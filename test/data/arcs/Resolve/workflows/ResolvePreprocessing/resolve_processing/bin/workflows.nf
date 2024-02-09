nextflow.enable.dsl=2

script_folder = "$baseDir/bin"

include {collect_data} from "$script_folder/processes.nf"
include {fill_image_gaps} from "$script_folder/processes.nf"
include {deduplicate} from "$script_folder/processes.nf"
include {cellpose_segment} from "$script_folder/processes.nf"
include {mesmer_segment} from "$script_folder/processes.nf"
include {make_rois} from "$script_folder/processes.nf"
include {clean_cell_mask} from "$script_folder/processes.nf"
include {extract_sc_data} from "$script_folder/processes.nf"

workflow data_collection{
	take:
		input_path
    main:
        collect_data(input_path)
	emit:
		data_csv = collect_data.out.metadata_csv 		
}

workflow gap_filling{
    take:
		sample_name
		dapi_path
    main:
        fill_image_gaps(sample_name, dapi_path)
    emit:
        gap_filled_image = fill_image_gaps.out.filled_image
}

workflow deduplicating{
    take:
		sample_name
	    transcript_path
        tile_size_x
        tile_size_y
        window_size
        max_freq
        min_mode
    main:
        deduplicate(sample_name, transcript_path, tile_size_x, tile_size_y,
            window_size, max_freq, min_mode)
    emit:
        deduplicated_transcripts = deduplicate.out.filtered_transcripts
}

workflow cellpose_segmentation{
    take:
		sample_name
		model_name
		probability
		diameter
		dapi_path
	main:
        cellpose_segment(sample_name, model_name, probability,
			diameter, dapi_path)
        clean_cell_mask(sample_name, diameter, cellpose_segment.out.mask_image)
    emit:
        mask_images = clean_cell_mask.out.cleaned_cell_mask
}

workflow mesmer_segmentation{
    take:
		sample_name
		dapi_path
		maxima_threshold          
		maxima_smooth            
		interior_threshold      
		interior_smooth        
		small_objects_threshold   
		fill_holes_threshold  
		radius                    
	main:
        mesmer_segment(sample_name, dapi_path, maxima_threshold,
			maxima_smooth, interior_threshold, interior_smooth,
			small_objects_threshold, fill_holes_threshold, radius)
        clean_cell_mask(sample_name, mesmer_segment.out.mask_image)
    emit:
        mask_images = clean_cell_mask.out.cleaned_cell_mask
}

workflow roi_making{
    take:
		sample_name
		mask_path
    main:
        make_rois(sample_name, mask_path)
    emit:
        zipped_rois = make_rois.out.roi_zip
}


workflow sc_data_extraction{
    take:
       sample_name
	   mask_image
	   counts
    main:
        extract_sc_data(sample_name, mask_image, counts)
    emit:
         sc_data = extract_sc_data.out.sc_data
}

