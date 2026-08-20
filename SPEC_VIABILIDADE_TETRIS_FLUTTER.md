# Spec de Viabilidade: Jogo estilo Tetris com Flutter

Data: 2026-04-21

## 1. Objetivo

Avaliamos se faz sentido desenvolver um jogo estilo Tetris usando Flutter com um unico codigo para:

- celular (`Android` e `iOS`)
- web (`desktop browser` e `mobile browser`)

Tambem comparamos Flutter com alternativas mais orientadas a jogos para decidir a base tecnologica mais indicada.

## 2. Resumo executivo

Sim, e viavel desenvolver um Tetris em Flutter com codigo unico para mobile e web.

Para este caso especifico, Flutter e uma opcao boa porque:

- Tetris e um jogo 2D simples, baseado em grade e regras deterministicas.
- Nao depende de fisica complexa, 3D, particulas pesadas ou centenas de entidades em tempo real.
- A logica principal pode ser modelada como estado puro, o que combina bem com Dart.
- Flutter ja suporta build para Android, iOS e web.
- O ecossistema Flutter reconhece jogos casuais como um bom encaixe para a stack.

Recomendacao principal:

- Se o objetivo e entregar rapido, manter um unico codigo e integrar UI de app com facilidade, usar `Flutter + Flame`.
- Se o jogo for extremamente simples e quisermos o minimo de dependencias, `Flutter puro` tambem e viavel.
- Se o foco principal for navegador e performance/game-feel web-first, `Phaser` pode ser mais indicado.
- `Godot` so passa a fazer mais sentido se o projeto crescer para algo muito mais "engine-driven" do que um Tetris classico.

## 3. Pergunta de decisao

Qual tecnologia oferece o melhor equilibrio entre:

- codigo unico para mobile e web
- simplicidade de implementacao
- boa experiencia de jogo
- manutencao baixa
- possibilidade de evoluir o projeto depois

## 4. Conclusao recomendada

### Recomendacao

Adotar `Flutter + Flame`.

### Motivo

Essa combinacao preserva o beneficio de codigo unico do Flutter, mas adiciona primitivas uteis para jogo:

- game loop
- renderizacao de componentes
- input unificado
- organizacao mais natural para cena, HUD e ciclo de atualizacao

Para Tetris, isso e suficiente sem trazer a complexidade de uma engine pesada.

### Quando usar Flutter puro

Usaria `Flutter puro` se o escopo for:

- tabuleiro 10x20
- animacoes simples
- controles basicos
- sem ambicao de efeitos mais elaborados

Funciona bem, mas a arquitetura de jogo tende a ficar menos natural do que com Flame.

### Quando nao escolher Flutter

Se a prioridade numero 1 for:

- browser como plataforma principal
- footprint web menor
- loop/renderizacao com mentalidade 100% game engine
- pipeline mais tipico de jogos HTML5

Entao `Phaser` tende a ser mais indicado.

## 5. Evidencias da pesquisa

### Flutter

O material oficial do Flutter para jogos casuais posiciona o framework como adequado para jogos multiplataforma e separa:

- jogos casuais/turn-based como muito adequados ao Flutter
- jogos em tempo real com suporte melhor quando combinados com `Flame`

Isso combina diretamente com Tetris, que e um jogo casual 2D com loop simples.

Tambem ha documentacao oficial de build e deploy web para Flutter, incluindo geracao de release para `build/web`.

### Flame

A documentacao do Flame informa suporte para:

- web
- mobile
- desktop

Como roda sobre Flutter, ele aproveita as plataformas ja suportadas pelo framework.

O Flame tambem documenta suporte de input em multiplas plataformas, incluindo:

- toque
- mouse
- teclado
- pointer events na web

Isso e especialmente relevante para Tetris, que costuma depender de teclado no desktop/web e toque no celular.

### Phaser

A documentacao oficial do Phaser deixa claro que ele e uma framework 2D orientada principalmente para navegadores.

Ponto forte:

- excelente para jogos 2D no browser

Limitacao frente ao objetivo deste projeto:

- mobile nativo depende de empacotamento com ferramentas de terceiros, entao a historia de "um codigo para web e celular" existe, mas com mais cara de "web game empacotado" do que app nativo real.

### Godot

Godot exporta para mobile e web, mas a documentacao oficial do export para web mostra restricoes e dependencias relevantes do ambiente do navegador.

Para um Tetris, Godot e plenamente capaz, mas tende a ser uma solucao mais pesada que o necessario se o objetivo principal for:

- rapidez
- simplicidade
- unificacao com stack de app

## 6. Comparativo de opcoes

| Opcao | Viabilidade para Tetris | Mobile + Web com codigo unico | Complexidade | Fit para este projeto | Observacao |
|---|---|---:|---:|---:|---|
| Flutter puro | Alta | Alta | Baixa | Boa | Melhor para MVP simples |
| Flutter + Flame | Alta | Alta | Media | Muito boa | Melhor equilibrio geral |
| Phaser | Alta | Media | Baixa/Media | Boa se web-first | Forte para browser |
| Godot | Alta | Media/Alta | Media/Alta | Razoavel | Mais engine do que precisamos |

## 7. Avaliacao por criterio

### 7.1 Codigo unico

`Flutter + Flame` atende muito bem ao requisito.

A maior parte do codigo pode ser compartilhada entre:

