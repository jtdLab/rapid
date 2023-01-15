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
Create a new Rapid project.

Usage: rapid create <project name> [arguments]
-h, --help          Print this usage information.


-o, --output-dir    The directory where to generate the new project
                    (defaults to ".")
    --desc          The description of the new project.
                    (defaults to "A Rapid app.")
    --org-name      The organization of the new project.
                    (defaults to "com.example")
    --example       Wheter the new project contains example features and their tests.


    --android       Wheter the new project supports the Android platform.
    --ios           Wheter the new project supports the iOS platform.
    --linux         Wheter the new project supports the Linux platform.
    --macos         Wheter the new project supports the macOS platform.
    --web           Wheter the new project supports the Web platform.
    --windows       Wheter the new project supports the Windows platform.

Run "rapid help" to see global options.
```

```sh
# Create a new Rapid project named my_app in the current directory with no platform enabled
rapid create my_app --project-name

# Create a new Rapid project named my_app in the current directory with ios enabled
rapid create my_app --project-name --ios

# Create a new Rapid project named my_app in the current directory with ios, web and macos enabled
rapid create my_app --project-name --ios --web --macos

# Create a new Rapid project named my_app in the current directory with custom description
rapid create my_app --project-name --desc "My new Flutter app"

# Create a new Rapid project named my_app in the current directory with custom organization
rapid create my_app --project-name --org "com.custom.org"

# Create a new Rapid project with some example features named my_app in the current directory with android enabled
rapid create my_app --project-name --example --android
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

### `rapid <platform>`

Work with the <platform> part of an existing Rapid project

### `rapid <platform> add`

Add features and languages to the <platform> part of an existing Rapid project

### `rapid <platform> add feature`

```sh
# Add feature with name my_feature to the <platform> part of an existing Rapid project
rapid <platform> add feature my_feature

# Add feature with name my_feature to the <platform> part of an existing Rapid project with custom description
rapid <platform> add feature my_feature --desc "My cool feature"

# Add routable feature with name my_feature to the <platform> part of an existing Rapid project
rapid <platform> add feature my_feature --routing
```

### `rapid <platform> add language`

```sh
# Add language de to the <platform> part of an existing Rapid project
rapid <platform> add language de
```

### `rapid <platform> feature`

Work with a feature of the <platform> part of and existing Rapid project

### `rapid <platform> feature add`

Add a bloc or cubit to a feature of the <platform> part of an existing Rapid project

### `rapid <platform> feature add bloc`

```sh
# Add bloc named MyBloc to the <platform> feature of an existing Rapid project named my_feature
rapid <platform> feature add bloc My --feature-name my_feature
```

### `rapid <platform> feature add cubit`

```sh
# Add cubit named MyCubit to the <platform> feature of an existing Rapid project named my_feature
rapid <platform> feature add cubit My --feature-name my_feature
```

### `rapid <platform> remove`

Remove features and languages from the <platform> part of an existing Rapid project

### `rapid <platform> remove feature`

```sh
# Remove the feature with name my_feature from the <platform> part of an existing Rapid project
rapid <platform> remove feature my_feature
```

### `rapid <platform> remove language`

```sh
# Remove language de from the <platform> part of an existing Rapid project
rapid <platform> remove language de
```

### `rapid doctor`

Get helpful insights into a Rapid project.

```sh
# Show information about an existing Rapid project
rapid doctor
```

### `rapid domain`

Work with the domain part of an existing Rapid project.

### `rapid domain add`

Add a component to the domain part of an existing Rapid project.

### `rapid domain add entity`

```sh
# TODO doc
rapid domain add entity
```

```sh
# TODO doc
rapid domain add entity --output-dir
```

### `rapid domain add service_interface`

```sh
# TODO doc
rapid domain add service_interface
```

```sh
# TODO doc
rapid domain add service_interface --output-dir
```

### `rapid domain add value_object`

```sh
# TODO doc
rapid domain add value_object
```

```sh
# TODO doc
rapid domain add value_object --output-dir
```

### `rapid domain remove`

Remove a component from the domain part of an existing Rapid project.

### `rapid domain remove entity`

```sh
# TODO doc
rapid domain remove entity
```

```sh
# TODO doc
rapid domain remove entity --dir
```

### `rapid domain remove service_interface`

```sh
# TODO doc
rapid domain remove service_interface
```

```sh
# TODO doc
rapid domain remove service_interface --dir
```

### `rapid domain remove value_object`

```sh
# TODO doc
rapid domain remove value_object
```

```sh
# TODO doc
rapid domain remove value_object --dir
```

### `rapid infrastructure`

Work with the infrastructure part of an existing Rapid project.

### `rapid infrastructure add`

Add a component to the infrastructure part of an existing Rapid project.

### `rapid infrastructure add data_transfer_object`

```sh
# TODO doc
rapid infrastructure add data_transfer_object --entity Foo
```

```sh
# TODO doc
rapid infrastructure add data_transfer_object --entity Foo --output-dir boom/bam
```

### `rapid infrastructure add service_implementation`

```sh
# TODO doc
rapid infrastructure add service_implementation --service Foo
```

```sh
# TODO doc
rapid infrastructure add service_implementation --service Foo --output-dir boom/bam
```

### `rapid infrastructure remove`

Remove a component from the infrastructure part of an existing Rapid project.

### `rapid infrastructure remove data_transfer_object`

```sh
# TODO doc
rapid infrastructure remove data_transfer_object --entity Foo
```

```sh
# TODO doc
rapid infrastructure remove data_transfer_object --entity Foo --dir boom/bam
```

### `rapid infrastructure remove service_implementation`

```sh
# TODO doc
rapid infrastructure remove service_implementation --service Foo
```

```sh
# TODO doc
rapid infrastructure remove service_implementation --service Foo --dir boom/bam
```

### `rapid ui`

Work with the UI part of an existing Rapid project.

### `rapid ui <platform>`

Work with the <platform> UI part of an existing Rapid project.

### `rapid ui <platform> add`

Add components to the <platform> UI part of an existing Rapid project.

### `rapid ui <platform> add widget`

Add widget to the <platform> UI part of an existing Rapid project.

```sh
# TODO doc
rapid ui <platform> add widget Button
```

```sh
# TODO doc
rapid ui <platform> add widget Button --output-dir
```

### `rapid ui <platform> remove`

Remove components from the <platform> UI part of an existing Rapid project.

### `rapid ui <platform> remove widget`

Remove widget from the <platform> UI part of an existing Rapid project.

```sh
# TODO doc
rapid ui <platform> remove widget Button
```

```sh
# TODO doc
rapid ui <platform> remove widget Button --dir
```
