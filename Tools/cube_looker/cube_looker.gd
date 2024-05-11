@tool
extends Node3D


@export var cube_size := 1.0:
	set(value):
		cube_size = value
		_update_cameras_position()
		_update_cameras_size()
@export var _save_cube_image := false:
	set(value):
		save_cube_image()


@onready var right_sub_viewport: SubViewport = %RightSubViewport
@onready var right_camera_3d: Camera3D = %RightCamera3D
@onready var up_sub_viewport: SubViewport = %UpSubViewport
@onready var up_camera_3d: Camera3D = %UpCamera3D
@onready var front_sub_viewport: SubViewport = %FrontSubViewport
@onready var front_camera_3d: Camera3D = %FrontCamera3D
@onready var left_sub_viewport: SubViewport = %LeftSubViewport
@onready var left_camera_3d: Camera3D = %LeftCamera3D
@onready var down_sub_viewport: SubViewport = %DownSubViewport
@onready var down_camera_3d: Camera3D = %DownCamera3D
@onready var back_sub_viewport: SubViewport = %BackSubViewport
@onready var back_camera_3d: Camera3D = %BackCamera3D


func _ready() -> void:
	_update_cameras_position()


func save_cube_image() -> void:
	var image := Image.create(512 * 4, 512 * 3, false, Image.FORMAT_RGBA8)
	var right := right_sub_viewport.get_texture().get_image()
	right.convert(Image.FORMAT_RGBA8)
	image.blit_rect(right, Rect2i(0, 0, 512, 512), Vector2(512 * 2, 512))
	var up := up_sub_viewport.get_texture().get_image()
	up.convert(Image.FORMAT_RGBA8)
	image.blit_rect(up, Rect2i(0, 0, 512, 512), Vector2(512, 0))
	var front := front_sub_viewport.get_texture().get_image()
	front.convert(Image.FORMAT_RGBA8)
	image.blit_rect(front, Rect2i(0, 0, 512, 512), Vector2(512, 512))
	var left := left_sub_viewport.get_texture().get_image()
	left.convert(Image.FORMAT_RGBA8)
	image.blit_rect(left, Rect2i(0, 0, 512, 512), Vector2(0, 512))
	var down := down_sub_viewport.get_texture().get_image()
	down.convert(Image.FORMAT_RGBA8)
	image.blit_rect(down, Rect2i(0, 0, 512, 512), Vector2(512, 512 * 2))
	var back := back_sub_viewport.get_texture().get_image()
	back.convert(Image.FORMAT_RGBA8)
	image.blit_rect(back, Rect2i(0, 0, 512, 512), Vector2(512 * 3, 512))
	image.save_png("res://Tools/cube_looker/cube.png")


func _update_cameras_position() -> void:
	if not is_node_ready():
		await ready
	right_camera_3d.position = Vector3(1.001, 0, 0) * (cube_size / 2 + right_camera_3d.near + 0.001)
	up_camera_3d.position = Vector3(0, 1.001, 0) * (cube_size / 2 + up_camera_3d.near + 0.001)
	front_camera_3d.position = Vector3(0, 0, 1.001) * (cube_size / 2 + front_camera_3d.near + 0.001)
	left_camera_3d.position = Vector3(-1.001, 0, 0) * (cube_size / 2 + left_camera_3d.near + 0.001)
	down_camera_3d.position = Vector3(0, -1.001, 0) * (cube_size / 2 + down_camera_3d.near + 0.001)
	back_camera_3d.position = Vector3(0, 0, -1.001) * (cube_size / 2 + back_camera_3d.near + 0.001)


func _update_cameras_size() -> void:
	if not is_node_ready():
		await ready
	right_camera_3d.size = cube_size
	up_camera_3d.size = cube_size
	front_camera_3d.size = cube_size
	left_camera_3d.size = cube_size
	down_camera_3d.size = cube_size
	back_camera_3d.size = cube_size
