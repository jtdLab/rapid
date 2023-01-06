<img src="./assets/logo_black.svg#gh-dark-mode-only" height="100">
<img src="./assets/logo_white.svg#gh-light-mode-only" height="100">

---

Create well architectured Flutter Apps fast with Rapid CLI.

## Quick Start 🚀

### Installing 🧑‍💻

```sh
flutter pub global activate melos
```

```sh
flutter pub global activate -sgit https://github.com/jtdLab/rapid.git --git-path packages/rapid_cli/
```

### Commands

### `rapid create`

Quickly create a Rapid project.

```sh
Creates a new Rapid project in the specified directory.

Usage: rapid create <output directory>
-h, --help            Print this usage information.


    --project-name    The name of this new project. This must be a valid dart package name.
    --desc            The description of this new project.
                      (defaults to "A Rapid app.")
    --org-name        The organization of this new project.
                      (defaults to "com.example")
    --example         Wheter this new project contains example features and their tests.


    --android         Wheter this new project supports the Android platform.
    --ios             Wheter this new project supports the iOS platform.
    --linux           Wheter this new project supports the Linux platform.
    --macos           Wheter this new project supports the macOS platform.
    --web             Wheter this new project supports the Web platform.
    --windows         Wheter this new project supports the Windows platform.

Run "rapid help" to see global options.
```

```sh
# Create a new Rapid project named my_app in the current directory with no platform enabled
rapid create . --project-name my_app

# Create a new Rapid project named my_app in the current directory with ios enabled
rapid create . --project-name my_app --ios

# Create a new Rapid project named my_app in the current directory with ios, web and macos enabled
rapid create . --project-name my_app --ios --web --macos

# Create a new Rapid project named my_app in the current directory with custom description
rapid create . --project-name my_app --desc "My new Flutter app"

# Create a new Rapid project named my_app in the current directory with custom organization
rapid create . --project-name my_app --org "com.custom.org"

# Create a new Rapid project with some example features named my_app in the current directory with android enabled
rapid create . --project-name my_app --example --android
```

---

### `rapid activate`

Add a platform to an existing Rapid project.

```sh
# Add Android to an existing Rapid project
rapid activate android

# Add iOS to an existing Rapid project
rapid activate ios

# Add Linux to an existing Rapid project
rapid activate linux

# Add macOS to an existing Rapid project
rapid activate macos

# Add Web to an existing Rapid project
rapid activate web

# Add Windows to an existing Rapid project
rapid activate windows
```

### `rapid deactivate`

Remove a platform from an existing Rapid project.

```sh
# Remove Android from an existing Rapid project
rapid deactivate android

# Remove iOS from an existing Rapid project
rapid deactivate ios

# Remove Linux from an existing Rapid project
rapid deactivate linux

# Remove macOS from an existing Rapid project
rapid deactivate macos

# Remove Web from an existing Rapid project
rapid deactivate web

# Remove Windows from an existing Rapid project
rapid deactivate windows
```

### `rapid android`

Work with the Android part of an existing Rapid project

### `rapid android add`

Add features and languages to the Android part of an existing Rapid project

### `rapid android add feature`

```sh
# Add feature with name my_feature to the Android part of an existing Rapid project
rapid android add feature my_feature

# Add feature with name my_feature to the Android part of an existing Rapid project with custom description
rapid android add feature my_feature --desc "My cool feature"
```

### `rapid android add language`

```sh
# Add language de to the Android part of an existing Rapid project
rapid android add language de
```

### `rapid android feature`

Work with a feature of the Android part of and existing Rapid project

### `rapid android feature add`

Add a bloc or cubit to a feature of the Android part of an existing Rapid project

### `rapid android feature add bloc`

```sh
# Add bloc named MyBloc to the Android feature of an existing Rapid project named my_feature
rapid android feature add bloc My --feature-name my_feature
```

### `rapid android feature add cubit`

```sh
# Add cubit named MyCubit to the Android feature of an existing Rapid project named my_feature
rapid android feature add cubit My --feature-name my_feature
```

### `rapid android remove`

Remove features and languages from the Android part of an existing Rapid project

### `rapid android remove feature`

```sh
# Remove the feature with name my_feature from the Android part of an existing Rapid project
rapid android remove feature my_feature
```

### `rapid android remove language`

```sh
# Remove language de from the Android part of an existing Rapid project
rapid android remove language de
```

### `rapid doctor`

Get helpful insights into a Rapid project.

```sh
# Show information about an existing Rapid project
rapid doctor
```
