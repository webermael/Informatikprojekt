extends Node2D

const NUMBER_DIRECTION = {0 : "up", 1 : "right", 2 : "down", 3 : "left"}
var enemy_pool = [preload("res://Enemies/Roller/Roller.tscn"), preload("res://Enemies/Dasher/Dasher.tscn")]
var walls_placed = {0 : false, 1 : false, 2 : false, 3 : false}
var enemies_in_room = Array ()
var floor_shift = Vector2 (randi() % 80, randi() % 40)
var floor_color = Color8(randi() % 150, randi() % 150, randi() % 150, 255)

@onready var spawnpoints = [$Spawnpoint1, $Spawnpoint2, $Spawnpoint3, $Spawnpoint4, $Spawnpoint5]


#places a wall with an opening in the direction of the room that is inputted (used for dungeon generation)
func place_door(direction):
	direction = direction % 4
	var new_door = false
	if NUMBER_DIRECTION[direction] == "up" and not walls_placed[direction]:
		new_door = preload("res://Environment/Doors/TopDoor.tscn").instantiate()
	elif NUMBER_DIRECTION[direction] == "right" and not walls_placed[direction]:
		new_door = preload("res://Environment/Doors/RightDoor.tscn").instantiate()
	elif NUMBER_DIRECTION[direction] == "down" and not walls_placed[direction]:
		new_door = preload("res://Environment/Doors/BottomDoor.tscn").instantiate()
	elif NUMBER_DIRECTION[direction] == "left" and not walls_placed[direction]:
		new_door = preload("res://Environment/Doors/LeftDoor.tscn").instantiate()
	if new_door:
		add_child(new_door)
		walls_placed[direction] = true


# places a full wall in the direction of the room that is inputted (used for dungeon generation)
func place_wall(direction):
	direction = direction % 4
	var new_wall = false
	if NUMBER_DIRECTION[direction] == "up" and not walls_placed[direction]:
		new_wall = preload("res://Environment/Walls/TopWall.tscn").instantiate()
	elif NUMBER_DIRECTION[direction] == "right" and not walls_placed[direction]:
		new_wall = preload("res://Environment/Walls/RightWall.tscn").instantiate()
	elif NUMBER_DIRECTION[direction] == "down" and not walls_placed[direction]:
		new_wall = preload("res://Environment/Walls/BottomWall.tscn").instantiate()
	elif NUMBER_DIRECTION[direction] == "left" and not walls_placed[direction]:
		new_wall = preload("res://Environment/Walls/LeftWall.tscn").instantiate()
	if new_wall:
		add_child(new_wall)
		walls_placed[direction] = true


# spawns a random amount of randomly chosen enemies (between the two parameters) at one of five random locations if it is unoccupied
func spawn_enemy(min_enemies, max_enemies):
	while enemies_in_room.size() < randi() % (max_enemies - min_enemies + 1) + min_enemies and spawnpoints.size() > 0:
		var enemy_type = randi() % enemy_pool.size()
		var new_enemy = enemy_pool[enemy_type].instantiate()
		var spawnpoint = randi() % spawnpoints.size()
		new_enemy.position = spawnpoints[spawnpoint].position
		new_enemy.spawnposition = spawnpoints[spawnpoint].position
		spawnpoints.remove_at(spawnpoint)
		add_child(new_enemy)
		enemies_in_room.append(new_enemy)


# removes any enemie that died from the list of enemies in the room
func enemy_died(enemy):
	enemies_in_room.erase(enemy)
	$/root/Game.points += 1
	if enemies_in_room.size() <= 0:
		get_parent().room_cleared.emit()


func pause_enemies():
	for enemy in enemies_in_room:
		enemy.player_in_room = false
		enemy.get_node("AnimationPlayer").active = false


func unpause_enemies():
	for enemy in enemies_in_room:
		enemy.player_in_room = true
		enemy.get_node("AnimationPlayer").active = true


# moves the camera to the room the player has entered, also tells all enemies in the room that the player has entered
# changes the color and position of the tile background attached to the player
# gives out a signal when there are still enemies in the room
func _on_room_inside_body_entered(body):
	if body.is_in_group("Player"):
		$/root/Game/RoomCamera.global_position = $CameraCenter.global_position
		get_parent().current_room = self
		if get_parent().end_room != null and get_parent().end_room == self:
			body.position = global_position + Vector2 (960, 540)
			$/root/Game.open_menu(false, false, true)
		body.get_node("Background").get_node("Background").offset = floor_shift
		body.get_node("Background").get_node("Overlay").modulate = floor_color
		if enemies_in_room.size() > 0:
			get_parent().room_entered.emit()
		for enemy in enemies_in_room:
			enemy.player_in_room = true


# tells the enemies in the room that the player has exited, so they stop moving
func _on_room_inside_body_exited(body):
	if body.is_in_group("Player"):
		for enemy in enemies_in_room:
			enemy.player_in_room = false
			enemy.position = enemy.spawnposition
