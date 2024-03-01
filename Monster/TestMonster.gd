extends CharacterBody3D

var current_state="chase"
var next_state="chase"
var previous_state  


@onready var health=100
@onready var player 


@onready var ammo=load("res://Pickups/ammo_picup.tscn")
@onready var health_pickup=load("res://Pickups/health_pickup.tscn")
@onready var rand=RandomNumberGenerator.new()

func _ready():
	player=get_tree().get_first_node_in_group("player")


func _physics_process(delta):
	if previous_state != current_state:
		$StateLabel.text=current_state
	previous_state = current_state
	current_state = next_state
	
	match current_state:
		"idle":
			idle()
		"bite":
			bite()
		"chase":
			chase(delta) 
		"takeHit":
			takeHit(delta)
		"death":
			death()
			
		
func idle():
	if previous_state != current_state:
		$Monster/AnimationPlayer.play("Rest")

func drop_item():
	var rand_numn=rand.randi_range(0,40)
	if rand_numn%2==0:
		var a = ammo.instantiate()
		get_tree().get_first_node_in_group("level").add_child(a)
		a.position=position+Vector3(0,2,0)
	else:
		var b = health_pickup.instantiate()
		get_tree().get_first_node_in_group("level").add_child(b)
		b.position=position+Vector3(0,2,0)

func death():
	if previous_state!=current_state:
		player.award_points(800)
		$CollisionShape3D.disabled=true
		drop_item()
		$Monster/AnimationPlayer.play("Death") 
		get_parent().get_node("Betterlevel").enemy_death()
		




func take_damage(num, type, blood_pos):
	next_state="takeHit"
	health-=num
	if health<=0:
		next_state="death"
		return	
	
	
@onready var nav = $NavigationAgent3D
@onready var speed = 8.0
@onready var turnspeed = 1
func chase(delta):
	velocity = (nav.get_next_path_position() - position).normalized() * speed * delta
	$FaceDirection.look_at(player.position, Vector3.UP)
	rotate_y(deg_to_rad($FaceDirection.rotation.y * turnspeed))
	if  player.position.distance_to(self.position) < 4:
		next_state="bite"
	
	if  player.position.distance_to(self.position) > 1:
		nav.target_position = player.position
		move_and_collide(velocity)



func takeHit(delta):
	velocity = -(nav.get_next_path_position() - position).normalized() * speed * delta
	move_and_collide(velocity)
	$Monster/AnimationPlayer.play("TakeHit")



func bite():
	if previous_state != current_state:
		$Monster/AnimationPlayer.play("Bite")
		player.take_damage(10)




func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"TakeHit":
			next_state="chase"
		"Bite":
			next_state="chase" # Replace with function body.
		"Death":
			queue_free()
