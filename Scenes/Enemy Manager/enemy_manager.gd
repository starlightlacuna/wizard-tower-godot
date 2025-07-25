class_name EnemyManager
extends Node2D

signal game_completed
signal enemies_cleared

enum EnemyType { SKELLY, GHOST, BRUTE }

@export var skelly_scene: PackedScene
@export var ghost_scene: PackedScene
@export var brute_scene: PackedScene
@export var levels: Array[Level]

var _level_index: int = 0
var _level_step_index: int = 0
var _enemies_count: int = 0

@onready var enemies: Node = $Enemies
@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	assert(skelly_scene, "[Enemy Manager] Skelly Scene not set!")
	assert(ghost_scene, "[Enemy Manager] Ghost Scene not set!")
	assert(brute_scene, "[Enemy Manager] Brute Scene not set!")
	assert(levels, "[Enemy Manager] Levels not set!")
	
	enemies.child_entered_tree.connect(_on_enemy_entered_tree)
	enemies.child_exiting_tree.connect(_on_enemy_exiting_tree)
	
	_begin_game.call_deferred()


func _begin_game() -> void:
	while _level_index < levels.size():
		var current_level: Level = levels[_level_index]
		if _level_step_index < current_level.steps.size():
			# We have to await here, otherwise execution will proceed without
			# pausing during wait steps
			await _execute_level_step(current_level.steps[_level_step_index])
			_level_step_index += 1
		else:
			_level_step_index = 0
			_level_index += 1
	
	# TODO: Handle no more levels
	print("[Enemy Manager] No more levels!")
	game_completed.emit()


func _execute_level_step(level_step: LevelStep) -> void:
	if level_step is SpawnEnemyGroup:
		_spawn_enemy_group(level_step)
	elif level_step is WaitDuration:
		spawn_timer.start(level_step.duration)
		await spawn_timer.timeout
		return
	elif level_step is WaitClear:
		await enemies_cleared
		return
	else:
		push_error("[Enemy Manager] Unknown LevelStep!")
		return


func _execute_next_level_step() -> void:
	if _level_step_index >= levels[_level_index].steps.size():
		# Move to next level
		_level_step_index = 0
		_level_index += 1
		return
		
	_execute_level_step(levels[_level_index].steps[_level_step_index])
	_level_step_index += 1
	randi()


func _spawn_enemy_group(enemy_group: SpawnEnemyGroup) -> void:
	var new_enemies: Array[Enemy] = []
	for index in enemy_group.enemies.size():
		var enemy_config: EnemyConfig = enemy_group.enemies[index]
		var enemy: Enemy
		match enemy_config.enemy_type:
			EnemyType.SKELLY:
				enemy = skelly_scene.instantiate()
			EnemyType.GHOST:
				enemy = ghost_scene.instantiate()
			EnemyType.BRUTE:
				enemy = brute_scene.instantiate()
		enemy.lane = enemy_config.lane
		new_enemies.push_back(enemy)
		# Have to defer the call to avoid an error
		enemies.add_child.call_deferred(enemy)


func _on_enemy_entered_tree(_node: Node) -> void:
	_enemies_count += 1


func _on_enemy_exiting_tree(_node: Node) -> void:
	_enemies_count -= 1
	if _enemies_count <= 0:
		enemies_cleared.emit()


func _on_spawn_timer_timeout() -> void:
	pass
