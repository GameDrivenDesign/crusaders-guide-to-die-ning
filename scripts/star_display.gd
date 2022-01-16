extends TextureRect

var current_star_count = 10
export var texture_size = 1200 

export var enable_gameover = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func decrement_star_count():
	current_star_count -= 1
	
	if current_star_count <= 0:
		if enable_gameover:
			get_tree().change_scene_to(load("res://gameover/gameover.tscn"))
		return
	
	self.rect_size.x -= texture_size
