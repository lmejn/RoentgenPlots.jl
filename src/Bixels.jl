#--- Bixels ------------------------------------------------------------------------------------------------------------

_rectangle(x, y, wx, wy) = Shape(x.+0.5*wx*[-1, 1, 1, -1], y.+0.5*wy*[-1, -1, 1, 1])

"""
    plot_bld!(p, bixel::AbstractBixel[, value]; kwargs...)

Plot a bixel.

To colour the bixel by a value (*e.g.* for a beamlet weight), can pass an optional
`value` argument.
"""
function plot_bld!(p::AbstractPlot, bixel::AbstractBixel; kwargs...)
    px, py = Roentgen.getedge(bixel)
    wx, wy = Roentgen.getwidth(bixel)

    plot!(p, _rectangle(px, py, wx, wy); aspect_ratio=1, kwargs...)
end

function plot_bld!(p::AbstractPlot, bixel::AbstractBixel, value; kwargs...)
    plot_bld!(p, bixel; line_z=value, fill_z=value, kwargs...)
end

"""
    plot_bld!(p, bixel::AbstractArray{<:AbstractBixel}[, value::AbstractArray]; kwargs...)

Plot a collection of bixels.

To colour the bixels by a value (*e.g.* for a beamlet weight), can pass an optional
`value` array.
"""
function plot_bld!(p::AbstractPlot, bixels::AbstractArray{<:AbstractBixel};
                   kwargs...)

    for i in eachindex(bixels)
        plot_bld!(p, bixels[i]; primary=false, kwargs...)
    end

    p
end

function plot_bld!(p::AbstractPlot, bixels::AbstractArray{<:AbstractBixel},
                   value::AbstractArray{<:Real}; kwargs...)

    @assert length(bixels) == length(value)

    for i in eachindex(bixels, value)
        plot_bld!(p, bixels[i], value[i]; primary=false, kwargs...)
    end

    p
end