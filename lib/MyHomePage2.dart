
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage2> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage2> {
  int _counter = 0;
  String ip = "";
   late var  contex;
  void   getMessages(message) {
    log("WebSocketChannelWebSocketChannel$message");
    var jsonn = jsonDecode(message);
    if (jsonn['STATE'] == "0" || jsonn['STATE'] == 0) {
      ScaffoldMessenger.of(contex).showSnackBar(
        SnackBar(
            content: Text(
              message.toString(),
              selectionColor: Colors.white,
            ),
            backgroundColor: Colors.green),
      );

      //channel.sink.close();
    }
    else {
      ScaffoldMessenger.of(contex).showSnackBar(
        SnackBar(
            content: Text(
              message.toString(),
              selectionColor: Colors.white,
            ),
            backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _incrementCounter() async {

    try {
      var url  = "192.168.1."+ip;
      var pricetopay="100";
      final wsUrl = Uri.parse("ws://" + url + ":5000");
      TcpSocketConnection socketConnection=TcpSocketConnection(url, 5000);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connecting...'+"ws://" + url + ":5000")),
      );
      socketConnection.enableConsolePrint(true);    //use this to see in the console what's happening
      if(await socketConnection.canConnect(5000, attempts: 3)) { //check if it's possible to connect to the endpoint
        await socketConnection.connect(5000, getMessages, attempts: 3,);
        socketConnection.sendMessage(jsonEncode({
          "TRAN_MODE": "1",
          "TRAN_CODE": "1",
          "AMOUNT": pricetopay,
          "TIP_ENTRY": "0",
          "SIGNATURE": "1",
          "PAPER_RECEIPT": "1",
          "MOBILE_ENTRY": "0",
          "MOBILE_NUMBER": "1234567890",
          "VAS_LABEL1": "INVOICE_NO",
          "VAS_DATA1": "12345",
          "VAS_LABEL2": "SERIAL_NO",
          "VAS_DATA2": "987654321"
        }));
      }
    } catch (e) {
      ///  log("WebSocketChannelWebSocketChannel${(e as SocketException).osError}");
      log("WebSocketChannelWebSocketChannel$e");
      log("WebSocketChannelWebSocketChannel-  ${e.runtimeType}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              e.toString(),
              selectionColor: Colors.white,
            ),
            backgroundColor: Colors.red),
      );
    }


    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  @override
  Widget build(BuildContext context) {
    contex=context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 40),
              child: TextField(
                decoration: InputDecoration(
                  border:OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  labelText: '192.168.0.',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    ip = value;
                  });
                },
              ),
            ),

            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Connect',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
