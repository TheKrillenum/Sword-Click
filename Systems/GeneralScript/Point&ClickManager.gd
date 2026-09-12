extends Node

var mouse_saved_pos: Vector2
var current_mouse_pos: Vector2
var last_highlighted_enemy: Interactible


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	highlight_nearest_clickable_interactible()


func highlight_nearest_clickable_interactible():
	
	if(current_mouse_pos):
		var nearest_distance: float = -100
		var nearest_enemy: Interactible
	
		if(EnemyManager.all_interactibles.is_empty()):
			last_highlighted_enemy = null
			return
	
		for enemy in EnemyManager.all_interactibles:
			var temp_distance: float = current_mouse_pos.distance_squared_to(enemy.global_position)
			if(nearest_distance == -100 || temp_distance < nearest_distance):
				nearest_distance = temp_distance
				nearest_enemy = enemy
	
		nearest_enemy.update_highlight_visibility(true)
	
		if(last_highlighted_enemy != nearest_enemy and last_highlighted_enemy != null):
			last_highlighted_enemy.update_highlight_visibility(false)
	
		last_highlighted_enemy = nearest_enemy
