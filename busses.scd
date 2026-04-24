(
// Libération idempotente : gère à la fois les bus stéréo directs
// (reverb, delay, master) et le tableau de slots (voix[i] = (a:, b:)).
if(~busses.notNil) {
    ~busses.keysValuesDo { |k, v|
        case
        { v.isKindOf(Bus) } { v.free }
        { v.isKindOf(SequenceableCollection) } {
            v.do { |slot|
                if(slot.isKindOf(Event)) {
                    slot.a.free;
                    slot.b.free;
                };
            };
        };
    };
};

~busses = (
    reverb: Bus.audio(s, 2),
    delay:  Bus.audio(s, 2),
    master: Bus.audio(s, 2),
    voix:   Array.fill(4, { (a: Bus.audio(s, 2), b: Bus.audio(s, 2)) }),
);

"Bus créés : reverb=%, delay=%, master=%".format(
    ~busses.reverb.index,
    ~busses.delay.index,
    ~busses.master.index
).postln;

~busses.voix.do { |slot, i|
    "  voix[%] : a=%, b=%".format(i, slot.a.index, slot.b.index).postln;
};
)
