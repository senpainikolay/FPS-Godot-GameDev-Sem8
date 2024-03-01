extends RayCast3D

@onready var red_dot = load("res://Weapons/Derringer/red_dot.tscn")
@onready var dot = red_dot.instantiate()

func _process(delta):
	if is_colliding():
		if !get_tree().root.get_child(0).has_node('RedDot'):
			get_tree().root.get_child(0).add_child(dot)
		dot.position = get_collision_point()
	else:
		if get_tree().root.get_child(0).has_node('RedDot'):
			get_tree().root.get_child(0).remove_child(dot)

func _exit_tree():
	if get_tree().root.get_child(0).has_node('RedDot'):
		get_tree().root.get_child(0).remove_child.call_deferred(dot)
	
