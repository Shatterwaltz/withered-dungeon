extends Shot
class_name Arrow

var speed: float = 1500
var direction: Vector2

func _ready() -> void:
	direction = target - position
	look_at(target)

func _physics_process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
	velocity = direction.normalized() * speed
	move_and_slide()
