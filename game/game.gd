extends Spatial

onready var plane = Plane(Vector3(0, 1, 0), 0)

var pointA = null
var pointB = null

var nav_mesh_height = Vector3(0, 0.1, 0)

var start_time

func _ready():
	start_time = OS.get_ticks_msec()

func spawn_enemy(probability): # lower = more often ships
	var positions = $EnemySpawnPoints.get_children()
	var position = positions[int(rand_range(0, positions.size()))]
			
	var enemy
	if int(rand_range(0, probability)) == 0:
		enemy = preload("res://ship/Ship.tscn").instance()
	else:
		enemy = preload("res://astronaut/astronaut.tscn").instance()
	enemy.global_transform = position.global_transform
	add_child(enemy)
	enemy.target_node = $base_target.get_path()

func _process(_delta):
	if is_network_master():
		var delta = OS.get_ticks_msec() - start_time
		
		if delta > 240_000: # = 120 secs: go crazy
			if int(rand_range(0, 20)) == 0:
				spawn_enemy(1)
		
		elif delta > 120_000: # = 60 secs: start spawning more ships
			if int(rand_range(0, 20)) == 0:
				spawn_enemy(10)
		
		elif delta > 60_000: # = 20 secs: start spawning some ships
			if int(rand_range(0, 20)) == 0:
				spawn_enemy(50)
		
		elif delta > 20_000: # = 10 secs: start spawning more of astronauts
			if int(rand_range(0, 20)) == 0:
				spawn_enemy(1000)
		
		elif delta > 1000: # = 1 sec: start some spawning astronauts
			if int(rand_range(0, 20)) == 0:
				spawn_enemy(1000)
