# @def published = "2019-04-03 00:00:00 +0000"
# @def title = "Pentachoron"
# @def authors = """Cormullion"""
# @def hascode = true
# @def hasmath = true
# @def rss = """I encountered the word \"pentachoron\" recently for the first time, and I thought it had to be something cool. Turns out it is, so I thought I'd have a go at drawing one... Unfortunately, it's a 4-dimensional object, which is going to tax my limited 2D skills. ![pentachoron](assetes/images/pentachoron/header-image.svg))"""
# @def rss_pubdate = Date(2019, 4, 3)
# @def rss_author = "cormullion"

# > This page contains quite a few animated GIFs. I apologise in advance if your browser or network connection doesn’t like them. It’s much easier to add a GIF than it is to embed a video into a GitHub pages blog, unfortunately.

# ![image label](IMAGEFOLDER/header-image.svg)

# I encountered the word “pentachoron’ recently for the first time, and I thought it had to be something cool. Turns out it is, so I thought I’d have a go at drawing one...

# Unfortunately, it’s a 4-dimensional object, which is going to tax my limited 2D skills. But I like being out of my depth.

# ## First steps

# The first job is to define a couple of types to help organize all the various points.

# Here’s an immutable structure to hold the coordinates of a point in four dimensions. In four dimensions, the axes are usually called `x`, `y`, `z`, and `w`.

struct Point4D{T} <: AbstractArray{T, 1}
    x::T
    y::T
    z::T
    w::T
end

Point4D(a::Array{T, 1}) where T <: Real = Point4D(a...)

Base.size(pt::Point4D) = (4, )

Base.getindex(pt::Point4D, i) = [pt.x, pt.y, pt.z, pt.w][i]

# By adopting the AbstractArray as our stepmother type, we can pick up many useful behaviors. `size()` and `getindex()` can be taught how to handle Point4Ds. If you browse the [official documentation](https://docs.julialang.org/en/v1/manual/interfaces/#man-interface-array-1) for a while you’ll find out how to effectively tap in to many desirable pre-defined abilities that our new type can inherit.

# While we’re here, let’s do three-dimensional points as well:

struct Point3D{T} <: AbstractArray{T, 1}
    x::T
    y::T
    z::T
end

Base.size(pt::Point3D) = (3, )

# ## Conversion

# The primary task we have to address is how to convert a 4D point into a 2D point. Let’s start with the easier task: how to convert a 3D point into a 2D point, ie how can we draw a 3D shape on a flat surface?

# Consider a simple cube. The front face and the back face could have the same X and Y coordinates, and vary only by their Z values.

# (This is just a diagram, it’s not really 3D...)

# ![image label](IMAGEFOLDER/cube.svg)

using Luxor

@svg begin
    fontface("Menlo")
    fontsize(8)
    setblend(blend(
    boxtopcenter(BoundingBox()),
    boxmiddlecenter(BoundingBox()),
    "skyblue",
    "white"))
    box(boxtopleft(BoundingBox()),
    boxmiddleright(BoundingBox()), :fill)

    setblend(blend(
    boxmiddlecenter(BoundingBox()),
    boxbottomcenter(BoundingBox()),
    "grey95",
    "grey45"
    ))
    box(boxmiddleleft(BoundingBox()),
    boxbottomright(BoundingBox()), :fill)

    sethue("black")
    setline(2)
    bx1 = box(O, 250, 250, vertices=true)
    poly(bx1, :stroke, close=true)
    label.(["-1/1/1", "-1/-1/1", "1/-1/1", "1/1/1"],
    slope.(O, bx1), bx1)

    setline(1)
    bx2 = box(O, 150, 150, vertices=true)
    poly(bx2, :stroke, close=true)
    label.(["-1/1/0", "-1/-1/0", "1/-1/0", "1/1/0"],
    slope.(O, bx2), bx2, offset=-45)

    map((x, y) -> line(x, y, :stroke), bx1, bx2)
end 500 500 "../images/pentachoron/cube.svg"

# So the idea is to project the cube from 3D to 2D by keeping the first two values, and multiplying or modifying them by the third value. We’ll make a `convert()` function to do this:

function Base.convert(type::Type{Point}, pt3::Point3D)
    k = 1/(K - pt3.z)
    return Point(pt3.x * k, pt3.y * k)
end

# `K` is just a constant which provides a consistent value for depth:

const K = 4.0

# Testing this quickly in Luxor.jl gives promising results:

@svg begin
    cube = [
    Point3D(-1, -1,  1),
    Point3D(-1,  1,  1),
    Point3D( 1, -1,  1),
    Point3D( 1,  1,  1),
    Point3D(-1, -1, -1),
    Point3D(-1,  1, -1),
    Point3D( 1, -1, -1),
    Point3D( 1,  1, -1),
    ]
    circle.(convert.(Point, cube) * 300, 5, :fill)
