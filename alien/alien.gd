extends KinematicBody
export var speed = 2
var direction = Vector3(0,0,0)

var old_position = Vector3(0,0,0)
var collecting = 0
var crystals = 0
var collecting_time = 0
export var collecting_time_total = 2

var status setget set_status
var color setget set_color

func set_status(new_status):
	if new_status != status:
		status = new_status
		$AnimationPlayer.play(status)

func set_color(col):
	color = col
	var mat = SpatialMaterial.new()
	mat.albedo_color = col
	$model/head.set_surface_material(0, mat)
	$model/armLeft.set_surface_material(0, mat)
	$model/armRight.set_surface_material(0, mat)

func _network_ready(is_source):
	if is_source:
		set_color(Color.from_hsv(rand_range(0, 360), 1, 1))

# Called when the node enters the scene tree for the first time.
func _ready():
	global_transform.origin = $"../SpawnPoint".global_transform.origin

func _process(delta):
	var new_status = "Idle"
	var moving = false
	var new_direction = Vector3(0,0,0)
	if Input.is_action_pressed("ui_up"):
		moving = true
		new_direction += Vector3(1,0,1)
	if Input.is_action_pressed("ui_down"):
		moving = true
		new_direction += Vector3(-1,0,-1)
	if Input.is_action_pressed("ui_left"):
		moving = true
		new_direction += Vector3(1,0,-1)
	if Input.is_action_pressed("ui_right"):
		moving = true
		new_direction += Vector3(-1,0,1)
	if moving == true:
		direction = new_direction.normalized()
		move_and_slide(direction * speed)
		look_at(direction + global_transform.origin, Vector3.UP)
		new_status = "Walking"
		
	# camera movement
	var camera = get_viewport().get_camera()
	var pos_delta = self.translation - old_position
	
	old_position = self.translation
	
	camera.translation += pos_delta
	
	if Input.is_action_just_pressed("ui_accept"):
		spawn_tower()

	if collecting > 0:
		new_status = "Pickaxing"
		collecting_time += delta
		if collecting_time > collecting_time_total:
			crystals += 1
			collecting_time -= collecting_time_total
	
	set_status(new_status)

func spawn_tower():
	var offset = 1
	var tower_node = preload("res://scenes/Tower.tscn").instance()
	tower_node.set_network_master(get_network_master())
	tower_node.global_transform.origin = global_transform.origin + direction * offset
	get_parent().add_child(tower_node)

func start_collecting():
	collecting += 1
		
	
func stop_collecting():
	collecting -= 1
