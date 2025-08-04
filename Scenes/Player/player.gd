class_name Player
extends Area2D
## Represents the player.
##
## This class represents the player character in the game world and handles all non-UI inputs. It 
## moves the player, spawns firebolts to attack, and keeps track of the power up state.

## Emitted when the value of [member powered_up] changes.
signal powered_up_changed(value)

## The cooldown between attacks in seconds.
@export var _attack_cooldown: float = 1.0

## How long the power up lasts in seconds.
@export var power_up_duration: float = 30.0

## How long the movement tween lasts in seconds. Lower values mean faster movement.
@export var _move_tween_duration: float = 0.1

@export_subgroup("Firebolt Scenes")
## The scene to instantiate when the player attacks.
@export var _firebolt_scene: PackedScene

## The scene to instantiate when the player attacks while powered up.
@export var _powered_up_firebolt_scene: PackedScene

## The node to add firebolts to. If this is not set, attacking will throw errors.
var firebolts_node: Node2D

## Flag for power ups. Changing its value will emit the [signal powered_up_changed] signal.
var powered_up: bool = false:
	set(new_value):
		powered_up = new_value
		powered_up_changed.emit(new_value)

var _can_fire: bool = true
var _movement_tween: Tween

## The [Timer] that determines the power up duration.
@onready var power_up_timer: Timer = $PowerUpTimer

@onready var _firebolt_spawn_position: Marker2D = $FireboltSpawnPosition
@onready var _attack_timer: Timer = $AttackTimer



func _ready() -> void:
	_attack_timer.set_wait_time(_attack_cooldown)


func _process(_delta: float) -> void:
	if Input.is_action_pressed("fire") and _can_fire:
		_shoot_firebolt()


func _unhandled_input(event: InputEvent) -> void:
	if _movement_tween:
		return
	
	if (event.is_action_pressed("move_down")):
		_move(Vector2i(0, 1))
	elif (event.is_action_pressed("move_left")):
		_move(Vector2i(-1, 0))
	elif (event.is_action_pressed("move_right")):
		_move(Vector2i(1, 0))
	elif (event.is_action_pressed("move_up")):
		_move(Vector2i(0, -1))


func _move(translation: Vector2i) -> void:
	var grid_position: Vector2i = Grid.world_to_grid(get_position())
	var new_grid_position: Vector2i = grid_position + translation;
	if (new_grid_position.x < 0 or new_grid_position.x > 1) or \
			(new_grid_position.y < 2 or new_grid_position.y > 7):
		return
	var new_world_position: Vector2 = Grid.grid_to_world(new_grid_position)
	
	_movement_tween = create_tween()
	_movement_tween.tween_property(
		self,
		"position",
		new_world_position,
		_move_tween_duration
	)
	_movement_tween.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	_movement_tween.tween_callback(func (): _movement_tween = null)


func _on_area_entered(area: Area2D) -> void:
	if area is PowerUpFairy and not powered_up:
		powered_up = true
		print("You're powered up. Get in there!")
		power_up_timer.start(power_up_duration)


func _on_attack_timer_timeout() -> void:
	_can_fire = true


func _on_power_up_timer_timeout() -> void:
	powered_up = false


func _shoot_firebolt() -> void:
	if not firebolts_node:
		push_error("[Player] firebolts_node not set!")
		return
	
	var firebolt: Firebolt
	if powered_up:
		firebolt = _powered_up_firebolt_scene.instantiate()
	else:
		firebolt = _firebolt_scene.instantiate()
	firebolt.set_global_position(_firebolt_spawn_position.get_global_position())
	firebolts_node.add_child(firebolt)
	_can_fire = false
	_attack_timer.start()
