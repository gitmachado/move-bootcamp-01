/// Module: todo_list
module move_bootcamp_01::todo_list {
    use std::string::{Self, String};
    use std::vector;
    use std::debug;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};

    /// A single todo item (stored inside the list)
    public struct TodoItem has store {
        id: u64,
        title: String,
        description: String,
        done: bool,
    }

    /// Top-level TodoList object (has key so it is on-chain)
    public struct TodoList has key {
        id: UID,
        items: vector<TodoItem>,
        next_id: u64,
    }

    /// Create a new empty TodoList. Caller receives the object and can store/share it.
    public fun create_list(ctx: &mut TxContext): TodoList {
        let list = TodoList {
            id: object::new(ctx),
            items: vector::empty<TodoItem>(),
            next_id: 1,
        };
        list
    }

    /// Add an item to the list
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

    /// Toggle the `done` flag for the item with the given id.
    /// Aborts with code 1 if the item is not found.
    public fun toggle_item(list: &mut TodoList, id: u64) {
        let len = vector::length(&list.items);
        let mut i = 0u64;
        while (i < len) {
            let ref_item = vector::borrow_mut(&mut list.items, i);
            if (ref_item.id == id) {
                ref_item.done = !ref_item.done;
                return;
            };
            i = i + 1;
        };
        abort 1;
    }

    /// Remove the item with the given id. Aborts with code 2 if not found.
    public fun remove_item(list: &mut TodoList, id: u64) {
        let len = vector::length(&list.items);
        let mut i = 0u64;
        while (i < len) {
            let ref_item = vector::borrow(&list.items, i);
            if (ref_item.id == id) {
                vector::swap_remove(&mut list.items, i);
                return;
            };
            i = i + 1;
        };
        abort 2;
    }

    /// Return number of items in the list
    public fun len(list: &TodoList): u64 {
        vector::length(&list.items)
    }

    /// Debug-print all items (for tests / local inspection)
    public fun debug_print(list: &TodoList) {
        let len = vector::length(&list.items);
        let mut i = 0u64;
        while (i < len) {
            let item = vector::borrow(&list.items, i);
            debug::print(&item.title);
            if (item.done) {
                debug::print(&string::utf8(b" [done]"));
            } else {
                debug::print(&string::utf8(b" [open]"));
            };
            i = i + 1;
        };
    }
}
