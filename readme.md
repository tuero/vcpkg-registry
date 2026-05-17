Personal vcpkg registry, triplets, and toolchain files.

## Packages supported
The following packages are supported
- [arcade-learning-environment](https://github.com/farama-foundation/arcade-learning-environment):The Arcade Learning Environment (ALE) -- a platform for AI research. 
- [boulderdash](https://github.com/tuero/boulderdash_cpp): Simple gridworld environment implementation of Boulderdash/Emerald Mine style games.
- [craftworld](https://github.com/tuero/craftworld_cpp_v2): A modified implementation of the Craftworld environment from [Modular Multitask Reinforcement Learning with Policy Sketches](https://arxiv.org/pdf/1611.01796.pdf).
- [libpolicyts](https://github.com/tuero/libpolicyts): Library for policy tree search algorithms and auxiliary utilities.
- [muzero](https://github.com/tuero/muzero-cpp): A C++ implementation of MuZero.
- [sokoban](https://github.com/tuero/sokoban_cpp): Implementation of Sokoban.
- [tensorboard-logger](https://github.com/RustingSword/tensorboard_logger): Standalone C++ API to log data in TensorBoard format, without any code dependency on TensorFlow or TensorBoard..
- [tinytensor](https://github.com/tuero/tinytensor): Multi-dimensional array + automatic differentiation library with CUDA acceleration.
- [tsp](https://github.com/tuero/tsp_cpp): Implementation of the TSP environment in a gridworld.


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
    "packages": [
        "arcade-learning-environment",
        "boulderdash",
        "craftworld",
        "libpolicyts",
        "muzero",
        "sokoban",
        "tsp",
        "tensorboard-logger",
        "tinytensor",
        "tsp"
    ]
}
]
...
```
where `<COMMIT_SHA>` is the 40-character git commit sha in the registry's repository (you can find 
this by clicking on the latest commit [here](https://github.com/tuero/vcpkg-registry) and looking 
at the URL.
You can also find the latest `<COMMIT_SHA>` by entering the following:
```shell
git ls-remote https://github.com/tuero/vcpkg-registry HEAD
```


## Adding a repository to this registry
Copy one of the `ports/` files and make a new directory for the package.


To get the SHA512, remove the package if it exists, try to add it again
with a `SHA512 0`, 
and look at the error message to get the SHA512.
```shell
vcpkg remove MY_PACKAGE
vcpkg install MY_PACKAGE --overlay-ports=./ports
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

When using GCC on OSX, libstdc++ expects `quick_exit`/`at_quick_exit` to be visible in the SDK headers, which requires `_DARWIN_C_SOURCE`.
The OSX toolchain sets this when using GCC.
See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=93469

Additionally, [libpolicyts](https://github.com/tuero/libpolicyts) uses the environment variable `LIBTORCH_ROOT` to libtorch 
(usually from a conda environment),
but this is not part of the vcpkg pacakge ABI by default.
This is usually done in the triplets, which can put environment variables into the ABI,
which is what the included triplets do.

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

To use the toolchain directly when invoking cmake:
```
cmake --toolchain <PATH>/toolchains/<FILE>.cmake <ARGS> ..
```

