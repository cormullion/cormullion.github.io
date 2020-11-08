@def published = "2020-07-26 00:00:00 +0000"
@def title = "JuliaMono"
@def authors = """Cormullion"""
@def hascode = true
@def hasmath = true
@def mintoclevel=1

> This page first appeared as a website to acompany the
> first release of JuliaMono, and it’s now been incorporated
> here as a blog post.

# JuliaMono - a monospaced font for scientific and technical computing

JuliaMono is a monospaced typeface designed for programming in the [Julia](https://julialang.org) Programming Language and in other text editing environments that require a wide range of specialist and technical Unicode characters. It was intended as a fun experiment to be presented at the 2020 JuliaCon conference in Lisbon, Portugal (which of course didn’t physically happen in Lisbon, but online).

JuliaMono is:

- free
- distributed with a liberal licence [^licence]
- suitable for scientific and technical programming as well as for general purpose hacking
- available for MacOS, Unix, and Windows [^windows]
- easy to use, simple, friendly, and approachable

The original temporary website used JuliaMono everywhere, so let's try to make the rest of this page do the same.

@@jm_h1
# Contents
@@

@@jm_franklin-toc
\toc
@@

@@jm_p

To download and install JuliaMono, see the instructions [here](#download_and_install).

@@jm_h1
# Screenshots
@@

Editing code in [Juno](https://github.com/JunoLab/Juno.jl).

~~~
<img src="/assets/images/juliamono/juno-example.png" alt="screenshot of Juno editor">
~~~

And in [VS Code](https://www.julia-vscode.org).

~~~
<img src="/assets/images/juliamono/vscode-example.png" alt="screenshot of VS code editor">
~~~

And in [Vim](https://www.vim.org):

~~~
<img src="/assets/images/juliamono/vim-example.png" alt="screenshot of VIM editor">
~~~

And in [Emacs](https://www.gnu.org/software/emacs/):

~~~
<img src="/assets/images/juliamono/emacs-example.png" alt="screenshot of emacs editor">
~~~

@@jm_h1
# Examples
@@

```julia
using Zygote: @adjoint
function ignore(f)
  try return f()
        catch e; return 0; end
end
@adjoint function ignore(f)
  try Zygote._pullback(__context__, f)
  catch e
    0, ȳ -> nothing
  end
end
```

There are different weights of JuliaMono, so you can control the amount of contrast you have in your highlighted code: ~~~<span style="font-family: JuliaMono-Light;">JuliaMono-Light</span>~~~, JuliaMono-Regular, ~~~<span style="font-family: JuliaMono-Medium;">JuliaMono-Medium</span>~~~, ~~~<span style="font-family: JuliaMono-Bold;">JuliaMono-Bold</span>~~~, ~~~<span style="font-family: JuliaMono-ExtraBold;">JuliaMono-ExtraBold</span>~~~, and ~~~<span style="font-family: JuliaMono-Black;">JuliaMono-Black</span>~~~. [^masters]

(There are also versions of two of the fonts with “Latin” in the name: these are stripped down versions supporting just the basic MacRoman/Windows1252 “Latin” character sets, intended for use as place-holders, of interest mainly if you want to have more control over font loading times in web browser-based applications.)

In the hands of a virtuoso (such as Dr Zygmunt Szpak, the author of the following Julia code fragment[^zscode]), the range of available Unicode characters can be quite expressive:

```
function T(𝛉::AbstractArray,
           𝒞::Tuple{AbstractArray,
           Vararg{AbstractArray}},
           𝒟::Tuple{AbstractArray, Vararg{AbstractArray}})
    ⊗ = kron
    l = length(𝛉)
    𝐈ₗ = SMatrix{l,l}(1.0I)
    𝐈ₘ = SMatrix{1,1}(1.0I)
    𝐓 = @SMatrix zeros(l,l)
    N = length(𝒟[1])
    ℳ, ℳʹ = 𝒟
    Λ₁, Λ₂ = 𝒞
    𝚲ₙ = @MMatrix zeros(4,4)
    𝐞₁ = @SMatrix [1.0; 0.0; 0.0]
    𝐞₂ = @SMatrix [0.0; 1.0; 0.0]
    for n = 1:N
        index = SVector(1,2)
        𝚲ₙ[1:2,1:2] .=  Λ₁[n][index,index]
        𝚲ₙ[3:4,3:4] .=  Λ₂[n][index,index]
        𝐦    = hom(ℳ[n])
        𝐦ʹ   = hom(ℳʹ[n])
        𝐔ₙ   = (𝐦 ⊗ 𝐦ʹ)
        ∂ₓ𝐮ₙ = [(𝐞₁ ⊗ 𝐦ʹ) (𝐞₂ ⊗ 𝐦ʹ) (𝐦 ⊗ 𝐞₁) (𝐦 ⊗ 𝐞₂)]
        𝐁ₙ   = ∂ₓ𝐮ₙ * 𝚲ₙ * ∂ₓ𝐮ₙ'
        𝚺ₙ   = 𝛉' * 𝐁ₙ * 𝛉
        𝚺ₙ⁻¹ = inv(𝚺ₙ)
        𝐓₁   = @SMatrix zeros(Float64,l,l)
        for k = 1:l
            𝐞ₖ = 𝐈ₗ[:,k]
            ∂𝐞ₖ𝚺ₙ = (𝐈ₘ ⊗ 𝐞ₖ') * 𝐁ₙ * (𝐈ₘ ⊗ 𝛉) + (𝐈ₘ ⊗ 𝛉') * 𝐁ₙ * (𝐈ₘ ⊗ 𝐞ₖ)
            # Accumulating the result in 𝐓₁ allocates memory,
            # even though the two terms in the
            # summation are both SArrays.
            𝐓₁ = 𝐓₁ + 𝐔ₙ * 𝚺ₙ⁻¹ * (∂𝐞ₖ𝚺ₙ) * 𝚺ₙ⁻¹ * 𝐔ₙ' * 𝛉 * 𝐞ₖ'
        end
        𝐓 = 𝐓 + 𝐓₁
    end
    𝐓
end
```

@@jm_h1
# Languages
@@

Here are some samples of various languages[^languages] :

~~~
<table class="jm_language">
	<tr>
		<td>Ancient Greek</td>
		<td>Ἄδμηθ’, ὁρᾷς γὰρ τἀμὰ πράγμαθ’ ὡς ἔχει, λέξαι θέλω σοι πρὶν θανεῖν ἃ βούλομαι.</td>
	</tr>
	<tr>
		<td>Bulgarian</td>
		<td>Я, пазачът Вальо уж бди, а скришом хапва кюфтенца зад щайгите.</td>
	</tr>
	<tr>
		<td>Catalan</td>
		<td>«Dóna amor que seràs feliç!». Això, il·lús company geniüt, ja és un lluït rètol blavís d’onze kWh.</td>
	</tr>
	<tr>
		<td>Czech</td>
		<td>Zvlášť zákeřný učeň s ďolíčky běží podél zóny úlů</td>
	</tr>
	<tr>
		<td>Danish</td>
		<td>Quizdeltagerne spiste jordbær med fløde, mens cirkusklovnen Walther spillede på xylofon.</td>
	</tr>
	<tr>
		<td>English</td>
		<td>Sphinx of black quartz, judge my vow.</td>
	</tr>
	<tr>
		<td>Estonian</td>
		<td>Põdur Zagrebi tšellomängija-följetonist Ciqo külmetas kehvas garaažis</td>
	</tr>
	<tr>
		<td>Finnish</td>
		<td>Charles Darwin jammaili Åken hevixylofonilla Qatarin yöpub Zeligissä.</td>
	</tr>
	<tr>
		<td>French</td>
		<td>Voix ambiguë d’un cœur qui au zéphyr préfère les jattes de kiwi.</td>
	</tr>
	<tr>
		<td>German</td>
		<td>Victor jagt zwölf Boxkämpfer quer über den großen Sylter Deich.</td>
	</tr>
	<tr>
		<td>Greek</td>
		<td>Ταχίστη αλώπηξ βαφής ψημένη γη, δρασκελίζει υπέρ νωθρού κυνός.</td>
	</tr>
	<tr>
		<td>Guarani</td>
		<td>Hĩlandiagua kuñanguéra oho peteĩ saʼyju ypaʼũme Gavõme omboʼe hag̃ua ingyleñeʼẽ mitãnguérare neʼẽndyʼỹ.</td>
	</tr>
	<tr>
		<td>Hungarian</td>
		<td>Jó foxim és don Quijote húszwattos lámpánál ülve egy pár bűvös cipőt készít.</td>
	</tr>
	<tr>
		<td>IPA</td>
		<td>[ɢʷɯʔ.nas.doːŋ.kʰlja] [ŋan.ȵʑi̯wo.ɕi̯uĕn.ɣwa]</td>
	</tr>
	<tr>
		<td>Icelandic</td>
		<td>Kæmi ný öxi hér, ykist þjófum nú bæði víl og ádrepa.</td>
	</tr>
	<tr>
		<td>Irish</td>
		<td>Ċuaiġ bé ṁórṡáċ le dlúṫspád fíorḟinn trí hata mo ḋea-ṗorcáin ḃig.</td>
	</tr>
	<tr>
		<td>Latvian</td>
		<td>Muļķa hipiji mēģina brīvi nogaršot celofāna žņaudzējčūsku.</td>
	</tr>
	<tr>
		<td>Lithuanian</td>
		<td>Įlinkdama fechtuotojo špaga sublykčiojusi pragręžė apvalų arbūzą.</td>
	</tr>
	<tr>
		<td>Macedonian</td>
		<td>Ѕидарски пејзаж: шугав билмез со чудење џвака ќофте и кељ на туѓ цех.</td>
	</tr>
	<tr>
		<td>Norwegian</td>
		<td>Jeg begynte å fortære en sandwich mens jeg kjørte taxi på vei til quiz</td>
	</tr>
	<tr>
		<td>Polish</td>
		<td>Pchnąć w tę łódź jeża lub ośm skrzyń fig.</td>
	</tr>
	<tr>
		<td>Portuguese</td>
		<td>Luís argüia à Júlia que «brações, fé, chá, óxido, pôr, zângão» eram palavras do português.</td>
	</tr>
	<tr>
		<td>Romanian</td>
		<td>Înjurând pițigăiat, zoofobul comandă vexat whisky și tequila.</td>
	</tr>
	<tr>
		<td>Russian</td>
		<td>Широкая электрификация южных губерний даст мощный толчок подъёму сельского хозяйства.</td>
	</tr>
	<tr>
		<td>Scottish</td>
		<td>Mus d’fhàg Cèit-Ùna ròp Ì le ob.</td>
	</tr>
	<tr>
		<td>Serbian</td>
		<td>Ајшо, лепото и чежњо, за љубав срца мога дођи у Хаџиће на кафу.</td>
	</tr>
	<tr>
		<td>Spanish</td>
		<td>Benjamín pidió una bebida de kiwi y fresa; Noé, sin vergüenza, la más champaña del menú.</td>
	</tr>
	<tr>
		<td>Swedish</td>
		<td>Flygande bäckasiner söka hwila på mjuka tuvor.</td>
	</tr>
	<tr>
		<td>Turkish</td>
		<td>Pijamalı hasta yağız şoföre çabucak güvendi.</td>
	</tr>
	<tr>
		<td>Ukrainian</td>
		<td>Чуєш їх, доцю, га? Кумедна ж ти, прощайся без ґольфів!</td>
	</tr>
</table>

~~~

@@jm_h1
# Unicode coverage
@@

One of the goals of JuliaMono is to include most of the characters that a typical programmer would reasonably expect to find. (Except for all those emojis - they are best handled by the operating system.) Here’s a thousand or so chosen at random:

~~~<img src="/assets/images/juliamono/unicode-sample.svg" width="100%" alt="Unicode sampler"> ~~~

In JuliaMono, every character is the same width, because this is a [monospaced](https://en.wikipedia.org/wiki/Monospaced_font) typeface. Usually, typefaces with a lot of Unicode mathematical symbols are not monospaced, because they’re intended for use in prose and $ \LaTeX $ applications, rather than in programming code.

From a design perspective, forcing every character into the same size box is a problem. It’s like fitting every human being of whatever shape or size into identical airplane seats - some characters are bound to look uncomfortable. There’s never quite enough room for a nice-looking “m” or “w”.

[UnicodePlots.jl](https://github.com/Evizero/UnicodePlots.jl) uses various Unicode characters to plot figures directly in a terminal window. [^linespacing]

~~~
<img src="/assets/images/juliamono/unicodeplots.png" alt="UnicodePlots in action">
~~~

[ImageInTerminal.jl](https://github.com/JuliaImages/ImageInTerminal.jl) is similarly awesome, conjuring images from Unicode characters:

~~~
<img src="/assets/images/juliamono/imageinterminal.png" alt="ImageInTerminal">
~~~


It’s also a good idea to support box-drawing characters and DataFrames.jl output (terminal permitting):

```
julia> df = DataFrame(A=samples, B=glyphs)
df = 10×2 DataFrame
│ Row │ A              │ B                   │
│     │ String         │ String              │
├─────┼────────────────┼─────────────────────┤
│ 1   │ sample 1       │ ▁▂▁▁▂▄▅▁▄▁▁▅▆▂▇▅▂▇  │
│ 2   │ sample 2       │ ▁▂▄▁▁▃▁▆▂▆▃▁▂▃▂▇▄   │
│ 3   │ sample 3       │ ▁▆▇▁▃▇▇▆▅▅▄▇▇▅▅▇▄▂  │
│ 4   │ sample 4       │ ▅▁▄▁▆▃▁▃▇▂▂▇▅▇▃▆▃▁  │
│ 5   │ sample 5       │ ▆▂▁▂▇▆▃▅▅▄▆▇▄▇▆▁▇   │
│ 6   │ sample 6       │ ▁▁▇▂▂▇▃▅▂▂▆▂▄▄▁▄▂▇▆ │
│ 7   │ sample 7       │ ▂▃▂▁▁▇▁▂▆▂▁▇▁▄▃▂▁▄  │
│ 8   │ sample 8       │ ▄▄▁▂▄▁▅▁▅▁▂▂▇▂▁▃▄▄  │
│ 9   │ sample 9       │ ▁▁▁▂▁▆▃▄▄▁▂▂▃▂▁▅▁▆▃ │
│ 10  │ sample 10      │ ▁▇▄▂▅▃▇▁▇▇▆▄▇▅▄▂▄▅▄ │
```

(Can you spot the little used and sadly mathematically-unsupported "times" character?)

JuliaMono is quite greedy[^greedy], and contains a lot of Unicode glyphs.

~~~<img src="/assets/images/juliamono/barchart.svg" width="100%" alt="silly barchart"> ~~~

(Of course, size isn’t everything - quality can beat quantity, and other fonts will offer different experiences[^otherfonts]).

If you want to know whether you can use a Unicode character as an identifier in your Julia code, use the undocumented function `Base.isidentifier()`. So, for example, if you have the urge to use a dingbat (one of the classic [Herman Zapf dingbat](https://en.wikipedia.org/wiki/Zapf_Dingbats) designs) as a variable name, you could look for something suitable in the output of this:

```
julia> for n in 0x2700:0x27bf
			Base.isidentifier(string(Char(n))) && print(Char(n))
	   end
✀✁✂✃✄✅✆✇✈✉✊✋✌✍✎✏✐✑✒✓✔✕✖✗✘✙✚✛✜✝✞✟✠✡✢✣✤✥✦✧✨✩✪✫✬✭✮✯✰✱✲✳✴✵✶✷✸✹✺
✻✼✽✾✿❀❁❂❃❄❅❆❇❈❉❊❋❌❍❎❏❐❑❒❓❔❕❖❗❘❙❚❛❜❝❞❟❠❡❢❣❤❥❦❧➔➕➖➗➘➙➚➛➜➝➞➟➠➡
➢➣➤➥➦➧➨➩➪➫➬➭➮➯➰➱➲➳➴➵➶➷➸➹➺➻➼➽➾➿

julia> ❤(s) = println("I ❤ $(s)")
❤ (generic function with 1 method)

julia> ❤("Julia")
I ❤ Julia
```

An easy way to include Unicode characters at the REPL is to use the clipboard:

```
julia> clipboard(Char(0x2764))

# then paste

julia> ❤("Unicode")
I ❤ Unicode
```

@@jm_h1
# Contextual and stylistic alternates (and ‘ligatures’)
@@

JuliaMono is an [OpenType](https://en.wikipedia.org/wiki/OpenType) typeface. OpenType technology provides powerful text positioning, pattern matching, and glyph substitution features, which are essential for languages such as Arabic and Urdu. In English, OpenType features are often seen when letter pairs such as ~~~<span style="font-size: 1.5em;font-family: Georgia;font-variant-ligatures: no-common-ligatures; ">fi</span>~~~ in certain fonts are replaced by a single glyph such as ~~~<span style="font-size: 1.5em; font-family: Georgia;">ﬁ</span>~~~. These [ligatures](https://en.wikipedia.org/wiki/Orthographic_ligature) have been used ever since printing with moveable type was invented, replacing the occasional awkward character combination with a better-looking alternative.

To be honest, I’m not a big fan of their use in coding fonts (and I’m not the only one[^nottheonlyone]). I like to see exactly what I’ve typed, rather than what the font has decided to replace it with. But, there are a few places in Julia where suitable Unicode alternatives are not accepted by the language, and where I feel that the ASCII-art confections currently used can be gently enhanced by the judicious use of alternate glyphs. There are also a few places where some subtle tweaks can enhance the readability of the language without introducing ambiguity.

In JuliaMono, the following substitutions are applied when the **contextual alternates** feature is active:

~~~
<table class="jm_sstable">
    <tr>
    <th><p>typed</p></th>
    <th><p>displayed</p></th>
    </tr>
    <tr>
    <td class="jm_code_ss_off">-></td>
    <td class="jm_code_calt_on">-></td>
    </tr>

    <tr>
    <td class="jm_code_ss_off">=></td>
    <td class="jm_code_calt_on">=></td>
    </tr>
    <tr>
    <td class="jm_code_ss_off">|></td>
    <td class="jm_code_calt_on">|></td>
    </tr>
    <tr>
    <td class="jm_code_ss_off"><|</td>
    <td class="jm_code_calt_on"><|</td>
    </tr>
    <tr>
    <td class="jm_code_ss_off">::</td>
    <td class="jm_code_calt_on">::</td>
    </tr>

</table>
~~~

You can see these in action in the following code fragment:[^width]

```
julialang = true # (!= 0)
(x, y) -> (x + y)
f(p::Int) = p * p
@inbounds if f in (Base.:+, Base.:-)
    if any(x -> x <: AbstractArray{<:Number})
         nouns = Dict(
            Base.:+ => "addition",
            Base.:- => "subtraction",
        )
    end
end
df2 = df |>
    @groupby(_.a) |>
    @map({a = key(_), b = mean(_.b)}) |>
    DataFrame # <|
```

OpenType fonts also offer you the ability to choose different designs for certain characters. These are stored as a ‘stylistic set’.

All the options are stored in the font, and are often referred to by their internal four letter code (not the best user-oriented design, really). For example, the contextual alternates listed above are collectively stored in the **calt** feature.

Sometimes, an application will show the options more visually in a Typography panel[^typographypanel], usually tucked away somewhere on a Font chooser dialog.

Here’s a list of the stylistic sets currently available in JuliaMono.

~~~
<table class="jm_sstable">
    <tr>
    <th><p>feature code</p></th>
    <th><p>off</p></th>
    <th><p>on</p></th>
    <th><p>description</p></th>
    </tr>

    <tr>
    <td>zero</td>
    <td class="jm_code_ss_off">0</td>
    <td class="jm_code_zero_on">0</td>
    <td><p>slashed zero</p></td>
    </tr>

    <tr>
    <td>ss01</td>
    <td class="jm_code_ss_off">g</td>
    <td class="jm_code_ss_on">g</td>
    <td><p>alternate g</p></td>
    </tr>

    <tr>
    <td>ss02</td>
    <td class="jm_code_ss_off">@</td>
    <td class="jm_code_ss_on">@</td>
    <td><p>alternate @</p></td>
    </tr>

    <tr>
    <td>ss03</td>
    <td class="jm_code_ss_off">j</td>
    <td class="jm_code_ss_on">j</td>
    <td><p>alternate j</p></td>
    </tr>

    <tr>
    <td>ss04</td>
    <td class="jm_code_ss_off">0</td>
    <td class="jm_code_alt_zero">0</td>
    <td><p>alternate 0</p></td>
    </tr>

    <tr>
    <td>ss05</td>
    <td class="jm_code_ss_off">*</td>
    <td class="jm_code_ss_on">*</td>
    <td><p>lighter asterisk</p></td>
    </tr>

    <tr>
    <td>ss06</td>
    <td class="jm_code_ss_off">a</td>
    <td class="jm_code_ss_on">a</td>
    <td><p>simple a</p></td>
    </tr>

    <tr>
    <td>ss07</td>
    <td class="jm_code_ss_off">`</td>
    <td class="jm_code_ss_on">`</td>
    <td><p>smaller grave</p></td>
    </tr>
    <tr>
    <td>ss08</td>
    <td class="jm_code_ss_off">-></td>
    <td class="jm_code_ss_on_dl">-></td>
    <td><p>distinct ligatures</p></td>
    </tr>
    <tr>
    <td>ss09</td>
    <td class="jm_code_ss_off">f</td>
    <td class="jm_code_ss_on">f</td>
    <td><p>alternate f</p></td>
    </tr>
    <tr>
    <td>ss10</td>
    <td class="jm_code_ss_off">r</td>
    <td class="jm_code_ss_on">r</td>
    <td><p>alternate r</p></td>
    </tr>
    <tr>
    <td>ss11</td>
    <td class="jm_code_ss_off">`</td>
    <td class="jm_code_ss_thinnergrave">`</td>
    <td><p>thinner grave</p></td>
    </tr>

</table>
~~~

All this fancy technology is under the control of the application and the operating system you’re using. Ideally, they will provide an easy way for you to switch the various OpenType features on and off.

Browser-based editors such as Juno and VS Code support many OpenType features in their editor windows, but not in the terminal/console windows. They provide a settings area where you can type CSS or JSON selectors to control the appearance of features, and you’ll have to know the feature codes. Some features are opt in, others are opt out; this too can vary from application to application.

Terminal/console applications also vary a lot; on MacOS the **Terminal** and **iTerm** applications try to offer controls for OpenType features, with varying degrees of success. On Linux, some terminal applications such as [Kitty](https://sw.kovidgoyal.net/kitty/#font-control) offer quite good support, but others such as [Alacritty](https://github.com/alacritty/alacritty) offer little or none, as yet. [^terminal]

If the application allows, you should be able to switch the ``calt`` contextual ligatures off, particularly since quite a few people won’t like any of them in their code. For the following listing, I switch the **calt** set off using CSS (see [here](#how_do_i_control_features_in_css_in_atomjuno_or_vs_code)), and then enable some of the alternative stylistic sets: compare characters such as the **0**, **g**, **a**, **j**, and **@** with the previous listing:

@@jm_code_ss_on
```
julialang = true # (!= 0)
(x, y) -> (x + y)
f(p::Int) = p * p
@inbounds if f in (Base.:+, Base.:-)
    if any(x -> x <: AbstractArray{<:Number})
         nouns = Dict(
            Base.:+ => "addition",
            Base.:- => "subtraction",
        )
    end
end
df2 = df |>
    @groupby(_.a) |>
    @map({a = key(_), b = mean(_.b)}) |>
    DataFrame # <|
```
@@

(I originally liked the idea of a more circular ``@`` sign, but in practice it doesn’t work at small point sizes, as the details disappear. But I’ve kept it anyway.)

@@jm_h1
# Private Use Areas (PUAs)
@@

There are a few areas of the Unicode system that have been officially kept empty and are thus available to store characters that are not part of the standard. These are called the **Private Use Areas**, and there are three: `\ue000` to `\uf8ff`, `\UF0000` to `\UFFFFD`, and `U100000` to `U+10FFFD`.

Each typeface can do its own thing in these areas. In JuliaMono, for example, if you look around `\ue800` you’ll find a few familiar shapes:

```
julia> foreach(println, '\ue800':'\ue802')



```

The obvious drawback to using characters in a Private Use Area is that you have to have installed the font wherever you want to see them rendered correctly, unless they’ve been converted to outlines or bitmaps. If the font isn’t installed (eg on github), you have no idea what glyph - if any - will be displayed.

You can define these to be available at the Julia REPL. For example, say you want the Julia circles to be available in the terminal when you type `\julialogo`~~~<span style="font-size: 1.5em;"></span>~~~ in a Julia session with the JuliaMono font active. Run this:

```
using REPL
REPL.REPLCompletions.latex_symbols["\\julialogo"] = "\ue800"
```

Now you can insert the logo in strings by typing `\julialogo`~~~<span style="font-size: 1.5em;"></span>~~~:

```
julia> println("Welcome to ")
Welcome to 
```

It’s usually possible to type Unicode values directly into text. This is a useful skill to have when you’re not using the Julia REPL... On MacOS you hold the Option (⌥) key down while typing the four hex digits (make sure you’re using the Unicode Hex Input keyboard). On Windows I think you type the four hex digits followed by `ALT` then `X`. On Linux it might be `ctrl`-`shift`-`u` followed by the hex digits.

@@jm_h1
# Download and install
@@

@@jm_h2
## Download
@@

You can find the font files at [https://github.com/cormullion/juliamono](https://github.com/cormullion/juliamono).

For Arch Linux, there is also a [package in the AUR](https://aur.archlinux.org/packages/ttf-juliamono/).

@@jm_h2
## Installation
@@

### Mac

To install and activate a font, launch Font Book from your Applications folder, and drag the font files into the middle pane labelled Font. If you're using a different font manager, you already know what to do. :)

#### Homebrew

On the latest version of Homebrew, you can install the fonts with:

```
$ brew tap homebrew/cask-fonts
$ brew cask install font-juliamono
```

### Windows

To install and activate a font on Windows, go to Computer |> Local Disk (C:) |> Windows |> Fonts. Locate the expanded .zip file folder, and drag the font files from there into the Fonts folder.

### Linux - using Font Manager

Install Font Manager:

```
sudo apt install font-manager
```

Then double-click on the font files and click Install on each one.

### Linux - on the command line

Locate your font folder. Might be one of:

```
~/.fonts
/usr/share/fonts/truetype/newfonts/
~/.local/fonts/
~/.local/share/fonts/
```

and copy the files there. You might want to (or have to) regenerate the font cache:

```
$ fc-cache -f -v
```

And verify installation:

```
$ fc-list | grep "JuliaMono"
```

@@jm_h1
# Frequently asked questions
@@

@@jm_h2
## ‘Why⁉’
@@

The typeface was introduced at the 2020 Julia Programming Language conference, JuliaCon, in Lisbon, Portugal, and it was (going to be) my contribution to the festivities. It was an experiment to see whether a font could be designed with a specific programming language in mind.

@@jm_h2
## ‘What’s Julia-specific about it? How does it “work well with” Julia?’
@@

* it has all the glyphs used in the Unicode Input chapter of the Julia documentation (except for the emojis)
* the glyphs were designed with the Julia programming language in mind
* the font contains special features such as contextual alternates, stylistic sets, and “ligatures” to complement Julia syntax

@@jm_h2
## ‘Where can I see it in action?’
@@

You can visit [this mirror of the Julia blog](https://julialangblogmirror.netlify.app/blog/). It hasn’t been updated for a while (it was useful during the development of [Franklin.jl](https://franklinjl.org)), but all the code examples use JuliaMono.

You can browse through [this local copy](/assets/images/juliamono/juliamanual/index.html) of an old Julia manual. The default Roboto-Mono font has been replaced with JuliaMono-Regular.

As an example of using JuliaMono with [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl)-generated documents, see the documentation for [Luxor.jl](https://github.com/JuliaGraphics/Luxor.jl).

@@jm_h2
## ‘I don’t like it as much as \$(myfavouritefont)’
@@

**That’s not a question!** But I know what you mean. Choice of work environment (editor, font, colour scheme, background music, preferred beverage, etc.) is very much a personal thing, and over the hours, days, and weeks that you work with your particular setup, you’ll grow accustomed to it, and unfamiliar work environments will look unappealing or even ugly. You’d probably need to try any alternatives for a while before you get more accustomed to them. Fortunately, you don’t have to try [Comic Code](https://www.myfonts.com/fonts/tabular-type-foundry/comic-code/), the [Kakoune editor](http://kakoune.org), the music of [Autechre](http://autechre.ws/), [Durian tea](https://www.tealeaves.com/products/durian), or anything else that’s new and unfamiliar; just stick to your current favourites!

@@jm_h2
## ‘How can I use the web fonts for my blog?’
@@

Find the relevant CSS file, and add a link to the WOFF2 stored on the server. For example:

```
@font-face {
	font-family: JuliaMono-Regular;
	src: url("https://cdn.jsdelivr.net/gh/cormullion/juliamono/webfonts/JuliaMono-Regular.woff2");
}
```

This accesses the current version the Regular font using the jsDelivr CDN (Content Delivery Network).

Then use CSS selectors:

```css
font-family: "JuliaMono";
```

You may prefer to serve the WOFF/2 fonts from your own server. One problem you might encounter is related to [Cross-origin resource sharing](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing), which on some browsers prevents one web page from downloading fonts from another.

@@jm_h2
## ‘How do I control features in CSS, in Atom/Juno, or VS Code?’
@@

### VS-Code

In VS-Code you’ll find the font settings somewhere in the labyrinthine (but thankfully searchable) Settings department.

![VS Code settings](/assets/images/juliamono/vscode-settings-1-800.png)

To control the display of contextual and stylistic alternates, click on the Edit Settings in JSON, and look for `editor.fontLigatures`:

![VS Code settings](/assets/images/juliamono/vscode-settings-2-800.png)

This uses the feature codes ([listed here](/#contextual_and_stylistic_alternates)). These should all be switched on or off in a single line.

For example, if you want all the alternate stylistic sets, use:

```css
"editor.fontLigatures": "'zero', 'ss01', 'ss02', 'ss03', 'ss04',
    'ss05', 'ss06',  'ss07', 'ss08', 'ss09', 'ss10'",
```

Or if you just don’t like the contextual alternates, prefer the slashed zero, a simpler g, and a lighter asterisk, use this:

```css
"editor.fontLigatures": "'calt' off, 'zero', 'ss01', 'ss05'",
```

### Atom/Juno

In the Atom/Juno stylesheet, you can specify the font with the required CSS selectors:

```css
font-family: "JuliaMono";
```

which defaults to the Regular weight, or

```css
font-family: "JuliaMono-Medium";
```

You can switch off the contextual alternates (such as `->` and `=>`) with:

```css
font-variant-ligatures: no-contextual;
```

Or on (if it’s not enabled by default) with:

```css
font-variant-ligatures: contextual;
```

Select any stylistic sets in a single line. For example:

```css
font-feature-settings: "zero", "ss02";
```

@@code_ss_on

<!--  force a paragraph  -->

~~~<p>enables the slashed zero (0) and the simpler "g".</p>~~~

@@

In Atom/Juno, you’d put these in the stylesheet, perhaps like this:

```css
atom-text-editor {
    font-variant-ligatures: no-contextual;
	font-feature-settings: "ss01", "ss02", "ss03",
	    "ss04", "ss05", "ss06";
}
```

<!--  force a paragraph  -->

@@jm_h2
## ‘Can I use this font in a notebook? And how do I do it?’
@@

It’s a good question. Some browsers these days are reluctant to give even you access to things on your own local disk, “for security reasons”. But a local copy of the font may be available and accessible on your particular set-up.

If not, you could try using web fonts, as above. For example, if there’s a Jupyter CSS file here:

```
~/.jupyter/custom/custom.css
```

you could add definitions like this:

```css
@font-face {
	font-family: JuliaMono-Regular;
	src: url("https://cdn.jsdelivr.net/gh/cormullion/juliamono/webfonts/JuliaMono-Regular.woff2");
}

.rendered_html table{
    font-size: 16px !important;
}

div.input_area {
    background: #def !important;
    font-size: 16px !important;
}

.CodeMirror {
    font-size: 16px !important;
    font-family: "JuliaMono-Regular" !important;
    font-feature-settings: "zero", "ss01";
    font-variant-ligatures: contextual;
}
```

which downloads the font once and is then available to applications.

~~~
<img src="/assets/images/juliamono/jupyter-example.png" alt="screenshot of jupyter editor">
~~~

@@jm_h2
## ‘How do I use the font for plotting, such as in Plots.jl?’
@@

Another great question. Are you sure you want a monospaced font on your plot? If you do, it should be easy enough to ask for the font when you plot. But it’s never as simple as you want it to be, as is usual in the world of fonts.

I know very little about plotting in Julia, but some investigations suggest that:

- `pyplot()` works well, mostly
- some backends do their own thing with fonts. For example, I couldn’t persuade the GR backend to use JuliaMono at all.

Here’s some code that uses JuliaMono for a plot. The plot shows the frequency of occurrence of every Unicode character used in the Julia git repository, and uses the characters as plot markers. I went through every text file and totalled all the characters - there are 956044 letter “e”s, and so on. I’m using `pyplot()`; the `freqs` DataFrame holds the characters and the counts. I’ve created a few font objects using `Plots.font()`, which makes it easier to use different text styles in the `plot()` function. I haven’t yet worked out how to use the different weights of a font family.

```
using Plots, Plots.PlotMeasures
pyplot()
theme(:dark)

juliamonofont8 = Plots.font(family="JuliaMono", 8,
    halign=:center, colorant"white")
juliamonofont12 = Plots.font(family="JuliaMono", 12,
    halign=:center, colorant"white")
juliamonofont80 = Plots.font(family="JuliaMono", 80,
    halign=:center, colorant"grey30")

annotation = "counting character frequencies\nin Julia source files "

p = plot(1:100,
    freqs[1:100, 2],
    fontfamily         = "JuliaMono",
    margin             = 20mm,
    yaxis              = :log10,
    annotation         = [
        (50, 1000, Plots.text(annotation, juliamonofont12)),
        (80, 1_000_000, Plots.text("", juliamonofont80))
        ],
    linewidth          = 0.25,
    series_annotations = Plots.text.(freqs[1:100, 1], Ref(juliamonofont8)),
    xlabel             = "← more frequent | less frequent → ",
    ylabel             = "occurrences (log scale) ",
    labelfontsize      = 6,
    titlefontsize      = 14,
    formatter          = :plain,
    size               = (800, 500),
	title              = "Top 100 characters\nin the Julia github repo ",
    legend             = false,
    )

display(p)
```

![frequency counts](/assets/images/juliamono/julia-frequencies.svg)

The top 9 characters - “etanirsol” - are a good match for the typical English frequency count e.g. “etarionsh”. it’s to be expected that parentheses make a very good showing, here.

Although over 3600 unique characters occur in the Julia documentation, about 3000 of them appear just once. All of them, except the emojis which aren’t in JuliaMono, could be plotted, but the long tail isn’t very interesting visually.

For plotting emoji characters, you’ll have to dive into the internals of the plots system...

Notice that the y-axis labels are in DejaVu Sans, provided with matplotlib. That’s because the `:log10` scaling code does its own $ \LaTeX $-y business, ignoring the current font. However, at least I was able to insert the Julia logo successfully, since it’s part of the JuliaMono font.

@@jm_h2
## ‘Can I use it in a $ \LaTeX $ document?’
@@

In a $ \LaTeX $ document, you should be able to define and use local fonts.

Robert Moss put together an excellent package to help negotiate the various font issues that you might encounter when using Unicode and $ \LaTeX $:

[A custom Julia language style for the LaTeX listings package, and Unicode support for the JuliaMono font in a lstlisting environment.](https://github.com/mossr/julia-mono-listings).

An earlier approach that worked for me is as follows:

In your $ \LaTeX $ source file, define the font, using the local pathname:

```
\newfontfamily \JuliaMono {JuliaMono-Regular.otf}[
    Path      = /Users/me/Library/Fonts/,
    Extension = .otf
    ]
\newfontface \JuliaMonoMedium{JuliaMono-Regular}
\setmonofont{JuliaMonoMedium}[
	Contextuals=Alternate
]
```

Then you can use something like `minted` to format the code.

~~~
<img src="/assets/images/juliamono/latex-example.png" alt="screenshot of latex ">
~~~

(I used the lualatex engine.)

@@jm_h2
## ‘There are problems with rendering and alignment’
@@

it’s well-known that there are two different styles of font rendering - the Apple way, and the Microsoft way. Apple and Microsoft have always disagreed in how to display fonts on screens. The argument has been going on for over a decade, now. For example, see [this blog post](https://damieng.com/blog/2007/06/13/font-rendering-philosophies-of-windows-and-mac-os-x).

In brief: Windows stretches and distorts the glyph shapes to better hit the pixel boundaries, but at the expense of distorting the forms. Apple renders the glyph shapes precisely, but uses antialiasing to smooth the outlines, making the type a bit fuzzy.

@@jm_h2
## ‘Aren’t these font files too big?’
@@

It depends if you mean the web fonts or the ‘desktop’ fonts. Web fonts come in two flavours, `.WOFF` and `.WOFF2`, where the `2` indicates a more recent and slightly more compact format. `JuliaMono-Regular.woff` is 674KB, `JuliaMono-Regular.woff2` is 619KB - the size of a PNG image, perhaps.

The `.TTF` versions are getting on for 1.8MB each.

For comparison, the Themes folder of `.CSS` files for the Julia manual (and for every manual built with Documenter.jl since v0.21) is about 700KB. So in that light the WOFF2 fonts aren’t that bad. Of course, the two Google fonts downloaded by every Julia document (Lato and Roboto) are tiny, at 14KB and 11KB, with 221 glyphs in each.

So, if you’re building a website, or designing for mobile applications, the size of the WOFF2 file(s) will be an important factor to weigh against the advantages of having predictable character sets. Note that you can specify font subsets in the CSS using the **unicode-range** feature, which defines a restricted set of characters which you know are going to be used, so that users don’t download any that they won’t need.

You could consider using the ‘-Latin’ variants to obviate the initial loading time.

@@jm_h2
## ‘How is this different from any other Unicode font?’
@@

You’re right, of course, there are many coding fonts, all perfectly adequate for the task of programming in Julia and most other languages. Comparing two different fonts is a matter of how important small similarities and differences are. Perhaps with one font you’ll see the occasional empty box or odd replacement rather than the character you were hoping for. Or perhaps sometimes you won’t like a particular glyph.

More likely, though, the overall ‘feel’ of a new and unfamiliar font - too narrow, too wide, too dense, too light, too quirky, too dull, too consistent, too variable - is a matter of personal taste, immune to objective measurement. The design goals of JuliaMono - readable, easy to use, unquirky, simple - mean that the shapes aren’t compressed or condensed. It’s not fashionably thin. It might feel quite “airy” because of the generously-spaced shapes. The punctuation is quite solid, which might not be to your taste; it’s much more important in code than in ordinary prose, and my eyesight is probably poorer than yours!

Most people probably can’t tell the difference between Helvetica and Arial, and certainly aren’t going to be bothered about minor differences between JuliaMono and other coding fonts. But that’s fine. Just stick to your current favourites!

@@jm_h2
## ‘Is it a package? Was it written in Julia? How will this contribute to the ecosystem of Julia language?’
@@

In the world of typographical software, one programming language is currently ubiquitous (hint: one of the leading programmers in the typography realm is **Just van Rossum**, one of the van Rossum brothers) and it’s not Julia.

The typeface isn’t a Julia package. It might be, soon! But although Julia wasn’t used to build the typeface, I did use Julia quite a lot while designing it; sometimes to generate glyphs, there being plenty of symmetrical designs that lend themselves to programmatic construction with a simple graphics program (e.g. [Luxor.jl](https://github.com/JuliaGraphics/Luxor.jl)). And also for producing glyph lists, charts, test output, and build scripts. And the various graphics you see here and in the specimen PDF were also made with Julia. So in that sense at least the font is a bit Julian.

And how will JuliaMono contribute? It’s often in the nature of an experiment that the outcome is uncertain until it’s been carried out.

@@jm_h2
## ‘Is it finished?’
@@

The first β release, version 0.001, was released on July 27, 2020.

The most recent β release, version 0.023, was released in October 2020. Always download the latest version if you want the typeface to perform as well as it can.

@@jm_h2
## ‘Why don’t these accents/marks work properly?’
@@

Unicode (and Julia) allows you to combine characters. In the REPL, you can type a character and then modify it by adding a mark or diacritic. For example:

```
e\vec
```

displays as

```
e⃗
```

and the arrow mark is displayed above the character. These **combining marks** are listed in the Unicode Input section of the Julia documentation. It’s sometimes possible to add more than one:

```
e\vec\dot
```

which JuliaMono renders like this:

```
e⃗̇
```

But this doesn’t work in all text environments, such as the terminals in Atom/Juno, VS Code, or Jupyter:

~~~
<img src="/assets/images/juliamono/font-terminal-comparison.png" alt="screenshots terminal emulators">
~~~

For Atom/Juno and VSCode, it’s due to limitations in the JavaScript terminal emulator they use (xterm.js) - there may be improvements in the future. Other terminal applications choose not to implement all OpenType features - they’re worried about the loss of performance, for example.

If it does work for you, this is fun:

```
jul\iota\ddot\dota
```

giving:

```
julϊ̇a
```

@@jm_h2
## ‘Does it work on macOS?’
@@

Yes. JuliaMono works well, with most modern MacOS text editors, such as Atom/Juno, Visual Studio Code, Sublime Text, the excellent free CotEditor, Panic's new Nova editor, and TextEdit, among others. If these editors support OpenType features such as stylistic alternatives and ligatures (not all do), these features of JuliaMono should work well.

With older applications, such as the old-school BBEdit text editor, you may experience a few glitches when using fonts such as FiraCode, IBMPlex Mono, JetBrains Mono, JuliaMono, Operator Mono, and Source Code Pro (to name the ones I checked). BBEdit doesn't support OpenType ligatures either.

@@jm_h2
## ‘Does it work on Linux?’
@@

Yes.

Font management in Linux may require you to become familiar with the `fontconfig` program. And it may be necessary to provide an additional configuration file (in `/etc/fonts/local.conf` for example), that contains instructions like the following:

```html
<alias>
    <family>monospace</family>
    <prefer>
		    <family>JuliaMono</family>
		</prefer>
</alias>
```

With some older terminal software the ligatures may cause problems (not that all terminals display ligatures properly, some are just confused by fonts that have them).

@@jm_h2
## ‘Does it work on Windows?’
@@

The font works well on a good quality display, but will struggle to maintain quality when displayed on low-resolution displays.

On Windows, the shapes of letters are distorted in order to place the important features of letters on pixels, rather than ‘between’ pixels (which could make features disappear). On high-resolution displays, as found on Apple devices, it isn't necesary to distort letter shapes in this way. The distortion is controlled by a process called ‘hinting’. On Windows displays, you may find that there is unevenness and variations in thickness and alignments, particularly at smaller sizes. This is due to the hinting generating distorted shapes to target pixels.

JuliaMono is an OTF/TTF-flavoured font that contains hinting instructions. Hinted fonts are larger than OTF/CFF (PostScript-flavour) as a consequence.

@@jm_h2
## ‘Any love for nerdfonts?’
@@

[nerdfonts](https://www.nerdfonts.com) can add about four thousand extra glyphs to a font. It does this by creating a new font that combines an existing font’s glyphs with a bunch of new ones, using a FontForge Python script. This is quite cool, in a way.

JuliaMono concentrates on the Unicode standard glyphs, as used for Julia code, whereas Nerdfonts adds many non-standard glyphs such as product and brand logos, trade names, icons for dozens of file extensions, programming languages, commercial applications, and a fair number of not-so-relevant characters. It’s aimed at a much wider audience. Nerdfonts doesn’t overlap much with JuliaMono.

The nerdfonts project is a bit of a hack - glyphs are pushed into areas that are outside the Private Use Area, and there’s some unnecessary duplication of icons and other Unicode characters. And, if you _do_ build a nerdfont version of JuliaMono, it will be quite large.

Perhaps the companies could contribute money to the Julia project in exchange for having their logos stored in the font...

@@jm_h2
## ‘I prefer the glyphs in this other font...’
@@

Good to know!

@@jm_h2
## ‘What about italics? How about JuliaSans?’
@@

One day perhaps.

@@jm_h1
# Footnotes
@@

@@jm_fndef
[^licence]:  &nbsp; “licence” Although not MIT-licensed like Julia, JuliaMono is licensed using the [SIL Open Font licence](https://scripts.sil.org/OFL), which allows the fonts to be used, studied, modified, freely redistributed, and even sold, without affecting anything they’re bundled with.

[^windows]:  &nbsp; “Windows” For more information about if and how it works on Windows, read [this](#does_it_work_on_windows), but I currently don't know enough about Windows font technology and how it differs from MacOS and Unix. Early reports said that the font didn't look good on Windows. This was because the format was CFF/PostScript OTF, which isn't hinted on Windows. A switch to TTF/TrueType OTF, which is hinted, was considered an improvement.

[^ohdear]: &nbsp; “downloading font problems” The problem might be something to do with the web security feature called [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS/Errors/CORSMissingAllowOrigin) which prevents a web page accessing the resources it needs.

[^masters]:  &nbsp; “masters” In fact there are only three masters (Light, Regular, and Black), and three instances (Medium, Bold, and ExtraBold), which are interpolated between them.

[^zscode]: &nbsp; “maths in code” spotted [here](https://github.com/JuliaArrays/StaticArrays.jl/issues/537#issuecomment-439863841)

[^languages]: &nbsp; “languages” Apologies for errors - I don’t speak most of these languages.

[^linespacing]: &nbsp; “terminals and line spacing” Terminal applications usually provide the option to vary the line spacing.  For perfectly smooth Unicode plots, you can adjust this until the shaded glyphs are in tune. But for coding purposes you might want the line spacing increased (or decreased) from the default, depending on the trade-off between reading speed, font size, and how many lines of code you can cram in.

[^greedy]: &nbsp; “greedy” referencing [this classic Julia blog post](https://julialang.org/blog/2012/02/why-we-created-julia/)

[^otherfonts]: &nbsp; “better fonts...” Operator Mono and Fira are excellent typefaces... Try them! Also try IBM Plex Mono, Iosevka, Recursive, and Victor Mono, to name a few of my favourites. Like programming languages, every typeface has its strengths and weaknesses. Perhaps keep JuliaMono for font fallback purposes... ;)

[^nottheonlyone]: &nbsp; “not the only one” Matthew Butterick says [“hell no”](https://practicaltypography.com/ligatures-in-programming-fonts-hell-no.html) to them. He also uses the phrase “well-intentioned amateur ligaturists” which isn’t a label I want to have. But more seriously, he says: “my main concern is typography that faces other human beings. So if you’re preparing your code for others to read — whether on screen or on paper — skip the ligatures.”

[^width]: &nbsp; “alternate glyphs” Note that the substitute glyphs occupy the same width as the source glyphs they're replacing. While you could in theory use one of the thousands of Unicode arrows, such as →, as a replacement for the ‘stabby lambda’ (~~~<span class="jm_code_ss_off">-></span>~~~), these are the width of a single character, and so you'd be changing the width of your string/line whenever you made the substitution.

[^typographypanel]: &nbsp; “Typography panel” These vary widely in their abilities and functions: the MacOS Terminal app’s Typography panel is comprehensive but I’m not convinced that all the buttons are wired up yet...

[^terminal]: &nbsp; “terminals again” Writers of terminal apps usually have their own ideas about how fonts and type should be managed and displayed. I haven’t yet found one that did everything that I wanted it to and nothing I didn’t expect it to. In the world of fonts, nothing is 100% correct, which can be frustrating. You can track some of the issues and discussions on github and elsewhere: here’s a [VS Code](https://github.com/microsoft/vscode/issues/34103) issue; here are the [Alacritty terminal developers](https://github.com/alacritty/alacritty/issues/50) working on it; here is the [iTerm documentation](https://iterm2.com/documentation-fonts.html) talking about performance.
@@

# Thanks!

Thanks to: Thibaut Lienart for his [Franklin.jl](https://github.com/tlienart/Franklin.jl) website builder; to Jérémie Knüsel who provided invaluable suggestions and advice; to Dr Zygmunt Szpak for his cool maths code; to Simeon Schaub for the issues and PRs, and to others in the Julia community for help and suggestions.


@@
