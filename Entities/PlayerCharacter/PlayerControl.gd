class_name Player extends CharacterBody2D

# VARIABLES ------------------------------------------------------------------

# Singleton
static var player_character: Player

# Player properties
var max_health: float = 10.0
var health: float = max_health
var armor: float = 0.0
var dead: bool = false

# Movement variable
var current_target: Interactible
const SPEED: float = 300
var debug_mode_target: Vector2

# Sword variables
@export var TEMP_SWORD: Sword

# Animation variables
@export var sprite: AnimatedSprite2D

# FUNCTIONS -------------------------------------------------------------------

static func get_player()->Player:
	if(player_character == null):
		pass
	return player_character


func _init() -> void:
	if(player_character == null):
		player_character = self
	else:
		print_debug("Two player instance")


func _ready() -> void:
	if(player_character == null):
		player_character = self
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, TEMP_SWORD.sword_range, Color.BLACK, false, 2.0)


func _physics_process(_delta: float) -> void:
	move_and_slide()


func _process(_delta: float) -> void:
	if(dead):
		return
	
	PointAndClick.current_mouse_pos = get_global_mouse_position()
	
	if(Input.is_action_just_pressed("RightClick")):
		debug_test()
		# Pure debugging over here guys


func heal(heal_amount: float) -> void:
	health += heal_amount
	if(health > max_health):
		health = max_health


func take_damage(damage_amount: float) -> void:
	health -= damage_amount
	if(health <= 0.0):
		player_death()
	else:
		sprite.play("Damaged")


func player_death() -> void:
	sprite.visible = false


func debug_test() -> void:
	TEMP_SWORD.throw_weapon(get_global_mouse_position())


func debug_mode() -> void:
	if(GlobalDataCollection.debug_mode == false):
		GlobalDataCollection.debug_mode = true
		print_debug("Debug mode on")
	else:
		GlobalDataCollection.debug_mode = false
		print_debug("Debug mode off")
