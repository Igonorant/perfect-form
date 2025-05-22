class_name EffectRes
extends Resource

@export var effect_type: Enums.EffectType = Enums.EffectType.EFFECT_TYPE_LAST
@export_range(0.0, 2000.0, 1.0, "or_greater") var effect_value: float = 0.0
@export var status_type: Enums.StatusType = Enums.StatusType.STATUS_TYPE_LAST
@export_range(0.0, 1.0, 0.01, "or_greater") var status_buildup: float = 0.0

func _to_string() -> String:
    return "ET %s EV %d | ST %s SB %.2f" % [
        Enums.effect_type_to_string(effect_type),
        effect_value,
        Enums.status_type_to_string(status_type),
        status_buildup
    ]