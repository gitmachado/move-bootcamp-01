# Move Bootcamp Project

This is a project developed during the Move bootcamp, demonstrating fundamental concepts of the Move language on the Sui blockchain.

## Project Structure

```
move_bootcamp_01/
├── Move.toml           # Move project configuration
├── sources/            # Main source code
│   └── move_bootcamp_01.move
├── tests/              # Project tests
│   └── move_bootcamp_01_tests.move
└── build/              # Build files (ignored by git)
```

## Prerequisites

- [Sui CLI](https://docs.sui.io/build/install) installed
- [Move CLI](https://github.com/move-language/move) (included with Sui)

## How to Use

### Build the project

```bash
sui move build
```

### Run tests

```bash
sui move test
```

## About Move

Move is a secure and expressive programming language for smart contracts, originally developed by Facebook for the Libra/Diem project. The Sui blockchain uses an adapted version of Move optimized for its object-based execution model.

## Useful Resources

- [Official Sui Documentation](https://docs.sui.io/)
- [Move Book](https://move-language.github.io/move/)
- [Sui Move by Example](https://examples.sui.io/)

## License

This project is for educational purposes.