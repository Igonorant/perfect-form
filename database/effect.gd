class_name Effect
extends Resource

@export var effects: Array[EffectRes]

func _to_string() -> String:
    var result: String = ""
    for i in range(effects.size()):
        result += effects[i]._to_string()
        if i < effects.size() - 1:
            result += "\n"
    return result

func get_effects() -> Array[EffectRes]:
    return effects
