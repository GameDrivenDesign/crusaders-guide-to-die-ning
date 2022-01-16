extends KinematicBody
export var speed = 2
var direction = Vector3(0,0,0)

var old_position = Vector3(0,0,0)
var collecting = 0
var collecting_time = 0
export var collecting_time_total = 2

var crystals = 0 setget set_crystals
var status setget set_status
var color setget set_color
var carrying_tower = false setget set_carrying_tower

var player_name = "" setget set_player_name

var velocity = Vector3(0, 0, 0)

func set_player_name(n):
	player_name = n
	$name_view/label.text = n

func set_carrying_tower(b):
	if carrying_tower == b:
		return
	if b:
		var tower = preload("res://scenes/Tower.tscn").instance()
		tower.active = false
		$model/tower_carry_position.add_child(tower)
	else:
		for c in $model/tower_carry_position.get_children():
			c.queue_free()
	carrying_tower = b

func set_crystals(num: int):
	var vertical_space = 0.07
	
	# add new crystals if the number increased
	for i in range(num - crystals):
		var emerald_node = preload("res://crystal/emerald.tscn").instance()
		emerald_node.transform.origin.y = vertical_space * (crystals + i)
		$model/emeraldPlate.add_child(emerald_node)
	
	# remove old crystals if the number decreased
	for i in range(crystals - num):
		# modification while iterating allowed, queue only marks
		$model/emeraldPlate.get_child(i).queue_free()
	
	crystals = num

func is_carrying():
	return crystals > 0 or carrying_tower

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
		set_crystals(3)
	
	yield(get_tree(), "idle_frame")
	if is_network_master():
		set_player_name(Global.player_name)

func _ready():
	global_transform.origin = $"../SpawnPoint".global_transform.origin

func _physics_process(delta):
	var new_status = "Idle"
	if is_carrying():
		new_status = "IdleCarrying"
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
		velocity = Vector3(direction.x, -0.5, direction.z)
		velocity = move_and_slide(velocity * speed)
		look_at(direction + global_transform.origin, Vector3.UP)
		if not is_carrying():
			new_status = "Walking"
		else:
			new_status = "Carrying"
	
	# camera movement
	var camera = get_viewport().get_camera()
	var pos_delta = self.translation - old_position
	
	old_position = self.translation
	
	camera.translation += pos_delta
	
	if Input.is_action_just_pressed("ui_accept") and carrying_tower:
		spawn_tower()

	if collecting > 0 and not moving:
		new_status = "Pickaxing"
		collecting_time += delta
		if collecting_time > collecting_time_total:
			get_crystal()
			collecting_time -= collecting_time_total
	
	$model/armRight/toolPickaxe.set_visible(new_status == "Pickaxing")
	set_status(new_status)

func spawn_tower():
	set_carrying_tower(false)
	var offset = 1
	var tower_node = preload("res://scenes/Tower.tscn").instance()
	tower_node.active = true
	tower_node.set_network_master(get_network_master())
	get_parent().add_child(tower_node)
	tower_node.global_transform.origin = global_transform.origin + direction * offset

func start_collecting():
	collecting += 1

func stop_collecting():
	collecting -= 1

func get_crystal():
	set_crystals(crystals + 1)
