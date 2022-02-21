import 'package:es_2022_02_02_1/api_models/helpDesk_model.dart';
import 'package:es_2022_02_02_1/ui/widgets/page_bar.dart';
import 'package:flutter/material.dart';

class AuthoritySelectionScreen extends StatefulWidget {
  const AuthoritySelectionScreen({Key? key}) : super(key: key);
  static final LocalKey keyPage = UniqueKey();

  @override
  _AuthoritySelectionScreenState createState() =>
      _AuthoritySelectionScreenState();
}

class _AuthoritySelectionScreenState extends State<AuthoritySelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PageBar(
              pageName: 'Seleziona Ente',
            )
          ],
        ),
      ),
    );
  }
}
