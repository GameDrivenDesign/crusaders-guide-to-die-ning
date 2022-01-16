extends Spatial

onready var plane = Plane(Vector3(0, 1, 0), 0)

var pointA = null
var pointB = null

var nav_mesh_height = Vector3(0, 0.1, 0)

func _process(_delta):
	if is_network_master():
		if int(rand_range(0, 5)) == 0:
			var positions = $EnemySpawnPoints.get_children()
			var position = positions[int(rand_range(0, positions.size()))]
			
			var enemy = preload("res://astronaut/astronaut.tscn").instance()
			enemy.global_transform = position.global_transform
			add_child(enemy)
			enemy.target_node = $base_target.get_path()
