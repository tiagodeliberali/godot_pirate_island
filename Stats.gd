extends Node

export(int) var max_health = 1 setget set_max_health
var health = max_health setget set_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func _ready():
	self.health = max_health

func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health)
	
	if health == 0:
		emit_signal("no_health")
		
func set_max_health(value):
	max_health = max(value, 1)
	emit_signal("max_health_changed", max_health)
	
	self.health = min(max_health, health)


func hit(amount = 1):
	self.health -= amount
