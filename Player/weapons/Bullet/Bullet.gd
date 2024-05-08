extends Area2D

const SPEED = 1000
const MAX_DISTANCE = 500
var damage = 2
var distance_traveled = 0

func land():
		var landed_bullet = preload("res://Player/weapons/Bullet/landed_bullet.tscn").instantiate()
		landed_bullet.global_position = global_position
		$/root/Game.add_child(landed_bullet)
		queue_free()

func _process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	distance_traveled += direction.length() * SPEED * delta
	if distance_traveled >= MAX_DISTANCE:
		land()


func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		$/root/Game/Player.hit_enemy = true
		body.health -= damage
		if body.health <= 0:
			body.get_parent().enemy_died(body)
			body.queue_free()
		queue_free()
	if body.is_in_group("Solid"):
		land()
