extends KinematicBody


# Called when the node enters the scene tree for the first time.
func _ready():
	global_transform.origin = $"../SpawnPoint".global_transform.origin
