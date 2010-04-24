;
; make-3d-anaglyph
;
; File -> Create -> Misc -> Make 3D Anaglyph...
;
; (c) Cougar <cougar@random.ee> 2010 
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; Based on Steph Parker (steph.parker58@yahoo.com.au) script make-anaglyph
;
; Decription is taken from make-anaglyph script and slightly modified
;
; This program creates stereoscopic 3D anaglyph photos from a stereo pair.
; In order to make use of this program you will first need a pair of images
; from slightly different angles or the same object. This script loads
; both images as different layers in the same image window in Gimp with the
; right image as the Bottom layer and the left image as the next layer above
; it. The script finishes leaving the two images as seperate layers so that
; final alignment adjustments can be made before merging the layers down
; and saving the anaglyph.
;
; Any colours can be chosen for the two layers but it is recommended that 
; you only choose colours with individual RGB values of 0 or 255 and that
; the two colours compliment each other. The default colours, and the most
; commoly used colour combination, are Red (255 0 0) for the right image and
; cyan (0 255 255) for the left image. Other possible pairs are:
;       Red   (255 0 0) and Blue    (0 0 255)
;       Red   (255 0 0) and Green   (0 255 0)
;       Blue  (0 0 255) and Green   (0 255 0)
;       Blue  (0 0 255) and Yellow  (255 255 0)
;       Green (0 255 0) and Magenta (255 0 255)
; but be warned, not all colour pairs work equally well.

; To view the anaglyphs as 3D images you will need a pair of glasses in
; the colours that you have chosen with the colour of the left eye of 
; the glasses matching the colour applied to the right image (e.g.
; with the default red/cyan combination the red side of the glasses
; goes over the left eye and the cyan side on the right eye).

(define (make-3d-anaglyph img_r_f img_l_f inRightColour inLeftColour)
	(let*  
	(
		(theImage (car (gimp-image-new 1 1 RGB) ) )
		(theRightImageLayer (car (gimp-file-load-layer RUN-INTERACTIVE theImage img_r_f)))
		(theLeftImageLayer (car (gimp-file-load-layer RUN-INTERACTIVE theImage img_l_f)))
	)

	(gimp-context-push)
	
	(gimp-image-undo-disable theImage)

	(gimp-image-add-layer theImage theRightImageLayer 0)
	(gimp-drawable-set-name theRightImageLayer (string-append "Right Image: " (car (reverse (strbreakup img_r_f "/")))))

	(gimp-image-add-layer theImage theLeftImageLayer -1)
	(gimp-drawable-set-name theLeftImageLayer (string-append "Left Image: " (car (reverse (strbreakup img_l_f "/")))))

	(gimp-image-resize-to-layers theImage)

	(gimp-context-set-foreground inLeftColour)
	(gimp-context-set-background inRightColour)
    
	(gimp-selection-all theImage)
	(gimp-edit-bucket-fill theLeftImageLayer FG-BUCKET-FILL SCREEN-MODE 100 0 FALSE 0 0)
	(gimp-edit-bucket-fill theRightImageLayer BG-BUCKET-FILL SCREEN-MODE 100 0 FALSE 0 0)
	(gimp-layer-set-mode theLeftImageLayer MULTIPLY-MODE)

	(gimp-display-new theImage)
	(gimp-displays-flush)

	(gimp-image-undo-enable theImage)

	(gimp-context-pop)
	)
)

(script-fu-register "make-3d-anaglyph"
	_"Make 3D _Anaglyph..."
	"Loads two images and converts them images to a two-colour Anaglyph."
	"Cougar"
	"Copyright 2010, Cougar <cougar@random.ee>"
	"25/4/2010"
	""
	SF-FILENAME	_"Right Image"			"right.jpg"
	SF-FILENAME	_"Left Image"			"left.jpg"
	SF-COLOR	"Right Image Color (Red):"	'(255 0 0)
	SF-COLOR	"Left Image Color (Cyan):"	'(0 255 255)
)

(script-fu-menu-register "make-3d-anaglyph"  _"<Toolbox>/Xtns/Misc")
