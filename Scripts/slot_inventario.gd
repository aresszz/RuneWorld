# slot_inventario.gd (versão 4.3)
extends Panel

var item_data: ItemResource = null
var quantidade: int = 0
var ui_inventario = null
var meu_indice: int = -1

func set_ui_controller(ui_reference):
	ui_inventario = ui_reference

func _on_mouse_entered():
	if item_data and ui_inventario:
		var texto_popup = item_data.nome + "\nx" + str(quantidade)
		ui_inventario.mostrar_popup_info(texto_popup)

func _on_mouse_exited():
	if ui_inventario:
		ui_inventario.esconder_popup_info()

func _on_focus_entered():
	if ui_inventario and meu_indice != -1:
		ui_inventario.reportar_foco(meu_indice)

func _get_drag_data(at_position):
	if item_data:
		var dados = {"source_index": meu_indice}
		
		var preview = TextureRect.new()
		preview.texture = item_data.icone
		# AQUI ESTÁ A CORREÇÃO FINAL, BASEADA NA SUA IMAGEM:
		preview.expand_mode = TextureRect.ExpandMode.EXPAND_FIT_WIDTH
		preview.size = Vector2(32, 32)
		set_drag_preview(preview)
		
		return dados
	return null

func _can_drop_data(at_position, data):
	return typeof(data) == TYPE_DICTIONARY and data.has("source_index")

func _drop_data(at_position, data):
	InventarioGlobal.trocar_itens(data.source_index, meu_indice)
