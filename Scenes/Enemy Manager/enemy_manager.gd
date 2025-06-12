class_name EnemyManager
extends Node2D

signal game_completed
enum EnemyType { SKELLY, GHOST, BRUTE }

@export var skelly_scene: PackedScene
@export var ghost_scene: PackedScene
@export var brute_scene: PackedScene
@export var levels: Array[Level]

var enemy_group_index: int = 0
var wave_index: int = 0
var level_index: int = 0

@onready var enemies: Node = $Enemies
@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	assert(skelly_scene, "[Enemy Manager] Skelly Scene not set!")
	assert(ghost_scene, "[Enemy Manager] Ghost Scene not set!")
	assert(brute_scene, "[Enemy Manager] Brute Scene not set!")
	
	_on_spawn_timer_timeout()

	#_spawn_enemy(EnemyType.SKELLY, 0)
	#_spawn_enemy(EnemyType.SKELLY, 1)
	#_spawn_enemy(EnemyType.SKELLY, 2)
	#_spawn_enemy(EnemyType.SKELLY, 3)
	#_spawn_enemy(EnemyType.SKELLY, 4)
	#_spawn_enemy(EnemyType.SKELLY, 5)


func _spawn_enemy_group(enemy_group: EnemyGroup) -> void:
	for index in enemy_group.enemies.size():
		var enemy_config: EnemyConfig = enemy_group.enemies[index]
		var enemy: Enemy
		match enemy_config.enemy_type:
			EnemyType.SKELLY:
				enemy = skelly_scene.instantiate()
			EnemyType.GHOST:
				enemy = ghost_scene.instantiate()
			EnemyType.BRUTE:
				enemy = brute_scene.instatiate()
		enemy.lane = enemy_config.lane
		enemies.add_child(enemy)


func _on_spawn_timer_timeout() -> void:
	if level_index > levels.size():
		# TODO: handle no more levels
		return
		
	#region Process Level
	var current_level: Level = levels[level_index]
	if wave_index > current_level.waves.size():
		# TODO: handle no more waves in level
		return
	#endregion
	
	#region Process Wave
	var current_wave: Wave = current_level.waves[wave_index]
	
	if enemy_group_index >= current_wave.enemy_groups.size():
		enemy_group_index = 0
		wave_index += 1
		if current_wave.wait_for_clear:
			# TODO: handle enemy clearing
			#var next_wave = current_level.waves[wave_index]
			#if next_wave.begin_delay > 0:
				#spawn_timer.set_wait_time(next_wave.begin_delay)
				#spawn_timer.start()
				#return
			#_on_spawn_timer_timeout()
			return
	
	if enemy_group_index == 0 and current_wave.begin_delay > 0:
		await get_tree().create_timer(current_wave.begin_delay).timeout
	#endregion
	
	#region Process EnemyGroup
	var enemy_group: EnemyGroup = current_wave.enemy_groups[enemy_group_index]
	_spawn_enemy_group(enemy_group)
	enemy_group_index += 1
	
	# TODO: Don't restart timer if last wave?
	spawn_timer.set_wait_time(current_wave.delay)
	spawn_timer.start()
	#endregion

#level = 0
#wave = 0
#group = 0
