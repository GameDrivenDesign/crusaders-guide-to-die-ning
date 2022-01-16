extends Spatial

func _ready():
	$menu/container/name.grab_focus()

func _on_start_pressed():
	$menu/container/loading.visible = true
	$menu/container/start.visible = false
	$menu/container/name.editable = false
	start()

func _on_name_text_entered(new_text):
	start()

func start():
	get_tree().change_scene_to(preload("res://game/game.tscn"))
