Personal vcpkg registry, triplets, and toolchain files.

## Packages supported
The following packages are supported
- [tinytensor](https://github.com/tuero/tinytensor)


## Using this registry
Create your vcpkg project
```shell
vcpkg new --application
```

To add `tuero/vcpkg-registry` as a git registry to your vcpkg project:
```json
"registries": [
...
{
    "kind": "git",
    "repository": "https://github.com/tuero/vcpkg-registry",
    "reference": "master",
    "baseline": "<COMMIT_SHA>",
    "packages": ["tinytensor"]
}
]
...
```
where `<COMMIT_SHA>` is the 40-character git commit sha in the registry's repository (you can find 
this by clicking on the latest commit [here](https://github.com/tuero/vcpkg-registry) and looking 
at the URL.


## Adding a repository to this registry
Copy one of the `ports/` files and make a new directory for the package.


To get the SHA512, remove the package if it exists, try to add it again
with a `SHA512 0`, 
and look at the error message to get the SHA512.
```shell
vcpkg remove MY_PACKAGE
vcpkg install MY_PACKAGE --overlay-ports=vcpkg-registry/ports
```

Then, update the versions database (below)


## Updating the verions database
Run the following
```shell
vcpkg --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions x-add-version --all --verbose
```

## Toolchains and Triplets
The default vcpkg toolchains do not respect the `CC` and `CXX` environment variables.
I've copied those defaults, but made the following changes:
- Respects `CC`, `CXX`, and `FC` 
- Disables cross compiling

I've made versions for Linux/OSX (arm64), with both dynamic and static linking.
To use these toolchains/triplets, set the following cache variables (preferably in `CMakePresets.json`)
```json
"cacheVariables": {
    "CMAKE_TOOLCHAIN_FILE": "$env{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake",
    "VCPKG_OVERLAY_TRIPLETS": "${sourceDir}/cmake/triplets",
    "VCPKG_TARGET_TRIPLET": "x64-linux-static",
    "VCPKG_HOST_TRIPLET": "x64-linux-static",
    "VCPKG_CHAINLOAD_TOOLCHAIN_FILE": "${sourceDir}/cmake/toolchains/linux-toolchain.cmake"
}

```

