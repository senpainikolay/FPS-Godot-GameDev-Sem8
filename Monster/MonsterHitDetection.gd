extends Area3D

func take_damage(num,type,pos):
	get_parent().get_parent().take_damage(num,type,pos)
	
