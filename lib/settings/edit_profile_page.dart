import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'settings.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruas_connect/models/models.dart';
import 'package:ruas_connect/authentication_bloc/bloc.dart';

class EditProfilePage extends StatelessWidget {
  final String uid;
  final String email;

  final UserDetails currentUser;

  const EditProfilePage(
      {Key key, @required String uid, @required String email, this.currentUser})
      : assert(uid != null, email != null),
        this.uid = uid,
        this.email = email,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: EditProfileForm(
        uid: uid,
        email: email,
        currentUser: currentUser,
      ),
    );
  }
}

class EditProfileForm extends StatefulWidget {
  final String uid, email;
  final UserDetails currentUser;

  final List<String> semesterOptions =
      List<String>.generate(8, (year) => 'SEMESTER_0${year + 1}');
  final List<String> branchOptions = ['CSE', 'ASE', 'EEE', 'CE', 'ME'];

  EditProfileForm({Key key, this.uid, this.email, this.currentUser})
      : super(key: key);

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  SettingsBloc _settingsBloc;

  String branchSelected;
  String semesterSelected;
  TextEditingController _usernameController;

  bool get isPopulated =>
      _usernameController.text.isNotEmpty &&
      branchSelected.isNotEmpty &&
      semesterSelected.isNotEmpty;

  bool isSaveButtonEnabled(SettingsFormState state) {
    return isPopulated && state.isFormValid && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    if (widget.currentUser == null) {
      branchSelected = 'CSE';
      semesterSelected = 'SEMESTER_01';

      _usernameController = TextEditingController.fromValue(
        TextEditingValue(text: 'anon.user'),
      );
    } else {
      branchSelected = widget.currentUser.branch;
      semesterSelected = widget.currentUser.semester;

      _usernameController = TextEditingController.fromValue(
        TextEditingValue(text: widget.currentUser.userName),
      );
    }

    _usernameController.addListener(_onUsernameChanged);
  }

  void _onUsernameChanged() {
    _settingsBloc.dispatch(
      UsernameChanged(
        username: _usernameController.text,
      ),
    );
  }

  void _onFormSubmitted() {
    _settingsBloc.dispatch(SaveProfileData(
        userDetails: UserDetails(
      uid: widget.uid,
      email: widget.email,
      branch: branchSelected,
      semester: semesterSelected,
      userName: _usernameController.text,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _settingsBloc,
      listener: (BuildContext context, SettingsState state) {
        if (state is SettingsFormSaveError) {
          /// Create a New Window With the displayed Error
        }
        if (state is SettingsFormState) {
          if (state.isSubmitting) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Updating, please wait ...'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
          if (state.isSuccess) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Updated Successfully !'),
                      Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              );
            BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
          }
          if (state.isFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Registration Failure'),
                      Icon(Icons.error),
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }
        }
      },
      child: BlocBuilder(
          bloc: _settingsBloc,
          builder: (BuildContext context, SettingsState state) {
            return Container(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Image.asset('assets/kitty.png'),
                      ),
                      backgroundColor: Colors.blueGrey,
                      radius: 110.0,
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.only(top: 15),
                        children: <Widget>[
                          TextFormField(
                            controller: _usernameController,
                            maxLength: 25,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              icon: Icon(Icons.title),
                              labelText: 'Username',
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                icon: Icon(Icons.streetview),
                                labelText: 'Branch'),
                            value: branchSelected,
                            items: widget.branchOptions
                                .map((label) => DropdownMenuItem(
                                      child: Text(label),
                                      value: label,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() => branchSelected = value);
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                icon: Icon(Icons.assignment),
                                labelText: 'Semester'),
                            value: semesterSelected,
                            items: widget.semesterOptions
                                .map(
                                  (label) => DropdownMenuItem(
                                        child: Text(label),
                                        value: label,
                                      ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() => semesterSelected = value);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80.0, vertical: 30.0),
                            child: RaisedButton.icon(
                              onPressed: isSaveButtonEnabled(state)
                                  ? _onFormSubmitted
                                  : null,
                              icon: Icon(Icons.save),
                              label: Text('Save'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
