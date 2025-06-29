@tool
class_name CustomButton
extends Control

signal pressed

@export var text: String = "":
	set(new_text):
		text = new_text
		if Engine.is_editor_hint():
			_resize()

@onready var focus_texture: NinePatchRect = $FocusTexture
@onready var button: Button = $Button
@onready var button_frame: NinePatchRect = $Button/Frame
@onready var button_label: Label = $Button/Label


func _ready() -> void:
	if not Engine.is_editor_hint():
		focus_texture.set_visible(false)
		_resize()


func button_grab_focus() -> void:
	button.grab_focus()


func _resize() -> void:
	button_label.set_text(text)
	button_label.reset_size()
	button_frame.set_size(button_label.get_size() + Vector2(9, 8))
	focus_texture.set_size(button_frame.get_size() + Vector2(6, 6))
	button.set_size(button_frame.get_size())
	set_size(button.get_size())


func _on_button_focus_entered() -> void:
	focus_texture.set_visible(true)


func _on_button_focus_exited() -> void:
	focus_texture.set_visible(false)


func _on_button_mouse_entered() -> void:
	button.grab_focus.call_deferred()


func _on_button_pressed() -> void:
	pressed.emit()
