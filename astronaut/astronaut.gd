extends KinematicBody

export(NodePath) var targetNode

var speed = 1
export var health = 10.0

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

func _physics_process(delta):
	var target = get_node(targetNode).global_transform.origin
	if target.distance_to(global_transform.origin) < 3:
		rpc("spawn_food", global_transform.origin)
		$Sync.remove()
		return
	
	var p = get_nav(target)
	if p.size() > 0:
		var next = next_point(p)
		if next:
			next.y = 0
			var my_pos = global_transform.origin
			my_pos.y = 0
			look_at(next, Vector3(0, 1, 0))
			move_and_slide((next - my_pos).normalized() * speed, Vector3(0, 1, 0))

func next_point(path):
	for p in path:
		if p.distance_to(global_transform.origin) > 0.3:
			return p
	return null

func get_nav(target):
	var nav = $"../Navigation"
	var start = nav.get_closest_point(global_transform.origin)
	var end = nav.get_closest_point(target)
	var path = nav.get_simple_path(start, end, true)
	# show_path(path)
	return path

# helper
var current_path
func show_path(p):
	if current_path:
		current_path.queue_free()
	
	var path = Array(p)
	path.invert()
	
	var im = ImmediateGeometry.new()
	add_child(im)
	
	im.clear()
	im.set_material_override(SpatialMaterial.new())
	im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	for x in p:
		im.add_vertex(x + Vector3(0, 0.1, 0))
	im.end()
	current_path = im
