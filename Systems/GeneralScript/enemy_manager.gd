extends Node

var all_interactibles: Array[Interactible]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(!all_interactibles.is_empty()):
		for enemy in all_interactibles:
			enemy.enemy_ai()
