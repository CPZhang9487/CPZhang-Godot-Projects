@tool
extends Control


@export_range(-90, 90) var cube_rotation_x := 0.0:
	set(value):
		value = clamp(value, -90, 90)
		cube_rotation_x = value
		_update_cube_rotation()
@export_range(-180, 180) var cube_rotation_y := 0.0:
	set(value):
		value = wrap(value, -180, 180)
		cube_rotation_y = value
		_update_cube_rotation()


@onready var magic_cube_3x3x3: MagicCube3x3x3 = %MagicCube3x3x3
@onready var cube_looker: CubeLooker = %CubeLooker


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if not event.pressed:
			if event.keycode == KEY_R:
				magic_cube_3x3x3.turn("R")
			elif event.keycode == KEY_U:
				magic_cube_3x3x3.turn("U")
			elif event.keycode == KEY_F:
				magic_cube_3x3x3.turn("F")
			elif event.keycode == KEY_L:
				magic_cube_3x3x3.turn("L")
			elif event.keycode == KEY_D:
				magic_cube_3x3x3.turn("D")
			elif event.keycode == KEY_B:
				magic_cube_3x3x3.turn("B")


func _on_sub_viewport_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			cube_rotation_x += event.relative.y
			cube_rotation_y += event.relative.x


func _update_cube_rotation() -> void:
	if not is_node_ready():
		await ready
	magic_cube_3x3x3.rotation = Vector3.ZERO
	magic_cube_3x3x3.rotation.x = deg_to_rad(cube_rotation_x)
	magic_cube_3x3x3.rotation.y = deg_to_rad(cube_rotation_y)
