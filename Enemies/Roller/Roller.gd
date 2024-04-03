extends CharacterBody2D

const SPEED = 200.0
var health = 2
const distance_for_friendship = 300

@onready var player = $/root/Game/Player


func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	var entities_in_vision = $Vision.get_overlapping_bodies()
	var rollers_in_vision = Array ()
	var rollers_nearby = Array ()
	for entity in entities_in_vision:
		if entity.is_in_group("Roller"):
			rollers_in_vision.append(entity)
		if global_position.distance_to(entity.global_position) < distance_for_friendship:
			rollers_nearby.append(entity)
	for roller in rollers_in_vision:
		if roller in rollers_in_vision and roller not in rollers_nearby and rollers_nearby.size() < 3:
			direction += global_position.direction_to(roller.global_position)
		elif roller in rollers_nearby:
			direction -= 0.5 * global_position.direction_to(roller.global_position)
	direction /= direction.length()
	velocity = direction * SPEED
	if global_position.direction_to(player.global_position)[0] > 0:
		rotation += delta
	elif global_position.direction_to(player.global_position)[0] <= 0:
		rotation -= delta
	move_and_slide()
