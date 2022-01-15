extends KinematicBody

var velocity: Vector3 setget set_velocity
export var lifetime = 3

func _physics_process(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
		return
	var collision = move_and_collide(velocity * delta)
	if collision:
		collided_with(collision.collider)

func collided_with(body):
	queue_free()

func set_velocity(new_velocity):
	velocity = new_velocity
	look_at(velocity, Vector3.UP)
