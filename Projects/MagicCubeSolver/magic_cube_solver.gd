@tool
extends Control


@export_range(-90, 90) var camera_anchor_rotation_x := 0.0:
	set(value):
		value = clamp(value, -90, 90)
		camera_anchor_rotation_x = value
		_update_camara_anchor_rotation()
@export_range(-180, 180) var camera_anchor_rotation_y := 0.0:
	set(value):
		value = wrap(value, -180, 180)
		camera_anchor_rotation_y = value
		_update_camara_anchor_rotation()


@onready var camera_anchor: Node3D = %CameraAnchor
@onready var magic_cube_3x3x3: MagicCube3x3x3 = %MagicCube3x3x3


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if not event.pressed:
			if event.keycode == KEY_R:
				magic_cube_3x3x3.turn(MagicCube3x3x3.TurnCode.R)
			elif event.keycode == KEY_U:
				magic_cube_3x3x3.turn(MagicCube3x3x3.TurnCode.U)
			elif event.keycode == KEY_F:
				magic_cube_3x3x3.turn(MagicCube3x3x3.TurnCode.F)
			elif event.keycode == KEY_L:
				magic_cube_3x3x3.turn(MagicCube3x3x3.TurnCode.L)
			elif event.keycode == KEY_D:
				magic_cube_3x3x3.turn(MagicCube3x3x3.TurnCode.D)
			elif event.keycode == KEY_B:
				magic_cube_3x3x3.turn(MagicCube3x3x3.TurnCode.B)


func _on_sub_viewport_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			camera_anchor_rotation_x -= event.relative.y
			camera_anchor_rotation_y -= event.relative.x


func _update_camara_anchor_rotation() -> void:
	if not is_node_ready():
		await ready
	camera_anchor.rotation = Vector3.ZERO
	camera_anchor.rotation.x = deg_to_rad(camera_anchor_rotation_x)
	camera_anchor.rotation.y = deg_to_rad(camera_anchor_rotation_y)
