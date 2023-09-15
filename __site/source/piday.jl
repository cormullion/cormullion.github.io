# @def published = "2019-03-13 00:00:00 +0000"
# @def title = "π day"
# @def authors = """Cormullion"""
# @def hascode = true
# @def hasmath = true
# @def rss = "Explporing some ways to visualize the digits of π, for tomorrow's π day celebrations ![image label](/assets/images/piday/t-800.png))"
# @def rss_pubdate = Date(2019, 3, 13)
# @def rss_author = "cormullion"

# >In the UK we have started to celebrate π day (the 3rd month's 14th day) every year, even though we don't use the USA's date formatting convention of `monthnumber` followed by `daynumber`. But we can't really celebrate the 31st of April (31/4) or the 3rd of Quatember (?) (3/14), so we'll happily celebrate π day on 14/3 along with everyone else!

# >I set myself a challenge at the beginning of March: make a π-related image using Julia and the Luxor.jl package every day until π day. Some days it worked out well, others didn't, but I've gathered them all here anyway. This post has a fair few images, but not very much code or mathematical content.

# The images here are in low-resolution: they should be available on my [Flickr page](https://www.flickr.com/photos/153311384@N03/) at their full resolution if you want to download or re-use them.

# ### Day 1: Circle packing

# Circle packing may be a well-trodden path, but it always looks neat, and it's a nice easy start. You maintain a list of circles (center point and radius). Then you create a random circle, check it against all the other ones, draw it if it doesn't overlap, or reduce the radius and try again. It's not very efficient but you can set it going and go and make some coffee.

# To make the π shape appear, the code creates a path:

#md fontsize(480)
#md textoutlines("π", O, :path, halign=:center, valign=:middle)
#md πoutline = first(pathtopoly())

# then checks whether each circle's centerpoint is inside or outside the outline of the π shape:

#md isinside(pt, πoutline)

# and colors it accordingly.

# ![image label](IMAGEFOLDER/t-800.png)

# ### Day 2: Dry and wet

# I repeated myself today, thinking I could develop the circles a bit more, and ended up with this glossier wet-look version. The apparently random-looking shapes in the background are Bézier splodges that are supposed to be splashes...

# ![image label](IMAGEFOLDER/pi-reds-balls-wet-800.png)

# ### Day 3: π packing

# This is π packing rather than circle packing, although the code is again quite similar in outline: choose a point at random, find the largest font size at which the π character fits without overlapping others in the list, and then place it and add it to the list. The colors are a bit murky though.

# ![image label](IMAGEFOLDER/pi-swarm-3-800.png)

# ### Day 4: Rainbow

# Combining concentric circles and rainbow colors, this image shows about 350 digits of π.

# ![image label](IMAGEFOLDER/digits-of-pi-avenir-800.png)

# To generate the digits of π, I use this function:

function pidigits(n)
    result = BigInt[]
    k, a, b, a1, b1 = big.([2, 4, 1, 12, 4])
    while n > 0
        p, q, k = k^2, 2k + 1, k + 1
        a, b, a1, b1 = a1, b1, p * a  +  q * a1, p * b  +  q * b1
        d, d1 = a ÷ b, a1 ÷ b1
        while d == d1
            push!(result, d)
            n -= 1
            a, a1 = 10(a % b), 10(a1 % b1)
            d, d1 = a ÷ b, a1 ÷ b1
        end
    end
    return result
end

# It looks like witchcraft to me, but I understand that it's a "spigot" algorithm. I was hoping for a while that it was named after a Professor Spigot, but in fact it's describing the way the digits trickle out one by one like drops of water. It's quick enough for a thousand digits or so, but slows down a lot when you ask for 100_000 or more, probably due to the hard work that the big integer library has to do: even when you're just calculating the first 15 digits of π, the values of `a1` and `b1` are way over the limits of Int64s.

#md julia-1.1> @time pidigits(1000);
#md  0.014522 seconds (44.90 k allocations: 9.425 MiB, 28.97% gc time)

# The image might work better on white:

# ![image label](IMAGEFOLDER/digits-of-pi-avenir-on-white-800.png)

