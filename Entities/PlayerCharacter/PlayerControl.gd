class_name Player extends CharacterBody2D

# VARIABLES ------------------------------------------------------------------

# Singleton
static var player_character: Player

# Player properties
var max_health: float = 10.0
var health: float = max_health
var armor: float = 0.0
var dead: bool = false
var invincible: bool = false

# Movement variable
var current_target: Interactible
const SPEED: float = 400
var debug_mode_target: Vector2

# Sword variables
var active_sword: Sword

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
	
	SignalBus.active_sword_changed.connect(set_active_sword)


func _ready() -> void:
	if(player_character == null):
		player_character = self
		
	queue_redraw()


func _draw() -> void:
	if(active_sword):
		draw_circle(Vector2.ZERO, active_sword.stats.sword_range, Color.BLACK, false, 2.0)


func _physics_process(_delta: float) -> void:
	PointAndClick.current_mouse_pos = get_global_mouse_position()
	move_and_slide()
	if(!is_instance_valid(current_target)):
		current_target = null


func _unhandled_input(event: InputEvent) -> void:
	
	if(event.is_action_pressed("RightClick")):
		debug_mode()
		print_debug("Debug mode")
	
	if(event.is_action_pressed("ScrollUp")):
		print_debug("Scroll up")
		next_sword()
	
	if(event.is_action_pressed("ScrollDown")):
		print_debug("scroll down")
		previous_sword()
	
	if(event.is_action_pressed("Throw")):
		SignalBus.throw_sword.emit()
		print_debug("Throw")

# Player Helth & Damage system ---------------------------------------------------------------------

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

# Sword management function ------------------------------------------------------------------------

func set_active_sword(new_active_sword: Sword)->void:
	active_sword = new_active_sword


func next_sword()->void:
	SignalBus.next_sword.emit()


func previous_sword()->void:
	SignalBus.previous_sword.emit()

# Debug --------------------------------------------------------------------------------------------

func debug_mode() -> void:
	if(GlobalDataCollection.debug_mode == false):
		GlobalDataCollection.debug_mode = true
		print_debug("Debug mode on")
	else:
		GlobalDataCollection.debug_mode = false
		print_debug("Debug mode off")
