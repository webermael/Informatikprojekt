extends CharacterBody2D

const SPEED = 300.0
var health = 2
var player_in_room = false
var spawnposition = Vector2.ZERO

@onready var player = $/root/Game/Player


# moves the roller directly towards the player also rotates the roller according to which direction the player is located
func _process(delta):
	if player_in_room:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * SPEED
		if global_position.direction_to(player.global_position)[0] > 0:
			$RollerSprite.flip_h = true
		elif global_position.direction_to(player.global_position)[0] <= 0:
			$RollerSprite.flip_h = false
	else:
		velocity = Vector2.ZERO
	move_and_slide()
