extends Spatial

func _ready():
	$menu/container/name.grab_focus()

func _on_start_pressed():
	start()

func _on_name_text_entered(_new_text):
	start()

func start():
	$menu/container/loading.visible = true
	$menu/container/start.visible = false
	$menu/container/name.editable = false
	if $menu/container/name.text.length() > 0:
		Global.player_name = $menu/container/name.text
	assert(get_tree().change_scene_to(preload("res://game/game.tscn")) == OK)
