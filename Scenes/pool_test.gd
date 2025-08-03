extends Node2D

@export var pool: Array[Button]


func _ready() -> void:
	for i in range(6):
		var new_button: Button = Button.new()
		new_button.name = "Button" + str(i)
		new_button.text = "button " + str(i)
		new_button.pressed.connect(_remove.bind(new_button))
		pool.append(new_button)
		
func _get_first_available_or_null() -> Button:
	for item in pool:
		if not item.is_inside_tree():
			return item
	return null


func _remove(button: Button) -> void:
	var index = pool.find(button)
	if index > -1:
		$VBoxContainer.remove_child(button)
		print(button.name + " at index " + str(index))
	else: 
		print(button.name + " not in pool!!!")


func _on_spawn_button_pressed() -> void:
	var next_button: Button = _get_first_available_or_null()
	if next_button != null:
		$VBoxContainer.add_child(next_button)
