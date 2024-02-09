script_folder = "$baseDir/bin"

process collect_data{

    memory { 1.GB }
    time '1h'
    
    publishDir "$params.output_path", mode:'copy', overwrite: true

    input:
		path(input_path)
	
    output:
        path("sample_metadata.csv", emit: metadata_csv)
    
    script:
    """
	echo "sample,dapi,counts" > sample_metadata.csv
	while IFS= read -d \$'\\0' -r DAPI
	do
		SAMPLE="\${DAPI##$launchDir/$input_path/}"
		SAMPLE="\${SAMPLE%%_Channel3_R8.tif}"
		COUNTS="$launchDir/$input_path/""\$SAMPLE""_results_withFP.txt"
		echo "\$SAMPLE,\$DAPI,\$COUNTS" >> sample_metadata.csv 
	done < <(find "$launchDir/$input_path/" -name "*_Channel3_R8.tif" -print0)
    """
}

process fill_image_gaps{

    memory { 8.GB * task.attempt }
    time '1h'

    errorStrategy { task.exitStatus in 137..143 ? 'retry' : 'terminate' }
    maxRetries 3

    publishDir "$params.output_path/$sample_name", mode:'copy', overwrite: true
    container = "library://michelebortol/resolve_tools/toolbox:gpu"

    input:
		val(sample_name)
		path(dapi_path)
	
    output:
        path("$sample_name-gridfilled.tiff", emit: filled_image)

    script:
    """
	python3.10 -u /MindaGap/mindagap.py $dapi_path 3 > gapfilling_log.txt
	mv *gridfilled.tif* $sample_name-gridfilled.tiff 2>&1

    """
}

process deduplicate{

    memory { 8.GB * task.attempt }
    time '12h'

    errorStrategy { task.exitStatus in 137..143 ? 'retry' : 'terminate' }
    maxRetries 3

    publishDir "$params.output_path/$sample_name", mode:'copy', overwrite: true
    container = "library://michelebortol/resolve_tools/toolbox:gpu"

    input:
		val(sample_name)
		path(transcript_path)
        val(tile_size_x)
        val(tile_size_y)
        val(window_size)
        val(max_freq)
        val(min_mode)
	
    output:
        path("$sample_name-filtered_transcripts.txt", emit: filtered_transcripts)

    script:
    """
	python3.10 -u /MindaGap/duplicate_finder.py $transcript_path $tile_size_x $tile_size_y \
    $window_size $max_freq $min_mode > deduplication_log.txt
	mv *_markedDups.txt $sample_name-filtered_transcripts.txt 2>&1

    """
}

process cellpose_segment{
   
    label "gpu_user"

    publishDir "$params.output_path/$sample_name", mode:'copy', overwrite: true
    container = "library://michelebortol/resolve_tools/toolbox:gpu"

    input:
		val(sample_name)
		val(model_name)
		val(probability)
		val(diameter)
		path(dapi_path)
	
    output:
        path("$sample_name-cellpose_mask.tiff", emit: mask_image)

    script:
	def use_gpu = workflow.profile.contains("gpu") ? "--gpu" : ""
    """
    echo $use_gpu
    nvidia-smi
	python3.10 -u $script_folder/cellpose_segmenter.py $dapi_path $model_name $probability \
		$diameter $sample_name-cellpose_mask.tiff $use_gpu > \
        $sample_name-segmentation_log.txt 2>&1
    """
}

process mesmer_segment{
    
    label "gpu_user"
    
    container = "library://michelebortol/resolve_tools/toolbox:gpu"

    input:
		val(sample_name)
		path(dapi_path)
		val(maxima_threshold)          
		val(maxima_smooth)            
		val(interior_threshold)      
		val(interior_smooth)        
		val(small_objects_threshold)   
		val(fill_holes_threshold)  
		val(radius)                    
	
    output:
        path("$sample_name-mesmer_mask.tiff", emit: mask_image)

    script:
    """
	python3.8 -u $script_folder/mesmer_segmenter.py $dapi_path \
        $sample_name-mesmer_mask.tiff --maxima_threshold $maxima_threshold\
		--maxima_smooth $maxima_smooth --interior_threshold $interior_threshold \
		--interior_smooth $interior_smooth --small_objects_threshold $small_objects_threshold \
		--fill_holes_threshold $fill_holes_threshold --radius $radius \
		> $sample_name-segmentation_log.txt 2>&1
    """
}

process clean_cell_mask{

    memory { 8.GB * task.attempt }
    time '12h'

    errorStrategy { task.exitStatus in 137..143 ? 'retry' : 'terminate' }
    maxRetries 3

    publishDir "$params.output_path/$sample_name", mode:'copy', overwrite: true
    container = "library://michelebortol/resolve_tools/toolbox:gpu"

    input:
		val(sample_name)
		val(diameter)
		path(segmaentation_mask_path)
	
    output:
        path("$sample_name-cleaned_cell_mask.tiff", emit: cleaned_cell_mask)

    script:
    """
	python3.10 -u $script_folder/image_cleaner.py $segmaentation_mask_path $diameter $sample_name-cleaned_cell_mask.tiff > mask_cleaning_log.txt 2>&1

    """
}


process make_rois{
    
    memory { 8.GB * task.attempt }
    time '72h'
    
    errorStrategy { task.exitStatus in 137..143 ? 'retry' : 'terminate' }
    maxRetries 4

    publishDir "$params.output_path/$sample_name", mode:'copy', overwrite: true
    container = "library://michelebortol/resolve_tools/toolbox:gpu"

    input:
		val(sample_name)
		path(mask_path)
	
    output:
        path("$sample_name-roi.zip", emit: roi_zip)
    
	script:
    
	"""
	python3.10 -u $script_folder/roi_maker.py $mask_path \
		$sample_name-roi.zip > $sample_name-roi-log.txt 2>&1
    """
}

process extract_sc_data{

    memory { 8.GB * task.attempt }
    time '72h'

    publishDir "$params.output_path/$sample_name", mode:'copy', overwrite: true
    container = "library://michelebortol/resolve_tools/toolbox:gpu"

    input:
        val(sample_name)
		path(mask_image_path)
		path(transcript_coord_path)

    output:
        path("$sample_name-cell_data.csv", emit: sc_data)

    script:

    """
	python3.10 $script_folder/extracter.py $mask_image_path $transcript_coord_path \
		${sample_name}-cell_data.csv > $sample_name-extraction_log.txt 2>&1
    """
}

