# RIBsArchitecture Xcode Templates

These templates generate starter files for RIBs built on `RIBsArchitecture`.

## Included Templates

- `RIB`: Internal-access RIB scaffold.
- `RIB (public)`: Public-entry RIB scaffold with generated `*Interface.swift` contract file.
- `RIB Unit Tests`: Swift Testing-based test scaffold.
- `Scope Extension`: Parent-scope dependency extension scaffold.

## Notes

- Interface Builder assets are not generated.
- `XIB` and `Storyboard` options are intentionally unsupported.
- `Owns corresponding view` generates a code-based `ViewController.swift`.
- `RIB (public)` generates `Listener`, `Routing`, `BuildDependency`, and `Buildable` in `*Interface.swift`.

## Installation

Run the install script:

```sh
./install-xcode-template.sh
```

After installation, open Xcode and choose `File > New > File...`.
