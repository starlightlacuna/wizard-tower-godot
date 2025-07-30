@tool
class_name CustomButton
extends Control
## A button that has a special focus frame.
##
## This node implements some of the functionality of the built-in [Button] node 
## such as focus neighbors and custom text/icon. It uses a child button to
## handle input events; the button text and icon are separate nodes that are
## updated automatically when their corresponding member variables are updated.
## [br][br]
## This can have both text and an icon, however, unlike [Button], the text
## will be covered by the icon instead of shifting to accomodate the icon. See
## [member Button.icon_alignment].

## Emitted when the inner [Button] emits the [signal Button.pressed] signal
signal pressed

## The text to display. If this and are set, the button is resized
## to the combined minimum size of both. Text is rendered behind the icon.
@export var text: String = "":
	set(new_text):
		text = new_text
		if Engine.is_editor_hint():
			if not is_node_ready():
				await ready
			_button_label.text = text
			_resize()

## The icon to display. If this and [member text] are set, the button is resized
## to the combined minimum size of both. Text is rendered behind the icon.
@export var icon: Texture2D = null:
	set(new_texture):
		icon = new_texture
		if Engine.is_editor_hint():
			if not is_node_ready():
				await ready
			_button_icon.texture = icon
			_resize()

## The button's minimum width. The button's frames will take the maximum value
## between this and the width calculated from [member icon] and [member text].
@export var minimum_width: float = 0.0:
	set(new_minimum_width):
		minimum_width = new_minimum_width
		if Engine.is_editor_hint():
			if not is_node_ready():
				await ready
			_resize()


#region Focus
@export_subgroup("Focus")
## Which node to give focus to when the [member ProjectSettings.input/ui_left]
## input action is pressed. See [member Control.focus_neighbor_left].
@export var neighbor_left: NodePath = NodePath("")

## Which node to give focus to when the [member ProjectSettings.input/ui_top]
## input action is pressed. See [member Control.focus_neighbor_top].
@export var neighbor_top: NodePath = NodePath("")

## Which node to give focus to when the [member ProjectSettings.input/ui_right]
## input action is pressed. See [member Control.focus_neighbor_right].
@export var neighbor_right: NodePath = NodePath("")

## Which node to give focus to when the [member ProjectSettings.input/ui_bottom]
## input action is pressed. See [member Control.focus_neighbor_bottom].
@export var neighbor_bottom: NodePath = NodePath("")

## Which node to give focus to when the [member ProjectSettings.input/ui_focus_next]
## input action is pressed. See [member Control.focus_next].
@export var neighbor_next: NodePath = NodePath("")

## Which node to give focus to when the [member ProjectSettings.Input/ui_focus_previous]
## input action is pressed. See [member Control.focus_previous].
@export var neighbor_previous: NodePath = NodePath("")
#endregion

## The [Button] node that handles events and focus for the CustomButton.
@onready var button: Button = $Button
@onready var _focus_texture: NinePatchRect = $FocusTexture
@onready var _button_frame: NinePatchRect = $Button/Frame
@onready var _button_label: Label = $Button/Label
@onready var _button_icon: TextureRect = $Button/Icon


func _ready() -> void:
	if not Engine.is_editor_hint():
		_focus_texture.set_visible(false)
		# This is a code smell, but it works. Ideally we shouldn't wait here for
		# ancestors to be ready; we should move this behavior upwards in the
		# scene tree.
		await owner.ready
		_button_label.text = text
		_button_icon.texture = icon
		_resize()
		set_focus_neighbors()


## Calls the [member button]'s [method Control.grab_focus] method.
func button_grab_focus() -> void:
	button.grab_focus()


## Sets the focus neighbors for the inner [Button]. This method should be called
## when all the necessary nodes are ready.
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
		button.set_focus_next(await _get_button_path(neighbor_next))
	if not neighbor_previous.is_empty():
		button.set_focus_previous(await _get_button_path(neighbor_previous))


func _get_button_path(node_path: NodePath) -> NodePath:
	if !owner.is_node_ready():
		await owner.ready
	var node: Control = get_node_or_null(node_path)
	if node is CustomButton:
		return node.button.get_path()
	else:
		return node_path


func _on_button_focus_entered() -> void:
	_focus_texture.set_visible(true)


func _on_button_focus_exited() -> void:
	_focus_texture.set_visible(false)


func _on_button_mouse_entered() -> void:
	button.grab_focus.call_deferred()


func _on_button_pressed() -> void:
	pressed.emit()


func _resize() -> Vector2:
	var minimum_size: Vector2 = Vector2.ZERO
	if not text.is_empty():
		_button_label.reset_size()
		minimum_size = _button_label.get_size()
	if icon != null:
		# Adding 1 extra pixel to account for horizontal spacing
		minimum_size.x = max(minimum_size.x, icon.get_width() + 1)
		minimum_size.y = max(minimum_size.y, icon.get_height() + 2)
	_button_frame.set_size(Vector2(
		max(minimum_size.x + 9, minimum_width),
		minimum_size.y + 8
	))
	_button_label.size = Vector2(
		max(_button_frame.size.x - 9, _button_label.size.x),
		_button_label.size.y
	)
	_focus_texture.set_size(_button_frame.get_size() + Vector2(6, 6))
	button.set_size(_button_frame.get_size())
	set_size(button.get_size())
	return minimum_size


func _set_focus_neighbor(side: Side, node_path: NodePath) -> void:
	button.set_focus_neighbor(side, await _get_button_path(node_path))
