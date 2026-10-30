extends Control

# --- 1. STATUS GLOBAIS ---
var consciencia: int = 50
var progresso: int = 50
var reputacao: int = 50
var formatura: int = 0

# --- 2. CONTROLE DE FLUXO ---
var fase_atual: int = 0
var pergunta_atual: int = 0
var ultima_escolha_tipo: int = 0 
var esperando_feedback: bool = false 

# --- 3. REFERÊNCIAS VISUAIS (@export) ---
@export var barra_consciencia: ProgressBar
@export var barra_progresso: ProgressBar
@export var barra_reputacao: ProgressBar
@export var barra_formatura: ProgressBar

@export var texto_principal: Label
@export var texto_titulo_fase: Label
@export var texto_estrelas: Label

@export var botao_1: Button
@export var botao_2: Button
@export var botao_3: Button
@export var botao_continuar: Button

# --- 4. DADOS DO JOGO ---
var roteiro_fases: Array = [
	{
		"nome": "fase1",
		"perguntas": [
			{
				"pergunta": "Primeiro trabalho da faculdade. Você descobre o ChatGPT. O que faz?",
				"opcoes": [
					{"texto": "Copio e colo tudo.", "c": -30, "p": -15, "r": -10, "tipo": -1, "feedback": "Péssima escolha. O trabalho foi entregue rápido, mas você não aprendeu nada. Isso é plágio acadêmico."},
					{"texto": "Uso para entender o tema e escrevo com minhas palavras.", "c": 20, "p": 15, "r": 10, "tipo": 1, "feedback": "Excelente! Você usou a IA como um tutor, potencializando seu estudo sem perder a ética."},
					{"texto": "Ignoro a IA e leio livros na biblioteca.", "c": 20, "p": -10, "r": 20, "tipo": 1, "feedback": "Muito seguro e ético! Porém, você gastou muito tempo e seu progresso em outras matérias foi afetado."}
				]
			},
			{
				"pergunta": "Seu grupo sumiu e você tem que apresentar o seminário sozinho amanhã.",
				"opcoes": [
					{"texto": "Gero slides automáticos e leio na hora.", "c": -20, "p": 20, "r": -20, "tipo": -1, "feedback": "Você gaguejou na apresentação porque não dominava o assunto. A turma percebeu a IA."},
					{"texto": "Faço o básico sozinho e peço ajuda ao professor.", "c": 10, "p": -10, "r": 10, "tipo": 1, "feedback": "Você foi honesto e o professor valorizou seu esforço, mesmo a apresentação sendo simples."},
					{"texto": "Uso a IA para resumir o texto e treino a fala.", "c": 15, "p": 20, "r": 15, "tipo": 1, "feedback": "Ótima estratégia. A IA acelerou a pesquisa e você pôde focar em treinar a oratória."}
				]
			},
			{
				"pergunta": "O professor pediu que você faça o Code Review (revisão de código) do projeto de um colega e entregue um feedback escrito para compor a nota dele.",
				"opcoes": [
					{"texto": "Mando a IA avaliar o código e gerar um feedback genérico para acabar logo.", "c": -40, "p": 20, "r": -30, "tipo": -1, "feedback": "A IA foi excessivamente dura por causa de um detalhe de sintaxe. Seu colega ficou prejudicado e perdeu a confiança em você."},
					{"texto": "Uso a IA para analisar a complexidade do código, mas eu mesmo escrevo o feedback com empatia.", "c": 25, "p": 10, "r": 15, "tipo": 1, "feedback": "Você usou a tecnologia para análise técnica, mas manteve a responsabilidade humana na hora de se comunicar com seu colega."},
					{"texto": "Leio linha por linha manualmente e escrevo a revisão do zero.", "c": 15, "p": -10, "r": 15, "tipo": 1, "feedback": "Um trabalho minucioso e justo, mas que tomou todo o seu final de semana."}
				]
			}
		]
	},
	{
	"nome": "fase2",
		"perguntas": [
			{
				"pergunta": "O professor passou um projeto de programação complexo.",
				"opcoes": [
					{"texto": "Peço o código pronto para a IA e entrego.", "c": -30, "p": 30, "r": -10, "tipo": -1, "feedback": "Péssima escolha. O trabalho foi entregue rápido, mas você não aprendeu nada."},
					{"texto": "Peço para a IA me explicar a lógica passo a passo.", "c": 20, "p": 15, "r": 10, "tipo": 1, "feedback": "Excelente! Você usou a IA como um tutor, potencializando seu estudo sem perder a ética."},
					{"texto": "Entrego em branco e aceito o zero.", "c": 20, "p": -10, "r": 20, "tipo": 1, "feedback": "Muito seguro e ético! Porém, você não conseguiu passar na materia."}
				]
			},
			{
				"pergunta": "Você está desenvolvendo uma engine gráfica 3D e travou na configuração do GLFW e na renderização do OpenGL. O código em Java não compila de jeito nenhum e o prazo é amanhã.",
				"opcoes": [
					{"texto": "Jogo o código na IA, copio a resposta e rezo para funcionar.", "c": -30, "p": 40, "r": -10, "tipo": -1, "feedback": "O código rodou, mas você inseriu vulnerabilidades e não faz ideia de como a pipeline gráfica está funcionando."},
					{"texto": "Peço para a IA agir como um sênior e me explicar onde está o erro de lógica.", "c": 20, "p": 15, "r": 10, "tipo": 1, "feedback": "Excelente. Você corrigiu o bug entendendo o fluxo do código, o que te prepara para provas futuras."},
					{"texto": "Ignoro a IA e vou ler a documentação do OpenGL até achar o erro.", "c": 20, "p": -15, "r": 20, "tipo": 1, "feedback": "Muito ético e o aprendizado foi sólido, mas você virou a noite e vai perder a próxima aula por exaustão."}
				]
			},
			{
				"pergunta": "Sua equipe precisa criar a arquitetura de um ambiente de testes baseado em containers. Vocês decidiram usar uma temática de trens para nomear as funcionalidades, mas estão sem ideias.",
				"opcoes": [
					{"texto": "Peço para a IA gerar toda a documentação, os nomes e a estrutura de classes, e entrego.", "c": -20, "p": 30, "r": -20, "tipo": -1, "feedback": "O professor elogiou a estrutura inicial, mas na hora de codar, ninguém do grupo entendeu a arquitetura gerada e o projeto travou."},
					{"texto": "Uso a IA para fazer um brainstorming de analogias entre containers e trens para debater com o grupo.", "c": 20, "p": 20, "r": 15, "tipo": 1, "feedback": "Uso perfeito! A IA destravou a criatividade da equipe, e vocês construíram um projeto autêntico e bem estruturado."},
					{"texto": "Marco uma reunião de 4 horas com o grupo para pensar em tudo do zero.", "c": 15, "p": -20, "r": 10, "tipo": 1, "feedback": "Vocês tiveram ideias boas, mas perderam muito tempo em discussões irrelevantes e atrasaram a entrega das outras matérias."}
				]
			}
		]
	}
]

