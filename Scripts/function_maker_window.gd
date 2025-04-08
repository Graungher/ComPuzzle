extends Window

signal SaveThis(customFuncName: String, displayName)
var disName
var realName

func _on_function_maker_save_this(customFuncName: String, displayName: Variant) -> void:
	
	disName = displayName
	realName = customFuncName
	emit_signal("SaveThis", realName, disName)
	print("WINDOW TEST")
	pass # Replace with function body.
