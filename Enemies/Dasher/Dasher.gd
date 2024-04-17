extends CharacterBody2D

const SPEED = 500.0
const CHARGE_DECELERATION = 5
const PLAYER_FOLLOW_INCREASE = 0.1
var player_weight = 1
var is_charging = false
var charge_ready = true
var charge_ratio = 1
var charging_ratio = 1
var direction = Vector2.ZERO
var health = 3

@onready var player = $/root/Game/Player

func _process(delta):
	direction += player_weight * global_position.direction_to(player.global_position)
	direction /= direction.length()
	velocity = direction * SPEED * charge_ratio * charging_ratio
	if not is_charging and charge_ratio >= 1:
		charge_ratio -= delta * CHARGE_DECELERATION
	elif charge_ratio < 1:
		charge_ratio = 1
	if not is_charging and player_weight <= 1:
		player_weight += delta * PLAYER_FOLLOW_INCREASE
	elif player_weight > 1:
		player_weight = 1
	for body in $ChargeArea.get_overlapping_bodies():
		if body.is_in_group("Player") and charge_ready:
			charging_ratio = -0.3
			charge_ready = false
			$ChargingTimer.start()
	move_and_slide()


func _on_charging_timer_timeout():
	charging_ratio = 1
	charge_ratio = 2.5
	is_charging = true
	player_weight = 0.01
	$ChargeDuration.start()
	$ChargeCooldown.start()


func _on_charge_duration_timeout():
	is_charging = false


func _on_charge_cooldown_timeout():
	charge_ready = true
