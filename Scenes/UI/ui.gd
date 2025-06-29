class_name UI
extends Control

signal lose_no_button_pressed
signal lose_yes_button_pressed
signal win_no_button_pressed
signal win_yes_button_pressed

@export var tower_health_icon_scene: PackedScene
var tower_health_icons: Array[TowerHealthIcon]

@onready var tower_health_bar: Control = $TowerHealthBar
@onready var lose_window: Control = $LoseWindow
@onready var pause_window: Control = $PauseWindow
@onready var win_window: Control = $WinWindow


func _ready() -> void:
	assert(tower_health_icon_scene, "[UI] Tower Health Icon not set!")
	
	lose_window.set_visible(false)
	win_window.set_visible(false)


func build_health_bar(max_health: int) -> void:
	for child in tower_health_bar.get_children():
		child.queue_free()
	
	for index in _get_icon_count(max_health):
		var new_icon: TowerHealthIcon = tower_health_icon_scene.instantiate()
		new_icon.set_position(Vector2(index * 40, 0))
		tower_health_bar.add_child(new_icon)
		tower_health_icons.append(new_icon)


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
	lose_window.set_visible(true)


func show_pause_window() -> void:
	pause_window.set_visible(true)


func show_win_window() -> void:
	win_window.set_visible(true)


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
