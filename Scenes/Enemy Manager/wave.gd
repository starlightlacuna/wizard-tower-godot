class_name Wave
extends Resource

## The time in seconds before the wave begins.
## If undefined or less than or equal to zero, the wave begins immediately.
@export var begin_delay: float

## The time in seconds between each enemy group.
@export var delay: float

## The enemy groups to spawn for this wave.
@export var enemy_groups: Array[EnemyGroup]

## Flag to spawn a fairy in this wave.
@export var spawn_powerup: bool

## Flag to pause after all enemy groups in this wave have been spawned.
## Once all the enemies have left the map, resume with the next wave.
@export var wait_for_clear: bool
