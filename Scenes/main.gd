extends Node

@export var game_scene: PackedScene
@export var start_menu_scene: PackedScene

enum SceneClass { GAME, START_MENU }

func _ready() -> void:
	assert(game_scene, "[Main] Game Scene not initialized!")
	assert(start_menu_scene, "[Main] Start Menu Scene not initialized!")
	
	_switch_to_scene(SceneClass.START_MENU)


func _free_children() -> void:
	if get_child_count() == 0:
		return
	
	for child in get_children():
		child.queue_free()


func _switch_to_scene(scene_class: SceneClass) -> void:
	_free_children()
	match scene_class:
		SceneClass.GAME:
			var game: Game = game_scene.instantiate()
			game.restart_button_pressed.connect(_on_game_restart_button_pressed)
			game.start_menu_button_pressed.connect(_on_game_start_menu_button_pressed)
			add_child(game)
		SceneClass.START_MENU:
			var start_menu: StartMenu = start_menu_scene.instantiate()
			start_menu.start_button_pressed.connect(_on_start_menu_start_button_pressed)
			add_child(start_menu)


func _on_game_restart_button_pressed() -> void:
	_switch_to_scene(SceneClass.GAME)


func _on_start_menu_start_button_pressed() -> void:
	_switch_to_scene(SceneClass.GAME)


func _on_game_start_menu_button_pressed() -> void:
	_switch_to_scene(SceneClass.START_MENU)
