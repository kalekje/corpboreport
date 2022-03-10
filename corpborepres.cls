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
    
    
    \if@twoside% if two-sided, put the section headings to right side and numbers in right margin
    	\raggedbottom
    \fi%  finally do nothing
    	\raggedbottom
    
    
    


%%%%%%%%%%%%  FontCMBotf.sty  %%%%%%%%%%%%
    \usepackage{fontspec}
    
    \usepackage[T1]{fontenc}
    \usepackage{cmbright} %for math only, will be overwritten
    \renewcommand\bfdefault{sb}
    \newcommand\sbdefault{bx} % swap sb with bf
    
    \setmainfont[
      Ligatures = TeX,
    %  Numbers = Uppercase,
    %  Numbers = Lowercase,
    %  Numbers = Oldstyle,
      ItalicFont = CMU Bright Oblique,
      BoldFont = CMU Bright SemiBold,
      BoldItalicFont = CMU Bright SemiBold Oblique,
    ]{CMU Bright}
    \setmonofont[Numbers=Lining]{CMU Typewriter Text Light}
    
    
    % https://tex.stackexchange.com/questions/204778/difficulty-finding-selecting-cm-bright-using-fontspec
    % https://tex.stackexchange.com/questions/358418/using-cmbright-in-xelatex-for-math-and-text
    % https://tex.stackexchange.com/questions/25293/replace-integral-sign-in-cmu-bright-with-iwona-while-keeping-proper-position-o
    % https://tex.stackexchange.com/questions/572015/using-the-cmbright-package-in-a-limited-range-of-my-document
    
    \DeclareSymbolFont{iwonalargesymbols}{OMX}{iwona}{m}{n}
    \DeclareMathSymbol{\intop}{\mathop}{iwonalargesymbols}{"52}
    
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
    
    % upper and lowercase number commands
    \def\togunums{}
    \def\toglnums{}
    \def\lnum#1{#1}
    \def\unum#1{#1}
    
    
    % why doesn't this work ???
    %\usepackage{unicode-math}
    %\setmathfont{CMU Bright}
    %    \setmathfont[range=\mathup]{CMU Bright Roman}
    %    \setmathfont[range=\mathbfup]{CMU Bright SemiBold}
    %    \setmathfont[range=\mathbfit]{CMU Bright SemiBold}
    %    \setmathfont[range=\mathit]{CMU Bright Oblique}
    
    
    


%%%%%%%%%%%%  MathSymbolsEtc.sty  %%%%%%%%%%%%
    % ##############################################
    % Math related packages and settings
    % ##############################################
    
    % rename to MathSciSymbols
    
    
    \usepackage[fleqn]{mathtools} % should load amsmath
    %\usepackage{amsmath}
    %\usepackage{amssymb} % issue with kpfonts, I think it already loads it..
    
    \usepackage{xfrac}
    \usepackage{amsfonts,gensymb}  % math fonts and symbols
    
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
    
    
    %	inter-unit-product=\,, % default
    %\sisetup{range-phrase=--,
    
    
    
    %\def\sbfCMB#1{\ThisStyle{\setbox0=\hbox{$\SavedStyle#1$}%
    %		#1\kern.2pt\kern-\wd0%
    %		\raisebox{.1pt}{$\SavedStyle#1$}}}
    \newcommand{\sbfCMB}[1]{\textbf{\textit{#1}}}
    


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
    \setlength\cmidrulewidth{0.3pt}  % latex default rule is 0.4 pt
    
    \providetoggle{useSerif}
    \iftoggle{useSerif}{
    	\setlength\heavyrulewidth{0.7pt}
    	\setlength\lightrulewidth{0.4pt}  % latex default rule is 0.4 pt
    	\setlength\cmidrulewidth{0.3pt}
    }{}
    
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
    
    


%%%%%%%%%%%%  ToDoNote.sty  %%%%%%%%%%%%
    % ##############################################
    % Todo Notes (with Example)
    % ##############################################
    
    \usepackage[color=orange!50!,
    bordercolor=orange!50!,
    textsize=scriptsize,
    textwidth=0.9in,
    %disable,    % uncomment to disable package entirely
    ]{todonotes}
    % invisible todo
    \newcommand{\todoINV}[1]{%  can just use \todototoc
    	\todo[linecolor=white, backgroundcolor=white,bordercolor=white, textcolor=white]{#1}%
    }
    \newcommand{\todoG}[1]{%  can just use \todototoc
    	\todo[color=green!90!]{#1}%
    }
    
    %\newcommand{\todoL}[1]{\todo[inline,textsize=\small]{#1}} %inline todo note
    \newcommand{\todoL}[1]{\todo[inline]{#1}} %inline todo note
    %\listoftodos
    %\todototoc{ToC todo, just a random list}
    %\todoG{Check for stuff}

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

%%%%%%%%%%%%  BibAndGloss.sty  %%%%%%%%%%%%
    % requires enumitem for acronym styling
    \usepackage[sorting=none]{biblatex}
    
    \newcommand{\citeT}[1]{\citetitle{#1}~\cite{#1}}
    \renewrobustcmd*{\bibinitdelim}{\,}
    \renewcommand*{\multicitedelim}{\addcomma\,}  % tighten [1,2,3] multi citations
    
    \defbibenvironment{bibliography}
    {\begin{enumerate}[leftmargin=0pt,labelsep=1.5ex,itemsep=0.8ex,label={\unum{\arabic*}.}]}%
    {\end{enumerate}}
    {\item}
    
    \renewcommand*{\citesetup}{%
    \togunums\biburlsetup}
    
    
    \usepackage[xindy,acronym,nonumberlist,toc]{glossaries-extra}
    \renewcommand{\glossarysection}[2][]{} % remove glossary section heading entirely, requires manual but more flexible
    
    
    \GlsXtrEnableEntryCounting % % https://tex.stackexchange.com/questions/477581/glossaries-introduce-short-name-only-if-used-more-than-once-within-section-chap
     	{acronym}% list of categories to use entry counting
     	{1}% trigger value
    
    \setabbreviationstyle[acronym]{long-short}
    
    %\glsenableentrycount % enable \cgls, \cglspl, \cGls, \cGlspl  supposed to not show accronym if only one
    \glsdisablehyper  % to disable hyperlinks
    \glstoctrue  % ToC
    
    \makeglossaries
    
    
    \newglossarystyle{AcronymsTwoCol}{%
    	\renewcommand*{\glossaryheader}{}%
    	\renewcommand*{\glsgroupheading}[1]{}%
    	\renewcommand*{\glossarysubentryfield}[6]{glssubentryitem{##2}{\strut\glstarget{##2}##4\glspostdescription\space ##6}}%
    	\renewcommand*{\glsgroupskip}{\vspace{7pt}}% space between alphabetized groups
    	\renewenvironment{theglossary}%
    		{\vspace*{1ex}\setlength{\columnsep}{30pt}\begin{multicols}{2}%
    		\begin{description}[font=\bfseries,leftmargin=1.7cm,style=multiline,itemsep=3pt]\raggedright}%
    		{\end{description}\end{multicols}}%
    	\renewcommand*{\glossaryentryfield}[5]{%
    		\item[{\normalfont\bfseries\glsentryitem{##1}\glstarget{##1}{##2}}]{##3\glspostdescription\space ##5}
    		}%
    }
    
    
    
    \newglossarystyle{GlossList}{%
    	\renewcommand*{\glossaryheader}{}%
    	\renewcommand*{\glsgroupheading}[1]{}%
    	\renewcommand*{\glossarysubentryfield}[6]{glssubentryitem{##2}{\strut\glstarget{##2}##4\glspostdescription\space ##6}}%
    	\renewcommand*{\glsgroupskip}{\vspace{7pt}}% space between alphabetized groups
    	\renewenvironment{theglossary}%
    		{\vspace*{1ex}%
    		\begin{description}[font=\bfseries,leftmargin=2.7cm,style=multiline,itemsep=3pt]\raggedright}%
    		{\end{description}}%
    	\renewcommand*{\glossaryentryfield}[5]{%
    		\item[{\normalfont\bfseries\glsentryitem{##1}\glstarget{##1}{##2}}]{##3\glspostdescription\space ##5}
    		}%
    }
    
    
    
    
    
    
    
    \usepackage{pdfcomment}
    
    \newcommand{\getTheToolTipText}[1]{%
      \ifcsname#1ToolTipText\endcsname%
        \csname#1ToolTipText\endcsname%
      \else%
        \glsentrylong{#1}%
      \fi%
    }
    
    
    \newcommand{\ac}[1]{%
          \ifglsused{#1}{%
    %         \pdftooltip{\gls*{#1}}{\getTheToolTipText{#1}}\xspace%
    				 {\scshape\pdftooltip{\gls*{#1}}{\getTheToolTipText{#1}}}%
    %         \pdftooltip{\textsc{\MakeLowercase{\gls*{#1}}}}{\getTheToolTipText{#1}}\xspace% todo consider small caps for serfif
        }{%
    %        \gls*{#1}\xspace%
    				{\scshape\gls*{#1}}% todo get to root, make sure acronyms specifically are small caps!
    %				{\textsc{\MakeLowercase{\gls*{#1}}}}
        }%
    }%
    
    
    %add tool tip to acronyms
    
    % todo do this for \Gls and \GLS, maybe * + to gls
    
    %\let\oldgls\gls
    %\RenewDocumentCommand{\gls}{ O{} m O{} }{%
    %    \ifglsused{#2}{%
    %    	\pdftooltip{\oldgls[#1]{#2}[#3]}{\glsentrylong{#2}}%
    %	}{%
    %		\oldgls{#2}%
    %	}%
    %}%
    %\let\oldglspl\glspl
    %
    %
    %
    
    
    %\RenewDocumentCommand{\glspl}{ O{} m O{} }{%
    %    \ifglsused{#2}{%
    %	    \pdftooltip{\oldglspl[#1]{#2}[#3]}{\glsentrylong{#2}}%
    %	}{%
    %		\oldglspl{#2}%
    %	}%
    %}%
    
    
    
    % override some acronyms that don't appear as we want
    \newcommand{\besToolTipText}{Bulk Electric System}
    \newcommand{\ioaToolTipText}{Interconnection and Operating Agreement}
    \newcommand{\rasToolTipText}{Remedial Action Scheme}
    \newcommand{\poiToolTipText}{Point(s) of Interconnection}
    \newcommand{\podToolTipText}{Point(s) of Delivery}
    \newcommand{\oaitToolTipText}{Open Access Interconnection Tariff}
    \newcommand{\oattToolTipText}{Open Access Transmission Tariff}
    \newcommand{\isuToolTipText}{Interconnection System Upgrade(s)}
    
    

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
\usepackage[noenumitem]{autopuncitems}

\begin{luacode*}
	YAMLvars.tabmidrule = 'gmidrule'
\end{luacode*}



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

%%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%


%%%% COLORS %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%  %%%%
\setbeamercolor{background canvas}{bg=background}


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
\setlength{\parskip}{0.25\baselineskip}
\newcommand{\@minipagerestore}{\setlength{\parskip}{0.25\baselineskip}} % for multi columns

\setbeamertemplate{itemize item}{\raisebox{0.1ex}{\color{main}\scalebox{1.0}{$\bullet$}}}
\setbeamertemplate{itemize subitem}{\raisebox{0.1ex}{\color{main}\scalebox{0.8}{$\bullet$}}}
\setbeamertemplate{itemize subsubitem}{\raisebox{0.1ex}{\color{main}\scalebox{0.5}{$\bullet$}}}

% list stuff https://tex.stackexchange.com/questions/31505/trouble-combining-enumitem-and-beamer
%\patchcmd{\@listI}{\itemsep3\p@}{\itemsep2em}{}{}
\patchcmd{\@listI}{\topsep 3\p@}{\topsep 0\p@}{}{}
%\patchcmd{\@listI}{\parsep 0\p@}{\parsep 1\p@}{}{}
\setlength\leftmargini{0em}
\setlength\leftmarginii{1em}
\setlength\leftmarginiii{1em}

\setlength  \labelsep  {0.3em} % default 0.5
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

\def\subtitleINline{\global\toggletrue{inlineframesubtitle}}
\def\subtitleNEWline{\global\togglefalse{inlineframesubtitle}}

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


\newcommand{\cpb@PageRule}{\vline height 1em depth 1.0em width \lightrulewidth}  %% Footer
\setbeamertemplate{footline}{%
    \null\hfill\rlap{\small\hspace*{1ex}\cpb@PageRule\enspace\insertframenumber{}}\hspace*{\beamer@rightmargin}
		\vskip9pt
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
		\ifinsert{title}{{\usebeamerfont{title}\usebeamercolor[fg]{title}\inserttitle\par\vspace{0.8ex}}}
		\ifinsert{subtitle}{{\usebeamerfont{subtitle}\usebeamercolor[fg]{subtitle}\insertsubtitle\vspace{0.4ex}}}
		\Vfill
		\ifinsert{author}{\vfill{\usebeamerfont{author}\insertauthor}}
		\ifinsert{institute}{\vfill{\usebeamerfont{institute}\insertinstitute}}
		\ifinsert{date}{\vfill{\usebeamerfont{date}\insertdate}}
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

\def\begCol{\vspace{2ex}\begin{columns}[t,onlytextwidth]\begin{column}[T]{\cpb@firstcolwidth\textwidth}}

\newcommand{\begColFF}{\gdef\cpb@firstcolwidth{0.46}\begCol} %% fifty-fifty % todo consider adding args ??
\newcommand{\begColNW}{\gdef\cpb@firstcolwidth{0.31}\begCol} %% narrow-wide
\newcommand{\begColWN}{\gdef\cpb@firstcolwidth{0.61}\begCol} %% wide-narrow

\def\cpb@calcnextcolwidth{\fpeval{1-0.08-\cpb@firstcolwidth}}

\newcommand{\nextCol}{\end{column}\hfill\begin{column}[T]{\cpb@calcnextcolwidth\textwidth}}
\def\endCol{\end{column}\end{columns}}


\usepackage{multicol}
\newcommand{\twoCol}[1]{%
    \begin{multicols}{2}
		#1
	\end{multicols}%
}
\setlength{\columnsep}{0.08\textwidth}  % for two column, good for long lists, but use begCol otherwise


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