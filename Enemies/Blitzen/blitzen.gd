extends CharacterBody2D

var speed = 800
var blitzen_position = 0
var player_in_room = false
var health = 2

@onready var player = $/root/Game/Player

func _process(delta):
	if player_in_room:
		$PlayerPosition/GroupingPath/EndLocation.progress_ratio = blitzen_position
		$PlayerPosition.global_position = player.global_position
		$PlayerPosition.rotation += 2 * delta
		var direction = global_position.direction_to($PlayerPosition/GroupingPath/EndLocation.global_position)
		if global_position.distance_to($PlayerPosition/GroupingPath/EndLocation.global_position) > 200:
			speed = 1500
		elif global_position.distance_to($PlayerPosition/GroupingPath/EndLocation.global_position) > 50:
			speed = 500
		elif global_position.distance_to($PlayerPosition/GroupingPath/EndLocation.global_position) < 50:
			speed = 0
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
