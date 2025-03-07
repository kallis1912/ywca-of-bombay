import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'user_event_details.dart';
import '../../widgets/blue_bubble_design.dart';
import '../../widgets/constants.dart';
import '../../models/User.dart';
import '../../drawers_constants/user_drawer.dart';
import '../../widgets/exit_popup.dart';

// ignore: must_be_immutable
class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final DrawerScaffoldController controller = DrawerScaffoldController();
  late int selectedMenuItemId;
  // Firebase auth for couting the onClick and Onregister count of event
  final FirebaseAuth auth = FirebaseAuth.instance;
  var userInfo;

  // conversion of event date for displaying
  String readEventDate(Timestamp eventDate) {
    DateTime newEventDate = eventDate.toDate();
    String formattedEventDate = DateFormat('dd-MM-yyyy').format(newEventDate);
    return formattedEventDate;
  }

  _openPopup(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Hey there, interested in being a member?'),
            content: Text(
                'For Membership details go to the About us page of the app or get in touch with your nearest YWCA now'),
            actions: <Widget>[
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK!',
                  ),
                ),
              ),
            ],
          );
        });
  }

  // onClick for counting number of clicks by the user
  void insertIntoOnClick(String eventID, String eventName) async {
    final User? user = auth.currentUser;
    final userID = user?.uid;
    FirebaseFirestore.instance
        .collection('eventClick')
        .where('eventID', isEqualTo: eventID)
        .where('userID', isEqualTo: userID)
        .get()
        .then((checkSnapshot) {
      if (checkSnapshot.size > 0) {
      } else {
        print("adding");
        FirebaseFirestore.instance
            .collection('eventClick')
            .add({'eventID': eventID, 'userID': userID});
      }
    });
  }

  @override
  void initState() {
    selectedMenuItemId = menuWithIcon.items[1].id;
    userInfo = Provider.of<UserData>(context, listen: false);
    if (userInfo.getmemberRole == "NonMember") {
      Timer(Duration(seconds: 3), () {
        _openPopup(context);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: DrawerScaffold(
        // appBar: AppBar(), // green app bar
        drawers: [
          SideDrawer(
            percentage: 0.75, // main screen height proportion
            headerView: header(context, userInfo),
            footerView: footer(context, controller, userInfo),
            color: successStoriesCardBgColor,
            selectorColor: Colors.indigo[600],
            menu: menuWithIcon,
            animation: true,
            // color: Theme.of(context).primaryColorLight,
            selectedItemId: selectedMenuItemId,
            onMenuItemSelected: (itemId) {
              setState(() {
                selectedMenuItemId = itemId;
                selectedItem(context, itemId);
              });
            },
          )
        ],
        controller: controller,
        builder: (context, id) => SafeArea(
          child: Center(
            child: Stack(
              children: <Widget>[
                EventPageBlueBubbleDesign(),
                Positioned(
                  child: AppBar(
                    centerTitle: true,
                    title: Text(
                      "YWCA Of Bombay",
                      style: TextStyle(
                        fontFamily: 'LobsterTwo',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black87,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () => {
                        controller.toggle(Direction.left),
                        // OR
                        // controller.open()
                      },
                    ),
                  ),
                ),
                // Events & Search bar Starts
                PreferredSize(
                  preferredSize: Size.fromHeight(80),
                  child: Column(
                    children: <Widget>[
                      // Distance from ywca
                      // or else it will overlap
                      SizedBox(height: 80),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyText2,
                          children: [
                            TextSpan(
                              text: 'Events ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.0,
                                ),
                                child: Icon(Icons.notification_important),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        decoration: InputDecoration(
                            hintText: "Search by venue",
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            suffixIcon: Icon(
                              Icons.mic,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.zero,
                            filled: true,
                            fillColor: Colors.transparent),
                      ),
                    ],
                  ),
                ),
                // card view for the events
                Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 160.0, 0.0, 0.0),
                    child: getHomePageBody(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getHomePageBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .orderBy('eventDate', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Text('Error: ${snapshot.error}' + 'something');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return ListView(
              padding: EdgeInsets.only(bottom: 80),
              children: snapshot.data!.docs.map(
                (DocumentSnapshot document) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 10,
                    ),
                    child: Card(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10.0)), //add border radius here
                          child: Image.network(
                            document['eventImageUrl'],
                            fit: BoxFit.cover,
                            width: 120,
                          ), //add image location here
                        ),
                        // Event date and time
                        title: Text(
                          'Date:' +
                              (readEventDate(document['eventDate'])) +
                              '| Time:' +
                              (document['eventTime']),
                          style: TextStyle(
                            color: Color(0xFF49DEE8),
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 5),
                            // Event name
                            Text(
                              document['eventName'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            // Event Resource Person
                            Text(
                              'Resource Person: Sharon Pies',
                              style: TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 5),
                            // Event Venue
                            Text(
                              'Venue: ' + document['eventVenue'],
                              style: TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 5),
                            // Event Amount
                            Text(
                              'Amount: ' + document['eventAmount'],
                              style: TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // when clicked on the event, the user id is saved
                          // and if the user clicks again it is checked with the db
                          // if it already exists it is not inserted again for the same event
                          insertIntoOnClick(document.id, document['eventName']);

                          // opening detail page for particular event
                          gotoDetailEvent(
                            context,
                            document.id,
                            document['eventAmount'],
                            document['eventDescription'],
                            document['eventName'],
                            document['eventImageUrl'],
                            document['eventVenue'],
                            document['eventType'],
                            document['eventDate'],
                            document['eventDeadline'],
                            document['eventTime'],
                          );
                        },
                      ),
                    ),
                  );
                },
              ).toList(),
            );
        }
      },
    );
  }

  gotoDetailEvent(
      BuildContext context,
      String id,
      String eventAmount,
      String eventDescription,
      String eventName,
      String eventImageUrl,
      String eventVenue,
      String eventType,
      Timestamp eventDate,
      Timestamp eventDeadline,
      String eventTime) {
    // TimeStamp to DateTime conversion of event date for displaying
    DateTime newEventDate = eventDate.toDate();

    // TimeStamp to DateTime conversion of event deadline for displaying
    DateTime newEventDeadline = eventDeadline.toDate();

    String memberRole = 'null';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          id: id,
          eventAmount: eventAmount,
          eventDescription: eventDescription,
          eventName: eventName,
          eventImageUrl: eventImageUrl,
          eventVenue: eventVenue,
          eventType: eventType,
          eventDate: newEventDate,
          eventDeadline: newEventDeadline,
          eventTime: eventTime,
          memberRole: memberRole,
        ),
      ),
    );
  }
}
