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

#--- MultiLeafCollimator Plot ------------------------------------------------------------------------------------------

"""
    plot_bld!(p, mlc::MultiLeafCollimator; kwargs...)

Plot the aperture of a `MultiLeafCollimator` with leaf positions.

Fills the area obstructed by leaves, unless `invert=true` where it fills the open aperture.

Args:
- `invert`: Fills the region **not** obscured by the leaves, defaults to `false`
- `fill`: Whether to fill, defaults to `true`
- `fillalpha`: Transparency of the fill, defaults to 0.1
- `leaf_length`: The length of the leaves, defaults to 125 mm
- Further `kwargs...` are passed to Plots.jl `plot()`
"""
function plot_bld!(p, mlc::MultiLeafCollimator; invert=false, leaf_length=125., fill=true, fillalpha=0.1, kwargs...)

    mlcx = mlc.positions
    mlcy = mlc.edges


    # Set fill=false if fillalpha = 0. (completely transparent)
    if(fill)
        if(fillalpha>0.)
            fill=true
        else
            fill=false
        end
    end

    # Segment the MLC positions
    x, y = segment_mlc(mlcx, mlcy)

    # Plot the first segment
    plot!(p, x[1], y[1]; aspect_ratio=1, kwargs...)
     # If there are more segments, plot them too. primary=False ensures same style as first
    if(length(x)>1)
        plot!(p, x[2:end], y[2:end]; primary=false, kwargs...)
    end

    # If invert==true, fill the inside of the aperture
    if(invert)
        plot!(p, x, y; line=false, primary=false, fill=fill, fillalpha=fillalpha, kwargs...)
    # Otherwise, fill the outside, up to the leaf length
    else
        # Plot the outside edge of the mlc
        x, y = segment_mlc(mlcx .+ leaf_length*[-1., 1.], mlcy)
        plot!(p, x, y; primary=false, kwargs...)
        
        # Fill the areas obstructed by the leaves
        if(fill)
            xB = segmentx(mlcx[1, :], mlcx[1, :].-leaf_length)
            xA = segmentx(mlcx[2, :], mlcx[2, :].+leaf_length)
            y = segmenty(mlcy)
            plot!(p, xB, y; line=false, primary=false, fill=true, fillalpha=fillalpha, kwargs...)
            plot!(p, xA, y; line=false, primary=false, fill=true, fillalpha=fillalpha, kwargs...)
        end
    end
    p
end

"""
    segmentx(xL, xR)

Creates a vector of MLC x positions, used for plotting the position of the
aperture.
"""
function segmentx(xL::Vector{T}, xR::Vector{T}) where T<:Number
    xs = T[]
    n = length(xL)
    for i=1:n
        push!(xs, xL[i])
        push!(xs, xL[i])
    end
    for i=n:-1:1
        push!(xs, xR[i])
        push!(xs, xR[i])
    end
    push!(xs, xL[1])
    xs
end

"""
    segmenty(y)

Creates a vector of MLC y positions, used for plotting the position of the
aperture.
"""
function segmenty(y::AbstractVector{T}) where T<:Number
    ys = T[]
    n = length(y)
    for i=1:n-1
        push!(ys, y[i])
        push!(ys, y[i+1])
    end
    for i=n-1:-1:1
        push!(ys, y[i+1])
        push!(ys, y[i])
    end
    push!(ys, y[1])
    ys
end

"""
    segment_indices(mlcx)

Segment the MLC aperture into separate contained "openings", returning the leaf
index.

The open aperture separates when xB[i] > xA[i+1] or xA[i] < xB[i+1]. This index
is used to remove plotting artefacts.

# Examples
In this case, the aperture has two "openings", at x=-1.->1. and at x=2.->4.
These openings are separated in the y direction, but this information is not
required to separate the openings. 
```julia-repl
julia> mlcx = [-1. -1. 2. 2.;
                1.  1. 4. 4.];
julia> segment_indices(mlcx)
3-element Vector{Int64}:
 1
 3
 5
```
The first aperture opening runs from index 1 -> 2, and the second opening
from index 3 -> 4
"""
function segment_indices(mlcx)
    indices = [1]
    n = size(mlcx, 2)
    for i=1:n-1
        if(mlcx[1, i+1] > mlcx[2, i] || mlcx[1, i] > mlcx[2, i+1])
            push!(indices, i+1)
        end
    end
    push!(indices, n+1)
    indices
end

"""
    segment_mlc(mlcx, mlcy)

Segment the MLC aperture into separate contained "openings", return the x and y
positions of the aperture.

Calls `segment_indices` to get the indices for each section, then `segmentx` 
and `segmenty` to retrieve the positions of the aperture.
"""
function segment_mlc(mlcx::AbstractMatrix{T}, mlcy) where T<:AbstractFloat
    indices = segment_indices(mlcx)
    
    x = Vector{T}[]
    y = Vector{T}[]

    for i=1:length(indices)-1
        i_start = indices[i]
        i_end = indices[i+1]-1

        xi = segmentx(mlcx[1, i_start:i_end], mlcx[2, i_start:i_end])
        yi = segmenty(mlcy[i_start:i_end+1])
        
        push!(x, xi)
        push!(y, yi)
    end
    x, y
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
