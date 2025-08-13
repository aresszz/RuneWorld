# ItemResource.gd (versão 2 - com sprite de mundo)

class_name ItemResource
extends Resource

enum Efeito {
	NENHUM,
	CURAR_VIDA,
	CAPTURAR
}

# --- Informações Básicas ---
@export var nome: String = "Novo Item"
@export_multiline var descricao: String = "Descrição do item."
@export var icone: Texture2D # <- Ícone para o inventário/UI
@export var sprite_mundo: Texture2D # <- NOVO: Imagem para aparecer no mapa

# --- Regras de Uso ---
@export_group("Regras")
@export var usavel_em_batalha: bool = true
@export var usavel_no_mapa: bool = true
@export var quantidade_maxima: int = 99

# --- Efeito do Item ---
@export_group("Efeito")
@export var tipo_de_efeito: Efeito = Efeito.NENHUM
@export var potencia_do_efeito: int = 0
