class_name Enemy
extends Area2D
## Base class for enemies.
##
## This class only provides common functionality for all enemies and should not be instantiated
## directly. Extend this class to create new enemy types with custom behavior.

## The speed at which the enemy moves, in pixels per second.
@export var speed: float = 16

## The lane where the enemy starts.
@export_range(0, 5) var lane: int = 0

## The enemy's maximum health. The enemy's [member HealthComponent.health] and
## [member HealthComponent.max_health] are both initialized to this value.
@export var max_health: int = 1

var _start_position: Vector2 = Vector2.ZERO

@onready var _health_component: HealthComponent = $HealthComponent
@onready var _health_bar: Sprite2D = $HealthBar

func _ready() -> void:
	assert($Sprite2D.get_texture(), "[" + get_name() + "] Sprite texture not set!")
	assert($CollisionShape2D.get_shape(), "[" + get_name() + "] Collision shape not set!")
	
	_health_component.set_max_health(max_health)
	_update_health_bar(_health_component.health)
	_start_position = Grid.grid_to_world(Vector2i(15, 2 + lane))


## Emits the [signal Event.tower_damaged] and [signal Event.enemy_died] signals, then calls 
## [method Node.queue_free] on the enemy.
func damage_tower() -> void:
	Event.tower_damaged.emit(_health_component.get_health())
	Event.enemy_died.emit()
	queue_free()


func _on_health_component_damaged(health: int) -> void:
	_update_health_bar(health)
	if health <= 0:
		Event.enemy_died.emit()
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Firebolts"):
		var damager: DamagerComponent = body.get_node_or_null("DamagerComponent");
		if damager == null:
			return
		_health_component.damage(damager.damage)
		body.queue_free()


func _update_health_bar(value: int) -> void:
	_health_bar.set_frame(max(value - 1, 0))
