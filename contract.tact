/// ТУМАН — cNFT + логика роллов

contract Tuman {
    data owner: Address;
    data totalMinted: Int;
    data cards: Dictionary;
    data basePrice: Int;

    receive() {
        totalMinted = 0;
        cards = Dictionary.empty<256, 256>();
        basePrice = 50_000_000;
    }

    receive(internal msg: InternalMessage) {
        if (msg.value >= basePrice) {
            let cardId = totalMinted + 1;
            let seed = intAsRef(msg.value ^ totalMinted ^ msg.lt.lib.size);
            let cells = Dictionary.empty<7, 3>();
            cards.set(cardId, packCellState(seed, cells, 1, 0, []));
            totalMinted = totalMinted + 1;
            basePrice = basePrice * 15 / 10;
        }
    }

    receive(extmsg msg: ExternalMessage) {
        if (msg.body.begin_parse().load_bits(32) == 0x524F4C4C) {
            let cardId = msg.body.load_uint(256);
            let state = cards.get(cardId);
            let seed = state.load_uint(256);
            let cells = state.load_dict();
            let evolution = state.load_uint(8);
            let rollsToday = state.load_uint(8);

            if (rollsToday < 4 && msg.value >= 20_000_000) {
                let newSeed = (seed ^ msg.value ^ msg.lt.lib.size) & 0xFFFFFFFF;
                let cellIndex = (newSeed % 64) as Int;
                let roll = (newSeed >> 8) % 100;
                let cellValue: Int;

                if (roll < 35) { cellValue = 1; }
                elif (roll < 65) { cellValue = 2 + (newSeed >> 16) % 4; }
                elif (roll < 85) { cellValue = 1; }
                elif (roll < 95) { cellValue = 4; }
                else { cellValue = 1; }

                cells.set(cellIndex, cellValue);
                rollsToday = rollsToday + 1;

                let opened = countOpened(cells);
                let newEvo = evolution;
                if (opened >= 10) { newEvo = max(newEvo, 2); }
                if (opened >= 20) { newEvo = max(newEvo, 3); }
                if (opened >= 30) { newEvo = max(newEvo, 4); }
                if (opened >= 40) { newEvo = max(newEvo, 5); }
                if (opened >= 50) { newEvo = max(newEvo, 6); }
                if (opened >= 60) { newEvo = max(newEvo, 7); }

                cards.set(cardId, packCellState(newSeed, cells, newEvo, rollsToday, []));
            }
        }
    }

    get method getCard(cardId: Int): (Int, Dictionary, Int, Int) {
        let state = cards.get(cardId);
        return (state.load_uint(256), state.load_dict(), state.load_uint(8), state.load_uint(8));
    }

    get method getTotalMinted(): Int {
        return totalMinted;
    }

    get method getBasePrice(): Int {
        return basePrice;
    }
}

function countOpened(cells: Dictionary): Int {
    let count = 0;
    cells.iterate((_, v) => {
        if (v > 0) { count = count + 1; }
    });
    return count;
}

function packCellState(seed: Int, cells: Dictionary, evo: Int, rolls: Int, journal: CellSlice): CellSlice {
    let s = begin_cell().store_uint(seed, 256).store_dict(cells).store_uint(evo, 8).store_uint(rolls, 8);
    return s.end_cell();
}
