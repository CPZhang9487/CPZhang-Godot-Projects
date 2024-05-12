@tool
extends Control


@export_range(-90, 90) var cube_rotation_x := 0.0:
	set(value):
		value = wrap(value, -90, 90)
		cube_rotation_x = value
		_update_cube_rotation()
@export_range(-180, 180) var cube_rotation_y := 0.0:
	set(value):
		value = wrap(value, -180, 180)
		cube_rotation_y = value
		_update_cube_rotation()


@onready var magic_cube_3x3x3: MagicCube3x3x3 = %MagicCube3x3x3
@onready var cube_looker: CubeLooker = %CubeLooker


func _update_cube_rotation() -> void:
	if not is_node_ready():
		await ready
	magic_cube_3x3x3.rotation = Vector3.ZERO
	magic_cube_3x3x3.rotation.y = deg_to_rad(cube_rotation_y)
	magic_cube_3x3x3.rotation = magic_cube_3x3x3.rotation.rotated(Vector3(1, 0, 0).rotated(Vector3(0, 1, 0), deg_to_rad(cube_rotation_y)), deg_to_rad(cube_rotation_x))
