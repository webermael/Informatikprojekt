extends Node2D

var rooms = Array ()
var room_coordinates = Array ()
var place = Vector2.ZERO
var rooms_placed = 0
const NUMBER_DIRECTION = {0 : "up", 1 : "right", 2 : "down", 3 : "left"}
const HEIGHT = 1080
const WIDTH = 1920
const ROOMS = 8
const ROOMS_TO_FINISH = 8


func new_place(direction, new_place):
	if direction == 0:
		new_place[1] -= HEIGHT
	elif direction == 1:
		new_place[0] += WIDTH
	elif direction == 2:
		new_place[1] += HEIGHT
	elif direction == 3:
		new_place[0] -= WIDTH
	return new_place

func place_room(place, direction, parent_room):
	var new_room = preload("res://Environment/Room/Room.tscn").instantiate()
	new_room.global_position = place
	room_coordinates.append(place)
	add_child(new_room)
	parent_room.place_door(direction)
	rooms.append(new_room)
	print(room_coordinates)
	new_room.place_door(direction + 2)
	rooms_placed += 1


func generate():
	var first_room = preload("res://Environment/Room/Room.tscn").instantiate()
	first_room.global_position = Vector2.ZERO
	add_child(first_room)
	rooms.append(first_room)
	room_coordinates.append(first_room.global_position)
	
	while rooms_placed < ROOMS_TO_FINISH:
		var direction = randi() % 4
		if new_place(direction, place) not in room_coordinates:
			place_room(new_place(direction, place), direction, rooms[-1])
			place = new_place(direction, place)
	
	var start_room = rooms[0]
	var end_room = rooms[-1]
	while rooms_placed < ROOMS:
		var parent_room = rooms[randi() % (rooms.size() - 1) + 1]
		place = parent_room.global_position
		var direction = randi() % 4
		if new_place(direction, place) not in room_coordinates and parent_room != end_room:
			place_room(new_place(direction, place), direction, parent_room)
			
	
	for room in rooms:
		for wall in range(4):
			if not room.walls_placed[wall]:
				room.place_wall(wall)
	
	for room in rooms:
		if room != start_room and room != end_room:
			room.spawn_enemy()
	

	
func _ready():
	generate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
