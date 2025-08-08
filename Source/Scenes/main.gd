extends Node

enum SceneClass {
	CREDITS,
	GAME,
	HOW_TO_PLAY,
	SETTINGS_MENU,
	START_MENU,
}

@export_category("Scenes")
@export var credits_scene: PackedScene
@export var game_scene: PackedScene
@export var how_to_play_scene: PackedScene
@export var settings_menu_scene: PackedScene
@export var start_menu_scene: PackedScene


func _ready() -> void:
	assert(credits_scene, "[Main] Credits Scene not set!")
	assert(how_to_play_scene, "[Main] How to Play Scene not set!")
	assert(game_scene, "[Main] Game Scene not set!")
	assert(settings_menu_scene, "[Main] Settings Menu Scene not set!")
	assert(start_menu_scene, "[Main] Start Menu Scene not set!")
	
	_switch_to_scene(SceneClass.START_MENU)


func _free_children() -> void:
	if get_child_count() == 0:
		return
	for child in get_children():
		child.queue_free()


func _switch_to_scene(scene_class: SceneClass) -> void:
	_free_children()
	match scene_class:
		SceneClass.CREDITS:
			var credits: Credits = credits_scene.instantiate()
			credits.back_button_pressed.connect(_switch_to_scene.bind(SceneClass.START_MENU))
			add_child(credits)
		SceneClass.GAME:
			var game: Game = game_scene.instantiate()
			game.restart_button_pressed.connect(_on_game_restart_button_pressed)
			game.start_menu_button_pressed.connect(_on_game_start_menu_button_pressed)
			add_child(game)
		SceneClass.HOW_TO_PLAY:
			var how_to_play: HowToPlay = how_to_play_scene.instantiate()
			how_to_play.back_button_pressed.connect(_on_how_to_play_back_button_pressed)
			add_child(how_to_play)
		SceneClass.SETTINGS_MENU:
			var settings_menu: SettingsMenu = settings_menu_scene.instantiate()
			settings_menu.back_button_pressed.connect(_on_settings_menu_back_button)
			add_child(settings_menu)
		SceneClass.START_MENU:
			var start_menu: StartMenu = start_menu_scene.instantiate()
			start_menu.credits_button_pressed.connect(_on_start_menu_credits_button_pressed)
			start_menu.how_to_play_button_pressed.connect(_on_start_menu_how_to_play_button_pressed)
			start_menu.settings_button_pressed.connect(_on_start_menu_settings_button_pressed)
			start_menu.start_button_pressed.connect(_on_start_menu_start_button_pressed)
			start_menu.quit_button_pressed.connect(_on_start_menu_quit_button_pressed)
			add_child(start_menu)


func _on_game_restart_button_pressed() -> void:
	_switch_to_scene(SceneClass.GAME)


func _on_game_start_menu_button_pressed() -> void:
	get_tree().paused = false
	_switch_to_scene(SceneClass.START_MENU)


func _on_how_to_play_back_button_pressed() -> void:
	_switch_to_scene(SceneClass.START_MENU)


func _on_start_menu_credits_button_pressed() -> void:
	_switch_to_scene(SceneClass.CREDITS)


func _on_start_menu_how_to_play_button_pressed() -> void:
	_switch_to_scene(SceneClass.HOW_TO_PLAY)


func _on_start_menu_quit_button_pressed() -> void:
	get_tree().quit()


func _on_start_menu_settings_button_pressed() -> void:
	_switch_to_scene(SceneClass.SETTINGS_MENU)


func _on_start_menu_start_button_pressed() -> void:
	_switch_to_scene(SceneClass.GAME)


func _on_settings_menu_back_button() -> void:
	_switch_to_scene(SceneClass.START_MENU)
