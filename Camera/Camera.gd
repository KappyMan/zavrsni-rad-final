extends Camera2D

export var min_zoom := 0.5
export var max_zoom := 2.0
export var zoom_factor := 0.1
export var zoom_duration := 0.1

var _previousPosition: Vector2 = Vector2(0, 0);
var _moveCamera: bool = false;
var _zoom_level := 1.0 setget _set_zoom_level
var _drag_mode = true setget set_drag_mode

onready var tween: Tween = $Tween

func _set_zoom_level(value: float) -> void:
	_zoom_level = clamp(value, min_zoom, max_zoom)
# warning-ignore:return_value_discarded
	tween.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(_zoom_level, _zoom_level),
		zoom_duration,
		tween.TRANS_LINEAR,
		tween.EASE_OUT
	)
# warning-ignore:return_value_discarded
	tween.start()

func set_drag_mode(value):
	_drag_mode = value

func _unhandled_input(event):
	#Zooming in and out
	if event.is_action_pressed("zoom_in"):
		_set_zoom_level(_zoom_level - zoom_factor)
	if event.is_action_pressed("zoom_out"):
		_set_zoom_level(_zoom_level + zoom_factor)
	#Click and drag on screen
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && _drag_mode:
		get_tree().set_input_as_handled();
		if event.is_pressed():
			_previousPosition = event.position;
			_moveCamera = true;
		else:
			_moveCamera = false;
	elif event is InputEventMouseMotion && _moveCamera:
		get_tree().set_input_as_handled();
		position += (_previousPosition - event.position);
		_previousPosition = event.position;
