class_name Firebolt
extends CharacterBody2D
## A firebolt, the player's standard projectile attack.
##
## Scenes using this script must have a [VisibleOnScreenNotifier2D] node so that they can be freed
## when exiting the screen.[br][br]
## [i]Enhancement: Use an object pool to prevent creating and freeing firebolts.[/i]

## The speed of this firebolt in pixels per second.
@export var speed: float = 100


func _ready() -> void:
	var notifier: VisibleOnScreenNotifier2D = null
	for child in get_children():
		if child is VisibleOnScreenNotifier2D:
			notifier = child
			break
	assert(notifier, "[Firebolt] VisibleOnScreenNotifier2D doesn't exist!")
	notifier.screen_exited.connect(queue_free)
	velocity = Vector2(speed, 0)


func _physics_process(_delta: float) -> void:
	move_and_slide()
