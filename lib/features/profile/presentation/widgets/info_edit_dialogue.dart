import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_text_field.dart';

void userInfoEditDialogue(
  BuildContext context, {
  required void Function()? onSaved,
  required TextEditingController nameController,
  required TextEditingController aboutController,
  required TextEditingController phoneController,
  required bool autofocusName,
  required bool autofocusAbout,
  required bool autofocusPhone,
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    enableDrag: false,
    context: context,
    builder: (context) {
      double bottom = MediaQuery.viewInsetsOf(context).bottom;
      return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, bottom),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [Text('Edit your info', style: AppTextStyles.intro)]),
              const SizedBox(height: 10),
              AppTextField(
                hintText: 'Name',
                borderless: true,
                textInputAction: TextInputAction.next,
                autofocus: autofocusName,
                controller: nameController,
              ),
              const SizedBox(height: 10),
              AppTextField(
                hintText: 'about',
                borderless: true,
                maxLines: 5,
                autofocus: autofocusAbout,
                controller: aboutController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 10),
              AppTextField(
                hintText: 'Phone',
                borderless: true,
                autofocus: autofocusPhone,
                textInputAction: TextInputAction.done,
                controller: phoneController,
              ),
              const SizedBox(height: 30),
              AppButton(label: 'Save', onPressed: onSaved),
            ],
          ),
        ),
      );
    },
  );
}

void infoEditDialogue(
  BuildContext context, {
  required void Function()? onSaved,
  bool showName = true,
  bool showAbout = true,
  bool isRoom = false,
  TextEditingController? nameController,
  TextEditingController? aboutController,
  final String? title,
}) {
  String defaultTitle = '';
  String name = '';
  String about = '';

  void text() {
    if (showName && isRoom) {
      defaultTitle = 'Edit Room info';
      name = 'Room name';
      about = 'Room description';
    } else if (!showName && isRoom) {
      defaultTitle = 'Room description';
      name = 'Room name';
      about = 'Room description';
    } else {
      defaultTitle = 'Edit name and about';
      name = 'Name';
      about = 'About';
    }
  }

  showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    enableDrag: false,
    context: context,
    builder: (context) {
      text();
      double bottom = MediaQuery.viewInsetsOf(context).bottom;
      return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, bottom),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                Text(
                  title ?? defaultTitle,
                  style: AppTextStyles.intro,
                ),
              ]),
              const SizedBox(height: 10),
              Visibility(
                visible: showName,
                child: Column(
                  children: [
                    AppTextField(
                      hintText: name,
                      borderless: true,
                      textInputAction: showAbout
                          ? TextInputAction.next
                          : TextInputAction.done,
                      autofocus: true,
                      controller: nameController,
                      onFieldSubmitted:
                          showAbout ? null : (_) => onSaved!(),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Visibility(
                visible: showAbout,
                child: AppTextField(
                  hintText: about,
                  borderless: true,
                  maxLines: 5,
                  autofocus: true,
                  controller: aboutController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
              ),
              const SizedBox(height: 30),
              AppButton(label: 'Save', onPressed: onSaved),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}
