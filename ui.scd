(
// ---- Cleanup idempotent ----
if(~uiWin.notNil) { ~uiWin.close };
if(~uiRoutine.notNil) { ~uiRoutine.stop };

// ---- Configuration ----
~imagesPath = "/Users/malcolmbraff/Documents/GitHub/MorphCongas/images/";

// ---- Charger les images ----
// Note : Array.includes est cassé sur les Strings dans cette version de SC,
// donc on utilise .any pour le filtrage.
~uiImages = [];
PathName(~imagesPath).entries
    .select { |e|
        var ext = e.extension.toLower;
        ["jpg", "jpeg", "png"].any { |allowed| allowed == ext }
    }
    .sort { |a, b| a.fileName < b.fileName }
    .do { |e|
        ~uiImages = ~uiImages.add(Image.new(e.fullPath));
    };

("UI: % images chargées".format(~uiImages.size)).postln;

// ---- État de l'affichage ----
~uiImageIndex = 0;

// ---- Fenêtre plein écran ----
~uiWin = Window("Morph Congas",
    Window.screenBounds,
    resizable: false,
    border: false
)
    .background_(Color.black)
    .userCanClose_(true);

// Quitter avec ESC
~uiWin.view.keyDownAction = { |view, char, modifiers, unicode, keycode|
    if(keycode == 53 or: { unicode == 27 }) {   // ESC
        ~uiWin.endFullScreen;
        ~uiWin.close;
    };
};

// ---- Vue principale ----
~uiView = UserView(~uiWin, ~uiWin.bounds.moveTo(0, 0))
    .background_(Color.black)
    .drawFunc_({ |view|
        var img, imgRect;
        var w = view.bounds.width;
        var h = view.bounds.height;
        var morphPct = (~morph ? 0) * 100;
        var label;

        // ---- Image plein écran avec préservation des proportions (letterbox) ----
        if(~uiImages.size > 0) {
            img = ~uiImages[~uiImageIndex];
            imgRect = Rect(0, 0, w, h);

            if((img.width / img.height) > (w / h)) {
                // image plus large que la fenêtre : ajuster sur la largeur
                imgRect.width = w;
                imgRect.height = w * img.height / img.width;
                imgRect.top = (h - imgRect.height) / 2;
            } {
                // image plus haute : ajuster sur la hauteur
                imgRect.height = h;
                imgRect.width = h * img.width / img.height;
                imgRect.left = (w - imgRect.width) / 2;
            };

            img.drawInRect(imgRect);
        };

        // ---- Affichage de la valeur de morph en surimpression ----
        label = morphPct.round(0.1).asString ++ " %";

        // Ombre derrière le texte (lisibilité sur image variable)
        Pen.color = Color.black.alpha_(0.6);
        Pen.font = Font("Helvetica-Bold", 96);
        Pen.stringAtPoint(label, Point(64, h - 160));

        // Texte principal
        Pen.color = Color.white;
        Pen.font = Font("Helvetica-Bold", 96);
        Pen.stringAtPoint(label, Point(60, h - 164));

        // ---- Barre de progression de morph ----
        block {
            var barX = 60;
            var barY = h - 50;
            var barW = w - 120;
            var barH = 12;

            Pen.color = Color.white.alpha_(0.3);
            Pen.fillRect(Rect(barX, barY, barW, barH));

            Pen.color = Color.white;
            Pen.fillRect(Rect(barX, barY, barW * (~morph ? 0), barH));
        };
    });

// Plein écran
~uiWin.fullScreen;
~uiWin.front;

// ---- Routine de rafraîchissement (pour suivre ~morph en continu) ----
~uiRoutine = Routine({
    loop {
        { if(~uiView.notNil) { ~uiView.refresh } }.defer;
        0.05.wait;   // 20 Hz : suffisant pour suivre les variations du knob
    };
}).play(AppClock);

// ---- Hooks pour avancer/reculer l'image ----
// Sera appelé depuis ~actions.nextWord et ~actions.prevWord
~uiNextImage = {
    if(~uiImages.size > 0) {
        ~uiImageIndex = (~uiImageIndex + 1) % ~uiImages.size;
        { ~uiView.refresh }.defer;
    };
};

~uiPrevImage = {
    if(~uiImages.size > 0) {
        ~uiImageIndex = (~uiImageIndex - 1).mod(~uiImages.size);
        { ~uiView.refresh }.defer;
    };
};

~uiSetImage = { |idx|
    if(~uiImages.size > 0) {
        ~uiImageIndex = idx % ~uiImages.size;
        { ~uiView.refresh }.defer;
    };
};

"UI prête : ESC pour quitter, % images, % x % px".format(
    ~uiImages.size,
    Window.screenBounds.width,
    Window.screenBounds.height
).postln;
)
