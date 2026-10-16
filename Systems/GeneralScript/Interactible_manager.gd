extends Node

var all_enemies: Array[BaseEnemy]
var all_interactible: Array[Interactible]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(!all_enemies.is_empty()):
		for enemy in all_enemies:
			enemy.enemy_ai()
