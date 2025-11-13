#[test_only]
module move_bootcamp_01::counter_tests {
    use move_bootcamp_01::counter;
    use sui::test_scenario;

    const OWNER: address = @0xA11CE;
    const OTHER: address = @0xBEEF;

    #[test]
    fun test_counter_flow() {
        let mut scenario = test_scenario::begin(OWNER);
        test_scenario::create_system_objects(&mut scenario);
        let ctx = test_scenario::ctx(&mut scenario);

        // cria contador com alvo 3
        let mut c = counter::create_counter(3, ctx);
        // incrementa 1 vez
        counter::increment(&mut c, ctx);
        assert!(counter::get_current(&c) == 1, 0);

        // incrementa até completar
        counter::increment(&mut c, ctx);
        counter::increment(&mut c, ctx);
        assert!(counter::is_completed(&c), 1);

        // reseta
        counter::reset(&mut c, ctx);
        assert!(counter::get_current(&c) == 0, 2);

        // transfere o contador para o dono e finaliza o cenário
        sui::transfer::public_transfer(c, OWNER);
        test_scenario::end(scenario);
    }

    #[test]
    fun test_transfer_ownership() {
        let mut scenario = test_scenario::begin(OWNER);
        test_scenario::create_system_objects(&mut scenario);
        let ctx = test_scenario::ctx(&mut scenario);

        let mut c = counter::create_counter(2, ctx);

        // transfere para outro endereço
        counter::transfer(&mut c, OTHER, ctx);

    // transfere o objeto para o inventário do novo owner e avança para próxima tx
    sui::transfer::public_transfer(c, OTHER);
    test_scenario::next_tx(&mut scenario, OTHER);

        // novo owner pega o objeto e incrementa
        let mut c2 = test_scenario::take_from_sender<move_bootcamp_01::counter::Counter>(&scenario);
        let ctx2 = test_scenario::ctx(&mut scenario);
        counter::increment(&mut c2, ctx2);
        assert!(counter::get_current(&c2) == 1, 0);

        // transfere de volta para o dono atual (agora OTHER) e finaliza
        sui::transfer::public_transfer(c2, OTHER);
        test_scenario::end(scenario);
    }
}
