import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/sdp.dart';
import 'package:intl/intl.dart';

get height5 => SizedBox(height: 5);
get height10 => SizedBox(height: 10);
get height15 => SizedBox(height: 15);
get height20 => SizedBox(height: 20);
get width5 => SizedBox(width: 5);
get width10 => SizedBox(width: 10);
get width20 => SizedBox(width: 20);
get width25 => SizedBox(width: 25);

SizedBox kHeight(double height) => SizedBox(height: height);
SizedBox kWidth(double width) => SizedBox(width: width);

// ----------------------------------------->

AppBar kAppBar(BuildContext context, {required String title}) {
  return AppBar(
    titleSpacing: 0,
    leading: kBackButton(context),
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: sdp(context, 12),
      ),
    ),
  );
}

kSystemColors() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: kScaffoldColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}

TextStyle kTitleStyle(
  BuildContext context, {
  Color? color,
  FontWeight? fontWeight,
  double? fontSize,
}) {
  return TextStyle(
    color: color ?? Colors.black,
    fontSize: fontSize ?? sdp(context, 15),
    fontWeight: fontWeight ?? FontWeight.w700,
  );
}

TextStyle kSubtitleStyle(
  BuildContext context, {
  Color? color,
  FontWeight? fontWeight,
}) {
  return TextStyle(
    color: color ?? Colors.black,
    fontSize: sdp(context, 12),
    fontWeight: fontWeight ?? FontWeight.w500,
  );
}

// ignore: non_constant_identifier_names
BorderRadius kRadius(double radius) => BorderRadius.circular(radius);

Future<void> navPush(BuildContext context, Widget screen) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => screen));
}

Future<void> navPushReplacement(BuildContext context, Widget screen) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => screen));
}

Future<void> navPopUntilPush(BuildContext context, Widget screen) {
  Navigator.popUntil(context, (route) => false);
  return navPush(context, screen);
}

String formatDate(String date) {
  return DateFormat('d-MM-y hh:mm a').format(DateTime.parse(date));
}

class Pill {
  static Widget label({
    Widget? icon,
    String? label,
    Color pillColor = kPillColor,
    Color? labelColor,
  }) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        // margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: pillColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon != null
                ? Padding(padding: EdgeInsets.only(right: 6), child: icon)
                : SizedBox.shrink(),
            Text(
              label ?? 'text',
              style: TextStyle(
                color: labelColor ?? Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget outlinedLabel(
      {Widget? icon, String? label, Color? borderColor}) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: borderColor ?? Colors.grey.shade600,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon != null
                ? Padding(padding: EdgeInsets.only(right: 6), child: icon)
                : SizedBox.shrink(),
            Text(
              label ?? 'text',
              style: TextStyle(
                color: Colors.grey.shade100,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget kTextButton({
  void Function()? onTap,
  required Widget child,
}) {
  return InkWell(
    onTap: onTap,
    child: child,
  );
}

Widget kUnorderedList(String text) {
  return Padding(
    padding: EdgeInsets.only(bottom: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("•"),
        width10,
        Expanded(
          child: Text(text),
        ),
      ],
    ),
  );
}

Widget statsCard(
  BuildContext context, {
  String? content,
  String? label,
  Color? textColor,
}) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColorAccent, width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: Text(
              content ?? '<content>',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: sdp(context, 11),
                color: textColor ?? Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          height5,
          Text(
            label ?? '<label>',
            style: TextStyle(
              fontSize: sdp(context, 9),
              color: textColor ?? Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}

IconButton kBackButton(BuildContext context) {
  return IconButton(
    onPressed: () {
      Navigator.pop(context);
    },
    icon: SvgPicture.asset(
      'assets/icons/back.svg',
      height: sdp(context, 16),
    ),
  );
}

// ignore: non_constant_identifier_names
Widget kTextField(
  BuildContext context, {
  String label = 'label',
  bool readOnly = false,
  Color bgColor = Colors.transparent,
  TextEditingController? controller,
  String hintText = 'Hint text',
  TextInputType? keyboardType,
  TextCapitalization textCapitalization = TextCapitalization.none,
  int maxLines = 1,
  int minLines = 1,
  int? maxLength,
  bool obscureText = false,
  bool isPasswordField = false,
  void Function()? onFieldTap,
  void Function()? onShowPassword,
  void Function(String)? onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: sdp(context, 9)),
      ),
      kHeight(7),
      Row(
        children: [
          Flexible(
            child: TextField(
              controller: controller,
              onTap: onFieldTap,
              readOnly: readOnly,
              cursorColor: kPrimaryColorAccent,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
              obscureText: obscureText,
              maxLines: maxLines,
              minLines: minLines,
              maxLength: maxLength,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization,
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: bgColor,
                focusedBorder: OutlineInputBorder(
                  borderRadius: kRadius(10),
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: kRadius(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: kRadius(10),
                  borderSide: BorderSide(color: Colors.red.shade400),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: sdp(context, 10),
                ),
              ),
              onChanged: onChanged,
            ),
          ),
          isPasswordField
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: kTextButton(
                    onTap: onShowPassword,
                    child: SvgPicture.asset(obscureText
                        ? 'assets/icons/hide-password.svg'
                        : 'assets/icons/show-password.svg'),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    ],
  );
}

Text kBulletSeperator({Color? color}) {
  return Text(
    ' • ',
    style: TextStyle(
      color: color ?? Colors.black,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget kPageHeader(
  BuildContext context, {
  required String title,
  String subtitle = '',
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      height20,
      Text(
        title,
        style: kTitleStyle(context),
      ),
      subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: TextStyle(fontSize: sdp(context, 10)),
            )
          : SizedBox.shrink(),
    ],
  );
}
