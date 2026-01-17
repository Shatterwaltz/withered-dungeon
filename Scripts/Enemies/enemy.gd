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
# how much aggro each player has built up on this enemy
var aggro_build: Dictionary[int, int] = {}
# time in seconds between aggro updates
var aggro_update_rate: float = 10
var aggro_update_timer: float = 0
## Aggro threshold a player must beat to take aggro
var aggro_threshold: int = 0

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
	for player_id in Gamestate.players.keys():
		aggro_build[player_id] = 0

func _physics_process(delta):
	if !is_puppet:
		aggro_update_timer += delta
		if aggro_update_timer >= aggro_update_rate:
			aggro_update_timer -= aggro_update_rate
			_reset_aggro_buildup()
			# decay threshold by 90% each reset cycle
			aggro_threshold = floori(.9 * aggro_threshold)
		attack_timer += delta
		if attack_timer >= attack_rate:
			attack_timer -= attack_rate
			if target:
				ToClientRpcs.trigger_enemy_attack.rpc(id, target.network_data.id)
	velocity = movement_component.get_movement(target)
	move_and_slide()

## check for new aggro target and reset aggro buildup of each player
func _update_aggro():
	if !is_puppet:
		var new_target_id: int = -1
		if target:
			new_target_id = target.network_data.id
		for player_id in aggro_build.keys():
			if aggro_build[player_id] > aggro_threshold:
				new_target_id = player_id
				aggro_threshold = aggro_build[player_id]
		if new_target_id != -1:
			if target && target.network_data.id == new_target_id:
				return
			elif !target:
				## Give first person to hit bonus aggro
				aggro_threshold = aggro_build[new_target_id] * 3
			ToClientRpcs.update_enemy_target.rpc(id, new_target_id)
			# Reset aggro buildup when it acquires a new target to prevent pingponging
			_reset_aggro_buildup()

func _reset_aggro_buildup():
	for player_id in aggro_build.keys():
		aggro_build[player_id] = 0

func trigger_attack(p_target: Player):
	var attack_scene: Attack = attack.instantiate()
	attack_scene.target = p_target
	add_child(attack_scene)

func take_damage(damage: int, attacker_id: int):
	hp = clampi(hp - damage, 0, Constants.BIG_INT)
	aggro_build[attacker_id] += damage
	if !is_puppet:
		if hp <= 0:
			ToClientRpcs.trigger_enemy_death.rpc(id)
		else:
			_update_aggro()

func die():
	Gamestate.enemies.erase(id)
	enemy_died.emit(id)
	queue_free()
