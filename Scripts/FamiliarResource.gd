# FamiliarResource.gd

class_name FamiliarResource
extends Resource

# --- Informações Básicas ---
@export var nome: String = "Novo Familiar"
@export_multiline var descricao: String = "Descrição do familiar."

# --- Assets Gráficos ---
@export var sprite_frente: AtlasTexture
@export var sprite_costas: AtlasTexture
@export var icone: AtlasTexture

# --- Atributos de Batalha ---
@export_group("Atributos")
@export var vida_maxima: int = 10
@export var ataque: int = 5
@export var defesa: int = 5
@export var velocidade: int = 5
@export var ataque_especial: int = 5
@export var defesa_especial: int = 5
