extends KinematicBody

export(NodePath) var targetNode

var speed = 100

func _physics_process(delta):
	var p = get_nav()
	if p.size() > 0:
		print(p)
		look_at(p[1], Vector3(0, 1, 0))
		# move_and_slide(Vector3(0, speed, 0), Vector3(0, 1, 0))

func get_nav():
	var nav = $"../Navigation"
	var target = get_node(targetNode).global_transform.origin
	
	var start = nav.get_closest_point(global_transform.origin)
	var end = nav.get_closest_point(target)
	var path = nav.get_simple_path(start, end, true)
	show_path(start, end, path)
	return path

var current_path
func show_path(start, end, p):
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
