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
onready var hurtbox = $HurtBox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_behaviour()

		WANDER:
			seek_behaviour()
			accelerate_toward(global_position.direction_to(wanderController.target_position).normalized(), delta)
			
			if global_position.distance_to(wanderController.target_position) <= 0.5:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wonder_timer(rand_range(1, 3))

		CHASE:
			var player = playerDetection.player
			if player != null:
				accelerate_toward(global_position.direction_to(player.global_position).normalized(), delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
			
	if softCollision.is_colliding():
		velocity = softCollision.get_push_vector() * delta * 400
	
	velocity = move_and_slide(velocity)

func accelerate_toward(point, delta):
	velocity = velocity.move_toward(point * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
	
func seek_behaviour():
	seek_player()
	
	if wanderController.get_time_left() < 0.01:
		state = pick_random_state([IDLE, WANDER])
		wanderController.start_wonder_timer(rand_range(1, 3))

func seek_player():
	if playerDetection.can_see_player():
		state = CHASE
		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	

func _on_HurtBox_area_entered(area):
	knockback = area.knockback_vector * IMPACT
	stats.hit(area.damage)
	hurtbox.create_hit_effect()


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
