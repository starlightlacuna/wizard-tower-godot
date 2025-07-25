class_name Game
extends Node2D

## Emitted when an InputEvent is received to restart the game
signal restart_button_pressed

## Emitted when an InputEvent is received to return to the start menu
signal start_menu_button_pressed

@export var tower_max_health: int = 20
var tower_health: int = tower_max_health

@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var firebolts: Node2D = $Firebolts
@onready var player: Player = $Player
@onready var ui: UI = $UICanvasLayer/UI


func _ready() -> void:
	player.set_position(Grid.grid_to_world(Vector2i(0, 2)))
	player.set_firebolts_node(firebolts)
	ui.build_health_bar(tower_max_health)
	ui.set_visible(true)
	
	#background_music.play()
	Event.tower_damaged.connect(_damage_tower)


func _damage_tower(damage: int) -> void:
	tower_health -= damage
	ui.update_tower_health_bar(tower_health, tower_max_health)
	
	if tower_health <= 0:
		background_music.stop()
		ui.show_lose_window()


func _on_enemy_manager_game_completed() -> void:
	ui.show_win_window()


func _on_start_menu_button_pressed() -> void:
	start_menu_button_pressed.emit()


func _on_restart_button_pressed() -> void:
	restart_button_pressed.emit()


func _on_ui_pause_menu_back_button_pressed() -> void:
	get_tree().paused = false


func _on_ui_pause_game_pressed() -> void:
	get_tree().paused = true


func _on_ui_pause_menu_quit_button_pressed() -> void:
	start_menu_button_pressed.emit()
