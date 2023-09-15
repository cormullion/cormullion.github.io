using Colors, Luxor
@draw begin
    setcolor("mauve")
    paint()
end 600 300

ERROR: LoadError: Unknown color: mauve
Stacktrace:
 [1] error(::String, ::String) at ./error.jl:42
 [2] _parse_colorant(::String) at /Users/me/.julia/packages/Colors/r1p4Q/src/parse.jl:103
 [3] _parse_colorant(::Type{RGBA}, ::Type{ColorAlpha{RGB{T},T,4} where T<:Union{AbstractFloat, FixedPointNumbers.FixedPoint}}, ::String) at /Users/me/.julia/packages/Colors/r1p4Q/src/parse.jl:112
 [4] parse at /Users/me/.julia/packages/Colors/r1p4Q/src/parse.jl:145 [inlined]
 [5] setcolor(::String) at /Users/me/.julia/dev/Luxor/src/colors_styles.jl:29
 [6] top-level scope at untitled-ba17b354ac0d06ec10bd7374a7ef9522:4
 [7] top-level scope at /Users/me/.julia/dev/Luxor/src/drawings.jl:555
in expression starting at untitled-ba17b354ac0d06ec10bd7374a7ef9522:3
