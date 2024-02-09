import argparse
import cv2
import numpy as np
from roifile import ImagejRoi, roiwrite
from skimage import io

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
	Assumes 2 and returns 2 positional command line arguments:
	mask_path = Path to the segmentation mask
	output_roi_file = Path to output the roi zip file
	"""
	parser = argparse.ArgumentParser(description = "Generates a zip file with FiJi ROIs from a segmentation mask.")
	parser.add_argument("mask_path", help = "path to the segmentation mask")
	parser.add_argument("output_roi_file", help = "path to the output zip file with the ROIs")
	args = parser.parse_args()
	return args.mask_path, args.output_roi_file

if __name__ == "__main__":
	mask_path, output_roi_file = get_arguments()
	print("Loading Mask")
	mask = io.imread(mask_path)

	print("Trimming Mask")
	trim(mask)

	print("Identifying ROIs.")
	cell_number = np.amax(mask, axis = None) + 1

	cells = []
	for cell_id in range(1, cell_number):
		cell = cv2.findContours((mask == cell_id).astype(np.uint8),
			cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
		cell = np.concatenate(cell[0][0]).tolist()
		cells.append(cell)

	print("Saving ROIs.")
	rois = list(map(ImagejRoi.frompoints, cells))
	roi_ids = list(map(str, range(0, len(rois))))
	roiwrite(output_roi_file, rois, name = roi_ids, mode = "w")
