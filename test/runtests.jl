using Test
using Roentgen
using RoentgenPlots

@testset "Jaws" begin
    jaws = Jaws(sort(rand(2)), sort(rand(2)))
    @test typeof(plot_bld(jaws)) <: RoentgenPlots.AbstractPlot
end
