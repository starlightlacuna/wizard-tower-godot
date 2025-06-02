class_name Ghost
extends Enemy

@export var tween_delay: float = 1.2

func _ready() -> void:
	super._ready()
	set_position(_start_position)
	_create_tween_chain(lane)

func _create_tween_chain(starting_lane: int) -> void:
	var end_position: Vector2 = Grid.grid_to_world(Vector2i(2, _get_mirrored_lane(starting_lane)))
	
	var third_x_distance: float = (_start_position.x - end_position.x) / 3
	var starting_lane_y_position: float = Grid.grid_to_world(Vector2i(0, 2 + starting_lane)).y
	var mirrored_lane_y_position: float = Grid.grid_to_world(Vector2i(0, _get_mirrored_lane(starting_lane))).y
	var waypoints: Array[Vector2] = [
		Vector2(end_position.x + third_x_distance * 2, mirrored_lane_y_position),
		Vector2(end_position.x + third_x_distance, starting_lane_y_position)
	]
	var tween_duration = _start_position.distance_to(waypoints[0]) / speed
	var tween: Tween = self.create_tween()
	tween.tween_property(self, "position", waypoints[0], tween_duration)
	tween.tween_interval(tween_delay)
	tween.tween_property(self, "position", waypoints[1], tween_duration)
	tween.tween_interval(tween_delay)
	tween.tween_property(self, "position", end_position, tween_duration)
	tween.tween_callback(queue_free)

func _set_start_and_end_positions(starting_lane: int) -> void:
	_start_position = Grid.grid_to_world(Vector2i(15, 2 + starting_lane))
	
func _get_mirrored_lane(value: int) -> int:
	return 7 - value
