extends Camera2D

@export var zoom_speed: float = 10

@export var zoom_target: Vector2

var drag_start_mouse_pos: Vector2 = Vector2.ZERO
var drag_start_camera_pos: Vector2 = Vector2.ZERO
var is_dragging: bool = false;

func _ready():
	zoom_target = zoom

func _process(delta):
	Zoom(delta)
	ClickAndDrag()

func Zoom(delta):
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoom_target *= 1.1
	if Input.is_action_just_pressed("camera_zoom_out"):
		zoom_target *= 0.9
	zoom = zoom.slerp(zoom_target, zoom_speed * delta)

func ClickAndDrag():
	if !is_dragging and Input.is_action_just_pressed("camera_pan"):
		drag_start_mouse_pos = get_viewport().get_mouse_position()
		drag_start_camera_pos = position
		is_dragging = true

	if is_dragging and Input.is_action_just_released("camera_pan"):
		is_dragging = false
	
	if is_dragging:
		var move_vec = get_viewport().get_mouse_position() - drag_start_mouse_pos
		position = drag_start_camera_pos - move_vec / zoom.x
