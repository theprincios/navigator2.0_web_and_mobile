import 'package:flutter/material.dart';
import 'package:reactive_raw_autocomplete/reactive_raw_autocomplete.dart';
import 'package:reactive_forms/reactive_forms.dart';

void main() {
  runApp(const MyApp());
}

List<String> _options = <String>[
  'aardvark',
  'bobcat',
  'chameleon',
];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  FormGroup buildForm() => fb.group({
        'input': FormControl<String>(value: null),
      });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: ReactiveFormBuilder(
              form: buildForm,
              builder: (context, form, child) {
                return Column(
                  children: [
                    ReactiveRawAutocomplete<String, String>(
                      formControlName: 'input',
                      // options: _options,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        return _options.where((String option) {
                          return option
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      optionsViewBuilder: (BuildContext context,
                          AutocompleteOnSelected<String> onSelected,
                          Iterable<String> options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4.0,
                            child: SizedBox(
                              height: 200.0,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(8.0),
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final String option =
                                      options.elementAt(index);
                                  return GestureDetector(
                                    onTap: () {
                                      onSelected(option);
                                    },
                                    child: ListTile(
                                      title: Text(option),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      child: const Text('Sign Up'),
                      onPressed: () {
                        if (form.valid) {
                          // ignore: avoid_print
                          print(form.value);
                        } else {
                          form.markAllAsTouched();
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}


Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: ReactiveRawAutocomplete<String,
                                        PlaceSearch>(
                                      decoration: const InputDecoration(
                                        labelText: 'Indirizzo',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      formControl: cardNumber,
                                      validationMessages: (control) =>
                                          {'required': 'Campo Obbligatorio'},
                                      // options: _options,
                                      optionsBuilder: (TextEditingValue
                                          textEditingValue) async {
                                        if (textEditingValue.text.length < 3) {
                                          return [];
                                        }

                                        List listObject =
                                            await Provider.of<ApiService>(
                                                    context,
                                                    listen: false)
                                                .getAddressAutocomplete(
                                                    search:
                                                        textEditingValue.text);

                                        List<PlaceSearch> listAddress =
                                            listObject
                                                .map((object) =>
                                                    PlaceSearch.fromJson(
                                                        object))
                                                .toList();

                                        return listAddress;
                                      },

                                      optionsViewBuilder: (BuildContext context,
                                          AutocompleteOnSelected<PlaceSearch>
                                              onSelected,
                                          Iterable<PlaceSearch> options) {
                                        final List<PlaceSearch> option = options
                                            .map((e) => PlaceSearch(
                                                city: e.city,
                                                addressName: e.addressName,
                                                point: e.point))
                                            .toList();
                                        return Align(
                                          alignment: Alignment.topLeft,
                                          child: Material(
                                            elevation: 4.0,
                                            child: SizedBox(
                                              width: 400,
                                              height: 100.0,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                    children: option
                                                        .map(
                                                            (e) =>
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    onSelected(PlaceSearch(
                                                                        city: e
                                                                            .city,
                                                                        addressName: e
                                                                            .addressName,
                                                                        point: e
                                                                            .point));
                                                                    print(e
                                                                        .point
                                                                        .latitude);
                                                                  },
                                                                  child: ListTile(
                                                                      title: Text(
                                                                          e.addressName)),
                                                                ))
                                                        .toList()),
                                              ),
                                            ),
                                            // child: ListView.builder(
                                            //   padding:
                                            //       const EdgeInsets.all(8.0),
                                            //   itemCount: options.length,
                                            //   itemBuilder:
                                            //       (BuildContext context,
                                            //           int index) {

                                            //     return GestureDetector(
                                            //       // onTap: () {
                                            //       //   onSelected(option);
                                            //       //   print(option);
                                            //       // },
                                            //       child: ListTile(
                                            //         title: Text(''),
                                            //       ),
                                            //     );
                                            //   },
                                            // ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),