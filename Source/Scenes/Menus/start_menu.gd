class_name StartMenu
extends Control

signal credits_button_pressed
signal how_to_play_button_pressed
signal settings_button_pressed
signal start_button_pressed
signal quit_button_pressed

@export var music: AudioStream = null

@onready var _start_button: CustomButton = $MenuFrame/StartButton


func _ready() -> void:
	_start_button.button_grab_focus.call_deferred()
	if music:
		BackgroundMusic.play(music, 4.0)


func _on_credits_button_pressed() -> void:
	credits_button_pressed.emit()


func _on_how_to_play_button_pressed() -> void:
	how_to_play_button_pressed.emit()


func _on_quit_button_pressed() -> void:
	quit_button_pressed.emit()


func _on_settings_button_pressed() -> void:
	settings_button_pressed.emit()


func _on_start_button_pressed() -> void:
	start_button_pressed.emit()
