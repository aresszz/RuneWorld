# InventarioGlobal.gd (versão 3.2)
extends Node

signal inventario_mudou

var slots: Array = []
var ultimo_indice_inventario: int = 0

func _ready():
	slots.resize(27)

func adicionar_item(item_data: ItemResource, quantidade: int = 1):
	var quantidade_restante = quantidade
	
	for i in range(slots.size()):
		if slots[i] and slots[i].item == item_data:
			var pode_adicionar = item_data.quantidade_maxima - slots[i].quantidade
			var vai_adicionar = min(quantidade_restante, pode_adicionar)
			
			if vai_adicionar > 0:
				slots[i].quantidade += vai_adicionar
				quantidade_restante -= vai_adicionar
				if quantidade_restante <= 0:
					inventario_mudou.emit()
					return

	if quantidade_restante > 0:
		for i in range(slots.size()):
			if slots[i] == null:
				slots[i] = {"item": item_data, "quantidade": quantidade_restante}
				inventario_mudou.emit()
				return

func trocar_itens(index_origem: int, index_destino: int):
	var temp = slots[index_origem]
	slots[index_origem] = slots[index_destino]
	slots[index_destino] = temp
	inventario_mudou.emit()

# --- NOVA FUNÇÃO DE REMOÇÃO ---
func remover_item(index: int):
	# Verifica se o índice é válido e se há um item ali para remover
	if index >= 0 and index < slots.size() and slots[index] != null:
		# Define o slot como vazio (null)
		slots[index] = null
		# Avisa a UI que os dados mudaram e ela precisa se redesenhar
		inventario_mudou.emit()
