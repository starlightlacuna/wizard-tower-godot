class_name Player
extends Area2D

signal powered_up_changed(value)

@export var firebolt_scene: PackedScene
@export var powered_up_firebolt_scene: PackedScene
@export var attack_cooldown: float = 1.0
@export var powered_up: bool = false:
	set(new_value):
		powered_up = new_value
		powered_up_changed.emit(new_value)
@export var power_up_duration: float = 30.0

var firebolts_node: Node2D
var can_fire: bool = true

@onready var firebolt_spawn_position: Marker2D = $FireboltSpawnPosition
@onready var attack_timer: Timer = $AttackTimer
@onready var power_up_timer: Timer = $PowerUpTimer


func set_firebolts_node(node: Node2D) -> void:
	firebolts_node = node


func _ready() -> void:
	attack_timer.set_wait_time(attack_cooldown)


func _process(_delta: float) -> void:
	if Input.is_action_pressed("fire") and can_fire:
		_shoot_firebolt()


func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("move_down")):
		_move(Vector2i(0, 1))
	elif (event.is_action_pressed("move_left")):
		_move(Vector2i(-1, 0))
	elif (event.is_action_pressed("move_right")):
		_move(Vector2i(1, 0))
	elif (event.is_action_pressed("move_up")):
		_move(Vector2i(0, -1))


func _on_attack_timer_timeout() -> void:
	can_fire = true


func _move(translation: Vector2i) -> void:
	var grid_position: Vector2i = Grid.world_to_grid(get_position())
	var new_grid_position: Vector2i = grid_position + translation;
	if (new_grid_position.x < 0 or new_grid_position.x > 1) or \
			(new_grid_position.y < 2 or new_grid_position.y > 7):
		return
	set_position(Grid.grid_to_world(new_grid_position))
	
	# TODO: Tween movement to make it look nice!


func _shoot_firebolt() -> void:
	var firebolt: Firebolt
	if powered_up:
		firebolt = powered_up_firebolt_scene.instantiate()
	else:
		firebolt = firebolt_scene.instantiate()
	firebolt.set_global_position(firebolt_spawn_position.get_global_position())
	firebolts_node.add_child(firebolt)
	can_fire = false
	attack_timer.start()


func _on_area_entered(area: Area2D) -> void:
	if area is PowerUpFairy and not powered_up:
		powered_up = true
		print("You're powered up. Get in there!")
		power_up_timer.start(power_up_duration)
		#(area as PowerUpFairy).consume()


func _on_power_up_timer_timeout() -> void:
	powered_up = false
