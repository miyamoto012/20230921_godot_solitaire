extends Node2D

@onready var card: Card = $Card


func _process(delta)->void:
	check_left_click()


func check_left_click():
	var mouse_position := get_global_mouse_position()
	
	if Input.is_action_just_pressed("left_click"):
		if card.check_collision(mouse_position):
			print("click")
		
