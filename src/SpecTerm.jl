# Notes: FPS is currently implemented via a sleep() function.
#        For keyboad inputs, we are using getch(), which is typically blocking
#        and waiting for input. Do we need more robust keyboard handling?
module SpecTerm

    include("objects/objects.jl")
    include("objects/dialogue.jl")
    include("run/init.jl")
    include("run/runtest.jl")

end
