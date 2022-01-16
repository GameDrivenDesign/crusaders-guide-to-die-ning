extends TextureRect

var current_star_count = 10 setget set_star_count
export var texture_size = 1200 

export var enable_gameover = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

remote func decrement_star_count():
	if not is_network_master():
		return
	
	set_star_count(current_star_count - 1)

func set_star_count(num):
	current_star_count = num
	if current_star_count <= 0:
		if enable_gameover:
			rpc("change_to_gameover")
	else:
		self.rect_size.x = num * texture_size

remotesync func change_to_gameover():
	assert(get_tree().change_scene_to(load("res://gameover/gameover.tscn")) == OK)
	get_node("/root/NetworkGame").disconnect_all()
