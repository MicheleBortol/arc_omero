from typing import Tuple
from pathlib import Path
import pandas as pd
from ome_types import OME, model
from omero.gateway import BlitzGateway
from generate_xml import populate_xml_folder


def prepare_arc(folder: str, filelist: bool, conn: BlitzGateway,
                                session: str) -> Tuple[OME, dict]:

    # Generate paths
    isa_investigation_path = str(Path(folder).parent.parent.parent.resolve() / "isa.investigation.xlsx")
    assay_path = str(Path(folder).parent.resolve()) 
    isa_assay_path = assay_path + "/isa.assay.xlsx"
    if filelist:
        filepath = str(Path(folder).parent.resolve() / "transfer.xml")
    else:
        filepath = str(Path(folder) / "transfer.xml")

    # Generate the transfer.xml file with the regular prepare function
    ome, path_id_dict = populate_xml_folder(folder, filelist, conn, session)

    # Read the isa investigation file and use "" for empty values
    investigation = pd.read_excel(isa_investigation_path, header=None, dtype = str)
    investigation = investigation.fillna("")
    investigation = dict(zip(investigation[0], investigation[1]))

    # Create project and dataset and link the dataset to the project
    ome.projects.append(
        model.Project(name = investigation["Study Identifier"],
            description = investigation["Study Description"]))
    ome.datasets.append(
        model.Dataset(name = assay_path.split("/")[-3]))
    ome.projects[0].dataset_refs.append(
        model.DatasetRef(id=ome.datasets[0].id))
    ome.projects[0].annotation_refs = []

    # Annotate the project with Key-Value pairs divided in namespaces
    owner_details = model.MapAnnotation(
        namespace = "ARC:ISA:INVESTIGATION:INVESTIGATION CONTACTS",
        value = {"ms" : [{"k" : "Investigation Person First Name",
            "value" : investigation["Investigation Person First Name"]},
            {"k" : "Investigation Person Last Name",
                "value" : investigation["Investigation Person Last Name"]},
            {"k" : "Investigation Person Email",
                "value" : investigation["Investigation Person Email"]},
            {"k" : "Investigation Person Address",
                "value" : investigation["Investigation Person Address"]},
            {"k" : "Investigation Person Affiliation",
                "value" : investigation["Investigation Person Affiliation"]}]})
    ome.structured_annotations.append(owner_details)
    ome.projects[0].annotation_refs.append(
        model.AnnotationRef(id=owner_details.id))

    protocol_details = model.MapAnnotation(
        namespace = "ARC:ISA:STUDY:STUDY PROTOCOLS",
        value = {"ms" : [{"k" : "Study Protocol Name",
            "value" : investigation["Study Protocol Name"]},
            {"k" : "Study Protocol Type",
                "value" : investigation["Study Protocol Type"]},
            {"k" : "Study Protocol Description",
                "value" : investigation["Study Protocol Description"]},
            {"k" : "Study Protocol Components Name",
                "value" : investigation["Study Protocol Components Name"]},
            {"k" : "Study Protocol Components Type",
                "value" : investigation["Study Protocol Components Type"]}]})
    ome.structured_annotations.append(protocol_details)
    ome.projects[0].annotation_refs.append(
        model.AnnotationRef(id=protocol_details.id))

    publication_details = model.MapAnnotation(
        namespace = "ARC:ISA:INVESTIGATION:INVESTIGATION PUBLICATIONS",
        value = {"ms" : [{"k" : "Investigation Publication DOI",
            "value" : investigation["Investigation Publication DOI"]},
            {"k" : "Investigation Publication PubMed ID",
                "value" : investigation["Investigation Publication PubMed ID"]},
            {"k" : "Investigation Publication Author List",
                "value" : investigation["Investigation Publication Author List"]},
            {"k" : "Investigation Publication Title",
                "value" : investigation["Investigation Publication Title"]},
            {"k" : "Investigation Publication Status",
                "value" : investigation["Investigation Publication Status"]}]})
    ome.structured_annotations.append(publication_details)
    ome.projects[0].annotation_refs.append(
        model.AnnotationRef(id=publication_details.id))

    # Read isa.assay.xlsx, and set empy values to "".
    # Here we need to process multiple excel column for the values
    assay = pd.read_excel(isa_assay_path, header=None, sheet_name="Assay", dtype = str)
    assay = assay.fillna("")
    assay_cols = []
    for i in assay.columns[1:]:
        assay_cols.append(dict(zip(assay[0], assay[i])))

    # Annotate the dataset with Key-Value pairs divided in namespaces
    for assay_col in assay_cols:
        assay_performer_details = model.MapAnnotation(
            namespace = "ARC:ISA:ASSAY:ASSAY PERFORMER",
            value = {"ms" : [{"k" : "Last Name",
                "value" : assay_col["Last Name"]},
                {"k" : "First Name",
                    "value" : assay_col["First Name"]},
                {"k" : "Email",
                    "value" : assay_col["Email"]},
                {"k" : "Address",
                    "value" : assay_col["Address"]},
                {"k" : "Roles",
                    "value" : assay_col["Roles"]},
                {"k" : "Affiliation",
                    "value" : assay_col["Affiliation"]}]})
        ome.structured_annotations.append(assay_performer_details)
        ome.datasets[0].annotation_refs.append(
            model.AnnotationRef(id=assay_performer_details.id))

        assay_metadata_details = model.MapAnnotation(
            namespace = "ARC:ISA:ASSAY:ASSAY METADATA",
            value = {"ms" : [{"k" : "Assay Identifier",
                "value" : assay_cols[0]["Assay Identifier"]},
                {"k" : "Measurement Type",
                    "value" : assay_cols[0]["Measurement Type"]},
                {"k" : "Measurement Type Term Accession Number",
                    "value" : assay_cols[0]["Measurement Type Term Accession Number"]},
                {"k" : "Technology Type",
                    "value" : assay_cols[0]["Technology Type"]},
                {"k" : "Technology Platform",
                    "value" : assay_cols[0]["Technology Platform"]}]})
        ome.structured_annotations.append(assay_metadata_details)
        ome.datasets[0].annotation_refs.append(
            model.AnnotationRef(id=assay_metadata_details.id))

    # Link every image in the transfer.xml to the dataset
    for image in ome.images:
        ome.datasets[0].image_refs.append(model.ImageRef(id=image.id))

    # Convert ome object back to xml and replace the original transfer file
    xml = ome.to_xml()
    with open(filepath, 'w') as xml_file:
        xml_file.write(xml)
    return ome, path_id_dict
                                                                                                                                                                                                                   
