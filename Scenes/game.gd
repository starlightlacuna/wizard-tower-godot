extends Node2D

@onready var player: Player = $Player
@onready var firebolts: Node2D = $Firebolts

@export var tower_max_health: int = 20

var tower_health: int = tower_max_health

@onready var ui: UI = $UI

func _ready() -> void:
	player.set_position(Grid.grid_to_world(Vector2i(0, 2)))
	player.set_firebolts_node(firebolts)
	ui.build_health_bar(tower_max_health)
	
	Event.tower_damaged.connect(_damage_tower)

func _damage_tower(damage: int) -> void:
	tower_health -= damage
	ui.update_tower_health_bar(tower_health, tower_max_health)
	
	if tower_health <= 0:
		print("Tower destroyed! You lose.")
