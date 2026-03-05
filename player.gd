extends CharacterBody2D

const SPEED = 120.0
const JUMP_VELOCITY = -350.0
const GRAVITY = 800.0

var has_gun = true  # SET TRUE FOR TESTING so you can shoot immediately
var is_dead = false
var facing_right = true
var on_ladder = false

func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	if is_dead:
		return

	# --- LADDER ---
	if on_ladder:
		var vert = Input.get_axis("ui_up", "ui_down")
		velocity.y = vert * SPEED
		velocity.x = 0
		if vert != 0:
			$AnimatedSprite2D.play("climb")
		else:
			$AnimatedSprite2D.stop()
		move_and_slide()
		return

	# --- GRAVITY ---
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# --- JUMP ---
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# --- MOVEMENT ---
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		facing_right = direction > 0
		$AnimatedSprite2D.flip_h = !facing_right
		if is_on_floor():
			$AnimatedSprite2D.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			$AnimatedSprite2D.play("idle")

	# --- JUMP ANIMATION ---
	if not is_on_floor():
		$AnimatedSprite2D.play("jump")

	# --- SHOOT ---
	if has_gun and Input.is_action_just_pressed("shoot"):
		shoot()

	move_and_slide()

func shoot():
	if is_dead:
		return
	$AnimatedSprite2D.play("attack")
	var bullet = preload("res://scenes/bullets.tscn").instantiate()
	bullet.global_position = global_position + Vector2(20 if facing_right else -20, -5)
	bullet.direction = 1 if facing_right else -1
	get_parent().add_child(bullet)
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("idle")

func enter_ladder():
	on_ladder = true
	velocity = Vector2.ZERO

func exit_ladder():
	on_ladder = false

func die():
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()
