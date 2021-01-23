import 'package:flutter/material.dart';
import '../global.dart' as globals;
import '../app_theme.dart';

class PeopleSliderView extends StatefulWidget {
  const PeopleSliderView({Key key, this.onChangePeopleValue, this.peopleValue})
      : super(key: key);

  final Function(double) onChangePeopleValue;
  final double peopleValue;

  @override
  _PeopleSliderViewState createState() => _PeopleSliderViewState();
}

class _PeopleSliderViewState extends State<PeopleSliderView> {
  double peopleValue;

  @override
  void initState() {
    peopleValue = widget.peopleValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: peopleValue.round(),
                child: const SizedBox(),
              ),
              Container(
                width: 170,
                child: Text(
                  '${peopleValue.round().toString()}人',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: peopleValue.round(),
                child: const SizedBox(),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              thumbShape: CustomThumbShape(),
            ),
            child: Slider(
              onChanged: !globals.isFilterOn
                  ? null
                  : (double value) {
                      setState(() {
                        peopleValue = value;
                      });
                      try {
                        widget.onChangePeopleValue(peopleValue);
                      } catch (_) {}
                    },
              min: 1,
              max: 12,
              activeColor: !globals.isFilterOn
                  ? Colors.grey.withOpacity(0.4)
                  : CafeExpressTheme.buildLightTheme().primaryColor,
              inactiveColor: Colors.grey.withOpacity(0.4),
              divisions: 11,
              value: peopleValue,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomThumbShape extends SliderComponentShape {
  static const double _thumbSize = 3.0;
  static const double _disabledThumbSize = 3.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return isEnabled
        ? const Size.fromRadius(_thumbSize)
        : const Size.fromRadius(_disabledThumbSize);
  }

  static final Animatable<double> sizeTween = Tween<double>(
    begin: _disabledThumbSize,
    end: _thumbSize,
  );

  @override
  void paint(
    PaintingContext context,
    Offset thumbCenter, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    Size sizeWithOverflow,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double textScaleFactor,
    double value,
  }) {
    final Canvas canvas = context.canvas;
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    canvas.drawPath(
        Path()
          ..addOval(Rect.fromPoints(
              Offset(thumbCenter.dx + 12, thumbCenter.dy + 12),
              Offset(thumbCenter.dx - 12, thumbCenter.dy - 12)))
          ..fillType = PathFillType.evenOdd,
        Paint()
          ..color = Colors.black.withOpacity(0.5)
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(8)));

    final Paint cPaint = Paint();
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.drawCircle(Offset(thumbCenter.dx, thumbCenter.dy), 12, cPaint);
    cPaint..color = colorTween.evaluate(enableAnimation);
    canvas.drawCircle(Offset(thumbCenter.dx, thumbCenter.dy), 10, cPaint);
  }

  double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }
}