# Sometimes I wanted to check where certain sequences of digits appeared. I couldn't find a built-in function that looked for a sequence of digits in an array, but this worked well enough for my purposes:

function findsubsequence(needle, haystack)
    result = Int64[]
    for k in 1:length(haystack) - length(needle)
        if needle == view(haystack, k:k + length(needle) - 1)
            push!(result, k)
        end
    end
    return result
end

findsubsequence(str::String, digits) =
    findsubsequence(map(x -> parse(Int, x), split(str, "")), digits)

findsubsequence("999999", pidigits(2000)) # => [763]

# ### Day 5: Low-fat

# A chunky typeface like the Avenir Heavy I used yesterday is good for masking and clipping. But I wondered how the narrowest typeface would look. I found Briem Akademi, designed by Gunnlaugur Briem at the Royal Academy of Fine Arts in Copenhagen. Adobe's description says:

# >The most compressed version works best where legibility is less important than dramatic visual effect.

# and I like the abstract look even though it's almost illegible... Would this make nice bathroom tiles?

# ![image label](IMAGEFOLDER/many-digits-of-pi-briem-800.png)

# ### Day 6 Breakfast and Tiffany

# I'm still thinking about using typefaces. I'm a fan of Ed Benguiat's ITC Tiffany font, his nostalgic look back from the 1970s to the age of Edwardian elegance.

# ![image label](IMAGEFOLDER/pi-digits-appearing-800.png)

# It's easy to do this with tables. Like the circle packing, the code checks whether the coordinates of each table cell fall within a given perimeter, and changes the font accordingly.

# ### Day 7 Distinguished

# The excellent Colors.jl package has a function called `distinguishable_colors()` (which fortunately tab-completes). The help text says:

# > This uses a greedy brute-force approach to choose `n` colors that are maximally distinguishable. Given `seed` color(s), and a set of possible hue, chroma, and lightness values (in LCHab space), it repeatedly chooses the next color as the one that maximizes the minimum pairwise distance to any of the colors already in the palette.

# Much to do with color depends on the viewer's perception, but I think it works well here. It starts at the top left, and works from left to right. (That pesky decimal point defaults to using the previous color...) You can spot the Feynman point (`999999`) halfway down on the left (look for the six consecutive sandy brown squares), or the four purple sevens on the bottom row.

# ![image label](IMAGEFOLDER/pi-distinguishable_colors-800.png)

# I remembered to try to choose the color for the small labels (probably unreadable in the low-resolution PNG you see here) so that they're either light on dark, or dark on light.

#md ... r, g, b = color of square
#md gamma = 2.2
#md luminance = 0.2126 * r^gamma + 0.7152 * g^gamma + 0.0722 * b^gamma
#md (luminance > 0.5^gamma) ? sethue("black") : sethue("white")

# ### Day 8 Candy crush edition

# ![image label](IMAGEFOLDER/candy-crush.png)

# I must have seen an advert for CandyCrush yesterday, or perhaps all that talk of gamma and LCHab spaces caused a reaction, but this sugar rush of an image was the result. The SVG version looks tasty but is too big for this web page.

# ### Day 9 Like a circle in a spiral, a wheel within a wheel

# Arranging the sweets in a spiral looks tidy.

# ![image label](IMAGEFOLDER/pi-digits-in-spiral-balls-800.png)

# ### Day 10 π into circumference

# Luxor's `polysample()` function takes a polygon and samples it at regular intervals. This allows the following idea, where each point on a shape (here, the outline of the π character) is slowly moved to a matching location on the circular shape around the outside.

# ![image label](IMAGEFOLDER/pi-to-circle-800.png)

# For a point on the π border `p1`, and a matching point on the circumference polygon `p2`, the intermediate point is given by `between(p1, p2, n)`, where `n` is between 0 and 1.

# I like the almost 3D effect you get from this.

# ### Day 11 Charcoal

# Time for a charcoal sketch:

# ![image label](IMAGEFOLDER/pi-charcoal-1-800.png)

