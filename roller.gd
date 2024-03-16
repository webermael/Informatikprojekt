extends CharacterBody2D

const SPEED = 100.0
var health = 2

@onready var player = $/root/Game/Player

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	if direction[0] > 0:
		rotation += delta
	elif direction[0] <= 0:
		rotation -= delta
	move_and_slide()
