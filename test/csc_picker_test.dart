import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:csc_picker_v2/csc_picker.dart';

const String mockJson = '''
[
  {
    "id": 100,
    "name": "India",
    "emoji": "🇮🇳",
    "emojiU": "U+1F1EE U+1F1F3",
    "iso2": "IN",
    "iso3": "IND",
    "countrycode": 91,
    "state": [
      {
        "id": 1,
        "name": "Delhi",
        "country_id": 100,
        "city": [
          {
            "id": 1,
            "name": "New Delhi",
            "state_id": 1
          }
        ]
      }
    ]
  }
]
''';

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key == 'packages/csc_picker_v2/lib/assets/country.json') {
      return ByteData.view(
        Uint8List.fromList(utf8.encode(mockJson)).buffer,
      );
    }
    throw PlatformException(code: '404', message: 'Asset not found');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('CSCPicker robust default pre-selection matching', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: CSCPicker(
              currentCountry: "India",
              currentState: "Delhi",
              currentCity: "New Delhi",
              onCountryChanged: (val) {},
              onStateChanged: (val) {},
              onCityChanged: (val) {},
            ),
          ),
        ),
      ),
    );

    // Let the async setDefaults() run and trigger setState.
    await tester.pumpAndSettle();

    expect(find.text('🇮🇳    India'), findsOneWidget);
    expect(find.text('Delhi'), findsOneWidget);
    expect(find.text('New Delhi'), findsOneWidget);
  });
}
