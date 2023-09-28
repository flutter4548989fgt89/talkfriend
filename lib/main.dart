import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final messageController = TextEditingController();
  List<Map> messages = new List();

  void response(query) async {
    AuthGoogle authGoogle = await AuthGoogle(
      fileJson: 'assets/chatbot.json',
    ).build();

    Dialogflow dialogflow = Dialogflow(
      authGoogle: authGoogle,
      language: Language.english,
    );
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messages.insert(
        0,
        {
          "data": 0,
          "messages":
          aiResponse.getListMessage()[0]["text"]["text"][0].toString(),
        },
      );
    });
    print(aiResponse.getListMessage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'chatbot',
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Text(
                  "Today,${DateFormat('Hm').format(DateTime.now())}",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                reverse: true,
                itemCount: 0,
                itemBuilder: (context, index) => chat(
                  messages[index]["message"].toString(),
                  messages[index]["data"],
                ),
              ),
            ),
            Divider(
              height: 5,
              color: Colors.redAccentt,
            ),
            Container(
              child: ListTile(
                leading: IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.redAccent,
                      size: 35,
                    ),
                    onPressed: null),
                title: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: Color.fromRGBO(220, 220, 220, 1),
                  ),
                  padding: EdgeInsets.only(
                    left: 15,
                  ),
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Enter a Message",
                      hintStyle: TextStyle(
                        color: Colors.black38,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 30,
                      color: Colors.whitet,
                    ),
                    onPressed: () {
                      if (messageController.text.isEmpty) {
                        print("empty message");
                      } else {
                        setState(() {
                          messages.insert(0,
                              {"data": 1, "message": messageController.text});
                        });
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chat(String message, int data) {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment:
          data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            data == 0
                ? Container(
              height: 60,
              width: 60,
              child: CircleAvatar(
                backgroundImage: NetworkImage('https://techendo.com/upload/000/u3/c/a/botfrog-photo-normal.png'),
                ),
              ),
            )
                : Container(),
            Padding(
              padding: EdgeInsets.all(10),
              child: Bubble(
                radius: Radius.circular(15),
                color: data == 0
                    ? Color.fromRGBO(23, 157, 139, 1)
                    : Colors.redAccent,
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 200),
                          child: Text(
                            message,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            data == 1
                ? Container(
              height: 60,
              width: 60,
              child: CircleAvatar(
                backgroundImage: NetworkImage('https://niramayam.com/wp-content/uploads/2023/03/worker.png'),
              ),
            )
                : Container(),
          ],
        );
  }
}