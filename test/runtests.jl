using Test
using Roentgen
using RoentgenPlots

_check_type(p) = typeof(p) <: RoentgenPlots.AbstractPlot

@testset "Jaws" begin
    jaws = Jaws(sort(rand(2)), sort(rand(2)))
    @test _check_type(plot_bld(jaws))
    @test _check_type(axes_lims!(jaws))
end

@testset "MultiLeafCollimator" begin
    mlcx = [-20. 10. -8.  -3.
            -10. 12.  12. 12.]
    mlcy = -10:5.:10
    mlc = MultiLeafCollimator(mlcx, mlcy)

    @test _check_type(plot_bld(mlc))
    @test _check_type(plot_bld(mlc; invert=true))
    @test _check_type(plot_bld(mlc; fill=false))
end

@testset "Bixels"
    bixel = Bixel(rand(2), rand(2))
    plot_bld

