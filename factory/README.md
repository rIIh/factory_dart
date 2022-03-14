# Factory Generator

Factory is created to help define easy to use model factories with predefined field assignment behaviour.

## Usage

See [README.md](../README.md) how to work with package.

# Known Issues

From time to time `analyzer` can't get default value code for formal field parameters.
Often it happen for models with redirected constructor.

If `factory` not able to get default value code it assumes that parameter is required by default.
Only drawback of this that you need provide explicit implementation for `get{Param}` method.

## Workaround:

Run `build_runner clean ; build runner build --delete-conflicting-outputs` to regenerate until factory code is valid;

## Fix (8 September 2021):

This behaviour fixed in `analyzer: 2.0.0` but for now flutter not support it.