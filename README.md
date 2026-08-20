# Tetris Flutter

Primeira versao de um Tetris classico em Flutter.

## Requisitos

- Flutter 3.10.5 ou superior compativel com Dart 3.
- Nao e necessario atualizar o Flutter global para esta primeira versao.

## Como rodar

```powershell
flutter pub get
flutter run -d chrome
```

Observacao: nesta maquina, os comandos `flutter`, `dart` e `fvm` podem demorar ou travar dependendo do terminal/PATH atual. A implementacao foi mantida sem dependencias externas alem do SDK Flutter para facilitar rodar com a versao global 3.10.5.

Para rodar no Android:

```powershell
flutter run -d android
```

As pastas nativas do Android ja foram geradas com `flutter create --platforms=android .`.

## Controles

- Seta esquerda: mover para esquerda.
- Seta direita: mover para direita.
- Seta para cima: girar.
- Seta para baixo: queda suave.
- Espaco: queda imediata.
- P: pausar ou continuar.
- R: reiniciar.

No mobile, use os botoes na tela.

Os botoes mobile usam cores por acao: azul para mover, amarelo para girar e vermelho para soltar a peca de uma vez. O header exibe o botao de pausa/continuar.

## FVM

O FVM parece existir em `C:\Users\diney\AppData\Local\Pub\Cache\bin\fvm.bat`, mas pode nao estar no PATH do seu terminal.

Quando quiser isolar a versao deste projeto, confira se o diretorio abaixo esta no PATH:

```text
C:\Users\diney\AppData\Local\Pub\Cache\bin
```

Depois disso, uma configuracao comum seria:

```powershell
fvm install 3.10.5
fvm use 3.10.5
fvm flutter pub get
fvm flutter run -d chrome
```
