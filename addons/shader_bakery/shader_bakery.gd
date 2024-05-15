extends Object

# Static class - do not instantiate.
class_name ShaderBakery

static func bake_shader(
	shader : Shader, 
	texture_width : int, 
	texture_height : int, 
	file_path : String, 
	should_scan_for_import : bool = true):
	
	var viewport_rid := RenderingServer.viewport_create()
	var canvas_rid := RenderingServer.canvas_create()
	var shader_rid := shader.get_rid()
	var material_rid := RenderingServer.material_create()
	var canvas_item_rid := RenderingServer.canvas_item_create()
	var screen_texture_rid : = RenderingServer.viewport_get_texture(viewport_rid)
	
	RenderingServer.viewport_set_size(viewport_rid, texture_width, texture_height)
	RenderingServer.viewport_set_render_direct_to_screen(viewport_rid, false)
	RenderingServer.viewport_set_update_mode(viewport_rid, RenderingServer.VIEWPORT_UPDATE_ONCE)
	RenderingServer.viewport_set_measure_render_time(viewport_rid, true)
	RenderingServer.viewport_attach_canvas(viewport_rid, canvas_rid)
	RenderingServer.viewport_set_active(viewport_rid, true)
	
	RenderingServer.material_set_shader(material_rid, shader_rid)
	
	RenderingServer.canvas_item_set_material(canvas_item_rid, material_rid)
	RenderingServer.canvas_item_set_parent(canvas_item_rid, canvas_rid)
	RenderingServer.canvas_item_add_rect(canvas_item_rid, Rect2(0, 0, texture_width, texture_height), Color(1, 1, 1))
	
	RenderingServer.force_draw()
	RenderingServer.force_sync()
	
	var image := RenderingServer.texture_2d_get(screen_texture_rid)
	image.save_png(file_path)
	if should_scan_for_import:
		EditorInterface.get_resource_filesystem().scan_sources()
	
	RenderingServer.free_rid(canvas_item_rid)
	RenderingServer.free_rid(material_rid)
	RenderingServer.free_rid(canvas_rid)
	RenderingServer.free_rid(viewport_rid)
