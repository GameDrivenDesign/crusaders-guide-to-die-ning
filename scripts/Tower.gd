extends Spatial

export var active = false setget set_active

func set_active(b):
	active = b
	
	var s = 1 if active else 0.4
	scale = Vector3(s, s, s)

func set_target_radius(radius):
	$TargetRange/CollisionShape.shape.radius = radius

func get_targets():
	return $TargetRange.get_overlapping_bodies()
