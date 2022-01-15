extends KinematicBody

export(NodePath) var targetNode

var speed = 1
export var health = 10.0

func _physics_process(delta):
	var p = get_nav()
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

func damage(amount):
	health -= amount
	if health <= 0:
		queue_free()

func get_nav():
	var nav = $"../Navigation"
	var target = get_node(targetNode).global_transform.origin
	
	var start = nav.get_closest_point(global_transform.origin)
	var end = nav.get_closest_point(target)
	var path = nav.get_simple_path(start, end, true)
	# show_path(path)
	return path

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
