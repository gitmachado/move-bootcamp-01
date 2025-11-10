/// Module: simple_nft
module move_bootcamp_01::simple_nft {
    use std::string::{Self, String};
    use sui::url::{Self, Url};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::event;

    // Struct para o NFT
    public struct SimpleNFT has key, store {
        id: UID,
        name: String,
        description: String,
        image_url: Url,
        creator: address,
    }

    // Evento quando NFT é criado
    public struct NFTMinted has copy, drop {
        nft_id: address,
        creator: address,
        name: String,
    }

    /// Função para criar NFT
    public fun mint_nft(
        name: vector<u8>,
        description: vector<u8>,
        image_url: vector<u8>,
        recipient: address,
        ctx: &mut TxContext
    ) {
        let nft = SimpleNFT {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            image_url: url::new_unsafe_from_bytes(image_url),
            creator: tx_context::sender(ctx),
        };

        let nft_id = object::uid_to_address(&nft.id);

        event::emit(NFTMinted {
            nft_id,
            creator: tx_context::sender(ctx),
            name: nft.name,
        });

        transfer::public_transfer(nft, recipient);
    }

    /// Função para obter detalhes do NFT
    public fun get_nft_details(nft: &SimpleNFT): (String, String, Url, address) {
        (nft.name, nft.description, nft.image_url, nft.creator)
    }
}