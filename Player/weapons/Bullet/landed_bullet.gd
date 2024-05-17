extends Sprite2D

# returns the projectile to the player (reloading the ranged attack)
func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		queue_free()
		$/root/Game/Player.bullet_ready = true
