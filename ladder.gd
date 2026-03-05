extends Area2D

func _ready():
	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)

func _on_enter(body):
	if body.name == "Player":
		body.enter_ladder()

func _on_exit(body):
	if body.name == "Player":
		body.exit_ladder()
