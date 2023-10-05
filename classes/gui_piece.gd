class_name GUI_Piece
extends AnimatedSprite2D
## Contains code to drive the GUI pieces


signal piece_picked(gui_piece: GUI_Piece)
signal piece_unpicked(gui_piece: GUI_Piece)

var color: int
var piece: int
var start_coords: Vector2
var end_coords: Vector2

var _picked := false

func _process(_delta):
	if _picked:
		set_position(get_global_mouse_position())


func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if (
			event is InputEventMouseButton
			and event.button_index == 1
			and event.is_pressed()
	):
		_picked = true
		top_level = true
		start_coords = position
		emit_signal("piece_picked", self)
	if (
			_picked
			and event is InputEventMouseButton
			and event.button_index == 1
			and not event.is_pressed()
	):
		_picked = false
		top_level = false
		end_coords.x = floori(position.x / 64) * 64 - 32 # + 32 to center the piece, - 64 for parent global offset
		end_coords.y = floori(position.y / 64) * 64 - 32
		position = end_coords
		emit_signal("piece_unpicked", self)


func set_pickable(value: bool) -> void:
	$Area2D.set_pickable(value)
