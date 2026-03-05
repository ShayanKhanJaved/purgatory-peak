extends Area2D

var speed = 400.0
var direction = 1

func _ready():
	body_entered.connect(_on_hit)
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _process(delta):
	position.x += speed * direction * delta

func _on_hit(body):
	if body.has_method("take_damage"):
		body.take_damage()
	queue_free()
