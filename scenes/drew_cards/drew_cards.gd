extends Node2D

var stacked_cards: Array[Card] = []


func add_stacked_card(card: Card)->void:
	card.set_z_index(stacked_cards.size())
	stacked_cards.append(card)


func pop_all_stacked_cards()->Array[Card]:
	var buf_cards = stacked_cards.duplicate()
	stacked_cards.clear()
	return buf_cards
