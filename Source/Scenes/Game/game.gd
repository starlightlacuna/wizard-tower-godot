class_name Game
extends Node2D
## The game scene.
##
## This class handles all the  game logic, from start to win or lose. 

## Emitted when a signal is received to restart the game. For example, see 
## [signal UI.win_yes_button_pressed].
signal restart_button_pressed
## Emitted when a signal is received to return to the start menu. For example, 
## see [signal UI.pause_menu_quit_button_pressed].
signal start_menu_button_pressed

## The cell to place the player at the start of the game. This value is clamped 
## to between (0, 2) and (1, 7) in the [method Node._ready] method.
@export var player_start_position := Vector2i(0, 2)
## The tower's maximum health.
@export var tower_max_health: int = 20

@export_subgroup("Music")
## Music to play while the game is ongoing.
@export var _background_music: AudioStream
## Music for when the player loses the game.
@export var _lose_music: AudioStream
## Music for when the player wins the game.
@export var _win_music: AudioStream

var _tower_health: int = tower_max_health

@onready var _level_manager: LevelManager = $LevelManager
@onready var _firebolts: Node2D = $Firebolts
@onready var _player: Player = $Player
@onready var _ui: UI = $UI
@onready var _tower_damaged: AudioStreamPlayer = $TowerDamaged


func _ready() -> void:
	assert(_background_music, "[Game] Background Music is not set!")
	assert(_lose_music, "[Game] Lose Music is not set!")
	assert(_win_music, "[Game] Win Music is not set!")
	
	_player.position = Grid.grid_to_world(Vector2i(
			clampi(player_start_position.x, 0, 1),
			clampi(player_start_position.y, 2, 7)
	))
	_player.firebolts_node = _firebolts
	_ui.build_health_bar(tower_max_health)
	_ui.visible = true
	
	Event.tower_damaged.connect(_damage_tower)
	
	BackgroundMusic.play(_background_music)


func _damage_tower(damage: int) -> void:
	_tower_health -= damage
	_ui.update_tower_health_bar(_tower_health, tower_max_health)
	_tower_damaged.play()
	
	if _tower_health <= 0:
		# Disconnect the signal to prevent multiple invocations
		Event.tower_damaged.disconnect(_damage_tower)
		_lose_game.call_deferred()


func _lose_game() -> void:
	_ui.show_lose_window()
	BackgroundMusic.play(_lose_music)
	get_tree().paused = true


func _on_first_level_delay_timer_timeout() -> void:
	_ui.show_level_tracker()
	await _level_manager.process_levels()
	_ui.show_win_window()
	BackgroundMusic.play(_win_music)
	get_tree().paused = true


func _on_level_manager_level_index_updated(
		current_level: int,
		total_levels: int
) -> void:
	_ui.current_level_value = min(current_level + 1, total_levels)
	_ui.total_level_value = total_levels


func _on_restart_button_pressed() -> void:
	restart_button_pressed.emit()
	get_tree().paused = false


func _on_start_menu_button_pressed() -> void:
	start_menu_button_pressed.emit()
	get_tree().paused = false


func _on_ui_pause_menu_back_button_pressed() -> void:
	get_tree().paused = false


func _on_ui_pause_game_pressed() -> void:
	get_tree().paused = true


func _on_ui_pause_menu_quit_button_pressed() -> void:
	start_menu_button_pressed.emit()
