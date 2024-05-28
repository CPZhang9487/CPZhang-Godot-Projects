@tool
class_name Draggable2D
extends Area2D


var _mouse_entered := false
var _mouse_left_pressed_in_shape := false


func _ready() -> void:
	monitorable = false
	monitoring = false

	mouse_entered.connect(func(): _mouse_entered = true)
	mouse_exited.connect(func(): _mouse_entered = false)


func _input(event: InputEvent) -> void:
	if _mouse_entered and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_mouse_left_pressed_in_shape = event.pressed
	if event is InputEventMouseMotion and _mouse_left_pressed_in_shape:
		var parent = get_parent()
		if not parent or not parent is Node2D:
			print("Draggable2D should be added to Node2D.")
		else:
			parent.position += event.relative
