import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/app_colors.dart';

import '../../view_models/payment_card_cubit/payment_card_cubit.dart';
import '../widgets/custom_text_field.dart';

class AddNewCardPage extends StatefulWidget {
  const AddNewCardPage({super.key});

  @override
  State<AddNewCardPage> createState() => _AddNewCardPageState();
}

class _AddNewCardPageState extends State<AddNewCardPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _cardNumberController;
  late final TextEditingController _cardHolderNameController;
  late final TextEditingController _expiryDateController;
  late final TextEditingController _cvvController;

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController();
    _cardHolderNameController = TextEditingController();
    _expiryDateController = TextEditingController();
    _cvvController = TextEditingController();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderNameController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<PaymentCardCubit>(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text("Add New Card"),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              AnimatedBuilder(
                animation: Listenable.merge([
                  _cardNumberController,
                  _cardHolderNameController,
                  _expiryDateController,
                ]),
                builder: (context, _) {
                  final number = _cardNumberController.text.isEmpty
                      ? '•••• •••• •••• ••••'
                      : _formatCardNumber(_cardNumberController.text);
                  final holder = _cardHolderNameController.text.isEmpty
                      ? 'CARDHOLDER NAME'
                      : _cardHolderNameController.text.toUpperCase();
                  final expiry = _expiryDateController.text.isEmpty
                      ? 'MM/YY'
                      : _expiryDateController.text;

                  return Container(
                    width: double.infinity,
                    height: 190,
                    margin: const EdgeInsets.only(bottom: 28),
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF7E57C2), Color(0xFF311B92)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.contactless_outlined,
                              color: Colors.white70,
                              size: 28,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.7),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Transform.translate(
                                  offset: const Offset(-12, 0),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withValues(
                                        alpha: 0.7,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          number,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "CARD HOLDER",
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 9,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  holder,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "EXPIRES",
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 9,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  expiry,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),


              CustomTextField(
                controller: _cardNumberController,
                label: "Card Number",
                hintText: "Enter 16-digit card number",
                prefixIcon: Icons.credit_card,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  if (value.length != 16) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              CustomTextField(
                controller: _cardHolderNameController,
                label: "Cardholder Name",
                hintText: "Enter full name",
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cardholder name';
                  }
                  if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                    return 'Name must contain only letters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _expiryDateController,
                      label: "Expiry Date",
                      hintText: "MM/YY",
                      prefixIcon: Icons.calendar_today_outlined,
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (!RegExp(
                          r'^(0[1-9]|1[0-2])\/?([0-9]{2})$',
                        ).hasMatch(value)) {
                          return 'Invalid format';
                        }
                        int month = int.parse(value.substring(0, 2));
                        int year =
                            int.parse(value.substring(value.length - 2)) + 2000;
                        DateTime now = DateTime.now();
                        if (year < now.year ||
                            (year == now.year && month < now.month)) {
                          return 'Card has expired';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: CustomTextField(
                      controller: _cvvController,
                      label: "CVV",
                      hintText: "•••",
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (value.length != 3) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: BlocConsumer<PaymentCardCubit, PaymentCardState>(
                  buildWhen: (previous, current) =>
                      current is AddPaymentCardLoading ||
                      current is AddPaymentCardSuccess ||
                      current is AddPaymentCardFailed,
                  bloc: cubit,
                  builder: (context, state) {
                    final isLoading = state is AddPaymentCardLoading;
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: !isLoading
                            ? const LinearGradient(
                                colors: [Color(0xFF7E57C2), Color(0xFF512DA8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isLoading ? Colors.grey.shade300 : null,
                        boxShadow: !isLoading
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.35,
                                  ),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : null,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          elevation: 0,
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  cubit.addPaymentCard(
                                    _cardNumberController.text,
                                    _cardHolderNameController.text,
                                    _cvvController.text,
                                    _expiryDateController.text,
                                  );
                                }
                              },
                        child: isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Add Card",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    );
                  },
                  listenWhen: (previous, current) =>
                      current is AddPaymentCardSuccess ||
                      current is AddPaymentCardFailed,
                  listener: (context, state) {
                    if (state is AddPaymentCardSuccess) {
                      BlocProvider.of<PaymentCardCubit>(
                        context,
                      ).fetchPaymentCards();
                      Navigator.pop(context);
                    } else if (state is AddPaymentCardFailed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: AppColors.white,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                state.message,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(16),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCardNumber(String number) {
    final clean = number.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < clean.length && i < 16; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(clean[i]);
    }
    return buffer.toString().padRight(19, '•').replaceAll('', '');
  }
}
