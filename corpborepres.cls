\let\footref\relax % if footref error appears
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{corpborepres}[2021-09-21]
\providecommand{\BeamerOptions}{} % extra beamer options someone may use from main.tex
\LoadClass[11pt,
	t, % top align content instead of middle
	aspectratio=1610,
	fleqn,
	\BeamerOptions
]{beamer}



\setbeamersize{
	text margin left=12mm,
	text margin right=12mm,
	sidebar width left=0pt,
	sidebar width right=0pt,
	description width=0.5em,
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            LuaStuff+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    \usepackage{ifluatex}
    \ifluatex
        \usepackage{luapackageloader} % todo is this even needd
        \usepackage{luacode}
        \usepackage{luakeys}
    %    \luadirect{}  % set default here
    \else
        \ClassError{corpboreport}{You did not use LuaLaTeX to compile! Try again}{}
        \ClassError{corpborepres}{You did not use LuaLaTeX to compile! Try again}{}
        \stop
        \usepackage[utf8]{inputenc}  % apparently this can be slow and is loaded by default % https://texfaq.org/FAQ-why-inp-font
    \fi



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            FontCMBotf+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% adopted from: https://tex.stackexchange.com/a/358621/186406
    % https://texdoc.org/serve/cm-unicode/0
    % https://texdoc.org/serve/cmbright/0
    
    \usepackage{fontspec}
    
    \setsansfont{cmunb}[        %CMU Bright for text
        Extension=.otf,
        UprightFont=*mr,
        ItalicFont=*mo,
        BoldFont=*sr, % semibold  % swap bold with semibold
        BoldItalicFont=*so, % semibold oblique
        NFSSFamily=cmbr
        ]
    
    \usepackage{cmbright}       %CMU Bright for math
    \gdef\bfdefault{sb}
    \gdef\sbdefault{bx}         % swap sb with bf
    
    %\renewcommand{\ttdefault}{lmtt}  % has bold series, but the normal weight is a bit thicker
    \setmonofont{CMU Typewriter Text Light} % monospace  % does not have bold but matches main font better
    
    \DeclareSymbolFont{iwonalargesymbols}{OMX}{iwona}{m}{n}
    \DeclareMathSymbol{\intop}{\mathop}{iwonalargesymbols}{"52}
    
    % todo try https://tex.stackexchange.com/questions/204778/difficulty-finding-selecting-cm-bright-using-fontspec
    
    
    \usepackage[%
      protrusion=true,
      expansion,
      final,
      tracking=true,
      letterspace=120,
      factor=1000,%(/1000), subtle
      stretch=10,%(/1000 %)
      shrink=10
    ]{microtype}
    
    % upper and lowercase number commands -- not applicable if using serif, I choose uppercase only for simplicity
    \def\togunums{}
    \def\toglnums{}
    \NewDocumentCommand{\lnum}{m}{}
    \NewDocumentCommand{\unum}{m}{}
    
    \def\act{}
    \def\actext#1{#1}
    
    
    
    
    
    
    
    
    \gdef\sbseries{\fontseries{sb}\selectfont}
    
    \DeclareRobustCommand{\sm@ller}{%
    \dimen@\f@size\p@
    \ifdim \dimen@ > 12\p@
    \dimen@=0.83333\dimen@
    \else
    \advance \dimen@ -2\p@
    \fi
    \math@fontsfalse
    \fontsize{\the\dimen@}\z@
    \selectfont
    }
    \newcommand{\textc}[1]{{\sm@ller\uppercase{#1}}}
    \newcommand{\sbfCMB}[1]{\textbf{\textit{#1}}}
    
    
    %\def\sbfCMB#1{\ThisStyle{\setbox0=\hbox{$\SavedStyle#1$}%
    %		#1\kern.2pt\kern-\wd0%
    %		\raisebox{.1pt}{$\SavedStyle#1$}}}
    
    
    %%% patching
    
    \newcommand{\mathup}[1]{\text{\textup{#1}}}  % patching needed for mathup

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            FontKPotf+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    \usepackage[onlyrm,light]{kpfonts-otf}  % https://texdoc.org/serve/kpfonts-otf/0
    
    \setsansfont[Scale=MatchLowercase]{CMU Bright} % monospace that looks nice with light kpfont
    \setmonofont[Numbers=Lining]{CMU Typewriter Text Light} % monospace that looks nice with light kpfont
    
    \usepackage[activate=true,% this package makes the font look nicer
        final,%
        tracking=true,%
    ]{microtype}
    %	kerning=true, % only works with pdftex
    \SetTracking{encoding=*, shape=sc}{18}  % adjust small caps letter spacing
    
    
    \def\togunums{\addfontfeature{Numbers=Lining}} %% from kpfonts.sty
    \def\toglnums{\addfontfeature{Numbers=OldStyle}}
    
    % if {} provided, apply to grouped text only--if *, apply toggle
    \NewDocumentCommand{\lnum}{m}{\ifstrequal{#1}{*}{\toglnums}{\oldstylenums{#1}}}
    \NewDocumentCommand{\unum}{m}{\ifstrequal{#1}{*}{\togunums}{\liningnums{#1}}}
    
    
    \let\classicstylenums\liningnums
    
    %\NewDocumentCommand{\act}{o}{\IfValueTF{#1}{\textsc{\lnum#1}}{\scshape\toglnums}}  % acronym text style
    \NewDocumentCommand{\act}{m}{\ifstrequal{#1}{*}{\scshape\toglnums}{\textsc{\lnum{#1}}}}  % acronym text style
    %% see BibAndGloss for other ac* commands
    
    
    \AtBeginEnvironment{tabular}{\togunums}
    \AtBeginEnvironment{tabular*}{\togunums}
    \AtBeginEnvironment{tikzpicture}{\togunums}
    
    \def\cbp@secnumsize{\toglnums} % dont allow cpb to use smaller numbers in section
    \newcommand{\cbp@appendixletformat}[1]{\scshape\alph{#1}}
    \def\cbp@appendixsecformat{\scshape\MakeLowercase}
    
    
    
    % Rules for number casing:
    %   Uppercase: quantities, page numbers, citations
    %   Lowercase: section numbers, dates, itemized lists
    % Rules for small capitals
    %   Only applied for 'label-like' items. Eg. doi: 123 or gpa: or date [yyyy-mm-dd]
    %   Acronyms to appear in uppercase
    
    
    %% for non-light option
    %\def\togunums{\fontfamily{jkp}\selectfont} %% from kpfonts.sty
    %\def\toglnums{\fontfamily{jkpxosn}\selectfont} for non-light



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            TextandParas+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % ##############################################
    % Text / Para Settings and utils
    % ##############################################
    
    
    \ifluatex
        \usepackage{polyglossia} % helps with hyphenation
        \setdefaultlanguage[variant=canadian]{english}
    \else
        \usepackage[english]{babel} % helps with hyphenation
    \fi
    
    
    \usepackage{csquotes} % helps with hyphenation and ""
    
    %%% GENERAL FORMATTING
    \usepackage{ragged2e}
    \usepackage{blindtext}
    
    %% Boxes and stuff
    \usepackage[usestackEOL]{stackengine}  % used for title page and stacking things
    \usepackage{setspace}  % enable onehalfspacing instyling
    \usepackage{relsize}  % relative sizing
    \usepackage{pbox}  % create box of max width http://ctan.mirror.colo-serv.net/macros/latex/contrib/pbox/pbox.pdf
    
    
    
    \usepackage{fontawesome5}
    
    
    \newcommand{\vparspace}{\vspace{\parskip}}
    
    \def\tspc{\nobreak\hspace{.08em plus .04em}} % tiny space
    \def\tspcs{\tspc{}s} % tiny space
    
    
    \let\oldcenter\center
    \let\oldendcenter\endcenter
    \renewenvironment{center}{\setlength\topsep{0pt}\oldcenter}{\oldendcenter}  % removes extra sep
    
    \let\oldflushleft\flushleft
    \let\oldendflushleft\endflushleft
    \renewenvironment{flushleft}{\setlength\topsep{0pt}\oldflushleft}{\oldendflushleft}
    
    %% some latex stuff
    \newcommand{\Llap}[1]{\leavevmode\llap{#1}}  % llap if first thing
    \newcommand{\Rlap}[1]{\leavevmode\rlap{#1}}  % ..
    \newcommand{\Clap}[1]{\leavevmode\clap{#1}}
    \newcommand{\Hfill}{\null\hfill}  % hfill if first thing
    \newcommand{\Vfill}{\null\vfill}  % hfill if first thing
    
    
    \newcommand\ensurecomma{%
    \@ifnextchar,{}{\@latex@error{Don’t forget the comma!}{}}}
    \newcommand\ex{e.g.\ensurecomma}
    \let\eg\ex
    \newcommand\ie{i.e.\ensurecomma}
    \newcommand\ensuresingleperiod{\@ifnextchar.{}{.\@}}
    \newcommand\etc{etc\ensuresingleperiod}
    \newcommand\etal{et~al\ensuresingleperiod}
    
    
    
    \usepackage[utf8]{luainputenc}
    
    \DeclareUnicodeCharacter{2014}{\dash}
    \AtBeginDocument{\pdfstringdefDisableCommands{\renewcommand{\dash}{ - }}}
    
    \DeclareRobustCommand\dash{%
      \unskip\nobreak\thinspace\textemdash\allowbreak\thinspace\ignorespaces}
    
    \DeclareRobustCommand\mdash{%
        \unskip\nobreak\thinspace\textemdash\thinspace\ignorespaces}
    
    \DeclareRobustCommand\ndash{%
        \unskip\nobreak\thinspace\textendash\thinspace\ignorespaces}
    
    
    \directlua{
      function autoemdash(s) return string.gsub(s,'[-][-][-]', '\string\\mdash ') end
      function autoendash(s) return string.gsub(s,'[=][-][-]', '\string\\ndash ') end
      function autodashes(s) return autoendash(autoemdash(s)) end
    }
    
    % todo trial replacement of unicode characters , eg. string.utfcharacter(0xFFFD)
    
    \def\autoendash{\directlua{luatexbase.add_to_callback("process_input_buffer", autoendash,"auto spaced en dashes")}}
    \def\autoemdash{\directlua{luatexbase.add_to_callback("process_input_buffer", autoemdash,"auto spaced em dashes")}}
    \def\autodashes{\directlua{luatexbase.add_to_callback("process_input_buffer", autodashes,"auto spaced dashes")}}
    
    \def\autoendashoff{\directlua{luatexbase.remove_from_callback("process_input_buffer","auto spaced en dashes")}}
    \def\autoemdashoff{\directlua{luatexbase.remove_from_callback("process_input_buffer","auto spaced em dashes")}}
    \def\autodashesoff{\directlua{luatexbase.remove_from_callback("process_input_buffer","auto spaced dashes")}}
    
    
    
    % ##############################################
    % Paragraph stretching and spacings
    % ##############################################
    
    % This is an suggestion from Axel Reichert (LaTeX package author)
    % See CTAN: http://www.ctan.org/author/reichert
    % See CTAN: http://www.ctan.org/pkg/l2tabu-english (Cgapter: 1.8 Should I use \sloppy?)
    
    % 10000 is the highest
    \tolerance=2800
    \hbadness=1414
    \emergencystretch=1.5em
    \hfuzz=0.3pt
    \widowpenalty=4000
    \clubpenalty=4002
    \brokenpenalty=101
    \displaywidowpenalty=50
    \vfuzz \hfuzz
    
    
    %\if@twoside%
    %	\raggedbottom
    %\fi%  finally do nothing
    %	\raggedbottom
    
    
    


\def\cbp@secnumsize{}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            MathSymbolsEtc+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% References %%%%%
    % siunitx: https://texdoc.org/serve/siunitx/0
    % mathtools: https://texdoc.org/serve/mathtools/0
    
    % mathtools loads amsmath
    \usepackage[fleqn,leqno]{mathtools} % NOTE: amsmath loaded before kpfonts for fleqn issue should load amsmath
    \usepackage{bm}
    
    %	\usepackage{gensymb} % bug in this package currently w/ kpfonts
    \usepackage{xfrac}
    \usepackage{amsfonts}  % math fonts and symbols
    
    \renewcommand{\theequation}{{\cbp@secnumsize\arabic{chapter}.\arabic{equation}}}
    
    %\def\@cbp@mathline{\raisebox{0pt}[0pt][0pt]{\vline height 0.8em depth 0.6em width \arrayrulewidth}}
    %\renewcommand\tagform@[1]{\maketag@@@{\ignorespaces\makebox[6ex][l]{\@cbp@mathline\;\cbp@secnumsize#1\unskip\@@italiccorr\hfill}\hspace*{5ex}}}
    
    \def\@cbp@mathline{\raisebox{0pt}[0pt][0pt]{\vline height 0.8em depth 0.6em width \arrayrulewidth}}
    %\renewcommand\tagform@[1]{\maketag@@@{\ignorespaces\makebox[6ex][r]{\ \hfill\cbp@secnumsize#1\;\@cbp@mathline\unskip\@@italiccorr\hspace*{2ex}}}}
    \renewcommand\tagform@[1]{\maketag@@@{\ignorespaces\makebox[6ex][r]{\@cbp@mathline\;\cbp@secnumsize#1\;\unskip\@@italiccorr\hspace*{2ex}}}}  % modificaiton for thesis
    
    %% for right side equation num
    %\renewcommand\tagform@[1]{\maketag@@@{\ignorespaces\makebox[6ex][l]{\@cpb@mathline\;\cpb@secnumsize#1\unskip\@@italiccorr\hfill}\hspace*{5ex}}}
    
    
    \providecommand{\togunums}{}  % toggle to uppercase number shortcut
    
    \usepackage[free-standing-units, % allow declared units usage outside of \qty and \unit
    	unit-optional-argument,  % allows declared units to have number after \kV[10]
    	detect-all=true, % allows italic/bold units
    	space-before-unit=true,
    	text-font-command=\togunums,
    	use-xspace=true,
    	table-number-alignment=center,
    	table-text-alignment=center,
    	table-align-text-post=false,
    	table-align-text-pre=false,
    ]{siunitx} % http://ctan.mirror.rafal.ca/macros/latex/contrib/siunitx/siunitx.pdf
    
    \providetoggle{useSerif}
    \iftoggle{useSerif}{}{
    	\usepackage{amssymb}   % only load if not serif, had issues with kpfont-otf
    %	\sisetup{math-micro=\text{µ},text-micro=µ}
    %	\sisetup{math-micro=\text{\mu},text-micro=$\text{\mu}$}  % as per https://tex.stackexchange.com/questions/33965/siunitx-%C2%B5-doesnt-work
    }
    
    
    
    %\newenvironment{mathwhere}
    %  {where:\vspace{\abovedisplayskip}\noindent\begin{tabularx}{\linewidth}{>{$}l<{$} !{is} Z}}
    %  {\end{tabularx}\par\vspace{\belowdisplayskip}}
    
    
    \NewDocumentEnvironment{mathwhere*}{ +b }{%
    \begin{tabularx}{0.8\linewidth}[t]{>{$}l<{$}  Z}
    					 #1
    \end{tabularx}\par\vspace{\belowdisplayskip}
    	}{}
    
    \NewDocumentEnvironment{mathwhere}{+b}{%
    where:\\[0.3ex]
    \hspace*{3ex}
    \begin{AutoPuncTabular}
    	\begin{mathwhere*}
    		#1
    	\end{mathwhere*}
    \end{AutoPuncTabular}
    	}{}
    
    
    \DeclareInstance{xfrac}{KpLight}{text}
    {slash-symbol-font = ptm,
    scaling = false,
    denominator-bot-sep = 10 pt,
    numerator-bot-sep = 10 pt,
    }
    %\UseCollection{xfrac}{KpLight}

\renewcommand\tagform@[1]{#1}

\usepackage[fleqn,leqno]{amsmath} % need to load before kpfonts-otf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            Utilities+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    \usepackage{scrhack}
    \usepackage{listings}  % re-loaded in code boxes, but needs to be loaded before changing ToC structure
    
    
    \usepackage{etoolbox} %
    
    \usepackage{xparse} % smart definition of commands
    \usepackage{pdftexcmds}  % string comparison with expanded input args
    \usepackage{xpatch}  %add to e toolbox pre, app, etc. to command or environments, https://ctan.math.illinois.edu/macros/latex/contrib/xpatch/xpatch.pdf
    
    \RequirePackage{datetime2}
    \DTMsetup{datesep={-}}
    
    \usepackage{calc}  % allows us to use expressions like {\linewidth-2ex} in commands
    \usepackage{xfp}  % floating point math, should remove as it is a part of new latex dist
    \usepackage{xspace}  % smartly looks at space after commands
    
    %\usepackage{tabto}% possibly usful for two column lists %http://tug.ctan.org/tex-archive/macros/latex/contrib/tabto/tabto-doc.pdf
    %%%
    
    \usepackage{import}
    \usepackage{catchfile} % catches a .tex file as a command
    
    %%% pdf stuff
    \usepackage{pdflscape}
    \usepackage{pdfpages}  % provides \includepdf command
    \usepackage{grffile}  % removes the pdf file name for includegraphics with a pdf file type
    \usepackage{afterpage} % can add code after page done, helps with pdflscape with inserting a page randomly,
    
    \usepackage[export]{adjustbox} % provide additional commands for graphicsx allows us to adjust graphics,  http://mirrors.ibiblio.org/CTAN/macros/latex/contrib/adjustbox/adjustbox.pdf
    
    
    \newtoggle{csdefined}
    
    \newcommand{\ifdefOR}[4]{%
    \togglefalse{csdefined}%
    \ifdef{#1}{\toggletrue{csdefined}}{}%
    \ifdef{#2}{\toggletrue{csdefined}}{}%
        \iftoggle{csdefined}{#3}{#4}%
        \togglefalse{csdefined}%<<<todo I should confirm global behaviour...
    }
    
    
    \newcommand{\invtoggle}[1]{% invert a toggle
    \iftoggle{#1}{\togglefalse{#1}}{\toggletrue{#1}}%
    }
    
    \newcommand{\gettogglestate}[1]{% get a toggles state
    \iftoggle{#1}{true}{false}%
    }
    
    
    \let\strcmp\pdf@strcmp
    
    \NewDocumentCommand{\ifstringeqx}{m m m O{}}{% if string equal fully expanded
        \ifnum\strcmp{#1}{#2}=0 #3\else#4\fi%
    }
    
    \NewDocumentCommand{\DoIfnotEmpty}{m m O{}}{%
        \ifstringeqx{#1}{}{#2}{#3}%
    }
    
    % requires ifthen package, does #2 if #1 is NOT empty, othwerise (optionally) do #3 can take command inputs
    
    \newcommand{\DoWithoutPrinting}[1]{\setbox0\vbox{#1}} % https://tex.stackexchange.com/questions/417327/is-it-possible-to-compile-but-not-showing-a-part
    
    \newcommand{\DontDo}[1]{} %command that does nothing
    
    
    \newcommand*\makealph[1]{\symbol{\numexpr96+#1}}% also can use \numexpr`a-1+#1
    \newcommand*\makeAlph[1]{\symbol{\numexpr64+#1}}
    
    
    %% x parse pre-processor, expands an argument, use by putting >{\ExpArgOnceProc} in front of arg spec
    % https://tex.stackexchange.com/questions/616804/using-definitions-for-key-val-arguments/616814#616814
    \newcommand\ExpArgOnceProc[1]
      {\edef\ProcessedArgument{\unexpanded\expandafter{#1}}}
    
    \ProvideDocumentCommand{\providelength}{ m m }{%
        \ifdeflength{#1}{% It is already defined!
        }{% Not defined, so define it!
            \newlength{#1}%
            \setlength{#1}{#2}
        }{}%
        }%
    
    
    
    %% todo need pdf string title, must check YAML vars for this.. strip out basic commands
    %% https://tex.stackexchange.com/questions/351877/hyperref-pdftitle-manages-line-breaks-in-a-strange-way
    %%
    
    
    \usepackage{luacode} %
    %% Replace text in a latex definition
    % * will redefine the macro, leaving it will only print the new val
    \begin{luacode*}
    function DefReplText(s, def, bef, aft)
        local DefReplTextVal = token.get_macro(def)
        DefReplTextVal = DefReplTextVal:gsub(bef, aft)
        if s == _xFalse then
            tex.sprint(DefReplTextVal)
        else
            token.set_macro(def, DefReplTextVal ,'global')
        end
    end
    \end{luacode*}
    \NewDocumentCommand{\DefReplText}{ s m m m }{\luadirect{%
        DefReplText(\luastring{#1},\luastringN{#2},\luastringN{#3},\luastringN{#4})
    }}
    
    \NewDocumentCommand{\MakeOneLineDef}{m o}{%
    todo take a definition, string \\ with single space, and add xspace.
    Useful for pdftitles, other things
    \begin{luacode*}
    -- do something here to make a definition
    \end{luacode*}
    }
    
    
    
    % enumerate text           *A +a   {pre} {num} {post} <inbetween>  <between last two>
    \NewDocumentCommand{\enumtext}{s t+ O{} m  O{} D<>{, } D<>{#6}}{%
    \foreach \n in {1,...,#4}{%
        #3%
        \IfBooleanTF{#1}{\makeAlph{\n}}{\IfBooleanTF{#2}{\makealph{\n}}{\n}}%
        %
        #5%
        \ifnum\n<\fpeval{#4-1}%
        #6%
        \else%
        \ifnum\n<\fpeval{#4}%
        #7%
        \fi%
        \fi%
    }}
    
    % iter text, sandwhich in between  [before] {list of text}  [after]
    % mandatory argument can be {Kale,Britt,Serena}, or {1,3,...,9}
    \NewDocumentCommand{\itertext}{O{} m D(){} O{,\ }}{%
    \foreach \n in {#2}{%
        \mbox{#1\n#3}#4%
    }}
    
    %% todo better syntax
    %\itertext<b>{1,2}<a>[; ] --> b1a, b2a,
    
    
    
    % overlay boxes
    \NewDocumentCommand{\overlaytr}{m}{%
      \Llap{\raisebox{\dimeval{(-\height+1.6ex)}}[0pt][0pt]{#1}}%
    }
    \NewDocumentCommand{\overlaybr}{m}{%
      \Llap{\raisebox{0pt}[0pt][0pt]{#1}}%
    }
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            Tables+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% TABLES
    \usepackage{array}
    \usepackage{multirow}
    \usepackage{makecell}
    \usepackage{colortbl} %
    \usepackage{rotating}
    
    \usepackage{tabularx}  % WARNING  supposed to be loaded after hyprref !!! investigate
    \usepackage{ltxtable}  % long table with tabularx
    \usepackage{longtable}
    
    \usepackage{booktabs}  % http://ctan.mirror.globo.tech/macros/latex/contrib/booktabs/booktabs.pdf
    
    % Table spacing
    %\renewcommand{\arraystretch}{1.0}  % normal table stretch.. can modify
    %\setlength\tabcolsep{2ex}  % additional padding on sides of tables
    
    \setlength\heavyrulewidth{0.8pt}
    \setlength\lightrulewidth{0.4pt}  % latex default rule is 0.4 pt
    \setlength\cmidrulewidth{0.3pt}  % latex default rule is 0.4 pt
    
    \providetoggle{useSerif}
    \iftoggle{useSerif}{
    	\setlength\heavyrulewidth{0.7pt}
    	\setlength\lightrulewidth{0.4pt}  % latex default rule is 0.4 pt
    	\setlength\cmidrulewidth{0.3pt}
    }{}
    
    \let\nl\\  % shortcut for \newline and \\
    
    \def\MoreRowHeight{\rule{0pt}{0.9em}}
    
    % fixed column width, ragged right instead of horizontally filled allows new line
    \newcolumntype{P}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}
    \newcolumntype{M}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}
    \newcolumntype{B}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}b{#1}}
    
    % vertical and horizontally centerred
    \newcolumntype{T}[1]{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}p{#1}}  % vertically centered instead of top
    \newcolumntype{V}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}  % vertically centered instead of top
    
    \newcolumntype{Z}{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}X}  % ragged right instead of filled, \newline lets you break lines
    \newcolumntype{Y}{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}X} % centered tabular X
    
    % things to consider, siunitx + tabularx?
    % https://tex.stackexchange.com/questions/12663/how-to-use-siunitx-and-tabularx-together
    % really want a way to distrubute columns evenly under a multicolumn cell that is wider than the two columns
    
    \sisetup{range-phrase=--,
    	table-number-alignment=center,
    	table-text-alignment=center,
    	table-align-text-post=false,
    	table-align-text-pre=false,
    }
    % https://tex.stackexchange.com/questions/469345/newcolumntype-with-optional-argument  todo consider this, but not working
    
    \newcolumntype{N}[1]{S[table-format=#1,table-alignment=center]}  % centered SI column,  N == number
    \newcolumntype{L}[1]{S[table-format=#1,table-alignment=left]}    % left SI column
    \newcolumntype{R}[1]{S[table-format=#1,table-alignment=right]}   % right SI column
    % S unit tables http://tug.ctan.org/macros/latex/exptl/siunitx/siunitx.pdf
    %%%
    
    \newcolumntype{~}{@{\hspace{\tabcolsep}}}
    
    
    % table note stuff
    \newlength{\TabNoteSpace} \setlength\TabNoteSpace{-1.3ex}
    
    
    % long table stuff
    \newlength{\LongTabNoteSpace} \setlength\LongTabNoteSpace{-4.5ex}
    
    
    \newcommand{\LTnotes}[2][\linewidth]{% todo might wanna fix this so it's more automatic
        \vspace{\LongTabNoteSpace}% manually tested
        \parbox{#1}{\footnotesize #2}}
    
    \NewCommandCopy\LongTableNotes\LTnotes
    
    \NewDocumentCommand{\LTcaption}{O{#2} m O{}}{{\WideFloatCaption\captionof{table}[#1]{#2}#3}}  % #3 is for \label{}
    
    \AfterEndEnvironment{longtable}{\addtocounter{table}{-1}} % hack to fix LTX/longtable numbering issue, seems to increment by 1
    
    \def\LTcontinues{\MC[+r]{\Llap{\ \hfill\textsl{Table continues on next page\ldots}}}}
    \def\LTcontinued{\MC[+l]{\Rlap{\textsl{\ldots Table continued from previous page}}}\\}
    
    %% example longtable header
    
    %\def\LTheader{\toprule {Section} & {Item} & {Comment}\\\midrule}
    %\setmidruleX{reset=true}
    %\LTcaption{}
    %\begin{longtable}{@{}lp{3cm}X@{\midruleX}}
    	%\LTheader\endfirsthead        % first header
    	%\LTcontinued\LTheader\endhead % headers after page break
    	%\LTcontinues\endfoot          % footers before page break
    	%\bottomrule\endlastfoot       % last footer
    	%\resetmidruleX
    	% ...
    
    
    
    
    % table foot notes: use tnote{a} in the table for superscript marker, and \tfnote{a}Note here in the footnotes of table
    \NewDocumentCommand{\tabfnote}{m}{\Llap{#1.\enspace}}
    \NewDocumentCommand{\tabnote}{s m}{%
    	\IfBooleanTF{#1}%
    		{\textsuperscript{#2}}%
    		{\rlap{\textsuperscript{#2}}}% without star, footnote label to take no space
    }%
    
    \NewDocumentCommand{\tfnote}{m}{\tabfnote{\uref{#1}}} % automatic table footnotes--semantic footnote labelling instead of abc
    \NewDocumentCommand{\tnote}{s m}{%
    	\IfBooleanTF{#1}%
    		{\tabnote*{\uref{#2}}}%
    		{\tabnote{\uref{#2}}}%
    }% use tnote{a} in the table, and \tfnote{a}Note here in the foot notes
    
    
    % adding on to MC
    \NewExpandableDocumentCommand{\MCh}{ O{2c_}   D(){rl} m }{\MC[#1#2]{#3}} % a 'hierarchical' cell, usually spans two, has underline
    \NewExpandableDocumentCommand{\MCb}{ O{,-2b}  D(){}  m }{\MC[#1#2]{#3}}  % a 'bottom' header cell of height 2, usually beside MCh on row after


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            Colors+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    \usepackage{xcolor}
    
    % todo confirm with xckd colors
    % https://xkcd.com/color/rgb/
    
    \definecolor{offwhite}{RGB}{255,253,248}
    
    \definecolor{lightgray}{RGB}{191, 191, 191}
    \colorlet{lightgrey}{lightgray}
    \definecolor{gray}{RGB}{128, 128, 128}
    \definecolor{darkgray}{RGB}{64, 64, 64}
    
    \definecolor{brightindigo}{RGB}{5, 1, 200}
    \definecolor{indigo}{RGB}{4, 1, 180}
    \definecolor{darkindigo}{RGB}{3, 0, 110}
    \definecolor{verydarkindigo}{RGB}{2, 0, 40}
    
    \definecolor{darkred}{RGB}{180, 0, 0}
    \definecolor{green}{RGB}{0, 130, 10}  % green color, used for code syntax and plots
    \definecolor{mygreen}{RGB}{0, 130, 10}  % green color, used for code syntax and plots
    
    \definecolor{mybrown}{HTML}{292826}
    \definecolor{mybeige}{HTML}{C3BDA5}
    
    
    % https://umanitoba.ca/sites/default/files/2019-12/UM_Brand-Guidelines.pdf
    \definecolor{umbrown}{RGB}{79, 44, 29}
    \definecolor{umdarkblue}{RGB}{56, 94, 157}
    \definecolor{umlightblue}{RGB}{0, 163, 224}
    \definecolor{umyellow}{RGB}{242, 169, 0}
    
    
    
    % for coding
    \colorlet{accCol}{indigo}  % accent color
    \colorlet{contCol}{darkred}    % contrast color
    \colorlet{grayCol}{gray}   % gray color
    \colorlet{greCode}{green}   % gray color
    
    \def\blacksectionheadings{
       \setaccentcolor{.} % . is current color, so if you invert it will change
    }
    
    
    \NewDocumentCommand{\setaccentcolor}{m}{
        \colorlet{chapCol}{#1}
        \colorlet{secCol}{#1}
        \colorlet{subsecCol}{#1}
        \colorlet{subsubsecCol}{#1}
        \colorlet{parCol}{#1}
    }
    
    \setaccentcolor{.}
    
    
    \NewDocumentCommand{\setcolortheme}{m}{
        \ifstrequal{#1}{blues}{\cbp@colorthemeblues}{}
        \ifstrequal{#1}{brown}{\setaccentcolor{umbrown}}{}
    }
    
    \NewDocumentCommand{\cbp@colorthemeblues}{}{
        \colorlet{chapCol}{indigo}
        \colorlet{secCol}{darkindigo}
        \colorlet{subsecCol}{verydarkindigo}
        \colorlet{subsubsecCol}{.}
        \colorlet{parCol}{.}
    }
    
    
    
    \definecolor{pltblue}{HTML}{1000F0}
    \definecolor{pltred}{HTML}{B30000}
    \definecolor{pltgreen}{HTML}{00820A}
    \definecolor{pltorange}{HTML}{F05F00}
    \definecolor{pltyellow}{HTML}{FFC30B}
    \definecolor{pltpurple}{HTML}{820078}
    
    \colorlet{pltcyan}{cyan}   % gray color
    % todo add option for markers
    \NewDocumentCommand{\pltLineIcon}{m}{%
        \mbox{({\color{plt#1}#1 \raisebox{0.6ex}{\rule{1em}{0.8pt}}})}%
    }


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            FloatsCaptions+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% References %%%%%
    % afterpage: https://texdoc.org/serve/afterpage/0
    % floatrow:  https://texdoc.org/serve/floatrow/0
    % caption:   https://texdoc.org/serve/caption/0
    
    % todo clean this up as per MWE I created!!!, tweak the spacing!!
    
    % Numbering for figures/tables as per section
    %\numberwithin{figure}{section}  % fig 4.1, 4.2, etc.
    %\numberwithin{table}{section}
    
    
    \usepackage{graphicx}
    \usepackage{afterpage}
    \usepackage{graphbox}  %% allows smash command for easier graphics placement
    \usepackage[skip=3pt,justification=raggedright,singlelinecheck=false,format=hang]{caption} %
    \usepackage{floatrow}% http://tug.ctan.org/tex-archive/macros/latex/contrib/floatrow/floatrow.pdf  (dont use float pack)
    \usepackage{subcaption} % http://mirrors.ibiblio.org/CTAN/macros/latex/contrib/caption/subcaption.pdf
    
    \renewcommand\FB@putfoots{% % patch below to not affect color after footnote
      \ifvoid\flrow@foot\else\FR@ifFOOT
      {\vskip\floatfootskip\color@begingroup\normalcolor
      \unvbox\flrow@foot\@@par\color@endgroup}\relax
      \fi}
    
    
    \DeclareCaptionLabelFormat{hangcap}{\llap{#1~#2:\enspace}}
    \DeclareCaptionLabelFormat{widecap}{#1~#2:}
    \captionsetup{labelformat=hangcap}
    \providetoggle{useSerif}
    \DeclareCaptionLabelSeparator{enspace}{\enspace}
    \captionsetup{labelfont=bf,labelformat=hangcap,labelsep=enspace}
    \iftoggle{useSerif}{
      %%%% for small caps
    %  \DeclareCaptionLabelFormat{hangcap}{\llap{\MakeLowercase{#1}~#2\enspace}}
    %  \DeclareCaptionLabelFormat{widecap}{\MakeLowercase{#1}~#2}
    %  \DeclareCaptionFont{bfscln}{\bfseries\scshape\toglnums}
    %  \captionsetup{labelfont=bfscln,labelformat=hangcap,labelsep=enspace}
      %%%% for not small caps
      \DeclareCaptionLabelFormat{hangcap}{\llap{#1~#2\enspace}}
      \DeclareCaptionLabelFormat{widecap}{#1~#2}
      \DeclareCaptionFont{bfln}{\bfseries\toglnums}
      \captionsetup{labelfont=bfln,labelformat=hangcap,labelsep=enspace}
    }{}
    \captionsetup[sub]{skip=8pt, aboveskip=5pt, font=small, labelfont={small,bf,sc},
    	position=top,labelformat=hangcap,labelsep=enspace}  % formats \subcaptionbox
    \floatsetup{justification=raggedright,objectset=raggedright}
    \floatsetup[table]{captionskip=0.3ex} %	 http://tug.ctan.org/tex-archive/macros/latex/contrib/floatrow/floatrow.pdf
    \floatsetup[figure]{captionskip=0.5ex} % for bottom caption
    %\iftoggle{TopFigCap}{\floatsetup[figure]{captionskip=0.3ex}\let\captop\{}}  % optional top caption for figure
    
    \newcommand{\WideFloatCaption}{\captionsetup{labelformat=widecap,format=plain}}
    
    \newlength{\floatindentlength}\setlength{\floatindentlength}{11ex}
    
    \setlength{\intextsep}{17pt}  % distance between floats on the top or the bottom and the text, baseline skip plus some
    \setlength{\floatsep}{24pt plus 2.0pt minus 2.0pt} % distance between two floats; add rubber here
    \setlength{\textfloatsep}{24pt plus 2.0pt minus 2.0pt} % distance between floats inserted inside the page text (using h) and the text proper, add rubber here
    
    \newlength{\fullheight}  % full height for pdfs/figures
    \setlength{\fullheight}{22cm}
    
    \NewDocumentCommand{\cbp@setFloatCap}{m m}{% by default (no star), use a wide float. If *, indent it. If no +, justify caption. If +, ragged right
      \captionsetup{margin={0pt,0pt}}% restore margin for caption
      \IfBooleanTF{#2}{\captionsetup{justification=raggedright}}{\captionsetup{justification=justified}}%
      \IfBooleanTF{#1}{% if star use the wide format
        \setfloatmargins{\hspace*{\floatindentlength}}{\hfil}% float indented
        \captionsetup{labelformat=hangcap, format=hang}% hanging label for caption
      }{% if not, use the indented / hanging style
        \setfloatmargins{\hspace*{0pt}}{\hfil}% no margins for float
        \captionsetup{labelformat=widecap, format=plain}% restore margin for caption
      }%
    }%
    
    
    % Insert(Table|Figure) syntax
    %     1      2           3           4          5              6            7            8      9
    %  *wide,  [pos]     <pre-amble>  {content}   +justify cap  {caption} [short caption] {label}  [footnotes]
    
    \NewDocumentCommand{\insertfigure}{s O{htbp} D<>{} m t+ +m O{#6} m o}{%
      \reseturef%
      \cbp@setFloatCap{#1}{#5}%
      \begin{figure}[#2]%
        #3%
    %    \captop%
        \caption[\ignorespaces#7\unskip]{\ignorespaces#6\unskip}\ignorespaces#8\unskip%
        \IfBooleanTF{#1}%
          {\ffigbox[\FBwidth]{}{\ignorespaces#4\unskip\IfValueT{#9}{\vspace{\TabNoteSpace}\floatfoot*{#9}}}}% indented caption
          {\ffigbox{}{\ignorespaces#4\unskip\IfValueT{#9}{\vspace{\TabNoteSpace}\floatfoot*{#9}}}}%  FBwidth doesn't work with sub-figure, hack for now
      \end{figure}%
    }%
    
    
    %                                  1  2   3    4    4 5  6
    \NewDocumentCommand{\inserttable}{ s O{htbp} D<>{} m t+ +m O{#6} m o }{%
      \reseturef%
      \cbp@setFloatCap{#1}{#5}%
      \begin{table}[#2]% htbp! settings
        #3% pre-amble
        \caption[\ignorespaces#7\unskip]{\ignorespaces#6\unskip}\ignorespaces#8\unskip%
        \ttabbox{}{\ignorespaces#4\unskip\IfValueT{#9}{\vspace{\TabNoteSpace}\floatfoot*{#9}}}% if no star then use hanging
      \end{table}%
    }
    
    %%% NOTE space or comma before key or error occurs
    %%       e.g. \includegraphics[ bigwidth]
    \define@key{Gin}{quarwidth}[0.24\textwidth]{\def\Gin@ewidth{#1}}
    \define@key{Gin}{thirdwidth}[0.33\textwidth]{\def\Gin@ewidth{#1}}
    \define@key{Gin}{halfwidth}[0.49\textwidth]{\def\Gin@ewidth{#1}}
    \define@key{Gin}{bigwidth}[0.66\textwidth]{\def\Gin@ewidth{#1}}
    \define@key{Gin}{biggwidth}[0.75\textwidth]{\def\Gin@ewidth{#1}}
    \define@key{Gin}{fullwidth}[1.0\textwidth]{\def\Gin@ewidth{#1}}
    %\define@key{Gin}{half-width}[0.48\linewidth]{\def\Gin@ewidth{#1}}
    
    
    % create an empty box that's the same size as of an image
    % useful for subfloats when you have an odd sized image and want to align
    \newlength{\imagewidth} \newlength{\imageheight}% variable for image
    \NewDocumentCommand{\BoxSameSizeImg}{O{t} O{t} m m}{%
      \settowidth{\imagewidth}{\includegraphics{#3}}% gets the width
      \settoheight{\imageheight}{\includegraphics{#3}}%
      \begin{minipage}[#1][\imageheight{}][#2]{\imagewidth{}}% create a mini page
        #4%
      \end{minipage}%
    }
    
    % maximum width, for graphics, or example, graphic that wont exceed margin: [width=\maxwidth{\linewidth}]
    \def\maxwidth#1{\ifdim\Gin@nat@width>#1 #1\else\Gin@nat@width\fi}
    
    
    \NewDocumentCommand{\rotatepdf}{t+ s}{\IfBooleanT{#1}{\pagebreak}%
      \IfBooleanTF{#2}{\global\pdfpageattr\expandafter{\the\pdfpageattr/Rotate 0}}%
      {\global\pdfpageattr\expandafter{\the\pdfpageattr/Rotate 90}}%
    } %%% + will add a page break before, * will restore it back to normal
    
    
    \newcommand{\rotatefloatnextpage}[1]{% if a float takes up the whole page, just insert the float after the page, rotate, then restore
      \afterpage{\RotPDF#1
      \RotPDF+*}
    }
    
    \newcommand{\floatnextpage}[1]{% if a float takes up the whole page
      \afterpage{#1
      \clearpage
      }
    }
    
    \begin{luacode*}
      function incpdfpages(pdffile, opts, start, stop, between)
        start = tonumber(start) or 1
        stop = tonumber(stop) or img.scan({filename=atlp_find_file(pdffile)}).pages
        between = between or ' \\par '
        opts = opts or 'fullwidth'
        local template = '\\includegraphics[page=__THEPAGENUMBER__,'..opts..']{'..pdffile..'}'
        for p=start,stop do
          local prtemplate = template:gsub('__THEPAGENUMBER__',tostring(p))
          tex.sprint(prtemplate)
          if p < stop then
            tex.sprint(between)
          end
        end
      end
    \end{luacode*}
    
    \NewDocumentCommand{\includepdfpages}{ O{} m m O{ \par} }{%
    % \includepdfpages[opts]{filename}{pg_start,pg_stop}[tex code between]
    % for pages, starting page required, if pg2 not included, will insert until end
      \tblfrcsv{incpdfpgs}{#3}%
      \directlua{incpdfpages(\luastring{#2}, \luastring{#1}, penlight.tbls.incpdfpgs[1], penlight.tbls.incpdfpgs[2], \luastring{#4})}
    }
    
    
    
    
    
    
    
    
    
    %\def\floatlefthanglabel{%
    %  \setlength{\floatindentlength}{0ex}
    %  \gdef\figurename{fig.}
    %  \gdef\tablename{tab.}
    %  \DeclareCaptionLabelFormat{hangcap}{\llap{##1\,##2\enspace}}
    %}
    %\def\hideeqlabelOP{}
    
    
    \def\eqprefixOG{eq.\,}
    \def\eqprefix{\eqprefixOG}
    \def\hideeqprefix{\gdef\eqprefix{}\afterpage{\gdef\eqprefix{\eqprefixOG}}}
    
    
    \def\floatlefthanglabel{
      \captionsetup{figurename=fig.,tablename=tab.,}
      \renewcommand{\lstlistingname}{code}
      \DeclareCaptionLabelFormat{hangcap}{\llap{\cbp@secnumsize##1\,##2\enspace}}
      \DeclareCaptionLabelFormat{widecap}{\llap{\cbp@secnumsize##1\,##2\enspace}}
      \global\setlength{\floatindentlength}{0ex}
      \renewcommand\tagform@[1]{\maketag@@@{\Llap{\ignorespaces\makebox[6ex][r]{\ \hfill\cbp@secnumsize\bfseries \eqprefix##1\unskip\@@italiccorr\enspace}}}}
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    %%% graveyard
    
    
    
    %% includes generator data sheet, rotates first three pages
    %%  \RotPDFninety now == \RotPDF, if on section, do this  BEFORE the section
    %% todo add a starting page
    \NewDocumentCommand{\RotFirstXpdf}{m O{3}}{
    %	\RotPDF  % todo determine if RotPDF would be better here
    	\enlargethispage{8in}
    	\includegraphics[angle=90,height=\fullheight]{#1}
    	\includepdf[pages=2-\fpeval{#2},angle=90,pagecommand={}, height=\fullheight]{#1}
    	\RotPDF*
    	\includepdf[pages=\fpeval{#2+1}-,angle=0,pagecommand={},height=\fullheight]{#1}
    }
    
    
    \NewDocumentCommand{\inputPDF}{m O{3}}{
    %  todo need option for rotating some pages here, that would be nice
    	\enlargethispage{8in}
      \includegraphics[height=\fullheight]{#1}
    	\includepdf[pages=2-,angle=0,pagecommand={},height=\fullheight]{#1}
    }
    
    %https://tex.stackexchange.com/questions/198091/get-number-of-pages-of-external-pdf
    \newcommand*{\pdfnumberofpages}[1]{%
      \directlua{%
        local doc = epdf.open("\luatexluaescapestring{#1}")
        local pages
        if (doc) then
          pages = doc:getCatalog():getNumPages()
        else
          pages = 0
        end
        tex.write(pages)
      }%
    }

%\colorlet{background}{gray}
\colorlet{background}{offwhite}
\colorlet{transition}{background}
\colorlet{body}{black}
\colorlet{main}{indigo}
\colorlet{caution}{darkred}
\colorlet{good}{green}

\def\DarkTheme{
\colorlet{background}{mybrown}
\colorlet{transition}{background}
\colorlet{body}{offwhite}
\colorlet{main}{blue!50}
\colorlet{caution}{red!50}
\colorlet{good}{green!50}
}

\providecommand{\cbp@listframe}{} % no frames for beamer

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            CodeBoxes+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ##############################################
    % Code Boxes
    % ##############################################
    
    % todo need to figure out listings a bit better...
    
    
    % https://tex.stackexchange.com/questions/77996/how-to-show-a-hint-when-lstlisting-is-breaking-page?rq=1
    % continued on next page... want to move this
    % read this and try it out more...
    % customize the appearance of the continuing notes:
    
    \def\continuingfont{\slshape} % put size here
    \def\continuingtext{Listing continues on next page\ldots}
    \def\continuedtext{\ldots Listing continued from previous page}
    
    
    
    \usepackage[framemethod=tikz]{mdframed}  % for multi-page codeboxes
    \usepackage{listings}  %
    
    \mdfdefinestyle{listing}
    {
    	hidealllines = true,
    	leftmargin = 0.01pt,
    	rightmargin = 0.01pt,
    	innerleftmargin = 0.01pt,
    	innerrightmargin = 0.01pt,
    	innertopmargin = 0.01pt,
    	innerbottommargin = 0.01pt,
    	splittopskip=30.01pt,
    	splitbottomskip=30.01pt,
    	skipabove    = \parskip,
    	skipbelow    = \parskip,
    %	backgroundcolor=none,
    	apptotikzsetting={\tikzset{mdfbackground/.append style={fill=red,fill opacity=0}}},
    	% innertopmargin = \parskip,
    	% afterbreak = {\vspace*{2cm} },
    	% beforebreak = {\vspace*{2cm}},
    	singleextra  = {} ,
    	firstextra   = {
    		\node[below left,overlay,align=right,font=\continuingfont]
    		at (P |- O) {\continuingtext};
    	} ,
    	secondextra  = {
    		\node[above right,overlay,align=left,font=\continuingfont, anchor=north west]
    		at (O |- P) {\continuedtext};
    	} ,
    	middleextra  = {
    		\node[below right,overlay,align=left,font=\continuingfont]
    		at (O) {\continuingtext};
    		\node[above right,overlay,align=left,font=\continuingfont, anchor=north west]
    		at (O |- P) {\continuedtext};
    	}
    }
    
    
    
    
    
    \renewcommand{\lstlistlistingname}{Code Listings}
    
    
    % toodo should really clean this up
    \providecolor{codekey}{RGB}{180, 0, 0}
    \providecolor{codestring}{RGB}{0, 130, 10}  % green color, used for code syntax and plots
    \providecolor{codecomment}{RGB}{128, 128, 128}
    \providecolor{codeemph}{RGB}{4, 1, 180}
    
    
    % http://texdoc.net/texmf-dist/doc/latex/listings/listings.pdf
    % requires xcolor
    \providecommand{\cbp@listframe}{tb}
    
    \lstset{
    	language=Python,
    	basicstyle=\ttfamily\small,
    	aboveskip={1.0\baselineskip},
    	belowskip={1.0\baselineskip},
    	captionpos=t,
    	belowcaptionskip=5pt, % trial and error gve this a good result
    %	frame=\cbp@listframe,
    	frame=tb,
    	rulecolor=\color{black},
    	numbers=left,
    	numberstyle=\color{codecomment}\ttfamily\scriptsize,
    %	keywords={for},  %% todo clean up keywords, i dont like built-ins..
    	keywordstyle=\color{codekey},
    	commentstyle=\color{codecomment},
    	stringstyle=\color{codestring},
    	prebreak=\raisebox{0ex}[0ex][0ex]{\ensuremath{\hookleftarrow}},
    	extendedchars=true,
    	breaklines=true,
    	showstringspaces=false,
    	tabsize=4,
    	emph={True,False,None},
    	emphstyle={\color{codeemph}},
    	keywords={for,def},
    	otherkeywords={+,-,*,/,=,!,>,<},
    	morekeywords={},
    	escapeinside={\#`}{`},  % escape to LaTeX (ex. \label{})
    	morecomment=[is]{"""!}{!"""},  % invisible block comments (CAUTION)
    	morecomment=[is]{\#!}{!},      % invisible line comment
    	% NOTE: invisible block comments may screw up line numbering for excerpt
    	moredelim=[s][\color{white}]{\#~}{~},  % make range limtis white
    	rangeprefix={\#~},      % to mark range for excerpt
    	rangesuffix={~},      %  
    	includerangemarker=false,
    	moredelim=[s][\color{white}]{"""~}{~"""},  % white block comment
    }
    
    
    
    %\lstdefinestyle{code}{
    %}
    %\lstset{
    %	language=[LaTeX]TeX,
    %	basicstyle=\ttfamily\small,
    %	commentstyle=\ttfamily\small\color{gray},
    %	numbers=left,
    %	numberstyle=\ttfamily\small\color{white},
    %	prebreak=\raisebox{0ex}[0ex][0ex]{\color{gray}\ensuremath{\hookleftarrow}},
    %	extendedchars=true,
    %	breaklines=true,
    %	tabsize=2,
    %}
    
    
    %False	def	if	raise
    %None	del	import	return
    %True	elif	in	try
    %and	else	is	while
    %as	except	lambda	with
    %assert	finally	nonlocal	yield
    %break	for	not
    %class	from	or
    %continue	global	pass
    % int, float, string, boolean
    %https://realpython.com/lessons/reserved-keywords/
    
    
    
    
    
    
    \lstnewenvironment{listing}
    {%
    	\mdframed[style=note]%
    }
    {%
    	\endmdframed
    }
    
    
    
    % emph is for emphasis, color single words (use emph and emphstyle)
    
    %  Use #`\label{whatever}` for line labels, or to escape use LaTeX script
    % reference line with \cref{lin:x}
    %  Use #~beg:sec~ and #~end:sec~ to extract blocks
    %  Use  '''~ BLOCK COMMENTS ~'''  to hide block comments (and remove line numbers)
    %
    
    
    %\renewcommand{\lstlistoflistings}{%
    %	\clearpage
    %  \begingroup
    %  \@starttoc{lol}
    %  \endgroup
    %}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            ToDoNote+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ##############################################
    % Todo Notes (with Example)
    % ##############################################
    
    \usepackage[color=white,
    bordercolor=orange,
    textsize=scriptsize,
    textwidth=0.9in,
    %disable,    % uncomment to disable package entirely
    ]{todonotes}
    % invisible todo
    \newcommand{\todoinv}[1]{%  can just use \todototoc
    	\todo[linecolor=white, backgroundcolor=white,bordercolor=white, textcolor=white]{#1}%
    }
    \newcommand{\todog}[1]{%
    	\todo[bordercolor=green!90!]{#1}%
    }
    
    %\newcommand{\todoL}[1]{\todo[inline,textsize=\small]{#1}} %inline todo note
    \newcommand{\todol}[1]{\todo[inline]{#1}} %inline todo note
    %\listoftodos
    %\todototoc{ToC todo, just a random list}
    %\todoG{Check for stuff}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            macros/symbolscbp+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    \newcommand{\Fst}{1\textsuperscript{st}\xspace}
    \newcommand{\Snd}{2\textsuperscript{nd}\xspace}
    \newcommand{\Trd}{3\textsuperscript{rd}\xspace}
    
    \newcommand{\degC}{\degree{}C\xspace}
    
    \newcommand{\rpm}{\raisebox{.2ex}{$\scriptstyle\pm$}} % raised plus/minus
    \newcommand{\rplus}{\raisebox{.2ex}{$+$}} % raised plutm looks better in text
    
    \newcommand{\pluspct}[1]{\mbox{\rplus\,\SI{#1}{\percent}\xspace}}
    \newcommand{\minuspct}[1]{\mbox{$-$\,\SI{#1}{\percent}\xspace}}
    
    \NewDocumentCommand{\pmpct}{s m}{%
    	\mbox{%
    	\IfBooleanT{#1}{(}%
    	\rpm\,\SI{#2}{\percent}\xspace%
    	\IfBooleanT{#1}{)}%
    	}%
    }%
    
    
    % todo how should dollars be shown?
    
    % todo option for CAD and USD
    \providetoggle{dollarsignpre}
    \AtBeginDocument{
    	\iftoggle{dollarsignpre}%
    	{\NewDocumentCommand{\@dol}{m O{M}}{\$\,\num{#1}\IfValueT{#2}{\,#2}\xspace}\global\let\dol\@dol}%  $ 2 M
    	{\NewDocumentCommand{\@dol}{m O{M}}{\num{#1}\IfValueT{#2}{\,#2}\,\$\xspace}\global\let\dol\@dol}% 2 M$
    }
    
    \newcommand{\ppm}{\,ppm\xspace} % parts per million
    
    %
    

\usepackage{graphbox}

\usepackage{multicol}


\usepackage[pl,globals]{penlightplus}
\usepackage{lutabulartools}
\usepackage[noenumitem]{autopuncitems}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            macros/unirefs+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% table footnote tracker interface
    \begin{luacode*}
    _uref = {}
    _uref.func = pl.char -- (a) | pl.Char (A) | tonumber (1)
    function _uref.reset()
      _uref.list = pl.List({})
    end
    function _uref.add(key)
      if not _uref.list:contains(key) then
        _uref.list:append(key)
      end
      tex.print(tostring(_uref.func(_uref.list:index(key))))
    end
    \end{luacode*}
    \NewDocumentCommand{\reseturef}{}{\luadirect{_uref.reset()}}\reseturef
    \NewDocumentCommand{\uref}{m}{\luadirect{_uref.add(\luastring{#1})}}






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            tikz+/libs+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    \usepackage{tikz}
    \usepackage{pgfplots}
    \usepackage{relsize}
    
    \usetikzlibrary{calc,positioning}
    \usetikzlibrary{decorations.markings}
    \usetikzlibrary{matrix,shapes,arrows,fit,tikzmark} %
    
    \usepackage[outline]{contour} % glow around text
    \contourlength{1.4pt}
    
    % todo extra libs likely already loaded
    %\usepackage{relsize}
    %\usepackage{luacode}
    %\usepackage{Colors+}
    %\usepackage{symbols}
    %\usepackage{xspace,pbox}
    %\usepackage[pl,globals]{penlightplus}
    %\usepackage{tikz+/anchors+}
    
    
    % https://tex.stackexchange.com/questions/18389/tikz-node-at-same-x-coordinate-as-another-node-but-specified-y-coordinate
    % note on positioning
    
    \tikzset{
        invisible/.style={opacity=0,text opacity=0},
        visible on/.style={alt={#1{}{invisible}}},
        alt/.code args={<#1>#2#3}{%
          \alt<#1>{\pgfkeysalso{#2}}{\pgfkeysalso{#3}} % \pgfkeysalso doesn't change the path
        },
        olaycapt/.style={draw=red, fill=white, rectangle,inner sep=3pt, outer sep=0pt, align=left},
        olayarrow/.style={->, red, line width=0.8pt},
        OL/.style={overlay,remember picture,baseline},
        olay/.style={overlay,remember picture,baseline},
        nopad/.style={inner sep=0pt},
        nosep/.style={inner sep=0pt, outer sep=0pt},
      }
    
    
    
    \pgfplotsset{
        axis line style={gray},
        every tick label/.append style=     {font=\color{gray}\smaller},
    }
    %every axis label/.append style =    {font=\color{black}\smaller},


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            tikz+/anchors+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%% Additions to tikz anchors
    %%%% https://tex.stackexchange.com/questions/14769/add-more-anchors-to-standard-tikz-nodes
    
    
    %\tikz@node@distance
    \def\cbptikzxyshift{0cm,0cm}
    \begin{luacode*}
    tikz_rel_pos_shortcuts = {a='0 1', b='0 -1', r='1 0', l='-1 0', ar='1 1', al='1 -1', br='1 -1', bl='-1 -1'}
    function parse_tikz_xy(s)
      s = pl.stringx.strip(s)
      s = tikz_rel_pos_shortcuts[s] or s
      coords = (string.gsub(s, ' ', ','))-- to do fancy stuff here with lua, above right etc
      token.set_macro('cbptikzxyshift', coords)
    end
    \end{luacode*}
    % if no units provided, use node distance multiplied
    
    \newcommand{\ProcesscbpXYshift}[1]{\luadirect{parse_tikz_xy(\luastring{#1})}shift=(\cbptikzxyshift)\let\cbptikzxyshift\undefined}
    \tikzset{
        xy/.style/.expand once = {\ProcesscbpXYshift{#1}},  % xy=X Y (space separated), can use abrl as well
        an/.style = {anchor=#1},  % alias for anchor
        minsize/.style = {minimum size=#1},  % alias for anchor
                        }
    
    %\node at (12,12) {\makeatletter
    %\tikz@node@distance
    %\makeatother};  % xcm and ycm
    %\node[anchor=sw](pooop)  at ([xy=1 1]cat.ne) {!!TEST};
    %  todo now you can always use 'at' for positioning
    %\node[anchor=sw](pooop)  at ([xy=a]cat.ne) {!!TEST};
    %  a = above (y=1, x=0), can have a b ar al br bl l r
    % todo maybe use a flag for node spacing or not
    
    
    %%%%%
    
    
    
    \usetikzlibrary{calc,positioning}
    
    \def\pgfaddtoshape#1#2{%
      \begingroup
      \def\pgf@sm@shape@name{#1}%
      \let\anchor\pgf@sh@anchor
      #2%
      \endgroup
    }
    
    
    \def\useanchor#1#2{\csname pgf@anchor@#1@#2\endcsname}
    
    \def\@shiftback#1#2#3#4#5#6{%
        \advance\pgf@x by -#5\relax
        \advance\pgf@y by -#6\relax
    }
    
    \pgfaddtoshape{rectangle}{%
      \anchor{west south west}{%
        \pgf@process{\northeast}%
        \pgf@ya=.5\pgf@y%
        \pgf@process{\southwest}%
        \pgf@y=1.5\pgf@y%
        \advance\pgf@y by \pgf@ya%
        \pgf@y=.5\pgf@y%
      }%
      \anchor{west north west}{%
        \pgf@process{\northeast}%
        \pgf@ya=1.5\pgf@y%
        \pgf@process{\southwest}%
        \pgf@y=.5\pgf@y%
        \advance\pgf@y by \pgf@ya%
        \pgf@y=.5\pgf@y%
      }%
      \anchor{east north east}{%
        \pgf@process{\southwest}%
        \pgf@ya=.5\pgf@y%
        \pgf@process{\northeast}%
        \pgf@y=1.5\pgf@y%
        \advance\pgf@y by \pgf@ya%
        \pgf@y=.5\pgf@y%
      }%
      \anchor{east south east}{%
        \pgf@process{\southwest}%
        \pgf@ya=1.5\pgf@y%
        \pgf@process{\northeast}%
        \pgf@y=.5\pgf@y%
        \advance\pgf@y by \pgf@ya%
        \pgf@y=.5\pgf@y%
      }%
      \anchor{north north west}{%
        \pgf@process{\southwest}%
        \pgf@xa=1.5\pgf@x%
        \pgf@process{\northeast}%
        \pgf@x=.5\pgf@x%
        \advance\pgf@x by \pgf@xa%
        \pgf@x=.5\pgf@x%
      }%
      \anchor{north north east}{%
        \pgf@process{\southwest}%
        \pgf@xa=.5\pgf@x%
        \pgf@process{\northeast}%
        \pgf@x=1.5\pgf@x%
        \advance\pgf@x by \pgf@xa%
        \pgf@x=.5\pgf@x%
      }%
      \anchor{south south west}{%
        \pgf@process{\northeast}%
        \pgf@xa=.5\pgf@x%
        \pgf@process{\southwest}%
        \pgf@x=1.5\pgf@x%
        \advance\pgf@x by \pgf@xa%
        \pgf@x=.5\pgf@x%
      }%
      \anchor{south south east}{%
        \pgf@process{\northeast}%
        \pgf@xa=1.5\pgf@x%
        \pgf@process{\southwest}%
        \pgf@x=.5\pgf@x%
        \advance\pgf@x by \pgf@xa%
        \pgf@x=.5\pgf@x%
      }%
      \anchor{width}{%
        \useanchor{rectangle}{west}%
        \pgf@xc=\pgf@x
        \useanchor{rectangle}{east}%
        \advance\pgf@x by -\pgf@xc
        \pgf@y=\z@
        \edef\pgf@temp{\csname pgf@sh@nt@\pgfreferencednodename\endcsname}%
        \expandafter\@shiftback\pgf@temp
      }
      \anchor{height}{%
        \useanchor{rectangle}{south}%
        \pgf@yc=\pgf@y
        \useanchor{rectangle}{north}%
        \advance\pgf@y by -\pgf@yc
        \pgf@x=\z@
        \edef\pgf@temp{\csname pgf@sh@nt@\pgfreferencednodename\endcsname}%
        \expandafter\@shiftback\pgf@temp
      }
      \anchor{size}{%
        \useanchor{rectangle}{south west}%
        \pgf@xc=\pgf@x
        \pgf@yc=\pgf@y
        \useanchor{rectangle}{north east}%
        \advance\pgf@x by -\pgf@xc
        \advance\pgf@y by -\pgf@yc
        \edef\pgf@temp{\csname pgf@sh@nt@\pgfreferencednodename\endcsname}%
        \expandafter\@shiftback\pgf@temp
      }
    }
    
    
    \newcommand{\anchorlet}[2]{%
        \global\expandafter
        \let\csname pgf@anchor@\pgf@sm@shape@name @#1\expandafter\endcsname
        \csname pgf@anchor@\pgf@sm@shape@name @#2\endcsname
    }
    
    \newcommand{\anchoralias}[2]{%
        \expandafter
        \gdef\csname pgf@anchor@\pgf@sm@shape@name @#1\expandafter\endcsname
        \expandafter{\csname pgf@anchor@\pgf@sm@shape@name @#2\endcsname}%
    }
    
    \pgfaddtoshape{rectangle}{%
      \anchorlet{c}{center}%
      \anchorlet{b}{base}%
      \anchorlet{bw}{base west}%
      \anchorlet{be}{base east}%
      \anchorlet{n}{north}%
      \anchorlet{e}{east}%
      \anchorlet{s}{south}%
      \anchorlet{w}{west}%
      \anchorlet{se}{south east}%
      \anchorlet{sw}{south west}%
      \anchorlet{ne}{north east}%
      \anchorlet{nw}{north west}%
      \anchorlet{wsw}{west south west}%
      \anchorlet{wnw}{west north west}%
      \anchorlet{ene}{east north east}%
      \anchorlet{ese}{east south east}%
      \anchorlet{nnw}{north north west}%
      \anchorlet{nne}{north north east}%
      \anchorlet{ssw}{south south west}%
      \anchorlet{sse}{south south east}%
    }
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            tikz+/overlay+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%  tikz page overlays
    % requires tikz+/libs+, tikz+/anchors+, penlightplus
    
    %https://tex.stackexchange.com/questions/55806/mindmap-tikzpicture-in-beamer-reveal-step-by-step#55849
    %https://tex.stackexchange.com/questions/146908/beamer-overlay-specifications-for-a-tikzpicture
    
    
    \NewDocumentCommand{\olaysetpgan}{O{}}{% todo need a way to make olay functions access this and change xfm for their scope only
      \tbldef{olayxfm.pgan}{olaypgan}%
    }
    
    \NewDocumentCommand{\olaysettemppgan}{O{}}{% todo need a way to make olay functions access this and change xfm for their scope only
      \tbldef{olayxfm.pgan}{olaypgan}%
      % todo need a way to restore page anchor to old
    }
    
    % todo add ignorespaces and unskip, very needed
    % todo option to set base unit, default cm but mm would be nicer
    % todo reemebr alast box size!!
    
    \NewDocumentCommand{\olayxfm}{ O{} }{%  transform the overlay coordinate system
    \tblfrkv{olayxfm}{#1}[defaults={shift=0 0, scale=1 1, pgan=false}]%
    \tbldefxy{shift}{olayshift}%
    \tbldefxy{scale}{olayscale}%
    \olaysetpgan%
    }%
    \olayxfm  % blank is default, initialize comands
    %\olayxfm{shift=5 5} % blank is default
    
    %%% TODO todo make pgan a universal key-val arg that only temporarily overwrites the transform, should be available to all nodes. Lots of potential here
    
    \NewDocumentEnvironment{olaytikz}{+b}{% overlay environment
      \unskip%
      \begin{tikzpicture}[olay, x=\olayscalex cm, y=\olayscaley  cm]
        \iftblv{olayxfm.pgan}%
          {\node[inner sep=0pt] (olayorigin) at (current page.\olaypgan){};}%
          [\coordinate (olayorigin) at (0,0);]%
        \begin{scope}[shift={($ (\olayshiftx cm, \olayshifty cm) + (olayorigin) $)}]
          #1%
        \end{scope}%
    \end{tikzpicture}\ignorespaces}{}
    
    % todo consider \contour{white} in number nodes
    \def\olaygridmax{20}
    \NewDocumentCommand{\olaygrid}{}{%
            \begin{olaytikz}%
                \draw[fill=white,opacity=0.5] (-\olaygridmax.4,-\olaygridmax.4) rectangle (\olaygridmax.4,\olaygridmax.4);
                \draw[step=0.2cm,blue!30,opacity=0.5] (-\olaygridmax.4,-\olaygridmax.4) grid (\olaygridmax.4,\olaygridmax.4);
                \draw[ystep=1cm,xstep=\olaygridmax.9cm,orange!70,opacity=0.8] (-\olaygridmax.4,-\olaygridmax.4) grid (\olaygridmax.4,\olaygridmax.4);
                \draw[ystep=\olaygridmax.9cm,xstep=1cm,red!70,opacity=0.8] (-\olaygridmax.4,-\olaygridmax.4) grid (\olaygridmax.4,\olaygridmax.4);
                \draw[blue,thick] (-\olaygridmax,0) -- (\olaygridmax,0) (0, \olaygridmax) -- (0, -\olaygridmax);
                \fill[blue] (0,0) circle (5pt);
                \foreach \x in {-\olaygridmax, ..., \olaygridmax}
                    \foreach \y in {-\olaygridmax, ..., \olaygridmax} {
                            \node[inner sep=0pt, outer sep=0pt, anchor=center, fill=white] at (\x,\y) {{\tiny\color{red}\x~\color{orange}\y}};
                    }
            \end{olaytikz}}
    
    
    % marker =tikz coord
    \def\cbp@olaybaseoffset@t{1.3ex}
    \def\cbp@olaybaseoffset@m{0.7ex}
    \def\cbp@olaybaseoffset@b{0ex}
    
    \NewDocumentCommand{\olaymkgeneric}{m O{} m}{\unskip%
    \tblfrkv{olaymk}{#2}[defaults={xy=0 0}]\tblkvundefcheck%
    \tbldefxy{xy}{olaymk}%
    \begin{olaytikz}
    \node[nosep, minimum size=0pt] (olaymk-#3) at ($(\olaymkx, \olaymky) + (0em, #1)$) {};
    \end{olaytikz}\ignorespaces}
    
    \NewDocumentCommand{\olaymkt}{O{} m}{\olaymkgeneric{\cbp@olaybaseoffset@t}[#1]{#2}}
    \NewDocumentCommand{\olaymkm}{O{} m}{\olaymkgeneric{\cbp@olaybaseoffset@m}[#1]{#2}}
    \NewDocumentCommand{\olaymkb}{O{} m}{\olaymkgeneric{\cbp@olaybaseoffset@b}[#1]{#2}}
    
    
    \NewDocumentCommand{\olayboxii}{m}{% todo allow for space
    \tblfrcsv{olaybox}{#1}%
    \begin{olaytikz}
      \node[inner sep=0.7ex,draw=red,thick,rounded corners,fit=(olaymk-\gettbl{olaybox/1}) (olaymk-\gettbl{olaybox/2})] {};
    \end{olaytikz}}
    
    
    
    
    %% https://texample.net/tikz/examples/feature/overlays/
    
    
    %% todo move tikz definitions to kev-val args, and image too?  would be nice to have a better system for args
    %% for now just put in separate brackets
    %\def,tikz=""{}
    %\def\kvtest{draw,red}
    \NewDocumentCommand{\olaypg}{O{} O{} m}{% olaypg[pos key-val][tikz node key-vals]{the thing}
      \tblfrkv{tikzpgol}{#1}[defaults={xy=0 0,pgan=nw,ndan=false}]\tblkvundefcheck%
      \tbldefxy{xy}{olaypg}%
      \iftblv{ndan}{}[\settbl{ndan}{\gettbl{pgan}}]%
      \begin{olaytikz}
         \node[anchor=\gettbl{ndan},inner sep=0pt, #2] (tkpgol) at ($(current page.\gettbl{pgan}) + (\olaypgx, \olaypgy)$) {#3};
      \end{olaytikz}%
    }% \tikzpgol{nd=se,pg=se,x=0,y=1}{floating node here}  % example usage
    
    
    \NewDocumentCommand{\olaypgi}{O{} O{} m}{\olaypg[#1]{\includegraphics[#2]{#3}}} % tikz page overlay graphics
    % \olaypgi[pos kv][includegraphics kv]{graphics file}
    
    \NewDocumentCommand{\olaypgt}{O{} O{} m}{%
      \tblfrkv{tikzpgolpar}{#2}[defaults={}]% todo should make a quick way to position pbox or pbox, make this better
      \tikzpgol{#1}{\pbox[#2]{}{#3}}%
    } % tikz page overlay textvox
    
    
    \NewDocumentCommand{\olay}{O{} O{} m}{% general overlay of a node \olay[pos kv][tikz node kv]{stuff}
      \tblfrkv{olaykv}{#1}[defaults={xy=0 0, an=bw, base=b}]\tblkvundefcheck%
      \tbldefxy{xy}{olaynd}%
      \luadirect{token.set_macro('olaybase',token.get_macro('cbp@olaybaseoffset@'..penlight.tbls.olaykv.base))}%
      \begin{olaytikz}
         \node[anchor=\gettbl{an}, nosep, #2] (tkpgol) at ($(0, \olaybase) + (\olayndx, \olayndy)$) {#3};
      \end{olaytikz}%
    }% \tikzpgol{nd=se,pg=se,x=0,y=1}{floating node here}  % example usage
    
    
    
    \NewDocumentCommand{\olaytext}{O{} O{} m}{%
      \olay[#1][nosep,align=left,#2]{#3}% todo allow for width to show up in first set of keyword args... need to make a function
    }
    
    
    
    
    \NewDocumentCommand{\olaybox}{ O{} m}{% todo allow for comma or space to be separator
    \tblfrcsv{olaybox}{#2}%
     \tbldef{/1}{xxi}\tbldef{/2}{yyi}\tbldef{/3}{xxii}\tbldef{/4}{yyii}%
    \begin{olaytikz}
      \draw[inner sep=0.0ex,draw=red,thick,rounded corners, #1] (\xxi,\yyi) rectangle (\xxii,\yyii);
    \end{olaytikz}}
    
    
    
    
    \NewDocumentCommand{\olaypgbox}{m m}{% todo allow for space
      \olayxfm[shift=-2 2]%
      \olaybox{#2}%
      \olayxfm{}%
    }
    
    
    
    % todo include node settings, or consider overall olaytikz kev-val
    \NewDocumentCommand{\olaycapt}{ O{} m }{% nd = node text box, ar = arrow,  an = anchor of text box pos, aran = arrow anchor on node, rel = relative text box to arrrow coords
    % ar can be coordinates (separated with space), or false. if false, no arrow is drawn
    \tblfrkv{olaycapt}{#1}[defaults={ndxy=0 0, arxy=false, ndan=nw, aran=d, rel=false}]%
    \kvtblundefcheck%
    \tbldefxy{ndxy}{olaycaptnode}%
    \iftblv{arxy}{\tbldefxy{arxy}{olaycaptarrow}}[\def\olaycaptarrowx{0}\def\olaycaptarrowy{0}]%
    \deftbl{ndan}{olaycaptanchor}%
    \iftblv{aran}{%
        \deftbl{aran}{olaycaptaran}% arrow anchor, if specified define it
        }[%
        \let\olaycaptaran\olaycaptanchor% arrow anchor, if specified define it
    ]%
    \begin{olaytikz}
        \coordinate (arrr) at ($(\olaycaptarrowx,\olaycaptarrowy)$);
        \iftblv{rel}{
            \node[olaycapt, anchor=\olaycaptanchor] (cappp) at ($(arrr)+(\olaycaptnodex,\olaycaptnodey)$) {\vphantom{I}#2\vphantom{y}};
        }[
            \node[olaycapt, anchor=\olaycaptanchor] (cappp) at (\olaycaptnodex,\olaycaptnodey) {\vphantom{I}#2\vphantom{y}};
        ]
        \iftblv{arxy}{
        \ifdefstring{\olaycaptaran}{d}{
            \draw[olayarrow] (cappp) -- (arrr);
        }{
            \draw[olayarrow] (cappp.\olaycaptaran) -- (arrr);
        }}
    \end{olaytikz}}
    
    
    
    \NewDocumentCommand{\olaycirc}{ O{} }{%
    \tblfrkv{olaycirc}{#1}[defaults={xy=0 0, r=1, rx=1, ry=1, rot=0}]\kvtblundefcheck%
    \tbldefxy{xy}{olaycirc}%
    \tbldef{r}{olaycircr}%
    \tbldef{rx}{olaycircrx}%
    \tbldef{ry}{olaycircry}%
    \tbldef{rot}{olaycircrot}%
    \begin{olaytikz}\begin{scope}[shift={(\olaycircx,\olaycircy)},xscale=\olaycircrx,yscale=\olaycircry,
      rotate=\olaycircrot]
      \draw[red] (0,0) circle (\olaycircr);
    \end{scope}\end{olaytikz}}
    
    \NewDocumentCommand{\olaydimen}{ O{} m }{%
    }% nd = node text box, ar = arrow,  an = anchor of text box pos, aran = arrow anchor on node, rel = relative text box to arrrow coords
    %overlay arrow-tips dimensioning something, with an optional caption
    
    
    
    
    
    
    % todo use better anchor system
    % specify box anchor , if no arrow anchor passed, assume it is the box anchor
    
    % todo need a dimension thing, sort of a measurement
    
    
    
    
    
    
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            tikz+/colormaps+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    \pgfplotsset{
      colormap/cividis/.style={colormap={cividis}{
    rgb255=(0, 34, 77);
    rgb255=(0, 35, 80);
    rgb255=(0, 38, 85);
    rgb255=(0, 39, 89);
    rgb255=(0, 41, 94);
    rgb255=(0, 42, 98);
    rgb255=(0, 44, 103);
    rgb255=(0, 47, 109);
    rgb255=(0, 48, 112);
    rgb255=(0, 49, 112);
    rgb255=(8, 51, 112);
    rgb255=(17, 53, 111);
    rgb255=(24, 55, 111);
    rgb255=(28, 56, 110);
    rgb255=(33, 59, 110);
    rgb255=(36, 60, 110);
    rgb255=(40, 62, 109);
    rgb255=(43, 63, 109);
    rgb255=(47, 66, 108);
    rgb255=(50, 68, 108);
    rgb255=(53, 69, 108);
    rgb255=(56, 71, 108);
    rgb255=(58, 72, 107);
    rgb255=(62, 75, 107);
    rgb255=(65, 77, 107);
    rgb255=(67, 78, 107);
    rgb255=(70, 80, 107);
    rgb255=(72, 81, 107);
    rgb255=(75, 84, 108);
    rgb255=(77, 85, 108);
    rgb255=(79, 87, 108);
    rgb255=(82, 89, 108);
    rgb255=(84, 90, 108);
    rgb255=(87, 93, 109);
    rgb255=(89, 94, 109);
    rgb255=(91, 96, 110);
    rgb255=(94, 98, 110);
    rgb255=(96, 100, 110);
    rgb255=(98, 102, 111);
    rgb255=(100, 103, 111);
    rgb255=(103, 105, 112);
    rgb255=(105, 107, 113);
    rgb255=(107, 109, 113);
    rgb255=(110, 111, 114);
    rgb255=(111, 112, 115);
    rgb255=(114, 115, 116);
    rgb255=(116, 116, 117);
    rgb255=(118, 118, 118);
    rgb255=(121, 120, 119);
    rgb255=(122, 122, 119);
    rgb255=(125, 124, 120);
    rgb255=(127, 125, 120);
    rgb255=(130, 128, 120);
    rgb255=(133, 130, 120);
    rgb255=(134, 131, 120);
    rgb255=(137, 134, 120);
    rgb255=(139, 135, 120);
    rgb255=(142, 137, 120);
    rgb255=(144, 139, 119);
    rgb255=(147, 141, 119);
    rgb255=(150, 143, 119);
    rgb255=(152, 145, 118);
    rgb255=(155, 147, 118);
    rgb255=(157, 149, 117);
    rgb255=(160, 151, 117);
    rgb255=(163, 154, 116);
    rgb255=(165, 155, 115);
    rgb255=(168, 158, 115);
    rgb255=(170, 159, 114);
    rgb255=(173, 162, 113);
    rgb255=(176, 164, 112);
    rgb255=(178, 166, 111);
    rgb255=(181, 168, 110);
    rgb255=(183, 170, 109);
    rgb255=(186, 172, 108);
    rgb255=(188, 174, 107);
    rgb255=(191, 176, 106);
    rgb255=(195, 179, 104);
    rgb255=(197, 181, 103);
    rgb255=(200, 183, 101);
    rgb255=(202, 185, 100);
    rgb255=(205, 188, 98);
    rgb255=(208, 190, 96);
    rgb255=(211, 192, 95);
    rgb255=(214, 195, 93);
    rgb255=(216, 196, 91);
    rgb255=(219, 199, 89);
    rgb255=(222, 201, 87);
    rgb255=(225, 204, 84);
    rgb255=(228, 206, 81);
    rgb255=(230, 208, 79);
    rgb255=(234, 211, 76);
    rgb255=(236, 213, 74);
    rgb255=(239, 216, 70);
    rgb255=(243, 218, 66);
    rgb255=(245, 220, 63);
    rgb255=(249, 223, 58);
    rgb255=(251, 225, 54);
    rgb255=(253, 229, 52);
    rgb255=(253, 231, 55);
            }
        },
    }

%



\newtoggle{inlineframesubtitle}
\newtoggle{sectionalToC}

\NewDocumentCommand{\ifinsert}{ m +m +O{}}{\ifcsstring{insert#1}{}{#3}{#2}} %% easer conditional command

% this was under mode<presentation>
%\DeclareOptionBeamer{background}{\PassOptionsToPackage{background=#1}{beamerouterthemeSaarland}}
%\DeclareOptionBeamer{logo}{\PassOptionsToPackage{logo=#1}{beamerouterthemeSaarland}}
%\ProcessOptionsBeamer


\mode<presentation>

%%%% BEAMER SETTINGS %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%
%%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%

\setbeamertemplate{navigation symbols}{} 	% turn off pdf navigation symbols

%%%% FONTS %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%
\setbeamerfont{title}{family=\sffamily, series=\bfseries, size=\LARGE}
\setbeamerfont{subtitle}{family=\sffamily, series=\mdseries, size=\large}
\setbeamerfont{author}{family=\sffamily, series=\mdseries, shape=\itshape, size=\large}
\setbeamerfont{institute}{family=\sffamily, series=\mdseries, size=\normalsize}
\setbeamerfont{date}{family=\sffamily, series=\mdseries, size=\normalsize}
\setbeamerfont{frametitle}{family=\sffamily, series=\bfseries, size=\Large}
\setbeamerfont{framesubtitle}{family=\sffamily, series=\mdseries, size=\large}

\setbeamerfont{structure}{family=\sffamily, series=\bfseries, size=\normalsize}

\setbeamerfont{page number in head/foot}{size=\small, series=\mdseries}
\setbeamerfont{frame number in head/foot}{size=\small, series=\mdseries}

\setbeamerfont{itemize/enumerate body}{}
\setbeamerfont{itemize/enumerate subbody}{size=\normalfont}
\setbeamerfont{itemize/enumerate subsubbody}{size=\smal}

%\setbeamertemplate{itemize/enumerate subbody begin}{\vspace{1cm}}
\setbeamertemplate{itemize/enumerate subbody end}{\vspace{1mm}}
\def\moreitemsep{\renewcommand<>{\item}{\beameroriginal\item\vspace{\stretch{.2}}}}
\def\moreitemseps{\renewcommand<>{\item}{\beameroriginal\item\vspace{\stretch{.1}}}}
\def\moreitemsepx{\renewcommand<>{\item}{\beameroriginal\item\vspace{\stretch{.3}}}}


%https://tex.stackexchange.com/questions/20654/length-between-nested-lists-in-beamer

%%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%


\usefonttheme{serif}


%%%% COLORS %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%
\setbeamercolor{background canvas}{bg=background}

\usefonttheme{structurebold}
\setbeamercolor{structure}{fg=body} % descrioption and ToC color
%\setbeamercolor{section in toc}{fg=body}

\setbeamercolor{frametitle}{fg=main}
\setbeamercolor{framesubtitle}{fg=main}
\setbeamercolor{alerted text}{fg=caution}


% block color settings
\setbeamercolor{normal text}{fg=body, bg=background}

\setbeamercolor{block title}{fg=main}
\setbeamercolor{block body}{parent=normal text}
\setbeamercolor{block title example}{fg=good}
\setbeamercolor{block body example}{parent=normal text}
\setbeamercolor{block title alerted}{fg=caution}
\setbeamercolor{block body alerted}{parent=normal text}

\setbeamercolor{title}{fg=main}
\setbeamercolor{subtitle}{fg=main}
%%%% %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%

%%%% INNER THEME %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%
%%%%  items
%\setbeamertemplate{itemize items}[circle]

\setlength{\parskip}{0.25\baselineskip}
\newcommand{\@minipagerestore}{\setlength{\parskip}{0.25\baselineskip}} % for multi columns

\setbeamertemplate{itemize item}{\raisebox{0.3ex}{\color{main}\scalebox{0.7}{$\bullet$}}}
\setbeamertemplate{itemize subitem}{\raisebox{0.3ex}{\color{main}\scalebox{0.5}{$\bullet$}}}
\setbeamertemplate{itemize subsubitem}{\raisebox{0.3ex}{\color{main}\scalebox{0.3}{$\bullet$}}}

% list stuff https://tex.stackexchange.com/questions/31505/trouble-combining-enumitem-and-beamer
%\patchcmd{\@listI}{\itemsep3\p@}{\itemsep2em}{}{}
\patchcmd{\@listI}{\topsep 3\p@}{\topsep 0\p@}{}{}
%\patchcmd{\@listI}{\parsep 0\p@}{\parsep 1\p@}{}{}
\setlength\leftmargini{0em}
\setlength\leftmarginii{1em}
\setlength\leftmarginiii{1em}

\setlength  \labelsep  {0.4em} % default 0.5
%\setlength  \labelwidth{\leftmargini}
%\addtolength\labelwidth{-\labelsep}

%%%% %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%



%%%% OUTER THEME %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%
\setbeamertemplate{sidebar right}{}

\setbeamertemplate{headline}{}
\setbeamertemplate{frametitle}{%
	\vspace*{1.7ex}{\usebeamerfont{frametitle}\usebeamercolor[fg]{frametitle}\strut\insertframetitle\strut}
	\ifinsert{framesubtitle}{%
		\iftoggle{inlineframesubtitle}{\hspace{2ex}}{\vskip 2pt}%
			{\usebeamerfont{framesubtitle}\usebeamercolor[fg]{framesubtitle}\strut\insertframesubtitle\strut}}[\vskip 0pt]
		\iftoggle{inlineframesubtitle}{\vskip 0pt}{}
	\vspace*{0.1ex}}
%\setbeamertemplate{framesubtitle}{\strut\insertframesubtitle\strut\vspace*{1ex}} ?



\def\subtitlesameline{\global\toggletrue{inlineframesubtitle}}
\def\subtitlenewline{\global\togglefalse{inlineframesubtitle}}

\let\subtitleINline\subtitlesameline
\let\subtitleNEWline\subtitlenewline


%https://tex.stackexchange.com/questions/275044/how-do-i-insert-the-total-continuation-count-in-the-allowframbreaks-frame-title
%% https://github.com/josephwright/beamer/issues/423
%% if pagebreak occurs, make the subtitle say ... continued on subsequent breaks
%https://tex.stackexchange.com/questions/275044/how-do-i-insert-the-total-continuation-count-in-the-allowframbreaks-frame-title
\newcounter{beamercontcount}
\defbeamertemplate*{frametitle continuation}{only if multiple}{%
    \ifnum \numexpr \beamer@endpageofframe+1-\beamer@startpageofframe\relax > 1
		\ifnum	\numexpr \insertcontinuationcount \relax > 1
			\framesubtitle{\Llap{... }continued}
    	\fi
    \fi
}

\setbeamerfont{footline}{series=\mdseries, size=\normalsize}

\newcommand{\cpb@PageRule}{\vline height 1em depth 0.8em width \lightrulewidth}  %% Footer
\setbeamertemplate{footline}{%
    \null\hfill\rlap{\hspace*{1ex}\cpb@PageRule\enspace\insertframenumber{}}\hspace*{\beamer@rightmargin}
		\vskip19pt
}

\let\company\institute  % alias for setting institution

\let\oldlogo\logo
\RenewDocumentCommand{\logo}{s m}{%
	\IfBooleanTF{#1}{\oldlogo{\includegraphics[width=3cm,smash=tl]{#2}}}%
	{\oldlogo{#2}}%
}%

\newlength{\cbp@BTPheight}
\setlength{\cbp@BTPheight}{8cm}
\newlength{\cbp@BTPwidth}
\setlength{\cbp@BTPwidth}{\textwidth-6mm-\heavyrulewidth-3mm}

\setbeamertemplate{title page}
{   \Vfill\vspace*{5mm}%
	\hspace*{1mm}%
	\rule{\heavyrulewidth}{\cbp@BTPheight}% Vertical line
	\hspace{7mm}% Whitespace between the vertical line and title page text
	\begin{minipage}[b][\cbp@BTPheight][t]{\cbp@BTPwidth}
		\Vfill\vfill\vfill
		\ifinsert{title}{{\usebeamerfont{title}\usebeamercolor[fg]{title}\inserttitle\par\vspace{2.0ex}}}
		\ifinsert{subtitle}{{\usebeamerfont{subtitle}\usebeamercolor[fg]{subtitle}\insertsubtitle\vspace{0.4ex}}}
		\Vfill
		\ifinsert{author}{\vfill{\usebeamerfont{author}\insertauthor}}
		\ifinsert{institute}{\vfill{\usebeamerfont{institute}\insertinstitute}}
		\ifinsert{date}{\vfill{\usebeamerfont{date}\lnum{\insertdate}}}
		\ifinsert{logo}{\vfill\vfill\hfill\tikz[OL] \node at (-2,0) {\insertlogo};}
%		\ifinsert{logo}{\vfill\vfill\hfill\insertlogo}
%		\ifinsert{logo}{\vfill\vfill\hspace*{\widthof{\usebeamerfont{title}\inserttitle}}\insertlogo}
		\Vfill\vfill\vfill\vfill\vfill
	\end{minipage}
	\Vfill\vfill
}


% Footnotes
% https://tex.stackexchange.com/questions/432316/how-can-i-change-footnote-superscript-size-and-remove-superscript-from-footnote/432374

\newlength{\extrafootnotespace}
% if you need more footnote room on a slide, use \addfootnotespace [optional]
\NewDocumentCommand{\addfootnotespace}{O{1em}}{\global\setlength{\global\extrafootnotespace}{#1}}

\def\@makefnmarknosuper{\hbox{{\usebeamercolor[fg]{footnote mark}\usebeamerfont*{footnote}\smaller\@thefnmark.\ }}}
\def\@makefntext#1{%
  \def\insertfootnotetext{#1}%
  \def\insertfootnotemark{\@makefnmarknosuper}%
  \usebeamertemplate***{footnote}}
\addtobeamertemplate{footnote}{\hskip -2em}{}

\xpretocmd{\footnoterule}{\vspace*{\extrafootnotespace}}{}{}
\xapptocmd{\footnoterule}{\global\setlength{\global\extrafootnotespace}{0pt}}{}{} % revert additional footnotespace


\newcommand{\moresep}{\addtolength{\itemsep}{5pt}}


%additional lengths
%\addtolength{\headsep}{0.6cm}  % more sep on slide titles, pushes title page though

%%%% %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%


\mode<all>



\newcommand{\cref}[1]{Slide \ref{#1}\xspace}  % likely to only reference slide numbers
\newcommand<>{\freecaption}[1]{\onslide#2{\\[0.2ex]\footnotesize#1}}
\setbeamertemplate{caption}{\raggedright\insertcaption\par}
\setbeamerfont{caption}{size=\footnotesize}

%	https://www.google.com/amp/s/nhigham.com/2013/01/18/top-5-beamer-tips/amp/
\AtBeginDocument{
	\iftoggle{sectionalToC}{
\AtBeginSection[]{{\setbeamercolor{background canvas}{bg=transition}\frame{\frametitle{Outline}%%
                  \usebeamerfont{structure}\tableofcontents[current]}}}
		}{}

}

\newcommand\sectionalToC{\toggletrue{sectionalToC}}

\def\allowframebreaksall{
	\let\oldframe\frame
	\global\renewcommand\frame[1][]{\oldframe[allowframebreaks,##1]}
}


% todo fix this vspace, want more room for multiples

%%%% some frame types, 50/50, narrow-wide, wide-narrow

\def\cbp@begcol{\vspace{0.1ex}\begin{columns}[t,onlytextwidth]\begin{column}[T]{\cpb@firstcolwidth\textwidth}}
\def\cpb@calcnextcolwidth{\fpeval{1-0.08-\cpb@firstcolwidth}}

\def\begcolFF{\gdef\cpb@firstcolwidth{0.46}\cbp@begcol} %% fifty-fifty % todo consider adding args ??
\def\begcolNW{\gdef\cpb@firstcolwidth{0.31}\cbp@begcol} %% narrow-wide
\def\begcolWN{\gdef\cpb@firstcolwidth{0.61}\cbp@begcol} %% wide-narrow
\def\begcolWNw{\gdef\cpb@firstcolwidth{0.55}\cbp@begcol} %% wide-narrow
\def\begcolFFi{\begcolFF\begin{itemize}}
\def\nextcol{\end{column}\hfill\begin{column}[T]{\cpb@calcnextcolwidth\textwidth}}
\def\nextcoli{\end{itemize}\nextcol}  % end current column itemize, begin next colun
\def\nextcolii{\end{itemize}\nextcol\begin{itemize}}  % end current column itemize, begin next columni with itemize
\def\endcoli{\end{itemize}\endcol}  % end itemize and colu
\def\endcol{\end{column}\end{columns}}



\newcommand{\twocol}[1]{%
    \begin{multicols}{2}
		#1
	\end{multicols}%
}
\setlength{\columnsep}{0.08\textwidth}  % for two column, good for long lists, but use begCol otherwise



\let\begColFF\begcolFF
\let\begColNW\begcolNW
\let\begColWN\begcolWN
\let\nextCol\nextcol
\let\endCol\endcol
\let\twoCol\twocol







%https://tex.stackexchange.com/questions/160767/how-to-customize-block-in-beamer
% https://tex.stackexchange.com/questions/372586/beamer-reduce-top-margin-which-is-possibly-left-for-title
%\setlength{\beamer@headheight}{2in}
%\setbeamersize{text margin left=30mm,text margin right=30mm}
%https://tex.stackexchange.com/questions/270409/adjust-vertical-height-of-beamer-box-title-bar
%\newcommand{\addheight}{\parbox{0pt}{\rule{0pt}{5cm}}}
%\setbeamerfont*{block title}{family=\sffamily,series=\bfseries\addheight,size=\Huge}
%\setbeamerfont*{frame title}{family=\sffamily,series=\bfseries\addheight,size=\Huge}

%https://tex.stackexchange.com/questions/368710/beamer-how-to-get-height-for-frame-content
% https://tex.stackexchange.com/questions/278429/is-there-a-simple-command-for-the-available-height-in-a-beamer-slide/278434#278434
\NewDocumentCommand{\FitToHeight}{ m }{
\makeatletter
  \global\beamer@shrinktrue
    \gdef\beamer@shrinkframebox{
        \setbox\beamer@framebox=\vbox to\beamer@frametextheight{
			\gdef\HeightMax{height=\beamer@frametextheight}%
			#1%
        }%
    }%
\makeatother
}

% the background and logo are in the images directory



%%% todo delete me
%\newcommand{\begColFF}{\vspace{2ex}\begin{columns}[t,onlytextwidth]\begin{column}[T]{0.46\textwidth}}
%\newcommand{\nextColFF}{\end{column}\hfill\begin{column}[T]{0.46\textwidth}}
%\def\endColFF{\end{column}\end{columns}}
%% narrow-wide
%\newcommand{\begColNW}{\begin{columns}[t,onlytextwidth]\begin{column}[T]{0.31\textwidth}}
%\newcommand{\nextColNW}{\end{column}\hfill\begin{column}[T]{0.61\textwidth}}
%\def\endColNW{\end{column}\end{columns}}
%% wide-narrow
%\newcommand{\begColWN}{\begin{columns}[t,onlytextwidth]\begin{column}[T]{0.61\textwidth}}
%\newcommand{\nextColWN}{\end{column}\hfill\begin{column}[T]{0.31\textwidth}}
%\def\endColWN{\end{column}\end{columns}}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            Hyperlinks+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    \AtBeginDocument{
        \if@twoside
            \hypersetup{pdfpagelayout=TwoPageRight}
        \else \fi
    }
    
    
    \usepackage{bookmark}
    \usepackage{hyperref}
    \hypersetup{
    hidelinks,
    colorlinks=false,%
    bookmarksnumbered=true,%
    bookmarksopen=true,%         
    bookmarksopenlevel=1,                  
    pdfstartview=Fit,%           
    pdfpagemode=UseOutlines,%
    }
    
    
    \usepackage[nameinlink,noabbrev]{cleveref}  % cref
    
    %% REFERENCING SECTIONS - lowercase s for sections, uppercase everything else
    \Crefname{section}{Section}{Sections}% {<type>}{<singular>}{<plural>}
    \Crefname{equation}{equation}{equations}% {<type>}{<singular>}{<plural>}
    \Crefname{appsec}{Appendix}{Appendices}
    \Crefname{table}{Table}{Tables}
    \Crefname{figure}{Figure}{Figures}
    \Crefname{frame}{Slide}{Slides}
    \Crefname{lstlisting}{Listing}{Listings}
    
    \crefname{section}{section}{sections}% {<type>}{<singular>}{<plural>}
    \crefname{equation}{equation}{equations}% {<type>}{<singular>}{<plural>}
    \crefname{appsec}{appendix}{appendices}
    \crefname{table}{table}{tables}
    \crefname{figure}{figure}{figures}
    \crefname{frame}{slide}{slides}
    \crefname{lstlisting}{listing}{listings}
    
    \creflabelformat{equation}{#2#1#3}
    \crefrangelabelformat{equation}{#3#1#4 to #5#2#6}
    
    \providetoggle{useSerif}
    \iftoggle{useSerif}{
        \crefdefaultlabelformat{#2{\toglnums#1}#3}
        \creflabelformat{equation}{#2#1#3}
    }{}
    
    
    % https://tex.stackexchange.com/questions/10555/hyperref-warning-token-not-allowed-in-a-pdf-string/330980#330980
    \pdfstringdefDisableCommands{% to clean pdf attributes string
    \def\\{}%
    \def\smaller{}%
    \def\texttt#1{<#1>}%
    \def\textbf#1{<#1>}%
    \def\textit#1{<#1>}%
    }
    
    \usepackage[a-3u]{pdfx}
    
    \begin{luacode*}
        __PDFmetadata__ = {Language='en-ca'}
    \end{luacode*}
    
    
    




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            LegacyCommands+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    \let\InsertFigure\insertfigure
    \let\InsertTable\inserttable
    
    \let\RotPDF\rotatepdf
    \let\RotFloatPage\rotatefloatnextpage
    \let\FloatNextPage\floatnextpage
    
    
    
    \let\todoL\todol
    
    
    \let\chapterM\chaptert
    \let\chapterF\chapterf
    
    \let\autodashON\autodashes
    \let\autodashOFF\autodashesoff
    
    
    
    \let\citeT\cite
    
    
    \let\PrintEndOfDocument\printenddocument
    
    \let\IntentionallyBlankPage\blankpage
    
    \let\overlayTR\overlaytr
    \let\overlayBR\overlaybr
    
    %\let\tikzpgol\olaypg
    \let\tikzpgolg\olaypgi
    \let\tikzpgolt\olaypgt
    \let\drawHelpingGrid\olaygrid
    \let\tmrk\olaymk
    \let\drawOverlayBoxTLBR\olaybox
