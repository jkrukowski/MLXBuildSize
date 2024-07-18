# MLXBuildSize

This is a simple repository to test the size of the build that contains the `mlx-swift` library.

## Usage

Compile it

```bash
xcodebuild clean build \
    -configuration Release \
    -scheme mlxbuildsize-cli \
    -destination generic/platform=macOS \
    -derivedDataPath .build/.xcodebuild/ \
    -clonedSourcePackagesDirPath .build/
```

Then check the size of the build

```bash
du -sh * | sort -h
```

```bash
size Cmlx.o
```

## Results

MacBook Air M1, 2020, MacOS Sonoma 14.5, XCode 15.4

```
  0B	PackageFrameworks
 36K	Numerics.o
 36K	_NumericsShims.o
 40K	MLXFast.o
 64K	Numerics.swiftmodule
 64K	mlxbuildsize_cli.swiftmodule
 68K	MLXFFT.o
 80K	MLXFast.swiftmodule
108K	MLXBuildSize.o
108K	MLXRandom.o
136K	MLXBuildSize.swiftmodule
176K	MLXFFT.swiftmodule
256K	MLXRandom.swiftmodule
264K	RealModule.o
316K	ComplexModule.o
440K	ComplexModule.swiftmodule
468K	RealModule.swiftmodule
1.2M	MLXNN.swiftmodule
2.0M	MLXNN.o
2.4M	MLX.o
2.5M	MLX.swiftmodule
7.4M	mlx-swift_Cmlx.bundle
 23M	mlxbuildsize-cli
 26M	Cmlx.o
199M	mlxbuildsize-cli.dSYM
```

```bash
__TEXT	__DATA	__OBJC	others	dec	hex
7662442	82105	0	301664	8046211	7ac683	Cmlx.o (for architecture x86_64)
5919267	84225	0	297376	6300868	6024c4	Cmlx.o (for architecture arm64)
```