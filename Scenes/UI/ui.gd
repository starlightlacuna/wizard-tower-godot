class_name UI
extends Control

signal lose_no_button_pressed
signal lose_yes_button_pressed
signal pause_menu_back_button_pressed
signal pause_menu_quit_button_pressed
signal pause_game_pressed
signal win_no_button_pressed
signal win_yes_button_pressed

@export var _tower_health_icon_scene: PackedScene

## The current level.
@export var current_level_value: int = 20:
	set(new_value):
		current_level_value = new_value
		#_set_label_text()
		_value_label.text = str(current_level_value)

## The total number of levels.
@export var total_level_value: int = 20:
	set(new_value):
		total_level_value = new_value
		#_set_label_text()
		_total_label.text = str(total_level_value)

var _tower_health_icons: Array[TowerHealthIcon]

#@onready var _level_tracker: Control = $LevelTracker
@onready var _value_label: Label = $LevelTracker/ValueLabel
@onready var _slash_label: Label = $LevelTracker/SlashLabel
@onready var _total_label: Label = $LevelTracker/TotalLabel
@onready var _lose_window: Control = $LoseWindow
@onready var _pause_window: SettingsMenu = $PauseWindow
@onready var _win_window: Control = $WinWindow
@onready var _tower_health_bar: Control = $TowerHealthBar


func _ready() -> void:
	assert(_tower_health_icon_scene, "[UI] Tower Health Icon not set!")
	
	_lose_window.visible = false
	_win_window.visible = false
	#_level_tracker.visible = false
	_value_label.visible = false
	_slash_label.visible = false
	_total_label.visible = false


func _shortcut_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		if _pause_window.visible:
			hide_pause_menu()
			pause_menu_back_button_pressed.emit()
		else:
			show_pause_window()
			pause_game_pressed.emit()
		return


func build_health_bar(max_health: int) -> void:
	for child in _tower_health_bar.get_children():
		child.queue_free()

	for index in _get_icon_count(max_health):
		var new_icon: TowerHealthIcon = _tower_health_icon_scene.instantiate()
		new_icon.position = Vector2(index * 12, 0)
		_tower_health_bar.add_child(new_icon)
		_tower_health_icons.append(new_icon)


func hide_pause_menu() -> void:
	_pause_window.visible = false


func update_tower_health_bar(current_health: int, max_health) -> void:
	for index in _get_icon_count(max_health):
		if current_health > 1:
			_tower_health_icons[index].update(TowerHealthIcon.Display.FULL)
			current_health -= 2
		elif current_health > 0:
			_tower_health_icons[index].update(TowerHealthIcon.Display.HALF)
			current_health -= 1
		else:
			_tower_health_icons[index].update(TowerHealthIcon.Display.NONE)


func show_level_tracker() -> void:
	#_level_tracker.visible = true
	_value_label.visible = true
	_slash_label.visible = true
	_total_label.visible = true


## Sets the lose window to be visible and makes it 
func show_lose_window() -> void:
	_lose_window.visible = true
	_lose_window.get_node("YesButton").button_grab_focus.call_deferred()


## Sets the pause window to be visible and makes its Back button grab focus.
func show_pause_window() -> void:
	_pause_window.visible = true
	_pause_window.back_button_grab_focus_deferred()


## Sets the win window to visible and makes its Yes button grab focus.
func show_win_window() -> void:
	_win_window.visible = true
	_win_window.get_node("YesButton").button_grab_focus.call_deferred()


func _get_icon_count(max_health: int) -> int:
	@warning_ignore("integer_division")
	return max_health / 2 if max_health % 2 == 0 else max_health / 2 + 1


func _on_lose_no_button_pressed() -> void:
	lose_no_button_pressed.emit()


func _on_lose_yes_button_pressed() -> void:
	lose_yes_button_pressed.emit()


func _on_win_no_button_pressed() -> void:
	win_no_button_pressed.emit()


func _on_win_yes_button_pressed() -> void:
	win_yes_button_pressed.emit()


func _on_pause_window_back_button_pressed() -> void:
	hide_pause_menu()
	pause_menu_back_button_pressed.emit()


func _on_pause_window_quit_button_pressed() -> void:
	pause_menu_quit_button_pressed.emit()


#func _set_label_text() -> void:
	#_level_value_label.text = str(current_level_value)
	#_total_value_label.text = str(total_level_value)
