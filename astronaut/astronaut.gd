extends KinematicBody

export(NodePath) var target_node setget set_target_node

var speed = 1
export var health = 10.0

var path

const NAV_OFFSET = Vector3(0, -0.3, 0)

func damage(amount):
	if is_network_master():
		health -= amount
		if health <= 0:
			rpc("_spawn_particles", global_transform)
			$Sync.remove()

remotesync func _spawn_particles(position):
	var particles = preload("res://astronaut/DeathParticles.tscn").instance()
	get_parent().add_child(particles)
	particles.global_transform = position

func _ready():
	$AnimationPlayer.play("Walking")

remotesync func spawn_food(pos):
	var p = preload("res://models/food/food_explosion.tscn").instance()
	p.scale = Vector3(0.3, 0.3, 0.3)
	get_parent().add_child(p)
	p.global_transform.origin = pos + Vector3(0, 0.3, 0)

remotesync func decrement_star_count():
	$"../Camera/hud/star_display".decrement_star_count()

func _physics_process(delta):
	if not target_node:
		return
	var target = get_target_position()
	
	if target.distance_to(global_transform.origin) < 2: # restaurant reached!
		rpc("spawn_food", global_transform.origin)
		
		rpc("decrement_star_count")
		$Sync.remove()
		
		return
	
	var current_target = get_current_target()
	if current_target:
		current_target += NAV_OFFSET
		var my_pos = global_transform.origin
		var diff = current_target - my_pos
		if diff.cross(Vector3.UP) != Vector3(): # check for alignment
			look_at(current_target, Vector3.UP)
		move_and_slide(diff, Vector3.UP)
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
	# show_path(path)
	return p

# helper
var current_path
func show_path(p):
	if current_path:
		current_path.queue_free()
	
	var im = ImmediateGeometry.new()
	add_child(im)
	
	im.clear()
	im.set_material_override(SpatialMaterial.new())
	im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	for x in p:
		im.add_vertex(x + Vector3(0, 0.1, 0))
	im.end()
	current_path = im
