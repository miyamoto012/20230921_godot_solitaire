class_name Card
extends Node2D

const CARD_WIDTH: int = 40
const CARD_HEIGHT: int = 50

enum CardColor{
	BLACK,
	RED,
}

var _clicked_local_position: Vector2 = Vector2.ZERO
var _tween_destination: Vector2
var _suit: AutoLoad.CardSuit
var _value: int
var _card_color: CardColor

@onready var _suit_label = $Front/SuitLabel
@onready var _value_label = $Front/ValueLabel
@onready var _back = $Back

func _ready():
	_tween_destination = global_position
	
	
func set_value(value: int)->void:
	_value = value
	_value_label.set_text("%d"%value)
	

func get_value()->int:
	return _value
	

func get_card_color()->CardColor:
	return _card_color
	
	
func set_suit(suit: AutoLoad.CardSuit):
	_suit = suit
	
	match suit:
		AutoLoad.CardSuit.CLUB:
			_suit_label.set_text("♧")
			_card_color = CardColor.BLACK
		AutoLoad.CardSuit.SPADE:
			_suit_label.set_text("♤")
			_card_color = CardColor.BLACK
		AutoLoad.CardSuit.DIAMOND:
			_suit_label.set_text("♢")
			_card_color = CardColor.RED
		AutoLoad.CardSuit.HEART:
			_suit_label.set_text("♡")
			_card_color = CardColor.RED
		

func get_suit()->AutoLoad.CardSuit:
	return _suit
	
	
func show_back()->void:
	_back.show()
	

func hide_back()->void:
	_back.hide()
	

func check_collision(mouse_global_position: Vector2)->bool:
	if _back.is_visible():
		return false
	
	if mouse_global_position.x < (global_position.x - CARD_WIDTH/2.0):
		return false
		
	if  (global_position.x + CARD_WIDTH/2.0) < mouse_global_position.x:
		return false
		
	if mouse_global_position.y < (global_position.y - CARD_HEIGHT/2.0):
		return false
		
	if  (global_position.y + CARD_HEIGHT/2.0) < mouse_global_position.y:
		return false
		
	return true

	
func set_clicked_local_position(mouse_global_position: Vector2):
	_clicked_local_position = global_position - mouse_global_position
	
	
func set_tween_destination(destination_global_position: Vector2)->void:
	_tween_destination = destination_global_position
	
	
func get_tween_destination()->Vector2:
	return _tween_destination
	
	
func dragged_global_position(mouse_global_position: Vector2):
	global_position = _clicked_local_position + mouse_global_position

