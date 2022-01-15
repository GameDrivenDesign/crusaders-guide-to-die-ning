extends KinematicBody
export var speed = 5
var direction = Vector3(0,0,0)

var old_position = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	global_transform.origin = $"../SpawnPoint".global_transform.origin

func _process(delta):
	var moving = false
	var new_direction = Vector3(0,0,0)
	if Input.is_action_pressed("ui_up"):
		moving = true
		new_direction += Vector3(1,0,0)
	if Input.is_action_pressed("ui_down"):
		moving = true
		new_direction += Vector3(-1,0,0)
	if Input.is_action_pressed("ui_left"):
		moving = true
		new_direction += Vector3(0,0,-1)
	if Input.is_action_pressed("ui_right"):
		moving = true
		new_direction += Vector3(0,0,1)
	if moving == true:
		direction = new_direction.normalized()
		move_and_slide(direction * speed)
		look_at(direction + global_transform.origin, Vector3.UP)
		$AnimationPlayer.play("Walking")
	else:
		$AnimationPlayer.play("Idle")
		
	# camera movement
	var camera = get_viewport().get_camera()
	var pos_delta = self.translation - old_position
	
	old_position = self.translation
	
	camera.translation += pos_delta
	
	if Input.is_action_just_pressed("ui_accept"):
		spawn_tower()


func spawn_tower():
	var offset = 1
	var tower_node = preload("res://scenes/Tower.tscn").instance()
	get_parent().add_child(tower_node)
	tower_node.global_transform.origin = global_transform.origin + direction * offset
