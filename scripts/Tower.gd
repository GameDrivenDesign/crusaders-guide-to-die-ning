extends Spatial

export var active = false setget set_active

var fuel = 0 setget set_fuel
const FUEL_PER_CRYSTAL = 20

func set_active(b):
	active = b
	
	var s = 1.0 if active else 0.4
	scale = Vector3(s, s, s)
	$fuel_indicator.visible = b

func _ready():
	set_fuel(100)

func set_target_radius(radius):
	$TargetRange/CollisionShape.shape.radius = radius

func get_targets():
	return $TargetRange.get_overlapping_bodies()

func can_shoot():
	return fuel > 0

func shot_fired():
	if is_network_master():
		set_fuel(fuel - 1)

func set_fuel(num):
	fuel = num
	set_crystals(ceil(float(fuel) / FUEL_PER_CRYSTAL))

func set_crystals(num: int):
	var vertical_space = 0.07
	var current = $fuel_indicator.get_child_count()
	if current == num:
		return
	
	# add new crystals if the number increased
	for i in range(num - current):
		var emerald_node = preload("res://crystal/emerald.tscn").instance()
		emerald_node.transform.origin.y = vertical_space * (current + i)
		$fuel_indicator.add_child(emerald_node)
	
	# remove old crystals if the number decreased
	for i in range(current - num):
		# modification while iterating allowed, queue only marks
		$fuel_indicator.get_child($fuel_indicator.get_child_count() - 1 - i).queue_free()

master func store_emeralds(count):
	set_fuel(fuel + count * FUEL_PER_CRYSTAL)

func _on_refuel_entered(body):
	if active and body.is_in_group("players") and body.is_network_master() and body.crystals > 0:
		rpc("store_emeralds", body.crystals)
		body.crystals = 0
