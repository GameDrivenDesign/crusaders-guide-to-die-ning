extends KinematicBody
export var speed = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	global_transform.origin = $"../SpawnPoint".global_transform.origin

func _process(delta):
	var moving = false
	var direction = Vector3(0, 0, 0)
	if Input.is_action_pressed("ui_up"):
		moving = true
		direction += Vector3(speed,0,0)
	if Input.is_action_pressed("ui_down"):
		moving = true
		direction += Vector3(-speed,0,0)
	if Input.is_action_pressed("ui_left"):
		moving = true
		direction += Vector3(0,0,-speed)
	if Input.is_action_pressed("ui_right"):
		moving = true
		direction += Vector3(0,0,speed)
	if moving == true:
		move_and_slide(direction)
		look_at(direction + global_transform.origin, Vector3.UP)
		$AnimationPlayer.play("Walking")
	else:
		$AnimationPlayer.play("Idle")


#void play(name: String = "", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false)

