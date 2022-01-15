extends Spatial

onready var plane = Plane(Vector3(0, 1, 0), 0)

var pointA = null
var pointB = null

var nav_mesh_height = Vector3(0, 0.2, 0)

func _process(delta):
	if not Input.is_action_just_pressed("mouseDown"):
		return
	
	var position2D = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera()
	var position3D = plane.intersects_ray(
						 camera.project_ray_origin(position2D),
						 camera.project_ray_normal(position2D))
	position3D = $Navigation.get_closest_point(position3D) - nav_mesh_height
	$astronaut.translation = position3D

