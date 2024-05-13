# alghwalbi_core

alghwalbi_core is a Flutter package designed to simplify state management and provide commonly used components and services for Flutter applications. This package follows the MVC (Model-View-Controller) architecture, making it easy to structure and manage your Flutter projects.

**Note:** This package is primarily intended for personal use, but feel free to use it in your projects.

## Features

- **MVC State Management:** Provides an easy-to-use MVC pattern for managing the state of your Flutter application.
- **Common Components:** Includes commonly used UI components to streamline development.
- **Services:** Offers services commonly needed in Flutter applications, such as API handling, database management, and more.

## Installation

To use alghwalbi_core in your Flutter project, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  alghwalbi_core: <Latest-version>

```
### the steps to use MVC for each module
- create controller extend `CoreController`
- create model extends `BaseModel`
- use `CoreStatefulWidget<Controller>` instead of `StatefulWidget`
- use `CoreState<Statfull,Controller>` instead of `State<Statfull>`
- implement `createController` on your state class

## Recommended project structure  

- modules
  - employee
    - widgets
      - employee_cart.widget.dart
    - employee.controller.dart
    - employee.model.dart
    - employee_form.page.dart
    - employee_list.page.dart
    - employee.service.dart

  - department

- widgets
  - text_filed.widget.dart

- services
  - navigator.service.dart
  - config.service.dart
  - notification.service.dart
  - init.service.dart


## Recommended Naming Convention

1- The file name shall end with `.[TYPE]` like 
**config`.service`.dart**

2- The file name shall separate the multi words name by underscore like **`employee_list`.page.dart**

3- All file/folders shall be lower case letters

4- The name of service function like **addNewOrder()** The Controller Function 	of this service must be **onAddNewOrder()**  
