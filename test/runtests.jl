using Test
using Roentgen
using RoentgenPlots

_check_type(p) = typeof(p) <: RoentgenPlots.AbstractPlot

@testset "Jaws" begin
    jaws = Jaws(sort(rand(2)), sort(rand(2)))
    @test plot_bld(jaws) |> _check_type
    @test axes_lims!(jaws) |> _check_type
end

@testset "MultiLeafCollimator" begin
    mlcx = [-20. 10. -8.  -3.
            -10. 12.  12. 12.]
    mlcy = -10:5.:10
    mlc = MultiLeafCollimator(mlcx, mlcy)

    @test plot_bld(mlc) |> _check_type
    @test plot_bld(mlc; invert=true) |> _check_type
    @test plot_bld(mlc; fill=false) |> _check_type
end

@testset "Bixels" begin
    bixel = Bixel(rand(2), rand(2))
    @test plot_bld(bixel) |> _check_type
    @test plot_bld(bixel, rand()) |> _check_type

    bixels = [Bixel(i*rand(2), i*rand(2)) for i=1:2]
    @test plot_bld(bixels) |> _check_type
    @test plot_bld(bixels, rand(2)) |> _check_type

    bixels = BixelGrid(-10:5.:10,-2.:1.:2)
    @test plot_bld(bixels) |> _check_type
    @test plot_bld(bixels, rand(size(bixels)...)) |> _check_type
end
