import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dhttpd/dhttpd.dart';
import 'package:linkcheck/linkcheck.dart' show run;
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

// Get the directory of the script being run.
void main() {
  group('linkcheck e2e', () {
    late _MockStdout out;
    final port = 4321;

    setUp(() {
      out = _MockStdout();
    });

    tearDown(() {
      unawaited(out.close());
    });

    test('reports no errors or warnings for a site without issues', () async {
      final server = await Dhttpd.start(path: getServingPath(0), port: port);
      try {
        final result = await run([':$port'], out);
        expect(result, 0);
        expect(out.output, contains('0 warnings'));
        expect(out.output, contains('0 errors'));
      } finally {
        await server.destroy();
      }
    });

    test('reports no errors or warnings for a site with correct <base>',
        () async {
      final server = await Dhttpd.start(path: getServingPath(4), port: port);
      try {
        final result = await run([':$port'], out);
        expect(result, 0);
        expect(out.output, contains('0 warnings'));
        expect(out.output, contains('0 errors'));
      } finally {
        await server.destroy();
      }
    });

    test('reports info when link is behind robots.txt rule', () async {
      final server = await Dhttpd.start(path: getServingPath(5), port: port);
      try {
        final result = await run([':$port'], out);
        expect(result, 0);
        expect(out.output, contains('subdirectory/other.html'));
        expect(out.output, contains('0 warnings'));
        expect(out.output, contains('0 errors'));
      } finally {
        await server.destroy();
      }
    });

    test(
        'reports bad link in file that is disallowed in robots.txt '
        'but allowed for linkcheck', () async {
      final server = await Dhttpd.start(path: getServingPath(11), port: port);
      try {
        final result = await run([':$port'], out);
        expect(result, 2);
        expect(out.output, contains('non-existent.html'));
        expect(out.output, contains('1 error'));
      } finally {
        await server.destroy();
      }
    });

    group('reports exit code 2 for a site with errors', () {
      test('in CSS', () async {
        final server = await Dhttpd.start(path: getServingPath(1), port: port);
        try {
          final result = await run([':$port'], out);
          expect(result, 2);
          expect(out.output, contains('main.css'));
          expect(out.output, contains('1 error'));
        } finally {
          await server.destroy();
        }
      });

      test('in <link> import', () async {
        final server = await Dhttpd.start(path: getServingPath(2), port: port);
        try {
          final result = await run([':$port'], out);
          expect(result, 2);
          expect(out.output, contains('nonexistent.css'));
          expect(out.output, contains('1 error'));
        } finally {
          await server.destroy();
        }
      });

      test('in <a> to non-existent internal page', () async {
        final server = await Dhttpd.start(path: getServingPath(3), port: port);
        try {
          final result = await run([':$port'], out);
          expect(result, 2);
          expect(out.output, contains('other.html'));
          expect(out.output, contains('nonexistent.html'));
          expect(out.output, contains('1 error'));
        } finally {
          await server.destroy();
        }
      });
    });

    test('reports all missing @font-face sources', () async {
      final server = await Dhttpd.start(path: getServingPath(6), port: port);
      try {
        final result = await run([':$port'], out);
        expect(result, 2);
        expect(out.output, contains('asset1.eot'));
        expect(out.output, contains('asset2.ttf'));
        expect(out.output, contains('asset3.woff'));
        expect(out.output, contains('asset4.svg'));
      } finally {
        await server.destroy();
      }
    });

    test('allows non-Base64-encoded SVG inline', () async {
      final server = await Dhttpd.start(path: getServingPath(7), port: port);
      try {
        final result = await run([':$port'], out);
        expect(result, 0);
        expect(out.output, contains('0 warnings'));
        expect(out.output, contains('0 errors'));
      } finally {
        await server.destroy();
      }
    });

    test('skips URLs according to their resolved URL with fragment', () async {
      final server = await Dhttpd.start(path: getServingPath(8), port: port);
      try {
        final result = await run(
            [':$port', '--skip-file', 'test/case8/skip-file.txt'], out);
        expect(result, 0);
        expect(out.output, contains('0 warnings'));
        expect(out.output, contains('0 errors'));
      } finally {
        await server.destroy();
      }
    });

    test('skips external URLs according to their resolved URL with fragment',
        () async {
      final server = await Dhttpd.start(path: getServingPath(12), port: port);
      try {
        final result = await run(
            [':$port', '-e', '--skip-file', 'test/case12/skip-file.txt'], out);
        expect(result, 0);
        expect(out.output, contains('0 warnings'));
        expect(out.output, contains('0 errors'));
      } finally {
        await server.destroy();
      }
    });

    test('works with unicode in title', () async {
      final server = await Dhttpd.start(path: getServingPath(9), port: port);
      try {
        final result = await run([':$port'], out);
        expect(result, 0);
      } finally {
        await server.destroy();
      }
    });

    test('anchors are normalized', () async {
      final server = await Dhttpd.start(path: getServingPath(10), port: port);
      try {
        final result = await run([':$port'], out);
        expect(result, 0);
      } finally {
        await server.destroy();
      }
    });

    test('fragment checking works with non-percent-encoded anchors', () async {
      final server = await Dhttpd.start(path: getServingPath(13), port: port);
      try {
        final result = await run([':$port'], out);
        expect(result, 0);
      } finally {
        await server.destroy();
      }
    });

    test("destinations with wrong mime-types aren't checked", () async {
      final server = await Dhttpd.start(path: getServingPath(14), port: port);
      try {
        final result = await run([':$port'], out);
        expect(result, 0);
      } finally {
        await server.destroy();
      }
    });
  }, tags: ['integration']);
}

