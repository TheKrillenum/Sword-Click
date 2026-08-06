class_name Player extends CharacterBody2D

# VARIABLES ------------------------------------------------------------------

# Singleton
static var player_character: Player

# Movement variable
var current_target: Interactible
var next_target_buffer: Interactible
var buffer_count: int = 0
var active_buffer: bool = false
const SPEED: float = 300
var MOVE: bool = false
const NEXT_TARGET_BUFFER_DURATION: int = 16

# Sword variables
@export var TEMP_SWORD: Sword

# Animation variables
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# FUNCTIONS -------------------------------------------------------------------

static func get_player()->Player:
	if(player_character == null):
		player_character = Player.new()
	return player_character


func _ready() -> void:
	if(player_character == null):
		player_character = self


func _physics_process(_delta: float) -> void:
	
	#Moving -------------
	if(Input.is_action_just_pressed("LeftClick")):
		if(MOVE == true):
			buffer_next_target()
		else:
			set_new_target()
		
	if(MOVE):
		velocity = position.direction_to(current_target.position) * SPEED
		
		if(position.distance_to(current_target.position) < (TEMP_SWORD.sword_range * 0.75)):
			TEMP_SWORD.dash_attack(current_target.position)
			
			if(active_buffer):
				current_target = next_target_buffer
				active_buffer = false
			else:
				stop_movement()
		
	if(Input.is_action_just_pressed("RightClick")):
		debug_test()
	
	move_and_slide()
	
	if(active_buffer):
		buffer_count = buffer_count + 1
		if(buffer_count >= NEXT_TARGET_BUFFER_DURATION):
			print_debug("Buffer duration ran out")
			active_buffer = false
	
	#Animation -----------
	if(MOVE == true):
		sprite.play("Run")
	else:
		sprite.play("Idle")


func set_new_target() -> void:
	
	if(PointAndClick.last_highlighted_enemy == null):
		return
	
	var selected_enemy: Interactible = PointAndClick.last_highlighted_enemy
	
	if(self.position.distance_to(selected_enemy.position) <= TEMP_SWORD.sword_range):
		TEMP_SWORD.perform_combo_attack(selected_enemy.position)
	else:
		MOVE = true
		current_target = selected_enemy


func stop_movement() -> void:
	velocity = Vector2(0,0)
	MOVE = false


func buffer_next_target() -> void:
	
	if(PointAndClick.last_highlighted_enemy == null):
		return
	
	active_buffer = true
	buffer_count = 0
	next_target_buffer = PointAndClick.last_highlighted_enemy


func debug_test() -> void:
	for n in TEMP_SWORD.check_for_area(0.0, Vector2(10.0,10.0), get_global_mouse_position(), Sword.Shape.SLASH):
		n.take_damage(1.0)
