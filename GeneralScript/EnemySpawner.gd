extends Node

@export var timer: Timer;
@export var test_enemy = preload("res://Interactibles/BaseInteractible/BaseInteractible.tscn")

var new_enemy: Interactible

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#timer.one_shot = true
	#timer.start(3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func spawn_enemy() -> void:
	if(test_enemy.can_instantiate()):
		new_enemy = test_enemy.instantiate() as Interactible
		
		if(new_enemy != null):
			new_enemy.global_position = Vector2( 50 , 30 )
			get_parent().add_child(new_enemy)
			return
			
		print_debug("Failed to spawn enemy")


func spawn_cycle() -> void:
	pass


func _on_timeout() -> void:
	spawn_enemy()
