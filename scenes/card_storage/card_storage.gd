class_name card_storage
extends Node2D

const CARD_WIDTH: int = 40
const CARD_HEIGHT: int = 50

const UNIT_SHIFT_HEIGHT: int = 20

var stacked_cards: Array[Card] = []

func check_collision_next_card_area(mouse_global_position: Vector2)->bool:
	var shift_height: int = UNIT_SHIFT_HEIGHT * stacked_cards.size()
	if mouse_global_position.x < global_position.x - CARD_WIDTH/2.0:
		return false
		
	if  global_position.x + CARD_WIDTH/2.0 < mouse_global_position.x:
		return false
		
	if mouse_global_position.y < global_position.y + shift_height - CARD_HEIGHT/2.0 :
		return false
		
	if  global_position.y + shift_height + CARD_HEIGHT/2.0 < mouse_global_position.y:
		return false
	
	return true

func get_next_card_position()->Vector2:
	var shift_height: int = UNIT_SHIFT_HEIGHT * stacked_cards.size()
	return Vector2(global_position.x, global_position.y + shift_height)
