extends Area2D

var fall_speed := 200
var is_hidet := false
var min_durability := 1
var max_durability := 5
var fall_distance := 64
var durability := min_durability
var is_falling := false
var destination_position := global_position
var rng := RandomNumberGenerator.new()

@onready var lable := $Label

func _ready():
	durability = rng.randi_range(min_durability, max_durability)
	lable.text = str(durability)
	
	
func fall():
	destination_position = global_position
	destination_position.y += fall_distance
	is_falling = true


func _process(delta):
	if is_falling:
		global_position = global_position.move_toward(destination_position, delta*fall_speed)
	if global_position == destination_position:
		is_falling = false
		


func _on_body_entered(body: CharacterBody2D):
	durability -= 1
	lable.text = str(durability)
	if durability == 0 and not is_hidet:
		is_hidet = true
		queue_free()
