#[test_only]
module move_bootcamp_01::sui_hello_world_tests {
    use move_bootcamp_01::sui_hello_world;

    #[test]
    fun test_print_sui_logo() {
        // Testa a função de impressão do logo
        sui_hello_world::print_sui_logo();
    }

    #[test]
    fun test_hello_sui() {
        // Testa a função completa de saudação
        sui_hello_world::hello_sui();
    }
}