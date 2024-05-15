@tool
extends EditorPlugin

var shader_baker_inspector_plugin : ShaderBakerInspectorPlugin

func _enter_tree():
	shader_baker_inspector_plugin = ShaderBakerInspectorPlugin.new()
	add_inspector_plugin(shader_baker_inspector_plugin)

func _exit_tree():
	remove_inspector_plugin(shader_baker_inspector_plugin)
