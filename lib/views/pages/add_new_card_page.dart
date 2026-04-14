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
      appBar: AppBar(title: const Text("Add New Card"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
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
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
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

                        // Extract month and year
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _cvvController,
                      label: "CVV",
                      hintText: "123",
                      prefixIcon: Icons.lock_outline,
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
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: BlocConsumer<PaymentCardCubit, PaymentCardState>(
                  buildWhen: (previous, current) =>
                      current is AddPaymentCardLoading ||
                      current is AddPaymentCardSuccess ||
                      current is AddPaymentCardFailed,
                  bloc: cubit,
                  builder: (context, state) {
                    if (state is AddPaymentCardLoading) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          elevation: 0,
                        ),
                        onPressed: null,
                        child: const CircularProgressIndicator.adaptive(),
                      );
                    }
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          cubit.addPaymentCard(
                            _cardNumberController.text,
                            _cardHolderNameController.text,
                            _cvvController.text,
                            _expiryDateController.text,
                          );
                        }
                      },
                      child: const Text(
                        "Add Card",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                  listenWhen: (previous, current) =>
                      current is AddPaymentCardSuccess ||
                      current is AddPaymentCardFailed,
                  listener: (context, state) {
                    if (state is AddPaymentCardSuccess) {
                      BlocProvider.of<PaymentCardCubit>(context).fetchPaymentCards();
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
                                style: Theme.of(context).textTheme.bodyMedium
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
            ],
          ),
        ),
      ),
    );
  }
}
