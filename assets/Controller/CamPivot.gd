extends Spatial

var g_delta : float = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y = lerp(rotation_degrees.y, rotation_degrees.y - event.relative.x, g_delta)
		clamp(rotation_degrees.y, 20, 35)
		rotation_degrees.x = lerp(rotation_degrees.x, rotation_degrees.x + event.relative.y, g_delta)
		clamp(rotation_degrees.x, 20, 75)
		
func _process(delta):
	g_delta = delta
