import argparse
import numpy as np
import cv2
import tensorflow as tf
from skimage import exposure, morphology, segmentation, io
from deepcell.applications import Mesmer

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
	image[0:, image.shape[1] - 1]   = 0
	image[0, 0:]					= 0
	image[image.shape[0] - 1, 0:]   = 0

def get_arguments():
	"""
	Parses and checks command line arguments, and provides an help text.
	Assumes 2 and returns 2 positional command line arguments:
	tiff_path				   = Path to the tiff file
	output_mask_file			= Path to output the cell mask
	--maxima_threshold		  = Decrease for over segmentation. Default(0.075)
	--maxima_smooth			 = Smoothing radius for maxima. Default(0)
	--interior_threshold		= Decrease to identify more cells. Default(0.2)
	--interior_smooth		   = Smoothing radius for cell detection. Default(2)
	--small_objects_threshold   = Minimum object size. Default(15)
	--fill_holes_threshold	  = Max Size for hole filling. Default(15)
	--radius					= Undocuented in Mesmer. Default(2)
	"""
	parser = argparse.ArgumentParser(description = "Performs 2D segmentation with MESMER.")
	parser.add_argument("tiff_path", help = "path to the image to segment")
	parser.add_argument("output_mask_file", help = "path to the cell mask output")
	parser.add_argument('--maxima_threshold', dest = "maxima_threshold", default = 0.075,
			help = "Decrease for over segmentation. Default(0.075)")
	parser.add_argument('--maxima_smooth', dest = "maxima_smooth", default = 0,
			help = "Smoothing radius for maxima. Default(0)")
	parser.add_argument('--interior_threshold', dest = "interior_threshold", default = 0.2,
			help = "Decrease to identify more cells. Default(0.2)")
	parser.add_argument('--interior_smooth', dest = "interior_smooth", default = 2,
			help = "Smoothing radius for cell detection. Default(2)")
	parser.add_argument('--small_objects_threshold', dest = "small_objects_threshold", default = 15,
			help = "Minimum object size. Default(15)")
	parser.add_argument('--fill_holes_threshold', dest = "fill_holes_threshold", default = 15,
			help = "Max size for hole filling. Default(15)")
	parser.add_argument('--radius', dest = "radius", default = 2,
			help = "Undocumented in Mesmer. Default(2)")
	args = parser.parse_args()
	return args.tiff_path, args.output_mask_file, float(args.maxima_threshold), int(args.maxima_smooth), \
			float(args.interior_threshold), int(args.interior_smooth), int(args.small_objects_threshold), \
			int(args.fill_holes_threshold), int(args.radius)

if __name__ == "__main__":
	tiff_path, output_mask_file, maxima_threshold, maxima_smooth, interior_threshold, interior_smooth, \
	small_objects_threshold, fill_holes_threshold, radius = get_arguments()

	# Load the input image
	print("Loading the image.")
	img = io.imread(tiff_path)

	# Perform Local Contrast Enhancment on the input image
	print("Running CLAHE the image.")
	img = claher(img)

	# Reshape the image to: 4D [batch, x, y, channel]
	# We use a 0 channel as membrane channel
	print("Reshape the image.")
	img = np.stack([img, np.zeros_like(img)], axis = -1)
	img = np.expand_dims(img, 0)

	# Define the model
	print("Initializing  the model.")
	model = tf.keras.models.load_model('/keras_models/MultiplexSegmentation')
	app = Mesmer(model)

	# Apply the model
	print("Segmenting cells.")
	postprocess_args={
		"maxima_threshold": maxima_threshold,
		"maxima_smooth": maxima_smooth,
		"interior_threshold": interior_threshold,
		"interior_smooth": interior_smooth,
		"small_objects_threshold": small_objects_threshold,
		"fill_holes_threshold": fill_holes_threshold,
		"radius": radius}
	mask = app.predict(img, image_mpp = 0.138,
		postprocess_kwargs_whole_cell = postprocess_args) # 0.138 um per pixel for resolve
	mask = mask[0,:,:,0]

	# Remove isolated pixels and too small cells
	print("Cleaning the segmentation mask.")
	trim(mask)
	cell_number = np.amax(mask, axis = None) + 1
	canvas = np.zeros_like(mask)
	for cell_id in range(1, cell_number):
		canvas[np.where(morphology.remove_small_objects(mask == cell_id, 10) != 0)] = cell_id
	mask, _, _ = segmentation.relabel_sequential(canvas, offset = 1)

	# save mask
	print("Saving mask.")
	io.imsave(output_mask_file, mask)
