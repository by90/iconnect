import 'provider.dart';
import 'counter.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: CounterBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final CounterBloc bloc = BlocProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: _getStreamChild(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bloc.incrementCounter();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _getStreamChild() {
    final CounterBloc bloc = BlocProvider.of<CounterBloc>(context);
    return StreamBuilder(
      initialData: 0,
      stream: bloc.counterStream,
      builder: (BuildContext context, snapshot) {
        return Center(
          child: Text(
            "Clicked ${snapshot.data} times!",
            style: const TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }
}
