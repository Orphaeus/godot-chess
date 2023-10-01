extends Node
## Handles generation of moves for the engine


## NW, N, NE, W, E, SW, S, SE
const DIRECTION_OFFSETS : Array[int] = [7, 8, 9, -1, 1, -9, -8, -7]
const KNIGHT_OFFSETS : Array[int] = [15, 17, 6, 10, -10, -6, -17, -15]

var num_squares_to_edge := {}


func _ready() -> void:
	_precompute_move_data()


func generate_moves() -> Array[Move]:
	var moves: Array[Move]
	var i : int = 0
	for square in Position.board:
		var piece : int = square
		if Piece.get_color(piece) == Position.color_to_move:
			match Piece.get_type(piece):
				Piece.PAWN:
					moves.append_array(_generate_pawn_moves(i))
				Piece.KNIGHT:
					moves.append_array(_generate_knight_moves(i))
				Piece.BISHOP:
					moves.append_array(_generate_bishop_moves(i))
				Piece.ROOK:
					moves.append_array(_generate_rook_moves(i))
				Piece.QUEEN:
					moves.append_array(_generate_queen_moves(i))
				Piece.KING:
					moves.append_array(_generate_king_moves(i))
				Piece.NONE:
					continue
		i += 1
	return moves


func _generate_pawn_moves(start_square: int) -> Array:
	var moves: Array[Move]
	var offsets := {}
	if Position.color_to_move == Piece.WHITE:
		offsets["single"] = 8 # N
		offsets["double"] = 16 # N * 2
		offsets["captures"] = [7, 9] # NW, NE
	else:
		offsets["single"] = -8 # S
		offsets["double"] = -16 # S * 2
		offsets["captures"] = [-7, -9] # SW, SE

	# Single push
	var end_square : int = start_square + offsets["single"]
	var piece_on_end_square : int = Position.board[end_square]
		# Blocked by friendly piece
	if Piece.get_color(piece_on_end_square) == Position.color_to_move:
		pass
	if Piece.get_type(piece_on_end_square) == Piece.NONE:
		moves.append(Move.new(start_square, end_square, Move.Result.MOVE))

	# Double push
	if start_square in range(8, 16):
		end_square = start_square + offsets["double"]
		piece_on_end_square = Position.board[end_square]
			# Blocked by friendly piece
		if Piece.get_color(piece_on_end_square) == Position.color_to_move:
			pass
		if Piece.get_type(piece_on_end_square) == Piece.NONE:
			moves.append(Move.new(start_square, end_square, Move.Result.MOVE))

	# Captures
	for offset in offsets["captures"]:
		end_square = start_square + offset
		piece_on_end_square = Position.board[end_square]
		if (
			(Piece.get_color(piece_on_end_square) != Position.color_to_move
			and Piece.get_type(piece_on_end_square) != Piece.NONE)
			or
			(end_square == Position.ep_target_square)
		):
			moves.append(Move.new(start_square, end_square, Move.Result.CAPTURE))

	return moves


func _generate_knight_moves(start_square: int) -> Array:
	var moves: Array[Move]
	for offset in KNIGHT_OFFSETS:
		var end_square : int = start_square + offset
		var piece_on_end_square : int = Position.board[end_square]

		# Blocked by friendly piece
		if Piece.get_color(piece_on_end_square) == Position.color_to_move:
			break
		if Piece.get_type(piece_on_end_square) == Piece.NONE:
			moves.append(Move.new(start_square, end_square, Move.Result.MOVE))
		# Separate return if it's a capture
		if (
				Piece.get_color(piece_on_end_square) != Position.color_to_move
				and Piece.get_type(piece_on_end_square) != Piece.NONE
		):
			moves.append(Move.new(start_square, end_square, Move.Result.CAPTURE))

	return moves


