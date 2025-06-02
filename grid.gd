class_name Grid
extends Object

const START_ROW: int = 2
const END_COL: int = 2

static func world_to_grid(world_coordinates: Vector2i) -> Vector2i:
	#var grid_vector: Vector2 = Vector2i(world_coordinates.x / 16, world_coordinates.y / 16)
	var grid_vector: Vector2 = world_coordinates / 16
	return grid_vector

static func grid_to_world(grid_coordinates: Vector2i) -> Vector2i:
	return grid_coordinates * 16
