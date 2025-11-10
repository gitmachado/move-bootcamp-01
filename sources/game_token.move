/// Module: game_token  
module move_bootcamp_01::game_token {
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::tx_context::TxContext;
    use std::option;

    // Token para jogos
    public struct GAME_TOKEN has drop {}

    fun init(witness: GAME_TOKEN, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency(
            witness,
            9, // decimals
            b"GAME", // symbol
            b"Game Token", // name
            b"Token for gaming on Sui", // description
            option::none(), // icon url
            ctx
        );
        
        // Transfere controle do treasury para quem fez deploy
        transfer::public_transfer(treasury, tx_context::sender(ctx));
        transfer::public_freeze_object(metadata);
    }

    public fun mint(
        treasury: &mut TreasuryCap<GAME_TOKEN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        let coin = coin::mint(treasury, amount, ctx);
        transfer::public_transfer(coin, recipient);
    }
}