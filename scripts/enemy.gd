extends CharacterBody2D

const SPEED = 35.0
const GRAVITY = 800.0

var health = 2
var player = null
var is_dead = false
var can_damage = true

func _ready():
	add_to_group("enemies")
	$AnimatedSprite2D.play("walk")
	# Find player directly on start
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("players")

func _physics_process(delta):
	if is_dead:
		return

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if player:
		var direction = sign(player.global_position.x - global_position.x)
		velocity.x = direction * SPEED
		$AnimatedSprite2D.flip_h = direction < 0

		# Kill player on touch
		if global_position.distance_to(player.global_position) < 40 and can_damage:
			can_damage = false
			player.die()
			await get_tree().create_timer(1.0).timeout
			can_damage = true

	move_and_slide()

func take_damage():
	if is_dead:
		return
	health -= 1
	modulate = Color(1, 0.2, 0.2)
	await get_tree().create_timer(0.15).timeout
	modulate = Color(1, 1, 1)
	if health <= 0:
		die()

func die():
	is_dead = true
	velocity = Vector2.ZERO
	set_physics_process(false)
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(0.8).timeout
	if get_parent().has_method("enemy_died"):
		get_parent().enemy_died()
	queue_free()
