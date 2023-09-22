extends Node2D

@onready var card: Card = $Card
@onready var card_storage = $CardStorage

var dragged_cards: Array[Card] = []

func _process(delta)->void:
	input_left_click()
	drag_card()


func input_left_click():
	var mouse_position := get_global_mouse_position()
	
	if Input.is_action_just_pressed("left_click"):
		if card.check_collision(mouse_position):
			dragged_cards.append(card) 
			dragged_cards[0].set_clicked_local_position(mouse_position)
	if Input.is_action_just_released("left_click") && dragged_cards.size() != 0:
			if card_storage.check_collision_next_card_area(mouse_position):
				dragged_cards[0].set_tween_destination(card_storage.get_next_card_position())
			tween_dragged_cards()
			dragged_cards.clear()
			


func tween_dragged_cards()->void:
	var tween = create_tween().set_parallel(true)
	for card in dragged_cards:
		tween.tween_property(card, "global_position", card.get_tween_destination(), 0.3)


func drag_card()->void:
	if dragged_cards.size() == 0:
		return

	for card in dragged_cards:
		card.dragged_global_position(get_global_mouse_position())
	
		