# --- 5. LÓGICA DE INICIALIZAÇÃO ---
func _ready() -> void:
	botao_continuar.pressed.connect(_on_botao_continuar_pressed)
	iniciar_jogo()

func iniciar_jogo() -> void:
	fase_atual = 0
	formatura = 0
	ultima_escolha_tipo = 0
	carregar_fase()

# --- 6. FLUXO DAS FASES ---
func carregar_fase() -> void:
	pergunta_atual = 0
	texto_titulo_fase.text = roteiro_fases[fase_atual]["nome"]
	texto_estrelas.hide()
	botao_continuar.hide()
	
	carregar_pergunta()

func carregar_pergunta() -> void:
	atualizar_interface_status()
	esperando_feedback = false
	botao_continuar.hide()
	
	var dados_fase = roteiro_fases[fase_atual]
	
	if pergunta_atual >= dados_fase["perguntas"].size():
		finalizar_fase()
		return
		
	mostrar_botoes_resposta(true)
	var dados_pergunta = dados_fase["perguntas"][pergunta_atual]
	texto_principal.text = dados_pergunta["pergunta"]
	
	botao_1.text = dados_pergunta["opcoes"][0]["texto"]
	botao_2.text = dados_pergunta["opcoes"][1]["texto"]
	botao_3.text = dados_pergunta["opcoes"][2]["texto"]

