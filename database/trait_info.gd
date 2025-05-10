@icon("res://assets/icons/damage.png")
class_name TraitInfo
extends Resource

enum EffectType {
    BLUDGEONING,
    PIERCING,
    FIRE,
    COLD,
    LIGHTNING,
    POISON,
    HEAL,
    SHIELD,
    EFFECT_TYPE_LAST
}

enum StatusType {
    STUN,
    BLEEDING,
    BURN,
    FROZEN,
    SHOCK,
    POISONED,
    HP_REGENERATION,
    SHIELD_REGENERATION,
    STATUS_TYPE_LAST
}

@export_range(0.0, 100.0, 1.0, "or_greater") var effect_amount: float = 0.0
@export var effect_type: EffectType = EffectType.EFFECT_TYPE_LAST
@export_range(0.0, 1.0, 0.01, "or_greater") var status_build_up: float = 0.0
@export var status_type: StatusType = StatusType.STATUS_TYPE_LAST
