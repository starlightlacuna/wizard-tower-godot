class_name Game
extends Node2D
## The game scene.
##
## This scene handles all game logic, from start to win or lose.

## Emitted when a signal is received to restart the game. For example, see 
## [signal UI.win_yes_button_pressed].
signal restart_button_pressed

## Emitted when a signal is received to return to the start menu. For example, see 
## [signal UI.pause_menu_quit_button_pressed].
signal start_menu_button_pressed

## The tower's maximum health. When the game starts, the tower's health is set to this value.
@export var tower_max_health: int = 20

## The levels to play. This gets passed into [method LevelManager.process_levels].
@export var levels: Array[Level]

var _tower_health: int = tower_max_health

@onready var _background_music: AudioStreamPlayer = $BackgroundMusic
@onready var _level_manager: LevelManager = $LevelManager
@onready var _firebolts: Node2D = $Firebolts
@onready var _player: Player = $Player
@onready var _ui: UI = $UI


func _ready() -> void:
	assert(levels, "[Game] Levels is not set!")
	
	_player.set_position(Grid.grid_to_world(Vector2i(1, 2)))
	_player.firebolts_node = _firebolts
	_ui.build_health_bar(tower_max_health)
	_ui.player = _player
	_ui.set_visible(true)
	
	#_background_music.play()
	Event.tower_damaged.connect(_damage_tower)


func _damage_tower(damage: int) -> void:
	_tower_health -= damage
	_ui.update_tower_health_bar(_tower_health, tower_max_health)
	
	if _tower_health <= 0:
		# Disconnect the signal to prevent multiple invocations
		Event.tower_damaged.disconnect(_damage_tower)
		_lose_game.call_deferred()


func _lose_game() -> void:
	_background_music.stop()
	_ui.show_lose_window()
	get_tree().paused = true


func _on_enemy_manager_level_index_updated() -> void:
	_ui.current_level_value = min(_level_manager.level_index + 1, levels.size())
	_ui.total_level_value = levels.size()


func _on_enemy_manager_levels_completed() -> void:
	_ui.show_win_window()
	get_tree().paused = true


func _on_start_menu_button_pressed() -> void:
	start_menu_button_pressed.emit()
	get_tree().paused = false


func _on_restart_button_pressed() -> void:
	restart_button_pressed.emit()
	get_tree().paused = false


func _on_ui_pause_menu_back_button_pressed() -> void:
	get_tree().paused = false


func _on_ui_pause_game_pressed() -> void:
	get_tree().paused = true


func _on_ui_pause_menu_quit_button_pressed() -> void:
	start_menu_button_pressed.emit()


func _on_first_level_delay_timer_timeout() -> void:
	_ui.show_level_tracker()
	await _level_manager.process_levels(levels)
	_ui.show_win_window()
	get_tree().paused = true
