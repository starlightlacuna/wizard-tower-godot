class_name PowerUpFairy
extends Area2D
## A Power Up Fairy.
##
## When the [Player] enters this scene's area, [signal consumed] is emitted to be handled by
## [PowerUpManager].

## Emitted when this fairy was consumed.
signal consumed

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		consumed.emit()
