extends CharacterBody2D

const SPEED = 400.0
var Last_Movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
var Stab_Ready = true
var health = 5

func _on_stab_duration_timeout():
	$Stab.visible = false
	$Stab/StabCollision.disabled = true

func _on_stab_cooldown_timeout():
	Stab_Ready = true

func _on_hitbox_body_entered(body):
	if body.is_in_group("Enemies") and $Hitbox/HitboxCollision.scale.x == 1:
		health -= 1
		$Hitbox/HitboxCollision.scale.x = 0.9
		$ImmunityFrames.start()
		$"../Healthbar".value = health
		if health == 0:
			get_tree().paused = true



func _on_immunity_frames_timeout():
		$Hitbox/HitboxCollision.scale.x = 1

func _physics_process(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * SPEED
	
	if input_direction.length() != 0:
		Last_Movement = input_direction
		
	if Input.is_action_pressed("ui_attack") and Stab_Ready:
		$Stab.rotation = Last_Movement.angle() - PI / 2
		$Stab.visible = true
		$Stab/StabCollision.disabled = false
		Stab_Ready = false
		$StabDuration.start()
		$StabCooldown.start()
		
	move_and_slide()
