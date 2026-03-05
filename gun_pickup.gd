extends Area2D

func _ready():
	body_entered.connect(_on_body)

func _on_body(body):
	if body.name == "Player":
		body.has_gun = true
		queue_free()
