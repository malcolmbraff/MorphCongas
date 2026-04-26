(
~root = thisProcess.nowExecutingPath.dirname +/+ "";
TempoClock.default.tempo = 0.5;

s.waitForBoot {
   [
    "synths.scd",
    "effects.scd",
    "busses.scd",
    "routing.scd",
    "midifighter.scd",
    "material.scd",
    "patterns.scd",
    "actions.scd",
    "mappings.scd",
    "ui.scd",          // <-- si tu veux la fenêtre plein écran
].do { |f| (~root ++ f).load };

    s.sync;  // attendre que tous les SynthDefs soient compilés côté serveur

    "Setup chargé depuis %".format(~root).postln;
};
)





