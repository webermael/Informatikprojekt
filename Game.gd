extends Node2D

var in_cleared_room = true


func change_song(delta, song, low_song, fade = 80, instant = false, stream_player = $Normal, not_stream_player = $Low):
	if not instant and $Normal.stream != song and stream_player.volume_db <= 0:
		print(stream_player.stream == song, stream_player.volume_db)
		if stream_player.volume_db <= -40 and $Normal.stream != song:
			$Normal.stream = song
			$Normal.play(0)
			$Low.stream = low_song
			$Low.play(0)
		elif stream_player.volume_db < 0 and stream_player.stream == song:
			stream_player.volume_db += delta * fade
		elif stream_player.volume_db > 0:
			stream_player.volume_db = 0
		else:
			print(stream_player.volume_db)
			stream_player.volume_db -= delta * fade
			print(stream_player.volume_db)
	elif instant and $Normal.stream != song:
		print(in_cleared_room, $Player.health, stream_player == $Low)
		$Normal.stream = song
		$Normal.play(0)
		$Low.stream = low_song
		$Low.play(0)
		not_stream_player.volume_db = -80
		stream_player.volume_db = 0
	elif stream_player.volume_db != 0:
		not_stream_player.volume_db = -80
		stream_player.volume_db = 0


func _process(delta):
	if in_cleared_room and $Player.health > 2:
		change_song(delta, load("res://Music/room_clear_normal.mp3"), load("res://Music/room_clear_low.mp3"))
	elif in_cleared_room and $Player.health <= 2:
		change_song(delta, load("res://Music/room_clear_normal.mp3"), load("res://Music/room_clear_low.mp3"), 80, false, $Low, $Normal)
	elif not in_cleared_room and $Player.health > 2:
		change_song(delta, load("res://Music/Main.mp3"), load("res://Music/Main_Low.mp3"), 0, true)
	elif not in_cleared_room and $Player.health <= 2:
		change_song(delta, load("res://Music/Main.mp3"), load("res://Music/Main_Low.mp3"), 0, true, $Low, $Normal)


func _on_dungeon_room_cleared():
	in_cleared_room = true


func _on_dungeon_room_entered():
	in_cleared_room = false
