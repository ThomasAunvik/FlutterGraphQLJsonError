import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'graphql/usergraph.dart';
import 'models/user.dart';

void main() async {
  final link = HttpLink("https://untitled-9uvfr8xkveg0.runkit.sh/graphql");
  await initHiveForFlutter(subDir: "test-hive");

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    ),
  );

  final app = GraphQLProvider(
    client: client,
    child: const MyApp(),
  );
  runApp(app);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Cached Result
            const Text("Cache Only"),
            SizedBox(
              width: 300,
              height: 100,
              child: Query<User>(
                options: QueryOptions(
                  fetchPolicy: FetchPolicy.cacheOnly,
                  document: gql(documentNodeUser),
                  parserFn: (data) {
                    return User.fromJson(data["user"]);
                  },
                ),
                builder: (result, {fetchMore, refetch}) {
                  final data = result.parsedData;
                  if (data == null) return const Text("Loading...");

                  return Text(
                      data.stats?.data?.distance.toString() ?? "No Data");
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Cache Only (Fix)"),
            SizedBox(
              width: 300,
              height: 100,
              child: Query<User>(
                options: QueryOptions(
                  fetchPolicy: FetchPolicy.networkOnly,
                  document: gql(documentNodeUser),
                  parserFn: (data) {
                    final stringJson = jsonEncode(data);
                    final newJson = jsonDecode(stringJson);
                    return User.fromJson(newJson["user"]);
                  },
                ),
                builder: (result, {fetchMore, refetch}) {
                  final data = result.parsedData;
                  if (data == null) return const Text("Loading...");

                  return Text(
                      data.stats?.data?.distance.toString() ?? "No Data");
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Cache And Network"),
            SizedBox(
              width: 300,
              height: 100,
              child: Query<User>(
                options: QueryOptions(
                  fetchPolicy: FetchPolicy.cacheAndNetwork,
                  document: gql(documentNodeUser),
                  parserFn: (data) {
                    return User.fromJson(data["user"]);
                  },
                ),
                builder: (result, {fetchMore, refetch}) {
                  final data = result.parsedData;
                  if (data == null) return const Text("Loading...");

                  return Text(
                      data.stats?.data?.distance.toString() ?? "No Data");
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Cache And Network (Fix)"),
            SizedBox(
              width: 300,
              height: 100,
              child: Query<User>(
                options: QueryOptions(
                  fetchPolicy: FetchPolicy.cacheAndNetwork,
                  document: gql(documentNodeUser),
                  parserFn: (data) {
                    final stringJson = jsonEncode(data);
                    final newJson = jsonDecode(stringJson);
                    return User.fromJson(newJson["user"]);
                  },
                ),
                builder: (result, {fetchMore, refetch}) {
                  final data = result.parsedData;
                  if (data == null) return const Text("Loading...");

                  return Text(
                      data.stats?.data?.distance.toString() ?? "No Data");
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Network Only"),
            SizedBox(
              width: 300,
              height: 100,
              child: Query<User>(
                options: QueryOptions(
                  fetchPolicy: FetchPolicy.networkOnly,
                  document: gql(documentNodeUser),
                  parserFn: (data) {
                    return User.fromJson(data["user"]);
                  },
                ),
                builder: (result, {fetchMore, refetch}) {
                  final data = result.parsedData;
                  if (data == null) return const Text("Loading...");

                  return Text(
                      data.stats?.data?.distance.toString() ?? "No Data");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
