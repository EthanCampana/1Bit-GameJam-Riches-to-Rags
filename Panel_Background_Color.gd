extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	var panel = $Panel_Background  # Adjust the path to your Panel node
	var style = StyleBoxFlat.new()

	style.bg_color = Color(1, 0, 0)  # Red color; replace with your desired color
	# Optionally set other properties like border width, border color, etc.

	panel.add_stylebox_override("panel", style)

