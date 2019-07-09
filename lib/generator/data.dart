import 'package:graphql_parser/graphql_parser.dart';
import 'package:artemis/schema/graphql.dart';

typedef void OnBuildQuery(QueryDefinition definition);

typedef void OnNewClassFoundCallback(
  SelectionSetContext selectionSet,
  String className,
  GraphQLType parentType,
);

class ClassProperty {
  final String type;
  final String name;
  final bool override;
  final String annotation;

  ClassProperty(this.type, this.name, {this.override = false, this.annotation});

  ClassProperty copyWith({type, name, override, annotation}) =>
      ClassProperty(type ?? this.type, name ?? this.name,
          override: override ?? this.override,
          annotation: annotation ?? this.annotation);
}

class QueryInput {
  final String type;
  final String name;

  QueryInput(this.type, this.name)
      : assert(
            type != null && type.isNotEmpty, 'Type can\'t be null nor empty.'),
        assert(
            name != null && name.isNotEmpty, 'Name can\'t be null nor empty.');
}

abstract class Definition {
  final String name;

  Definition(this.name)
      : assert(
            name != null && name.isNotEmpty, 'Name can\'t be null nor empty.');
}

class ClassDefinition extends Definition {
  final Iterable<ClassProperty> properties;
  final String mixins;
  final Iterable<String> factoryPossibilities;
  final String resolveTypeField;

  ClassDefinition(
    String name,
    this.properties, {
    this.mixins = '',
    this.factoryPossibilities = const [],
    resolveTypeField,
  })  : assert(
            factoryPossibilities == null ||
                factoryPossibilities.isEmpty ||
                resolveTypeField != null,
            'To use a custom factory, include resolveType.'),
        this.resolveTypeField = resolveTypeField,
        super(name);
}

class EnumDefinition extends Definition {
  final Iterable<String> values;

  EnumDefinition(
    String name,
    this.values,
  )   : assert(values != null && values.isNotEmpty,
            'An enum must have at least one possible value.'),
        super(name);
}

class QueryDefinition {
  final String queryName;
  final String query;
  final String basename;
  final Iterable<Definition> classes;
  final Iterable<QueryInput> inputs;
  final String customParserImport;
  final bool generateHelpers;

  QueryDefinition(
    this.queryName,
    this.query,
    this.basename, {
    this.classes = const [],
    this.inputs = const [],
    this.customParserImport,
    this.generateHelpers = false,
  })  : assert(queryName != null && queryName.isNotEmpty,
            'Query name must not be null or empty.'),
        assert(query != null && query.isNotEmpty,
            'Query must not be null or empty.'),
        assert(basename != null && basename.isNotEmpty,
            'Basename must not be null or empty.');
}