# The crinkly edges of the paper are made by the `polysample()` function on a rectangle then applying simplex-`noise()`-y nudges to the vertices. The paper is textured with `rule()`d lines, and there's some very low values for `setopacity()` smudges. Shifting the Bézier curve handles slightly for each iteration gives a brushy/sketchy feel. (It's fortunate I can copy and paste some of this code from drawings I've made before: I've learnt the hard way that it's better keep things than throw them away...)

# ### Day 12

# I ran out of time on this one, and there are still some problems with the text spacing. The idea is to have the infinite digits of π spiral into some fiery star with some space-y stuff. Probably not the sort of image I should be attempting at all with simple vector-based 2D graphics tools, but it feels like a challenge. Those wispy trails are the same as yesterday's brush strokes, but using custom `setdash()` dashing patterns.

# ![image label](IMAGEFOLDER/pi-cosmic-spiral-800.png)

# ### Day 13

# The idea here is to show which digit of π is the current leader, in terms of how many times that digit has appeared already. (Yes, a stupid idea, I know!) Then I couldn't decide on how many digits to show, so it's going to be an animated GIF showing the first 1000 digits. At the 200 digit mark poor old "7" is struggling at the back of the field, but the glory days are ahead - after 1000 digits, it's overtaken 0, 4, and 6.

# ![image label](IMAGEFOLDER/200-digits-of-pi-800.png)

# The animation turned into a video rather than a GIF, because I don't like the low resolution of GIFs today.

# And now of course I have to add a suitable audio soundtrack. Luckily I've recently been playing with George Datseris' [MIDI interface for Julia](https://github.com/JuliaMusic), so it was easy enough to make a musical version of the first 1000 digits of π, where the digits from 0 to 9 choose the appropriate note from a reasonably harmonious scale.

using MIDI

function savetrack(track, notes)
    file = MIDIFile()
    addnotes!(track, notes)
    addtrackname!(track, "a track")
    push!(file.tracks, track)
    writeMIDIFile("/tmp/sound-of-pi.mid", file)
end

scales = [46, 48, 51, 53, 55, 57, 58, 60, 62, 65, 67]

function generatetune!(notes)
    pos = 1
    dur = 80
    k = 1
    manypidigits = pidigits(1000)
    for i in manypidigits
        dur = k * 960
        pos += k * 960
        n = scales[i + 1]
        note = Note(n, 76, pos, dur)
        push!(notes, note)
    end
end

notes = Notes()
track = MIDITrack()
generatetune!(notes)
savetrack(track, notes)

# ![image label](IMAGEFOLDER/music-credits.png)

# This "sonification" (or "audification") is just for fun. For a more convincing critique of these sonifications than I can provide, watch the always entertaining [Tantacrul](https://www.youtube.com/watch?v=Ocq3NeudsVk)'s presentation on YouTube.

# And while you're on YouTube, the π video is on [my YouTube channel](https://www.youtube.com/channel/UCfd52kTA5JpzOEItSqXLQxg), and it's my entry for YouTube's Most Boring Video of 2019 competition, but I suspect it won't do very well—competition in this category is fierce, even if sometimes the contestants are unwilling participants.

# Happy π day!

# [2019-03-13]

# ![cormullion signing off](http://steampiano.net/cormullionknot.gif?piday)

using Literate                                                                              #src
# preprocess for notebooks                                                                  #src
function setimagefolder(content)                                                            #src
    content = replace(content, "IMAGEFOLDER" => "$IMAGEFOLDER")                             #src
    return content                                                                          #src
end                                                                                         #src

# for Jupyter notebook, put images in subfolder                                             #src
#IMAGEFOLDER = "images/piday"                                                               #src

#Literate.notebook("source/piday.jl", "notebooks", preprocess = setimagefolder)             #src

# for Markdown, put images in "/assets/images/..."                                          #src

IMAGEFOLDER = "/assets/images/piday"                                                        #src

Literate.markdown("source/piday.jl", ".", name="pages/2019-03-13-piday",           #src
 preprocess = setimagefolder,                                                               #src
 documenter=false)                                                                          #src
