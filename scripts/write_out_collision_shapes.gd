extends MeshInstance

var path = "res://new_meshlibrary.tres"
export var index = -1

func _ready():
	if index < 0:
		return
	var mesh_library = load(path) as MeshLibrary
	var count = mesh.get_surface_count()
	var shapes = []
	var min_v = Vector2(INF, INF)
	var max_v = Vector2(-INF, -INF)
	for i in range(count):
		var shape = mesh.surface_get_arrays(i)
		var mesh = ArrayMesh.new()
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, shape)
		var convex = mesh.create_convex_shape(true, true)
		shapes.append(convex)
		for point in convex.points:
			if point.x > max_v.x:
				max_v.x = point.x
			if point.x < min_v.x:
				min_v.x = point.x
			if point.z > max_v.y:
				max_v.y = point.z
			if point.z < min_v.y:
				min_v.y = point.z
	var size_v = max_v - min_v
	for i in range(shapes.size()):
		shapes.insert(2 * i + 1, Transform().scaled(Vector3(1, 1, 1)).translated(0 * Vector3(-size_v.x / 2, 0, size_v.y / 2)))
	mesh_library.set_item_shapes(index, shapes)
	ResourceSaver.save(path, mesh_library)
