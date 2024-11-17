extends CPUParticles2D

@export var parent_node: bool = false
@export var center: bool = false
@export var right_edge: bool = false
@export var left_edge: bool = false
@export var top_edge: bool = false
@export var bottom_edge: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if parent_node:
		if center:
			position.x = get_parent().global_position.x + get_parent().size.x / 2
			position.y = get_parent().global_position.y + get_parent().size.y / 2
	else:
		if right_edge:
			position.x = get_viewport().size.x
		elif left_edge:
			position.x = 0
		
		if bottom_edge:
			position.y = get_viewport().size.y
		elif top_edge:
			position.y = 0
		
