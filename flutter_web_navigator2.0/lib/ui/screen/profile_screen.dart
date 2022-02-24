import 'package:es_2022_02_02_1/api_models/get/get_user_logged.dart';
import 'package:es_2022_02_02_1/core/networking/services/api/api_service.dart';
import 'package:es_2022_02_02_1/core/networking/services/authentication/authentication_provider.dart';
import 'package:es_2022_02_02_1/ui/widgets/page_bar.dart';
import 'package:es_2022_02_02_1/ui/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static final LocalKey keyPage = UniqueKey();

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        ? Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const PageBar(pageName: 'Profilo'),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Card(
                      elevation: 1,
                      child: Container(
                        margin: const EdgeInsets.all(40),
                        width: double.infinity,
                        child: FutureBuilder<UserLogged?>(
                          future: getData(context),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              final _user = snapshot.data;

                              return Expanded(
                                child: Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      (Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text(
                                            'Nome',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _user!.firstName.isEmpty
                                                ? ''
                                                : _user.firstName,
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            'Cognome',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _user.lastName.isEmpty
                                                ? ''
                                                : _user.lastName,
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            'Codice Fiscale',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _user.fiscalCode.isEmpty
                                                ? ''
                                                : _user.fiscalCode,
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            'Email',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _user.email.isEmpty
                                                ? ''
                                                : _user.email,
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            'Numero Di telefono',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _user.phoneNumber ?? '',
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      )),
                                      _user.avatarUrl == null
                                          ? CircleAvatar(
                                              backgroundColor:
                                                  Colors.grey.shade400,
                                              radius: 130,
                                              child: const Icon(
                                                FontAwesomeIcons.user,
                                                size: 180,
                                                color: Colors.white,
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  _user.avatarUrl!),
                                              radius: 130,
                                            ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  Future<UserLogged?> getData(BuildContext context) async {
    final responseHelpDesk =
        await Provider.of<ApiService>(context, listen: false).profiles();

    if (responseHelpDesk.item1 == 401) {
      Provider.of<AuthenticationProvider>(context, listen: false).setAuth =
          false;
    }

    return responseHelpDesk.item2;
  }
}
