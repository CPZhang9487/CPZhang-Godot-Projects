@tool
class_name MagicCube3x3x3
extends Node3D


signal turned


enum TurnCode {
	R,
	U,
	F,
	L,
	D,
	B,
}


enum TurnMode {
	NONE = 0,
	COUNTERCLOCKWISE = 1,
	DOUBLE = 2,
	W = 4,
}


const CUBE_SHADER: Shader = preload("res://Objects/MagicCubes/cube_shader.gdshader")
const FACE_NAMES: PackedStringArray = ["right", "up", "front", "left", "down", "back"]


@export_range(0, 1, 0.001, "or_greater", "suffix:s") var turn_animate_duration := 0.016
@export var color := Color.BLACK:
	set(value):
		color = value
		_update_colors()
@export_range(0, 1, 0.001, "or_greater") var size := 1.0:
	set(value):
		if value == 0:
			return
		var old_size := size
		size = value
		_update_positions_and_sizes(old_size)
@export_group("Face")
@export_subgroup("Right", "right")
@export var right_color := Color.DARK_ORANGE:
	set(value):
		right_color = value
		_update_colors()
@export_subgroup("Up", "up")
@export var up_color := Color.YELLOW:
	set(value):
		up_color = value
		_update_colors()
@export_subgroup("Front", "front")
@export var front_color := Color.GREEN:
	set(value):
		front_color = value
		_update_colors()
@export_subgroup("Left", "left")
@export var left_color := Color.RED:
	set(value):
		left_color = value
		_update_colors()
@export_subgroup("Down", "down")
@export var down_color := Color.WHITE:
	set(value):
		down_color = value
		_update_colors()
@export_subgroup("Back", "back")
@export var back_color := Color.BLUE:
	set(value):
		back_color = value
		_update_colors()


var _cube_data:PackedInt32Array = [0, 0, 0, 0, 0, 0]
var _is_turning := false


func _ready() -> void:
	_init_pivot()
	_init_cubes()
	_init_faces()


func get_cube_data() -> PackedInt32Array:
	return _cube_data


func get_cube_image() -> Image:
	var image_face_size := 18
	var image_border_size := 1
	var image_grid_size := image_border_size * 4 + image_face_size * 3
	var image := Image.create(
		4 * (image_grid_size),
		3 * (image_grid_size),
		false,
		Image.FORMAT_RGBA8
	)
	image.fill_rect(Rect2i(0, image_grid_size, image_grid_size * 4, image_grid_size), color)
	image.fill_rect(Rect2i(image_grid_size, 0, image_grid_size, image_grid_size * 3), color)
	const IMAGE_FACE_COORDS: PackedVector2Array = [
		Vector2(2, 1),
		Vector2(1, 0),
		Vector2(1, 1),
		Vector2(0, 1),
		Vector2(1, 2),
		Vector2(3, 1),
	]
	for i in range(6):
		var temp := _cube_data[i]
		for y in range(2, -1, -1):
			for x in range(2, -1, -1):
				var j := temp & 7
				image.fill_rect(
					Rect2i(
						IMAGE_FACE_COORDS[i] * image_grid_size + Vector2(x + 1, y + 1) * image_border_size + Vector2(x, y) * image_face_size,
						Vector2i.ONE * image_face_size
					),
					get(FACE_NAMES[j] + "_color")
				)
				temp >>= 3
	return image


