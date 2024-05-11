@tool
class_name CubeLooker
extends Node3D


@export var cube_size := 1.0:
	set(value):
		cube_size = value
		_update_cameras_position()
		_update_cameras_size()
@export_group("Image")
@export var image_size := Vector2i(4, 3)
@export var right_image_cube_coord := Vector2i(2, 1)
@export var up_image_cube_coord := Vector2i(1, 0)
@export var front_image_cube_coord := Vector2i(1, 1)
@export var left_image_cube_coord := Vector2i(0, 1)
@export var down_image_cube_coord := Vector2i(1, 2)
@export var back_image_cube_coord := Vector2i(3, 1)
@export var _save_cube_image := false:
	set(value):
		save_cube_image()
@export_group("Viewport")
@export var viewport_size := Vector2i(512, 512):
	set(value):
		viewport_size = value
		_update_sub_viewports_size()
@export_subgroup("Camera")
@export var cameras_near := 0.05:
	set(value):
		cameras_near = value
		_update_cameras_near()
@export_subgroup("Right", "right_camera")
@export var right_camera_base_position := Vector3(1, 0, 0):
	set(value):
		right_camera_base_position = value
		_update_cameras_position()
@export var right_camera_rotation := Vector3(0, PI / 2, 0):
	set(value):
		right_camera_rotation = value
		_update_cameras_rotation()
@export_subgroup("Up", "up_camera")
@export var up_camera_base_position := Vector3(0, 1, 0):
	set(value):
		up_camera_base_position = value
		_update_cameras_position()
@export var up_camera_rotation := Vector3(-PI / 2, 0, 0):
	set(value):
		up_camera_rotation = value
		_update_cameras_rotation()
@export_subgroup("Front", "front_camera")
@export var front_camera_base_position := Vector3(0, 0, 1):
	set(value):
		front_camera_base_position = value
		_update_cameras_position()
@export var front_camera_rotation := Vector3(0, 0, 0):
	set(value):
		front_camera_rotation = value
		_update_cameras_rotation()
@export_subgroup("Left", "left_camera")
@export var left_camera_base_position := Vector3(-1, 0, 0):
	set(value):
		left_camera_base_position = value
		_update_cameras_position()
@export var left_camera_rotation := Vector3(0, -PI / 2, 0):
	set(value):
		left_camera_rotation = value
		_update_cameras_rotation()
@export_subgroup("Down", "down_camera")
@export var down_camera_base_position := Vector3(0, -1, 0):
	set(value):
		down_camera_base_position = value
		_update_cameras_position()
@export var down_camera_rotation := Vector3(PI / 2, 0, 0):
	set(value):
		down_camera_rotation = value
		_update_cameras_rotation()
@export_subgroup("Back", "back_camera")
@export var back_camera_base_position := Vector3(0, 0, -1):
	set(value):
		back_camera_base_position = value
		_update_cameras_position()
@export var back_camera_rotation := Vector3(0, PI, 0):
	set(value):
		back_camera_rotation = value
		_update_cameras_rotation()


func _ready() -> void:
	var sub_viewport_container := SubViewportContainer.new()
	sub_viewport_container.name = "sub_viewport_container"
	sub_viewport_container.visible = false
	for face_name in MagicCube1x1x1.FACE_NAMES:
		var sub_viewport := SubViewport.new()
		sub_viewport.name = face_name + "_sub_viewport"
		sub_viewport.size = viewport_size
		var camera_3d := Camera3D.new()
		camera_3d.name = face_name + "_camera_3d"
		camera_3d.near = cameras_near
		camera_3d.projection = Camera3D.PROJECTION_ORTHOGONAL
		sub_viewport.add_child(camera_3d)
		sub_viewport_container.add_child(sub_viewport)
	add_child(sub_viewport_container)

	_update_cameras_position()
	_update_cameras_rotation()
	_update_cameras_size()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_SPACE and not event.pressed:
			save_cube_image()


func save_cube_image() -> void:
	var sub_viewport_container: SubViewportContainer = get_node("sub_viewport_container")
	sub_viewport_container.position -= sub_viewport_container.size
	sub_viewport_container.visible = true
	await RenderingServer.frame_post_draw
	var image := Image.create(image_size.x * viewport_size.x, image_size.y * viewport_size.y, false, Image.FORMAT_RGBA8)
	for face_name in MagicCube1x1x1.FACE_NAMES:
		var cube_image: Image = sub_viewport_container.get_node(face_name + "_sub_viewport").get_texture().get_image()
		cube_image.convert(image.get_format())
		image.blit_rect(
			cube_image,
			Rect2i(Vector2.ZERO, viewport_size),
			get(face_name + "_image_cube_coord") * viewport_size
		)
	image.save_png("res://Tools/CubeLooker/cube.png")
	sub_viewport_container.position += sub_viewport_container.size
	sub_viewport_container.visible = false


func _update_cameras_near() -> void:
	if not is_node_ready():
		await ready
	for face_name in MagicCube1x1x1.FACE_NAMES:
		var camera_3d: Camera3D = get_node("sub_viewport_container/" + face_name + "_sub_viewport/" + face_name + "_camera_3d")
		camera_3d.near = cameras_near


func _update_cameras_position() -> void:
	if not is_node_ready():
		await ready
	for face_name in MagicCube1x1x1.FACE_NAMES:
		var camera_3d: Camera3D = get_node("sub_viewport_container/" + face_name + "_sub_viewport/" + face_name + "_camera_3d")
		camera_3d.position = cube_size * get(face_name + "_camera_base_position") * (cube_size / 2 + cameras_near + 0.001)


func _update_cameras_rotation() -> void:
	if not is_node_ready():
		await ready
	for face_name in MagicCube1x1x1.FACE_NAMES:
		var camera_3d: Camera3D = get_node("sub_viewport_container/" + face_name + "_sub_viewport/" + face_name + "_camera_3d")
		camera_3d.rotation = get(face_name + "_camera_rotation")


func _update_cameras_size() -> void:
	if not is_node_ready():
		await ready
	for face_name in MagicCube1x1x1.FACE_NAMES:
		var camera_3d: Camera3D = get_node("sub_viewport_container/" + face_name + "_sub_viewport/" + face_name + "_camera_3d")
		camera_3d.size = cube_size


func _update_sub_viewports_size() -> void:
	if not is_node_ready():
		await ready
	for face_name in MagicCube1x1x1.FACE_NAMES:
		var sub_viewport: SubViewport = get_node("sub_viewport_container/" + face_name + "_sub_viewport/")
		sub_viewport.size = viewport_size
