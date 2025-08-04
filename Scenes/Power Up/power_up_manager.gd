class_name PowerUpManager
extends Node2D
## Handles power up spawning and consumption.
##
## This class uses an object pool, meaning it holds references to a finite number of [PowerUpFairy]
## instances that are created during the [method Node._ready] method. These instances are reused
## instead of creating and destroying instances.

@export var _power_up_fairy_scene: PackedScene
@export_range(0, 6) var _max_fairies: int = 6

## How long it takes in seconds for a newly spawned fairy to move to the left-most column.
@export var _move_tween_duration: float = 2.0

var _pool: Array[PowerUpFairy]


func _ready() -> void:
	assert(_power_up_fairy_scene, "[PowerUpManager] Power Up Fairy Scene not set!")
	_pool = []
	_pool.resize(_max_fairies)
	for i in range(_max_fairies):
		var fairy: PowerUpFairy = _power_up_fairy_scene.instantiate()
		fairy.consumed.connect(_on_fairy_consumed.bind(fairy))
		_pool[i] = fairy


## Gets the first available [PowerUpFairy] instance in the object pool and adds it to the scene.
## An instance is available if it is not a child of this scene.
func spawn_power_up() -> void:
	var available_index: int = -1
	for index in _pool.size():
		if not _pool[index].is_inside_tree():
			available_index = index
			break
	if available_index > -1:
		var fairy: PowerUpFairy = _pool[available_index]
		add_child(fairy)
		fairy.animation_player.play("RESET")
		fairy.position = Grid.grid_to_world(Vector2i(-1, Grid.START_ROW + available_index))
		var end_position: Vector2 = Grid.grid_to_world(Vector2i(0, Grid.START_ROW + available_index))
		var tween: Tween = fairy.create_tween()
		tween.tween_property(
			fairy,
			"position",
			end_position,
			_move_tween_duration
		)
		tween.tween_callback(fairy.animation_player.play.bind("Power Up Fairy/Hover"))


func _on_fairy_consumed(fairy: PowerUpFairy) -> void:
	remove_child.call_deferred(fairy)
