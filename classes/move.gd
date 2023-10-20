class_name Move
extends Node
## Represents a single move, including a starting square, destination square, and move result.


enum Result {MOVE, CAPTURE, CHECK, CASTLE, PROMOTE, DOUBLE}

var start_square: int
var end_square: int
var result: Result


func _init(start: int, end: int, result: Result = Result.MOVE):
	self.start_square = start
	self.end_square = end
	self.result = result
