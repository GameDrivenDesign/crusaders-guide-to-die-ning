extends Spatial

export var cost_per_tower = 4

var stored_emeralds = 0

func _ready():
	store_emeralds(14)

func store_emeralds(number: int):
	stored_emeralds += number
	
	while stored_emeralds >= cost_per_tower:
		var tower = preload("res://scenes/Tower.tscn").instance()
		tower.active = false
		tower.translation = Vector3(0.3 * $tower_spawn.get_child_count(), 0, 0)
		$tower_spawn.add_child(tower)
		stored_emeralds -= cost_per_tower
