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