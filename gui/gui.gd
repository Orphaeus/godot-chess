extends Control


@onready var board := $GridContainer/HBoxContainer/Board
@onready var highlighter := $GridContainer/HBoxContainer/Highlighter

@export var legal_move_color := Color("00ff76b1")
@export var selected_color := Color("00d7f7c8")
@export var capture_color := Color("f30000a8")


func highlight_legal_moves(moves: Array[Move]) -> void:
	if len(moves) != 0:
		for move in moves:
			if move.result == Move.Result.CAPTURE:
				highlighter.add_highlight(move.end_square, capture_color)
			else:
				highlighter.add_highlight(move.end_square, legal_move_color)
		highlighter.add_highlight(moves[0].start_square, selected_color)


func unhighlight(moves: Array[Move]) -> void:
	if len(moves) != 0:
		for move in moves:
			highlighter.remove_highlight(move.end_square)
		highlighter.remove_highlight(moves[0].start_square)