end 500 500 "../images/pentachoron/basic3_to_2.png"

# ![image label](IMAGEFOLDER/basic3_to_2.png)

# It’s a simple type of perspective projection.

# Using the same principle, let’s make a method for converting a 4D point.

function Base.convert(::Type{Point3D}, pt4::Point4D)
    k = 1/(K - pt4.w)
    return Point3D(pt4.x * k, pt4.y * k, pt4.z * k)
end

# Let’s hope it works.

# We can combine these into a single utility function called `flatten()` that takes a list of 4D points and double-maps them into a list of 2D points suitable for drawing.

function flatten(shape4)
    return map(pt3 -> convert(Point, pt3), map(pt4 -> convert(Point3D, pt4), shape4))
end

# ## Going up a level

# To test this, we’ll define the vertices of a unit pentachoron:

const n = -1/√5

const pentachoron = [Point4D(vertex...) for vertex in [
[ 1.0,  1.0,  1.0, n],
[ 1.0, -1.0, -1.0, n],
[-1.0,  1.0, -1.0, n],
[-1.0, -1.0,  1.0, n],
[ 0.0,  0.0,  0.0, n + √5]]]

#

#-

# (According to [Wikipedia](https://en.wikipedia.org/wiki/5-cell), other names for the pentachoron include:

# * Regular 5-cell
# * C5
# * pentatope
# * pentahedroid
# * tetrahedral pyramid
# * 4-simplex

# I think *pentachoron* is the coolest, though.)

#-

#

# Here’s a list of “faces”, with each face defined by three of the vertices:

const pentachoronfaces = [
[1, 2, 3],
[1, 2, 4],
[1, 2, 5],
[1, 3, 4],
[1, 3, 5],
[1, 4, 5],
[2, 3, 4],
[2, 3, 5],
[2, 4, 5],
[3, 4, 5]]

# A quick test:

@svg begin
    setopacity(0.2)
    pentachoron2D = flatten(pentachoron)
    for (n, face) in enumerate(pentachoronfaces)
        randomhue()
        poly(1500 * pentachoron2D[face], :fillpreserve, close=true)
        sethue("black")
        strokepath()
    end
end 600 250 "../images/pentachoron/firstdraw.svg"

# ![image label](IMAGEFOLDER/firstdraw.svg)

# This isn’t very interesting, although I *think* it’s correct. To see a more appealing display, let’s make it dance...

# ## Swings and roundabouts

# You usually rotate 2D points about a 1D point. You usually rotate 3D points about a 2D line (often one of the XYZ axes). So logically you’d rotate 4D points with reference to a 3D plane. We’ll define some matrices that do 4D rotations relative to a plane defined by two of the X, Y, Z, and W axes.

# As I’m thinking about it, the XY plane is typically the plane of the drawing surface. If you think of the XY plane as a computer screen straight in front of you, the XZ plane is parallel to your desk or floor, and the YZ plane is like a wall beside your desk on your right or left side.

# But what about the XW plane? And the YW and ZW planes, for that matter? This is the mystery of 4D shapes: we can’t see these planes, we can only imagine their existence by watching shapes moving through and around them.

# Here’s a function that generates a suitable rotation matrix for rotating a 4D point in the XY plane:

function XY(θ)
    [cos(θ)   -sin(θ)  0        0;
    sin(θ)    cos(θ)   0        0;
    0         0        1        0;
    0         0        0        1]
end

# and here’s another one that rotates a 4D point in the XW plane:

function XW(θ)
    [cos(θ)   0        0        -sin(θ);
    0         1        0        0;
    0         0        1        0;
    sin(θ)    0        0        cos(θ)]
end

# Oh, it looks like we’re having a matrix party, so we might as well do the others while we’re here:

function XZ(θ)
    [cos(θ)   0        -sin(θ)  0;
    0         1        0        0;
    sin(θ)    0        cos(θ)   0;
    0         0        0        1]
end


function YZ(θ)
    [1        0        0        0;
    0         cos(θ)   -sin(θ)  0;
    0         sin(θ)   cos(θ)   0;
    0         0        0        1]
end

function YW(θ)
    [1        0        0        0;
    0         cos(θ)   0        -sin(θ);
    0         0        1        0;
    0         sin(θ)   0        cos(θ)]
end

function ZW(θ)
    [1        0        0        0;
    0         1        0        0;
    0         0        cos(θ)   -sin(θ);
    0         0        sin(θ)   cos(θ)];
end

# We’ll make a handy utility function that uses one of these matrix functions to rotate an array of 4D points `A` in the plane defined by the matrix function:

