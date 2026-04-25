(
// Matière partagée entre les Pdef. ~morph et ~word sont lus
// dynamiquement par les Pbind via Pfunc, donc tout changement
// est entendu sans reconstruire les Pdef.
~words = [
    [2, 1, 1, 2, 2, 1, 2],
    [1, 2, 1, 1, 2, 1, 2, 1],
    [1, 2, 1, 2, 1, 2, 1, 2],
    [2, 1, 1, 2, 1, 1, 2, 1, 1],
    [2, 1, 2, 2, 1, 2, 2, 1, 2],
    [1, 2, 1, 2, 1, 2, 1, 2, 1, 2],
    [2, 1, 1, 2, 1, 2, 1, 1, 2, 1]
];
~wordIndex = 0;
~word = ~words[0];
~morph = 0.5;
)
