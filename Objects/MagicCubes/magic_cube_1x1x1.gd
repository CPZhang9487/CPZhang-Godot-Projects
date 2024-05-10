@tool
class_name MagicCube1x1x1
extends Node3D


const COLORED_SHADER: Shader = preload("res://Shaders/colored_shader.gdshader")
const FACE_NAMES: PackedStringArray = ["right", "up", "front", "left", "down", "back"]


@export var color := Color.BLACK: set = set_color
@export var size := Vector3.ONE: set = set_size
@export_group("Face")
@export_subgroup("Right", "right")
@export var right_color := Color.DARK_ORANGE:
	set(value):
		right_color = value
		_update_faces_color()
@export var right_position := Vector3(0.5, 0, 0):
	set(value):
		right_position = value
		_update_faces_position()
@export var right_size := Vector3(0.005, 0.9, 0.9):
	set(value):
		right_size = value
		_update_faces_size()
@export var right_visible := true:
	set(value):
		right_visible = value
		_update_faces_visible()
@export_subgroup("Up", "up")
@export var up_color := Color.YELLOW:
	set(value):
		up_color = value
		_update_faces_color()
@export var up_position := Vector3(0, 0.5, 0):
	set(value):
		up_position = value
		_update_faces_position()
@export var up_size := Vector3(0.9, 0.005, 0.9):
	set(value):
		up_size = value
		_update_faces_size()
@export var up_visible := true:
	set(value):
		up_visible = value
		_update_faces_visible()
@export_subgroup("Front", "front")
@export var front_color := Color.GREEN:
	set(value):
		front_color = value
		_update_faces_color()
@export var front_position := Vector3(0, 0, 0.5):
	set(value):
		front_position = value
		_update_faces_position()
@export var front_size := Vector3(0.9, 0.9, 0.005):
	set(value):
		front_size = value
		_update_faces_size()
@export var front_visible := true:
	set(value):
		front_visible = value
		_update_faces_visible()
@export_subgroup("Left", "left")
@export var left_color := Color.RED:
	set(value):
		left_color = value
		_update_faces_color()
@export var left_position := Vector3(-0.5, 0, 0):
	set(value):
		left_position = value
		_update_faces_position()
@export var left_size := Vector3(0.005, 0.9, 0.9):
	set(value):
		left_size = value
		_update_faces_size()
@export var left_visible := true:
	set(value):
		left_visible = value
		_update_faces_visible()
@export_subgroup("Down", "down")
@export var down_color := Color.WHITE:
	set(value):
		down_color = value
		_update_faces_color()
@export var down_position := Vector3(0, -0.5, 0):
	set(value):
		down_position = value
		_update_faces_position()
@export var down_size := Vector3(0.9, 0.005, 0.9):
	set(value):
		down_size = value
		_update_faces_size()
@export var down_visible := true:
	set(value):
		down_visible = value
		_update_faces_visible()
@export_subgroup("Back", "back")
@export var back_color := Color.BLUE:
	set(value):
		back_color = value
		_update_faces_color()
@export var back_position := Vector3(0, 0, -0.5):
	set(value):
		back_position = value
		_update_faces_position()
@export var back_size := Vector3(0.9, 0.9, 0.005):
	set(value):
		back_size = value
		_update_faces_size()
@export var back_visible := true:
	set(value):
		back_visible = value
		_update_faces_visible()


func _ready() -> void:
	var cube := MeshInstance3D.new()
	cube.mesh = BoxMesh.new()
	cube.mesh.material = ShaderMaterial.new()
	cube.mesh.material.shader = COLORED_SHADER
	cube.mesh.material.set_shader_parameter("color", color)
	cube.mesh.size = size
	cube.name = "cube"
	add_child(cube)

	for face_name in FACE_NAMES:
		var face := MeshInstance3D.new()
		face.mesh = BoxMesh.new()
		face.mesh.material = ShaderMaterial.new()
		face.mesh.material.shader = COLORED_SHADER
		face.mesh.material.set_shader_parameter("color", get(face_name + "_color"))
		face.mesh.size = get(face_name + "_size")
		face.name = face_name
		face.position = get(face_name + "_position")
		face.visible = get(face_name + "_visible")
		cube.add_child(face)


func set_color(value: Color) -> void:
	color = value
	if not is_node_ready():
		await ready
	var cube: MeshInstance3D = get_node("cube")
	cube.mesh.material.set_shader_parameter("color", value)


func set_size(value: Vector3) -> void:
	var old_size: Vector3 = size
	size = value
	if not is_node_ready():
		await ready
	var cube: MeshInstance3D = get_node("cube")
	cube.mesh.size = value
	for face_name in FACE_NAMES:
		set(face_name + "_position", get(face_name + "_position") * value / old_size)
		set(face_name + "_size", get(face_name + "_size") * value / old_size)


func _update_faces_color() -> void:
	if not is_node_ready():
		await ready
	for face_name in FACE_NAMES:
		var face: MeshInstance3D = get_node("cube/" + face_name)
		face.mesh.material.set_shader_parameter("color", get(face_name + "_color"))


func _update_faces_position() -> void:
	if not is_node_ready():
		await ready
	for face_name in FACE_NAMES:
		var face: MeshInstance3D = get_node("cube/" + face_name)
		face.position = get(face_name + "_position")


func _update_faces_size() -> void:
	if not is_node_ready():
		await ready
	for face_name in FACE_NAMES:
		var face: MeshInstance3D = get_node("cube/" + face_name)
		face.mesh.size = get(face_name + "_size")


func _update_faces_visible() -> void:
	if not is_node_ready():
		await ready
	for face_name in FACE_NAMES:
		var face: MeshInstance3D = get_node("cube/" + face_name)
		face.visible = get(face_name + "_visible")
