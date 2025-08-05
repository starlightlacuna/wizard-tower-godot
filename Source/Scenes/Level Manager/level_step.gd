## Base class for resources that represent steps in the level execution.
##
## LevelStep represents a distinct action that the [LevelManager] makes during the
## course of a level. This class itself does not represent any action and must 
## be extended. Behavior for each derived class must be defined in
## [LevelManager].
class_name LevelStep
extends Resource
