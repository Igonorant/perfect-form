class_name Enums
extends Resource

# enum CollisionCategory {
#     ENVIRONMENT,
#     ALLY,
#     ENEMY,
#     ENVIRONMENT_EFFECT,
#     ALLY_EFFECT,
#     ENEMY_EFFECT
# }
# static func collision_category_to_string(collision_category: CollisionCategory) -> StringName:
#     match collision_category:
#         CollisionCategory.ENVIRONMENT: return "ENVIRONMENT"
#         CollisionCategory.ALLY: return "ALLY"
#         CollisionCategory.ENEMY: return "ENEMY"
#         CollisionCategory.ENVIRONMENT_EFFECT: return "ENVIRONMENT_EFFECT"
#         CollisionCategory.ALLY_EFFECT: return "ALLY_EFFECT"
#         CollisionCategory.ENEMY_EFFECT: return "ENEMY_EFFECT"
#     return ""
# static func get_collision_layer(collision_category: CollisionCategory) -> int:
#     match collision_category:
#         CollisionCategory.ENVIRONMENT: return 0b000001
#         CollisionCategory.ALLY: return 0b000010
#         CollisionCategory.ENEMY: return 0b000100
#         CollisionCategory.ENVIRONMENT_EFFECT: return 0b001000
#         CollisionCategory.ALLY_EFFECT: return 0b010000
#         CollisionCategory.ENEMY_EFFECT: return 0b100000
#     return -1
# static func get_collision_mask(collision_category: CollisionCategory) -> int:
#     match collision_category:
#         CollisionCategory.ENVIRONMENT: return 0b000111
#         CollisionCategory.ALLY: return 0b000111
#         CollisionCategory.ENEMY: return 0b000111
#         CollisionCategory.ENVIRONMENT_EFFECT: return 0b000110
#         CollisionCategory.ALLY_EFFECT: return 0b000101
#         CollisionCategory.ENEMY_EFFECT: return 0b000011
#     return -1

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
static func effect_type_to_string(effect_type: EffectType) -> StringName:
    match effect_type:
        EffectType.BLUDGEONING: return "BLDG"
        EffectType.PIERCING: return "PIRC"
        EffectType.FIRE: return "FIRE"
        EffectType.COLD: return "COLD"
        EffectType.LIGHTNING: return "LIGN"
        EffectType.POISON: return "POSN"
        EffectType.HEAL: return "HEAL"
        EffectType.SHIELD: return "SHLD"
    return ""


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
static func status_type_to_string(status_type: StatusType) -> StringName:
    match status_type:
        StatusType.STUN: return "STUN"
        StatusType.BLEEDING: return "BLED"
        StatusType.BURN: return "BURN"
        StatusType.FROZEN: return "FROZ"
        StatusType.SHOCK: return "SHCK"
        StatusType.POISONED: return "POSN"
        StatusType.HP_REGENERATION: return "HPRG"
        StatusType.SHIELD_REGENERATION: return "SHRG"
    return ""
