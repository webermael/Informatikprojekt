extends CharacterBody2D

const SPEED = 500.0
const DECELERATION = 1
const CHARGE_DRIFT = 0.05
var health = 5
var charging = 1
var in_charge = false
var direction = Vector2 (0, 0)
var player_weight = 1

@onready var player = $/root/Game/Player

func _process(delta):
	direction += player_weight * global_position.direction_to(player.global_position)
	if player_weight < 1:
		player_weight += CHARGE_DRIFT * delta
	direction /= direction.length()
	if int(charging) > 1:
		charging -= DECELERATION * delta
	elif int(charging) == 1:
		in_charge = false
	print(charging, in_charge)
	for body in $ChargeArea.get_overlapping_bodies():
		if body.is_in_group("Player") and not in_charge:
			charging = -0.5
			$ChargeTimer.start()
	velocity = direction * SPEED * charging
	move_and_slide()


func _on_charge_timer_timeout():
	charging = 3
	in_charge = true
	player_weight = 0
	
