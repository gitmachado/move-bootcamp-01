# Move Bootcamp Project

Este é um projeto desenvolvido durante o bootcamp de Move, demonstrando conceitos fundamentais da linguagem Move na blockchain Sui.

## Estrutura do Projeto

```
move_bootcamp_01/
├── Move.toml           # Configuração do projeto Move
├── sources/            # Código fonte principal
│   └── move_bootcamp_01.move
├── tests/              # Testes do projeto
│   └── move_bootcamp_01_tests.move
└── build/              # Arquivos de build (ignorado pelo git)
```

## Pré-requisitos

- [Sui CLI](https://docs.sui.io/build/install) instalado
- [Move CLI](https://github.com/move-language/move) (incluído com Sui)

## Como usar

### Build do projeto

```bash
sui move build
```

### Executar testes

```bash
sui move test
```

## Sobre o Move

Move é uma linguagem de programação segura e expressiva para smart contracts, originalmente desenvolvida pelo Facebook para o projeto Libra/Diem. A Sui blockchain utiliza uma versão adaptada do Move otimizada para seu modelo de execução baseado em objetos.

## Recursos Úteis

- [Documentação oficial do Sui](https://docs.sui.io/)
- [Move Book](https://move-language.github.io/move/)
- [Sui Move by Example](https://examples.sui.io/)

## Licença

Este projeto é para fins educacionais.