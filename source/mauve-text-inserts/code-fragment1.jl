if occursin("mauv", k)
    sethue("cyan")
    box(pt, 2d, 2d, :stroke)
    text(k, pt + (0, 8), halign=:center)
    sethue(col)
    circle(pt, d/2, :fillstroke)
end
