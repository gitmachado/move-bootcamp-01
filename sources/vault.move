/// Module: vault
module move_bootcamp_01::vault {
    use std::debug::print;
    use std::string::utf8;
    // TxContext e object são fornecidos pelo framework por padrão; não é necessário re-exportar aliases

    /// Cofre temporizado simples (simulação com saldo numérico)
    /// OBS: Exemplo pedagógico que armazena um saldo numérico (u64).
    /// Não realiza transferências de moedas SUI reais; adicionar suporte a Coin
    /// exige APIs de moedas e tratamento cuidadoso de recursos Coin<SUI>.
    public struct Vault has key, store {
        id: UID,
        owner: address,
        balance: u64,
           unlock_time: u64, // timestamp epoch em milissegundos
    }

    /// Error codes
    const E_NOT_OWNER: u64 = 1;
    const E_NOT_UNLOCKED: u64 = 2;
    const E_INSUFFICIENT_BALANCE: u64 = 3;

    /// Cria um novo cofre pertencente ao remetente da transação.
    /// `initial` é um depósito inicial numérico (simulado) e `unlock_time` é o timestamp epoch
    /// em milissegundos a partir do qual saques são permitidos.
    public fun create_vault(initial: u64, unlock_time: u64, ctx: &mut TxContext): Vault {
        let owner = tx_context::sender(ctx);
        let v = Vault {
            id: object::new(ctx),
            owner,
            balance: initial,
            unlock_time,
        };
        v
    }

    /// Deposita um valor numérico no cofre (apenas proprietário).
    public fun deposit(v: &mut Vault, amount: u64, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        assert!(sender == v.owner, E_NOT_OWNER);
        v.balance = v.balance + amount;
    }

    /// Retira um valor numérico do cofre (apenas proprietário) após o `unlock_time`.
    public fun withdraw(v: &mut Vault, amount: u64, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        assert!(sender == v.owner, E_NOT_OWNER);
           // Use the TxContext epoch timestamp (milliseconds) as the current time
           let now = tx_context::epoch_timestamp_ms(ctx);
        assert!(now >= v.unlock_time, E_NOT_UNLOCKED);
        assert!(v.balance >= amount, E_INSUFFICIENT_BALANCE);
        v.balance = v.balance - amount;
    }

    /// Retorna o saldo do cofre
    public fun get_balance(v: &Vault): u64 {
        v.balance
    }

    /// Retorna o tempo de desbloqueio
    public fun get_unlock_time(v: &Vault): u64 {
        v.unlock_time
    }

    /// Impressão de debug (simples)
    public fun debug_print(_v: &Vault) {
        // Parâmetro prefixado com '_' para suprimir warning de variável não usada
        print(&utf8(b"[vault] debug_print called"));
    }
}
