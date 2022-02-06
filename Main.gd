extends Spatial


func _ready() -> void:
	$PlayerController.connect("obstacle_should_spawn", $ObstacleContainer, "handle_obstacle_should_spawn")
