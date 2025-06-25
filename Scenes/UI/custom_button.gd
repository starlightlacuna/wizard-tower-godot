class_name CustomButton
extends Control

@export var text: String = "Test"

@onready var focus_texture: NinePatchRect = $FocusTexture
@onready var button: Button = $Button

func _ready() -> void:
	button.set_text(text)
	var button_size: Vector2 = button.get_size()
	focus_texture.set_size(Vector2(button_size.x + 7.0, button_size.y + 8.0))
	focus_texture.set_visible(false)


func _on_focus_entered() -> void:
	focus_texture.set_visible(true)


func _on_focus_exited() -> void:
	focus_texture.set_visible(false)
