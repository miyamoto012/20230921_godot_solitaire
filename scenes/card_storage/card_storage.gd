class_name CardStorage
extends Node2D

const CARD_WIDTH: int = 40
const CARD_HEIGHT: int = 50
const UNIT_SHIFT_HEIGHT: int = 20

var stacked_cards: Array[Card] = []


func add_stacked_card(card: Card)->void:
	card.set_z_index(stacked_cards.size())
	stacked_cards.append(card)


func check_collision_next_card_area(mouse_global_position: Vector2)->bool:
	var shift_height: int = UNIT_SHIFT_HEIGHT * stacked_cards.size()
	const HALF_WIDTH: float = CARD_WIDTH/2.0
	const HALF_HEIGHT: float = CARD_HEIGHT/2.0
	
	if mouse_global_position.x < (global_position.x - HALF_WIDTH):
		return false
		
	if  (global_position.x + HALF_WIDTH) < mouse_global_position.x:
		return false
		
	if mouse_global_position.y < (global_position.y + shift_height - HALF_HEIGHT):
		return false
		
	if  (global_position.y + shift_height + HALF_HEIGHT) < mouse_global_position.y:
		return false
		
	return true
	
	
func is_placeable(card: Card)->bool:
	if stacked_cards.size() == 0:
		if card.get_value() == 12:
			return true
		else:
			return false

	var top_card: Card = stacked_cards.back()
	
	if card.get_card_color() == top_card.get_card_color():
		return false
		
	if card.get_value() != (top_card.get_value() - 1):
		return false
		
	return true


func get_next_card_position()->Vector2:
	var shift_height: int = UNIT_SHIFT_HEIGHT * stacked_cards.size()
	return Vector2(global_position.x, global_position.y + shift_height)
	
	
func deliver_stacked_cards(mouse_global_position: Vector2)->Array[Card]:
	var collision_index = -1
	for i in stacked_cards.size():
		if stacked_cards[i].check_collision(mouse_global_position):
			collision_index = i
	if collision_index == -1:
		return []
		
	var dragged_cards: Array[Card] = stacked_cards.slice(collision_index)
	stacked_cards = stacked_cards.slice(0, collision_index)
	
	for card in dragged_cards:
		card.set_clicked_local_position(mouse_global_position)
	
	return dragged_cards
