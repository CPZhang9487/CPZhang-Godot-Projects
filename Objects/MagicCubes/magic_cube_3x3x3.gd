@tool
class_name MagicCube3x3x3
extends Node3D

@export var color := Color.BLACK: set = set_color
@export var size := 1.0: set = set_size
@export_group("Face")
@export_subgroup("Right", "right")
@export var right_color := Color.DARK_ORANGE:
	set(value):
		right_color = value
		_update_faces_color()
@export_subgroup("Up", "up")
@export var up_color := Color.YELLOW:
	set(value):
		up_color = value
		_update_faces_color()
@export_subgroup("Front", "front")
@export var front_color := Color.GREEN:
	set(value):
		front_color = value
		_update_faces_color()
@export_subgroup("Left", "left")
@export var left_color := Color.RED:
	set(value):
		left_color = value
		_update_faces_color()
@export_subgroup("Down", "down")
@export var down_color := Color.WHITE:
	set(value):
		down_color = value
		_update_faces_color()
@export_subgroup("Back", "back")
@export var back_color := Color.BLUE:
	set(value):
		back_color = value
		_update_faces_color()


func _ready() -> void:
	for x in range(-1, 2):
		for y in range(-1, 2):
			for z in range(-1, 2):
				var cube111 := MagicCube1x1x1.new()
				cube111.position = Vector3(x, y, z) / 3.0
				cube111.size = Vector3.ONE * size / 3.0
				cube111.right_visible = x == 1
				cube111.up_visible = y == 1
				cube111.front_visible = z == 1
				cube111.left_visible = x == -1
				cube111.down_visible = y == -1
				cube111.back_visible = z == -1
				add_child(cube111)



func set_color(value: Color) -> void:
	color = value
	if not is_node_ready():
		await ready
	for child in get_children():
		if child is MagicCube1x1x1:
			child.color = value


func set_size(value: float) -> void:
	var old_size: float = size
	size = value
	if not is_node_ready():
		await ready
	for child in get_children(true):
		if child is MagicCube1x1x1:
			child.position *= value / old_size
			child.size = Vector3.ONE * value / 3.0


func _update_faces_color() -> void:
	if not is_node_ready():
		await ready
	for child in get_children(true):
		if child is MagicCube1x1x1:
			for face_name in MagicCube1x1x1.FACE_NAMES:
				child.set(face_name + "_color", get(face_name + "_color"))
