extends Control
## Manages the piece elements of the GUI


signal piece_picked(piece: GUI_Piece)
signal piece_unpicked(piece: GUI_Piece)

var _GUI_Piece : PackedScene = preload("res://scenes/gui_piece.tscn")


func _ready():
	update_pieces()


func update_pieces() -> void:
	# Set up position and gui_pieces
	for child in get_children():
		child.queue_free()
	var i : int = 0
	for square in Position.board:
		if square != Piece.NONE:
			var new_gui_piece : GUI_Piece = _GUI_Piece.instantiate()
			var square_coords := BoardHelper.get_coords_from_square(i)
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

	if Position.color_to_move == Piece.WHITE:
		get_tree().call_group("white_pieces", "set_pickable", true)
		get_tree().call_group("black_pieces", "set_pickable", false)
	else:
		get_tree().call_group("white_pieces", "set_pickable", false)
		get_tree().call_group("black_pieces", "set_pickable", true)


func _on_piece_picked(piece:GUI_Piece) -> void:
	emit_signal("piece_picked", piece)


func _on_piece_unpicked(piece:GUI_Piece) -> void:
	emit_signal("piece_unpicked", piece)
