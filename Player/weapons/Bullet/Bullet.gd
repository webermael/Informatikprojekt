extends Area2D

const SPEED = 600
const MAX_DISTANCE = 500
var damage = 2
var distance_traveled = 0


func _process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	distance_traveled += direction.length() * SPEED * delta
	if distance_traveled >= MAX_DISTANCE:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		body.health -= damage
		if body.health <= 0:
			body.queue_free()
		queue_free()