function rotate4(A, matrixfunction)
    return map(A) do pt4
    Point4D(matrixfunction * pt4)
end
end

# So we can write `rotate4(A, XW(π/2))` to rotate the array of points in `A` in the XW plane by π/2. We can also write `rotate4(A, XW(π/2) * XY(π/2))` to rotate the points first in the XW plane and then in the XY plane.

# Notice that the `rotate4()` function returns a new array, rather than modifying the original one. This probably has some disadvantages, but for now it means that we don’t have to keep track of mutating objects so carefully.

# ## It moves

# We’re now able to make an animation that rotates our pentachoron in one or more planes.

# The `frame()` function generates a single frame, using the framenumber (`eased_n` provides a normalized version of the framenumber modulated by the easing function) to control the rotation between 0 and 2π. The scalefactor makes the unit shape big enough to fill the frame.

# It’s helpful to color the faces very slightly, using `poly(..., :fill)`-er.

using ColorSchemes

function frame(scene, framenumber, scalefactor=1000)
background("antiquewhite")
setlinejoin("bevel")
setline(1.0)
sethue("black")
eased_n       = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)
pentachoron′  = rotate4(pentachoron, XZ(eased_n * 2π))
pentachoron2D = flatten(pentachoron′)

setopacity(0.2)
for (n, face) in enumerate(pentachoronfaces)
    sethue(get(ColorSchemes.diverging_rainbow_bgymr_45_85_c67_n256,
    n/length(pentachoronfaces)))
    poly(scalefactor * pentachoron2D[face], :fillpreserve, close=true)
    sethue("black")
    strokepath()
end
end

# And this function generates a series of frames and saves them to an animation:

function makemovie(w, h, fname;
scalefactor=1000)
movie1 = Movie(w, h, "4D movie")
animate(movie1,
Scene(movie1, (s, f)  -> frame(s, f, scalefactor),
1:300,
easingfunction=easeinoutsine),
creategif=true,
pathname="../images/pentachoron/$(fname)")
end

makemovie(600, 600, "pentachoron-xz.gif", scalefactor=2000)

# This is a rotation in the “parallel to the desk my computer’s resting on” XZ plane.

# ![image label](IMAGEFOLDER/pentachoron-xz.gif)

# It’s not a realistic rendering with hidden-surface removal—I wouldn’t know how to do that in 3D, let alone 4D. But it does make it slightly easier to follow some of the faces. Something to do one day might be to sort the “faces” to determine which are drawn first, but given the maths involved this is a challenge I’m dubious about tackling...

# We can modify `frame()` to allow various permutations of XY, XW, XZ, YZ, YW, and ZW rotations. Here’s a version that rotates in XZ, followed by YW:

function frame(scene, framenumber, scalefactor=1000)
background("antiquewhite")
setlinejoin("bevel")
setline(1.0)
setopacity(0.2)

eased_n       = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)
pentachoron2D = flatten(
rotate4(
pentachoron,
XZ(eased_n * 2π) *
YW(eased_n * 2π)))
for (n, face) in enumerate(pentachoronfaces)
    sethue(get(ColorSchemes.diverging_rainbow_bgymr_45_85_c67_n256,
    n/length(pentachoronfaces)))
    poly(scalefactor * pentachoron2D[face], :fillpreserve, close=true)
    sethue("black")
    strokepath()
end
end

makemovie(800, 800, "pentachoron-xz-yw.gif", scalefactor=2000)

# ![image label](IMAGEFOLDER/pentachoron-xz-yw.gif)

# These are starting to make me think of kneading machines for making pizza dough.

# You can draw a few different models at once, placing each one in a separate cell:

# ![image label](IMAGEFOLDER/showall-pentachoronmovie.gif)

# This is showing 2D shadows of 3D shadows of 4D objects. Do these objects exist? I don’t know...

# ### Other shapes

# While the word “pentachoron” was unfamiliar to me until recently, the word “tesseract” is much more familiar. After all, didn’t the tesseract contain the Space Stone, one of the six Infinity Stones that apparently predate the universe and possess unlimited energy? (According to the scientists at Marvel Comics, at least...) It’s also the name of a 4-dimensional hypercube, one step up from the pentachoron.

# Here are the vital numbers for the tesseract:

const tesseract = [Point4D(vertex...) for vertex in [
[-1, -1, -1,  1],
[ 1, -1, -1,  1],
[ 1,  1, -1,  1],
[-1,  1, -1,  1],
[-1, -1,  1,  1],
[ 1, -1,  1,  1],
[ 1,  1,  1,  1],
[-1,  1,  1,  1],
[-1, -1, -1, -1],
[ 1, -1, -1, -1],
[ 1,  1, -1, -1],
[-1,  1, -1, -1],
[-1, -1,  1, -1],
[ 1, -1,  1, -1],
[ 1,  1,  1, -1],
[-1,  1,  1, -1]]]

