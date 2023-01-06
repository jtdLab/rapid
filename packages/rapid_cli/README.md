[![Rapid CLI Logo][logo]]

---

Rapid CLI

## Quick Start 🚀

### Installing 🧑‍💻

```sh
dart pub global activate -sgit https://github.com/jtdLab/rapid.git --git-path packages/rapid_cli/
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

TODO other commands

### `rapid doctor`

Get helpful insights into a Rapid project.

```sh
# Show information about an existing Rapid project
rapid doctor
```

[logo]: https://raw.githubusercontent.com/jtdLab/rapid/main/packages/rapid_cli/assets/logo.svg