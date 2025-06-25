class_name SettingsMenu
extends Control

const Bus = Settings.Bus

@onready var master_volume_group: VolumeGroup = $PanelBackground/MasterVolumeGroup
@onready var music_volume_group: VolumeGroup = $PanelBackground/MusicVolumeGroup
@onready var sfx_volume_group: VolumeGroup = $PanelBackground/SFXVolumeGroup
@onready var back_button: CustomButton = $PanelBackground/BackButton


func _ready() -> void:
	Settings.volume_changed.connect(_on_settings_volume_changed)
	back_button.grab_focus.call_deferred()


func _on_master_volume_group_volume_down_pressed() -> void:
	Settings.set_volume(Bus.MASTER, Settings.get_volume(Bus.MASTER) - 0.1)


func _on_master_volume_group_volume_up_pressed() -> void:
	Settings.set_volume(Bus.MASTER, Settings.get_volume(Bus.MASTER) + 0.1)


func _on_music_volume_group_volume_down_pressed() -> void:
	Settings.set_volume(Bus.MUSIC, Settings.get_volume(Bus.MUSIC) - 0.1)


func _on_music_volume_group_volume_up_pressed() -> void:
	Settings.set_volume(Bus.MUSIC, Settings.get_volume(Bus.MUSIC) + 0.1)


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
