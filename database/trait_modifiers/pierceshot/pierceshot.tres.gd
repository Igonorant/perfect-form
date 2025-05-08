class_name PierceshotRes
extends TraitModifier

func spawn_power_inject(_power: Power, spawn_info: SpawnInfo) -> void:
    spawn_info.has_pierce_modifier = true
