import 'package:flutter/material.dart';
import 'package:ztsparking/authentication/login/bloc/login_bloc.dart';
import 'package:ztsparking/authentication/login/widgets/button.dart';
import 'package:ztsparking/authentication/login/widgets/text_field.dart';
import 'package:ztsparking/utils/shared_pref.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController baseUrlController = TextEditingController();
  FocusNode baseUrlFocus = FocusNode();
  TextEditingController ticketNumController = TextEditingController();
  FocusNode tickNumFocus = FocusNode();

  @override
  void initState() {
    baseUrlController.text = sharedPrefs.getbaseUrl;
    ticketNumController.text = sharedPrefs.getTicketCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc? loginBloc = LoginProvider.of(context);
    loginBloc!.changebaseUrl(baseUrlController.text);
    loginBloc.changeticketCode(ticketNumController.text);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.green),
          title: Text("Settings",
              style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 20)),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              //base url
              baseUrl(loginBloc),

              ticketNumberCode(loginBloc),
              saveButton(loginBloc)
            ],
          ),
        ));
  }

  Widget baseUrl(LoginBloc? loginBloc) {
    return Container(
      child: Column(
        children: [
          ZTSTextField(
            width: 400,
            controller: baseUrlController,
            focusNode: baseUrlFocus,
            icon: Icons.email,
            labelText: 'Base Url',
            onChanged: (String value) {
              loginBloc!.changebaseUrl(value);
            },
            onfocus: baseUrlFocus.hasFocus,
            onTap: () {
              setState(() {});
            },
            stream: loginBloc!.baseUrl,
            heading: 'Base Url',
          ),
        ],
      ),
    );
  }

  Widget ticketNumberCode(LoginBloc? loginBloc) {
    return Container(
      child: Column(
        children: [
          ZTSTextField(
            width: 400,
            controller: ticketNumController,
            focusNode: tickNumFocus,
            icon: Icons.email,
            labelText: 'Ticket Number Code',
            onChanged: (String value) {
              loginBloc!.changeticketCode(value);
            },
            onfocus: tickNumFocus.hasFocus,
            onTap: () {
              setState(() {});
            },
            stream: loginBloc!.ticketCode,
            heading: 'Ticket Number Code',
          ),
        ],
      ),
    );
  }

  Widget saveButton(LoginBloc? loginBloc) {
    return Container(
      child: Row(
        children: [
          ZTSStreamButton(
              width: 150,
              formValidationStream: loginBloc!.validateSettingsFormStream,
              submit: () {
                sharedPrefs.setbaseUrl(baseUrl: baseUrlController.text);
                sharedPrefs.setTicketCode(baseUrl: ticketNumController.text);
                Navigator.pop(context);
              },
              text: 'Save',
              errrorText: '',
              errorFlag: false)
        ],
      ),
    );
  }
}
