extends Node3D

@onready var can_fire = true 
@onready var active_weapon = true
@onready var max_rounds_in_gun = 15
@onready var ammo_in_gun = 0
@onready var ammo_in_inventory = 0
@onready var shot=preload("res://Weapons/Mac10/Mac10Shot.tscn")

func _process(delta):
	if active_weapon:
		if Input.is_action_just_pressed("reload"):
			if can_fire:
				reload()
		if Input.is_action_just_pressed("fire"):
			if can_fire:
				if ammo_in_gun>0:
					fire()
				else:
					reload()

func reload():

	can_fire=false
	#This part handles the ammo
	var rounds_needed = max_rounds_in_gun-ammo_in_gun
	if ammo_in_inventory > rounds_needed:
		ammo_in_inventory -= rounds_needed
		ammo_in_gun = max_rounds_in_gun
	else:
		if ammo_in_inventory == 0:
			$MisfireSound.play()
	#		print("no ammo in inventory")
			can_fire=true
			return
		else:
			ammo_in_gun = ammo_in_inventory
			ammo_in_inventory = 0
	#This part plays the animation
	$AnimationPlayer.play("Reload")
	$ReloadSound.play()
	update_ammo()

func fire():
	can_fire = false
	ammo_in_gun -= 1
	#print("ammo in gun: ", ammo_in_gun)
	#print("ammo in inventory: ", ammo_in_inventory)
	$FireSound.play()
	$AnimationPlayer.play("fire")
	update_ammo()
	var bullet=shot.instantiate()
	add_child(bullet)
	
	if $RayCast3D.is_colliding():
		if $RayCast3D.get_collider().is_in_group("enemy"):
			$RayCast3D.get_collider().take_damage(25, "normal", $RayCast3D.get_collision_point())

		if $RayCast3D.get_collider().is_in_group("critical"):
			$RayCast3D.get_collider().take_damage(85, "critical", $RayCast3D.get_collision_point())

		if $RayCast3D.get_collider().is_in_group("bugs"):
			$RayCast3D.get_collider().squash_bug()

func update_ammo():
	get_tree().call_group("Cam","update_ammo",[ammo_in_gun,ammo_in_inventory])

func _on_animation_player_animation_finished(anim_name):
#	print("anim_name: ", anim_name)
	if anim_name == "fire":
		can_fire=true

	if anim_name == "Reload":
		can_fire = true

