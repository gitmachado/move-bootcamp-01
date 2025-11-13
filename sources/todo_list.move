/// Módulo: todo_list
module move_bootcamp_01::todo_list {
    use std::string::{Self, String};
    use std::debug;

    /// Um único item da lista (armazenado dentro da lista)
    /// Observação: a habilidade `drop` é necessária porque usamos `vector::swap_remove`
    /// que pode descartar elementos.
    public struct TodoItem has store, drop {
        id: u64,
        title: String,
        description: String,
        done: bool,
    }

    /// Objeto TodoList de nível superior (tem `key` para ser um objeto on-chain)
    public struct TodoList has key, store {
        id: UID,
        items: vector<TodoItem>,
        next_id: u64,
    }

    /// Cria uma nova TodoList vazia. O chamador recebe o objeto e pode armazená-lo/compartilhá-lo.
    public fun create_list(ctx: &mut TxContext): TodoList {
        let list = TodoList {
            id: object::new(ctx),
            items: vector::empty<TodoItem>(),
            next_id: 1,
        };
        list
    }

    /// Adiciona um item à lista
    public fun add_item(list: &mut TodoList, title: vector<u8>, description: vector<u8>) {
        let item = TodoItem {
            id: list.next_id,
            title: string::utf8(title),
            description: string::utf8(description),
            done: false,
        };
        vector::push_back(&mut list.items, item);
        list.next_id = list.next_id + 1;
    }

    /// Alterna a flag `done` para o item com o id fornecido.
    /// Aborta com código 1 se o item não for encontrado.
    public fun toggle_item(list: &mut TodoList, id: u64) {
        let len = vector::length(&list.items);
        let mut i = 0u64;
        while (i < len) {
            let ref_item = vector::borrow_mut(&mut list.items, i);
            if (ref_item.id == id) {
                ref_item.done = !ref_item.done;
                return
            };
            i = i + 1;
        };
        abort 1;
    }

    /// Remove o item com o id fornecido. Aborta com código 2 se não for encontrado.
    public fun remove_item(list: &mut TodoList, id: u64) {
        let len = vector::length(&list.items);
        let mut i = 0u64;
        while (i < len) {
            let ref_item = vector::borrow(&list.items, i);
            if (ref_item.id == id) {
                vector::swap_remove(&mut list.items, i);
                return
            };
            i = i + 1;
        };
        abort 2;
    }

    /// Retorna o número de itens na lista
    public fun len(list: &TodoList): u64 {
        vector::length(&list.items)
    }

    /// Impressão de depuração de todos os itens (para testes / inspeção local)
    public fun debug_print(list: &TodoList) {
        let len = vector::length(&list.items);
        let mut i = 0u64;
        while (i < len) {
            let item = vector::borrow(&list.items, i);
            debug::print(&item.title);
            if (item.done) {
                debug::print(&string::utf8(b" [concluído]"));
            } else {
                debug::print(&string::utf8(b" [aberto]"));
            };
            i = i + 1;
        };
    }
}
