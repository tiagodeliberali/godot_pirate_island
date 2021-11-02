extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty

onready var label = $Label

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	heartUIFull.rect_size.x = 15 * hearts
	
func set_max_hearts(value):
	max_hearts = max(value, 1)
	heartUIEmpty.rect_size.x = 15 * max_hearts
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
