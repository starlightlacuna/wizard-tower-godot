class_name TowerHealthIcon
extends TextureRect

enum Display {
	NONE,
	HALF,
	FULL
}

@export var half_texture: Texture
@export var full_texture: Texture

func _ready() -> void:
	assert(half_texture, "[TowerHealthIcon] Half Texture not set!")
	assert(full_texture, "[TowerHealthIcon] Full Texture not set!")

func update(value: Display) -> void:
	match value:
		Display.NONE:
			set_texture(null)
		Display.HALF:
			set_texture(half_texture)
		Display.FULL:
			set_texture(full_texture)
