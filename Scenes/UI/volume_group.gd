class_name VolumeGroup
extends Control

signal volume_down_pressed
signal volume_up_pressed

@onready var value_bar: TextureProgressBar = $ValueBar


func set_value(value: float) -> void:
	value_bar.set_value_no_signal(value)


func _on_down_button_pressed() -> void:
	volume_down_pressed.emit()


func _on_up_button_pressed() -> void:
	volume_up_pressed.emit()
