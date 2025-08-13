# ui_inventario.gd (versão 11.0)
extends CanvasLayer

const SlotInventario = preload("res://cenas/ui/slot_inventario.tscn")
const TOTAL_SLOTS = 27
const COLUNAS = 9

@onready var grid_container = $Container/Panel/GridContainer
@onready var popup_info = $Container/Popupinfo
@onready var popup_label = $Container/Popupinfo/Popuplabel
@onready var anel_seletor = $Container/Panel/AnelSeletor

var indice_selecionado = 0

func _ready():
	InventarioGlobal.inventario_mudou.connect(atualizar_inventario)
	criar_slots_vazios()
	atualizar_inventario()

func _unhandled_input(event):
	if not visible:
		return

	if event is InputEventKey and event.is_pressed():
		var direcao_pressionada = false
		var nova_linha = indice_selecionado / COLUNAS
		var nova_coluna = indice_selecionado % COLUNAS

		if event.is_action("ui_right"):
			nova_coluna = (nova_coluna + 1) % COLUNAS
			direcao_pressionada = true
		elif event.is_action("ui_left"):
			nova_coluna = (nova_coluna - 1 + COLUNAS) % COLUNAS
			direcao_pressionada = true
		elif event.is_action("ui_down"):
			nova_linha = (nova_linha + 1) % (TOTAL_SLOTS / COLUNAS)
			direcao_pressionada = true
		elif event.is_action("ui_up"):
			nova_linha = (nova_linha - 1 + (TOTAL_SLOTS / COLUNAS)) % (TOTAL_SLOTS / COLUNAS)
			direcao_pressionada = true
		
		if direcao_pressionada:
			var novo_indice = nova_linha * COLUNAS + nova_coluna
			selecionar_slot(novo_indice)
			get_viewport().set_input_as_handled()

func _notification(what):
	if what == CanvasItem.NOTIFICATION_VISIBILITY_CHANGED:
		if visible:
			selecionar_slot(InventarioGlobal.ultimo_indice_inventario)
		else:
			InventarioGlobal.ultimo_indice_inventario = indice_selecionado
			esconder_popup_info()
			if anel_seletor:
				anel_seletor.visible = false

func _process(delta):
	if popup_info and popup_info.visible:
		popup_info.global_position = get_viewport().get_mouse_position() + Vector2(15, 15)

func criar_slots_vazios():
	for i in range(TOTAL_SLOTS):
		var novo_slot = SlotInventario.instantiate()
		novo_slot.set_ui_controller(self)
		grid_container.add_child(novo_slot)

func atualizar_inventario():
	var inventario_slots = InventarioGlobal.slots
	var slots_ui = grid_container.get_children()
	
	for i in range(slots_ui.size()):
		var slot_ui = slots_ui[i]
		slot_ui.meu_indice = i
		var icone = slot_ui.get_node("MarginContainer/IconeItem")
		
		if not icone:
			continue
		
		var dados_do_slot = inventario_slots[i]
		
		if dados_do_slot: # Se o slot não está vazio (não é null)
			var item_data = dados_do_slot.item
			var quantidade = dados_do_slot.quantidade
			
			icone.texture = item_data.icone
			icone.visible = true
			
			slot_ui.item_data = item_data
			slot_ui.quantidade = quantidade
		else: # Se o slot está vazio
			icone.visible = false
			slot_ui.item_data = null
			slot_ui.quantidade = 0

func mostrar_popup_info(texto: String):
	if popup_info:
		popup_label.text = texto
		popup_info.visible = true

func esconder_popup_info():
	if popup_info:
		popup_info.visible = false

func reportar_foco(index_do_slot: int):
	selecionar_slot(index_do_slot)

func selecionar_slot(index: int):
	indice_selecionado = index
	var slots = grid_container.get_children()
	
	if indice_selecionado < slots.size():
		var slot_selecionado = slots[indice_selecionado]
		
		slot_selecionado.grab_focus()
		
		if anel_seletor:
			anel_seletor.position = grid_container.position + slot_selecionado.position
			anel_seletor.visible = true
		
		if slot_selecionado.item_data:
			var texto = slot_selecionado.item_data.nome + "\nx" + str(slot_selecionado.quantidade)
			mostrar_popup_info(texto)
		else:
			esconder_popup_info()
