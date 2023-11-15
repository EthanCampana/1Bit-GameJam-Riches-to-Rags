extends Node2D

func _ready():
	var animated_bg = AnimatedSprite2D.new()
	add_child(animated_bg)
	animated_bg.position = Vector2(0, 0)  # Adjust based on your scene

	var frames = SpriteFrames.new()
	var animation_name = "background_animation"
	
	# Add each frame to the animation
	frames.add_animation(animation_name)
	var image_paths = ["CARTA_2-1.png", "CARTA_2-2.png", "CARTA_2-3.png"]  # Add all your frame paths here
	for path in image_paths:
		var texture = load(path)
		print("its doing it")
		frames.add_frame(animation_name, texture)

	animated_bg.frames = frames
	animated_bg.play(animation_name)
