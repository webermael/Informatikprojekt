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


# returns the coordinates of a location that is one screensize into the direction given
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


# adds a room in the direction given (from the parent room) also connects the two through a pair of entryways
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


# generates the dungeon by adding rooms and adding walls and entrances to the rooms
func generate():
	# sets up the first room of the dungeon
	var first_room = preload("res://Environment/Room/Room.tscn").instantiate()
	first_room.global_position = Vector2.ZERO
	add_child(first_room)
	rooms.append(first_room)
	room_coordinates.append(first_room.global_position)
	# adds rooms in random directions in a straight line until a certain number of rooms have been placed
	while rooms_placed < ROOMS_TO_FINISH:
		var direction = randi() % 4
		if new_place(direction, place) not in room_coordinates:
			place_room(new_place(direction, place), direction, rooms[-1])
			place = new_place(direction, place)
	# sets first and last room from the straight path
	var start_room = rooms[0]
	var end_room = rooms[-1]
	# chooses a random room and attaches a room in a random direction until a certain number of rooms have been placed
	while rooms_placed < ROOMS:
		var parent_room = rooms[randi() % (rooms.size() - 1) + 1]
		place = parent_room.global_position
		var direction = randi() % 4
		if new_place(direction, place) not in room_coordinates and parent_room != end_room:
			place_room(new_place(direction, place), direction, parent_room)
	# closes off all the rooms with walls, where there isn't already a entryway
	for room in rooms:
		for wall in range(4):
			if not room.walls_placed[wall]:
				room.place_wall(wall)
	# spawns a number of enemies in all the rooms except for the first and last room
	for room in rooms:
		if room != start_room and room != end_room:
			room.spawn_enemy(2, 4)


# called as soon as the dungeon is loaded, after which it generates all of the rooms
func _ready():
	generate()