func turn(code: TurnCode, mode := TurnMode.NONE) -> void:
	if _is_turning:
		return
	_is_turning = true
	if not is_node_ready():
		await ready
	var filter: Callable = func(child): return false
	var pivot_rotation := Vector3.ZERO
	if code == TurnCode.R:
		filter = func(child): return (
			child.name.begins_with("cube") and (is_equal_approx(child.position.x, size / 3) or mode & TurnMode.W and is_equal_approx(child.position.x, 0)) or
			child.name.begins_with("face") and (is_equal_approx(child.position.x, size / 3) or is_equal_approx(child.position.x, size * 2 / 3) or mode & TurnMode.W and is_equal_approx(child.position.x, 0))
		)
		pivot_rotation = Vector3(-1, 0, 0) * PI / 2
	elif code == TurnCode.U:
		filter = func(child): return (
			child.name.begins_with("cube") and (is_equal_approx(child.position.y, size / 3) or mode & TurnMode.W and is_equal_approx(child.position.y, 0)) or
			child.name.begins_with("face") and (is_equal_approx(child.position.y, size / 3) or is_equal_approx(child.position.y, size * 2 / 3) or mode & TurnMode.W and is_equal_approx(child.position.y, 0))
		)
		pivot_rotation = Vector3(0, -1, 0) * PI / 2
	elif code == TurnCode.F:
		filter = func(child): return (
			child.name.begins_with("cube") and (is_equal_approx(child.position.z, size / 3) or mode & TurnMode.W and is_equal_approx(child.position.z, 0)) or
			child.name.begins_with("face") and (is_equal_approx(child.position.z, size / 3) or is_equal_approx(child.position.z, size * 2 / 3) or mode & TurnMode.W and is_equal_approx(child.position.z, 0))
		)
		pivot_rotation = Vector3(0, 0, -1) * PI / 2
	elif code == TurnCode.L:
		filter = func(child): return (
			child.name.begins_with("cube") and (is_equal_approx(child.position.x, -size / 3) or mode & TurnMode.W and is_equal_approx(child.position.x, 0)) or
			child.name.begins_with("face") and (is_equal_approx(child.position.x, -size / 3) or is_equal_approx(child.position.x, -size * 2 / 3) or mode & TurnMode.W and is_equal_approx(child.position.x, 0))
		)
		pivot_rotation = Vector3(1, 0, 0) * PI / 2
	elif code == TurnCode.D:
		filter = func(child): return (
			child.name.begins_with("cube") and (is_equal_approx(child.position.y, -size / 3) or mode & TurnMode.W and is_equal_approx(child.position.y, 0)) or
			child.name.begins_with("face") and (is_equal_approx(child.position.y, -size / 3) or is_equal_approx(child.position.y, -size * 2 / 3) or mode & TurnMode.W and is_equal_approx(child.position.y, 0))
		)
		pivot_rotation = Vector3(0, 1, 0) * PI / 2
	elif code == TurnCode.B:
		filter = func(child): return (
			child.name.begins_with("cube") and (is_equal_approx(child.position.z, -size / 3) or mode & TurnMode.W and is_equal_approx(child.position.z, 0)) or
			child.name.begins_with("face") and (is_equal_approx(child.position.z, -size / 3) or is_equal_approx(child.position.z, -size * 2 / 3) or mode & TurnMode.W and is_equal_approx(child.position.z, 0))
		)
		pivot_rotation = Vector3(0, 0, 1) * PI / 2
	if mode & TurnMode.COUNTERCLOCKWISE:
		pivot_rotation *= -1
	var pivot: Node3D = get_node("pivot")
	for child in get_children().filter(filter):
		child.reparent(pivot)
	var _turn_tween = create_tween()
	_turn_tween.tween_property(pivot, "rotation", pivot_rotation, turn_animate_duration).as_relative()
	if mode & TurnMode.DOUBLE:
		_turn_tween.tween_property(pivot, "rotation", pivot_rotation, turn_animate_duration).as_relative()
	_turn_tween.tween_callback(func():
		for cube in pivot.get_children():
			cube.reparent(self)
		pivot.rotation = Vector3.ZERO
		_update_cube_data()
		turned.emit()
		_is_turning = false
	)


func _init_cubes() -> void:
	for x in range(-1, 2):
		for y in range(-1, 2):
			for z in range(-1, 2):
				var cube := MeshInstance3D.new()
				cube.material_override = ShaderMaterial.new()
				cube.material_override.shader = CUBE_SHADER
				cube.material_override.set_shader_parameter("color", color)
				cube.mesh = BoxMesh.new()
				cube.mesh.size = Vector3.ONE / 3.0
				cube.position = Vector3(x, y, z) / 3.0
				add_child(cube)
				cube.name = "cube"


