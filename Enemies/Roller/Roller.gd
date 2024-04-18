extends CharacterBody2D

const SPEED = 150.0
var health = 2
var player_in_room = false
const friendship_distance = 300

@onready var player = $/root/Game/Player


func pathfind(direction):
	var entities_in_vision = $Vision.get_overlapping_bodies()
	var rollers_in_vision = Array ()
	var rollers_nearby = Array ()
	for entity in entities_in_vision:
		if entity.is_in_group("Roller"):
			rollers_in_vision.append(entity)
		if global_position.distance_to(entity.global_position) < friendship_distance:
			rollers_nearby.append(entity)
	for roller in rollers_in_vision:
		if roller in rollers_in_vision and roller not in rollers_nearby and rollers_nearby.size() < 3:
			direction += global_position.direction_to(roller.global_position)
		elif roller in rollers_nearby:
			direction -= 0.5 * global_position.direction_to(roller.global_position)
	direction /= direction.length()
	return direction


func _process(delta):
	if player_in_room:
		var direction = global_position.direction_to(player.global_position)
		direction = pathfind(direction)
		velocity = direction * SPEED
		if global_position.direction_to(player.global_position)[0] > 0:
			rotation += delta
		elif global_position.direction_to(player.global_position)[0] <= 0:
			rotation -= delta
	else:
		velocity = Vector2.ZERO
	move_and_slide()
