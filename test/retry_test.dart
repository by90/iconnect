// Copyright 2018 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import 'package:flutter_test/flutter_test.dart';
import 'package:iconnect/src/retry.dart';

void main() {
  group('retry test', () {
    test('retry (success)', () async {
      var count = 0;
      //final r = RetryOptions();
      final f = retry(() async {
        count++;
        return true;
      });
      expect(f, completion(isTrue));
      expect(count, equals(1));
    });

    test('retry (unhandled exception)', () async {
      var count = 0;
      var f;
      try {
        f = retry(() {
          count++;
          throw Exception('Retry will fail');
        }, retries: 5, retryIf: (e) => Future.value(false));
      } catch (e) {
        print('throw ${e.toString()}');
      }

      //异常用future.error返回，而非rethrow，然后下一句就相当于捕获了，debug不会断掉。
      //这可能导致futureBuilder同样捕获错误。
      await expectLater(
          f,
          throwsA(
              isException)); //如果注释掉，debug会断掉。即使不注释这句，若前面是throw而非future.error，也会断掉。
      expect(count, equals(1));
    });

    test('retry (retryIf, exhaust retries)', () async {
      var count = 0;

      final f = retry(() {
        count++;
        throw FormatException('Retry will fail');
      }, retries: 5, retryIf: (e) => e is FormatException);
      await expectLater(f, throwsA(isFormatException));
      expect(count, equals(5));
    });

    test('retry (success after 2)', () async {
      var count = 0;
      final f = retry(() {
        count++;
        if (count == 1) {
          throw FormatException('Retry will be okay');
        }
        return Future<bool>.value(true);
      }, retryIf: (e) => e is FormatException);
      await expectLater(f, completion(isTrue));
      expect(count, equals(2));
    });

    test('retry (no retryIf)', () async {
      var count = 0;

      final f = retry(() {
        count++;
        if (count == 1) {
          throw FormatException('Retry will be okay');
        }
        return Future<void>.value(true);
      }, retries: 5);
      await expectLater(f, completion(isTrue));
      expect(count, equals(2));
    });

    test('retry (unhandled on 2nd try)', () async {
      var count = 0;
      final f = retry(() {
        count++;
        if (count == 1) {
          throw FormatException('Retry will be okay');
        }
        throw Exception('unhandled thing');
      }, retries: 5, retryIf: (e) => e is FormatException);
      await expectLater(f, throwsA(isException));
      expect(count, equals(2));
    });
  });
}
