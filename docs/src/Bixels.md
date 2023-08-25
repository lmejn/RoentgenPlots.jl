```@setup abc
using Roentgen, RoentgenPlots, FileIO, Plots
w, bixels = load("assets/plot-data.jld2", "w", "bixels")
```

# Bixels

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

## Collections of Bixels

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
