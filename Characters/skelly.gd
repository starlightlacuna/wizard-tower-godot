class_name Skelly
extends Area2D

@export var speed: float = 16
@export_range(0, 5) var lane: int = 0

var _start_position: Vector2 = Vector2.ZERO
var _end_position: Vector2 = Vector2.ZERO

@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: Sprite2D = $HealthBar

func _ready() -> void:
	_set_start_and_end_positions()
	set_position(_start_position)
	_set_health_bar(health_component.get_health())
	var tween_duration = abs((_end_position.x - _start_position.x) / speed)
	var tween: Tween = self.create_tween()
	tween.tween_property(self, "position", _end_position, tween_duration)
	tween.tween_callback(queue_free)
	
	# TODO: deal damage to tower

	
## Make sure to set the lane before adding this enemy to the game scene
func set_lane(value: int) -> void:
	lane = value

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Firebolts"):
		var damager: DamagerComponent = body.get_node_or_null("DamagerComponent");
		if damager == null:
			return
		health_component.damage(damager.damage)
		body.queue_free()

func _on_health_component_on_damaged(health: int) -> void:
	_set_health_bar(health)
	if health <= 0:
		queue_free()
		
func _set_health_bar(health: int) -> void:
	health_bar.set_frame(max(health - 1, 0))

func _set_start_and_end_positions() -> void:
	_start_position = Grid.grid_to_world(Vector2i(15, 2 + lane))
	_end_position = Grid.grid_to_world(Vector2i(2, 2 + lane))
