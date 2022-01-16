extends KinematicBody

export(NodePath) var target_node setget set_target_node

export var speed = 0.5
export var health = 50.0
export var astronautNumber = 5

var path


func damage(amount):
	if is_network_master():
		health -= amount
		if health <= 0:
			rpc("_spawn_particles", global_transform)
			rpc("_spawn_astronauts", global_transform)
			$Sync.remove()

remotesync func _spawn_astronauts(position):
	for _i in range(astronautNumber):
		var astronaut = preload("res://astronaut/astronaut.tscn").instance()
		astronaut.global_transform = position
		astronaut.translation += Vector3(rand_range(-2, 2), 0, rand_range(-2, 2))
		get_parent().add_child(astronaut)
		astronaut.target_node = target_node


remotesync func _spawn_particles(position):
	var particles = preload("res://astronaut/DeathParticles.tscn").instance()
	get_parent().add_child(particles)
	particles.global_transform = position


func _ready():
	#$AnimationPlayer.play("Walking")
	pass


remotesync func spawn_food(pos):
	var p = preload("res://models/food/food_explosion.tscn").instance()
	p.scale = Vector3(0.3, 0.3, 0.3)
	get_parent().add_child(p)
	p.global_transform.origin = pos + Vector3(0, 0.3, 0)

func _physics_process(delta):
	if not target_node:
		return
	var target = get_target_position()
	if target.distance_to(global_transform.origin) < 2:
		rpc("spawn_food", global_transform.origin)
		$Sync.remove()
		return
	
	var current_target = get_current_target()
	if current_target:
		var my_pos = global_transform.origin
		if my_pos.distance_to(current_target) > 0.1:
			look_at(current_target, Vector3(0, 1, 0))
		var _vel = move_and_slide(current_target - my_pos, Vector3(0, 1, 0))
	update_target(delta)

func get_current_target():
	if not path:
		return null
	return path[0]

func update_target(delta):
	if not path:
		return
	var residual = speed * delta
	while residual > 0 and path.size() > 1:
		var dist = path[0].distance_to(path[1])
		if residual <= dist:
			path[0] += (path[1] - path[0]).normalized() * residual
			residual = 0
		else:
			residual -= dist
			path.remove(0)

func get_target_position():
	return get_node(target_node).global_transform.origin

func set_target_node(new_target_node):
	target_node = new_target_node
	if target_node:
		path = get_nav(get_target_position())

func get_nav(target):
	var nav = $"../Navigation"
	var start = nav.get_closest_point(global_transform.origin)
	var end = nav.get_closest_point(target)
	var p = nav.get_simple_path(start, end, true)
	return p
