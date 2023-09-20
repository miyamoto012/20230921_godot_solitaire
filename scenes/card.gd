class_name Card
extends Node2D


const CARD_WIDTH: int = 40
const CARD_HEIGHT: int = 50


func check_collision(object_position: Vector2)->bool:
	if object_position.x < global_position.x - CARD_WIDTH/2.0:
		return false
		
	if  global_position.x + CARD_WIDTH/2.0 < object_position.x:
		return false
		
	if object_position.y < global_position.y - CARD_HEIGHT/2.0:
		return false
		
	if  global_position.y + CARD_HEIGHT/2.0 < object_position.y:
		return false
	
	return true
