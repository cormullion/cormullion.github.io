# This file was generated, do not modify it. # hide
tempfile = joinpath(@OUTPUT, "_d16.svg")

Drawing(1200, 550, tempfile)
origin()
background("#ededed")

panes = Tiler(1200, 550, 1, 2)

t = "“
Of course it is necessary that the mathematically-defined letters be beautiful according to traditional notions of aesthetics. Given a sequence of points in the plane, what is the most pleasing curve that connects them? This question leads to interesting mathematics, and one solution based on a novel family of spline curves has produced excellent [SIC] fonts of type in the author’s preliminary experiments.
” [Donald Knuth]"

@layer begin
    fontface("LibreBaskerville-Regular")
    fontsize(24)
    bbx = BoundingBox(box(panes, 1)) * 0.9
    textwrap(t, boxwidth(bbx), boxtopleft(bbx), leading=40)
end

@layer begin
    # Baskerville font with the "e" replaced with the Comic Sans one
    fontface("BaskervilleComic")
    fontsize(24)
    bbx = BoundingBox(box(panes, 2)) * 0.9
    textwrap(t, boxwidth(bbx), boxtopleft(bbx), leading = 40)
end
finish()
tidysvg(joinpath(@OUTPUT, "_d16.svg"), joinpath(@OUTPUT, "d16.svg"))