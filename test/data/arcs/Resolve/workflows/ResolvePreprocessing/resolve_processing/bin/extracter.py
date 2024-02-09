import argparse
import numpy as np
import pandas as pd
from skimage import measure, io
from PIL import Image
Image.MAX_IMAGE_PIXELS = 9999999999

def get_arguments():	
	"""
	Parses and checks command line arguments, and provides an help text.
	Assumes 3 and returns 3 positional command line arguments:
	mask_file = Path to the input mask file
	transcript_file = Path to the input transcript file
	output_file = Path to the output single cell data file
	"""
	parser = argparse.ArgumentParser(description = "Assigns transcripts to cells.")
	parser.add_argument("mask_file", help = "path to the input cell mask file")
	parser.add_argument("transcript_file", help = "path to the input transcript file")
	parser.add_argument("output_file", help = "path to the cell data output")
	args = parser.parse_args()
	return args.mask_file, args.transcript_file, args.output_file

def gene_counter(regionmask, intensity_image):
	"""	Adds all values in a boolean array """
	return np.sum(intensity_image[regionmask])

if __name__ == "__main__":
	mask_file_name, transcript_file_name, output_file = get_arguments()
		
	print("Processing Mask")
	mask = io.imread(mask_file_name, "tiff")
	w = mask.shape[1]
	h = mask.shape[0]

	print("Processing Transcripts")
	transcripts = pd.read_csv(transcript_file_name, sep = "\t", 
		header = None, usecols = [0,1,2,3], 
		names = ["x", "y", "z", "gene"])
		
	transcripts = transcripts.loc[(transcripts.x < w) & (transcripts.y < h)]
	transcripts = transcripts.groupby(["x", "y", "gene"]).size().reset_index(name="freq")

	genes = transcripts.gene
	geneset = sorted(list(set(genes))) # Sorted is not necessary
	print(geneset)

	print("Measuring cell area and position")

	measures = [pd.DataFrame(measure.regionprops_table(mask, None, ["area",
		"centroid", "label"]))]
	print("Counting transcripts in each cell")
	for gene in geneset:
		genemask = np.zeros(mask.shape, dtype = "int")
		points = transcripts.loc[transcripts.gene == gene][["x" , "y"]].to_numpy()
		counts = transcripts.loc[transcripts.gene == gene]["freq"]
		idx =  points[:, 0] + points[:, 1] * w # 1D index of each point
		np.put(genemask, idx, counts, mode = "raise") # Add transcript count at every point
		geneint = pd.DataFrame(measure.regionprops_table(mask,
			genemask, [], extra_properties = [gene_counter]))
		geneint.rename(columns={"gene_counter": gene}, inplace = True)
		measures.append(geneint)
		print(gene)

	cells = pd.concat(measures, axis = 1, ignore_index = False)
	cells.rename(columns = {"centroid-0":"centroid.y",
		"centroid-1":"centroid.x"}, inplace = True)
	print("Prepare and write csv output")
	cells.to_csv(output_file, header = True, index = True,
			index_label = "cell")

