extends Spatial

export var cost_per_tower = 4

var stored_emeralds = 0

var stored_towers = 0 setget set_stored_towers

func set_stored_towers(num):
	for i in range(num - stored_towers):
		var t = preload("res://scenes/TowerPreview.tscn").instance()
		t.transform.origin.x = 0.3 * (stored_towers + i)
		$tower_spawn.add_child(t)
	
	for i in range(stored_towers - num):
		# modification while iterating allowed, queue only marks
		$tower_spawn.get_child($tower_spawn.get_children().size() - 1 - i).queue_free()
	
	stored_towers = num

func _ready():
	store_emeralds(14)

remotesync func store_emeralds(number: int):
	stored_emeralds += number
	
	while stored_emeralds >= cost_per_tower:
		set_stored_towers(stored_towers + 1)
		stored_emeralds -= cost_per_tower

func _on_dropoff_entered(body):
	if body.is_in_group("players") and body.is_network_master() and body.crystals > 0:
		rpc_id(1, "store_emeralds", body.crystals)
		body.crystals = 0

func _on_tower_collect_entered(body):
	if body.is_in_group("players") and body.is_network_master() and not body.is_carrying():
		# fixme may cause race conditions
		if $tower_spawn.get_child_count() > 0:
			body.carrying_tower = true
		rpc_id(1, "collect_tower")

remotesync func collect_tower():
	if $tower_spawn.get_child_count() > 0:
		set_stored_towers(stored_towers - 1)
		return true
	return false

func _on_FoodArea_body_entered(body):
	if is_network_master() and body.is_in_group("enemy"):
		body.die()
