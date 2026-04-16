import 'package:e_commerce/utils/app_colors.dart';
import 'package:e_commerce/view_models/location_cubit/location_cubit.dart';
import 'package:e_commerce/views/widgets/custom_elevated_button.dart';
import 'package:e_commerce/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/location_widget.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  late final TextEditingController _addressController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationCubit = BlocProvider.of<LocationCubit>(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text("Delivery Address"),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Choose your location",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Let's find your delivery address",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 24),


                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _addressController,
                        label: "Enter Address",
                        hintText: "City-Country",
                        prefixIcon: Icons.location_on_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          if (!value.contains('-') ||
                              value.split('-').length < 2 ||
                              value.split('-')[0].trim().isEmpty ||
                              value.split('-')[1].trim().isEmpty) {
                            return 'Format must be City-Country';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 26.0),
                      child: BlocConsumer<LocationCubit, LocationState>(
                        bloc: locationCubit,
                        buildWhen: (previous, current) =>
                            current is AddingLocation ||
                            current is LocationAdded ||
                            current is AddingLocationFailed,
                        listenWhen: (previous, current) =>
                            current is LocationAdded ||
                            current is LocationButtonConfirmed,
                        listener: (context, state) {
                          if (state is LocationAdded) {
                            _addressController.clear();
                          } else if (state is LocationButtonConfirmed) {
                            Navigator.of(context).pop();
                          }
                        },
                        builder: (context, state) {
                          return Container(
                            height: 54,
                            width: 54,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF7E57C2), Color(0xFF512DA8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: state is AddingLocation
                                ? const Padding(
                                    padding: EdgeInsets.all(14),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        locationCubit.addLocation(
                                          _addressController.text,
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.add_rounded,
                                      color: AppColors.white,
                                      size: 22,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                Text(
                  "Saved Locations",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 14),

                BlocBuilder<LocationCubit, LocationState>(
                  bloc: locationCubit,
                  buildWhen: (previous, current) =>
                      current is FetchingLocations ||
                      current is FetchingLocationsFailed ||
                      current is LocationsFetched,
                  builder: (context, state) {
                    if (state is FetchingLocations) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (state is FetchingLocationsFailed) {
                      return Center(child: Text(state.message));
                    } else if (state is LocationsFetched) {
                      final locations = state.locations;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: locations.length,
                        itemBuilder: (context, index) {
                          final address = locations[index];
                          return InkWell(
                            onTap: () {
                              locationCubit.selectedLocation(address.id);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: BlocBuilder<LocationCubit, LocationState>(
                                bloc: locationCubit,
                                buildWhen: (previous, current) =>
                                    current is LocationChosen,
                                builder: (context, state) {
                                  if (state is LocationChosen) {
                                    final chosenLocation = state.location;
                                    return LocationWidget(
                                      address: address,
                                      borderColor:
                                          chosenLocation.id == address.id
                                          ? AppColors.primary
                                          : AppColors.grey2,
                                    );
                                  } else {
                                    return LocationWidget(
                                      address: address,
                                      borderColor: AppColors.grey2,
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(height: 32),
                BlocBuilder<LocationCubit, LocationState>(
                  bloc: locationCubit,
                  buildWhen: (previous, current) =>
                      current is LocationButtonConfirming ||
                      current is LocationButtonConfirmed ||
                      current is LocationButtonConfirmingFailed,
                  builder: (context, state) {
                    if (state is LocationButtonConfirming) {
                      return CustomElevatedButton(isLoading: true);
                    } else {
                      return CustomElevatedButton(
                        text: "Confirm Location",
                        onPressed: () {
                          locationCubit.confirmAddress();
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
