<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->
[![Dart CI](https://github.com/runkaiz/sdartistics/actions/workflows/main.yml/badge.svg)](https://github.com/runkaiz/sdartistics/actions/workflows/main.yml) [![codecov](https://codecov.io/gh/runkaiz/sdartistics/branch/main/graph/badge.svg?token=eFmtCIikp2)](https://codecov.io/gh/runkaiz/sdartistics)

# Sdartistics
A statistics package written in Dart. This package powers [SP2S](https://github.com/yych42/SP2S).

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

Install the Dart SDK on your development machine, then clone this project and begin hacking!

## Usage

See `/example` folder for more details. 

```dart
Future<void> main() async {
  final df = await Table.fromCsv('datasets/incomplete.csv');
  df.print();
}
```

## Additional information

Some commands to run during development:

### Generate Documentation
```shell
foo@bar:~$ dartdoc --output docs
```
I used the `alias` command in Linux so that the command `ddg` would produce the same results, the extra flag is added for GitHub Pages compatibility.