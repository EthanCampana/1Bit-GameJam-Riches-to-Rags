extends Area2D

@onready var animation_player = $NewGameCollision/AnimationPlayer

var mouseOver = false

func _input(event):
	if event is InputEventMouseButton:
		if mouseOver == true:
			# CHANGE THIS SCENE TO THE CHARACTER SELECT SCENE
			animation_player.play("fadeIn")

# Mouse is hovering over the element
func _on_mouse_entered():
	mouseOver = true

# Mouse stopped hovering over the element
func _on_mouse_exited():
	mouseOver = false


func _on_animation_player_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")

