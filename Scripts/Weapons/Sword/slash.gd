extends Shot
class_name Slash

func _ready():
	look_at(target)
	lifetime = .2

func _physics_process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
