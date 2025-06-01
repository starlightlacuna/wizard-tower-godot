class_name Ghost
extends Area2D

@export var speed: float = 16
@export_range(0, 5) var lane: int = 0
@export var tween_delay: float = 1.2

var _start_position: Vector2 = Vector2.ZERO
var _end_position: Vector2 = Vector2.ZERO

@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: Sprite2D = $HealthBar

func _ready() -> void:
	_set_health_bar(health_component.health)
	_create_tween_chain(lane)

func _create_tween_chain(starting_lane: int) -> void:
	_set_start_and_end_positions(starting_lane)
	set_position(_start_position)
	
	var third_x_distance: float = (_start_position.x - _end_position.x) / 3
	var starting_lane_y_position: float = Grid.grid_to_world(Vector2i(0, 2 + starting_lane)).y
	var mirrored_lane_y_position: float = Grid.grid_to_world(Vector2i(0, _get_mirrored_lane(starting_lane))).y
	var waypoints: Array[Vector2] = [
		Vector2(_end_position.x + third_x_distance * 2, mirrored_lane_y_position),
		Vector2(_end_position.x + third_x_distance, starting_lane_y_position)
	]
	var tween_duration = _start_position.distance_to(waypoints[0]) / speed
	var tween: Tween = self.create_tween()
	tween.tween_property(self, "position", waypoints[0], tween_duration)
	tween.tween_interval(tween_delay)
	tween.tween_property(self, "position", waypoints[1], tween_duration)
	tween.tween_interval(tween_delay)
	tween.tween_property(self, "position", _end_position, tween_duration)
	tween.tween_callback(queue_free)
	
	# TODO: deal damage to tower

func _set_start_and_end_positions(starting_lane: int) -> void:
	_start_position = Grid.grid_to_world(Vector2i(15, 2 + starting_lane))
	_end_position = Grid.grid_to_world(Vector2i(2, _get_mirrored_lane(starting_lane)))
	
func _get_mirrored_lane(value: int) -> int:
	return 7 - value

func _set_health_bar(value: int) -> void:
	health_bar.set_frame(max(value - 1, 0))

func _on_health_component_on_damaged(health: int) -> void:
	_set_health_bar(health)
	if health <= 0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Firebolts"):
		var damager: DamagerComponent = body.get_node_or_null("DamagerComponent");
		if damager == null:
			return
		health_component.damage(damager.damage)
		body.queue_free()
