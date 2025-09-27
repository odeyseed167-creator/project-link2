import 'dart:async';
import 'dart:io' hide Link;
import 'package:linkcheck/linkcheck.dart';


import 'package:args/args.dart';
import 'package:console/console.dart';

import 'src/crawl.dart' show CrawlResult, crawl;
import 'src/parsers/url_skipper.dart';
import 'src/writer_report.dart' show reportForWriters;


export 'src/crawl.dart' show CrawlResult, crawl;
export 'src/destination.dart' show Destination;
export 'src/link.dart' show Link;
export 'src/origin.dart' show Origin;
export 'src/writer_report.dart' show reportForWriters;

const anchorFlag = 'check-anchors';
const ansiFlag = 'nice';
const connectionFailuresAsWarnings = 'connection-failures-as-warnings';
const debugFlag = 'debug';
const defaultUrl = 'http://localhost:8080/';
const externalFlag = 'external';
const helpFlag = 'help';
const hostsFlag = 'hosts';
const inputFlag = 'input-file';
const redirectFlag = 'show-redirects';
const skipFlag = 'skip-file';
const version = '3.1.0';
const versionFlag = 'version';
final _portOnlyRegExp = RegExp(r'^:\d+$');


