extends Node2D

enum GameState{
	WAITING_INPUT_PRESS,
	WAITING_INPUT_RELEASE,
	IN_PROCESS,
}

@onready var card_storage: CardStorage = $CardStorage
@onready var card_storage_2: CardStorage = $CardStorage2
@onready var card_storage_3 = $CardStorage3
@onready var _deck = %Deck
@onready var _drew_cards = %DrewCards

const CARD_MOVE_TIME: float = 0.2

var dragged_cards: DraggedCards = null
var game_state: GameState = GameState.WAITING_INPUT_PRESS

class DraggedCards:
	const BASE_Z_INDEX: int = 100
	var dragged_cards: Array[Card] = []
	var previous_card_storage: CardStorage = null


	func _init(cards: Array[Card], card_storage: CardStorage)->void:
		dragged_cards = cards.duplicate(true)
		previous_card_storage = card_storage
		_modify_cards_z_index()


	func _modify_cards_z_index():
		for i in dragged_cards.size():
			dragged_cards[i].set_z_index(BASE_Z_INDEX + i)
	
	
	func get_dragged_cards()->Array[Card]:
		return dragged_cards
	
	
	func get_dragged_cards_front()->Card:
		return dragged_cards.front()
		
		
	func get_previous_card_storage()->CardStorage:
		return previous_card_storage


func _ready()->void:
	place_card_storage(spawn_card(1, AutoLoad.CardSuit.CLUB), card_storage)
	place_card_storage(spawn_card(12, AutoLoad.CardSuit.CLUB), card_storage)
	place_card_storage(spawn_card(2, AutoLoad.CardSuit.HEART), card_storage_2)
	place_card_storage(spawn_card(2, AutoLoad.CardSuit.HEART), card_storage_2)
	place_card_storage(spawn_card(1, AutoLoad.CardSuit.SPADE), card_storage_3)
	place_card_storage(spawn_card(1, AutoLoad.CardSuit.SPADE), card_storage_3)
	
	place_deck(spawn_card(1, AutoLoad.CardSuit.SPADE))
	

func spawn_card(value: int, suit: AutoLoad.CardSuit)->Card:
	var card_scene = load("res://scenes/card/card.tscn")
	var card_instance: Card = card_scene.instantiate()
	add_child(card_instance)
	card_instance.set_value(value)
	card_instance.set_suit(suit)
	
	return card_instance


func place_card_storage(card: Card, card_storage: CardStorage)->void:
	card.global_position = card_storage.get_next_card_position()
	card_storage.add_stacked_card(card)


func place_deck(card: Card)->void:
	card.global_position = _deck.global_position
	_deck.add_stacked_card(card)
	card.show_back()


func set_card_tween_to_card_storage(card: Card, card_storage: CardStorage)->void:
	card.set_tween_destination(card_storage.get_next_card_position())
	card_storage.add_stacked_card(card)


func _process(delta)->void:
	input_left_click()


func input_left_click():
	var mouse_position := get_global_mouse_position()
	
	if Input.is_action_just_pressed("left_click") && game_state == GameState.WAITING_INPUT_PRESS:
		game_state = GameState.IN_PROCESS
		
		if _deck.check_collision(mouse_position):
			var deck_card: Card = _deck.pop_back_stacked_card()
			
			if deck_card == null:
				var drew_cards = _drew_cards.pop_all_stacked_cards()
				
				if drew_cards.size() == 0:
					game_state = GameState.WAITING_INPUT_PRESS
					return
				
				for card in drew_cards:
					card.set_tween_destination(_deck.global_position)
					_deck.add_stacked_card(card)
				
				await tween_cards(drew_cards)
				game_state = GameState.WAITING_INPUT_PRESS
				return
				
				
			deck_card.hide_back()
			_drew_cards.add_stacked_card(deck_card)
			deck_card.set_tween_destination(_drew_cards.global_position)
			await tween_cards([deck_card])
			game_state = GameState.WAITING_INPUT_PRESS
			return
		
		
		
		var card_storages = get_tree().get_nodes_in_group("card_storage")
		for card_storage in card_storages:
			var cards: Array[Card] = card_storage.deliver_stacked_cards(mouse_position)
			if cards.size() != 0:
				dragged_cards = DraggedCards.new(cards, card_storage)
				break
				
		if dragged_cards == null:
			game_state = GameState.WAITING_INPUT_PRESS
		else:
			game_state = GameState.WAITING_INPUT_RELEASE
			
			
	if Input.is_action_pressed("left_click") && game_state == GameState.WAITING_INPUT_RELEASE:
		drag_cards()
		
	if Input.is_action_just_released("left_click") && game_state == GameState.WAITING_INPUT_RELEASE:
		game_state = GameState.IN_PROCESS
		
		var is_return_card_storage: bool = true
		var card_storages = get_tree().get_nodes_in_group("card_storage")
		for card_storage in card_storages:
			if card_storage == dragged_cards.get_previous_card_storage():
				continue

			if card_storage.check_collision_next_card_area(mouse_position):
				if card_storage.is_placeable(dragged_cards.get_dragged_cards_front()):
					var cards = dragged_cards.get_dragged_cards()
					is_return_card_storage = false
					for card in cards:
						card.set_tween_destination(card_storage.get_next_card_position())
						set_card_tween_to_card_storage(card, card_storage)
					break
		
		if is_return_card_storage:
			var previous_card_storage = dragged_cards.get_previous_card_storage()
			var cards = dragged_cards.get_dragged_cards()
			for card in cards:
				card.set_tween_destination(previous_card_storage.get_next_card_position())
				set_card_tween_to_card_storage(card, previous_card_storage)
		
		await tween_cards(dragged_cards.get_dragged_cards())
		dragged_cards = null
		game_state = GameState.WAITING_INPUT_PRESS


func drag_cards()->void:
	if dragged_cards == null:
		return
		
	var cards: Array[Card] = dragged_cards.get_dragged_cards()
	for card in cards:
		card.dragged_global_position(get_global_mouse_position())


func tween_cards(cards: Array[Card])->void:
	var tween = create_tween().set_parallel(true)
	for card in cards:
		tween.tween_property(card, "global_position", card.get_tween_destination(), CARD_MOVE_TIME)
	await tween.finished


