extends KinematicBody

var hovered = false
var material
var selected = false
onready var camera = $"../Camera"
onready var plane = Plane(Vector3(0, 1, 0), 1)

func _ready():
	material = $MeshInstance.get_active_material(0)

func _process(delta):
	if hovered and Input.is_action_just_pressed("mouseDown"):
		selected = not selected
	if selected:
		var position2D = get_viewport().get_mouse_position()
		var position3D = plane.intersects_ray(
							 camera.project_ray_origin(position2D),
							 camera.project_ray_normal(position2D))
		translation = position3D

func _on_Placable_mouse_entered():
	hovered = true
	material.set_shader_param("hovered", hovered)

func _on_Placable_mouse_exited():
	hovered = false
	material.set_shader_param("hovered", hovered)
