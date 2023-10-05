extends Control
## Manages the piece elements of the GUI


signal piece_picked(piece: GUI_Piece)
signal piece_unpicked(piece: GUI_Piece)

var _GUI_Piece : PackedScene = preload("res://scenes/gui_piece.tscn")
var _picked_gui_piece: GUI_Piece


func _ready():
	# Set up position and gui_pieces
	var i : int = 0
	for square in Position.board:
		if square != Piece.NONE:
			var new_gui_piece : GUI_Piece = _GUI_Piece.instantiate()
			var square_coords := Vector2(32 + (i % 8) * 64, 32 + (i / 8) * 64)
			new_gui_piece.set_position(square_coords)
			new_gui_piece.set_animation(str(square))
			new_gui_piece.piece = square
			new_gui_piece.color = Piece.get_color(square)
			new_gui_piece.connect("piece_picked", _on_piece_picked)
			new_gui_piece.connect("piece_unpicked", _on_piece_unpicked)

			var group := "white_pieces" if new_gui_piece.color == Piece.WHITE else "black_pieces"
			new_gui_piece.add_to_group(group)

			add_child(new_gui_piece)
		i += 1
	get_tree().call_group("black_pieces", "set_pickable", false)


func update_pieces() -> void:
	pass # Read from position


func _on_piece_picked(piece:GUI_Piece) -> void:
	emit_signal("piece_picked", _get_square_from_coords(piece.start_coords))


func _on_piece_unpicked(piece:GUI_Piece) -> void:
	emit_signal("piece_unpicked", _get_square_from_coords(piece.start_coords))


## Calculate square index given coords
func _get_square_from_coords(pos:Vector2) -> int:
	return (pos.y - 32) / 64 * 8 + (pos.x - 32) / 64
