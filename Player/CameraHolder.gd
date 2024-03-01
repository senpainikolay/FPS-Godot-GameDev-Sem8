extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		rotate_x(deg_to_rad(event.relative.y * -0.04)) 
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_ammo(numList):
	$Camera3D/PlayerUI/Ammo.text="Ammo: " + str(numList[1])
	$Camera3D/PlayerUI/Inventory.text="Inventory: " + str(numList[0])
