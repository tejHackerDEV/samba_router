import 'dart:convert';

import 'package:samba_helpers/samba_helpers.dart';
import 'package:samba_router/src/extensions/iterable.dart';
import 'package:samba_router/src/extensions/string.dart';

import 'enum/node_type.dart';
import 'enum/parametric_node_type.dart';
import 'node.dart';
import 'result.dart';

class SambaRouter<T> {
  final Map<HttpMethod, Node<T>> _trees = {};

  void put({
    required HttpMethod method,
    required String path,
    required T value,
  }) {
    _trees[method] ??= Node<T>(pathSection: '/');
    Node<T> currentNode = _trees[method]!;

    final pathSections = path.decodePath().sections;
    for (int i = 0; i < pathSections.length; ++i) {
      final pathSection = pathSections[i];
      switch (pathSection.nodeType) {
        case NodeType.static:
          currentNode = currentNode.staticChildNodes[pathSection] ??= Node<T>(
            pathSection: pathSection,
            parentNode: currentNode,
          );
          break;
        case NodeType.parametric:
          switch (pathSection.parametricNodeType) {
            case ParametricNodeType.regExp:
              Node<T>? nodeInsertedAlready =
                  currentNode.regExpParametricChildNodes.firstWhereOrNull(
                (parametricChild) => parametricChild.pathSection == pathSection,
              );
              if (nodeInsertedAlready == null) {
                // node in not inserted already. So insert new node
                final nodeToInsert = Node<T>(
                  pathSection: pathSection,
                  parentNode: currentNode,
                );
                currentNode.regExpParametricChildNodes.add(nodeToInsert);
                nodeInsertedAlready = nodeToInsert;
              }
              currentNode = nodeInsertedAlready;
              break;
            case ParametricNodeType.nonRegExp:
              if (currentNode.nonRegExpParametricChild != null) {
                final pathSectionAlreadyPresent =
                    currentNode.nonRegExpParametricChild!.pathSection;
                if (pathSection != pathSectionAlreadyPresent) {
                  // pathSection that we want to insert is not equal to the
                  // pathSectionAlreadyPresento throw an error
                  throw AssertionError(
                    'Invalid pathSection detected. Found $pathSection instead of $pathSectionAlreadyPresent. This will happen if any route is already registered & startsWith ${pathSections.take(i).join('/')}/$pathSectionAlreadyPresent',
                  );
                }
              }
              currentNode = currentNode.nonRegExpParametricChild ??= Node<T>(
                pathSection: pathSection,
                parentNode: currentNode,
              );
              break;
          }
          break;
        case NodeType.wildcard:
          currentNode = currentNode.wildcardNode ??= Node<T>(
            pathSection: pathSection,
            parentNode: currentNode,
          );

          if (!pathSections.isLastIteration(i)) {
            // if currentNode is wildcard node, then there shouldn't
            // be any other sections after the path
            throw AssertionError(
              'Wildcard should be the last section of the $path',
            );
          }
          break;
      }
    }
    if (currentNode.value != null) {
      throw AssertionError('$path is already registered for $method');
    }
    currentNode.value = value;
  }

  Result<T> lookup({
    required HttpMethod method,
    required String path,
  }) {
    Node<T>? currentNode = _trees[method];
    if (currentNode == null) {
      return Result(
        value: null,
        pathParameters: {},
        queryParameters: {},
        child: null,
      );
    }

    final decodedPath = path.decodePath();
    final pathParameters = <String, String>{};
    final queryParameters = decodedPath.queryString?.extractQueryParameters(
          encoding: utf8,
        ) ??
        {};

    return Result(
      value: currentNode.value,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      // if pathSections are empty don't try lookup simply return null
      // else lookup through the pathSection & return as child
      child: decodedPath.sections.isEmpty
          ? null
          : _lookup(
              pathSections: decodedPath.sections,
              currentNode: currentNode,
              pathParameters: Map.from(pathParameters),
              queryParameters: queryParameters,
            ),
    );
  }

