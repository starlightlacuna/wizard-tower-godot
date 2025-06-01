class_name Firebolt
extends CharacterBody2D

@export var damage: int = 1
@export var speed: float = 100

func _ready() -> void:
	set_velocity(Vector2(speed, 0))

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
