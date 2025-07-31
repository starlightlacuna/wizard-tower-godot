class_name Firebolt
extends CharacterBody2D
## A firebolt, the player's standard projectile attack.
##
## Scenes using this script must have a VisibleOnScreenNotifier2D node so that they can be freed
## when exiting the screen.

## The speed of this firebolt in pixels per second.
@export var speed: float = 100


func _ready() -> void:
	set_velocity(Vector2(speed, 0))
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)


func _physics_process(_delta: float) -> void:
	move_and_slide()
