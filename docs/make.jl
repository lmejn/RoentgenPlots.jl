using Documenter, RoentgenPlots, Plots, Roentgen

makedocs(
    sitename="RoentgenPlots.jl",
    modules = [RoentgenPlots],
    pages = [
        "index.md",
        "Beam's Eye View Plots"=>[
            "BeamLimitingDevices.md",
            "Bixels.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/lmejn/RoentgenPlots.jl.git",
)
