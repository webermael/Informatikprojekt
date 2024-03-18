extends Area2D

const SPEED = 600


func _process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta


func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		body.health -= 2
		if body.health <= 0:
			body.queue_free()
		queue_free()
