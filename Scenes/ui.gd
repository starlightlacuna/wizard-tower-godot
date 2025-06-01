class_name UI
extends Control


@export var tower_health_icon_scene: PackedScene

var tower_health_icons: Array[TowerHealthIcon]

@onready var tower_health_bar: Control = $TowerHealthBar

func _ready() -> void:
	assert(tower_health_icon_scene, "[UI] Tower Health Icon not set!")
	build_health_bar(20)
	await get_tree().create_timer(3).timeout
	update_tower_health_bar(13)

func update_tower_health_bar(tower_health: int) -> void:
	for icon in tower_health_icons:
		icon.update(TowerHealthIcon.Display.NONE)
		
	var index: int = 0
	while tower_health > 0:
		if tower_health == 1:
			tower_health_icons[index].update(TowerHealthIcon.Display.HALF)
			tower_health -= 1
		else:
			tower_health_icons[index].update(TowerHealthIcon.Display.FULL)
			tower_health -= 2
		index += 1

func build_health_bar(max_health: int) -> void:
	for child in tower_health_bar.get_children():
		child.queue_free()
	
	# TODO: Check for odd values!
	for index in max_health / 2:
		var new_icon: TowerHealthIcon = tower_health_icon_scene.instantiate()
		new_icon.set_position(Vector2(index * 10, 0))
		tower_health_bar.add_child(new_icon)
		tower_health_icons.append(new_icon)
	
