extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 7

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 

@onready var derringer = preload("res://Weapons/Derringer/derringer.tscn") 

@onready var can_interact= false
@onready var interactable="none"

@onready var health=130
@onready var points=100

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	var starting_gun = derringer.instantiate()
	$CameraHolder/WeaponHolder.add_child(starting_gun)
	starting_gun.add_inital_ammo(1,30)
	starting_gun.update_ammo()
	var derringer_offset = Vector3(1,-1.5,-2)
	starting_gun.position += derringer_offset
	update_points()
	update_health()
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(event.relative.x * -0.04)) 
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

@onready var dead_sc = preload("res://Scenes/dead.tscn")
func take_damage(num):
	health -= num
	if health<=0:
		get_tree().change_scene_to_packed(dead_sc)
	update_health() 

func heal_player(num):
	health += num
	update_health()
	
func ammo_up():
	var holder=get_node("CameraHolder/WeaponHolder")
	var weapon_list = holder.weapon_list
	var current_weapon = $CameraHolder/WeaponHolder.get_child(0)
	for weapons in weapon_list:
		if weapons==current_weapon.name:
			if weapons=="Mac10":
				current_weapon.ammo_in_inventory+=25
			if weapons=="Shotgun":
				current_weapon.ammo_in_inventory+=10
			if weapons=="Glock":
				current_weapon.ammo_in_inventory+=15
			if weapons=="Derringer":
				current_weapon.ammo_in_inventory+=10
		if weapons=="Mac10":
			holder.ammo_dict[weapons.to_lower()][1]+=25
		if weapons=="Shotgun":
			holder.ammo_dict[weapons.to_lower()][1]+=10
		if weapons=="Glock":
			holder.ammo_dict[weapons.to_lower()][1]+=15
		if weapons=="Derringer":
			holder.ammo_dict[weapons.to_lower()][1]+=10
	$CameraHolder/WeaponHolder.get_child(0).update_ammo()
	
@onready var health_label = $CameraHolder/Camera3D/PlayerUI/Health
func update_health():
	health_label.text = "Health: " + str(health)
	

func _physics_process(delta):
	# Add the gravity.
	check_interactions()
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("a", "d", "w", "s")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func near_shotgun():
	interactable="shotgun"
	can_interact=true

func near_glock():
	interactable="glock"
	can_interact=true

func near_mac10():
	interactable="mac10"
	can_interact=true
	
func disable_interactions():
	can_interact=false

func award_points(num): 
	points += num
	$CameraHolder/Camera3D/PlayerUI/Points.text = "Points: "  + str(points)

func update_points():
	$CameraHolder/Camera3D/PlayerUI/Points.text=  "Points: " +  str(points)


func check_interactions():
	if can_interact:
		if Input.is_action_just_pressed("interact"):
			match interactable:
				#"hand":
				#	get_tree().call_group("level","interact_with_hand")
				"shotgun":
					if not "Shotgun" in $CameraHolder/WeaponHolder.weapon_list:
						if points>=1500:
							$CameraHolder/WeaponHolder.weapon_list.append("Shotgun")
							$CameraHolder/WeaponHolder.switch_to_weapon("Shotgun")
							points-=1500
							update_points()
					else:
						if points>=500:
							points-=500
							update_points()
							if $CameraHolder/WeaponHolder.get_child(0).name=="Shotgun":
								$CameraHolder/WeaponHolder.get_child(0).ammo_in_inventory+=25
								$CameraHolder/WeaponHolder.get_child(0).update_ammo()
							else:
								$CameraHolder/WeaponHolder.ammo_dict["shotgun"][1]+=25
								$CameraHolder/WeaponHolder.get_child(0).update_ammo()
							#print("not enough cash, stranger") 
				"glock":
					if not "Glock" in $CameraHolder/WeaponHolder.weapon_list:
						if points>=1200:
							$CameraHolder/WeaponHolder.weapon_list.append("Glock")
							$CameraHolder/WeaponHolder.switch_to_weapon("Glock")
							points-=1200
							update_points()
						else:
							print("not enough points") 
					else:
						if points>=500:
							points-=500
							update_points()
							if $CameraHolder/WeaponHolder.get_child(0).name=="Glock":
								$CameraHolder/WeaponHolder.get_child(0).ammo_in_inventory+=40
								$CameraHolder/WeaponHolder.get_child(0).update_ammo()
							else:
								$CameraHolder/WeaponHolder.ammo_dict["glock"][1]+=40
								$CameraHolder/WeaponHolder.get_child(0).update_ammo()
						else:
							print("not enough cash, stranger") 
						
				"mac10":
					if not "Mac10" in $CameraHolder/WeaponHolder.weapon_list:
						if points>=2500:
							$CameraHolder/WeaponHolder.weapon_list.append("Mac10")
							$CameraHolder/WeaponHolder.switch_to_weapon("Mac10")
							points-=2500
							update_points()
					else:
						if points>=500:
							points-=500
							update_points()
							if $CameraHolder/WeaponHolder.get_child(0).name=="Mac10":
								$CameraHolder/WeaponHolder.get_child(0).ammo_in_inventory+=60
								$CameraHolder/WeaponHolder.get_child(0).update_ammo()
							else:
								$CameraHolder/WeaponHolder.ammo_dict["mac10"][1]+=60
								$CameraHolder/WeaponHolder.get_child(0).update_ammo()
							#$CameraHolder/WeponHolder.update_ammo()
						else:
							print("not enough points") 

				"none":
					pass
	else:
		return
