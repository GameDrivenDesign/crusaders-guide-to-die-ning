extends Spatial

export var is_game_over_screen = false

func _ready():
	if "--dedicated" in OS.get_cmdline_args():
		assert(get_tree().change_scene_to(load("res://game/game.tscn")) == OK)
		return
	if not is_game_over_screen:
		$menu/container/name.grab_focus()

func _on_start_pressed():
	start()

func _on_name_text_entered(_new_text):
	start()

func start():
	if is_game_over_screen:
		$menu/container/restart.visible = false
	else:
		$menu/container/name.editable = false
		$menu/container/start.visible = false
		if $menu/container/name.text.length() > 0:
			Global.player_name = $menu/container/name.text
	
	$menu/container/loading.visible = true
	assert(get_tree().change_scene_to(load("res://game/game.tscn")) == OK)
