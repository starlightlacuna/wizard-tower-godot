extends Node2D

@onready var player: Player = $Player
@onready var firebolts: Node2D = $Firebolts


func _ready() -> void:
	#player = $Player
	player.set_position(Grid.grid_to_world(Vector2i(0, 2)))
	
	player.set_firebolts_node(firebolts)
