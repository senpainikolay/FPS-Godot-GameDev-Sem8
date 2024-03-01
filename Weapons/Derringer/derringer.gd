extends Node3D

@onready var shot=preload("res://Weapons/Mac10/Mac10Shot.tscn")
@onready var can_fire = true
#we will use this when we have multiple weapons to switcth to 
@onready var active_weapon = true

#ammo vars
@onready var max_rounds_in_gun = 1
@onready var ammo_in_gun = 0
@onready var ammo_in_inventory = 0

@onready var red_dot_site_enabled=false
func enable_red_dot():
	red_dot_site_enabled=true

func enable_quick_reload():
	pass

func enable_damage_boost():
	pass


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
	if ammo_in_inventory<=0:
		$MisfireSound.play()
		return
	$AnimationPlayer.play("Reload")
	$ReloadSound.play()
	
func add_inital_ammo(in_gun, in_inventory):
	#print("valueBefore: ", ammo_in_gun)
	ammo_in_gun=in_gun
	ammo_in_inventory=in_inventory
	#print("value after: ", ammo_in_gun)

func fire():
	can_fire = false
	#$GPUParticles3D.emitting = true
	ammo_in_gun -= 1
#	print("ammo in gun: ", ammo_in_gun)
#	print("ammo in inventory: ", ammo_in_inventory)
	$FireSound.play()
	$AnimationPlayer.play("fire")
	update_ammo()
	var bullet=shot.instantiate()
	add_child(bullet)
	if $RayCast3D.is_colliding():
		if $RayCast3D.get_collider().is_in_group("enemy"):
			$RayCast3D.get_collider().take_damage(45, "normal", $RayCast3D.get_collision_point())

		if $RayCast3D.get_collider().is_in_group("critical"):
			$RayCast3D.get_collider().take_damage(100, "critical", $RayCast3D.get_collision_point())
	

func update_ammo():
	get_tree().call_group("Cam","update_ammo",[ammo_in_gun,ammo_in_inventory])

func _on_animation_player_animation_finished(anim_name):
#	print("anim_name: ", anim_name)
	if anim_name == "fire":
		$AnimationPlayer.play("Reload")
	if anim_name=="Reload":
		if ammo_in_inventory>0:
			ammo_in_gun=1
			ammo_in_inventory-=1
		update_ammo()
		can_fire=true


