extends Spatial

func set_target_radius(radius):
	$TargetRange/CollisionShape.shape.radius = radius

func get_targets():
	return $TargetRange.get_overlapping_bodies()
