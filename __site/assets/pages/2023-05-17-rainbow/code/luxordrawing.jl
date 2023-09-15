# This file was generated, do not modify it. # hide
w = 1000
h = 600
Drawing(w, h, joinpath(@OUTPUT, "pride.svg"))
origin()
boxes = Tiler(w, h, 6, 1, margin=0)
pride_colors = ["red", "orange", "yellow", "green", "blue", "purple"]
for (i, bx) in enumerate(boxes)
    sethue(pride_colors[i])
    box(boxes, i, :fillstroke)
end
finish()