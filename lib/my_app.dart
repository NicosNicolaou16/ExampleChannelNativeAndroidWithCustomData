import 'dart:convert';

import 'package:examplechannelnativeandroidwithcomplexdata/data/channel_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const String _channel_name = "complex_data_channel_name";
  static const String _method_name = "complex_data";
  ChannelDataModel _channelDataModel = ChannelDataModel();
  final _channelMethod = const MethodChannel(_channel_name);
  late Map<String, dynamic> _body;
  bool _isLoading = true;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    await Future.delayed(const Duration(milliseconds: 1000), () async {
      _channelDataModel = await ChannelDataModel.createTheDataModel();
      setState(() {
        _body = _createMapForNativeAndroid(_channelDataModel);
        _isLoading = false;
      });
    });
  }

  _sendDataToNativeAndroid() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 1000), () async {
      await _channelMethod
          .invokeMethod(_method_name, _body.toString())
          .then((value) async {
        await _parseDataFromNativeAndroid(value);
      });
    });
  }

  Map<String, dynamic> _createMapForNativeAndroid(
      ChannelDataModel channelDataModel) {
    return {
      "id": _channelDataModel.id,
      "text": _channelDataModel.text,
      "sub_text": _channelDataModel.subText,
    };
  }

  _parseDataFromNativeAndroid(dynamic value) async {
    if (value != null) {
      Map<String, dynamic> bodyUpdated = jsonDecode(value);
      setState(() {
        _channelDataModel.id = bodyUpdated["id"];
        _channelDataModel.text = bodyUpdated["text"];
        _channelDataModel.subText = bodyUpdated["sub_text"];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Channel Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: 350,
                    child: Text(
                      "id: ${_channelDataModel.id ?? ""} text: ${_channelDataModel.text ?? ""} subText: ${_channelDataModel.subText ?? ""}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _sendDataToNativeAndroid();
                  },
                  child: const Text("Click Here"),
                )
              ],
            ),
            if (_isLoading) const Center(child: CircularProgressIndicator())
          ],
        ),
      ),
    );
  }
}
