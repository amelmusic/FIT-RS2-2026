import 'dart:convert';

import 'package:ecommerce_desktop/models/message.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce_desktop/layouts/master_screen.dart';
import 'package:http/http.dart' as http;

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _chatController = TextEditingController();

  List<Message> messageList = [
    Message(role: "system", content: "You are helpful assistant"),
  ];

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "AI Assistent",
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messageList.length,
                itemBuilder: (context, index){
                  var message = messageList[index];
                  var role = message.role;

                  return role == "system" ? SizedBox() : Row(
                    mainAxisAlignment: role == "user" ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 500
                        ),
                        padding: EdgeInsets.all(10),
                        color: role == "user" ? Colors.blue : Colors.green,
                        child: Text(message.content ?? ""),
                      )
                    ],
                  );

                }),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(label: Text('Ask a question')),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    var url = "http://localhost:11434/api/chat";
                    var uri = Uri.parse(url);
                    var headers = {"Content-Type": " application/json"};

                    var userMessage = Message(
                      role: "user",
                      content: _chatController.text,
                    );

                    var request = {
                      "model": "llama3.2:1b ",
                      "messages": [
                        {"role": "user", "content": _chatController.text},
                      ],
                      "stream": false,
                    };

                    setState(() {
                      messageList.add(userMessage);
                    });

                    var jsonRequest = jsonEncode(request);
                    var response = await http.post(
                      uri,
                      headers: headers,
                      body: jsonRequest,
                    );

                    if (isValidResponse(response)) {
                      var data = jsonDecode(response.body);
                      var message = Message.fromJson(data['message']);

                      setState(() {
                        messageList.add(message);
                      });

                      _chatController.clear();

                      print(data);
                    } else {
                      throw new Exception("Unknown error");
                    }
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool isValidResponse(http.Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw new Exception("Unauthorized");
    } else {
      print(response.body);
      throw new Exception("Something bad happened please try again");
    }
  }
}
