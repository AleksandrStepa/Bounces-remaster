extends RigidBody2D

var is_flying := false
var is_shootable := true
var speed := 180000.0
var start_position_init: Vector2
var touch_position_init: Vector2
var on_base_time := 0


func shoot():
	is_flying = true
	is_shootable = false
	set_contact_monitor(true)

func move_to_start(start_position: Vector2):
	PhysicsServer2D.body_set_state(get_rid(), PhysicsServer2D.BODY_STATE_TRANSFORM, Transform2D.IDENTITY.translated(start_position))
	is_shootable = true
	set_sleeping(false)
	
	
func _physics_process(delta: float):
	if is_flying:
		var direction := -(start_position_init - touch_position_init).normalized()
		linear_velocity = direction * delta * speed
		is_flying = false


func _on_body_entered(body: StaticBody2D):
	if body.name == "Floor":
		set_sleeping(true)
		on_base_time = Time.get_ticks_usec()
		get_tree().call_group("OrbShooter", "orbs_on_base_check")
