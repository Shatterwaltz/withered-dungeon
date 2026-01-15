extends Attack

func _ready():
	#print("%s, %s" % [target.network_data.id, multiplayer.get_unique_id()])
	queue_free()