# --- 7. RECEPTORES DE CLIQUE ---
func _on_botao_1_pressed() -> void: processar_resposta(0)
func _on_botao_2_pressed() -> void: processar_resposta(1)
func _on_botao_3_pressed() -> void: processar_resposta(2)

func _on_botao_continuar_pressed() -> void:
	if esperando_feedback:
		pergunta_atual += 1
		carregar_pergunta()
	else:
		fase_atual += 1
		if fase_atual >= roteiro_fases.size():
			tela_final_formatura()
		else:
			carregar_fase()

# --- 8. MOTOR DE REGRAS E PENALIDADE ---
func processar_resposta(indice: int) -> void:
	var alternativas = roteiro_fases[fase_atual]["perguntas"][pergunta_atual]["opcoes"]
	var escolha = alternativas[indice]
	
	consciencia += escolha["c"]
	progresso += escolha["p"]
	reputacao += escolha["r"]
	
	var texto_do_feedback = escolha["feedback"]
	
	# Verifica inconsistência (Penalidade do Professor)
	if ultima_escolha_tipo == 1 and escolha["tipo"] == -1:
		reputacao -= 15
		texto_do_feedback += "\n\n⚠️ PENALIDADE: O professor notou uma queda brusca de qualidade em relação ao seu ótimo trabalho anterior! Reputação caiu."
	
	if escolha["tipo"] != 0: 
		ultima_escolha_tipo = escolha["tipo"]
	
	consciencia = clampi(consciencia, 0, 100)
	progresso = clampi(progresso, 0, 100)
	reputacao = clampi(reputacao, 0, 100)
	
	mostrar_feedback(texto_do_feedback)

# --- 9. FEEDBACK E ATUALIZAÇÃO VISUAL ---
func mostrar_feedback(texto: String) -> void:
	mostrar_botoes_resposta(false) 
	atualizar_interface_status() 
	
	texto_principal.text = "RESULTADO:\n\n" + texto
	
	esperando_feedback = true
	botao_continuar.text = "Próxima Pergunta"
	botao_continuar.show()

func atualizar_interface_status() -> void:
	barra_consciencia.value = consciencia
	barra_progresso.value = progresso
	barra_reputacao.value = reputacao
	barra_formatura.value = formatura

# --- 10. FINAL DE FASE E JOGO ---
func finalizar_fase() -> void:
	mostrar_botoes_resposta(false)
	texto_estrelas.show()
	esperando_feedback = false
	
	var media = (consciencia + progresso + reputacao) / 3.0
	
	if media >= 75 and consciencia > 60:
		texto_estrelas.text = "⭐⭐⭐ EXCELENTE!"
		texto_principal.text = "concluido com sucesso."
		formatura += 50
	elif media >= 45:
		texto_estrelas.text = "⭐⭐ REGULAR"
		texto_principal.text = "Faltou um pouco de equilíbrio, mas você avançou."
		formatura += 25
	else:
		texto_estrelas.text = "⭐ RUIM"
		texto_principal.text = "Suas atitudes antiéticas geraram penalidades. O sistema acadêmico está de olho em você."
		formatura -= 15
		
	formatura = clampi(formatura, 0, 100)
	atualizar_interface_status()
	
	botao_continuar.text = "Avançar "
	botao_continuar.show()

func tela_final_formatura() -> void:
	mostrar_botoes_resposta(false)
	botao_continuar.hide()
	texto_estrelas.hide()
	texto_titulo_fase.text = "conclusão"
	
	if formatura >= 80:
		texto_principal.text = "PARABÉNS! Você dominou o uso ético da IA!"
	elif formatura >= 50:
		texto_principal.text = "Você conseguiu cuncluir mas a jornada foi turbulenta."
	else:
		texto_principal.text = "REPROVADO. Suas escolhas comprometeram sua formação."

func mostrar_botoes_resposta(mostrar: bool) -> void:
	botao_1.visible = mostrar
	botao_2.visible = mostrar
	botao_3.visible = mostrar
