@tool
class_name MagicCube3x3x3
extends Node3D


@export var size := 1.0: set = set_size


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


func set_size(value: float) -> void:
	var old_size: float = size
	size = value
	if not is_node_ready():
		await ready
	for child in get_children(true):
		if child is MagicCube1x1x1:
			child.position *= value / old_size
			child.size = Vector3.ONE * value / 3.0
