extends Spatial

var current_target: Spatial = null setget set_current_target
var cooldown = 0.2

var time_until_next_shot = cooldown

func _physics_process(delta):
	if not is_active():
		return
	time_until_next_shot -= delta
	update_target()
	if time_until_next_shot <= 0:
		time_until_next_shot = 0
		try_shoot()

func get_tower():
	return get_parent()

func is_active():
	return get_tower().active

func update_target():
	var targets = get_tower().get_targets()
	var target = choose_target(targets)
	set_current_target(target)

func choose_target(targets):
	for target in targets:
		if target.is_in_group("enemy"):
			return target
	return null

func try_shoot():
	if current_target and get_tower().can_shoot():
		shoot()

func set_current_target(new_target):
	current_target = new_target
	if current_target != null:
		turn_to_target()

func turn_to_target():
	var direction = current_target.global_transform.origin
	look_at(direction, Vector3.UP)

func shoot():
	spawn_projectile(current_target)
	time_until_next_shot = cooldown

func spawn_projectile(target: Spatial):
	var projectile = preload("res://scenes/Projectile.tscn").instance()
	get_tower().get_parent().add_child(projectile)
	projectile.target = target
	projectile.global_transform.origin = global_transform.origin
	get_tower().shot_fired()

func get_direction_to_target():
	return current_target.global_transform.origin - global_transform.origin
