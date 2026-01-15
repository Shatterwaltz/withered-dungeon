extends Resource
class_name EnemyData

# max hp
@export var hp: int = 100
# movement speed
@export var movespeed: float = 500
# scene containing attack logic
@export var attack: PackedScene
# movement component
@export var movement_component: PackedScene
# time in seconds between attack triggers
@export var attack_rate: float = 5
# sprite texture
@export var sprite: Texture2D
# hitbox dimensions
@export var size: Vector2
