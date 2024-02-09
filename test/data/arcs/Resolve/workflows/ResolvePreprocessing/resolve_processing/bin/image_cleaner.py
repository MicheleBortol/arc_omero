import argparse
import cv2
import numpy as np
from roifile import ImagejRoi, roiwrite
from skimage import io, morphology, segmentation

def trim(image):
	"""
	Sets to 0 all pixels at the edges in place.
	"""
	image[0:, 0]					= 0
	image[0:, image.shape[1] - 1]	= 0
	image[0, 0:]					= 0
	image[image.shape[0] - 1, 0:]	= 0

def get_arguments():	
	"""
	Parses and checks command line arguments, and provides an help text.
	Assumes 3 and returns 3 positional command line arguments:
	mask_path = Path to the segmentation mask
	output_mask_file = Path to the output cleaned mask for ROI extraction.
	"""
	parser = argparse.ArgumentParser(description = "Cleans up a segmentation mask to allow ROI extraction.")
	parser.add_argument("mask_path", help = "path to the segmentation mask")
	parser.add_argument("diameter", help = "cell diameter")
	parser.add_argument("output_mask_file", help = "path to the output cleaned mask for ROI extraction.")
	args = parser.parse_args()
	return args.mask_path, int(args.diameter), args.output_mask_file

if __name__ == "__main__":
	mask_path, diameter, output_mask_file = get_arguments()

	print("Loading Mask")
	mask = io.imread(mask_path)

	print("Trimming Mask")
	trim(mask)

	# Remove isolated pixels and too small cells
	print("Cleaning the segmentation mask.")
	cell_number = np.amax(mask, axis = None) + 1
	canvas = np.zeros_like(mask)
	for cell_id in range(1, cell_number):
		canvas[np.where(morphology.remove_small_objects(mask == cell_id, diameter / 2) != 0)] = cell_id
	mask, _, _ = segmentation.relabel_sequential(canvas, offset = 1)

	# save mask
	print("Saving mask.")
	io.imsave(output_mask_file, mask)
