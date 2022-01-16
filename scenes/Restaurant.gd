extends Spatial

export var cost_per_tower = 4

var stored_emeralds = 0

func _ready():
	store_emeralds(14)

master func store_emeralds(number: int):
	stored_emeralds += number
	
	while stored_emeralds >= cost_per_tower:
		var tower = preload("res://scenes/Tower.tscn").instance()
		tower.active = false
		tower.translation = Vector3(0.3 * $tower_spawn.get_child_count(), 0, 0)
		$tower_spawn.add_child(tower)
		stored_emeralds -= cost_per_tower

func _on_dropoff_entered(body):
	if body.is_in_group("players") and body.is_network_master() and body.crystals > 0:
		rpc("store_emeralds", body.crystals)
		body.crystals = 0

func _on_tower_collect_entered(body):
	if body.is_in_group("players") and body.is_network_master() and not body.is_carrying():
		# fixme may cause race conditions
		if $tower_spawn.get_child_count() > 0:
			body.carrying_tower = true
		rpc("collect_tower")

master func collect_tower():
	if $tower_spawn.get_child_count() > 0:
		$tower_spawn.get_child($tower_spawn.get_child_count() - 1).queue_free()
		return true
	return false


func _on_FoodArea_body_entered(body):
	if body.is_in_group("enemy"):
		body.die()
