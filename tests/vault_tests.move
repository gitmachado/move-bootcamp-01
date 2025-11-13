#[test_only]
module move_bootcamp_01::vault_tests {
    use move_bootcamp_01::vault;
    use sui::test_scenario;

    const OWNER: address = @0xA11CE;

    #[test]
    fun test_create_and_deposit_withdraw() {
    let mut scenario = test_scenario::begin(OWNER);
    // Cria e compartilha objetos de sistema (Clock, Random, DenyList, ...)
    test_scenario::create_system_objects(&mut scenario);
    let ctx = test_scenario::ctx(&mut scenario);

    // Cria um cofre que desbloqueia imediatamente (usa timestamp do TxContext em ms)
    let mut vault = vault::create_vault(10, sui::tx_context::epoch_timestamp_ms(ctx), ctx);

        // Deposita 5
        vault::deposit(&mut vault, 5, ctx);
        assert!(vault::get_balance(&vault) == 15, 0);

    // Retira 8 (permitido porque unlock_time == now)
    vault::withdraw(&mut vault, 8, ctx);
    assert!(vault::get_balance(&vault) == 7, 1);

    // Transfere o cofre para o proprietário para que os efeitos do tx sejam registrados
    // e o cenário possa encerrar corretamente.
    sui::transfer::public_transfer(vault, OWNER);
    test_scenario::end(scenario);
    }

    #[test, expected_failure(abort_code = 2)]
    fun test_withdraw_before_unlock() {
    let mut scenario = test_scenario::begin(OWNER);
    // Cria e compartilha objetos de sistema para que clock e outros módulos estejam disponíveis
    test_scenario::create_system_objects(&mut scenario);
    let ctx = test_scenario::ctx(&mut scenario);

    // Cria um cofre que desbloqueia no futuro (timestamp em ms)
    let future = sui::tx_context::epoch_timestamp_ms(ctx) + 10_000;
    let mut vault = vault::create_vault(20, future, ctx);

    // Tenta sacar antes do desbloqueio -> deve abortar com E_NOT_UNLOCKED (2)
    vault::withdraw(&mut vault, 1, ctx);

    // Transfere o cofre de volta para o proprietário para que os efeitos incluam a transferência
    // e então encerra o cenário.
    sui::transfer::public_transfer(vault, OWNER);
    test_scenario::end(scenario);
    }
}
