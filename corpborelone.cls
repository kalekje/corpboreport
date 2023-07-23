\let\footref\relax % if footref error appears
\providecommand{\standaloneOptions}{}
\LoadClass[11pt,multi=pg,crop,\standaloneOptions]{standalone}
% \use the \begin{pg} enviroment for separate pages



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            Utilities            %%%
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
    \NewDocumentCommand{\overlayTR}{m}{%
      \Llap{\raisebox{\dimeval{(-\height+1.6ex)}}[0pt][0pt]{#1}}%
    }
    \NewDocumentCommand{\overlayBR}{m}{%
      \Llap{\raisebox{0pt}[0pt][0pt]{#1}}%
    }
    


\newtoggle{useSerif}
\DeclareOption{serif}{\toggletrue{useSerif}}
\ProcessOptions\relax


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            LuaStuff            %%%
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
%%%            TextandParas            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % ##############################################
    % Text / Para Settings and utils
    % ##############################################
    
    \usepackage[utf8]{luainputenc}
    
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
    \usepackage{lastpage}
    
    %% Boxes and stuff
    \usepackage[usestackEOL]{stackengine}  % used for title page and stacking things
    \usepackage{setspace}  % enable onehalfspacing instyling
    \usepackage{relsize}  % relative sizing
    \usepackage{pbox}  % create box of max width http://ctan.mirror.colo-serv.net/macros/latex/contrib/pbox/pbox.pdf
    
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
    
    
    \DeclareRobustCommand\mdash{%
        \unskip\nobreak\thinspace\textemdash\thinspace\ignorespaces}
    \DeclareRobustCommand\ndash{%
        \unskip\nobreak\thinspace\textendash\thinspace\ignorespaces}
    \DeclareUnicodeCharacter{2014}{\dash}
    \AtBeginDocument{\pdfstringdefDisableCommands{\renewcommand{\dash}{ - }}}
    
    \DeclareRobustCommand\dash{%
      \unskip\nobreak\thinspace\textemdash\allowbreak\thinspace\ignorespaces}
    
    \directlua{
    function autodashes(s)
    s = string.gsub(s,'[-][-][-]', '\string\\mdash ')
    %s = string.gsub(s,'[-][-]',    '\string\\ndash ')
    return s
    end}
    
    \def\autodashON{\directlua{%
    luatexbase.add_to_callback("process_input_buffer", autodashes,"auto spaced dashes")%
    }}
    
    \def\autodashOFF{\directlua{%
    luatexbase.remove_from_callback("process_input_buffer","auto spaced dashes")%
    }}
    
    
    
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
%%%            FontKPotf            %%%
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
    
    %\let\lnum\oldstylenums % {}
    %\let\unum\liningnums   % {}
    
    % if [] provided, apply to grouped text only--if not apply toggle
    %\NewDocumentCommand{\lnum}{o}{\IfValueTF{#1}{\oldstylenums{#1}}{\toglnums}}
    %\NewDocumentCommand{\unum}{o}{\IfValueTF{#1}{\liningnums{#1}}{\togunums}}
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
%%%            FontCMBotf            %%%
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
%%%            MathSymbolsEtc            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% References %%%%%
    % siunitx: https://texdoc.org/serve/siunitx/0
    % mathtools: https://texdoc.org/serve/mathtools/0
    
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
%%%            Tables            %%%
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
%%%            Colors            %%%
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
%%%            Lists            %%%
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
%%%            CodeBoxes            %%%
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
%%%            macros/unirefs            %%%
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            TikZstuff            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    \usepackage{tikz}
    \usetikzlibrary{positioning}
    \usetikzlibrary{calc}
    \usetikzlibrary{arrows}
    \usetikzlibrary{decorations.markings}
    \usetikzlibrary{shapes.misc}
    \usetikzlibrary{matrix,shapes,arrows,fit,tikzmark}
    
    %%% TIKZ STUFF for marking over text
    %\tikzstyle{every picture}+=[remember picture]
    %\tikzstyle{mybox} =[draw=black, very thick, rectangle, inner sep=10pt, inner ysep=20pt]
    %\tikzstyle{fancytitle} =[draw=black,fill=red, text=white]
    
    %https://tex.stackexchange.com/questions/55806/mindmap-tikzpicture-in-beamer-reveal-step-by-step#55849
    %https://tex.stackexchange.com/questions/146908/beamer-overlay-specifications-for-a-tikzpicture
    \tikzset{
        invisible/.style={opacity=0,text opacity=0},
        visible on/.style={alt={#1{}{invisible}}},
        alt/.code args={<#1>#2#3}{%
          \alt<#1>{\pgfkeysalso{#2}}{\pgfkeysalso{#3}} % \pgfkeysalso doesn't change the path
        },
      }
    
    \tikzset{
    %        every picture/.style={remember picture,baseline},
    %        every node/.style={anchor=base,align=center,outer sep=1.5pt},
    %        every path/.style={thick},
            OL/.style={overlay,remember picture,baseline},
            nopad/.style={inner sep=0pt},
            }
    
    %% todo consider using the tikzmark package:
    % https://ctan.mirror.rafal.ca/graphics/pgf/contrib/tikzmark/tikzmark.pdf
    \usetikzlibrary{tikzmark}
    \usetikzmarklibrary{listings}
    %% useful for tikz node, otherwise my implementation is a bit better for me
    \let\tmrkN\tikzmarknode
    
    
    % marker =tikz coord
    \def\cbp@tikzmarker@t{1.3ex}
    \def\cbp@tikzmarker@m{0.7ex}
    \def\cbp@tikzmarker@b{0ex}
    
    \NewDocumentCommand{\tmrk}{ s O{b} d() m }{% place a tikz marker on the baseline, middle, or top of ine. Or coord (x,y) relative to baseline
    %    for additional padding, use \tmrkr* %
        \IfBooleanTF{#1}{\gdef\cbp@insep{0.3ex}}{\gdef\cbp@insep{0pt}}%
        \IfValueTF{#3}{%
            \tikz[OL] \node[inner sep=\cbp@insep,minimum size=0pt] (tm-#4) at (#3) {};%
        }{%
            \tikz[OL] \node[inner sep=\cbp@insep,minimum size=0pt] (tm-#4) at (0em, \csname cbp@tikzmarker@#2\endcsname) {};%
        }%
    }%
    
    \newcommand{\drawOverlayBoxTLBR}[2]{% requires 2 tikzmarkers be used. Pass the label that matches the tikzmarker
    \tikz[OL,inner sep=0.7ex]
    		\node[draw=red,thick,rounded corners,fit=(tm-#1.north west) (tm-#2.south east)] {};%
    }%
    
    \NewDocumentCommand{\drawHelpingGrid}{s}{%
            \begin{tikzpicture}[OL]
                \draw[step=1cm,gray,opacity=0.5] (-10.4,-10.4) grid (10.4,10.4);
                \draw[step=1cm,gray!50,opacity=0.5,shift={(0.5,0.5)}] (-10.4,-10.4) grid (10.4,10.4);
                \IfBooleanTF{#1}{\draw[step=0.2cm,blue!30,opacity=0.5] (-10.4,-10.4) grid (10.4,10.4);}{}
                \fill[red] (0,0) circle (2.5pt);
            \end{tikzpicture}%
    }
    
    %% https://texample.net/tikz/examples/feature/overlays/
    
    %%%% END TIKZ STUFF

\usepackage[pl,globals]{penlightplus}
\usepackage{YAMLvars}
\usepackage{lutabulartools}
\usepackage{autopuncitems}

\begin{luacode*}
	YAMLvars.tabmidrule = 'gmidrule'
\end{luacode*}




