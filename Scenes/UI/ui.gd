class_name UI
extends Control
## The UI scene for the game.
##
## This scene contains all the UI elements shown to the player during gameplay such as the tower
## health bar, the pause menu, and the win and lose screens. It does not contain any game logic, nor
## does it define any responses to input events. Instead, it emits signals that other classes can
## connect and respond to.

## Emitted when the No button in the lose window is pressed.
signal lose_no_button_pressed

## Emitted when the Yes button in the lose window is pressed.
signal lose_yes_button_pressed

## Emitted when the Back button in the pause menu is pressed.
signal pause_menu_back_button_pressed

## Emitted when the Quit button in the pause menu is pressed.
signal pause_menu_quit_button_pressed

## Emitted when the [code]pause_game[/code] input action is pressed.
signal pause_game_pressed

## Emitted when the No button in the win window is pressed.
signal win_no_button_pressed

## Emitted when the Yes button in the win window is pressed.
signal win_yes_button_pressed

@export var _tower_health_icon_scene: PackedScene

## The current level. This member is used for the level tracker.
var current_level_value: int:
	set(new_value):
		current_level_value = new_value
		_value_label.text = str(current_level_value)

## The [Player] instance. This must be assigned to show the power up bar.
var player: Player:
	set(new_value):
		player = new_value
		player.powered_up_changed.connect(func (powered_up):
			_power_up_bar_container.visible = powered_up
		)

## The total number of levels. This member is used for the level tracker.
var total_level_value: int:
	set(new_value):
		total_level_value = new_value
		_total_label.text = str(total_level_value)

var _tower_health_icons: Array[TowerHealthIcon]

@onready var _value_label: Label = $LevelTracker/ValueLabel
@onready var _slash_label: Label = $LevelTracker/SlashLabel
@onready var _total_label: Label = $LevelTracker/TotalLabel
@onready var _lose_window: Control = $LoseWindow
@onready var _pause_window: SettingsMenu = $PauseWindow
@onready var _win_window: Control = $WinWindow
@onready var _tower_health_bar: Control = $TowerHealthBar
@onready var _power_up_bar_container: CenterContainer = $PowerUpBarContainer
@onready var _power_up_bar: TextureProgressBar = $PowerUpBarContainer/PowerUpBar


func _ready() -> void:
	assert(_tower_health_icon_scene, "[UI] Tower Health Icon not set!")
	
	_lose_window.visible = false
	_win_window.visible = false
	_pause_window.visible = false
	_value_label.visible = false
	_slash_label.visible = false
	_total_label.visible = false
	_power_up_bar_container.visible = false


func _process(_delta: float) -> void:
	if player:
		_power_up_bar.value = remap(
			player.power_up_timer.time_left,
			0.0,
			player.power_up_duration,
			_power_up_bar.min_value,
			_power_up_bar.max_value
		)


func _shortcut_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		if _pause_window.visible:
			_hide_pause_menu()
			pause_menu_back_button_pressed.emit()
		else:
			_show_pause_menu()
			pause_game_pressed.emit()
		return


## Builds the tower's health bar. The health bar is composed of tower sprites, each representing 
## two hit points. [param max_health] is used to determine how many sprites are created initially.
func build_health_bar(max_health: int) -> void:
	for child in _tower_health_bar.get_children():
		child.queue_free()

	for index in _get_icon_count(max_health):
		var new_icon: TowerHealthIcon = _tower_health_icon_scene.instantiate()
		new_icon.position = Vector2(index * 12, 0)
		_tower_health_bar.add_child(new_icon)
		_tower_health_icons.append(new_icon)


## Updates the tower's health bar. The health bar's individual icons are updated to the approprite 
## sprites. See [method TowerHealthIcon.update].
func update_tower_health_bar(current_health: int, max_health: int) -> void:
	for index in _get_icon_count(max_health):
		if current_health > 1:
			_tower_health_icons[index].update(TowerHealthIcon.Display.FULL)
			current_health -= 2
		elif current_health > 0:
			_tower_health_icons[index].update(TowerHealthIcon.Display.HALF)
			current_health -= 1
		else:
			_tower_health_icons[index].update(TowerHealthIcon.Display.NONE)


## Sets the level tracker to be visible.
func show_level_tracker() -> void:
	_value_label.visible = true
	_slash_label.visible = true
	_total_label.visible = true


## Sets the lose window to be visible and makes its Back button grab focus.
func show_lose_window() -> void:
	_lose_window.visible = true
	_lose_window.get_node("YesButton").button_grab_focus.call_deferred()


## Sets the win window to visible and makes its Yes button grab focus.
func show_win_window() -> void:
	_win_window.visible = true
	_win_window.get_node("YesButton").button_grab_focus.call_deferred()


func _get_icon_count(max_health: int) -> int:
	@warning_ignore("integer_division")
	return max_health / 2 if max_health % 2 == 0 else max_health / 2 + 1


func _hide_pause_menu() -> void:
	_pause_window.visible = false


func _on_lose_no_button_pressed() -> void:
	lose_no_button_pressed.emit()


func _on_lose_yes_button_pressed() -> void:
	lose_yes_button_pressed.emit()


func _on_pause_window_back_button_pressed() -> void:
	_hide_pause_menu()
	pause_menu_back_button_pressed.emit()


func _on_pause_window_quit_button_pressed() -> void:
	pause_menu_quit_button_pressed.emit()


func _on_win_no_button_pressed() -> void:
	win_no_button_pressed.emit()


func _on_win_yes_button_pressed() -> void:
	win_yes_button_pressed.emit()


func _show_pause_menu() -> void:
	_pause_window.visible = true
	_pause_window.back_button_grab_focus_deferred()
