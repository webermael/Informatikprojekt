extends Node2D

const NUMBER_DIRECTION = {0 : "up", 1 : "right", 2 : "down", 3 : "left"}
var walls_placed = {0 : false, 1 : false, 2 : false, 3 : false}


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


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func _on_room_inside_body_entered(body):
	if body.is_in_group("Player"):
		$/root/Game/RoomCamera.global_position = $CameraCenter.global_position
