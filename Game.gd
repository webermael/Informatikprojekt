extends Node2D

var in_cleared_room = true
var song_positions = {
load("res://Music/room_clear_normal.mp3") : 0, 
load("res://Music/room_clear_low.mp3") : 0, 
load("res://Music/Main.mp3") : 0,
load("res://Music/Main_Low.mp3") : 0
}


func change_song(delta, song, low_song, fade = 80, instant = false, stream_player = $AudioStreamPlayer, not_stream_player = $Low):
	if not instant and $AudioStreamPlayer.stream != song and $AudioStreamPlayer.volume_db <= 0:
		if stream_player.volume_db <= -40 and $AudioStreamPlayer.stream != song:
			song_positions[$AudioStreamPlayer.stream] = $AudioStreamPlayer.get_playback_position()
			$AudioStreamPlayer.stream = song
			$AudioStreamPlayer.play(song_positions[song])
		elif $AudioStreamPlayer.volume_db < 0 and stream_player.stream == song:
			$AudioStreamPlayer.volume_db += delta * fade
		else:
			$AudioStreamPlayer.volume_db -= delta * fade
	elif instant and $AudioStreamPlayer.stream != song:
		song_positions[$AudioStreamPlayer.stream] = $AudioStreamPlayer.get_playback_position()
		$AudioStreamPlayer.stream = song
		$AudioStreamPlayer.play(song_positions[song])
	elif stream_player.volume_db != 0:
		stream_player.volume_db = 0


func _process(delta):
	if in_cleared_room and $Player.health > 2:
		change_song(delta, load("res://Music/room_clear_normal.mp3"), load("res://Music/room_clear_low.mp3"))
	elif in_cleared_room and $Player.health <= 2:
		change_song(delta, load("res://Music/room_clear_low.mp3"), load("res://Music/room_clear_low.mp3"), 80, false, $AudioStreamPlayer, $Normal)
	elif not in_cleared_room and $Player.health > 2:
		change_song(delta, load("res://Music/Main.mp3"), load("res://Music/Main_Low.mp3"), 0, true)
	elif not in_cleared_room and $Player.health <= 2:
		change_song(delta, load("res://Music/Main_Low.mp3"), load("res://Music/Main_Low.mp3"), 0, true, $AudioStreamPlayer, $Normal)


func _on_dungeon_room_cleared():
	in_cleared_room = true


func _on_dungeon_room_entered():
	in_cleared_room = false
