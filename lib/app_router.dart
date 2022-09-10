import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constnats/strings.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/map_screen.dart';
import 'presentation/screens/otp_screen.dart';
import 'business_logic/cubit/maps/maps_cubit.dart';
import 'business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'data/repository/maps_repo.dart';
import 'data/webservices/places_web_services.dart';

class AppRouter {
  PhoneAuthCubit? phoneAuthCubit;

  AppRouter() {
    phoneAuthCubit = PhoneAuthCubit();
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<PhoneAuthCubit>.value(
                  value: phoneAuthCubit!,
                  child: LoginScreen(),
                ));

      case otpScreen:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => BlocProvider<PhoneAuthCubit>.value(
                  value: phoneAuthCubit!,
                  child: OtpScreen(
                    phoneNumber: phoneNumber,
                  ),
                ));

      case mapScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) =>
                MapsCubit(MapsRepository(PlacesWebServices())),
            child: const MapScreen(),
          ),
        );
    }
    // return MaterialPageRoute(builder: (_) => LoginScreen());
    return null;
  }
}
