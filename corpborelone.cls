\let\footref\relax % if footref error appears
\providecommand{\standaloneOptions}{}
\LoadClass[11pt,multi=pg,crop,\standaloneOptions]{standalone}
% \use the \begin{pg} enviroment for separate pages



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
    


\newtoggle{useSerif}
\DeclareOption{serif}{\toggletrue{useSerif}}
\ProcessOptions\relax


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
    
    \usepackage{moreenum}
    \newcounter{moreenumtempcounter}
    \NewDocumentCommand{\nword}{m}{\setcounter{moreenumtempcounter}{#1}\nwords{moreenumtempcounter}}
    
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
    \newcommand\ie{i.e.\ensurecomma}
    \newcommand\ensuresingleperiod{\@ifnextchar.{}{.\@}}
    \newcommand\etc{etc\ensuresingleperiod}
    \newcommand\etal{et~al\ensuresingleperiod}
    
    
    
    \usepackage[utf8]{luainputenc}
    
    \DeclareUnicodeCharacter{2014}{\dash}
    \AtBeginDocument{\pdfstringdefDisableCommands{\renewcommand{\dash}{ - }}}
    
    \DeclareRobustCommand\mdash{%
        \unskip\nobreak\thinspace\textemdash\thinspace\ignorespaces}
    
    \DeclareRobustCommand\ndash{%
        \unskip\nobreak\thinspace\textendash\thinspace\ignorespaces}
    
    \DeclareRobustCommand\dash{%
      \unskip\nobreak\thinspace\textemdash\allowbreak\thinspace\ignorespaces}
    
    \directlua{
    function autodashes(s)
    s = string.gsub(s,'[-][-][-]', '\string\\mdash ')
    s = string.gsub(s,'[-][-]',    '\string\\ndash ')
    return s
    end
    function autoemdash(s)
    s = string.gsub(s,'[-][-][-]', '\string\\mdash ')
    return s
    end
    function autoendash(s)
    s = string.gsub(s,'[-][-]',    '\string\\ndash ')
    return s
    end
    }
    
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
    
    
    


\usepackage[fleqn]{amsmath} % need to load before kpfonts-otf

\iftoggle{useSerif}{


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


}{


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

}


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
    
    \renewcommand{\theequation}{\arabic{chapter}.\arabic{equation}}
    
    %\def\@cbp@mathline{\raisebox{0pt}[0pt][0pt]{\vline height 0.8em depth 0.6em width \arrayrulewidth}}
    %\renewcommand\tagform@[1]{\maketag@@@{\ignorespaces\makebox[6ex][l]{\@cbp@mathline\;\cbp@secnumsize#1\unskip\@@italiccorr\hfill}\hspace*{5ex}}}
    
    \def\@cbp@mathline{\raisebox{0pt}[0pt][0pt]{\vline height 0.8em depth 0.6em width \arrayrulewidth}}
    \renewcommand\tagform@[1]{\maketag@@@{\ignorespaces\makebox[6ex][r]{\ \hfill\cbp@secnumsize#1\;\@cbp@mathline\unskip\@@italiccorr\hspace*{2ex}}}}
    
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
    
    \definecolor{offwhite}{RGB}{255,253,237}
    
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
%%%            Lists+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    \usepackage{enumitem} % https://muug.ca/mirror/ctan/macros/latex/contrib/enumitem/enumitem.pdf
    \usepackage{multicol}  % used for two column list
    
    \newlength{\moreseplength}
    \setlength{\moreseplength}{2.5pt}  % this is only used for listed; indent is 2* this
    
    \newlength{\ListIndentLength}
    \setlength{\ListIndentLength}{4ex}  % this is only used for listed; indent is 2* this
    
    \newlength{\SemiParSkipLength}
    \setlength{\SemiParSkipLength}{4.1pt plus 0.41pt}  % 0.3 * 13.7
    
    \newlength{\SemiMinusParLength}
    \setlength{\SemiMinusParLength}{-9.6pt plus 0.96pt}  % (0.3 - 1 )* 13.7
    
    \newcommand{\SemiMinusParSkip}{\vspace{\SemiMinusParLength}}  % remove parskip, add env. skip
    \newcommand{\ContParaAfterList}{\vspace{\SemiMinusParLength}\noindent}
    
    % global settings for all lists
    
    \setlist{nosep,%
    	leftmargin=\ListIndentLength,%
    	topsep=-\parskip, % removes default parskip in topsep
    	before=\vspace{\SemiParSkipLength},  % add a small buffer, assuming that list is in same par as above
    	after*={\@topsepadd\parskip}  % restores topsep to parskip (topsep=0pt)
    }  % seperation is same as baseline,needs enumitem
    
    
    \setlist[2,3,4,5]{nosep,
    	leftmargin=\ListIndentLength,
    	topsep=-\parskip,
    	before=,
    	after*=,  % todo consider putting some butter after
    }
    %
    
    
    \setlist[enumerate,2]{label=\alph*.}
    \SetEnumitemKey{moresep}{itemsep=\moreseplength}
    
    \providetoggle{useSerif}
    \iftoggle{useSerif}{
    %	\setlist[enumerate,2]{label=\alph*., format=\toglnums}
    	\setlist[enumerate,1]{label=\toglnums\arabic*.}
    }{}
    
    
    %%%
    \SetEnumitemKey{twocol}{
    itemsep = 1\itemsep,
    parsep = 1\parsep,
    before = \raggedcolumns\begin{multicols}{2},
    after = \end{multicols}}
    
    \SetEnumitemKey{threecol}{
    itemsep = 1\itemsep,
    parsep = 1\parsep,
    before = \raggedcolumns\begin{multicols}{3},
    after = \end{multicols}}
    %%%
    
    % changes bullets, I like them smaller than default
    \renewcommand\labelitemi{\raisebox{0.3ex}{\scalebox{0.9}{\scriptsize$\bullet$}}}
    \renewcommand\labelitemii{\raisebox{0.3ex}{\scalebox{0.7}{\scriptsize$\bullet$}}}
    \renewcommand\labelitemiii{\raisebox{0.3ex}{\scalebox{0.4}{\scriptsize$\bullet$}}}
    
    \providetoggle{useSerif}
    \iftoggle{useSerif}{
      \setlist[description]{font={\normalfont\bfseries}}
    }{}


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

\usepackage{graphbox}



\usepackage[pl,globals]{penlightplus}
\usepackage{YAMLvars}
\usepackage{lutabulartools}
\usepackage{autopuncitems}

\begin{luacode*}
	YAMLvars.tabmidrule = 'gmidrule'
\end{luacode*}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            tikz+/libs+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    \usepackage{tikz}
    \usepackage{pgfplots}
    \usepackage{relsize}
    
    \usetikzlibrary{calc,positioning}
    \usetikzlibrary{decorations.markings}
    \usetikzlibrary{matrix,shapes,arrows,fit,tikzmark}
    
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
        olaycapt/.style={draw=red, fill=white, rectangle,inner sep=3pt, outer sep=0pt},
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
      wrth(coords,'!!!')
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
    
    
    
    %% todo delete soon
    \begin{luacode*}
        function penlight.def_tbl_coords(str, def)
        -- todo could definitely make this flexible for a table...
        local x, y = str:strip():splitv('%s+')
        -- if (~penlight.hasval(x)) or (~penlight.hasval(y))  then
        --   penlight.tex.pkgerror('penlightplus', 'def_tbl_coords function could not parse coordiantes given as "'..str..'" ensure two numbers separated by space are given!', '', true)
        -- end
        token.set_macro(def..'x', tostring(x))
        token.set_macro(def..'y', tostring(y))
        end
    \end{luacode*}
    \NewDocumentCommand{\tbldefxyZZZ}{ m m }{\luadirect{penlight.def_tbl_coords(penlight.get_tbl_item(\luastring{#1}), \luastring{#2})}}
    
    
    
    \NewDocumentCommand{\olayxfm}{ O{} }{%
    \tblfrkv{olayxfm}{#1}[defaults={shift=0 0, scale=1 1}]%
    \tbldefxy{shift}{olayshift}%
    \tbldefxy{scale}{olayscale}%
    }%
    \olayxfm  % blank is default, initialize comands
    %\olayxfm{shift=5 5} % blank is default
    
    
    \NewDocumentEnvironment{olaytikz}{+b}{% overlay environment
      \begin{tikzpicture}[olay, x=\olayscalex cm, y=\olayscaley  cm]
        \begin{scope}[shift={(\olayshiftx cm, \olayshifty cm)}]
          #1%
        \end{scope}%
    \end{tikzpicture}}{}
    
    
    \def\olaygridmax{20}
    \NewDocumentCommand{\olaygrid}{}{%
            \begin{tikzpicture}[OL]
                \draw[step=0.2cm,blue!30,opacity=0.5] (-\olaygridmax.4,-\olaygridmax.4) grid (\olaygridmax.4,\olaygridmax.4);
                \draw[step=1cm,red!30,opacity=0.8] (-\olaygridmax.4,-\olaygridmax.4) grid (\olaygridmax.4,\olaygridmax.4);
                \fill[red] (0,0) circle (2.5pt);
                \foreach \x in {-\olaygridmax, ..., \olaygridmax}
                    \foreach \y in {-\olaygridmax, ..., \olaygridmax} {
                            \node[inner sep=0pt, outer sep=0pt, anchor=center] at (\x,\y) {{\color{red}\tiny\x~\color{magenta}\y}};
                    }
            \end{tikzpicture}%
    }
    
    
    % marker =tikz coord
    \def\cbp@olaybaseoffset@t{1.3ex}
    \def\cbp@olaybaseoffset@m{0.7ex}
    \def\cbp@olaybaseoffset@b{0ex}
    
    \NewDocumentCommand{\olaymkgeneric}{m O{} m}{%
    \tblfrkv{olaymk}{#2}[defaults={xy=0 0}]\tblkvundefcheck%
    \tbldefxy{xy}{olaymk}%
    \begin{olaytikz}
    \node[nosep, minimum size=0pt] (olaymk-#3) at ($(\olaymkx, \olaymky) + (0em, #1)$) {};
    \end{olaytikz}}
    
    \NewDocumentCommand{\olaymkt}{O{} m}{\olaymkgeneric{\cbp@olaybaseoffset@t}[#1]{#2}}
    \NewDocumentCommand{\olaymkm}{O{} m}{\olaymkgeneric{\cbp@olaybaseoffset@m}[#1]{#2}}
    \NewDocumentCommand{\olaymkb}{O{} m}{\olaymkgeneric{\cbp@olaybaseoffset@b}[#1]{#2}}
    
    
    \NewDocumentCommand{\olaybox}{m}{%
    \tblfrcsv{olaybox}{#1}%
    \begin{olaytikz}
      \node[inner sep=0.7ex,draw=red,thick,rounded corners,fit=(olaymk-\gettbl{olaybox/1}) (olaymk-\gettbl{olaybox/2})] {};
    \end{olaytikz}}
    
    
    
    
    %% https://texample.net/tikz/examples/feature/overlays/
    
    
    
    
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
      \tblfrkv{tikzpgolpar}{#2}[defaults={}]% todo should make a quick way to position pbox or pbox
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
    
    
    
    
    
    % todo include node settings
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
            \node[olaycapt, anchor=\olaycaptanchor] (cappp) at ($(arrr)+(\olaycaptnodex,\olaycaptnodey)$) {#2};
        }[
            \node[olaycapt, anchor=\olaycaptanchor] (cappp) at (\olaycaptnodex,\olaycaptnodey) {#2};
        ]
        \iftblv{arxy}{
        \ifdefstring{\olaycaptaran}{d}{
            \draw[olayarrow] (cappp) -- (arrr);
        }{
            \draw[olayarrow] (cappp.\olaycaptaran) -- (arrr);
        }}
    \end{olaytikz}}
    
    
    
    \NewDocumentCommand{\olaydimen}{ O{} m }{ }% nd = node text box, ar = arrow,  an = anchor of text box pos, aran = arrow anchor on node, rel = relative text box to arrrow coords
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

