extends KinematicBody

export(NodePath) var targetNode

export var health = 10.0

func _physics_process(delta):
	# var p = get_nav()
	# print(p)
	pass

func damage(amount):
	health -= amount
	if health <= 0:
		queue_free()

func get_nav():
	var nav = $"../Level/Navigation"
	var target = get_node(targetNode).global_transform.origin
	
	var start = nav.get_closest_point(global_transform.origin)
	var end = nav.get_closest_point(target)
	return nav.get_simple_path(start, end, true)
