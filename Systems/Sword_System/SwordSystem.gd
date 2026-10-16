class_name SwordSystem extends Node

var sword_active: Sword
var sword_dropped: Array[Sword] = []
var sword_on_player: Array[Sword] = []


func _init() -> void:
	SignalBus.next_sword.connect(switch_to_next_sword)
	SignalBus.previous_sword.connect(switch_to_previous_sword)
	SignalBus.throw_sword.connect(throw_sword)


func _ready() -> void:
	
	for sword in get_children():
		if sword is Sword:
			sword_on_player.push_back(sword)
	
	if sword_on_player.is_empty():
		push_warning("SwordSystem has no Sword children.")
		return
	
	update_player_active_sword()


func update_player_active_sword()->void:
	sword_active = sword_on_player[0]
	sword_active.sprite_visibility(true)
	SignalBus.active_sword_changed.emit(sword_active)


func switch_to_next_sword()->void:
	sword_active.sprite_visibility(false)
	
	# Remove the first index and place it last
	sword_on_player.push_back(sword_on_player.pop_front())
	update_player_active_sword()


func switch_to_previous_sword()->void:
	sword_active.sprite_visibility(false)
	
	# Remove the last index and place it first
	sword_on_player.push_front(sword_on_player.pop_back())
	update_player_active_sword()


func throw_sword()->void:
	sword_active.throw_weapon(PointAndClick.current_mouse_pos)
	sword_dropped.append(sword_on_player.pop_front())
	update_player_active_sword


func pick_up_sword(picked_up_sword: Sword)->void:
	if picked_up_sword in sword_dropped:
		var dropped_sword_index: int = sword_dropped.find(picked_up_sword)
		sword_dropped.remove_at(dropped_sword_index)
		sword_on_player.push_back(picked_up_sword)
	else:
		push_warning("Tried to pick up a sword that wasn't dropped")