func _init_faces() -> void:
	const FACE_MESH_POSITION := Vector3(-0.5, 0, 0)
	const FACE_MESH_SIZE := Vector3(0.005, 0.9, 0.9)
	var face_rotations: PackedVector3Array = [
		Vector3(0, 0, 0),
		Vector3(0, 0, PI / 2),
		Vector3(0, -PI / 2, 0),
		Vector3(0, PI, 0),
		Vector3(0, 0, -PI / 2),
		Vector3(0, PI / 2, 0),
	]
	for i in range(-1, 2):
		for j in range(-1, 2):
			var face_positions: PackedVector3Array= [
				Vector3(2, i, j),
				Vector3(i, 2, j),
				Vector3(i, j, 2),
				Vector3(-2, i, j),
				Vector3(i, -2, j),
				Vector3(i, j, -2),
			]
			for k in range(6):
				var face := Node3D.new()
				face.position = face_positions[k] / 3.0
				face.rotation = face_rotations[k]
				var face_mesh := MeshInstance3D.new()
				face_mesh.material_override = ShaderMaterial.new()
				face_mesh.material_override.shader = CUBE_SHADER
				face_mesh.material_override.set_shader_parameter("color", get(FACE_NAMES[k] + "_color"))
				face_mesh.mesh = BoxMesh.new()
				face_mesh.mesh.size = FACE_MESH_SIZE / 3.0
				face_mesh.position = FACE_MESH_POSITION / 3.0
				face.add_child(face_mesh)
				face_mesh.name = "mesh"
				add_child(face)
				face.name = "face_" + FACE_NAMES[k]


func _init_pivot() -> void:
	var pivot := Node3D.new()
	pivot.name = "pivot"
	add_child(pivot)


func _update_colors() -> void:
	if not is_node_ready():
		await ready
	for child in get_children():
		if child.name.begins_with("cube"):
			var cube: MeshInstance3D = child
			cube.material_override.set_shader_parameter("color", color)
		elif child.name.begins_with("face"):
			var face: Node3D = child
			var what_face: String = face.name.trim_prefix("face_")
			for face_name in FACE_NAMES:
				if what_face.begins_with(face_name):
					face.get_node("mesh").material_override.set_shader_parameter("color", get(face_name + "_color"))
					break


func _update_cube_data() -> void:
	_cube_data.fill(0)
	for face in get_children().filter(func(child): return child.name.begins_with("face")):
		var coord := Vector3i((face.position * 3.0 / size).round())
		var index := -1
		var offset := 0
		if coord.x == 2:
			index = 0
			offset = 3 * (coord.y + 1) + coord.z + 1
		elif coord.y == 2:
			index = 1
			offset = 3 * (-coord.z + 1) + coord.x + 1
		elif coord.z == 2:
			index = 2
			offset = 3 * (coord.y + 1) + -coord.x + 1
		elif coord.x == -2:
			index = 3
			offset = 3 * (coord.y + 1) + -coord.z + 1
		elif coord.y == -2:
			index = 4
			offset = 3 * (coord.z + 1) + -coord.x + 1
		elif coord.z == -2:
			index = 5
			offset = 3 * (coord.y + 1) + coord.x + 1
		var what_face: String = face.name.trim_prefix("face_")
		for i in range(6):
			if what_face.begins_with(FACE_NAMES[i]):
				_cube_data[index] |= i << 3 * offset
				break


func _update_positions_and_sizes(old_size: float) -> void:
	if not is_node_ready():
		await ready
	for child in get_children():
		if child.name.begins_with("cube"):
			var cube: MeshInstance3D = child
			cube.mesh.size *= size / old_size
			cube.position *= size / old_size
		elif child.name.begins_with("face"):
			var face: Node3D = child
			child.position *= size / old_size
			child.get_node("mesh").mesh.size *= size / old_size
			child.get_node("mesh").position *= size / old_size
