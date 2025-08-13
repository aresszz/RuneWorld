# item_coletavel.gd (versão 3.0)
extends StaticBody2D

@export var pode_respawnar: bool = false
@export var tempo_de_respawn: float = 10.0

@export var item_data: ItemResource
@export var quantidade: int = 1

var jogador_na_area: bool = false

# Referências diretas para os nós filhos
@onready var sprite_2d = $Sprite2D
@onready var colisao_solida = $CollisionShape2D
@onready var area_de_interacao = $AreaDeInteracao
@onready var respawn_timer = $RespawnTimer


func _ready():
	if not item_data:
		print("ERRO: Item Coletável no mapa não tem um ItemResource associado.")
		queue_free()
		return
	sprite_2d.texture = item_data.sprite_mundo

func _process(delta):
	# A lógica de interação continua a mesma
	if jogador_na_area and Input.is_action_just_pressed("interact"):
		coletar_item()

func coletar_item():
	InventarioGlobal.adicionar_item(item_data, quantidade)
	if pode_respawnar:
		desativar_coletavel()
	else:
		queue_free()

func desativar_coletavel():
	# Agora as chamadas são diretas, sem 'corpo_pai'
	visible = false
	colisao_solida.disabled = true
	area_de_interacao.monitoring = false
	
	respawn_timer.wait_time = tempo_de_respawn
	respawn_timer.start()

func ativar_coletavel():
	visible = true
	colisao_solida.disabled = false
	area_de_interacao.monitoring = true

# --- Funções conectadas aos Sinais dos Filhos ---

# Dentro de item_coletavel.gd

func _on_area_de_interacao_body_entered(body):
	print("Área de interação detectou um corpo entrando!") # <-- LINHA DE TESTE
	if body.is_in_group("player"):
		jogador_na_area = true
		modulate = Color(1.3, 1.3, 1.3)
	if body.is_in_group("player"):
		jogador_na_area = true
		modulate = Color(1.3, 1.3, 1.3)

func _on_area_de_interacao_body_exited(body):
	if body.is_in_group("player"):
		jogador_na_area = false
		modulate = Color.WHITE

func _on_respawn_timer_timeout():
	ativar_coletavel()

func _on_area_de_interação_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_de_interação_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
