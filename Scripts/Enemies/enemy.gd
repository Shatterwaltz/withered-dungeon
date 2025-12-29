extends CharacterBody2D
class_name Enemy

var id: int
var is_puppet: bool

var target: Player
var hp: int
var movespeed: float
var attack: PackedScene
var attack_rate: float
var attack_timer: float = 0
var sprite: Sprite2D

# Factory function
static func with_data(enemy_data: EnemyData, p_id: int) -> Enemy:
	var enemy: Enemy = Enemy.new()
	enemy.id = p_id
	enemy.hp = enemy_data.hp
	enemy.movespeed = enemy_data.movespeed
	enemy.attack = enemy_data.attack
	enemy.attack_rate = enemy_data.attack_rate
	var enemy_sprite: Sprite2D = Sprite2D.new()
	enemy_sprite.texture = enemy_data.sprite
	enemy.sprite = enemy_sprite
	enemy.add_child(enemy_sprite)
	return enemy

func _ready():
	#enemies are always puppets on clients
	is_puppet = !Network.is_server
	Gamestate.enemies[id] = self
	if !is_puppet:
		target = Gamestate.players.values().pick_random()

func _physics_process(delta):
	if !is_puppet:
		attack_timer += delta
		if attack_timer >= attack_rate:
			attack_timer = 0
			ToClientRpcs.trigger_enemy_attack.rpc(id, target.network_data.id)

func trigger_attack(p_target: Player):
	var attack_scene: Attack = attack.instantiate()
	attack_scene.target = p_target
	add_child(attack_scene)

func take_damage(damage: int):
	hp = clampi(hp - damage, 0, Constants.BIG_INT)
	if hp <= 0 && !is_puppet:
		ToClientRpcs.trigger_enemy_death.rpc(id)

func die():
	Gamestate.enemies.erase(id)
