extends Node3D

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		#print("we are playing")
		body.ammo_up()
		queue_free()

func _on_animation_player_animation_finished(anim_name):
	queue_free()
