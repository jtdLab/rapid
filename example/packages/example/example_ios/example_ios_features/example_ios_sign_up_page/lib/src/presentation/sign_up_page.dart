import 'package:auto_route/auto_route.dart';
import 'package:example_di/example_di.dart';
import 'package:example_ios_navigation/example_ios_navigation.dart';
import 'package:example_ios_sign_up_page/src/application/application.dart';
import 'package:example_ios_sign_up_page/src/presentation/l10n/l10n.dart';
import 'package:example_ui_ios/example_ui_ios.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SignUpPage extends StatefulWidget implements AutoRouteWrapper {
  const SignUpPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignUpBloc>(),
      child: this,
    );
  }

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

// TODO: consider using https://pub.dev/packages/flutter_hooks
class _SignUpPageState extends State<SignUpPage> with ExampleToastMixin {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listenWhen: (_, current) =>
          current is SignUpLoadSuccess || current is SignUpLoadFailure,
      listener: (context, state) => state.mapOrNull(
        loadSuccess: (_) => _onLoadSuccess(context),
        loadFailure: (state) => _onLoadFailure(context, state),
      ),
      child: const SignUpView(),
    );
  }

  void _onLoadSuccess(BuildContext context) {
    getIt<IProtectedRouterNavigator>().replace(context);
  }

  void _onLoadFailure(BuildContext context, SignUpLoadFailure state) {
    final failure = state.failure;
    failure.whenOrNull(
      serverError: () => showToast(context.l10n.errorServer),
      emailAlreadyInUse: () => showToast(context.l10n.errorEmailAlreadyInUse),
      usernameAlreadyInUse: () =>
          showToast(context.l10n.errorUsernameAlreadyInUse),
    );
  }
}

// TODO: use FocusScopeNodes more granular
class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

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
              child: BlocBuilder<SignUpBloc, SignUpState>(
                buildWhen: (_, current) => current is SignUpInitial,
                builder: (context, state) {
                  return Column(
                    children: [
                      const SizedBox(height: 56),
                      const RapidLogo(),
                      const SizedBox(height: 56),
                      Text(
                        context.l10n.signUp,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 32),
                      ExampleTextField.validate(
                        placeholder: context.l10n.email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => node.nextFocus(),
                        onChanged: (email) => _onEmailChanged(context, email),
                        isValid: state.maybeMap(
                          initial: (initial) =>
                              !initial.showErrorMessages ||
                              (initial.showErrorMessages &&
                                  initial.emailAddress.isValid()),
                          orElse: () => true,
                        ),
                        errorMessage: context.l10n.errorInvalidEmailAddress,
                      ),
                      const SizedBox(height: 16),
                      ExampleTextField.validate(
                        placeholder: context.l10n.username,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => node.nextFocus(),
                        onChanged: (username) =>
                            _onUsernameChanged(context, username),
                        isValid: state.maybeMap(
                          initial: (initial) =>
                              !initial.showErrorMessages ||
                              (initial.showErrorMessages &&
                                  initial.username.isValid()),
                          orElse: () => true,
                        ),
                        errorMessage: context.l10n.errorInvalidUsername,
                      ),
                      const SizedBox(height: 16),
                      ExampleTextField.validate(
                        obscureText: true,
                        placeholder: context.l10n.password,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => node.nextFocus(),
                        onChanged: (password) =>
                            _onPasswordChanged(context, password),
                        isValid: state.maybeMap(
                          initial: (initial) =>
                              !initial.showErrorMessages ||
                              (initial.showErrorMessages &&
                                  initial.password.isValid()),
                          orElse: () => true,
                        ),
                        errorMessage: context.l10n.errorInvalidPassword,
                      ),
                      const SizedBox(height: 16),
                      ExampleTextField.validate(
                        obscureText: true,
                        placeholder: context.l10n.passwordAgain,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () => node.unfocus(),
                        onChanged: (passwordAgain) =>
                            _onPasswordAgainChanged(context, passwordAgain),
                        isValid: state.maybeMap(
                          initial: (initial) =>
                              !initial.showErrorMessages ||
                              (initial.showErrorMessages &&
                                  initial.password == initial.passwordAgain &&
                                  initial.password.isValid()),
                          orElse: () => true,
                        ),
                        errorMessage: context.l10n.errorPasswordsDontMatch,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: BlocBuilder<SignUpBloc, SignUpState>(
                          buildWhen: (previous, current) =>
                              previous is SignUpLoadInProgress ||
                              current is SignUpLoadInProgress,
                          builder: (context, state) {
                            return ExamplePrimaryButton(
                              isSubmitting: state is SignUpLoadInProgress,
                              text: context.l10n.signUp,
                              onPressed: () => _onSignUpPressed(context),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.l10n.alreadyHaveAnAccount,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 6),
                          ExampleLinkButton(
                            text: context.l10n.login,
                            onPressed: () => _onGoToLoginPressed(context),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _onEmailChanged(BuildContext context, String newEmailAddress) {
    context
        .read<SignUpBloc>()
        .add(SignUpEvent.emailChanged(newEmailAddress: newEmailAddress));
  }

  void _onUsernameChanged(BuildContext context, String newUsername) {
    context
        .read<SignUpBloc>()
        .add(SignUpEvent.usernameChanged(newUsername: newUsername));
  }

  void _onPasswordChanged(BuildContext context, String newPassword) {
    context
        .read<SignUpBloc>()
        .add(SignUpEvent.passwordChanged(newPassword: newPassword));
  }

  void _onPasswordAgainChanged(BuildContext context, String newPasswordAgain) {
    context.read<SignUpBloc>().add(
          SignUpEvent.passwordAgainChanged(newPasswordAgain: newPasswordAgain),
        );
  }

  void _onSignUpPressed(BuildContext context) {
    context.read<SignUpBloc>().add(const SignUpEvent.signUpPressed());
  }

  void _onGoToLoginPressed(BuildContext context) {
    getIt<ILoginPageNavigator>().navigate(context);
  }
}
