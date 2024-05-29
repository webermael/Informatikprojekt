extends CharacterBody2D

var speed = 800
var player_in_room = false
var health = 2
var spawnposition = Vector2.ZERO

@onready var player = $/root/Game/Player

func _process(delta):
	if player_in_room:
		velocity = global_position.direction_to(player.global_position) * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
