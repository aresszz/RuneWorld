# area_lixeira.gd (versão 1.0)
extends Panel

# Chamada quando um item arrastado passa por cima da lixeira
func _can_drop_data(at_position, data):
	# Aceita o "drop" apenas se os dados forem do nosso inventário
	return typeof(data) == TYPE_DICTIONARY and data.has("source_index")

# Chamada quando o item é solto sobre a lixeira
func _drop_data(at_position, data):
	var index_do_item = data.source_index
	print("Item do slot #", index_do_item, " foi solto na lixeira!")
	
	# Por enquanto, vamos chamar a função de remoção diretamente.
	# No futuro, aqui abriremos a janela de confirmação.
	InventarioGlobal.remover_item(index_do_item)
