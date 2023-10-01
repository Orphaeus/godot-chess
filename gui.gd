extends Control


@onready var cli = $VBoxContainer/CLI


func _on_cli_text_submitted(new_text: String) -> void:
	var parts : PackedStringArray = new_text.split(" ")
	if len(parts) == 1:
		_set_error_text("No args found")
		return
	if parts[0] == "legal":
		pass
		# parts[1] should be a square that gets looked up and passed to the engine for legal moves
	elif parts[0] not in ["legal"]:
		_set_error_text("Command not recognized")


func _set_error_text(text):
		cli.text = ""
		cli.placeholder_text = text
