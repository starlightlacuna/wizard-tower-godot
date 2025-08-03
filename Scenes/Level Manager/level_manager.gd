class_name LevelManager
extends Node2D
## Handles enemy spawning and tracking.

## Emitted when the last enemy has been removed from the scene tree.
signal enemies_cleared

## Emitted when the level index has changed, likely when moving to the next level.
signal level_index_updated

## The type of enemy to spawn.
enum EnemyType { SKELLY, GHOST, BRUTE }

## The index of the current level being processed.
@export var level_index: int = 0:
	set(new_value):
		level_index = new_value
		level_index_updated.emit()

@export var _enemies: Node2D
@export var _power_up_manager: PowerUpManager

@export_subgroup("Enemy Scenes")
@export var _skelly_scene: PackedScene
@export var _ghost_scene: PackedScene
@export var _brute_scene: PackedScene

var _enemies_count: int = 0

#@onready var _enemies: Node = $Enemies
@onready var _spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	assert(_skelly_scene, "[Level Manager] Skelly Scene not set!")
	assert(_ghost_scene, "[Level Manager] Ghost Scene not set!")
	assert(_brute_scene, "[Level Manager] Brute Scene not set!")
	assert(_enemies, "[Level Manager] Enemies Node not set!")
	assert(_power_up_manager, "[Level Manager] Power Up Manager not set!")
	
	_enemies.child_entered_tree.connect(_on_enemies_child_entered_tree)
	Event.enemy_died.connect(_on_enemy_died)


## Begins iterating through the [param levels] and processing each [member Level.steps] array.
func process_levels(levels: Array[Level]) -> void:
	level_index = 0
	for level in levels:
		for level_step in level.steps:
			await _execute_level_step(level_step)
		level_index += 1


# TODO: Refactor to move execution details to the LevelSteps themselves instead of here.
func _execute_level_step(level_step: LevelStep) -> void:
	if level_step is SpawnEnemyGroup:
		_spawn_enemy_group(level_step)
	elif level_step is SpawnEnemy:
		_spawn_enemy(level_step.enemy_type, level_step.lane)
	elif level_step is WaitDuration:
		_spawn_timer.start(level_step.duration)
		await _spawn_timer.timeout
		return
	elif level_step is WaitClear:
		await enemies_cleared
		return
	elif level_step is SpawnPowerUpFairy:
		_power_up_manager.spawn_power_up()
		return
	else:
		push_error("[Level Manager] Unknown LevelStep!")
		return


func _spawn_enemy(enemy_type: EnemyType, lane: int) -> void:
	var enemy: Enemy
	match enemy_type:
		EnemyType.SKELLY:
			enemy = _skelly_scene.instantiate()
		EnemyType.GHOST:
			enemy = _ghost_scene.instantiate()
		EnemyType.BRUTE:
			enemy = _brute_scene.instantiate()
	enemy.lane = lane
	# Have to defer the call to avoid an error
	_enemies.add_child.call_deferred(enemy)


func _spawn_enemy_group(enemy_group: SpawnEnemyGroup) -> void:
	for index in enemy_group.enemies.size():
		var enemy_config: EnemyConfig = enemy_group.enemies[index]
		var enemy: Enemy
		match enemy_config.enemy_type:
			EnemyType.SKELLY:
				enemy = _skelly_scene.instantiate()
			EnemyType.GHOST:
				enemy = _ghost_scene.instantiate()
			EnemyType.BRUTE:
				enemy = _brute_scene.instantiate()
		enemy.lane = enemy_config.lane
		# Have to defer the call to avoid an error
		_enemies.add_child.call_deferred(enemy)


func _on_enemies_child_entered_tree(_node: Node) -> void:
	_enemies_count += 1


func _on_enemies_child_exiting_tree(_node: Node) -> void:
	_enemies_count -= 1
	if _enemies_count <= 0:
		enemies_cleared.emit()


func _on_enemy_died() -> void:
	_enemies_count -= 1
	if _enemies_count == 0:
		enemies_cleared.emit()
