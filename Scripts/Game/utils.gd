extends Node
class_name Utils

static var _id: int = 0

static func generate_id() -> int:
	_id += 1
	return _id
