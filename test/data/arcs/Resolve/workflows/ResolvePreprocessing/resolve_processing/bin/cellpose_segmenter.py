import argparse
import numpy as np
import cv2
from cellpose import models, io, utils
from skimage import exposure, morphology, segmentation
from torch import no_grad

def claher(img):
	"""
	Runs Contrast Limited Adaptive Histogram Equalization (CLAHE)
	on the image and converts it to 8bit
	"""
	img = exposure.equalize_adapthist(img, kernel_size = 127, clip_limit = 0.01, nbins = 256)
	img = img / img.max() #normalizes img in range 0 - 255
	img = 255 * img
	img = img.astype(np.uint8)
	return img


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
	Assumes 4 and returns 4 positional command line arguments:
	tiff_path = Path to the tiff file
	model_name = Model to use for the segmentation
	prob_thresh = Probability threshold
	cell_diameter = Expected cell diameter
	output_mask_file = Path to output the cell mask
	--gpu = Flag to enable GPU use (optional, defaults to False)
	"""
	parser = argparse.ArgumentParser(description = "Performs 2D segmentation with cellpose.")
	parser.add_argument("tiff_path", help = "path to the image to segment")
	parser.add_argument("model_name", help = "model to use for the segmentation")			
	parser.add_argument("prob_thresh", help = "probability threshold")
	parser.add_argument("cell_diameter", help = "expected cell diameter")
	parser.add_argument("output_mask_file", help = "path to the cell mask output")
	parser.add_argument('--gpu', dest = "use_gpu", default = False, action='store_true', \
		help = "use the gpu? (default False)")
	args = parser.parse_args()
	return args.tiff_path, args.model_name, args.prob_thresh, args.cell_diameter, \
		args.output_mask_file, args.use_gpu

if __name__ == "__main__":
		tiff_path, model_name, prob_thresh, cell_diameter, \
			output_mask_file, use_gpu = get_arguments()

		# Define cellpose model
		print("Initializing  the model.")
		
		model = models.Cellpose(gpu = use_gpu, model_type = model_name)

		channels = [0, 0] # We assume the input is a single grayscale image

		try:
			cell_diameter = float(cell_diameter)
		except ValueError:
			cell_diameter = None

		# if diameter is set to None, the size of the cells is estimated on a per image basis
		# you can set the average cell `diameter` in pixels yourself (recommended) 
		# diameter can be a list or a single number for all images

		# Load the input image
		print("Loading the image.")
		img = io.imread(tiff_path)
		
		# Perform Local Contrast Enhancment on the input image
		img = claher(img)

		# Apply the model
		print("Segmenting cells.")
		mask, flows, style, diameter = model.eval(img, diameter = cell_diameter,
				channels = channels) # recover diameter if it was set to None earlier

		# save mask
		print("Saving mask.")
		io.imsave(output_mask_file, mask)
