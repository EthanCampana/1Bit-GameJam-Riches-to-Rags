extends Area2D

var mouseOver = false

func _input(event):
	if event is InputEventMouseButton:
		if mouseOver == true:
			# CHANGE THIS SCENE TO THE CHARACTER SELECT SCENE
			anim.play("fadeIn")
			get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")

# Mouse is hovering over the element
func _on_mouse_entered():
	mouseOver = true

# Mouse stopped hovering over the element
func _on_mouse_exited():
	mouseOver = false
