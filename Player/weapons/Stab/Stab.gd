extends Area2D

# damages enemies that are in the area of the attack
func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		body.health -= 1
		if body.health <= 0:
			body.get_parent().enemy_died(body)
			body.queue_free()
