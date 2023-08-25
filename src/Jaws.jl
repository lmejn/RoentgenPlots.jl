
#--- Jaws Plot ---------------------------------------------------------------------------------------------------------

"""
    plot_bld!(p, jaws::Jaws; kwargs...)

Plot the jaw positions.

`kwargs...` are passed to Plots.jl `plot()`
"""
function plot_bld!(p, jaws::Jaws; kwargs...)
    # Create a box out of the four jaw positions
    x = vcat(jaws.x[1], jaws.x[2], jaws.x[2], jaws.x[1], jaws.x[1])
    y = vcat(jaws.y[1], jaws.y[1], jaws.y[2], jaws.y[2], jaws.y[1])

    plot!(p, x, y; aspect_ratio=1, kwargs...)
end
