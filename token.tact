/// ТУМАН — токен сообщества

contract TumanToken {
    data totalSupply: Int;
    data balances: Dictionary;

    receive() {
        totalSupply = 0;
        balances = Dictionary.empty<256, 128>();
    }

    receive(internal msg: InternalMessage) {
        let to = msg.src;
        let amount = msg.value;
        let current = balances.get(to) ?? 0;
        balances.set(to, current + amount);
        totalSupply = totalSupply + amount;
    }

    get method balanceOf(addr: Address): Int {
        return balances.get(addr) ?? 0;
    }

    get method totalSupply(): Int {
        return totalSupply;
    }
}
