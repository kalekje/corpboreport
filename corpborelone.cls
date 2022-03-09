\let\footref\relax % if footref error appears
\providecommand{\standaloneOptions}{}
\LoadClass[11pt,multi=pg,crop,\standaloneOptions]{standalone}
% \use the \begin{pg} enviroment for separate pages



%%%%%%%%%%%%  Utilities.sty  %%%%%%%%%%%%
    \usepackage{etoolbox} %
    
    \usepackage{xparse} % smart definition of commands
    \usepackage{pdftexcmds}  % string comparison with expanded input args
    \usepackage{xpatch}  %add to e toolbox pre, app, etc. to command or environments, https://ctan.math.illinois.edu/macros/latex/contrib/xpatch/xpatch.pdf
    
    \usepackage{calc}  % allows us to use expressions like {\linewidth-2ex} in commands
    \usepackage{xfp}  % floating point math
    \usepackage{xspace}  % smartly looks at space after commands
    
    %\usepackage{tabto}% possibly usful for two column lists %http://tug.ctan.org/tex-archive/macros/latex/contrib/tabto/tabto-doc.pdf
    %%%
    
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
        }%
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


\newtoggle{useSerif}
\DeclareOption{serif}{\toggletrue{useSerif}}
\ProcessOptions\relax


%%%%%%%%%%%%  LuaStuff.sty  %%%%%%%%%%%%
    
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


%%%%%%%%%%%%  TextandParas.sty  %%%%%%%%%%%%
    
    % ##############################################
    % Text / Para Settings and utils
    % ##############################################
    
    \ifluatex
        \usepackage{polyglossia} % helps with hyphenation
        \setdefaultlanguage[variant=canadian]{english}
    \else
        \usepackage[english]{babel} % helps with hyphenation
    \fi
    
    
    \usepackage{csquotes} % helps with hyphenation
    
    %%% GENERAL FORMATTING
    \usepackage{ragged2e}
    \usepackage{blindtext}
    \usepackage{lastpage}
    
    %% Boxes and stuff
    \usepackage[usestackEOL]{stackengine}  % used for title page and stacking things
    \usepackage{setspace}  % enable onehalfspacing instyling
    \usepackage{relsize}  % relative sizing
    \usepackage{pbox}  % create box of max width http://ctan.mirror.colo-serv.net/macros/latex/contrib/pbox/pbox.pdf
    
    
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


\iftoggle{useSerif}{


%%%%%%%%%%%%  FontKP.sty  %%%%%%%%%%%%
    \usepackage[T1]{fontenc}
    %frenchstyle,narrowiints,partialup < math settings for kp fonts
    \usepackage[light,notextcomp,oldstylenums]{kpfonts} % the light is also decent, could consider
    \renewcommand{\ttdefault}{cmtl} % monospace that looks nice with light kpfont
    \usepackage[activate=true,% this package makes the font look nicer
        final,%
        tracking=true,%
    %	kerning=true, % only works with pdftex
    ]{microtype}
    \SetTracking{encoding=*, shape=sc}{18}  % adjust small caps letter spacing

}{


%%%%%%%%%%%%  FontCMBlua.sty  %%%%%%%%%%%%
    \usepackage[T1]{fontenc}  % used for accented letter, OT1 works better with cmbright, makes font work
    \usepackage{cmbright}  % use hfbright and cm-super
    \usefont{OT1}{cmbr}{m}{n}
    \renewcommand\bfdefault{sb}
    \newcommand\sbdefault{bx}
        \usepackage[%
        protrusion=true,
        expansion,
        final,
        tracking=true,
        letterspace=120,
        factor=1000,% protrusion (/1000), subtle
        stretch=10,%(/1000 %)
        shrink=10]{microtype}
    
    \frenchspacing
    
    \usepackage{fourier} % lotsa symbols
    
    
    %kerning=true,  $ NOT ALLOWED IN LUA
    %spacing=true,  $ NOW ALLOWED IN LUA
    
    
    %% FONT
    %%% IF YOU GET AN ERROR WITH microtype, there is an issue with font:
    % Install cm-super and hfbright packages via MiKTeX console,  you need the scalable version of cmbright, for ex.
    %    \usepackage{fontspec}          % lualatex font engine
    %    \setmainfont[Numbers = Uppercase,
    %                 Ligatures = TeX,
    %                 BoldFont  = CMU Bright SemiBold,
    %                 ItalicFont = CMU Bright Oblique,
    %                ]{CMU Bright Roman}
    % NOTE OPEN font version of CMU Bright doesnt look as nice, we use type 1 here

}


