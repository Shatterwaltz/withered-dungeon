extends Shot
class_name Arrow

var speed: float = 2000
var direction: Vector2

func _ready() -> void:
	direction = target - position
	look_at(target)
	body_entered.connect(_on_collide)

func _physics_process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
	position += direction.normalized() * speed * delta

func _on_collide(body: Node2D):
	if !is_puppet:
		if body is Enemy:
			ToServerRpcs.damage_enemy.rpc_id(1, body.id, damage)
	queue_free()