- logica do tabuleiro
- regras de colisao
- geracao de pecas
- rotacao
- pontuacao
- niveis
- interface base

As diferencas por plataforma tendem a ficar concentradas em:

- mapeamento de input
- pequenos ajustes de layout
- comportamento de fullscreen
- audio/web quirks

### 7.2 Performance

Para Tetris, a exigencia de performance e baixa a moderada.

O jogo precisa de:

- atualizacao previsivel do estado
- renderizacao rapida de poucos elementos
- resposta imediata ao input

Flutter consegue entregar isso. Flame ajuda a tornar o loop mais natural.

Nao ha sinal de que Tetris, por si so, exija engine mais especializada.

### 7.3 Manutenibilidade

Flutter favorece:

- codigo legivel em Dart
- testes unitarios fortes para regras de jogo
- facilidade para menus, HUD, ranking local, settings e overlays

Isso e uma vantagem real contra engines mais focadas apenas na cena do jogo.

### 7.4 Experiencia web

Aqui existe o principal ponto de atencao.

Embora Flutter suporte web oficialmente, jogos web em Flutter podem ter trade-offs como:

- bundle inicial maior que stacks web-native
- necessidade de validar input e responsividade no navegador real
- possiveis diferencas sutis de comportamento entre browser desktop e mobile

Para um Tetris isso nao inviabiliza a solucao, mas reforca a necessidade de prototipo cedo.

## 8. Arquitetura sugerida

### Stack recomendada

- `Flutter`
- `Flame`
- gerenciamento de estado simples, preferencialmente centrado na logica do jogo e nao em UI

### Separacao de camadas

#### Nucleo do jogo

Responsavel por:

- grade
- pecas
- colisao
- rotacao
- travamento de peca
- limpeza de linhas
- pontuacao
- game over
- velocidade por nivel

Essa camada deve ser quase toda independente de UI e renderizacao.

#### Camada de engine/render

Responsavel por:

- desenhar grade e blocos
- animacoes simples
- loop de atualizacao
- leitura de input
- pausa
- HUD

#### Camada de plataforma

Responsavel por:

- touch controls no celular
- teclado no web/desktop
- persistencia local de high score
- integracao com tela cheia quando fizer sentido

## 9. Riscos e mitigacao

### Risco 1: Experiencia web abaixo do esperado

Possiveis sintomas:

- carregamento inicial mais pesado
- input com sensacao diferente no browser

Mitigacao:

- construir um prototipo jogavel cedo
- testar no Chrome desktop e no navegador do celular
- medir tamanho do build web antes de comprometer o roadmap

### Risco 2: Arquitetura muito "app-like" e pouco "game-like"

Isso pode acontecer se o projeto usar apenas widgets e logica espalhada.

Mitigacao:

- manter a logica do jogo isolada
- usar Flame para o loop/render do jogo
- deixar menus e telas auxiliares em Flutter padrao

### Risco 3: Controles touch ruins

Tetris depende de controles precisos.

Mitigacao:

- testar cedo duas abordagens:
- botoes virtuais fixos
- gestos simples como swipe e tap

### Risco 4: Crescimento de escopo

Se o projeto evoluir para:

- muitos efeitos
- multiplayer em tempo real
- modos mais complexos
- pipeline forte de conteudo e cenas

Talvez a decisao ideal mude.

Mitigacao:

- validar primeiro o Tetris classico como produto-base
- reavaliar engine apenas se o escopo sair muito do jogo casual simples

## 10. Prova de conceito recomendada

Antes de consolidar a stack, vale construir uma POC com 1 a 2 dias de esforco contendo:

- tabuleiro 10x20
- 7 tetrominos
- movimento lateral
- rotacao
- queda automatica
- soft drop
- hard drop
- line clear
- score
- game over
- input por teclado na web
- input por botoes touch no celular

Criterios de aceite da POC:

- jogabilidade fluida em celular e navegador
- sem bugs frequentes de colisao/rotacao
- controles responsivos
- build web aceitavel para um jogo casual

## 11. Decisao final proposta

### Decisao

Seguir com `Flutter + Flame`.

### Justificativa

- atende bem ao requisito de codigo unico
- e tecnicamente suficiente para Tetris
- simplifica menus, HUD e integracao com app
- reduz o peso operacional em comparacao com uma engine maior
- mantem espaco para publicar em mobile e web

### Plano B

Se a POC mostrar que a experiencia no browser e o fator dominante e Flutter web nao estiver satisfatorio, migrar para `Phaser` como alternativa web-first.

## 12. Recomendacao pratica

Comecar com esta estrategia:

1. Criar uma POC em `Flutter + Flame`.
2. Validar input, performance e experiencia web.
3. Se a POC passar, seguir com a stack.
4. Se a POC falhar principalmente no web, reconsiderar `Phaser`.

## 13. Fontes

- Flutter Casual Games Toolkit: https://docs.flutter.dev/resources/games-toolkit
- Flutter Web Deployment: https://docs.flutter.dev/deployment/web
- Flame Supported Platforms: https://docs.flame-engine.org/latest/flame/platforms.html
- Flame Inputs: https://docs.flame-engine.org/latest/flame/inputs/inputs.html
- Phaser - What is Phaser?: https://docs.phaser.io/phaser/getting-started/what-is-phaser
- Godot - Exporting for the Web: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html
