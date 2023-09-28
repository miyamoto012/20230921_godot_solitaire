extends Node2D

enum GameState{
	WAITING_INPUT_PRESS,
	WAITING_INPUT_RELEASE,
	IN_PROCESS,
}

@onready var CAED_SCENE = preload("res://scenes/card/card.tscn")
@onready var card_storage: CardStorage = $CardStorage
@onready var card_storage_2: CardStorage = $CardStorage2

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
	
		
	func get_previous_card_storage()->CardStorage:
		return previous_card_storage


func _ready()->void:
	for i in range(0, 2):
		var card_instance = CAED_SCENE.instantiate() as Card
		add_child(card_instance)
		place_card(card_instance, card_storage)
		card_instance.hide_back()
		
	for i in range(0, 2):
		var card_instance = CAED_SCENE.instantiate() as Card
		add_child(card_instance)
		place_card(card_instance, card_storage_2)
		card_instance.hide_back()


func place_card(card: Card, card_storage: CardStorage)->void:
	card.global_position = card_storage.get_next_card_position()
	card_storage.add_stacked_card(card)


func set_card_tween_to_card_storage(card: Card, card_storage: CardStorage)->void:
	card.set_tween_destination(card_storage.get_next_card_position())
	card_storage.add_stacked_card(card)



func _process(delta)->void:
	input_left_click()
#	drag_cards()


func input_left_click():
	var mouse_position := get_global_mouse_position()
	
	if Input.is_action_just_pressed("left_click") && game_state == GameState.WAITING_INPUT_PRESS:
		game_state = GameState.IN_PROCESS
		
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
				var cards = dragged_cards.get_dragged_cards()
				is_return_card_storage = false
				for card in cards:
					card.set_tween_destination(card_storage.get_next_card_position())
					set_card_tween_to_card_storage(card, card_storage)
		
		if is_return_card_storage:
			var previous_card_storage = dragged_cards.get_previous_card_storage()
			var cards = dragged_cards.get_dragged_cards()
			for card in cards:
				card.set_tween_destination(previous_card_storage.get_next_card_position())
				set_card_tween_to_card_storage(card, previous_card_storage)
		
		await tween_dragged_cards()
		dragged_cards = null
		game_state = GameState.WAITING_INPUT_PRESS


func drag_cards()->void:
	if dragged_cards == null:
		return
		
	var cards: Array[Card] = dragged_cards.get_dragged_cards()
	for card in cards:
		card.dragged_global_position(get_global_mouse_position())


func tween_dragged_cards()->void:
	if dragged_cards == null:
		return
	
	var tween = create_tween().set_parallel(true)
	for card in dragged_cards.get_dragged_cards():
		tween.tween_property(card, "global_position", card.get_tween_destination(), CARD_MOVE_TIME)

	await tween.finished



