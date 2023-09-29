extends Node
## Primary engine node


func _ready() -> void:
	var move : Move = $Movegen.generate_moves()[7]
	print("\n",[move.start_square, move.end_square, move.result])
	var test_board = Position.board
	test_board[move.end_square] = test_board[move.start_square]
	test_board[move.start_square] = 0
	Position.pretty_print_board(test_board)
