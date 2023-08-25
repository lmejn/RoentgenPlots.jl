```@setup abc
using Roentgen, RoentgenPlots, FileIO
mlc, w, jaws, bixels = load("assets/plot-data.jld2", "mlc", "w", "jaws", "bixels")
```

# RoentgenPlots.jl

This notebook provides examples of how to plot with RoentgenPlots.jl, along various settings.

RoentgenPlots.jl provides two methods for plotting beam-limiting device positions `plot_bld` and `plot_bld!` functions:

- `plot_bld(bld::AbstractBeamLimitingDevice; kwargs...)` takes beam-limiting device types as defined in Roentgen.jl and plots them on a new figure
- `plot_bld!([p,] bld::AbstractBeamLimitingDevice; kwargs...)` adds beam-limiting device plots to existing figures

Following the notation used in Plots.jl, `plot_bld` creates a new figure, while `plot_bld!` adds to an existing plot (which can be specified by providing `p`).


## Jaws

Calling `plot_bld` with jaws will plot a simple rectangle where the jaw positions lie,
```@example abc
    plot_bld(jaws)
```

```@docs
plot_bld!(p, jaws::Jaws; kwargs...)
```

## Multi-Leaf Collimator 

Calling `plot_bld!` with an MLC fills in the region obscured by the leaves.

```@example abc
plot_bld(mlc)
```

```@docs
plot_bld!(p, mlc::MultiLeafCollimator; kwargs...)
```

Here, `plot_bld!` is used to add to an existing figure:

```@example abc
plot_bld(mlc; label="Default")
plot_bld!(mlc+(25., 30.); invert=true, fillalpha=0.8, label="Inverted")
plot_bld!(mlc-(50., 50.); fill=false, label="No fill")
```
