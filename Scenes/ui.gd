class_name UI
extends Control

@export var tower_health_icon_scene: PackedScene

var tower_health_icons: Array[TowerHealthIcon]

@onready var tower_health_bar: Control = $TowerHealthBar

func _ready() -> void:
	assert(tower_health_icon_scene, "[UI] Tower Health Icon not set!")

func update_tower_health_bar(current_health: int, max_health) -> void:
	for index in _get_icon_count(max_health):
		if current_health > 1:
			tower_health_icons[index].update(TowerHealthIcon.Display.FULL)
			current_health -= 2
		elif current_health > 0:
			tower_health_icons[index].update(TowerHealthIcon.Display.HALF)
			current_health -= 1
		else:
			tower_health_icons[index].update(TowerHealthIcon.Display.NONE)

func build_health_bar(max_health: int) -> void:
	for child in tower_health_bar.get_children():
		child.queue_free()
	
	for index in _get_icon_count(max_health):
		var new_icon: TowerHealthIcon = tower_health_icon_scene.instantiate()
		new_icon.set_position(Vector2(index * 10, 0))
		tower_health_bar.add_child(new_icon)
		tower_health_icons.append(new_icon)

func _get_icon_count(max_health: int) -> int:
	@warning_ignore("integer_division")
	return max_health / 2 if max_health % 2 == 0 else max_health / 2 + 1
