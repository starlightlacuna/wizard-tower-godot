extends Node2D

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
	
	background_music.play()
	
	Event.tower_damaged.connect(_damage_tower)
	Event.restart_button_pressed.connect(_on_restart_button_pressed)


func _damage_tower(damage: int) -> void:
	tower_health -= damage
	ui.update_tower_health_bar(tower_health, tower_max_health)
	
	if tower_health <= 0:
		background_music.stop()
		ui.show_lose_screen()


func _on_enemy_manager_game_completed() -> void:
	ui.show_win_screen()


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
