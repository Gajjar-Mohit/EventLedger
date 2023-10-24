import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateEvent extends StatelessWidget {
  final VoidCallback submit, getAccessTap;
  final TextEditingController dateController, nameController;
  const CreateEvent({
    required this.submit,
    super.key,
    required this.dateController,
    required this.nameController,
    required this.getAccessTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create an Event',
          style: TextStyle(
            color: Color(0xFF101213),
            fontSize: 36,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
          child: Text(
            'Let\'s get started by filling out the details below.',
            style: TextStyle(
              color: Color(0xFF57636C),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
          child: SizedBox(
            width: 370,
            child: TextFormField(
                controller: nameController,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Event Name',
                  labelStyle: const TextStyle(
                    color: Color(0xFF57636C),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFF1F4F8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF4B39EF),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFFF5963),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFFF5963),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF1F4F8),
                ),
                style: const TextStyle(
                  color: Color(0xFF101213),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  return null;
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
          child: SizedBox(
            width: 370,
            child: TextFormField(
                controller: dateController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "DD/MM/YYYY",
                  labelText: 'Event Date',
                  labelStyle: const TextStyle(
                    color: Color(0xFF57636C),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFF1F4F8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF4B39EF),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFFF5963),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFFF5963),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF1F4F8),
                ),
                style: const TextStyle(
                  color: Color(0xFF101213),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                validator: (val) {
                  return null;
                }),
          ),
        ),
        InkWell(
          onTap: submit,
          child: Container(
            width: 370,
            height: 60,
            decoration: BoxDecoration(
                color: const Color(0xFF4B39EF),
                borderRadius: BorderRadius.circular(12)),
            child: const Center(
              child: Text(
                "Create",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Already created event? ',
                  style: TextStyle(),
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = getAccessTap,
                  text: 'get access',
                  style: const TextStyle(
                    color: Color(0xFF4B39EF),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
              style: const TextStyle(
                color: Color(0xFF57636C),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class WalletCard extends StatefulWidget {
  final VoidCallback getMaticTap, confirmTap, checkBalanceTap;
  final String balance, etherAdd;
  const WalletCard({
    super.key,
    required this.getMaticTap,
    required this.balance,
    required this.confirmTap,
    required this.checkBalanceTap,
    required this.etherAdd,
  });

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  void copyAddress() {
    Clipboard.setData(ClipboardData(text: widget.etherAdd));
    Fluttertoast.showToast(msg: "Address copied to clipboad");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Get some fuel',
          style: TextStyle(
            color: Color(0xFF101213),
            fontSize: 36,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${widget.balance} Matic',
              style: const TextStyle(fontSize: 20),
            ),
            IconButton(
                onPressed: widget.checkBalanceTap,
                icon: const Icon(Icons.refresh_outlined))
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.etherAdd,
            ),
            IconButton(onPressed: copyAddress, icon: const Icon(Icons.copy))
          ],
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'You can get some test matic from ',
                  style: TextStyle(),
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = widget.getMaticTap,
                  text: 'here',
                  style: const TextStyle(
                    color: Color(0xFF4B39EF),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
              style: const TextStyle(
                color: Color(0xFF57636C),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: widget.confirmTap,
          child: Container(
            width: 370,
            height: 60,
            decoration: BoxDecoration(
                color: const Color(0xFF4B39EF),
                borderRadius: BorderRadius.circular(12)),
            child: const Center(
              child: Text(
                "Lets go",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AccessEvent extends StatelessWidget {
  final VoidCallback submit, createAccountTap;
  final TextEditingController privateKeyController;
  const AccessEvent({
    required this.submit,
    super.key,
    required this.privateKeyController,
    required this.createAccountTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome back',
          style: TextStyle(
            color: Color(0xFF101213),
            fontSize: 36,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
          child: Text(
            'Let\'s get access by filling out the field below.',
            style: TextStyle(
              color: Color(0xFF57636C),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
          child: SizedBox(
            width: 370,
            child: TextFormField(
                controller: privateKeyController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Private key',
                  labelStyle: const TextStyle(
                    color: Color(0xFF57636C),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFF1F4F8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF4B39EF),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFFF5963),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFFF5963),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF1F4F8),
                ),
                style: const TextStyle(
                  color: Color(0xFF101213),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                validator: (val) {
                  return null;
                }),
          ),
        ),
        InkWell(
          onTap: submit,
          child: Container(
            width: 370,
            height: 60,
            decoration: BoxDecoration(
                color: const Color(0xFF4B39EF),
                borderRadius: BorderRadius.circular(12)),
            child: const Center(
              child: Text(
                "Login",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'No event to access? ',
                  style: TextStyle(),
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = createAccountTap,
                  text: 'create it.',
                  style: const TextStyle(
                    color: Color(0xFF4B39EF),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
              style: const TextStyle(
                color: Color(0xFF57636C),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
