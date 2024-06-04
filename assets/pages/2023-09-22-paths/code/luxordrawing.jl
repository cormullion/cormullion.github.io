# This file was generated, do not modify it. # hide
using Luxor, Colors # hide

function frame(scene, framenumber)
    translate(boxtopleft())
    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop - 5)
    background("black")
    for (n, path) in enumerate(paths)
        sethue(colors[n])
        pt = drawpath(path, eased_n, action=:stroke)
        sethue("red")
        circle(pt, 5, :fill)
    end 
end

function make_the_kitten_move_again()
    amovie = Movie(w, h, "kitten")
    animate(amovie,
        Scene(amovie, frame, 1:60),
        framerate=10,
        creategif=true,
        pathname="_assets/images/path/tribal-kitten-1.gif")
end

make_the_kitten_move_again()