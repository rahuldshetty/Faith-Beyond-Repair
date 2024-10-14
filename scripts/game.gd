extends Node

const TOTAL_BATTERY = 1

var state = {
	"HAS_FLASHLIGHT": false,
	"HAS_GIJOE": false,
	"HAS_BATTERY": 0,
	"SAFE_ZONE": false,
	"LAMP_FIXED": false,
	"GAME_END": false
}

# Testing
#var state = {
	#"HAS_FLASHLIGHT": true,
	#"HAS_GIJOE": false,
	#"HAS_BATTERY": 0
#}

func load_conversation(path:String):
	if path != "":
		var raw_string = FileAccess.open(path, FileAccess.READ).get_as_text(true)
		var json = JSON.new()
		return json.parse_string(raw_string)
	return {}
