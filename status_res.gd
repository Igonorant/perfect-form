@icon("res://assets/icons/external/pixel-boy/node_2D/icon_character.png")
class_name StatusRes
extends Resource

@export_group("Health and Shield")

@export_range(0.0, 2000.0, 1.0, "or_greater") var max_hp: float = 100.0
@export_range(0.0, 100.0, 0.1, "or_greater", "suffix:hp/s") var hp_regen: float = 0.0

@export_range(0.0, 2.0, 0.1, "suffix:s") var invulnerability_window: float = 0.0

@export_range(0.0, 2000.0, 1.0, "or_greater") var max_shield: float = 0.0
@export_range(0.0, 2000.0, 0.1, "or_greater", "suffix:shield/s") var shield_regen: float = 0.0
@export_range(0.1, 10.0, 0.1, "suffix:s") var shield_regen_wait_time: float = 4.0


@export_group("Effects and Status")

@export_subgroup("Bludgeoning")
@export_range(0.0, 1.0, 0.01) var bludgeoning_effect_resistance: float = 0.0
@export_range(0.0, 1.0, 0.01) var stun_status_resistance: float = 0.0
@export_subgroup("Piercing")
@export_range(0.0, 1.0, 0.01) var piercing_effect_resistance: float = 0.0
@export_range(0.0, 1.0, 0.01) var bleeding_status_resistance: float = 0.0
@export_subgroup("Fire")
@export_range(0.0, 1.0, 0.01) var fire_effect_resistance: float = 0.0
@export_range(0.0, 1.0, 0.01) var burn_status_resistance: float = 0.0
@export_subgroup("Cold")
@export_range(0.0, 1.0, 0.01) var cold_effect_resistance: float = 0.0
@export_range(0.0, 1.0, 0.01) var frozen_status_resistance: float = 0.0
@export_subgroup("Lightning")
@export_range(0.0, 1.0, 0.01) var lightning_effect_resistance: float = 0.0
@export_range(0.0, 1.0, 0.01) var shock_status_resistance: float = 0.0
@export_subgroup("Poison")
@export_range(0.0, 1.0, 0.01) var poison_effect_resistance: float = 0.0
@export_range(0.0, 1.0, 0.01) var poisoned_status_resistance: float = 0.0


@export_group("Movement")

## Maximum speed in pixels/sec
@export_range(0.0, 1000.0, 1.0, "or_greater", "suffix:pixels/s") var max_speed: float = 500.0

## Time in seconds to reach the maximum speed.
## 0.0 means speed will be reached instantly.
@export_range(0.0, 5.0, 0.01, "or_greater", "suffix:seconds") var acceleration_time: float = 0.0

## Time in seconds to stop when there is no acceleration, 999 means no deceleration.
## This is used to calculate the static and dynamic friction.
## NOTE: Instead of 999 it should be INF, but using INF does not work well in the editor
@export_range(0.01, 5.0, 0.01, "or_greater", "suffix:seconds") var deceleration_time: float = 999.0
