```@setup abc
using Roentgen, RoentgenPlots, FileIO, Plots
mlc, w, jaws, bixels = load("assets/plot-data.jld2", "mlc", "w", "jaws", "bixels")
```

# RoentgenPlots.jl

This notebook provides examples of how to plot with RoentgenPlots.jl, along various settings.

![RoentgenPlots.jl example plot](assets/feature-plot.svg)

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

## Bixels

Bixels are 2D rectangular elements defined on the isoplane.
They are also plotted using `plot_bld`,
```@example abc
plot_bld(Bixel(0., 0., 1., 2.))
plot_bld!(Bixel(10., 5., 3., 2.))
```

```@docs
plot_bld!(p::AbstractPlot, bixel::Roentgen.AbstractBixel; kwargs...)
```

The value of the bixel can also be plotted with a colourbar,
```@example abc
plot_bld(Bixel(0., 0., 1., 2.), 0.5)
plot_bld!(Bixel(10., 5., 3., 2.), 1.)
plot_bld!(Bixel(-10., 2., 1., 1.), -0.1)
```

### Collections of Bixels

As well as plotting individual bixels, a collection of bixels can be plotted using the same syntax,
```@example abc
plot_bld(bixels)
```

```@docs 
plot_bld!(p::AbstractPlot, bixels::AbstractArray{<:Roentgen.AbstractBixel}; kwargs...)
```

A vector of values (`w`) can also be supplied to colour the bixels,
```@example abc
plot_bld(bixels, w)
```
