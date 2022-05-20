// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'ast.dart';
import 'async_transforms.dart';
import 'block_syntaxes/block_syntax.dart';
import 'extension_set.dart';
import 'html_renderer.dart';
import 'inline_syntaxes/inline_syntax.dart';

/// Converts the given string of Markdown to HTML.
Future<String> markdownToHtmlWithAsyncTransforms(
  String markdown, {
  Iterable<BlockSyntax> blockSyntaxes = const [],
  Iterable<InlineSyntax> inlineSyntaxes = const [],
  ExtensionSet? extensionSet,
  Resolver? linkResolver,
  Resolver? imageLinkResolver,
  bool encodeHtml = true,
  bool withDefaultBlockSyntaxes = true,
  bool withDefaultInlineSyntaxes = true,
}) async {
  final asyncDocument = AsyncDocument(
    blockSyntaxes: blockSyntaxes,
    inlineSyntaxes: inlineSyntaxes,
    extensionSet: extensionSet,
    linkResolver: linkResolver,
    imageLinkResolver: imageLinkResolver,
    encodeHtml: encodeHtml,
    withDefaultBlockSyntaxes: withDefaultBlockSyntaxes,
    withDefaultInlineSyntaxes: withDefaultInlineSyntaxes,
  );

  // Replace windows line endings with unix line endings, and split.
  final lines = markdown.replaceAll('\r\n', '\n').split('\n');

  final nodes = asyncDocument.parseLines(lines);

  await asyncDocument.waitForCompletion();

  return '${renderToHtml(nodes)}\n';
}