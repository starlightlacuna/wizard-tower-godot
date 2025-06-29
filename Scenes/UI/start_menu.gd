class_name StartMenu
extends Control

signal start_button_pressed
signal settings_button_pressed

@onready var start_button: CustomButton = $StartButton


func _ready() -> void:
	start_button.button_grab_focus.call_deferred()


func _on_start_button_pressed() -> void:
	start_button_pressed.emit()


func _on_settings_button_pressed() -> void:
	settings_button_pressed.emit()
