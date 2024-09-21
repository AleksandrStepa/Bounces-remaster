extends Node2D

const LEFT_BORDER := -288
const RIGHT_BORDER := 288
const BLOCK_SIZE := 64

var first_line_y := -352
var possible_positions := range(LEFT_BORDER, RIGHT_BORDER+1, BLOCK_SIZE)
var block_positions := []
var block_scene := preload("res://elements/block/block.tscn")
var num_blocks := 3
var num_lines := 6
var is_lines_ready := false
var is_checking_lines := false

var rng := RandomNumberGenerator.new()

func line_checking_enable():
	is_checking_lines = true


func line_generate():
	var block_index := 0
	while block_index <= num_blocks:
		var x_postion = possible_positions[randi() % possible_positions.size()]
		if x_postion not in block_positions:
			var current_position := Vector2(x_postion, first_line_y)
			var block := block_scene.instantiate()
			block.position = current_position
			block_positions.append(x_postion)
			block_index += 1
			add_child(block)
	is_lines_ready = false


func check_block_fallen(block):
	return not block.is_falling


func check_lines_fallen():
	var existed_blocks := get_tree().get_nodes_in_group("Blocks")
	if existed_blocks.all(check_block_fallen):
		is_checking_lines = false
		is_lines_ready = true


func _ready():
	#line_generate()
	#block_positions = []
	pass


func _process(delta):
	if is_checking_lines:
		check_lines_fallen()
	if is_lines_ready:
		line_generate()
		block_positions = []
