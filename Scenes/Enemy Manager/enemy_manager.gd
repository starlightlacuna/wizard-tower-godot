class_name EnemyManager
extends Node2D

signal enemies_cleared
signal game_completed
signal level_index_updated

enum EnemyType { SKELLY, GHOST, BRUTE }

@export var skelly_scene: PackedScene
@export var ghost_scene: PackedScene
@export var brute_scene: PackedScene
@export var levels: Array[Level]
@export var level_index: int = 0:
	set(new_value):
		level_index = new_value
		level_index_updated.emit()
		
@export var should_process_levels: bool = true:
	set(new_value):
		should_process_levels = new_value
		if new_value == false:
			enemies.child_exiting_tree.disconnect(_on_enemies_child_exiting_tree)

var _enemies_count: int = 0

@onready var enemies: Node = $Enemies
@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	assert(skelly_scene, "[Enemy Manager] Skelly Scene not set!")
	assert(ghost_scene, "[Enemy Manager] Ghost Scene not set!")
	assert(brute_scene, "[Enemy Manager] Brute Scene not set!")
	assert(levels, "[Enemy Manager] Levels not set!")
	
	_begin_game.call_deferred()


func _begin_game() -> void:
	await _process_levels()
	
	# TODO: Handle no more levels
	print("[Enemy Manager] No more levels!")
	game_completed.emit()


func _process_levels() -> void:
	for level in levels:
		for level_step in level.steps:
			if not should_process_levels:
				return
			await _execute_level_step(level_step)
		level_index += 1


func _execute_level_step(level_step: LevelStep) -> void:
	if level_step is SpawnEnemyGroup:
		_spawn_enemy_group(level_step)
	elif level_step is SpawnEnemy:
		_spawn_enemy(level_step.enemy_type, level_step.lane)
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


func _spawn_enemy(enemy_type: EnemyType, lane: int) -> void:
	var enemy: Enemy
	match enemy_type:
		EnemyType.SKELLY:
			enemy = skelly_scene.instantiate()
		EnemyType.GHOST:
			enemy = ghost_scene.instantiate()
		EnemyType.BRUTE:
			enemy = brute_scene.instantiate()
	enemy.lane = lane
	# Have to defer the call to avoid an error
	enemies.add_child.call_deferred(enemy)


func _spawn_enemy_group(enemy_group: SpawnEnemyGroup) -> void:
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
		# Have to defer the call to avoid an error
		enemies.add_child.call_deferred(enemy)


func _on_spawn_timer_timeout() -> void:
	pass


func _on_enemies_child_entered_tree(_node: Node) -> void:
	_enemies_count += 1


func _on_enemies_child_exiting_tree(_node: Node) -> void:
	_enemies_count -= 1
	if _enemies_count <= 0:
		enemies_cleared.emit()
