@tool
class_name CustomButton
extends Control

signal pressed

@export var text: String = "":
	set(new_text):
		text = new_text
		# Need to check that the node is ready, otherwise the label is null
		if is_node_ready():
			_resize()
@export_category("Focus")
@export var neighbor_left: NodePath
@export var neighbor_top: NodePath
@export var neighbor_right: NodePath
@export var neighbor_bottom: NodePath
@export var neighbor_next: NodePath
@export var neighbor_previous: NodePath

@onready var focus_texture: NinePatchRect = $FocusTexture
@onready var button: Button = $Button
@onready var button_frame: NinePatchRect = $Button/Frame
@onready var button_label: Label = $Button/Label


func _ready() -> void:
	_resize()
	if not Engine.is_editor_hint():
		focus_texture.set_visible(false)
		await get_tree().get_current_scene().ready
		_set_focus_neighbors()


func button_grab_focus() -> void:
	button.grab_focus()


func _get_button_path(node_path: NodePath) -> NodePath:
	#var node: Control = get_tree() \
			#.get_current_scene() \
			#.get_node_or_null(node_path)
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


func _resize() -> void:
	button_label.set_text(text)
	button_label.reset_size()
	button_frame.set_size(button_label.get_size() + Vector2(9, 8))
	focus_texture.set_size(button_frame.get_size() + Vector2(6, 6))
	button.set_size(button_frame.get_size())
	set_size(button.get_size())


func _set_focus_neighbor(side: Side, node_path: NodePath) -> void:
	button.set_focus_neighbor(side, _get_button_path(node_path))


func _set_focus_neighbors() -> void:
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
		button.set_focus_previous(_get_button_path(neighbor_next))
		