const tesseractfaces = [
[1,   2,   3,   4],
[1,   2,  10,   9],
[1,   4,   8,   5],
[1,   5,   6,   2],
[1,   9,  12,   4],
[2,   3,  11,  10],
[2,   3,   7,   6],
[3,   4,   8,   7],
[5,   6,  14,  13],
[5,   6,   7,   8],
[5,   8,  16,  13],
[6,   7,  15,  14],
[7,   8,  16,  15],
[9,  10,  11,  12],
[9,  10,  14,  13],
[9,  13,  16,  12],
[10, 11,  15,  14],
[13, 14,  15,  16]]

#-
# Replace `pentachoron` everywhere by `tesseract` in the above code, choosing the rotations to taste.
#-

function frame(scene, framenumber, scalefactor=1000)
background("black")
setlinejoin("bevel")
setline(10.0)
setopacity(0.7)

eased_n       = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)
tesseract2D = flatten(
rotate4(
tesseract,
XZ(eased_n * 2π) *
YW(eased_n * 2π)))
for (n, face) in enumerate(tesseractfaces)
    sethue([Luxor.lighter_blue, Luxor.lighter_green,
    Luxor.lighter_purple, Luxor.lighter_red][mod1(n, 4)]...)
    poly(scalefactor * tesseract2D[face], :fillpreserve, close=true)
    sethue([Luxor.darker_blue, Luxor.darker_green,
    Luxor.darker_purple, Luxor.darker_red][mod1(n, 4)]...)
    strokepath()
end
end

makemovie(800, 800, "tesseract-xz-yw.gif", scalefactor=2000)

# ![image label](IMAGEFOLDER/tesseract-xz-yw.gif)

# (Just for fun I temporarily switched the color scheme over to the Julia logo colors. You can see the 3D rendering problems more clearly, as well!)

# Here’s a composite of four pairs of rotations:

# ![image label](IMAGEFOLDER/showall-tesseractmovie.gif)

# ## Enough is enough

# It’s tempting to go further, but these web pages do get very big with all these GIFs. But just one more... I quite like this one, the *hexadecachoron*:

const hexadecachoron = [Point4D(vertex...) for vertex in [
[ 1,  0,  0,  0],
[ 0,  1,  0,  0],
[ 0,  0,  1,  0],
[ 0,  0,  0,  1],
[-1,  0,  0,  0],
[ 0, -1,  0,  0],
[ 0,  0, -1,  0],
[ 0,  0,  0, -1]]]

using Combinatorics

const hexadecachoronfaces = combinations(1:8, 3)

function frame(scene, framenumber, scalefactor=1000)
background("antiquewhite")
setlinejoin("bevel")
setline(1.0)
setopacity(0.15)
eased_n          =
scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)
hexadecachoron2D = flatten(
rotate4(
hexadecachoron,
YZ(eased_n * 2π) *
XZ(eased_n * 2π) *
YW(eased_n * 2π)))
for (n, face) in enumerate(hexadecachoronfaces)
    sethue(get(ColorSchemes.magma,
    n/length(hexadecachoronfaces)))
    poly(scalefactor * hexadecachoron2D[face], :fillpreserve, close=true)
    sethue("black")
    strokepath()
end
end

makemovie(650, 650, "movie-hexadecachoron.gif", scalefactor=5000)

# ![image label](IMAGEFOLDER/movie-hexadecachoron.gif)

# There’s lots more fun to be had (combining two or more different shapes is fun), but I’m worried about your network and my brain cells, so that’s enough animated GIFs for today.

# [2018-04-03]

# ![cormullion signing off](http://steampiano.net/cormullionknot.gif?pentachoron)

#src
using Literate                                                                                 #src
# preprocess for notebooks                                                                     #src
function setimagefolder(content)                                                               #src
content = replace(content, "IMAGEFOLDER" => "$IMAGEFOLDER")                                #src
return content                                                                             #src
end                                                                                            #src
# for Jupyter notebook, put images in subfolder                                                #src
#IMAGEFOLDER = “? /assets/images/pentachoron”                                                  #src
#Literate.notebook(“source/pentachoron.jl”, “notebooks”, preprocess = setimagefolder)          #src
# for Markdown, put images in “/assets/images”                                                 #src
IMAGEFOLDER = "/assets/images/pentachoron"                                                     #src
Literate.markdown("source/pentachoron.jl", ".", name="pages/2019-04-03-pentachoron",  #src
preprocess = setimagefolder,                                                                  #src
documenter=false)                                                                             #src
#src
