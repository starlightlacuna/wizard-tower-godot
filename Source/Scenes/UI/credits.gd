class_name Credits
extends Control

signal back_button_pressed

@onready var _back_button: CustomButton = $BackButton

func _ready() -> void:
	_back_button.button_grab_focus.call_deferred()


func _on_back_button_pressed() -> void:
	back_button_pressed.emit()
