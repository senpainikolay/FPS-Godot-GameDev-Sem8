extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		body.heal_player(20)
		queue_free()
		


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"Rotate":
			queue_free()
