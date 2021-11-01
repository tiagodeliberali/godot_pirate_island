extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var FRICTION = 200
export var IMPACT = 130
export var MAX_SPEED = 50
export var ACCELERATION = 300

enum {
	IDLE,
	WANDER,
	CHASE
}
var state = CHASE

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

onready var stats = $Stats
onready var playerDetection = $PlayerDetection
onready var sprite = $AnimatedSprite

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()

		WANDER:
			pass

		CHASE:
			var player = playerDetection.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
			
	velocity = move_and_slide(velocity)


func seek_player():
	if playerDetection.can_see_player():
		state = CHASE

func _on_HurtBox_area_entered(area):
	knockback = area.knockback_vector * IMPACT
	stats.hit(area.damage)


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
