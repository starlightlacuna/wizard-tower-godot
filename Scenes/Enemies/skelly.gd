class_name Skelly
extends Enemy

func _ready() -> void:
	super._ready()
	set_position(_start_position)
	
	var end_position: Vector2i = Grid.grid_to_world(Vector2i(Grid.END_COL, lane + Grid.START_ROW))
	var tween_duration = abs((end_position.x - _start_position.x) / speed)
	var tween: Tween = self.create_tween()
	tween.tween_property(self, "position", Vector2(end_position), tween_duration)
	tween.tween_callback(damage_tower)
