extends Node

export(int) var max_health = 1
onready var health = max_health setget set_health

func set_health(value):
	health = value
	
	if health <= 0:
		health = 0
		emit_signal("no_health")

func hit(amount = 1):
	set_health(health - amount)

signal no_health
