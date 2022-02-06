extends Spatial


const OBSTACLE = preload("res://Obstacle.tscn")

signal obstacle_added(obstacle)
signal obstacle_removed(obstacle)


func create_obstacle(location: Vector3):
	var obstacle_instance = OBSTACLE.instance()
	add_child(obstacle_instance)
	obstacle_instance.global_transform.origin = location
	emit_signal("obstacle_added", obstacle_instance)


func delete_obstacle(obstacle: StaticBody):
	emit_signal("obstacle_removed", obstacle)
	obstacle.queue_free()


func handle_obstacle_should_spawn(location: Vector3):
	var snapped_location = Vector3(
		stepify(location.x, 2),
		1.5,
		stepify(location.z, 2)
	)

	for c in get_children():
		if c.global_transform.origin == snapped_location:
			delete_obstacle(c)
			return

	create_obstacle(snapped_location)
