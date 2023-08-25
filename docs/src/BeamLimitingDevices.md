```@setup abc
using Roentgen, RoentgenPlots, FileIO, Plots
mlc, jaws = load("assets/plot-data.jld2", "mlc", "jaws")
```

# Beam-Limiting Devices

## Jaws

Calling `plot_bld` with jaws will plot a simple rectangle where the jaw positions lie,
```@example abc
    plot_bld(jaws)
```

```@docs
plot_bld!(p, jaws::Jaws; kwargs...)
```

### Axes Limits

As well as plotting the positions of the jaws, the axis limits can also be set based on the jaw positions,
```@example abc
    axes_lims!(jaws)
```

```@docs 
axes_lims!(p, jaws::Jaws; pad=10.)
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