%%%%%%%%%%%%  MathSymbolsEtc.sty  %%%%%%%%%%%%
    % ##############################################
    % Math related packages and settings
    % ##############################################
    
    % rename to MathSciSymbols
    
    
    \usepackage[fleqn]{mathtools} % should load amsmath
    %\usepackage{amsmath}
    
    \usepackage{xfrac}
    \usepackage{amssymb,amsfonts,gensymb}  % math fonts and symbols
    
    
    \usepackage[free-standing-units,
    	unit-optional-argument,
    	detect-all=true, % allows italic/bold units
    	space-before-unit=true,
    	inter-unit-product=\,,
    	use-xspace=true]{siunitx}  % \SI \num used for physical units and S column in tables
    
    \sisetup{range-phrase=--,
    	table-number-alignment=center,
    	table-text-alignment=center,
    	table-align-text-post=false,
    	table-align-text-pre=false,
    }
    % http://ctan.mirror.rafal.ca/macros/latex/contrib/siunitx/siunitx.pdf
    
    
    %\def\sbfCMB#1{\ThisStyle{\setbox0=\hbox{$\SavedStyle#1$}%
    %		#1\kern.2pt\kern-\wd0%
    %		\raisebox{.1pt}{$\SavedStyle#1$}}}
    \newcommand{\sbfCMB}[1]{\textbf{\textit{#1}}}
    


%%%%%%%%%%%%  Tables.sty  %%%%%%%%%%%%
    
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
    
    
    \let\nl\\  % shortcut for \newline and \\
    
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
    \newlength{\TabNoteSpace}
    \newlength{\LongTabNoteSpace}
    \setlength\TabNoteSpace{-1.3ex}
    \setlength\LongTabNoteSpace{-5.5ex}
    
    
    \newcommand{\LongTableNotes}[2][\linewidth]{% todo might wanna fix this so it's more automatic
        \vspace{\LongTabNoteSpace}% manually tested
        \parbox{#1}{\footnotesize #2}}
    
    
    %%%%% todo should I move this into unirefs?  maybe make a lua version
    \newcommand{\tfnote}[1]{\leavevmode\llap{#1.\enspace}} % use tnote{a} in the table, and \tfnote{a}Note here in the foot notes
    \NewDocumentCommand{\tnote}{s m}{%
    	\IfBooleanTF{#1}%
    		{\textsuperscript{#2}}%
    		{\rlap{\textsuperscript{#2}}}% without star, footnote label to take no space
    }% use tnote{a} in the table, and \tfnote{a}Note here in the foot notes
    
    \newcommand{\atfnote}[1]{\tfnote{\uref{#1}}} % automatic table footnote
    
    %\newcommand{\atnote}[1]{\tnote{\uref{#1}}} % automatic table footnote
    \NewDocumentCommand{\atnote}{s m}{%
    	\IfBooleanTF{#1}%
    		{\tnote*{\uref{#2}}}%
    		{\tnote{\uref{#2}}}%
    }% use tnote{a} in the table, and \tfnote{a}Note here in the foot notes


%%%%%%%%%%%%  ColorsCustom.sty  %%%%%%%%%%%%
    % ##############################################
    % Custom Colors
    % ##############################################
    
    \usepackage{xcolor}
    
    % todo confirm with xckd colors
    % https://xkcd.com/color/rgb/
    
    % make a consistent color set with mpl "rich colors"
    % define shades of gray to mtach
    
    
    %\definecolor{lightgray}{RGB}{216, 220, 214}
    
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
    
    
    
    % for coding
    \colorlet{accCol}{indigo}  % accent color
    \colorlet{contCol}{darkred}    % contrast color
    \colorlet{grayCol}{gray}   % gray color
    \colorlet{greCode}{green}   % gray color
    
    % for sections
    \colorlet{secCol}{indigo}
    \colorlet{subsecCol}{darkindigo}
    \colorlet{subsubsecCol}{verydarkindigo}
    
    
    
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


%%%%%%%%%%%%  Lists.sty  %%%%%%%%%%%%
    
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



%%%%%%%%%%%%  CodeBoxes.sty  %%%%%%%%%%%%
    % ##############################################
    % Code Boxes
    % ##############################################
    
    % https://tex.stackexchange.com/questions/77996/how-to-show-a-hint-when-lstlisting-is-breaking-page?rq=1
    % continued on next page... want to move this
    % read this and try it out more...
    \usepackage[framemethod=tikz]{mdframed}  % for multi-page codeboxes
    \mdfdefinestyle{listing}
    {
    	hidealllines = true,
    	leftmargin = 0pt,
    	rightmargin = 0pt,
    	innerleftmargin = 0pt,
    	innerrightmargin = 0pt,
    	innertopmargin = 0pt,
    	innerbottommargin = 0pt,
    	splittopskip=30pt,
    	splitbottomskip=30pt,
    	skipabove    = \parskip,
    	skipbelow    = \parskip,
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
    % customize the appearance of the continuing notes:
    \newcommand*\continuingfont{\itshape} % put size here
    \newcommand*\continuingtext{Listing continues on next page\ldots}
    \newcommand*\continuedtext{\ldots Listing continued from previous page}
    
    
    
    \usepackage{listings}  % 
    
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
    	frame=\cbp@listframe,
    	rulecolor=\color{black},
    	numbers=left,
    	numberstyle=\ttfamily\footnotesize\color{codecomment},
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
    
    
    
    \lstdefinestyle{code}{
    	language         = [LaTeX]TeX,
    	basicstyle       = \small\ttfamily ,
    	numbers          = left,
    	numberstyle      = \tiny,
    	numberblanklines = true,
    	breaklines       = true,
    	keepspaces       = true,
    	columns          = fullflexible,
    	% whatever else you want ...
    }
    
    
    \lstnewenvironment{listing}
    {%
    	\lstset{style=code}%
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
    
    


%%%%%%%%%%%%  macros/unirefs.sty  %%%%%%%%%%%%
    %%%% todo maybe move this to a lua-based function
    
    %%%% todo make a lua tables latex interface? That might be fun
    
    \newcounter{unilabIN}% my referene counter withIN each new instance
    \newcounter{unilabOUT}% creates a new set of counters if incremented
    
    \setcounter{unilabIN}{1}
    \setcounter{unilabOUT}{1}  % start at 1 -> a
    
    
    \newcommand\uref[1]{% my command "unique" referencer
      \@ifundefined{uni\alph{unilabOUT}lab@#1}{%if reference doesnt exist, ie. hasn't been used
        \global\advance\value{unilabIN}1% global advance to work with ttabbox (can replace 1 with \@ne, use this instead of \stepcounter{unilabIN})
        \expandafter\xdef\csname uni\alph{unilabOUT}lab@#1\endcsname{\alph{unilabIN}}% create a label for reference
        % defines a command : uni&lab$  where & is group letter, and $ is the label name
      }{}%
      \csname uni\alph{unilabOUT}lab@#1\endcsname% call the label
    }
    
    
    \newcommand{\reseturef}{\setcounter{unilabIN}{0}\stepcounter{unilabOUT}}% must use this outside of ttabbox
    
    
    %Example usage:
    %
    %\reseturef  % resets counters for new labels
    %
    %
    %\begin{tabular}{lr}
    %  \hline
    %    Things & Applicable Things \\\hline
    %    Aardvark & \uref{lookslikerat}, \uref{fourlegs} \\
    %    Bat & \uref{lookslikerat} \\
    %    Cheetah & \uref{fourlegs} \\\hline
    %\end{tabular}
    
    
    %% single layer
    
    %\newcounter{unilabIN}% my referene counter withIN each new instance
    %\newcounter{unilabOUT}% creates a new set of counters if incremented
    %
    %\setcounter{unilabIN}{0}
    %\setcounter{unilabOUT}{1}  % start at 1 -> a
    %
    %\makeatletter
    %\newcommand\uref[1]{% my command "unique" referencer
    %  \@ifundefined{unilab@#1}{%if reference doesnt exist, ie. hasn't been used
    %    \stepcounter{unilabIN}\theunilabIN\expandafter\xdef\csname unilab@#1\endcsname{\theunilabIN}% create a label for reference
    %    % defines a command : uni&lab$  where & is group letter, and $ is the label name
    %  }{%
    %  \csname unilab@#1\endcsname% call the label
    %  }%
    %}
    %\makeatother
    %
    %\newcommand{\reseturef}{\setcounter{unilabIN}{0}\stepcounter{unilabOUT}}
\usepackage{graphbox}


%%%%%%%%%%%%  TikZstuff.sty  %%%%%%%%%%%%
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

\usepackage[pl,extras]{penlight}
\usepackage{YAMLvars}
\usepackage{lutabulartools}
\usepackage{autopuncitems}

\begin{luacode*}
	YAMLvars.tabmidrule = 'gmidrule'
\end{luacode*}




