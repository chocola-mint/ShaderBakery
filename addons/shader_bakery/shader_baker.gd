extends Resource

class_name ShaderBaker

@export
var shader : Shader
@export_dir
var directory : String
@export
var file_name : String
@export_range(1, 8192, 1, "hide_slider", "or_greater")
var texture_width : int = 2048
@export_range(1, 8192, 1, "hide_slider", "or_greater")
var texture_height : int = 2048
