class_name PowerUpFairy
extends Area2D

## Emitted when this fairy was consumed.
#signal consumed(fairy: PowerUpFairy)
signal consumed


func consume() -> void:
	consumed.emit()
