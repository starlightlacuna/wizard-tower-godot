class_name CustomButton
extends Control

signal pressed

@onready var focus_texture: NinePatchRect = $FocusTexture
@onready var button: Button = $Button

func _ready() -> void:
	focus_texture.set_visible(false)


func button_grab_focus() -> void:
	button.grab_focus()


func _on_button_focus_entered() -> void:
	focus_texture.set_visible(true)


func _on_button_focus_exited() -> void:
	focus_texture.set_visible(false)


func _on_button_mouse_entered() -> void:
	button.grab_focus.call_deferred()


func _on_button_pressed() -> void:
	pressed.emit()
