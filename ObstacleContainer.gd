extends Spatial


const OBSTACLE = preload("res://Obstacle.tscn")


func handle_obstacle_should_spawn(location: Vector3):
	var snapped_location = Vector3(
		stepify(location.x, 2),
		1.5,
		stepify(location.z, 2)
	)

	for c in get_children():
		if c.global_transform.origin == snapped_location:
			c.queue_free()
			return

	var obstacle_instance = OBSTACLE.instance()
	add_child(obstacle_instance)
	print(snapped_location)
	obstacle_instance.global_transform.origin = snapped_location
