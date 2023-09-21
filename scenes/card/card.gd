class_name Card
extends Node2D


const CARD_WIDTH: int = 40
const CARD_HEIGHT: int = 50

var _clicked_local_position: Vector2 = Vector2.ZERO
var _tween_destination: Vector2


func _ready():
	_tween_destination = global_position


func check_collision(mouse_global_position: Vector2)->bool:
	if mouse_global_position.x < global_position.x - CARD_WIDTH/2.0:
		return false
		
	if  global_position.x + CARD_WIDTH/2.0 < mouse_global_position.x:
		return false
		
	if mouse_global_position.y < global_position.y - CARD_HEIGHT/2.0:
		return false
		
	if  global_position.y + CARD_HEIGHT/2.0 < mouse_global_position.y:
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

