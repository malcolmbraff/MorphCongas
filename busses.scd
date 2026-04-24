(
if(~busses.notNil) {
    ~busses.do { |bus| bus.free };
};

~busses = (
    reverb: Bus.audio(s, 2),
    delay:  Bus.audio(s, 2),
    master: Bus.audio(s, 2),
);

"Bus créés : reverb=%, delay=%, master=%".format(
    ~busses.reverb.index,
    ~busses.delay.index,
    ~busses.master.index
).postln;
)