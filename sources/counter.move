module move_bootcamp_01::counter {
  // módulos do framework (sui::tx_context e sui::object) estão disponíveis por padrão

  /// Pequeno contrato de contador on-chain.
  /// Este módulo define um objeto `Counter` com `has key` para que seja um
  /// objeto armazenado na blockchain. Funções públicas permitem criar e
  /// manipular o contador de forma segura (somente o proprietário).
  public struct Counter has key, store {
    id: UID,
    owner: address,
    current: u64,
    target: u64,
  }

  /// Erros
  const ECOUNTER_OVERFLOW: u64 = 1;
  const E_NOT_OWNER: u64 = 2;

  /// Cria um novo Counter on-chain. O remetente da transação será o `owner`.
  /// Retorna o objeto Counter recém-criado (o chamador recebe a posse).
  public fun create_counter(target: u64, ctx: &mut TxContext): Counter {
    let owner = tx_context::sender(ctx);
    Counter {
      id: object::new(ctx),
      owner,
      current: 0,
      target,
    }
  }

  /// Incrementa o contador. Apenas o proprietário pode chamar.
  public fun increment(counter: &mut Counter, ctx: &mut TxContext) {
    let sender = tx_context::sender(ctx);
    assert!(sender == counter.owner, E_NOT_OWNER);
    assert!(counter.current < counter.target, ECOUNTER_OVERFLOW);
    counter.current = counter.current + 1;
  }

  /// Lê o valor atual do contador (view-read).
  public fun get_current(counter: &Counter): u64 {
    counter.current
  }

  /// Verifica se o contador atingiu o alvo
  public fun is_completed(counter: &Counter): bool {
    counter.current == counter.target
  }

  /// Reseta o contador para zero (somente owner)
  public fun reset(counter: &mut Counter, ctx: &mut TxContext) {
    let sender = tx_context::sender(ctx);
    assert!(sender == counter.owner, E_NOT_OWNER);
    counter.current = 0;
  }

  /// Transferir posse do contador para outro endereço (owner only)
  /// Transfere a posse do objeto Counter para outro endereço.
  /// Apenas o owner atual pode chamar. Modifica o objeto na hora (in-place).
  public fun transfer(counter: &mut Counter, new_owner: address, ctx: &mut TxContext) {
    let sender = tx_context::sender(ctx);
    assert!(sender == counter.owner, E_NOT_OWNER);
    counter.owner = new_owner;
  }
}