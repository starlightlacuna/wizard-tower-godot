@tool
class_name CustomButton
extends Control

signal pressed

@export var text: String = "":
	set(new_text):
		text = new_text
@export var icon: Texture2D:
	set(new_texture):
		icon = new_texture
			
@export_category("Focus")
@export var neighbor_left: NodePath
@export var neighbor_top: NodePath
@export var neighbor_right: NodePath
@export var neighbor_bottom: NodePath
@export var neighbor_next: NodePath
@export var neighbor_previous: NodePath

var top_left_corner: Vector2 = Vector2i(5, 5)

@onready var focus_texture: NinePatchRect = $FocusTexture
@onready var button: Button = $Button
@onready var button_frame: NinePatchRect = $Button/Frame
@onready var button_label: Label = $Button/Label
@onready var button_icon: TextureRect = $Button/Icon


func _ready() -> void:
	if not Engine.is_editor_hint():
		focus_texture.set_visible(false)
		await get_tree().get_current_scene().ready
		set_focus_neighbors()


func _process(_delta: float) -> void:
	_resize()


func button_grab_focus() -> void:
	button.grab_focus()


func _get_button_path(node_path: NodePath) -> NodePath:
	var node: Control = get_node_or_null(node_path)
	if node is CustomButton:
		return node.button.get_path()
	else:
		return node_path


func _on_button_focus_entered() -> void:
	focus_texture.set_visible(true)


func _on_button_focus_exited() -> void:
	focus_texture.set_visible(false)


func _on_button_mouse_entered() -> void:
	button.grab_focus.call_deferred()


func _on_button_pressed() -> void:
	pressed.emit()


func _resize() -> Vector2:
	var minimum_size: Vector2 = Vector2.ZERO
	if not text.is_empty():
		button_label.set_text(text)
		button_label.reset_size()
		minimum_size = button_label.get_size()
	if icon != null:
		# Adding 1 extra pixel to account for horizontal spacing
		button_icon.set_texture(icon)
		minimum_size.x = max(minimum_size.x, icon.get_width() + 1)
		minimum_size.y = max(minimum_size.y, icon.get_height() + 2)
	button_frame.set_size(minimum_size + Vector2(9, 8))
	focus_texture.set_size(button_frame.get_size() + Vector2(6, 6))
	button.set_size(button_frame.get_size())
	set_size(button.get_size())
	return minimum_size


func _set_focus_neighbor(side: Side, node_path: NodePath) -> void:
	button.set_focus_neighbor(side, _get_button_path(node_path))


func _set_icon() -> void:
	button_icon.set_texture(icon)


func set_focus_neighbors() -> void:
	if not neighbor_left.is_empty():
		_set_focus_neighbor(SIDE_LEFT, neighbor_left)
	if not neighbor_top.is_empty():
		_set_focus_neighbor(SIDE_TOP, neighbor_top)
	if not neighbor_right.is_empty():
		_set_focus_neighbor(SIDE_RIGHT, neighbor_right)
	if not neighbor_bottom.is_empty():
		_set_focus_neighbor(SIDE_BOTTOM, neighbor_bottom)
	if not neighbor_next.is_empty():
		button.set_focus_next(_get_button_path(neighbor_next))
	if not neighbor_previous.is_empty():
		button.set_focus_previous(_get_button_path(neighbor_previous))
