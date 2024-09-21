extends Node2D

var orb_scene := preload("res://elements/orb/orb.tscn")
var num_orbs := 5
var list_orbs := []
var orbs_on_base := 0
var last_orb_index := 0
var touch_position: Vector2
var start_position : Vector2
var is_ready_to_shoot := true
var is_aiming := false

@onready var sight := $Sight

func _ready():
	start_position = global_position
	sight.global_position = global_position
	
	for index in range(num_orbs):
		var orb := orb_scene.instantiate()
		add_child(orb)
		list_orbs.append(orb)
		
		
func _draw():
	if is_aiming:
		draw_set_transform_matrix(get_global_transform().affine_inverse())
		draw_dashed_line(sight.global_position, sight.get_collision_point(), Color.ALICE_BLUE, 4.0, 4.0)


func _process(delta):
		queue_redraw()



func _input(event: InputEvent):
	if is_ready_to_shoot:
		if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
			is_aiming = true
			sight.target_position = (get_global_mouse_position() - sight.global_position) * 100
			
		if event is InputEventScreenTouch and event.is_released():
			touch_position = get_global_mouse_position()
			is_aiming = false
			is_ready_to_shoot = false
			for current_orb in list_orbs:
				current_orb.start_position_init = start_position
				current_orb.touch_position_init = touch_position
				current_orb.shoot()

				await get_tree().create_timer(0.1).timeout



func orbs_on_base_check():
	orbs_on_base += 1
	if orbs_on_base == len(list_orbs):
		orbs_on_base = 0
		
		var on_base_time_list := []
		for current_orb in list_orbs:
			on_base_time_list.append(current_orb.on_base_time)
		last_orb_index = on_base_time_list.find(on_base_time_list.max())
		start_position = list_orbs[last_orb_index].global_position
		get_tree().call_group("Orbs", "move_to_start", start_position)
		sight.global_position = start_position
		get_tree().call_group("Blocks", "fall")
		get_tree().call_group("BlockGenerator", "line_checking_enable")

		is_ready_to_shoot = true


