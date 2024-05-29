class_name Draggable2D
extends Area2D


var can_be_dragged := false
var is_dragged := false:
	set(value):
		if not is_dragged and not can_be_dragged:
			value = false
		is_dragged = value


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragged = event.pressed
	if event is InputEventMouseMotion:
		var parent = get_parent()
		if is_dragged and parent and parent is Node2D:
			parent.position += event.relative
			get_viewport().set_input_as_handled()


func _ready() -> void:
	monitorable = false
	monitoring = false

	mouse_entered.connect(func(): can_be_dragged = true)
	mouse_exited.connect(func(): can_be_dragged = false)
