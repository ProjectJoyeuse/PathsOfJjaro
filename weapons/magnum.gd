extends RaycastWeapon
export(PackedScene) var squib = preload("res://Joyeuse/Basics/Guns/squib.tscn")

export var spread = 2
onready var AISHS = get_tree().get_root().get_node("World/AI_SH_SYSTEM")
const sound1 = "res://assets/sounds/M1/Mega45_fire.ogg"
const sound3 = "res://assets/sounds/M1/Ricochet_random.tres"


func _ready():
	$AnimationPlayer.play("standard")
	id = 1
	identity = ".45 Magnum Mega Class"
	primary_uses = 8
	secondary_uses = 8
	primary_initial_ammo = 8
	secondary_initial_ammo = 8
	primary_ammo_id = 0
	secondary_ammo_id = 0

func dual_wield():
	dual_wielding = true
	$AnimationPlayer.play("dual_start")

func primary_use(_uses : int = 0):

	#check if the weapon has cooled
	if can_shoot:

		# adjust ray for random spread


		# check if there is ammo in the magazine
		if ammo_check_primary():

			randomshoot()
			# check for collisions
			var hit = $aperture/RayCast.get_collider()

			# if a collision occurs
			if hit:
				# if the object is a static or kinematic body
				if not hit is Area:

					# load a squib (a spark or flash to show impact) and place it at the impact point
					var squibpoint = $aperture/RayCast.get_collision_point()
					var thissquib = squib.instance()
					thissquib.set_as_toplevel(true)
					var squibpos = thissquib.get_global_transform()
					squibpos.origin = squibpoint
					thissquib.set_global_transform(squibpos)
					hit.owner.add_child(thissquib)
					AISHS.add_child(AutoSound3D.new(sound3, squibpoint)) 
					get_parent().add_child(AutoSound3D.new(sound1, translation)) 

			# weapon set not chambered, start timer for cooldown.
			$AnimationPlayer.play("fire")
			can_shoot=false
			$chamber_timer.start()


func _on_chamber_timer_timeout():
	can_shoot = true

# "M .75 ammunition is neither vacuum enabled nor teflon coated, and due to a manufacturing defect is highly inaccurate at long range."
# used for random spread.
func randomshoot():

	randomize()
	var randx = rand_range(-spread, spread)
	randomize()
	var randy = rand_range(-spread, spread)


	var newx = 0 + randx
	var newy = 0 + randy
	#print("rando =", newx," ", newy)
	$aperture/RayCast.set_cast_to(Vector3(newx,newy,-1000))


func _on_grenade_timer_timeout():
	can_shoot_secondary = true
	pass # replace with function body
