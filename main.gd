extends Node


@onready var mockfish := $Mockfish
@onready var gui := $GUI
@onready var gui_pieces := $GUI/GUIPieces

var picked_legal_moves : Array[Move]


func _on_piece_picked(piece: GUI_Piece) -> void:
	var square : int = BoardHelper.get_square_from_coords(piece.start_coords)
	picked_legal_moves = mockfish.get_legal_moves_for_square(square)
	gui.highlight_legal_moves(picked_legal_moves)


func _on_piece_unpicked(piece: GUI_Piece) -> void:
	gui.unhighlight(picked_legal_moves)
	# Validate requested move
	var start_square : int = BoardHelper.get_square_from_coords(piece.start_coords)
	var end_square : int = BoardHelper.get_square_from_coords(piece.end_coords)
	var requested_move = Move.new(start_square,end_square)

	var move_approved := false
	for move in picked_legal_moves:
		if move.end_square == requested_move.end_square:
			move_approved = true
			Position.make_move(move)
			mockfish.update_moves()
			gui_pieces.update_pieces()
			break
	if not move_approved:
		gui_pieces.update_pieces()
