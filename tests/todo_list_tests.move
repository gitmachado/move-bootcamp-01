#[test_only]
module move_bootcamp_01::todo_list_tests {
    use move_bootcamp_01::todo_list;
    use sui::test_scenario;

    const OWNER: address = @0xA11CE;

    #[test]
    fun test_add_toggle_remove() {
        let mut scenario = test_scenario::begin(OWNER);
        // garante objetos de sistema (não estritamente necessário aqui, mas seguro)
        test_scenario::create_system_objects(&mut scenario);
        let ctx = test_scenario::ctx(&mut scenario);

        // cria lista vazia
        let mut list = todo_list::create_list(ctx);
        assert!(todo_list::len(&list) == 0, 0);

        // adiciona dois itens
        todo_list::add_item(&mut list, b"Título 1", b"Descrição 1");
        todo_list::add_item(&mut list, b"Título 2", b"Descrição 2");
        assert!(todo_list::len(&list) == 2, 1);

        // toggle no primeiro item
        todo_list::toggle_item(&mut list, 1);

        // remove o primeiro (agora índice 1 ou 2 dependendo da implementação)
        todo_list::remove_item(&mut list, 1);
        assert!(todo_list::len(&list) == 1, 2);

        // transfere a lista para o dono para que os efeitos do tx incluam a
        // transferência e então finaliza o cenário.
        sui::transfer::public_transfer(list, OWNER);
        test_scenario::end(scenario);
    }
}
