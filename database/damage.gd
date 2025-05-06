@icon("res://assets/icons/damage.png")
class_name Damage
extends Resource

enum DamageType {
    NONE,
    PHYSICAL,
    FIRE,
    COLD,
    LIGHTNING,
    POISON
}

@export var amount: float = 0.0
@export var type: DamageType = DamageType.NONE
