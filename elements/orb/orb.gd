extends CharacterBody2D

var SPEED := 1000.0
var direction: Vector2
var is_flying := false
#var is_shootable := true
var is_moving := false
var start_position_init: Vector2
var touch_position_init: Vector2
var on_base_time := 0


func shoot():
	direction = -(start_position_init - touch_position_init).normalized()
	is_flying = true
	#is_shootable = false
	
	
func move_to_start(start_position: Vector2):
	start_position_init = start_position
	is_moving = true


func _physics_process(delta):
	if is_flying:
		var collider = move_and_collide(direction.normalized() * SPEED * delta)
		if collider:
			handle_collision(collider)
			
	if is_moving:
		global_position = global_position.move_toward(start_position_init, SPEED * delta)
		if global_position == start_position_init:
			is_moving = false
			#is_shootable = true


func handle_collision(collider: KinematicCollision2D):
	direction = collider.get_remainder().bounce(collider.get_normal())


func _on_area_2d_body_entered(body: StaticBody2D):
	if body.name == "Floor":
		is_flying = false
		on_base_time = Time.get_ticks_usec()
		get_tree().call_group("OrbShooter", "orbs_on_base_check")
