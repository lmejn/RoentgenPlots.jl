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
include("Bixels.jl")

end # module RoentgenPlots
