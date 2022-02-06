extends Spatial


export (bool) var should_draw_cubes := false

var grid_step := 2.0
var grid_y := 0.5
var points := {}
var astar = AStar.new()

var cube_mesh = CubeMesh.new()
var red_material = SpatialMaterial.new()
var green_material = SpatialMaterial.new()


func _ready() -> void:
	red_material.albedo_color = Color.red
	green_material.albedo_color = Color.green
	cube_mesh.size = Vector3(0.25, 0.25, 0.25)
	var pathables = get_tree().get_nodes_in_group("pathable")
	_add_points(pathables)
	_connect_points()


func _add_points(pathables: Array):
	for pathable in pathables:
		var mesh = pathable.get_node("MeshInstance")
		var aabb: AABB = mesh.get_transformed_aabb()

		var start_point = aabb.position

		var x_steps = aabb.size.x / grid_step
		var z_steps = aabb.size.z / grid_step

		for x in x_steps:
			for z in z_steps:
				var next_point = start_point + Vector3(x * grid_step, 0, z * grid_step)
				_add_point(next_point)


func _add_point(point: Vector3):
	point.y = grid_y

	var id = astar.get_available_point_id()

	astar.add_point(id, point)
	points[world_to_astar(point)] = id
	_create_nav_cube(point)


func _connect_points():
	for point in points:
		var pos_str = point.split(",")
		var world_pos := Vector3(pos_str[0], pos_str[1], pos_str[2])
		var search_coords = [-grid_step, 0, grid_step]
		for x in search_coords:
			for z in search_coords:
				var search_offset = Vector3(x, 0, z)
				if search_offset == Vector3.ZERO:
					continue

				var potential_neighbor = world_to_astar(world_pos + search_offset)
				if points.has(potential_neighbor):
					var current_id = points[point]
					var neighbor_id = points[potential_neighbor]
					if not astar.are_points_connected(current_id, neighbor_id):
						astar.connect_points(current_id, neighbor_id)
						if should_draw_cubes:
							get_child(current_id).material_override = green_material
							get_child(neighbor_id).material_override = green_material


func _create_nav_cube(position: Vector3):
	if should_draw_cubes:
		var cube = MeshInstance.new()
		cube.mesh = cube_mesh
		cube.material_override = red_material
		add_child(cube)
		position.y = grid_y
		cube.global_transform.origin = position


func find_path(from: Vector3, to: Vector3) -> Array:
	var start_id = astar.get_closest_point(from)
	var end_id = astar.get_closest_point(to)
	return astar.get_point_path(start_id, end_id)


func world_to_astar(world: Vector3) -> String:
	var x = stepify(world.x, grid_step)
	var y = stepify(world.y, grid_step)
	var z = stepify(world.z, grid_step)
	return "%d,%d,%d" % [x, y, z]

