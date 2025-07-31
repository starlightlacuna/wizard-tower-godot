class_name Grid
extends Object
## Utilities for handling the game's grid system.

## The row corresponding to the top-most enemy lane.
const START_ROW: int = 2

## The column that corresponds to the final destination of enemies. Enemy movement tweens use this
## for their ending positions.
const END_COL: int = 2


## Converts world coordinates to grid coordinates.[br]
## [i]TODO: Deprecate in favor of [method TileMapLayer.local_to_map].[/i]
static func world_to_grid(world_coordinates: Vector2i) -> Vector2i:
	var grid_vector: Vector2 = world_coordinates / 16
	return grid_vector

## Converts grid coordinates to world coordinates.[br]
## [i]TODO: Deprecate in favor of [method TileMapLayer.map_to_local].[/i]
static func grid_to_world(grid_coordinates: Vector2i) -> Vector2i:
	return grid_coordinates * 16
