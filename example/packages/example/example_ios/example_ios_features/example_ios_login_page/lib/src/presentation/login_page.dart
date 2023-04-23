import 'package:auto_route/auto_route.dart';
import 'package:example_di/example_di.dart';
import 'package:example_ios_login_page/src/application/application.dart';
import 'package:example_ios_login_page/src/presentation/l10n/l10n.dart';
import 'package:example_ios_navigation/example_ios_navigation.dart';
import 'package:example_ui_ios/example_ui_ios.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LoginPage extends StatefulWidget implements AutoRouteWrapper {
  const LoginPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginBloc>(),
      child: this,
    );
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// TODO: consider using https://pub.dev/packages/flutter_hooks
class _LoginPageState extends State<LoginPage> with ExampleToastMixin {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (_, current) =>
              current is LoginLoadSuccess || current is LoginLoadFailure,
          listener: (context, state) => state.mapOrNull(
            loadSuccess: (_) => _onLoadSuccess(context),
            loadFailure: (state) => _onLoadFailure(context, state),
          ),
        ),
      ],
      child: const LoginView(),
    );
  }

  void _onLoadSuccess(BuildContext context) {
    getIt<IProtectedRouterNavigator>().replace(context);
  }

  void _onLoadFailure(BuildContext context, LoginLoadFailure state) {
    final failure = state.failure;
    failure.when(
      serverError: () => showToast(context.l10n.errorServer),
      invalidUsernameAndPasswordCombination: () => showToast(
        context.l10n.errorInvalidUsernameAndPasswordCombination,
      ),
    );
  }
}

// TODO: use FocusScopeNodes more granular
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
                  const SizedBox(height: 56),
                  const RapidLogo(),
                  const SizedBox(height: 96),
                  Text(
                    context.l10n.login,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  ExampleTextField(
                    placeholder: context.l10n.username,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    onChanged: (username) =>
                        _onUsernameChanged(context, username),
                  ),
                  const SizedBox(height: 16),
                  ExampleTextField(
                    obscureText: true,
                    placeholder: context.l10n.password,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => node.unfocus(),
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
                        onPressed: () => _onGoToSignUpPressed(context),
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
    context
        .read<LoginBloc>()
        .add(LoginEvent.usernameChanged(newUsername: username));
  }

  void _onPasswordChanged(BuildContext context, String password) {
    context
        .read<LoginBloc>()
        .add(LoginEvent.passwordChanged(newPassword: password));
  }

  void _onLoginPressed(BuildContext context) {
    context.read<LoginBloc>().add(const LoginEvent.loginPressed());
  }

  void _onGoToSignUpPressed(BuildContext context) {
    getIt<ISignUpPageNavigator>().navigate(context);
  }
}
