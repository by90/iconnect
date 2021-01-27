import 'package:flutter_test/flutter_test.dart';

class Singleton {
  static final Singleton _singleton = Singleton._internal();
  factory Singleton() => _singleton;
  Singleton._internal(); // private constructor
}

get single => Singleton();

class Counter {
  Counter(this.value);
  final int value;

  call(int another) => another + value;
}

void main() {
  test('hashcode of Singleton instance is same', () {
    var s1 = Singleton();
    var s2 = Singleton();
    var s3 = single;

    print(identical(s1, s2)); // true
    print(s1 == s2); // true
    expect(identical(s1, s2), true);
    expect(s1 == s2 && s1 == s3, true);
    expect(s1.hashCode, s2.hashCode);
    expect(s1.hashCode, single.hashCode);
  });

//use call for class instance
  test('call and constructor', () {
    var s1 = Counter(0);
    expect(0, s1.value);
    expect(3, s1(3));
  });
}
