module RoentgenPlots

using Roentgen
import Roentgen.AbstractBixel

using Plots

""" Plot Functions for Beam Limiting Devices

Plots jaw positions and multileafcollimator apertures.
Sets axes limits to jaw positions
"""

export plot_bld, plot_bld!, axes_lims!, axes_lims

#--- Generic BeamLimitingDevice Plot -----------------------------------------------------------------------------------
"""
    plot_bld(args...; kwargs...)

Plot the geometry of a beam limiting device

Creates a new figure. See ?plot_bld for more information.
"""
plot_bld(args...; kwargs...) = plot_bld!(plot(), args...; kwargs...)

"""
    plot_bld!([p,] args...; kwargs...)

Plot the geometry of a beam limiting device

Creates a 2D plot of the given beam limiting device in the beam limiting device
(BLD) coordinate system, showing their relevant geometry (e.g. aperture
positions for MLC)
    
Use `plot_bld` to create a new plot object, and `plot_bld!` to add to an
existing one.
"""
plot_bld!(args...; kwargs...) = plot_bld!(plot!(), args...; kwargs...)

include("Jaws.jl")
include("MultiLeafCollimator.jl")

#--- Bixels ------------------------------------------------------------------------------------------------------------

rectangle(x, y, wx, wy) = Shape(x.+0.5*wx*[-1, 1, 1, -1], y.+0.5*wy*[-1, -1, 1, 1])

"""
    plot_bld!(p, bixel::AbstractBixel[, value]; kwargs...)

Plot a bixel.

To colour the bixel by a value (*e.g.* for a beamlet weight), can pass an optional
`value` argument.
"""
function plot_bld!(p::AbstractPlot, bixel::AbstractBixel; kwargs...)
    px, py = Roentgen.position(bixel)
    wx, wy = Roentgen.width(bixel)

    plot!(p, rectangle(px, py, wx, wy); aspect_ratio=1, kwargs...)
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

end # module RoentgenPlots
