extends Spatial


func _ready() -> void:
	$PlayerController.connect("obstacle_should_spawn", $ObstacleContainer, "handle_obstacle_should_spawn")
	$ObstacleContainer.connect("obstacle_added", $AStar, "handle_obstacle_added")
	$ObstacleContainer.connect("obstacle_removed", $AStar, "handle_obstacle_removed")
