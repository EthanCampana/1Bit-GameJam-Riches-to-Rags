extends Node2D


@export var cell_size = Vector2i(64, 64)

var astar_grid = AStarGrid2D.new()
var grid_size
var global_pos:Vector2i
var clicked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_grid()


func initialize_grid():
	grid_size = Vector2i(get_viewport_rect().size) / cell_size
	astar_grid.size = grid_size
	astar_grid.cell_size = cell_size
	astar_grid.offset = cell_size / 2
	astar_grid.update()
	return


func fill_walls():
	for x in grid_size.x:
		for y in grid_size.y:
			if astar_grid.is_point_solid(Vector2i(x, y)):
				draw_rect(Rect2(x * cell_size.x, y * cell_size.y, cell_size.x, cell_size.y), Color.DARK_GRAY)

func _draw():
	draw_grid()
	fill_walls()
	if clicked:
		draw_movement()




func draw_movement():
	var tiles = movementDFS(global_pos.x,global_pos.y)
	var i = 0
	for t in tiles:
		if i == 0:
			i+=1
			continue
		draw_rect(Rect2(t.x * cell_size.x, t.y * cell_size.y, cell_size.x, cell_size.y), Color.GREEN)
	clicked = false

 
func draw_grid():
	for x in grid_size.x + 1:
		draw_line(Vector2(x * cell_size.x, 0), Vector2(x * cell_size.x, grid_size.y * cell_size.y), Color(0.5, 0.5, 0.5, 0.5))
	for y in grid_size.y + 1:
		draw_line(Vector2(0, y * cell_size.y), Vector2(grid_size.x * cell_size.x, y * cell_size.y), Color(0.5, 0.5, 0.5, 0.5))

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var pos = Vector2i(event.position) / cell_size
			print(pos)
			global_pos = pos
			if astar_grid.is_in_boundsv(pos):
				astar_grid.set_point_solid(pos, not astar_grid.is_point_solid(pos))
		clicked = true
		queue_redraw()
		




func movementDFS(x,y:int):
	var speed = 3 
	var discovered = []
	var stack = []
	stack.append(Vector2i(x,y))

	while speed >= 0:
		var cur_band = stack
		stack = []
		while !cur_band.is_empty():
			var current = cur_band.pop_back()
			if current not in discovered:
				discovered.append(current)
			if speed > 0:
				if current.x + 1 <= 64:
					stack.append(Vector2i(current.x+1,current.y))
				if current.x -1 >= 0:
					stack.append(Vector2i(current.x-1,current.y))
				if current.y + 1 <= 64:
					stack.append(Vector2i(current.x,current.y+1))
				if current.y - 1 >= 0:
					stack.append(Vector2i(current.x,current.y-1))
		speed -= 1	
	return discovered


