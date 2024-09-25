extends Button

var min_size_x = 250
var min_size_y = 160


func _process(delta: float) -> void:
	var custom_min_size_x = custom_minimum_size.x
	var custom_min_size_y = custom_minimum_size.y
	custom_min_size_x = lerpf(custom_min_size_x, min_size_x, 15 * delta)
	custom_min_size_y = lerpf(custom_min_size_y, min_size_y, 15 * delta)
	
	custom_minimum_size = Vector2(custom_min_size_x, custom_min_size_y)


func _on_mouse_entered() -> void:
	min_size_x = 270
	min_size_y = 180


func _on_mouse_exited() -> void:
	min_size_x = 250
	min_size_y = 160
