extends CharacterBody2D

const SPEED = 300.0

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * SPEED
	if input_direction.length() != 0:
		var Last_Movement = input_direction
		$Stab.rotation = Last_Movement.angle() - PI / 2
	if Input.is_action_pressed("ui_attack"):
		$Stab.visible = true
		$StabDuration.start()

func _on_stab_duration_timeout():
	$Stab.visible = false
	
func _physics_process(delta):
	get_input()
	move_and_slide()
