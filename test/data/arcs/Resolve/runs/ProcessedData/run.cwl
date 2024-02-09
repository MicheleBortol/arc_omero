cwlVersion: v1.2
class: Workflow

inputs:
  dataset_folder: Directory 
  nextflow_config_file: File
  run_profile: string

steps:
  resolve_processing:
    run: ../../workflows/ResolvePreprocessing/workflow.cwl
    in: 
      input_folder: dataset_folder 
      config_file: nextflow_config_file 
      profile: run_profile
    out: [filled_images, masks, filtered_transcripts, cell_data]

outputs:
    gridfilled_images:
        type:
            type: array
            items: File
        outputSource: resolve_processing/filled_images  
    segmentation_masks:
        type:
            type: array
            items: File
        outputSource: resolve_processing/masks
    deduplicated_transcripts:
        type:
            type: array
            items: File
        outputSource: resolve_processing/filtered_transcripts
    cell_expression_matrix:
        type:
            type: array
            items: File
        outputSource: resolve_processing/cell_data
