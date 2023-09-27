import 'dart:async';

import 'package:flutter/material.dart';

import '../dashboard/ascii_art_generator.dart';

class FontProvider extends StatefulWidget {
  final Widget child;

  const FontProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  static FontProviderState? of(BuildContext context) {
    return context.findAncestorStateOfType<FontProviderState>();
  }

  @override
  FontProviderState createState() => FontProviderState();
}

class FontProviderState extends State<FontProvider>
    with SingleTickerProviderStateMixin {
  List<String> fonts = <String>[
    'funfaces.flf',
    'fuzzy.flf',
    'georgi16.flf',
    'Georgia11.flf',
    'ghost.flf',
    'ghoulish.flf',
    'glenyn.flf',
    'goofy.flf',
    'gothic.flf',
    'graceful.flf',
    'gradient.flf',
    'graffiti.flf',
    'greek.flf',
    'heart_left.flf',
    'heart_right.flf',
    'henry3d.flf',
    'hex.flf',
    'hieroglyphs.flf',
    'hollywood.flf',
    'horizontalleft.flf',
    'horizontalright.flf',
    'ICL-1900.flf',
    'impossible.flf',
    'invita.flf',
    'isometric1.flf',
    'isometric2.flf',
    'isometric3.flf',
    'isometric4.flf',
    'italic.flf',
    'ivrit.flf',
    'jacky.flf',
    'jazmine.flf',
    'jerusalem.flf',
    'katakana.flf',
    'kban.flf',
    'keyboard.flf',
    'knob.flf',
    'konto.flf',
    'kontoslant.flf',
    'larry3d.flf',
    'lcd.flf',
    'lean.flf',
    'letters.flf',
    'lildevil.flf',
    'lineblocks.flf',
    'linux.flf',
    'lockergnome.flf',
    'madrid.flf',
    'marquee.flf',
    'maxfour.flf',
    'merlin1.flf',
    'merlin2.flf',
    'mike.flf',
    'mini.flf',
    'mirror.flf',
    'mnemonic.flf',
    'modular.flf',
    'morse.flf',
    'morse2.flf',
    'moscow.flf',
    'mshebrew210.flf',
    'muzzle.flf',
    'nancyj.flf',
    'nancyj-fancy.flf',
    'nancyj-improved.flf',
    'nancyj-underlined.flf',
    'nipples.flf',
    'nscript.flf',
    'ntgreek.flf',
    'nvscript.flf',
    'o8.flf',
    'octal.flf',
    'ogre.flf',
    'oldbanner.flf',
    'os2.flf',
    'pawp.flf',
    'peaks.flf',
    'peaksslant.flf',
    'pebbles.flf',
    'pepper.flf',
    'poison.flf',
    'puffy.flf',
    'puzzle.flf',
    'pyramid.flf',
    'rammstein.flf',
    'rectangles.flf',
    'red_phoenix.flf',
    'relief.flf',
    'relief2.flf',
    'rev.flf',
    'reverse.flf',
    'roman.flf',
    'rot13.flf',
    'rotated.flf',
    'rounded.flf',
    'rowancap.flf',
    'rozzo.flf',
    'runic.flf',
    'runyc.flf',
    'santaclara.flf',
    'sblood.flf',
    'script.flf',
    'serifcap.flf',
    'shadow.flf',
    'shimrod.flf',
    'short.flf',
    'slant.flf',
    'slide.flf',
    'slscript.flf',
    'small.flf',
    'smallcaps.flf',
    'smisome1.flf',
    'smkeyboard.flf',
    'smpoison.flf',
    'smscript.flf',
    'smshadow.flf',
    'smslant.flf',
    'smtengwar.flf',
    'soft.flf',
    'speed.flf',
    'spliff.flf',
    's-relief.flf',
    'stacey.flf',
    'stampate.flf',
    'stampatello.flf',
    'standard.flf',
    'starstrips.flf',
    'starwars.flf',
    'stellar.flf',
    'stforek.flf',
    'stop.flf',
    'straight.flf',
    'sub-zero.flf',
    'swampland.flf',
    'swan.flf',
    'sweet.flf',
    'tanja.flf',
    'tengwar.flf',
    'term.flf',
    'test1.flf',
    'thick.flf',
    'thin.flf',
    'threepoint.flf',
    'ticks.flf',
    'ticksslant.flf',
    'tiles.flf',
    'tinker-toy.flf',
    'tombstone.flf',
    'train.flf',
    'trek.flf',
    'tsalagi.flf',
    'tubular.flf',
    'twisted.flf',
    'twopoint.flf',
    'univers.flf',
    'usaflag.flf',
    'varsity.flf',
    'wavy.flf',
    'weird.flf',
    'wetletter.flf',
    'whimsy.flf',
    'wow.flf',
    '1row.flf',
    '3-d.flf',
    '3d_diagonal.flf',
    '3x5.flf',
    '4max.flf',
    '5lineoblique.flf',
    'acrobatic.flf',
    'alligator.flf',
    'alligator2.flf',
    'alligator3.flf',
    'alpha.flf',
    'alphabet.flf',
    'amc3line.flf',
    'amc3liv1.flf',
    'amcaaa01.flf',
    'amcneko.flf',
    'amcrazo2.flf',
    'amcrazor.flf',
    'amcslash.flf',
    'amcslder.flf',
    'amcthin.flf',
    'amctubes.flf',
    'amcun1.flf',
    'arrows.flf',
    'ascii_new_roman.flf',
    'avatar.flf',
    'B1FF.flf',
    'banner.flf',
    'banner3.flf',
    'banner3-D.flf',
    'banner4.flf',
    'barbwire.flf',
    'basic.flf',
    'bear.flf',
    'bell.flf',
    'benjamin.flf',
    'big.flf',
    'bigchief.flf',
    'bigfig.flf',
    'binary.flf',
    'block.flf',
    'blocks.flf',
    'bolger.flf',
    'braced.flf',
    'bright.flf',
    'broadway.flf',
    'broadway_kb.flf',
    'bubble.flf',
    'bulbhead.flf',
    'calgphy2.flf',
    'caligraphy.flf',
    'cards.flf',
    'catwalk.flf',
    'chiseled.flf',
    'chunky.flf',
    'coinstak.flf',
    'cola.flf',
    'colossal.flf',
    'computer.flf',
    'contessa.flf',
    'contrast.flf',
    'cosmic.flf',
    'cosmike.flf',
    'crawford.flf',
    'crazy.flf',
    'cricket.flf',
    'cursive.flf',
    'cyberlarge.flf',
    'cybermedium.flf',
    'cybersmall.flf',
    'cygnet.flf',
    'DANC4.flf',
    'dancingfont.flf',
    'decimal.flf',
    'defleppard.flf',
    'diamond.flf',
    'dietcola.flf',
    'digital.flf',
    'doh.flf',
    'doom.flf',
    'dosrebel.flf',
    'dotmatrix.flf',
    'double.flf',
    'doubleshorts.flf',
    'drpepper.flf',
    'dwhistled.flf',
    'eftichess.flf',
    'eftifont.flf',
    'eftipiti.flf',
    'eftirobot.flf',
    'eftitalic.flf',
    'eftiwall.flf',
    'eftiwater.flf',
    'epic.flf',
    'fender.flf',
    'filter.flf',
    'fire_font-k.flf',
    'fire_font-s.flf',
    'flipped.flf',
    'flowerpower.flf',
    'fourtops.flf',
    'fraktur.flf',
    'funface.flf',
  ];
  final List<String> _assets = <String>[];
  bool _assetsLoading = false;
  bool _assetsLoaded = false;

  List<String> notWorkingFont = <String>[];

  @override
  void initState() {
    super.initState();
  }

  Future<bool> isLoaded() async {
    return _assetsLoaded;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _loadAssets(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          //if (snapshot.hasData){
          if (_assetsLoaded) {
            return widget.child;
          }
          return const SizedBox();
        });
  }

  Future<void> _loadAssets() async {
    if (!_assetsLoaded && !_assetsLoading) {
      _assetsLoading = true;
      _assets.clear();
      for (String font in fonts) {
        try {
          debugPrint('try load asset: $font');
          _assets.add(await loadAsset(font));
          debugPrint('loaded: $font');
        } catch (e) {
          notWorkingFont.add(font);
          debugPrint('error loading font: $font: $e');
        }
      }
      for (String notWorking in notWorkingFont) {
        debugPrint("Not working font: $notWorking");
      }
      _assetsLoaded = true;
    }
  }
}
