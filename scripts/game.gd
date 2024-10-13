extends Node

var state = {
	"HAS_FLASHLIGHT": false
}

func load_conversation(path:String):
	if path != "":
		var raw_string = FileAccess.open(path, FileAccess.READ).get_as_text(true)
		var json = JSON.new()
		return json.parse_string(raw_string)
	return {}
