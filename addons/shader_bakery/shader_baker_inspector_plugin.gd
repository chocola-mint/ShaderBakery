extends EditorInspectorPlugin

class_name ShaderBakerInspectorPlugin

var baker : ShaderBaker
var preview_square_container : AspectRatioContainer
var preview_rect_material : ShaderMaterial

func _can_handle(object : Object):
	return object is ShaderBaker

func _parse_begin(object : Object):
	baker = object as ShaderBaker
	preview_square_container = AspectRatioContainer.new()
	var preview_rect := ColorRect.new()
	preview_square_container.add_child(preview_rect)
	preview_rect.color = Color.WHITE
	preview_rect_material = ShaderMaterial.new()
	preview_rect.material = preview_rect_material
	add_custom_control(preview_square_container)
	
	add_custom_control(_create_spacer())
	
	var button := Button.new()
	button.text = "Bake Shader"
	button.theme_type_variation = "InspectorActionButton"
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.icon = EditorInterface.get_editor_theme().get_icon("Shader", "EditorIcons")
	button.connect("pressed", func(): _on_bake_button_pressed(baker))
	add_custom_control(button)
	
	add_custom_control(_create_spacer())

func _parse_property(object : Object, type : int, name : String, hint_type : int, hint_string : String, usage_flags : int, wide : bool):
	# EditorProperty is used to dynamically update the shader preview.
	if name == "shader":
		add_property_editor(name, ShaderProperty.new(baker, preview_rect_material))
	if name == "texture_width" or name == "texture_height":
		add_property_editor(name, TextureSizeProperty.new(baker, preview_square_container))
	return false

func _create_spacer(height : int = 5) -> Control:
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, height * EditorInterface.get_editor_scale())
	return spacer

func _on_bake_button_pressed(baker : ShaderBaker):
	var dir = DirAccess.open(baker.directory)
	if not dir:
		var err = DirAccess.get_open_error()
		printerr("Shader baker could not open the directory at path = \"" + baker.directory + "\". Error code: " + str(err))
		return
	var file_path := dir.get_current_dir() + "/" + baker.file_name + ".png"
	
	ShaderBakery.bake_shader(baker.shader, baker.texture_width, baker.texture_height, file_path)

class ShaderProperty extends EditorProperty:
	var baker : ShaderBaker = null
	var preview_material : ShaderMaterial = null
	func _init(baker : ShaderBaker, preview_material : ShaderMaterial):
		self.baker = baker
		self.preview_material = preview_material
		hide()
		_update_property()

	func _update_property():
		preview_material.shader = baker.shader

class TextureSizeProperty extends EditorProperty:
	var baker : ShaderBaker
	var preview_square_container : AspectRatioContainer
	func _init(baker : ShaderBaker, preview_square_container : AspectRatioContainer):
		self.baker = baker
		self.preview_square_container = preview_square_container
		hide()
		_update_property()

	func _update_property():
		const ratio_limit := 10.0
		var aspect_ratio := float(baker.texture_width) / float(baker.texture_height)
		aspect_ratio = clampf(aspect_ratio, 1.0 / ratio_limit, ratio_limit)
		preview_square_container.ratio = aspect_ratio
		preview_square_container.custom_minimum_size = Vector2(200, 200) * EditorInterface.get_editor_scale()
