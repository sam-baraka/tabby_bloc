import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tabby_boc/blocs/counter_cubit.dart';
import 'package:tabby_boc/blocs/counter_cubit_hydrated.dart';
import 'package:tabby_boc/blocs/cubit/get_breeds_cubit.dart';
import 'package:tabby_boc/blocs/logged_in_cubit.dart';
import 'package:tabby_boc/blocs/name_cubit.dart';
import 'package:tabby_boc/models/tabby_login_response.dart';
import 'package:tabby_boc/page_2.dart';

void main() async {
// Initialize storages
  var tempDir = await getTemporaryDirectory();
  var storage = await HydratedStorage.build(storageDirectory: tempDir);
  HydratedBlocOverrides.runZoned(() => runApp(const MyApp()), storage: storage);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CounterCubit(0)),
        BlocProvider(create: (context) => CounterCubitHydrated(0)),
        BlocProvider(create: (context) => LoggedInCubit(TabbyLoginResponse())),
        BlocProvider(create: (context) => NameCubit('')),
        BlocProvider(create: (context) => GetBreedsCubit()..getCatBreeds()),
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.purple),
        home: const TabbyPage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabby Bloc'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.read<CounterCubitHydrated>().add();
        },
      ),
      body: BlocBuilder<CounterCubitHydrated, int>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Button pressed $state times',
                  style: const TextStyle(fontSize: 24),
                ),
                CupertinoButton(
                  color: Colors.purple,
                  onPressed: () {
                    context.read<NameCubit>().saveName('Tabby');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Page2()));
                  },
                  child: const Text('Go to text'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class TabbyPage extends StatelessWidget {
  const TabbyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          Text(context.watch<LoggedInCubit>().state.toString()),
          CupertinoButton(
              child: Text('Login'),
              onPressed: () {
                context.read<LoggedInCubit>().save(TabbyLoginResponse(
                      name: 'Tabby',
                      token: '123',
                      email: 'tabby@gmail.com',
                      password: '123',
                      id: '123',
                      createdAt: '123',
                      updatedAt: '123',
                    ));
              })
        ],
      ),
    ));
  }
}
