class_name LevelManager
extends Node2D
## Handles enemy spawning and tracking.

## Emitted when the last enemy has been removed from the scene tree.
signal enemies_cleared
## Emitted when the level index has changed.
signal level_index_updated(current_level: int, total_levels: int)

## The type of enemy to spawn.
enum EnemyType { SKELLY, GHOST, BRUTE }

## The levels to play.
@export var levels: Array[Level] = []
## The enemies node in the game scene. When enemies are spawned, they are added 
## as children to this node.
@export var _enemies: Node2D
## The PowerUpManager node in the game scene. Calls are made to this node's
## methods to spawn power ups.
@export var _power_up_manager: PowerUpManager

@export_subgroup("Enemy Scenes")
@export var _skelly_scene: PackedScene
@export var _ghost_scene: PackedScene
@export var _brute_scene: PackedScene

## The index of the current level being processed.
var level_index: int = 0:
	set(new_value):
		level_index = new_value
		level_index_updated.emit(level_index, levels.size())

var _enemies_count: int = 0

@onready var _spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	assert(levels, "[LevelManager] Levels not set!")
	assert(_enemies, "[LevelManager] Enemies node not set!")
	assert(_power_up_manager, "[LevelManager] Power Up Manager not set!")
	assert(_skelly_scene, "[LevelManager] Skelly Scene not set!")
	assert(_ghost_scene, "[LevelManager] Ghost Scene not set!")
	assert(_brute_scene, "[LevelManager] Brute Scene not set!")
	
	_enemies.child_entered_tree.connect(_on_enemies_child_entered_tree)
	Event.enemy_died.connect(_on_enemy_died)


## Iterates through the elements of [param levels] and processes each of their
## [member Level.steps] arrays.
func process_levels() -> void:
	level_index = 0
	for level in levels:
		for level_step in level.steps:
			await _execute_level_step(level_step)
		level_index += 1


# Potential enhancement?: Refactor to move execution details to the LevelSteps 
# themselves instead of here.
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
	for enemy_config in enemy_group.enemies:
		_spawn_enemy(enemy_config.enemy_type, enemy_config.lane)


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
