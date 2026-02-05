import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_test/shared/utils/responsive.dart';

void main() {
  testWidgets(
    'Given a BuildContext object, when the responsive class is instantiated, then it must generate the values according to the screen',
    (WidgetTester tester) async {
      //GIVEN
      await tester.pumpWidget(
        Builder(
          builder: (BuildContext context) {
            //THEN
            final Responsive responsive = Responsive.of(context);

            // THEN
            expect(responsive.width, equals(MediaQuery.of(context).size.width));
            expect(
              responsive.height,
              equals(MediaQuery.of(context).size.height),
            );
            expect(
              responsive.diagonal,
              equals(
                math.sqrt(
                  math.pow(MediaQuery.of(context).size.width, 2) +
                      math.pow(MediaQuery.of(context).size.height, 2),
                ),
              ),
            );
            expect(
              responsive.isTablet,
              equals(MediaQuery.of(context).size.shortestSide >= 600),
            );

            return Container();
          },
        ),
      );
    },
  );
}
