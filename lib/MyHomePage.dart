
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:websocket_universal/websocket_universal.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String ip = "";
  Future<void> _incrementCounter() async {

      try {
        var url  = "192.168.0."+ip;
        var pricetopay="100";
        final wsUrl = Uri.parse("ws://" + url + ":5000");
        //final wsUrl = Uri.parse("wss://ws-feed.pro.coinbase.com");
       // if (kIsWeb) {
        // channel = WebSocketChannel.connect(Uri.parse("ws://$url:5000"));
       /* } else {
         WebSocket.connect("ws://$url:5000").then((ws) {
            channel = IOWebSocketChannel(ws);

         });*/
       // }

        /// 1. Create webSocket handler:
        final textSocketHandler = IWebSocketHandler<String, String>.createClient(
          'ws://$url:5000', // Postman echo ws server
          SocketSimpleTextProcessor(),
        );

        /// 2. Listen to webSocket messages:
        textSocketHandler.incomingMessagesStream.listen((inMsg) {
          print('> webSocket  got text message from server: "$inMsg" '
              '[ping: ${textSocketHandler.pingDelayMs}]');
        });
        textSocketHandler.outgoingMessagesStream.listen((inMsg) {
          print('> webSocket sent text message to   server: "$inMsg" '
              '[ping: ${textSocketHandler.pingDelayMs}]');
        });

        /// 3. Connect & send message:
        await textSocketHandler.connect();
        textSocketHandler.sendMessage(jsonEncode({
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
        await Future<void>.delayed(const Duration(seconds: 4));

        // 4. Disconnect & close connection:
        await textSocketHandler.disconnect('manual disconnect');
        textSocketHandler.close();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connecting...'+"ws://" + url + ":5000")),
        );
       // await channel.ready;

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
      floatingActionButton: Padding(
        padding: EdgeInsets.all(40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed:() {

              },
              tooltip: 'Try TCP connection',
              child: const Icon(Icons.refresh),
            ),
            FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Connect',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/*
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tesock/MyHomePage2.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String ip = "";
  Future<void> _incrementCounter() async {

      try {
        var url  = "192.168.0."+ip;
        var pricetopay="100";
        final wsUrl = Uri.parse("ws://" + url + ":5000");
        //final wsUrl = Uri.parse("wss://ws-feed.pro.coinbase.com");
        IOWebSocketChannel? channel;
        if (kIsWeb) {
    //      channel = WebSocketChannel.connect(Uri.parse("ws://$url:5000"));
        } else {
         WebSocket.connect("ws://$url:5000").then((ws) {
            channel = IOWebSocketChannel(ws);

         });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connecting...'+"ws://" + url + ":5000")),
        );
        await channel?.ready;

        channel?.sink.add(jsonEncode({
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
        channel?.stream.listen((message) {
          log("WebSocketChannelWebSocketChannel" + message
            ..toString());

          var jsonn = jsonDecode(message);
          if (jsonn['STATE'] == "0"||jsonn['STATE'] == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                    message.toString(),
                    selectionColor: Colors.white,
                  ),
                  backgroundColor: Colors.red),
            );
          }
          channel?.sink.close();
        }, onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                  error.toString(),
                  selectionColor: Colors.white,
                ),
                backgroundColor: Colors.red),
          );
          channel?.sink.close();
        });
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
      floatingActionButton: Padding(
        padding: EdgeInsets.all(40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed:() {
                Navigator.push(context, MaterialPageRoute(builder:(context) {
                  return  MyHomePage2(title: "TCP Test");

                },));
              },
              tooltip: 'Try TCP connection',
              child: const Icon(Icons.refresh),
            ),
            FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Connect',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}*/