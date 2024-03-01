extends Node3D

@onready var rand=RandomNumberGenerator.new() 
@onready var monster_spawn = get_parent().get_node("MonsterSpawn")

@onready var in_between_waves=true
func _ready():
	$InBetweenWaves.start()
	rand.randomize()


@onready var dead_enemies=0
func enemy_death():
	dead_enemies+=1
	if dead_enemies==monster_dict[current_level]:
		$InBetweenWaves.start()
		dead_enemies=0

@onready var ui_timer=get_tree().get_nodes_in_group("player")[0].get_node("CameraHolder/Camera3D/PlayerUI/TimerLabel")
func _process(delta):
	if in_between_waves:
		ui_timer.text= "Time Left: " + str($InBetweenWaves.get_time_left())
	else:
		pass

@onready var current_level=0
@onready var monster_dict={
	1:2, 
	2:4, 
	3:6
}
@onready var monster= preload("res://Monster/TestMonster.tscn")


func spawn_enemies():
	for i in range(monster_dict[current_level]):
		var m = monster.instantiate()
		var spawn_length = monster_spawn.get_child_count()-1
		var rand_num = rand.randi_range(0,spawn_length)
		var spawn_postion = monster_spawn.get_child(rand_num).position
		get_parent().add_child(m)
		m.position = spawn_postion
		# Stronger Enemies
		m.health += current_level * 100 
		m.speed += current_level * 2
		
		await get_tree().create_timer(2.0).timeout
		#print("amount of monsters: ",i+1)


@onready var win_scene = preload("res://Scenes/finish.tscn")
func _on_in_between_waves_timeout():
	#print("Leaving level: ", current_level)
	current_level+=1
	if current_level<=len(monster_dict):
		spawn_enemies()
	else:
		get_tree().change_scene_to_packed(win_scene)

