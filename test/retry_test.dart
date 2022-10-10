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
      // final r = RetryOptions(
      //   maxAttempts: 5,
      // );
      final f = retry(() {
        count++;
        throw Exception('Retry will fail');
      }, retries: 5, retryIf: (e) => Future.value(false));

      //当出现未处理的异常时，这里可以不再断出？
      await expectLater(f, throwsA(isException));
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
