class_name PowerUpFairy
extends Area2D
## A Power Up Fairy.
##
## When the [Player] enters this scene's area, [signal consumed] is emitted to be handled by
## [PowerUpManager]. See [Player]'s [method Node._process] method.

## Emitted when this fairy was consumed.
@warning_ignore("unused_signal")
signal consumed

## The [AnimationPlayer] that handles the fairy's animation. The hovering animation's key is 
## [code]Power Up Fairy/Hover[/code] (e.g. [code]animation_player.play("Power Up Fairy/Hover")[/code]).
@onready var animation_player: AnimationPlayer = $AnimationPlayer
