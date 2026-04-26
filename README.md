# MorphCongas

Système de génération rythmique en SuperCollider basé sur la transformation morphologique de mots binaires (séquences de 1 et 2). Développé dans le cadre d'une recherche sur les structures rythmiques fractales et les transformations continues entre métriques.

## Concept

Un *word* est une suite d'entiers (`[2, 1, 1, 2, 2, 1, 2]` par exemple) qui définit un pattern rythmique. Chaque valeur correspond à une pulsation dont la durée est modulée par un paramètre `morph` continu entre 0 et 1.

- À `morph = 0` : toutes les pulsations ont la même durée (rythme straight).
- À `morph = 1` : les pulsations marquées `2` sont étirées selon un ratio (par défaut, doublées).

Cette modulation continue permet une transition fluide entre rythmes droits et boiteux, contrôlable en performance.

Deux variantes coexistent par défaut pour chaque word :
- **Voix sans subdivision** (`sub: false`) : applique directement le morphing sur le word original.
- **Voix avec subdivision** (`sub: true`) : applique une règle de réécriture (`1 → [2]`, `2 → [1,1]`) avant le morphing.

Les deux voix tournent en parallèle, partagent le même word et le même morph, et peuvent être mixées en V-inversé via un knob.

## Dépendances

- **SuperCollider** 3.12 ou ultérieur ([supercollider.github.io](https://supercollider.github.io/))
- **Quark Pneu** : la classe `Pneu` qui implémente le morphing rythmique. Le code source est inclus dans le dossier `Pneu/` (version modifiée acceptant un pattern dynamique pour l'argument `word`).
- **Midi Fighter Twister** (DJ TechTools) : contrôleur MIDI 4×4 encoders pour les paramètres en temps réel. Le système peut être adapté à d'autres contrôleurs en modifiant `midifighter.scd`.

## Installation

1. Cloner le repo :
   ```bash
   git clone https://github.com/malcolmbraff/MorphCongas.git
   ```

2. Installer la version modifiée de Pneu :
   ```bash
   cp Pneu/PneuBase.sc ~/Library/Application\ Support/SuperCollider/Extensions/Pneu/
   ```
   Puis dans SuperCollider, recompiler la class library : *Language > Recompile Class Library* (ou Cmd+Shift+L).

3. Ajuster le chemin des samples dans `synths.scd` pour pointer vers `sounds/clacks/` du repo (ou tout autre dossier de samples).

4. Lancer SuperCollider, ouvrir `Morph_Congas.scd` et évaluer le bloc principal (Cmd+Enter sur le `(...)`).

## Architecture

Le code est organisé en fichiers thématiques chargés dans cet ordre depuis `Morph_Congas.scd` :

| Fichier | Rôle |
|---|---|
| `synths.scd` | SynthDefs des sources (`\negSaw`, `\bufplay`) et chargement des samples |
| `effects.scd` | SynthDefs des effets (`\reverb`, `\delay`, `\master`) |
| `busses.scd` | Allocation des bus audio (`~busses.master`, `~busses.reverb`, `~busses.delay`) |
| `routing.scd` | Instanciation des synths d'effets, ordre d'exécution sur le serveur |
| `midifighter.scd` | Infrastructure MIDI (capture des CCs et notes, hooks vides par défaut) |
| `material.scd` | Matériaux et état initial (`~words`, `~morph`, `~amp1/2`, `~sendReverb`, `~reverbAmp`) |
| `patterns.scd` | `Pdef(\rhythm)` regroupant deux Pbind dans un Ppar |
| `actions.scd` | Verbes de haut niveau (`togglePlay`, `toggleAuto`, `nextWord`, `prevWord`, etc.) |
| `mappings.scd` | Routage MIDI → actions et variables |
| `ui.scd` | (optionnel) Fenêtre plein écran pour présentation |

Cette séparation permet de recharger un fichier individuel pendant la performance sans interrompre le système.

## Contrôles

### Knobs (rotations des encoders, ch 0)

| Knob | Paramètre | Plage |
|---|---|---|
| 0 | `~morph` | 0 (straight) → 1 (transformé) |
| 1 | Mix entre voix 1 et voix 2 | gauche : voix 1 isolée, milieu : les deux à fond, droite : voix 2 isolée |
| 2 | `~sendReverb` | niveau d'envoi des deux voix vers la reverb |
| 3 | `~reverbAmp` | niveau de retour de la reverb dans le master |

### Pushes (clic sur l'encoder, ch 1)

| Push | Action |
|---|---|
| 0 | Toggle play/stop manuel (sans automation) |
| 1 | Toggle play/stop avec routines automatiques (morph oscillant + cycler de words) |
| 2 | Word précédent dans `~words` |
| 3 | Word suivant dans `~words` |

### Mode automatique

Quand `toggleAuto` est activé :
- `~morph` oscille entre 0 et 1 par paliers de 1/16 (montée puis descente, période de 32 beats).
- `~wordIndex` avance d'un cran toutes les 16 unités de temps, en boucle sur la liste `~words`.
- L'image associée à chaque word change automatiquement à l'écran (si `ui.scd` est chargé).

## Words par défaut

Les patterns rythmiques de base sont des suites binaires choisies pour leur intérêt morphologique :

```supercollider
~words = [
    [2, 1, 1, 2, 2, 1, 2],
    [1, 2, 1, 1, 2, 1, 2, 1],
    [1, 2, 1, 2, 1, 2, 1, 2],
    [2, 1, 1, 2, 1, 1, 2, 1, 1],
    [2, 1, 2, 2, 1, 2, 2, 1, 2],
    [1, 2, 1, 2, 1, 2, 1, 2, 1, 2],
    [2, 1, 1, 2, 1, 2, 1, 1, 2, 1]
];
```

Modifiables à chaud dans `material.scd` ou en évaluant directement `~words = [...]` dans une session SC.

## Modification de la classe Pneu

Le Pneu original ne traite pas l'argument `word` comme un stream — il est figé à l'instanciation du pattern. La modification incluse dans ce repo (`Pneu/PneuBase.sc`) permet de passer un pattern (typiquement `Pfunc({ ~word })`) qui sera relu à chaque cycle, rendant le changement de word audible sans reconstruction du Pdef.

Voir le fichier pour le détail technique. La compatibilité ascendante est préservée : passer un Array fonctionne comme avant.

## Présentation

Le fichier `ui.scd` ouvre une fenêtre plein écran qui affiche :
- L'image associée au word courant (un fichier `systeme_N.png` par word, dans `images/`).
- La valeur de `~morph` en pourcentage, mise à jour en temps réel.
- Une barre de progression indiquant la valeur de `~morph` de 0 à 1.

Quitter la fenêtre : touche `ESC`.

## Structure des dossiers

```
MorphCongas/
├── Morph_Congas.scd           ← point d'entrée
├── synths.scd
├── effects.scd
├── busses.scd
├── routing.scd
├── midifighter.scd
├── material.scd
├── patterns.scd
├── actions.scd
├── mappings.scd
├── ui.scd
├── test.scd                   ← tests manuels (non chargé par le main)
├── Pneu/
│   ├── Pneu.sc
│   └── PneuBase.sc            ← version modifiée
├── sounds/
│   └── clacks/
│       ├── 1.aiff
│       └── ...
└── images/
    ├── systeme_1.png
    └── ...
```

## Licence

À définir.

## Auteur

Malcolm Braff — recherche en composition algorithmique et morphologie rythmique.
