class_name EnemyConfig
extends Resource

@export var enemy_type: LevelManager.EnemyType
@export_range(0, 5) var lane: int:
	set(new_value):
		lane = new_value
	get:
		if random_lane:
			return randi_range(min_lane, max_lane)
		else:
			return lane
@export var random_lane: bool = false
@export_subgroup("Random Lane")
@export_range(0, 5) var min_lane: int = 0
@export_range(0, 5) var max_lane: int = 5
