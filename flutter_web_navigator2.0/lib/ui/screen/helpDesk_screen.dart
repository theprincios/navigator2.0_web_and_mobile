import 'package:es_2022_02_02_1/api_models/get/get_helpDesk_model.dart';
import 'package:es_2022_02_02_1/api_models/get/get_place_search.dart';
import 'package:es_2022_02_02_1/api_models/post/post_helpDesk_model.dart';
import 'package:es_2022_02_02_1/core/networking/provider/page_refresh.dart';
import 'package:es_2022_02_02_1/core/networking/services/api/api_service.dart';
import 'package:es_2022_02_02_1/ui/widgets/custom_autocomplete.dart';
import 'package:es_2022_02_02_1/ui/widgets/custom_dialog.dart';
import 'package:es_2022_02_02_1/ui/widgets/page_bar.dart';
import 'package:es_2022_02_02_1/ui/widgets/table/helpdesk_table.dart';
import 'package:es_2022_02_02_1/ui/widgets/research_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class HelpDeskScreen extends StatefulWidget {
  HelpDeskScreen({Key? key, this.refresh}) : super(key: key);
  static final LocalKey keyPage = UniqueKey();
  final VoidCallback? refresh;

  @override
  State<HelpDeskScreen> createState() => _HelpDeskScreenState();
}

