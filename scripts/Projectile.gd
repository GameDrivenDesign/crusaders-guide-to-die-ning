extends KinematicBody

var target: Spatial
export var lifetime = 3
var damage = 2.0
var speed = 10.0
var velocity

func _physics_process(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
		return
	if not is_instance_valid(target):
		target = null
	if target:
		var direction = target.global_transform.origin - global_transform.origin
		velocity = direction.normalized() * speed
	var collision = move_and_collide(velocity * delta)
	look_at(global_transform.origin + velocity, Vector3.UP)
	if collision:
		collided_with(collision.collider)

func collided_with(body):
	if body.is_in_group("enemy"):
		body.damage(damage)
		queue_free()
