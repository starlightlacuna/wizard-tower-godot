class_name Brute
extends Enemy

@export var tween_delay: float = 0.5

func _ready() -> void:
	super._ready()
	set_position(_start_position)
	_create_tween_chain(lane)

func _create_tween_chain(starting_lane: int) -> void:
	var tween: Tween = self.create_tween()
	var tween_duration: float = Grid.grid_to_world(Vector2i(0, 0)).distance_to(Grid.grid_to_world(Vector2i(0, 1))) / speed
	for column in range(14, 1, -1):
		tween.tween_interval(tween_delay)
		tween.tween_property(self, "position", Vector2(Grid.grid_to_world(Vector2i(column, 2 + starting_lane))), tween_duration)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_QUAD)
		
	tween.tween_callback(queue_free)
	
	# TODO: deal damage to tower
