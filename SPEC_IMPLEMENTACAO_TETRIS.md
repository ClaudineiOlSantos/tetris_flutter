# Spec de Implementacao: Tetris Classico em Flutter

Data: 2026-04-24

## 1. Objetivo

Criar a primeira versao jogavel de um Tetris classico em Flutter, com suporte inicial para web e mobile usando um unico codigo.

## 2. Escopo da primeira versao

A versao inicial deve conter:

- jogo classico em grid retangular
- grid branco
- blocos em tom alaranjado, lembrando tijolos
- painel lateral direito com nivel e pontuacao
- sistema de pontuacao
- aumento de nivel a cada 1000 pontos
- aumento gradual de velocidade conforme o nivel sobe
- controles por teclado para web/desktop
- controles por botoes na tela para mobile

## 3. Regras do jogo

### Tabuleiro

- Dimensao: 10 colunas x 20 linhas.
- Celula vazia: branca.
- Celula ocupada: tom alaranjado.
- Pecas compostas por tetrominos classicos: `I`, `O`, `T`, `S`, `Z`, `J`, `L`.

### Movimento

- A peca atual cai automaticamente.
- O jogador pode mover para esquerda e direita.
- O jogador pode rotacionar.
- O jogador pode acelerar a queda com soft drop.
- O jogador pode usar hard drop para encaixar imediatamente.

### Limpeza de linhas

- Quando uma linha fica completamente preenchida, ela e removida.
- As linhas acima descem.
- A pontuacao aumenta conforme a quantidade de linhas removidas em uma jogada.

### Pontuacao

Pontuacao base sugerida:

- 1 linha: `100 * nivel`
- 2 linhas: `300 * nivel`
- 3 linhas: `500 * nivel`
- 4 linhas: `800 * nivel`

### Nivel

- Nivel inicial: 1.
- O nivel aumenta a cada faixa de 1000 pontos.
- A velocidade aumenta conforme o nivel.

Formula inicial sugerida:

```text
intervalo_de_queda_ms = max(120, 700 - ((nivel - 1) * 60))
```

## 4. Interface

### Layout desktop/web

- Area principal com tabuleiro.
- Aba lateral direita com:
- nivel atual
- pontuacao atual
- linhas limpas
- estado do jogo
- botao de reiniciar

### Layout mobile

- Tabuleiro centralizado.
- Informacoes do jogo visiveis sem ocupar espaco excessivo.
- Controles touch abaixo do tabuleiro:
- mover esquerda
- mover direita
- rotacionar
- soft drop
- hard drop

## 5. Stack tecnica

### Decisao inicial

Usar Flutter puro para a primeira versao.

### Justificativa

O jogo pode ser implementado com:

- `CustomPainter` para desenhar o tabuleiro
- `Timer.periodic` para o game loop simples
- `KeyboardListener` para controles por teclado
- widgets comuns para HUD e botoes touch

Isso reduz dependencias para a primeira versao e funciona bem com Flutter 3.10.5.

### Evolucao possivel

Se a logica de jogo crescer, podemos migrar a camada visual/game loop para `Flame` mantendo o nucleo de regras em Dart.

## 6. Compatibilidade de Flutter

A maquina tem Flutter 3.10.5 instalado globalmente e outro projeto depende dessa versao.

Diretriz:

- nao atualizar o Flutter global
- usar `fvm` para fixar uma versao por projeto quando necessario
- manter a primeira implementacao compativel com Flutter 3.10.5 para reduzir risco

## 7. Arquitetura proposta

### Arquivos principais

- `lib/main.dart`: entrada da aplicacao e tela principal.
- `lib/game/tetris_game.dart`: estado, regras e progresso do jogo.
- `lib/game/tetromino.dart`: definicao das pecas e rotacoes.
- `lib/widgets/tetris_board.dart`: desenho do grid e blocos.
- `lib/widgets/game_panel.dart`: painel lateral de informacoes.
- `lib/widgets/mobile_controls.dart`: botoes touch.

### Separacao de responsabilidades

`tetris_game.dart` deve concentrar:

- grade
- peca atual
- colisao
- movimento
- rotacao
- limpeza de linhas
- score
- nivel
- game over

Widgets devem apenas:

- renderizar estado
- enviar comandos para o jogo

## 8. Tasks graduais

### Task 1: Preparacao do projeto

- Criar projeto Flutter.
- Adicionar spec e estrutura de pastas.
- Confirmar estrategia com FVM sem alterar Flutter global.

### Task 2: Modelo do jogo

- Criar tetrominos.
- Criar grid 10x20.
- Implementar colisao.
- Implementar spawn de pecas.

### Task 3: Loop e movimentos

- Implementar queda automatica.
- Implementar esquerda/direita.
- Implementar rotacao.
- Implementar soft drop e hard drop.

### Task 4: Pontuacao e niveis

- Detectar linhas completas.
- Remover linhas.
- Calcular pontuacao.
- Subir nivel a cada 1000 pontos.
- Aumentar velocidade por nivel.

### Task 5: Interface

- Desenhar grid branco.
- Desenhar blocos alaranjados.
- Criar painel lateral direito.
- Criar controles mobile.
- Criar reinicio de jogo.

### Task 6: Validacao

- Rodar `flutter analyze`.
- Rodar testes unitarios se houver.
- Validar build web quando o ambiente permitir.

## 9. Criterios de aceite

- O jogo abre e ja permite jogar.
- O tabuleiro tem grid branco e blocos alaranjados.
- O painel lateral mostra nivel, pontuacao e linhas.
- Ao completar linha, a linha some e pontua.
- Ao acumular linhas limpas, o nivel sobe.
- Ao subir de nivel, a velocidade aumenta.
- O jogo detecta game over.
- O jogo pode ser reiniciado.
