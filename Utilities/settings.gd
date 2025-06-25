extends Node

signal volume_changed(bus: Bus, value: float)

enum Bus {
	MASTER,
	MUSIC,
	SFX,
}

@onready var master_bus_index: int = AudioServer.get_bus_index("Master")
@onready var music_bus_index: int = AudioServer.get_bus_index("Music")
@onready var sfx_bus_index: int = AudioServer.get_bus_index("Sound Effects")


func get_volume(bus: Bus) -> float:
	match bus:
		Bus.MASTER:
			return AudioServer.get_bus_volume_linear(master_bus_index)
		Bus.MUSIC:
			return AudioServer.get_bus_volume_linear(music_bus_index)
		Bus.SFX:
			return AudioServer.get_bus_volume_linear(sfx_bus_index)
		_:
			return -1.0


func set_volume(bus: Bus, value: float) -> void:
	value = clampf(value, 0.0, 1.0)
	match bus:
		Bus.MASTER:
			AudioServer.set_bus_volume_linear(master_bus_index, value)
			volume_changed.emit(bus, value)
		Bus.MUSIC:
			AudioServer.set_bus_volume_linear(music_bus_index, value)
			volume_changed.emit(bus, value)
		Bus.SFX:
			AudioServer.set_bus_volume_linear(sfx_bus_index, value)
			volume_changed.emit(bus, value)
