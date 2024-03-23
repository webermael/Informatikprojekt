extends CharacterBody2D

const SPEED = 400.0
var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
var last_movement = input_direction.angle()
var stab_ready = true
var bullet_ready = true
var health = 5


func _on_stab_duration_timeout():
	$Stab.visible = false
	$Stab/StabCollision.disabled = true


func _on_stab_cooldown_timeout():
	stab_ready = true


func _on_bullet_cooldown_timeout():
	bullet_ready = true


func _on_hitbox_body_entered(body):
	if body.is_in_group("Enemies") and $Hitbox/HitboxCollision.scale.x == 1:
		health -= 1
		$Hitbox/HitboxCollision.scale.x = 0.9
		$ImmunityFrames.start()
		$"UI_Layer/Healthbar".value = health
		if health == 0:
			get_tree().paused = true


func _on_immunity_frames_timeout():
		$Hitbox/HitboxCollision.scale.x = 1


func move():
	velocity = input_direction * SPEED
	move_and_slide()


func _process(delta):
	input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	
	if input_direction.length() != 0:
		last_movement = input_direction.angle()
		
	if Input.is_action_pressed("ui_melee_attack") and stab_ready:
		$Stab.rotation = last_movement - PI / 2
		$Stab.visible = true
		$Stab/StabCollision.disabled = false
		stab_ready = false
		$StabDuration.start()
		$StabCooldown.start()
	
	if Input.is_action_pressed("ui_ranged_attack") and bullet_ready:
		$ShootingPivot.rotation = last_movement
		var Bullet = preload("res://Player/weapons/Bullet/Bullet.tscn").instantiate() 
		Bullet.global_position = $ShootingPivot/ShootingPoint.global_position
		Bullet.rotation = $ShootingPivot.rotation
		$ShootingPivot/ShootingPoint.add_child(Bullet) 
		bullet_ready = false
		$BulletCooldown.start()
	
	
