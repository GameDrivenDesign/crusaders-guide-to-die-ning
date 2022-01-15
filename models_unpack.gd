tool
extends EditorScript

func _run():
	var root = get_editor_interface().get_selection().get_selected_nodes()[0]
	#add_colliders_to_mesh(root)
	create_containers(root)

func create_containers(root):
	var o = root.get_tree().get_edited_scene_root()
	var i = 0
	for m in o.get_children():
		var s = Spatial.new()
		o.add_child(s)
		s.owner = o
		m.get_parent().remove_child(m)
		s.add_child(m)
		m.owner = o
		m.get_child(0).owner = o
		m.get_child(0).get_child(0).owner = o
		s.global_transform.origin.x = i
		i = i + 1

func add_colliders_to_mesh(root):
	var o = root.get_tree().get_edited_scene_root()
	var i = 0
	for c in o.get_children():
		var scene = c as Spatial
		var mesh = c.get_child(0).get_child(0) as MeshInstance
		mesh.create_convex_collision(true, false)
		mesh.get_parent().remove_child(mesh)
		root.add_child(mesh)
		mesh.owner = o
		mesh.get_child(0).owner = o
		mesh.get_child(0).get_child(0).owner = o
		mesh.global_transform.origin.x = i
		c.queue_free()
		i = i + 1

#		var collider = c.get_child(0).get_child(0)
#		collider.owner = o
#		collider.get_parent().remove_child(collider)
#		mesh.get_parent().remove_child(mesh)
#		print("removed")
#
#		var body = StaticBody.new()
#		body.name = "static"
#		body.translation = mesh.translation
#		body.owner = o
#
#		print("add")
#		body.add_child(collider)
#		mesh.add_child(body)
#		root.add_child(mesh)
#
#		c.queue_free()


#		var body = c.get_child(0)
#		collider.get_parent().remove_child(collider)
#		area.add_child(collider)
#		collider.owner = o
#
#		body.get_parent().remove_child(body)
#
#		var t = mesh.global_transform
#		root.remove_child(mesh)
#		area.add_child(mesh)
#		mesh.global_transform = t
#		mesh.owner = o