func _generate_bishop_moves(start_square: int) -> Array:
	# Check each direction
	var moves: Array[Move]
	for direction in [0, 2, 5, 7]: # NW, NE, SW, SE
		for n in num_squares_to_edge[start_square][direction]:
			var end_square : int = start_square + DIRECTION_OFFSETS[direction] * (n + 1)
			var piece_on_end_square : int = Position.board[end_square]

			# Blocked by friendly piece
			if Piece.get_color(piece_on_end_square) == Position.color_to_move:
				break
			if Piece.get_type(piece_on_end_square) == Piece.NONE:
				moves.append(Move.new(start_square, end_square, Move.Result.MOVE))
			# Can't move any further in this direction after capture
			if (
					Piece.get_color(piece_on_end_square) != Position.color_to_move
					and Piece.get_type(piece_on_end_square) != Piece.NONE # Not necessary after color bitmask rewrite?
			):
				moves.append(Move.new(start_square, end_square, Move.Result.CAPTURE))
				break
	return moves


func _generate_rook_moves(start_square: int) -> Array:
	# Check each direction
	var moves: Array[Move]
	for direction in [1, 3, 4, 6]: # N, W, E, S
		for n in num_squares_to_edge[start_square][direction]:
			var end_square : int = start_square + DIRECTION_OFFSETS[direction] * (n + 1)
			var piece_on_end_square : int = Position.board[end_square]

			# Blocked by friendly piece
			if Piece.get_color(piece_on_end_square) == Position.color_to_move:
				break
			if Piece.get_type(piece_on_end_square) == Piece.NONE:
				moves.append(Move.new(start_square, end_square, Move.Result.MOVE))
			# Can't move any further in this direction after capture
			if (
					Piece.get_color(piece_on_end_square) != Position.color_to_move
					and Piece.get_type(piece_on_end_square) != Piece.NONE
			):
				moves.append(Move.new(start_square, end_square, Move.Result.CAPTURE))
				break
	return moves


func _generate_queen_moves(start_square: int) -> Array:
	# Check each direction
	var moves: Array[Move]
	for direction in range(0, 8):
		for n in num_squares_to_edge[start_square][direction]:
			var end_square : int = start_square + DIRECTION_OFFSETS[direction] * (n + 1)
			var piece_on_end_square : int = Position.board[end_square]

			# Blocked by friendly piece
			if Piece.get_color(piece_on_end_square) == Position.color_to_move:
				break
			if Piece.get_type(piece_on_end_square) == Piece.NONE:
				moves.append(Move.new(start_square, end_square, Move.Result.MOVE))
			# Can't move any further in this direction after capture
			if (
					Piece.get_color(piece_on_end_square) != Position.color_to_move
					and Piece.get_type(piece_on_end_square) != Piece.NONE
			):
				moves.append(Move.new(start_square, end_square, Move.Result.CAPTURE))
				break
	return moves


func _generate_king_moves(start_square: int) -> Array:
	var moves: Array[Move]
	for direction in range(0, 8):
		if num_squares_to_edge[start_square][direction] > 0:
			var end_square : int = start_square + DIRECTION_OFFSETS[direction]
			var piece_on_end_square : int = Position.board[end_square]

			# Blocked by friendly piece
			if Piece.get_color(piece_on_end_square) == Position.color_to_move:
				break
			if Piece.get_type(piece_on_end_square) == Piece.NONE:
				moves.append(Move.new(start_square, end_square, Move.Result.MOVE))
			# Separate return if it's a capture
			if (
					Piece.get_color(piece_on_end_square) != Position.color_to_move
					and Piece.get_type(piece_on_end_square) != Piece.NONE
			):
				moves.append(Move.new(start_square, end_square, Move.Result.CAPTURE))

	return moves


## Calculate distance from each square to edge in all 8 directions at runtime
func _precompute_move_data() -> void:
	for rank in range(0,8):
		for file in range(0,8):
			var num_north : int = 7 - rank
			var num_south : int = rank
			var num_west : int = file
			var num_east : int = 7 - file

			var square_index : int = 8 * rank + file

			num_squares_to_edge[square_index] = [
				min(num_north, num_west),
				num_north,
				min(num_north, num_east),
				num_west,
				num_east,
				min(num_south, num_west),
				num_south,
				min(num_south,num_east),
			]
