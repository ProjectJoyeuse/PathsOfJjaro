extends Camera

var pivot_node : Spatial = null
var target_node : Spatial = null
var tps_node : Spatial = null
onready var Ray : RayCast = $RayCast
export(Array, NodePath) var collision_exceptions : Array = []
export(NodePath) var  pivot : NodePath = ""
export(NodePath) var target : NodePath = ""
export(NodePath) var tps_target : NodePath = ""
export(float) var fly_range : float = 3
export(bool) var third_person : bool = false
var g_delta : float = 0.0

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y = lerp(rotation_degrees.y, rotation_degrees.y - event.relative.x, g_delta)
		clamp(rotation_degrees.y, 20, 35)
		rotation_degrees.x = lerp(rotation_degrees.x, rotation_degrees.x - event.relative.y, g_delta)
		clamp(rotation_degrees.x, 20, 75)
		

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pivot_node = get_node(pivot)
	
	#third person code:
	target_node = get_node(target)
	tps_node = get_node(tps_target)
	for exception in collision_exceptions:
		Ray.add_exception(get_node(exception))
	
func _process(delta):
	g_delta = delta
	if pivot_node and target_node:
		
		if third_person:
			
			tps_node.translation.z = -fly_range
			
			if (translation - to_local(pivot_node.to_global(Vector3.ZERO))).length() > fly_range:
				translation = lerp(translation, to_local(pivot_node.to_global(Vector3.ZERO)), delta)
			elif Ray.is_colliding():
				translation = lerp(translation, to_local(Ray.to_global(Vector3.ZERO)), delta)
			else:
				print(translation)
				translation = lerp(translation, to_local(tps_node.to_global(Vector3.ZERO)), delta)
			look_at(get_parent().to_local(target_node.to_global(Vector3.ZERO)), Vector3.UP)
		else:
			translation = lerp(translation, get_parent().to_local(pivot_node.to_global(Vector3.ZERO)), delta)
		
		tps_node.get_parent().translation = lerp(tps_node.get_parent().translation, tps_node.get_parent().to_local(pivot_node.to_global(Vector3.ZERO)), delta)
		
