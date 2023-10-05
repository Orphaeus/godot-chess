extends Node


@onready var mockfish = $Mockfish
@onready var gui = $GUI


func _on_piece_picked(square: int) -> void:
	var legal_moves : Array[Move] = mockfish.get_legal_moves_for_square(square)
	gui.highlight_legal_moves(legal_moves)


func _on_piece_unpicked(square: int) -> void:
	var legal_moves : Array[Move] = mockfish.get_legal_moves_for_square(square)
	gui.unhighlight(legal_moves)