  Result<T>? _lookup({
    required Iterable<String> pathSections,
    required Node<T> currentNode,
    required Map<String, String> pathParameters,
    required Map<String, dynamic> queryParameters,
  }) {
    final pathSection = pathSections.first;
    Node<T>? tempNode = currentNode.staticChildNodes[pathSection];
    if (tempNode != null) {
      return Result(
        value: tempNode.value,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        // if pathSections contains only oneElement
        // then don't try lookup simply return child as null
        // else lookup through the pathSection
        child: pathSections.containsOnlyOneElement
            ? null
            : _lookup(
                pathSections: pathSections.skip(1),
                currentNode: tempNode,
                pathParameters: Map.from(pathParameters),
                queryParameters: queryParameters,
              ),
      );
    }

    // not found in static route so look in parametricChildNodes
    // at first look in regExpParametricChildNodes
    for (int j = 0; j < currentNode.regExpParametricChildNodes.length; ++j) {
      tempNode = currentNode.regExpParametricChildNodes[j];
      // it is an regExp one so check regExp matches the pathSection
      if (!tempNode.parameterRegExp!.hasMatch(pathSection)) {
        // match not found so skip the iteration
        continue;
      }
      pathParameters[tempNode.parameterName] = pathSection;
      return Result(
        value: tempNode.value,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        // if pathSections contains only oneElement
        // then don't try lookup simply return child as null
        // else lookup through the pathSection
        child: pathSections.containsOnlyOneElement
            ? null
            : _lookup(
                pathSections: pathSections.skip(1),
                currentNode: tempNode,
                pathParameters: Map.from(pathParameters),
                queryParameters: queryParameters,
              ),
      );
    }

    // notFound in regExpParametricChildNode so look in nonExpParametricChild
    tempNode = currentNode.nonRegExpParametricChild;
    if (tempNode != null) {
      // it is an non-regexp so don't check anything
      pathParameters[tempNode.parameterName] = pathSection;
      return Result(
        value: tempNode.value,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        // if pathSections contains only oneElement
        // then don't try lookup simply return child as null
        // else lookup through the pathSection
        child: pathSections.containsOnlyOneElement
            ? null
            : _lookup(
                pathSections: pathSections.skip(1),
                currentNode: tempNode,
                pathParameters: Map.from(pathParameters),
                queryParameters: queryParameters,
              ),
      );
    }

    // route not found in parametricNodes so check for wildcardNode
    tempNode = currentNode.wildcardNode;
    if (tempNode != null) {
      // wildcardNode found so update the pathParameters
      // & return it
      pathParameters['*'] = pathSections.join('/');
      return Result(
        value: tempNode.value,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        child: null,
      );
    }
    return Result(
      value: null,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      child: null,
    );
  }

  void clear() {
    _trees.clear();
  }

  void combineWith(SambaRouter<T> other, {String? prefixPath}) {
    for (final entry in other._trees.entries) {
      final httpMethod = entry.key;
      Node<T> node = entry.value;
      _putNode(
        httpMethod,
        node,
        prefixPath: prefixPath,
      );
    }
  }

  void _putNode(
    HttpMethod httpMethod,
    Node<T> node, {
    String? prefixPath,
  }) {
    void put(HttpMethod httpMethod, Node<T> node) {
      Node<T> tempNode = node;

      List<String> pathSections = [];
      while (true) {
        // inserts tha pathSection at 0 position,
        // so that at last we will get correct pathSections
        // by joining with "/".
        pathSections.insert(0, tempNode.pathSection);
        if (tempNode.parentNode == null) {
          break;
        }
        tempNode = tempNode.parentNode!;
      }
      StringBuffer stringBuffer = StringBuffer();
      // if prefixPath is not null, then add it
      if (prefixPath != null) {
        stringBuffer.write(prefixPath);
        // if the last path is not "/" add it,
        // as below we willing be writing the pathSections
        if (prefixPath[prefixPath.length - 1] != '/') {
          stringBuffer.write('/');
        }
      } else {
        // as prefixPath is null simply add "/"
        stringBuffer.write('/');
      }
      // finally add the pathSections by "/"
      stringBuffer.writeAll(pathSections.skip(1), '/');
      this.put(
        method: httpMethod,
        path: stringBuffer.toString(),
        value: node.value as T,
      );
    }

    // nonParametricNode is not null, so insert it recusively
    if (node.nonRegExpParametricChild != null) {
      _putNode(
        httpMethod,
        node.nonRegExpParametricChild!,
        prefixPath: prefixPath,
      );
    }

    // insert each regExpParametricChildNode recusively
    for (final childNode in node.regExpParametricChildNodes) {
      _putNode(httpMethod, childNode, prefixPath: prefixPath);
    }

    // insert each staticChildNode recusively
    for (final entry in node.staticChildNodes.entries) {
      _putNode(httpMethod, entry.value, prefixPath: prefixPath);
    }

    // currentNode value is  not null, so insert it
    if (node.value != null) {
      put(httpMethod, node);
    }

    // wildcardNode value is not null, so insert it
    if (node.wildcardNode?.value != null) {
      put(httpMethod, node.wildcardNode!);
    }
  }

  @override
  String toString() {
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write('{');
    final treeEntries = _trees.entries;
    for (int i = 0; i < treeEntries.length; ++i) {
      final treeEntry = treeEntries.elementAt(i);
      stringBuffer.write('"${treeEntry.key}"');
      stringBuffer.write(': ');
      stringBuffer.write(treeEntry.value);
      if (i != treeEntries.length - 1) {
        stringBuffer.write(', ');
      }
    }
    stringBuffer.write('}');
    return stringBuffer.toString();
  }
}
