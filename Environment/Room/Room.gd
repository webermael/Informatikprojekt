extends Node2D

const NUMBER_DIRECTION = {0 : "up", 1 : "right", 2 : "down", 3 : "left"}
var walls_placed = {0 : false, 1 : false, 2 : false, 3 : false}
var enemies_in_room = Array ()
@onready var spawnpoints = [$Spawnpoint1, $Spawnpoint2, $Spawnpoint3, $Spawnpoint4, $Spawnpoint5]


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


func spawn_enemy():
	while enemies_in_room.size() < randi() % 2 + 2:
		var new_enemy = preload("res://Enemies/Roller/Roller.tscn").instantiate()
		var spawnpoint = randi() % spawnpoints.size()
		new_enemy.position = spawnpoints[spawnpoint].position
		new_enemy.spawnposition = spawnpoints[spawnpoint].position
		spawnpoints.remove_at(spawnpoint)
		add_child(new_enemy)
		enemies_in_room.append(new_enemy)


func enemy_died(enemy):
	enemies_in_room.erase(enemy)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_room_inside_body_entered(body):
	if body.is_in_group("Player"):
		$/root/Game/RoomCamera.global_position = $CameraCenter.global_position
		for enemy in enemies_in_room:
			enemy.player_in_room = true
			enemy.position = enemy.spawnposition
			

func _on_room_inside_body_exited(body):
	if body.is_in_group("Player"):
		for enemy in enemies_in_room:
			enemy.player_in_room = false
