extends TextureRect

var current_star_count = 10 setget set_star_count
export var texture_size = 1200 

export var enable_gameover = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func decrement_star_count():
	current_star_count -= 1
	
	if current_star_count <= 0:
		if enable_gameover:
			assert(get_tree().change_scene_to(load("res://gameover/gameover.tscn")) == OK)
		return
	
	set_star_count(current_star_count)

func set_star_count(num):
	current_star_count = num
	self.rect_size.x = num * texture_size
