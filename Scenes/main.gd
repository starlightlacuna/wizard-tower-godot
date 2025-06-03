extends Node

@export var game: PackedScene
#@export var main_menu: PackedScene

func _ready() -> void:
	assert(game, "[Main] Game not initialized!")
	#assert(main_menu, "[Main] Main Menu not initialized!")
	
	for child in get_children():
		child.queue_free()
	
	var game_scene: Node = game.instantiate()
	add_child(game_scene)
