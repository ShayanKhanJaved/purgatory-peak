extends Node2D

var enemy_count = 0

func _ready():
	enemy_count = get_tree().get_nodes_in_group("enemies").size()

func enemy_died():
	enemy_count -= 1
	if enemy_count <= 0:
		$Ladder.modulate = Color(1, 1, 0)
		print("ALL DEAD - LADDER OPEN")
