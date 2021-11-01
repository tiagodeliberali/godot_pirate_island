extends Node2D


func create_grass_effect():
	# instance effect
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	var grassEffect = GrassEffect.instance()
	grassEffect.global_position = global_position
	
	# add the effect to the world
	var world = get_tree().current_scene
	world.add_child(grassEffect)

func _on_HurtBox_area_entered(area):
	create_grass_effect()
	queue_free()
