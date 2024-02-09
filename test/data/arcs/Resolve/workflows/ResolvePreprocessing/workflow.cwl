cwlVersion: v1.2

class: CommandLineTool

requirements:
  InitialWorkDirRequirement:
    listing: [$(inputs.script), $(inputs.nextflow_config), $(inputs.bin),$(inputs.input_folder)]

inputs:
  script:
    type: File
    inputBinding:
      position: 1
    default:
      class: File
      location: ../../workflows/ResolvePreprocessing/resolve_processing/main.nf 
  nextflow_config:
    type: File
    default:
      class: File
      location: ../../workflows/ResolvePreprocessing/resolve_processing/nextflow.config
  bin:
    type: Directory
    default:
      class: Directory
      location: ../../workflows/ResolvePreprocessing/resolve_processing/bin
  input_folder:
    type: Directory
  config_file:
    type: File
    inputBinding:
      position: 2
      prefix: -c
  profile:
    type: string
    inputBinding:
      position: 3
      prefix: -profile

outputs:
  filled_images:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*-gridfilled.tiff"
  masks:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*mask.tiff"
  filtered_transcripts:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*-filtered_transcripts.txt"
  cell_data:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*-cell_data.csv"

hints:
  SoftwareRequirement:
    packages:
      nextflow:
        specs: [ "https://identifiers.org/rrid/RRID:SCR_024135" ]
        version: [ "23.10.0" ]
      apptainer:
        specs: [ "https://github.com/apptainer/apptainer" ]
        version: [ "1.2.4" ]

baseCommand: nextflow
arguments: [run] 

