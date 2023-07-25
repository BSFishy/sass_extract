# sass_extract

[![License](https://img.shields.io/github/license/BSFishy/sass_extract)](LICENSE)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/BSFishy/sass_extract/build.yml?logo=github)](https://github.com/BSFishy/sass_extract/actions/workflows/build.yml)
[![NPM Version](https://img.shields.io/npm/v/sass-extract-dart?logo=npm)](https://www.npmjs.com/package/sass-extract-dart)

`sass_extract` is a simple tool to extract Sass variables from source code.

## Example

Given an input file:

```scss
@use 'sass:color';

$primaryColor: #4C4CBF;
$secondaryPalette: ("dark": #871245, "medium": #e01f73, "light": #ed78ab);
$sizes: 10px, 12, 14px, 16, 18px;
$gray: color.mix(#fff, #000, 60%);
```

Results in the following JSON:

```json
{
  "primaryColor": "#4C4CBF",
  "secondaryPalette": {
    "dark": "#871245",
    "medium": "#e01f73",
    "light": "#ed78ab"
  },
  "sizes": [
    "10px",
    12.0,
    "14px",
    16.0,
    "18px"
  ],
  "gray": "#999999"
}
```

## History

Originally, there was the [`sass-extract`](https://www.npmjs.com/package/sass-extract) along with the [`sass-extract-js`](https://www.npmjs.com/package/sass-extract-js).
Combined, those two offered the same functionality of this tool.
However, they relied on the now deprecated [`node-sass`](https://www.npmjs.com/package/node-sass) sass implementation.

Since the functionality was extremely useful, and given both it and the implementation of sass it was based off of were deprecated, I decided to try and find a replacement, so I could migrate to [`dart-sass`](https://www.npmjs.com/package/sass).
However, there weren't any good options to migrate to.
I decided to reimplement it using the Dart API from the [reference sass implementation](https://github.com/sass/dart-sass).

## Installation

To install sass_extract, simply add it as a dev dependency for your project

```commandline
~$ npm install --save-dev sass-extract-dart
# or if you use yarn
~$ yarn add --dev sass-extract-dart
```

Alternatively, if you just want to use the command, you can install it globally

```commandline
~$ npm install --global sass-extract-dart
```

## Usage

### API

sass_extract exposes a small API to perform the extraction.

```typescript
import { extractVariablesFromString } from 'sass-extract-dart';

extractVariablesFromString('$variable: #000;');
```

The `extractVariablesFromString` function also has an options parameter.

```typescript
const contents = /* ... */;

extractVariablesFromString(contents, {
    path: __dirname + '/src',
});
```

| name | required | description |
| --- | --- | --- |
| `path` | no | The path to search for imports in. This includes `@use`, `@import`, `@forward`, etc. |

### Command

Installing sass_extract will also add a command with the same name.

```commandline
~$ sass_extract -o output.json input.scss
```

This command is a wrapper around the `extractVariablesFromString` function, which automatically reads the input file, determines a `path`, and writes it to an output file.
By default, the output file is the same as the input file, but with a `.json` extension.

#### License

<sup>
Licensed under <a href="LICENSE">MIT license</a>.
</sup>
