[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://lmejn.github.io/RoentgenPlots.jl/stable/)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://lmejn.github.io/RoentgenPlots.jl/dev)
[![CI](https://github.com/lmejn/RoentgenPlots.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/lmejn/RoentgenPlots.jl/actions/workflows/CI.yml)

# RoentgenPlots.jl

RoentgenPlots.jl provides functions to plot using [Plots.jl](https://docs.juliaplots.org) datatypes defined in [Roentgen.jl](https://github.com/Image-X-Institute/Roentgen.jl).

![Aperture Example](docs/src/assets/feature-plot.svg)

## Installation

1. Navigate to your project
2. Open the Julia REPL
3. *[Optional]* Activate a new environment
4. Enter package mode by typing `]`
5. Install using 
    ```julia
    add https://github.com/lmejn/RoentgenPlots.jl
    ```

## Usage

Import the package using,
```julia
using RoentgenPlots
```

The two main function are:
```julia
plot_bld(args...; kwargs...)
```
To plot the geometry of beam-limiting devices. Currently supported devices are:

- Multi-Leaf Collimator
- Jaws
- Bixels

```julia
axes_lims!(args...; kwargs...)
```
To set the axes limits of the figure based on the geometry of the beam-limiting device.

See the example [notebook](https://github.com/lmejn/RoentgenPlots.jl/blob/main/examples/Plotting%20Beam%20Limiting%20Devices.ipynb) for usage.


