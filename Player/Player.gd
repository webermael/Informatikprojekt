extends CharacterBody2D

const SPEED = 750.0
var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
var last_movement = input_direction.angle()
var stab_ready = true
var stab_released = true
var bullet_ready = true
var hit_enemy = false
var health = 5
signal player_died


# Toggling off the stab sprite after a certain time frame
func _on_stab_duration_timeout():
	$Stab.visible = false
	$Stab/StabCollision.disabled = true


# making the stab available again
func _on_stab_cooldown_timeout():
	stab_ready = true


# making the ranged attack available again
func _on_bullet_cooldown_timeout():
	if hit_enemy:
		bullet_ready = true
		$PlayerSprite.texture = load("res://Player/Full_Sheet.png")


# take damage if an enemie touches the players hitbox
func _on_hitbox_body_entered(body):
	if body.is_in_group("Hurtful") and $Hitbox/HitboxCollision.scale.x == 1:
		health -= 1
		$Hitbox/HitboxCollision.scale.x = 0.9
		$ImmunityFrames.start()
		$UI_Layer/Healthbar.value = health
		if health == 0:
			player_died.emit()
			#get_tree().paused = true


# making the player vulnerable to damage again after being hit
func _on_immunity_frames_timeout():
	$Hitbox/HitboxCollision.scale.x = 1


# Moving the player according to the input direction
func move():
	velocity = input_direction * SPEED
	if velocity.length() != 0:
		$AnimationPlayer.current_animation = "Walk"
	else:
		$AnimationPlayer.current_animation = "Idle"
	if velocity[0] < 0:
		$PlayerSprite.flip_h = false
	elif velocity[0] > 0:
		$PlayerSprite.flip_h = true
	move_and_slide()


# check if the player is pressing the stab button and innitiates a stab in the direction of the player's current movement
func stab():
	if Input.is_action_pressed("ui_melee_attack") and stab_ready and stab_released:
		if last_movement > PI / 2 and last_movement < 1.5 * PI:
			$Stab/StabSprite.flip_v = false
		else:
			$Stab/StabSprite.flip_v = true
		$Stab.rotation = last_movement - PI / 2
		$Stab.visible = true
		$Stab/StabCollision.disabled = false
		stab_released = false
		stab_ready = false
		$StabDuration.start()
		$StabCooldown.start()
	if Input.is_action_just_released("ui_melee_attack"):
		stab_released = true


# checks if the player is pressing the ranged attack button and shoots a bullet in the direction of movement
func shoot():
	if Input.is_action_pressed("ui_ranged_attack") and bullet_ready:
		$ShootingPivot.rotation = last_movement
		var bullet = preload("res://Player/weapons/Bullet/Bullet.tscn").instantiate() 
		bullet.global_position = $ShootingPivot/ShootingPoint.global_position
		bullet.rotation = $ShootingPivot.rotation
		$/root/Game.add_child(bullet) 
		hit_enemy = false
		bullet_ready = false
		$BulletCooldown.start()
		$PlayerSprite.texture = load("res://Player/Empty_Sheet.png")


# called every frame that handles attacks and movement
func _process(delta):
	input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_direction.length() != 0:
		last_movement = input_direction.angle()
	if health > 0:
		stab()
		shoot()
		move()

