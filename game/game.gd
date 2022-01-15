extends Spatial

onready var plane = Plane(Vector3(0, 1, 0), -0.75)

var pointA = null
var pointB = null

func _process(delta):
	if not Input.is_action_just_pressed("mouseDown"):
		return
	
	var position2D = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera()
	var position3D = plane.intersects_ray(
						 camera.project_ray_origin(position2D),
						 camera.project_ray_normal(position2D))
	position3D = $Level/Navigation.get_closest_point(position3D)
	if pointA:
		pointB = position3D
		_update_path()
	else:
		pointA = position3D
	$astronaut.translation = position3D
	print(position3D)

func _update_path():
	var p = $Level/Navigation.get_simple_path(pointA, pointB, true)
	var path = Array(p)
	print(path)
	path.invert()
	
	var im = ImmediateGeometry.new()
	add_child(im)
	
	im.clear()
	im.set_material_override(SpatialMaterial.new())
	im.begin(Mesh.PRIMITIVE_POINTS, null)
	im.add_vertex(pointA + Vector3(0, 1, 0))
	im.add_vertex(pointB + Vector3(0, 1, 0))
	im.end()
	im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	for x in p:
		im.add_vertex(x + Vector3(0, 1, 0))
	im.end()
