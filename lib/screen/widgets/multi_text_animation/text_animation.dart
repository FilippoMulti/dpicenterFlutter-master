import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../dashboard/ascii_art_generator.dart';

class TextAnimation extends StatefulWidget {
  final String text;

  const TextAnimation({Key? key, required this.text}) : super(key: key);

  @override
  TextAnimationState createState() => TextAnimationState();
}

class TextAnimationState extends State<TextAnimation> {
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
  int index = 0;
  int asset = 0;
  int color = 0;
  double fontSize = 8;
  bool _assetsLoaded = false;
  bool _assetsLoading = false;
  String text = '';
  final List<String> _assets = <String>[];

  Timer scheduleTimeout([int milliseconds = 1000]) =>
      Timer.periodic(Duration(milliseconds: milliseconds), handleTimeout);

  void handleTimeout(timer) {
    index++;
    if (index >= text.length) {
      index = 0;
    }
    fontSize = Random().nextDouble() * (24 - 16) + 16;
    if (_assetsLoaded) {
      asset = Random().nextInt(_assets.length);
    }
    color = Random().nextInt(Colors.primaries.length);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    text = widget.text.replaceAll(' ', '');
    scheduleTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return getAsciiArt(text[index]);
  }

  Widget getAsciiArt(String text) {
    return FutureBuilder<void>(
        future: _loadAssets(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          //if (snapshot.hasData){
          return AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: Random().nextInt(800)),
            style: TextStyle(fontSize: fontSize),
            child: Text(
              _assetsLoaded
                  ? renderTextWithFont(_assets[asset], text)
                  : 'loading...',
              style: TextStyle(
                  color: Colors.primaries[color],
                  fontFamily: 'Roboto Mono',
                  fontFeatures: const [FontFeature.tabularFigures()]),
              textAlign: TextAlign.center,
            ),
          );

          /*}
          return const Text("...");*/
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
          debugPrint('error loading font: $font: $e');
        }
      }
      _assetsLoaded = true;
    }
  }
}
