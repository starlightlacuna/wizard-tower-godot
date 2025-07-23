class_name SettingsMenu
extends Control

signal back_button_pressed
signal quit_button_pressed

const Bus = Settings.Bus

@export var is_pause_menu: bool = false
@export var main_menu_back_button_position: Vector2 = Vector2(59.0, 102.0)
@export var main_menu_test_button_position: Vector2 = Vector2(111.0, 102.0)
@export var pause_menu_back_button_position: Vector2 = Vector2(59.0, 102.0)
@export var pause_menu_test_button_position: Vector2 = Vector2(111.0, 102.0)

@onready var master_volume_group: VolumeGroup = $PanelBackground/MasterVolumeGroup
@onready var music_volume_group: VolumeGroup = $PanelBackground/MusicVolumeGroup
@onready var sfx_volume_group: VolumeGroup = $PanelBackground/SFXVolumeGroup
@onready var sfx_volume_up_button: CustomButton = $PanelBackground/SFXVolumeGroup/UpButton
@onready var back_button: CustomButton = $PanelBackground/BackButton
@onready var test_button: CustomButton = $PanelBackground/TestButton
@onready var quit_button: CustomButton = $PanelBackground/QuitButton


func _ready() -> void:
	Settings.volume_changed.connect(_on_settings_volume_changed)
	back_button_grab_focus_deferred()
	
	if is_pause_menu:
		back_button.set_position(pause_menu_back_button_position)
		test_button.set_position(pause_menu_test_button_position)
		quit_button.set_visible(true)
		var quit_button_path: NodePath = quit_button.get_path()
		back_button.neighbor_left = quit_button_path
		back_button.neighbor_previous = quit_button_path
		back_button.set_focus_neighbors()
		sfx_volume_up_button.focus_next = quit_button_path
		sfx_volume_up_button.set_focus_neighbors()
		
	else:
		back_button.set_position(main_menu_back_button_position)
		test_button.set_position(main_menu_test_button_position)
		quit_button.set_visible(false)


func back_button_grab_focus_deferred() -> void:
	back_button.button_grab_focus.call_deferred()


func _on_back_button_pressed() -> void:
	back_button_pressed.emit()


func _on_master_volume_group_volume_down_pressed() -> void:
	Settings.set_volume(Bus.MASTER, Settings.get_volume(Bus.MASTER) - 0.1)


func _on_master_volume_group_volume_up_pressed() -> void:
	Settings.set_volume(Bus.MASTER, Settings.get_volume(Bus.MASTER) + 0.1)


func _on_music_volume_group_volume_down_pressed() -> void:
	Settings.set_volume(Bus.MUSIC, Settings.get_volume(Bus.MUSIC) - 0.1)


func _on_music_volume_group_volume_up_pressed() -> void:
	Settings.set_volume(Bus.MUSIC, Settings.get_volume(Bus.MUSIC) + 0.1)


func _on_quit_button_pressed() -> void:
	quit_button_pressed.emit()


func _on_sfx_volume_group_volume_down_pressed() -> void:
	Settings.set_volume(Bus.SFX, Settings.get_volume(Bus.SFX) - 0.1)


func _on_sfx_volume_group_volume_up_pressed() -> void:
	Settings.set_volume(Bus.SFX, Settings.get_volume(Bus.SFX) + 0.1)


func _on_settings_volume_changed(bus: Bus, value: float) -> void:
	match bus:
		Bus.MASTER:
			master_volume_group.set_value(value)
		Bus.MUSIC:
			music_volume_group.set_value(value)
		Bus.SFX:
			sfx_volume_group.set_value(value)
