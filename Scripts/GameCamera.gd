extends Camera2D
class_name GameCamera
# Target node that the camera will follow
@export var target_node : Node2D = null

# Camera follow speed (adjust as needed)
var follow_speed : float = 800.0

func _process(delta):
	if target_node:
		# Calculate the new camera position based on the target node's position
		var target_position = target_node.global_position
		var new_position = position.move_toward(target_position, follow_speed * delta)
		
		# Set the camera position to the new calculated position
		position = new_position


func zoomCameraOut():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"zoom",Vector2(0.5,0.5),1).set_trans(tween.TRANS_SINE)
	await tween.finished

func zoomCameraIn():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"zoom",Vector2(1,1),1).set_trans(tween.TRANS_SINE)
	await tween.finished
