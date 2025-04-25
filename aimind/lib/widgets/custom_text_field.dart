import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final int maxLegth;
  final double height;
  final double width;
  final bool enabled;

  const CustomTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    required this.maxLegth,
    this.height = 60.0,
    this.width = double.infinity,
    this.enabled = true,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool secureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: TextField(
          enabled: widget.enabled,
          controller: widget.controller,
          inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLegth)],
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: Color(0xFFB0B0B0),
              fontFamily: 'SFPro',
              fontSize: 20,
            ),
            alignLabelWithHint: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 16.0,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.grey, width: 3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.green, width: 3),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.grey, width: 3),
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: const Color(0xFFB0B0B0))
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      secureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        secureText = !secureText;
                      });
                    },
                  )
                : null,
            counterText: '',
          ),
          keyboardType: widget.keyboardType,
          textInputAction: TextInputAction.next,
          obscureText: widget.isPassword ? secureText : false,
          maxLength: widget.maxLegth,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontFamily: 'SFPro',
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
