extends Node
## Autoloaded node that contains global signals.

@warning_ignore_start("unused_signal")
## Emitted when the tower is damaged. See [method Enemy.damage_tower].
signal tower_damaged(damage: int)

## Emitted when an enemy dies or gets removed from the game. See [method Enemy.damage_tower].
signal enemy_died
