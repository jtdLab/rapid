import 'package:auto_route/auto_route.dart';
import 'package:example_di/example_di.dart';
import 'package:example_ios_login_page/src/application/application.dart';
import 'package:example_ios_login_page/src/presentation/l10n/l10n.dart';
import 'package:example_ios_navigation/example_ios_navigation.dart';
import 'package:example_ui_ios/example_ui_ios.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginBloc>(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<LoginBloc, LoginState>(
            listenWhen: (_, current) =>
                current is LoginLoadSuccess || current is LoginLoadFailure,
            listener: (context, state) => state.mapOrNull(
              loadSuccess: (failure) => _onAuthenticated(context),
              loadFailure: (failure) => _onLoadFailure(context, failure),
            ),
          ),
        ],
        child: const LoginView(),
      ),
    );
  }

  void _onAuthenticated(BuildContext context) {
    getIt<IProtectedRouterNavigator>().replace(context);
  }

  void _onLoadFailure(BuildContext context, LoginLoadFailure failure) {
    // TODO switch error cases
    //showToast('An error occured');

    /*  failure.failure.maybeWhen(
      // TODO show server error feels not perfect
      serverError: () => context.showToast(
        context.l10n.errorServer.toUpperCase(),
      ),
      invalidEmailAndPasswordCombination: () => context.showToast(
        context.l10n.errorInvalidEmailAndPasswordCombination.toUpperCase(),
      ),
      // TODO display other errors better
      orElse: () => context.showToast(
        context.l10n.errorUnexpected.toUpperCase(),
      ),
    ); */
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return ExampleScaffold(
      onTap: () => node.unfocus(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bottomInsets = MediaQuery.of(context).viewInsets.bottom;

          return SingleChildScrollView(
            physics:
                bottomInsets == 0 ? const NeverScrollableScrollPhysics() : null,
            child: ConstrainedBox(
              constraints: constraints.copyWith(
                maxHeight: constraints.maxHeight + bottomInsets,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 64),
                  const RapidLogo(),
                  const SizedBox(height: 64),
                  Text(
                    context.l10n.login,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  ExampleTextField(
                    placeholder: context.l10n.username,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onEditingComplete: () => node.nextFocus(),
                    onChanged: (email) => _onUsernameChanged(context, email),
                  ),
                  const SizedBox(height: 16),
                  ExampleTextField(
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => node.unfocus(),
                    obscureText: true,
                    placeholder: context.l10n.password,
                    onChanged: (password) =>
                        _onPasswordChanged(context, password),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (previous, current) =>
                          previous is LoginLoadInProgress ||
                          current is LoginLoadInProgress,
                      builder: (context, state) {
                        return ExamplePrimaryButton(
                          isSubmitting: state is LoginLoadInProgress,
                          text: context.l10n.login,
                          onPressed: () => _onLoginPressed(context),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.l10n.dontHaveAnAccount,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      ExampleLinkButton(
                        text: context.l10n.signUpNow,
                        onPressed: () => _onGotSignUpPressed(context),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onUsernameChanged(BuildContext context, String username) {
    context.read<LoginBloc>().add(
          LoginEvent.usernameChanged(newUsername: username),
        );
  }

  void _onPasswordChanged(BuildContext context, String password) {
    context.read<LoginBloc>().add(
          LoginEvent.passwordChanged(newPassword: password),
        );
  }

  void _onLoginPressed(BuildContext context) {
    context.read<LoginBloc>().add(
          const LoginEvent.loginPressed(),
        );
  }

  void _onGotSignUpPressed(BuildContext context) {
    getIt<ISignUpPageNavigator>().navigate(context);
  }
}
