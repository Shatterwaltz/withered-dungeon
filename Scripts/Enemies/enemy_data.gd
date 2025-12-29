extends Resource
class_name EnemyData

# max hp
@export var hp: int = 100
# movement speed
@export var movespeed: float = 500
# scene containing attack logic
@export var attack: PackedScene
# time in seconds between attack triggers
@export var attack_rate: float = 5
@export var sprite: Texture2D
