extends Node2D

@onready var player: Player = $Player
@onready var firebolts: Node2D = $Firebolts

@export var tower_health: int = 10
@export var tower_max_health: int = 20

#signal on_tower_damaged(tower_health: int)

@onready var ui: UI = $UI

func _ready() -> void:
	#player = $Player
	player.set_position(Grid.grid_to_world(Vector2i(0, 2)))
	player.set_firebolts_node(firebolts)
	ui.build_health_bar(tower_max_health)

func _damage_tower(value: int) -> void:
	tower_health -= value
	#on_tower_damaged.emit(tower_health)
	ui.update_tower_health_bar(tower_health, tower_max_health)
