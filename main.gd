extends Node2D

@onready var card: Card = $Card

var dragged_card: Card = null

func _process(delta)->void:
	input_left_click()
	drag_card()


func input_left_click():
	var mouse_position := get_global_mouse_position()
	
	if Input.is_action_just_pressed("left_click"):
		if card.check_collision(mouse_position):
			dragged_card = card
			dragged_card.set_clicked_local_position(mouse_position)
	if Input.is_action_just_released("left_click") && dragged_card != null:
			dragged_card = null
		

func drag_card()->void:
	if dragged_card == null:
		return
	
	dragged_card.dragged_global_position(get_global_mouse_position())
	
		
