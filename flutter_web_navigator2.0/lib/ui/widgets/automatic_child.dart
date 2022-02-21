import 'package:es_2022_02_02_1/core/routing/models/form_models.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AutomaticChild extends StatelessWidget {
  AutomaticChild({Key? key, required this.forms}) : super(key: key);

  List<FormModel> forms;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Wrap(
        children: getReactiveformWidgets(forms),
      ),
    );
  }
}

List<Widget> getReactiveformWidgets(List<FormModel> strings) {
  List<Widget> w = [];
  strings.forEach((element) {
    w.add(
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 50,
          width: element.width,
          child: ReactiveForm(
            formGroup: FormGroup({
              element.name: FormControl<String>(value: element.value),
            }),
            child: ReactiveTextField(
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: element.label,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                formControlName: element.name),
          ),
        ),
      ),
    );
  });
  return w;
}

class AutomaticToggle extends StatelessWidget {
  AutomaticToggle({Key? key, required this.toggle}) : super(key: key);

  List<FormModel> toggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Wrap(
        children: getToggleWidgets(toggle),
      ),
    );
  }
}

List<Widget> getToggleWidgets(List<FormModel> strings) {
  List<Widget> w = [];
  strings.forEach((element) {
    w.add(
      SizedBox(
        width: element.width,
        child: ReactiveForm(
            formGroup: FormGroup({
              element.name: FormControl<bool>(value: false),
            }),
            child: ReactiveSwitch(
              formControlName: element.name,
              // activeColor: ,
            )),
      ),
    );
  });
  return w;
}
