import 'package:flutter/material.dart';
import 'package:userApp/components/text_field_container.dart';
import 'package:userApp/constants.dart';

class RoundedPasswordFieldCheck extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordFieldCheck({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "한번 더 입력해주세요.",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
