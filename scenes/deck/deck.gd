class_name Deck
extends Node2D

const CARD_WIDTH: int = 40
const CARD_HEIGHT: int = 50

var stacked_cards: Array[Card] = []


func set_stacked_cards(cards: Array[Card])->void:
	stacked_cards = cards.duplicate(true)
	
	
func add_stacked_card(card: Card)->void:
	card.set_z_index(stacked_cards.size())
	stacked_cards.append(card)


func check_collision(mouse_global_position: Vector2)->bool:
	if mouse_global_position.x < (global_position.x - CARD_WIDTH/2.0):
		return false
		
	if  (global_position.x + CARD_WIDTH/2.0) < mouse_global_position.x:
		return false
		
	if mouse_global_position.y < (global_position.y - CARD_HEIGHT/2.0):
		return false
		
	if  (global_position.y + CARD_HEIGHT/2.0) < mouse_global_position.y:
		return false
		
	return true


func pop_back_stacked_card()->Card:
	return stacked_cards.pop_back()
	
