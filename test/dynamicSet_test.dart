import 'package:flutter_test/flutter_test.dart';

class Counter {
  int value = 0;
  Counter(this.value);
}

class Greeting {
  String title = 'Hello,world!';
}

class Add<T> with Greeting {}

void main() {
  test('hashcode of Singleton instance is same', () {
    var mySet = Set<dynamic>();
    var counter1 = Counter(1);
    var counter2 = Counter(2);
    mySet.add(counter1);
    mySet.add(counter2);
    expect(true, mySet.contains(counter1));
  });

  test('we can get index from List<dynamic>', () {
    var counter1 = Counter(1);
    var counter2 = Counter(2);
    var greeting1 = Greeting();
    var greeting2 = Greeting();
    List<dynamic> list = [counter1, greeting1, counter2, greeting2];
    var index = list.indexOf(counter2);
    expect(2, index);
    expect(3, list.indexOf(greeting2));
  });

  test('use a map', () {
    var counter1 = Counter(1);
    var counter2 = Counter(2);
    var greeting1 = Greeting();
    var greeting2 = Greeting();
    Map<dynamic, int> list = {
      counter1: 0,
      greeting1: 1,
      counter2: 2,
      greeting2: 3
    };
    expect(2, list[counter2]);
    expect(3, list[greeting2]);
  });
}