class _HelpDeskScreenState extends State<HelpDeskScreen> {
  @override
  void initState() {}
  List<String> _options = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];

  final form = FormGroup({
    'name': FormControl<String>(validators: [Validators.required]),
    // 'address': FormControl<String>(),
    'addressNote': FormControl<String>(),
    'publicTransportNote': FormControl<String>(),
    'FreeParking': FormControl<bool>(),
    'PaidParking': FormControl<bool>(),
    'DisabledParking': FormControl<bool>(),
    'Elevator': FormControl<bool>(),
    'WaitingRoom': FormControl<bool>(),
    'address': FormControl<String>(validators: [Validators.required]),
  });

  double? latitude;
  double? longitude;

  late List<String> service = [];
  late bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PageBar(
              pageName: 'Sportelli',
              actioName: 'Aggiungi Sportello',
              primaryButtonDidTapHandler: () async {
                form.reset();

                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialogBox(
                        title: "Nuovo Sportello",
                        primaryButtonTitle: 'Salva',
                        secondaryButtonTitle: 'Annulla',
                        contextt: context,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  width: double.infinity,
                                  child: ReactiveForm(
                                    formGroup: form,
                                    child: ReactiveTextField(
                                      maxLines: 1,
                                      decoration: const InputDecoration(
                                        labelText: 'Denominazione',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      formControlName: 'name',
                                      validationMessages: (control) =>
                                          {'required': 'Campo Obbligatorio'},
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  // height: 150,
                                  width: double.infinity,
                                  child: CustomAutocomplete<PlaceSearch>(
                                    displayStringForOption:
                                        (PlaceSearch option) =>
                                            option.addressName,
                                    optionsBuilder: (TextEditingValue
                                        textEditingValue) async {
                                      if (textEditingValue.text.length < 3) {
                                        return const Iterable<
                                            PlaceSearch>.empty();
                                      }

                                      List listObject =
                                          await Provider.of<ApiService>(context,
                                                  listen: false)
                                              .getAddressAutocomplete(
                                                  search:
                                                      textEditingValue.text);

                                      List<PlaceSearch> listAddress = listObject
                                          .map((object) =>
                                              PlaceSearch.fromJson(object))
                                          .toList();

                                      return listAddress;
                                    },
                                    onSelected: (PlaceSearch selection) {
                                      setState(() {
                                        form.control('address').value =
                                            selection.addressName;
                                        latitude = selection.point.latitude;
                                        longitude = selection.point.longitude;
                                      });
                                    },
                                  ),
                                ),
                                // Container(
                                //   margin: EdgeInsets.symmetric(
                                //       horizontal: 20, vertical: 10),
                                //   child: ReactiveForm(
                                //     formGroup: form,
                                //     child: ReactiveRawAutocomplete<String,
                                //         PlaceSearch>(
                                //       decoration: const InputDecoration(
                                //         labelText: 'Indirizzo',
                                //         border: OutlineInputBorder(
                                //           borderRadius: BorderRadius.all(
                                //             Radius.circular(10.0),
                                //           ),
                                //         ),
                                //       ),
                                //       formControlName: 'address',
                                //       validationMessages: (control) =>
                                //           {'required': 'Campo Obbligatorio'},
                                //       // options: _options,
                                //       optionsBuilder: (TextEditingValue
                                //           textEditingValue) async {
                                //         if (textEditingValue.text.length < 3) {
                                //           return [];
                                //         }

                                //         List listObject =
                                //             await Provider.of<ApiService>(
                                //                     context,
                                //                     listen: false)
                                //                 .getAddressAutocomplete(
                                //                     search:
                                //                         textEditingValue.text);

                                //         List<PlaceSearch> listAddress =
                                //             listObject
                                //                 .map((object) =>
                                //                     PlaceSearch.fromJson(
                                //                         object))
                                //                 .toList();

                                //         return listAddress;
                                //       },

                                //       optionsViewBuilder: (BuildContext context,
                                //           onSelected,
                                //           Iterable<PlaceSearch> options) {
                                //         final List<PlaceSearch> option = options
                                //             .map((e) => PlaceSearch(
                                //                 city: e.city,
                                //                 addressName: e.addressName,
                                //                 point: e.point))
                                //             .toList();
                                //         return Align(
                                //           alignment: Alignment.topLeft,
                                //           child: Material(
                                //             elevation: 4.0,
                                //             child: SizedBox(
                                //               width: 400,
                                //               height: 100.0,
                                //               child: SingleChildScrollView(
                                //                 child: Column(
                                //                     children: option
                                //                         .map(
                                //                             (e) =>
                                //                                 GestureDetector(
                                //                                   onTap: () {
                                //                                     onSelected(PlaceSearch(
                                //                                         city: e
                                //                                             .city,
                                //                                         addressName: e
                                //                                             .addressName,
                                //                                         point: e
                                //                                             .point));
                                //                                     print(e
                                //                                         .point
                                //                                         .latitude);
                                //                                   },
                                //                                   child: ListTile(
                                //                                       title: Text(
                                //                                           e.addressName)),
                                //                                 ))
                                //                         .toList()),
                                //               ),
                                //             ),
                                //             // child: ListView.builder(
                                //             //   padding:
                                //             //       const EdgeInsets.all(8.0),
                                //             //   itemCount: options.length,
                                //             //   itemBuilder:
                                //             //       (BuildContext context,
                                //             //           int index) {

                                //             //     return GestureDetector(
                                //             //       // onTap: () {
                                //             //       //   onSelected(option);
                                //             //       //   print(option);
                                //             //       // },
                                //             //       child: ListTile(
                                //             //         title: Text(''),
                                //             //       ),
                                //             //     );
                                //             //   },
                                //             // ),
                                //           ),
                                //         );
                                //       },
                                //     ),
                                //   ),
                                // ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  height: 50,
                                  width: double.infinity,
                                  child: ReactiveForm(
                                    formGroup: form,
                                    child: ReactiveTextField(
                                      maxLines: 2,
                                      decoration: const InputDecoration(
                                        labelText: 'Note indirizzo',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      formControlName: 'addressNote',
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  height: 50,
                                  width: double.infinity,
                                  child: ReactiveForm(
                                    formGroup: form,
                                    child: ReactiveTextField(
                                        maxLines: 2,
                                        decoration: const InputDecoration(
                                          labelText: 'Trasporto pubblico',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                        formControlName: 'publicTransportNote'),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          ReactiveForm(
                                            formGroup: form,
                                            child: ReactiveCheckbox(
                                              activeColor: Colors.white,
                                              formControlName: 'FreeParking',
                                              checkColor: Colors.blue,
                                            ),
                                          ),
                                          Text('Parcheggio gratuito')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          ReactiveForm(
                                            formGroup: form,
                                            child: ReactiveCheckbox(
                                              formControlName: 'PaidParking',
                                              activeColor: Colors.white,
                                              checkColor: Colors.blue,
                                            ),
                                          ),
                                          Text('Parcheggio a pagamento')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          ReactiveForm(
                                            formGroup: form,
                                            child: ReactiveCheckbox(
                                              formControlName:
                                                  'DisabledParking',
                                              activeColor: Colors.white,
                                              checkColor: Colors.blue,
                                            ),
                                          ),
                                          Text('Parcheggio per disabili')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          ReactiveForm(
                                            formGroup: form,
                                            child: ReactiveCheckbox(
                                              formControlName: 'Elevator',
                                              activeColor: Colors.white,
                                              checkColor: Colors.blue,
                                            ),
                                          ),
                                          Text('Ascensore')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          ReactiveForm(
                                            formGroup: form,
                                            child: ReactiveCheckbox(
                                              formControlName: 'WaitingRoom',
                                              activeColor: Colors.white,
                                              checkColor: Colors.blue,
                                            ),
                                          ),
                                          Text('Sala interna')
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        primaryButtonDidTapHandler: () {
                          form.control('FreeParking').value == true
                              ? service.add('FreeParking')
                              : null;
                          form.control('PaidParking').value == true
                              ? service.add('PaidParking')
                              : null;
                          form.control('DisabledParking').value == true
                              ? service.add('DisabledParking')
                              : null;
                          form.control('Elevator').value == true
                              ? service.add('Elevator')
                              : null;
                          form.control('WaitingRoom').value == true
                              ? service.add('WaitingRoom')
                              : null;

                          form.valid
                              ? postHelpDeskRefresh(
                                  PostHelpDesk(
                                    address: form.control('address').value,
                                    name: form.control('name').value,
                                    addressNote: form.control('name').value,
                                    publicTransportNote: form
                                        .control('publicTransportNote')
                                        .value,
                                    services: service,
                                    addressPoint: AddressPoint(
                                        latitude: latitude,
                                        longitude: longitude),
                                  ),
                                  context,
                                )
                              : form.markAllAsTouched();
                        },
                        secondaryButtonDidTapHandler: () {});
                  },
                );
              },
            ),
            ResearchBar(
              child: Container(
                child: Row(
                  children: [],
                ),
              ),
            ),
            HelpDeskTable(),
          ],
        ),
      ),
    );
  }

  void postHelpDeskRefresh(
    PostHelpDesk data,
    BuildContext context,
  ) async {
    await postHelpDesk(data);
    Provider.of<PageRefresh>(context, listen: false).refresh();
    Navigator.of(context).pop();
  }

  Future postHelpDesk(PostHelpDesk data) async {
    final response = await Provider.of<ApiService>(context, listen: false)
        .postHelpDesk(data.toJson());

    if (response.item2 == 400) {
      print(response.item1!);
    }
  }
}
