extends CharacterBody2D
class_name Enemy

signal enemy_died(id: int)

# scene for factory function
const ENEMY: PackedScene = preload("uid://kjpcet4hpt5j")

# network data
var id: int
var is_puppet: bool

# loaded from EnemyData
var target: Player
var hp: int
var movespeed: float
var attack: PackedScene
var attack_rate: float
var attack_timer: float = 0
var sprite_tex: Texture2D
var collision_shape: RectangleShape2D
var movement_component: MovementComponent

# Node refs
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D

# Factory function
static func from_data(enemy_data: EnemyData, p_id: int) -> Enemy:
	var enemy: Enemy = ENEMY.instantiate()
	enemy.id = p_id
	enemy.hp = enemy_data.hp
	enemy.movespeed = enemy_data.movespeed
	enemy.attack = enemy_data.attack
	enemy.attack_rate = enemy_data.attack_rate
	enemy.sprite_tex = enemy_data.sprite
	enemy.movement_component = enemy_data.movement_component.instantiate()
	enemy.add_child(enemy.movement_component)
	var hitbox_shape: RectangleShape2D = RectangleShape2D.new()
	hitbox_shape.size = enemy_data.size
	enemy.collision_shape = hitbox_shape
	return enemy

func _ready():
	#enemies are always puppets on clients
	is_puppet = !Network.is_server
	Gamestate.enemies[id] = self
	sprite.texture = sprite_tex
	hitbox.shape = collision_shape
	if !is_puppet:
		target = Gamestate.players.values().pick_random()

func _physics_process(delta):
	if !is_puppet:
		attack_timer += delta
		if attack_timer >= attack_rate:
			attack_timer = 0
			ToClientRpcs.trigger_enemy_attack.rpc(id, target.network_data.id)
	velocity = movement_component.get_movement(target)
	move_and_slide()

func trigger_attack(p_target: Player):
	var attack_scene: Attack = attack.instantiate()
	attack_scene.target = p_target
	add_child(attack_scene)

func take_damage(damage: int, attacker_id: int):
	if Gamestate.players.has(attacker_id):
		target = Gamestate.players[attacker_id]
	hp = clampi(hp - damage, 0, Constants.BIG_INT)
	if hp <= 0 && !is_puppet:
		print('dying')
		ToClientRpcs.trigger_enemy_death.rpc(id)

func die():
	Gamestate.enemies.erase(id)
	enemy_died.emit(id)
	queue_free()
