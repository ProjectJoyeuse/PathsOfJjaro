extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func start():
	$Particles.emitting = true
	$Particles2.emitting = true
	$Particles/OmniLight.visible = true
	
func stop():
	$Particles.emitting = false
	$Particles2.emitting = false
	$Particles/OmniLight.visible = false
