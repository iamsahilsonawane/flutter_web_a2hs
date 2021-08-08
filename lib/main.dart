import 'package:shared_preferences/shared_preferences.dart';
import "package:universal_html/js.dart" as js;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PWA Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'PWA Counter App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        final _prefs = await SharedPreferences.getInstance();
        final _isWebDialogShownKey = "is-web-dialog-shown";
        final _isWebDialogShown = _prefs.getBool(_isWebDialogShownKey) ?? false;
        if (!_isWebDialogShown) {
          final bool isDeferredNotNull =
              js.context.callMethod("isDeferredNotNull") as bool;

          if (isDeferredNotNull) {
            debugPrint(">>> Add to HomeScreen prompt is ready.");
            await showAddHomePageDialog(context);
            _prefs.setBool(_isWebDialogShownKey, true);
          } else {
            debugPrint(">>> Add to HomeScreen prompt is not ready yet.");
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

Future<bool?> showAddHomePageDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Icon(
                Icons.add_circle,
                size: 70,
                color: Theme.of(context).primaryColor,
              )),
              SizedBox(height: 20.0),
              Text(
                'Add to Homepage',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20.0),
              Text(
                'Want to add this application to home screen?',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                  onPressed: () {
                    js.context.callMethod("presentAddToHome");
                    Navigator.pop(context, false);
                  },
                  child: Text("Yes!"))
            ],
          ),
        ),
      );
    },
  );
}
