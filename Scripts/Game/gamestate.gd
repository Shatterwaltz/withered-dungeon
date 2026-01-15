extends Node

var seed_val: int = 0
var players: Dictionary[int, Player] = {}
var enemies: Dictionary[int, Enemy] = {}
var loaded_layouts: Dictionary[int, Layout] = {}
var level_load_offset: int = 0
