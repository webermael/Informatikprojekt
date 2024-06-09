extends Node2D

var in_cleared_room = true
var song_positions = {
load("res://Music/room_clear_normal.mp3") : 0, 
load("res://Music/room_clear_low.mp3") : 0, 
load("res://Music/Main.mp3") : 0,
load("res://Music/Main_Low.mp3") : 0
}
var points = 0


#changes the song, if instant = true there is no transition, otherwise the current song fades out and the new one fades in
func change_song(delta, song, fade = 80, instant = false):
	if not instant and $AudioStreamPlayer.stream != song and $AudioStreamPlayer.volume_db <= 0:
		if $AudioStreamPlayer.volume_db <= -40 and $AudioStreamPlayer.stream != song:
			song_positions[$AudioStreamPlayer.stream] = $AudioStreamPlayer.get_playback_position()
			$AudioStreamPlayer.stream = song
			$AudioStreamPlayer.play(song_positions[song])
		elif $AudioStreamPlayer.volume_db < 0 and $AudioStreamPlayer.stream == song:
			$AudioStreamPlayer.volume_db += delta * fade
		else:
			$AudioStreamPlayer.volume_db -= delta * fade
	elif instant and $AudioStreamPlayer.stream != song:
		song_positions[$AudioStreamPlayer.stream] = $AudioStreamPlayer.get_playback_position()
		$AudioStreamPlayer.stream = song
		$AudioStreamPlayer.play(song_positions[song])
	elif $AudioStreamPlayer.volume_db != 0:
		$AudioStreamPlayer.volume_db = 0


# opens/closes the menu when pressing "esc", always closes it when pressing the button in the menu
func open_menu(button_triggered = false, player_died = false, player_won = false):
	if Input.is_action_just_pressed("ui_cancel") or button_triggered or player_died or player_won:
		if not $Menu.visible:
			$Menu.visible = true
			$Player.in_menu = true
			# when the player dies, shows points and option to restart, resetting points
			if player_died:
				$Menu/ContinueBg.visible = false
				$Menu/RestartBg.visible = true
				$Menu/RestartBg/RestartButton.text = "Restart"
				$Menu/PointLabel.text = "You Got " + str(points) + " Points!"
				points = 0
			# after clearing a floor, gives the option to enter the next floor
			elif player_won:
				$Menu/ContinueBg.visible = false
				$Menu/RestartBg.visible = true
				$Menu/RestartBg/RestartButton.text = "Next Floor"
				$Menu/PointLabel.text = "Floor Cleared!"
			# on no special occasion, just shows a pause menu with the option to continue the game
			else:
				$Menu/ContinueBg.visible = true
				$Menu/RestartBg.visible = false
				$Menu/PointLabel.text = "Paused"
			$Dungeon.current_room.pause_enemies()
		# closes the menu if triggered by a button on screen, or by escape button while the menu is already open
		elif ($Menu.visible and $Menu/ContinueBg.visible) or button_triggered:
			$Menu.visible = false
			$Player.in_menu = false
			$Dungeon.current_room.unpause_enemies()


# checks for which song to play and whether the menu should be opened 
func _process(delta):
	if in_cleared_room and $Player.health > 2:
		change_song(delta, load("res://Music/room_clear_normal.mp3"))
	elif in_cleared_room and $Player.health <= 2:
		change_song(delta, load("res://Music/room_clear_low.mp3"))
	elif not in_cleared_room and $Player.health > 2:
		change_song(delta, load("res://Music/Main.mp3"), 0, true)
	elif not in_cleared_room and $Player.health <= 2:
		change_song(delta, load("res://Music/Main_Low.mp3"), 0, true)
	open_menu()


# received after the player beats the last enemy in a room, used to change the music
func _on_dungeon_room_cleared():
	in_cleared_room = true


# received when the player enters a room with enemies, used to change the music
func _on_dungeon_room_entered():
	in_cleared_room = false


# continues the game when pressing the "Continue" button in the menu
func _on_continue_button_pressed():
	open_menu(true)


# quits the game when pressing the "Quit" button in the menu
func _on_quit_button_pressed():
	get_tree().quit()


# closes menu, deletes the dungeon and generates a new one placing the player in the first room
func _on_restart_button_pressed():
	open_menu(true)
	$Dungeon.free()
	var new_dungeon = preload("res://Dungeon.tscn").instantiate()
	add_child(new_dungeon)
	$Player.global_position = Vector2 (960, 540)
	$RoomCamera.global_position = Vector2 (960, 540)
	$Player.reset()
	
