import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ruas_connect/notes/notes.dart';
import 'package:ruas_connect/repository/respository.dart';
import 'package:ruas_connect/upload/upload.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ruas_connect/assignments/assignments.dart';
import 'package:ruas_connect/questions/questions.dart';
import 'screens/screens.dart';

class CourseArena extends StatefulWidget {
  final String courseCode;

  const CourseArena({Key key, this.courseCode}) : super(key: key);

  @override
  _CourseArenaState createState() => _CourseArenaState();
}

class _CourseArenaState extends State<CourseArena> {
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  int _selectedIndex = 0;

  final bottomNavbarItems = [
    BottomNavyBarItem(
        icon: Icon(Icons.library_books),
        title: Text('Notes'),
        activeColor: Colors.deepOrange),
    BottomNavyBarItem(
        icon: Icon(Icons.inbox),
        title: Text('Questions'),
        activeColor: Colors.limeAccent),
    BottomNavyBarItem(
        icon: Icon(Icons.error_outline),
        title: Text('Assignments'),
        activeColor: Colors.blue),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      width: 2.0,
                      color: Colors.white30,
                    ),
                  ),
                ),
                child: Image.asset('assets/cat.png'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(widget.courseCode),
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
//        onPageChanged: onPageChanged,
        children: <Widget>[
          ArenaScreen(
            courseCode: widget.courseCode,
            arenaName: 'notes',
          ),
          ArenaScreen(
            courseCode: widget.courseCode,
            arenaName: 'questions',
          ),
          ArenaScreen(
            courseCode: widget.courseCode,
            arenaName: 'assignments',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          });
        },
        items: bottomNavbarItems,
      ),
      floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton(
          onPressed: () async {
            try {
              final filePath = await FilePicker.getFilePath(
                  type: FileType.CUSTOM, fileExtension: 'pdf');

              if (filePath == null) {
                throw Exception(['Please Select a File']);
              }

              String arenaName = '';

              switch (_selectedIndex) {
                case 0:
                  arenaName = 'notes';
                  break;
                case 1:
                  arenaName = 'questions';
                  break;
                case 2:
                  arenaName = 'assignments';
                  break;
              }

              final isUploadSuccessful = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UploadScreen(
                      filePath: filePath,
                      arenaName: arenaName,
                      courseCode: widget.courseCode),
                ),
              );

              if (isUploadSuccessful) {
                ///Refresh the page
              }
            } catch (_) {
              print(_);
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Error Selecting File : {$_}'),
                        Icon(
                          Icons.warning,
                          color: Colors.redAccent,
                        )
                      ],
                    ),
                  ),
                );
            }
          },
          child: Icon(Icons.file_upload),
          backgroundColor: Colors.white30,
          foregroundColor: Colors.white,
        );
      }),
    );
  }
}

class InnerPage extends StatelessWidget {
  final Color color;

  const InnerPage({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text('UNDER DEVELOPEMENT'),
      ),
    );
  }
}
