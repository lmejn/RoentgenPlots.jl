
#--- Jaws Plot ---------------------------------------------------------------------------------------------------------

"""
    plot_bld!(p, jaws::Jaws; kwargs...)

Plot the jaw positions.

`kwargs...` are passed to Plots.jl `plot`
"""
function plot_bld!(p, jaws::Jaws; kwargs...)
    # Create a box out of the four jaw positions
    x = [jaws.x[1], jaws.x[2], jaws.x[2], jaws.x[1], jaws.x[1]]
    y = [jaws.y[1], jaws.y[1], jaws.y[2], jaws.y[2], jaws.y[1]]

    plot!(p, x, y; aspect_ratio=1, kwargs...)
end

#--- Axes Limits -------------------------------------------------------------------------------------------------------

"""
    axes_lims!(p, jaws::Jaws; pad=10.)

Set the axes limits to the position of the jaws.

By default, a pad of 10 mm is added to each side.
"""
function axes_lims!(p, jaws::Jaws; pad=10.)
    padding = pad.*[-1, 1]
    plot!(p, xlim=jaws.x .+ padding, ylim=jaws.y .+ padding)
end

"""
    axes_lims!(jaws::Jaws; pad=10.)

When no plot object given, applies to latest plot created.
"""
axes_lims!(jaws::Jaws; pad=10.) = axes_lims!(plot!(), jaws; pad=pad)
