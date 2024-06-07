extends Node2D

var in_cleared_room = true


func change_song(delta, song, fade = 10, instant = false):
	if not instant:
		if $AudioStreamPlayer.volume_db <= -40 and $AudioStreamPlayer.stream != song:
			$AudioStreamPlayer.stream = song
			$AudioStreamPlayer.play(0)
		elif $AudioStreamPlayer.volume_db < 0 and $AudioStreamPlayer.stream == song:
			$AudioStreamPlayer.volume_db += delta * (abs($AudioStreamPlayer.volume_db) * fade + 1)
		elif $AudioStreamPlayer.volume_db > 0:
			$AudioStreamPlayer.volume_db = 0
		else:
			$AudioStreamPlayer.volume_db -= delta * (abs($AudioStreamPlayer.volume_db) * fade + 1)
	if instant and $AudioStreamPlayer.stream != song:
		$AudioStreamPlayer.stream = song
		$AudioStreamPlayer.play(0)


func _process(delta):
	if in_cleared_room and $Player.health > 2:
		change_song(delta, load("res://Music/room_clear_normal.mp3"))
	elif in_cleared_room and $Player.health <= 2:
		change_song(delta, load("res://Music/room_clear_low.mp3"))
	elif not in_cleared_room:
		change_song(delta, load("res://Music/Main.mp3"), 0, true)
		#$AudioStreamPlayer.stream = load("res://Music/Main.mp3")
		#$AudioStreamPlayer.play(0)
		#$AudioStreamPlayer.volume_db = 24


func _on_dungeon_room_cleared():
	in_cleared_room = true


func _on_dungeon_room_entered():
	in_cleared_room = false
