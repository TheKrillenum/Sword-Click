extends Node

var mouse_saved_pos: Vector2
var current_mouse_pos: Vector2
var last_highlighted_interactible: Interactible = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	highlight_nearest_clickable_interactible()


func highlight_nearest_clickable_interactible():
	
	if(current_mouse_pos):
		var nearest_distance: float = -100
		var nearest_interactible: Interactible
	
		if(InteractibleManager.all_interactible.is_empty()):
			last_highlighted_interactible = null
			return
	
		for n in InteractibleManager.all_interactible:
			var temp_distance: float = current_mouse_pos.distance_squared_to(n.global_position)
			if(nearest_distance == -100 || temp_distance < nearest_distance):
				nearest_distance = temp_distance
				nearest_interactible = n
	
		nearest_interactible.update_highlight_visibility(true)
	
		if(last_highlighted_interactible != nearest_interactible and last_highlighted_interactible != null):
			last_highlighted_interactible.update_highlight_visibility(false)
	
		last_highlighted_interactible = nearest_interactible
