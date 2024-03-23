extends Area2D

func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		body.health -= 1
		if body.health <= 0:
			body.queue_free()
		
