class_name HealthComponent
extends Node

@export var health: int = 1
@export var max_health: int = 1

signal on_damaged(health: int)
#signal on_zero_health

func _ready() -> void:
	health = max_health

func get_health() -> int:
	return health

func set_max_health(value: int) -> void:
	max_health = value

func damage(value: int) -> void:
	health -= value
	on_damaged.emit(health)
	#if health <= 0:
		#on_zero_health.emit()
