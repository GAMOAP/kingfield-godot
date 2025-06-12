extends Node2D

@onready var spot_container = $spot_container

const _board_size:int = 5
const _slot_size:int = 16

var dragging_spot: Area2D = null
var drag_offset: Vector2 = Vector2.ZERO

var spot_count := 0
var _spot_list := []
 
var _spot
var _new_spot_frame := 0 :
	set(value):
		_new_spot_frame = value
		_spot.set_frame(_new_spot_frame)

func _ready():
	#Create slots in grid
	for row in range(_board_size):
		for col in range(_board_size):
			var slot = preload("res://src/admin/card_board/board_slot.tscn").instantiate()
			var pos = Vector2(col, row)
			slot.add_to_group("admin_board_slot")
			slot.data = [col - 2,row * -1 + 2]
			slot.position = pos * _slot_size
			$slot_container.add_child(slot)
			
	for spot in $case_image.get_children():
		spot.add_to_group("admin_board_slot")
		
	_new_spot()

func _new_spot(pos := Vector2(136, 24), frame := 0, lock := false):
	var spot = preload("res://src/admin/card_board/board_spot.tscn").instantiate()
	spot.spot_lock_in_area.connect(_on_spot_locked)
	spot.name = "spot_%d" % spot_count
	spot_count += 1
	
	spot.global_position = pos
	spot.set_frame(frame)
	spot.lock = lock
	spot_container.add_child(spot)
	
	if lock == false:
		_spot = spot
	else :
		spot_container.move_child(spot, 0)

func _remove_spot() -> void:
	var spot_object_list := [] 
	for spot in $spot_container.get_children():
		if spot.lock == true:
			spot_object_list.append(spot)
	if spot_object_list.size() > 0:
		var last_spot = spot_object_list[spot_object_list.size() - 1]
		last_spot.queue_free()

func _on_spot_locked(spot) -> void:
	var merge_spot = false
	for locked_spot in _spot_list:
		if locked_spot.start == spot.start:
			locked_spot.end.append(spot.end[0])
			merge_spot = true
	if merge_spot == false:
		_spot_list.append(spot)
	_new_spot()

func set_spot_list(spot_list: Array) -> void:
	for spot in spot_list:
		_spot_list.append(spot)
		var start = spot["start"]
		var x = (start[0] + 2) * _slot_size + _slot_size/2
		var y = (start[1] + 2) * _slot_size + _slot_size/2
		var pos := Vector2(x, y)
		for frame in spot["end"]:
			_new_spot(pos, frame, true)

func get_spot_list() -> Array:
	return _spot_list

func _on_btn_left_pressed() -> void:
	_new_spot_frame -= 1
	if _new_spot_frame < 0:
		_new_spot_frame = 8

func _on_btn_right_pressed() -> void:
	_new_spot_frame += 1
	if _new_spot_frame > 8:
		_new_spot_frame = 0

func _on_btn_remove_pressed() -> void:
	_remove_spot()
