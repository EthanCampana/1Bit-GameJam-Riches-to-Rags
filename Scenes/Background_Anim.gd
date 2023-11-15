extends TileMap

var width = 50
var height = 50
var ID = 0
# Called when the node enters the scene tree for the first time.
#func _ready():
#	set_background(Vector2i(20,20), ID)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_background(Vector2i(20,20), random_ID())

func set_background(position, ID):
	var tile_pos = local_to_map(position)
	for x in range(width):
		for y in range(height):
#			var moist = moisture.get_noise_2d(tile_pos.x + x, tile_pos.y + y)
#			var temp = temperature.get_noise_2d(tile_pos.x + x, tile_pos.y + y)
#			var alt = altitude.get_noise_2d(tile_pos.x + x, tile_pos.y + y)
			set_cell(0, Vector2i(tile_pos.x + x, tile_pos.y + y), ID, Vector2i(0,0))

func random_ID() -> int:
	return randi() % 7
