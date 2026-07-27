import 'package:flutter_test/flutter_test.dart';
import 'package:watch_atlas/core/extensions/string_extensions.dart';

void main() {
  group('StringExtensions.sanitizeUserInput', () {
    test('strips HTML tags', () {
      expect('<b>hello</b>'.sanitizeUserInput(), 'hello');
    });

    test('strips nested HTML tags', () {
      expect('<div><span class="x">text</span></div>'.sanitizeUserInput(), 'text');
    });

    test('collapses multiple spaces', () {
      expect('hello   world'.sanitizeUserInput(), 'hello world');
    });

    test('trims leading and trailing whitespace', () {
      expect('  hello  '.sanitizeUserInput(), 'hello');
    });

    test('handles empty string', () {
      expect(''.sanitizeUserInput(), '');
    });

    test('handles string with only HTML tags', () {
      expect('<br/><hr/>'.sanitizeUserInput(), '');
    });

    test('preserves plain text unchanged', () {
      expect('Normal text'.sanitizeUserInput(), 'Normal text');
    });

    test('strips script tags (content is inert in Flutter)', () {
      expect('<script>alert(1)</script>'.sanitizeUserInput(), 'alert(1)');
    });

    test('handles mixed content', () {
      expect('<p>Hello</p> <b>World</b>'.sanitizeUserInput(), 'Hello World');
    });

    test('strips self-closing tags', () {
      expect('line<br/>break'.sanitizeUserInput(), 'linebreak');
    });
  });
}
