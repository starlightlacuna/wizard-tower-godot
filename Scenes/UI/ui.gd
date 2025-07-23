class_name UI
extends Control

signal lose_no_button_pressed
signal lose_yes_button_pressed
signal pause_menu_back_button_pressed
signal pause_menu_quit_button_pressed
signal pause_game_pressed
signal win_no_button_pressed
signal win_yes_button_pressed

@export var tower_health_icon_scene: PackedScene

var tower_health_icons: Array[TowerHealthIcon]

@onready var tower_health_bar: Control = $TowerHealthBar
@onready var lose_window: Control = $LoseWindow
@onready var pause_window: SettingsMenu = $PauseWindow
@onready var win_window: Control = $WinWindow


func _ready() -> void:
	assert(tower_health_icon_scene, "[UI] Tower Health Icon not set!")
	lose_window.visible = false
	win_window.visible = false


func _shortcut_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		if pause_window.visible:
			hide_pause_menu()
			pause_menu_back_button_pressed.emit()
		else:
			show_pause_window()
			pause_game_pressed.emit()
		return


func build_health_bar(max_health: int) -> void:
	for child in tower_health_bar.get_children():
		child.queue_free()

	for index in _get_icon_count(max_health):
		var new_icon: TowerHealthIcon = tower_health_icon_scene.instantiate()
		new_icon.position = Vector2(index * 40, 0)
		tower_health_bar.add_child(new_icon)
		tower_health_icons.append(new_icon)


func hide_pause_menu() -> void:
	pause_window.visible = false


func update_tower_health_bar(current_health: int, max_health) -> void:
	for index in _get_icon_count(max_health):
		if current_health > 1:
			tower_health_icons[index].update(TowerHealthIcon.Display.FULL)
			current_health -= 2
		elif current_health > 0:
			tower_health_icons[index].update(TowerHealthIcon.Display.HALF)
			current_health -= 1
		else:
			tower_health_icons[index].update(TowerHealthIcon.Display.NONE)


func show_lose_window() -> void:
	lose_window.visible = true


func show_pause_window() -> void:
	pause_window.visible = true
	pause_window.back_button_grab_focus_deferred()


func show_win_window() -> void:
	win_window.visible = true


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
