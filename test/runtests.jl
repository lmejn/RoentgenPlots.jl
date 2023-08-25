using Test
using Roentgen
using RoentgenPlots

@testset "Jaws" begin
    jaws = Jaws(sort(rand(2)), sort(rand(2)))
    @test typeof(plot_bld(jaws)) <: RoentgenPlots.AbstractPlot
    @test typeof(axes_lims!(jaws)) <: RoentgenPlots.AbstractPlot
end

@testset "MultiLeafCollimator" begin
    mlcx = [-20. 10. -8.  -3.
            -10. 12.  12. 12.]
    mlcy = -10:5.:10
    mlc = MultiLeafCollimator(mlcx, mlcy)

    @test typeof(plot_bld(mlc)) <: RoentgenPlots.AbstractPlot
    @test typeof(plot_bld(mlc; invert=true)) <: RoentgenPlots.AbstractPlot
    @test typeof(plot_bld(mlc; fill=false)) <: RoentgenPlots.AbstractPlot
end
