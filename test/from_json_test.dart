import 'package:flutter_test/flutter_test.dart';
//import 'package:iconnect/iconnect.dart';
import 'dart:convert';

class Counter {
  int value = 0;

  Counter(this.value); //亦可用命名参数
  factory Counter.fromJson(Map<String, dynamic> json) => Counter(
        json['value'],
      );

  Counter? fromJson(Map<String, dynamic> json) => Counter(
        json['value'],
      );

  Map<String, dynamic> toJson() => {
        'value': value,
      };
}

main() {
  test('hashcode of Singleton instance is same', () {
    var result = Counter.fromJson({"value": 1});
    var encode = json.encode(result,
        toEncodable: (Object? value) => value is Counter
            ? value.toJson()
            : throw UnsupportedError('Cannot convert to JSON: $value'));
    print(encode);

    //Counter counter = Counter(0);
    var obj = json.decode(encode, reviver: (key, value) {
      return null;
      //return (Counter.fromJson(json));
    });
    print(obj.toString());
    expect(true, result.value == 1);
  });
}


///
/// Example of converting an otherwise unsupported object to a
/// custom JSON format:
///
/// ```dart
/// class CustomClass {
///   final String text;
///   final int value;
///   CustomClass({required this.text, required this.value});
///   CustomClass.fromJson(Map<String, dynamic> json)
///       : text = json['text'],
///         value = json['value'];
///
///   static Map<String, dynamic> toJson(CustomClass value) =>
///       {'text': value.text, 'value': value.value};
/// }
///
/// void main() {
///   final CustomClass cc = CustomClass(text: 'Dart', value: 123);
///   final jsonText = jsonEncode({'cc': cc},
///       toEncodable: (Object? value) => value is CustomClass
///           ? CustomClass.toJson(value)
///           : throw UnsupportedError('Cannot convert to JSON: $value'));
///   print(jsonText); // {"cc":{"text":"Dart","value":123}}
/// }
/// ```
// String jsonEncode(Object? object,
//         {Object? toEncodable(Object? nonEncodable)?}) =>
//     json.encode(object, toEncodable: toEncodable);