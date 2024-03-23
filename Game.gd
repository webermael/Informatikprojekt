extends Node2D


func spawn_enemy():
	var new_enemy = preload("res://Enemies/Roller/Roller.tscn").instantiate()
	$Player/Spawnpath/Spawnpoint.progress_ratio = randf()
	new_enemy.global_position = $Player/Spawnpath/Spawnpoint.global_position
	add_child(new_enemy)


func _on_spawn_timer_timeout():
	spawn_enemy()
