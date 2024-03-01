extends Node3D

@onready var shotgun = preload("res://Weapons/Shotgun/shotgun.tscn") 
@onready var mac10 = preload("res://Weapons/Mac10/mac_10.tscn") 
@onready var glock = preload("res://Weapons/Glock/Glock.tscn") 
@onready var derringer = preload("res://Weapons/Derringer/derringer.tscn") 

#This script will hold our weapons and ammo. 
#it will also spawn the weapons in on the player

@onready var ammo_dict={
	"shotgun":[3,6],
	"mac10":[30,60],
	"glock":[15,30],
	"derringer":[1,25]
}

func _input(event):
	if event.is_action_pressed("change_weapon_up"):
		cycle_weapon_up()

@onready var weapon_list = ["Derringer", "Mac10"]
func pick_up_weapon(weapon):
	weapon_list.append(weapon)

func switch_to_weapon(weapon):
	var current_weapon = get_children()[0]
	var index
	match weapon:
		"Shotgun":
			index = weapon_list.find("Shotgun")
		"Mac10":
			index = weapon_list.find("Mac10")
		"Derringer":
			index = weapon_list.find("Derringer")
		"Glock":
			index = weapon_list.find("Glock")
	get_children()[0].queue_free()
	spawn_new_gun(index)

func cycle_weapon_up():
	var current_weapon = get_children()[0].name
	
	#We check the canfire variable one our first child which should always be our gun.
	#We check this to make sure we are not firing.
	if get_children()[0].can_fire:
		var index = weapon_list.find(current_weapon)
		var returned_index
		if index==-1:
			#This is incase we try to switch with only one gun. we return so that we dont run anything below this.
			print("no index")
			return
		else:
			#when we change wepons we record the ammo count to the ammo_dictionary
			record_ammo_count(get_children()[0].name, get_children()[0].ammo_in_gun, get_children()[0].ammo_in_inventory)
			get_children()[0].queue_free()
			# we check if moving to the next weapon is possible or we loop back to the first.
			if index==len(weapon_list)-1:
				returned_index=0
			else:
				returned_index=index+1
			spawn_new_gun(returned_index)
	else:
		return

func spawn_new_gun(returned_index):
	print("Returned Index:", weapon_list[returned_index])
	match weapon_list[returned_index]:
		"Derringer":
			
			#updates the UI
			get_parent().get_node("Camera3D/PlayerUI/GunName").text="Single Shooter"
			get_parent().get_node("Camera3D/PlayerUI/Current_Weapon").texture=load("res://Weapons/Derringer/Derringer.png")
			
			#instantiates the scene
			var gun = derringer.instantiate()
			
			#adds the scene as a child of our selves. 
			add_child(gun)
			
			#sets our ammo equal to the value in the ammo dictionary
			#this keeps track of our ammo when we switch scenes
			gun.ammo_in_gun=ammo_dict["derringer"][0]
			gun.ammo_in_inventory=ammo_dict["derringer"][1]
			
			#This updates the ammo on the players hud
			gun.update_ammo()
			
			#this moves the pistol to a better position for the camera
			var derringer_offset = Vector3(1,-1.5,-2)
			gun.position += derringer_offset
			
		"Shotgun":
			get_parent().get_node("Camera3D/PlayerUI/GunName").text="Shotgun"
			get_parent().get_node("Camera3D/PlayerUI/Current_Weapon").texture=load("res://Weapons/Shotgun/Shotgun.png")
			var gun = shotgun.instantiate()
			add_child(gun)
			gun.ammo_in_gun=ammo_dict["shotgun"][0]
			gun.ammo_in_inventory=ammo_dict["shotgun"][1]
			gun.update_ammo()
			var offset = Vector3(1,-1,-2)
			gun.position += offset
			
		"Mac10":
			get_parent().get_node("Camera3D/PlayerUI/GunName").text="Mac din Centru"
			get_parent().get_node("Camera3D/PlayerUI/Current_Weapon").texture=load("res://Weapons/Mac10/Mac10.png")
			var gun = mac10.instantiate()
			add_child(gun)
			gun.ammo_in_gun=ammo_dict["mac10"][0]
			gun.ammo_in_inventory=ammo_dict["mac10"][1]
			gun.update_ammo()
			var offset = Vector3(1,-1.5,-3)
			gun.position += offset
			
		"Glock":
			get_parent().get_node("Camera3D/PlayerUI/GunName").text="Glockamole"
			get_parent().get_node("Camera3D/PlayerUI/Current_Weapon").texture=load("res://Weapons/Glock/Mac10.png")
			var gun = glock.instantiate()
			add_child(gun)
			gun.ammo_in_gun=ammo_dict["glock"][0]
			gun.ammo_in_inventory=ammo_dict["glock"][1]
			gun.update_ammo()
			var offset = Vector3(1,-1.5,-3)
			gun.position += offset

#this function keeps track of our ammo even after switching. 
func record_ammo_count(weapon, rounds_in_gun, rounds_in_inventory):
	match weapon:
		"Derringer":
			ammo_dict["derringer"][0]=rounds_in_gun
			ammo_dict["derringer"][1]=rounds_in_inventory
		"Shotgun":
			ammo_dict["shotgun"][0]=rounds_in_gun
			ammo_dict["shotgun"][1]=rounds_in_inventory
		"Mac10":
			ammo_dict["mac10"][0]=rounds_in_gun
			ammo_dict["mac10"][1]=rounds_in_inventory
		"Glock":
			ammo_dict["glock"][0]=rounds_in_gun
			ammo_dict["glock"][1]=rounds_in_inventory
