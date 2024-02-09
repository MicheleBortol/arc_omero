nextflow.enable.dsl=2

script_folder = "$baseDir/bin"

include {data_collection} from "$script_folder/workflows.nf"
include {gap_filling} from "$script_folder/workflows.nf"
include {deduplicating} from "$script_folder/workflows.nf"
include {cellpose_segmentation} from "$script_folder/workflows.nf"
include {mesmer_segmentation} from "$script_folder/workflows.nf"
include {roi_making} from "$script_folder/workflows.nf"
include {sc_data_extraction} from "$script_folder/workflows.nf"

Closure compare_file_names = {a, b -> a.name <=> b.name}

workflow {

	// Data Collection
	data_collection(file(params.input_path))
    sample_metadata = data_collection.out.data_csv
		.splitCsv(header : true)
		.multiMap { row -> 
			sample: row.sample
			dapi: row.dapi
			counts: row.counts}

	samples = sample_metadata.sample.toSortedList().flatten().view()
	dapi = sample_metadata.dapi.toSortedList().flatten().view()
	counts = sample_metadata.counts.toSortedList().flatten().view()

	// Gap Filling with MindaGap
    if (params.fill_gaps == true){
	    gap_filling(samples, dapi)
	    images = gap_filling.out.gap_filled_image
		    .toSortedList(compare_file_names).flatten().view()
    } else {
        images = dapi
    }

    // Deduplicate transcripts with MindaGap
	if (params.deduplicate == true){
        deduplicating(samples, counts, params.tile_size_x, params.tile_size_y, \
            params.window_size, params.max_freq, params.min_mode) 
	    transcripts = deduplicating.out.deduplicated_transcripts
		    .toSortedList(compare_file_names).flatten().view()
    } else {
        transcripts = counts
    }

	// Cell Segmentation
	if(params.segmentation_tool == "cellpose"){
		segmentation = cellpose_segmentation(samples, \
			params.model_name, params.probability_threshold, \
			params.cell_diameter, images)
	}else if (params.segmentation_tool == "mesmer") {
		segmentation = mesmer_segmentation(samples, images, \
			params.maxima_threshold, params.maxima_smooth, params.interior_threshold, \
			params.interior_smooth, params.small_objects_threshold, \
			params.fill_holes_threshold, params.radius)
	} else {
		return
	}	
	cell_masks = segmentation.mask_images
		.toSortedList(compare_file_names).flatten().view()
    
    // ROI Making
	if(params.do_zip){
		roi_making(samples, cell_masks)
		roi_zips = roi_making.out.zipped_rois
			.toSortedList(compare_file_names).flatten().view()
	}    

    // Single Cell Data Extraction
	sc_data_extraction(samples, cell_masks, transcripts)
    single_cell_data = sc_data_extraction.out.sc_data
                .toSortedList(compare_file_names).flatten().view()
}
