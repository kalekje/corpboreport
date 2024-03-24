\let\footref\relax % if footref error appears

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{corpboreport}[2022-10-28]

\PassOptionsToClass{%
      11pt,
      letterpaper,
      twoside=false,
      hidelinks,
      parskip=half,
      bibliography=totoc,
      open=right,
      chapterprefix=false,
      fleqn,
      leqno,
      numbers=noenddot,
      titlepage=firstiscover,
}{scrbook}  % default options for basepass

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrbook}} %% pass cbp class options to scrbook
\ProcessOptions\relax

\RequirePackage{iftex} \RequireLuaTeX

\LoadClass{scrbook} % load the base case  % https://texdoc.org/serve/scrbook/0

%%% additional class options: (memo|compact|thesis) &| serif
\RequirePackage{etoolbox}  % https://texdoc.org/serve/etoolbox/0
\newtoggle{useMemo}
\newtoggle{useSerif}
\gdef\TitleLogoPlaceDefault{tl}

\DeclareOption{serif}{\toggletrue{useSerif}}
\DeclareOption{report}{}
\DeclareOption{memo}{
      \toggletrue{useMemo}
      \AtBeginDocument{\global\toggletrue{samepgTitle}\global\toggletrue{ChapOnSamePage}\global\toggletrue{SimpleChaps}}}
\DeclareOption{compact}{\gdef\TitleLogoPlaceDefault{bl}
      \AtBeginDocument{\global\toggletrue{samepgTitle}\global\toggletrue{ChapOnSamePage}\global\toggletrue{SimpleChaps}}}
\DeclareOption{thesis}{\toggletrue{useSerif}
      \AtBeginDocument{\FancyChapters\global\togglefalse{SimpleChaps}\global\togglefalse{ChapOnSamePage}\global\toggletrue{AppendixPage}}}
\ProcessOptions\relax
\AtBeginDocument{\iftoggle{SimpleChaps}{\gdef\chapterpagestyle{scrheadings}}{}}

%https://github.com/mrpiggi/svg/issues/18
\providecommand*{\Ifstr}{\ifstr}  % little hack that supposed to fix ifstr warning, see https://komascript.de/faq_deprecatedif


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
%%%            GeometryCustom+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Check if two-sided https://tex.stackexchange.com/questions/360785/how-do-i-check-if-a-document-is-oneside-or-twoside  %
     % https://tex.stackexchange.com/questions/470752/section-numbers-in-margins-in-double-sided-document
    %preamble
    \if@twoside% if two-sided, put the section headings to right side and numbers in right margin 
    	\usepackage[
    		letterpaper,
    		top=1.46in,
    		headheight=2em,
    		headsep=0.29in,
    		footskip=0.01pt,
    		bottom=1.5in,
    		bindingoffset=0.0in,
    		left=1.30in,
    		right=1.50in,
    	]{geometry} 
    \else%
    \usepackage[
    		letterpaper,
    		top=1.46in,
    		headheight=2em,
    		headsep=0.29in,
    		footskip=0.01pt,
    		bottom=1.5in,
    		bindingoffset=0.0in,
    		left=1.50in,
    		right=1.50in,
    		%showframe=true,
    	]{geometry}
    \fi%  finally do nothing
    
    %%% https://ctan.math.illinois.edu/macros/latex/contrib/geometry/geometry.pdf
    %%% Logic: want header and footer space that is larger than the margin width
    %%% approximately fit a mini page (of same ratio) in the corners and touch the text
    %%% I take the footer in the margin so that I can lengthen a page to squeeze in material where needed
    %%%

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
%%%            TextAndParas+            %%%
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
    
    
    


\usepackage{moreenum}  %% ensure this package does not get used by beamer
\newcounter{moreenumtempcounter}
\NewDocumentCommand{\nword}{m}{\setcounter{moreenumtempcounter}{#1}\nwords{moreenumtempcounter}}


\usepackage{lastpage}



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

}{%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
%%%            HeaderFooterFootnotes+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ##############################################
    % KOMA-Script Settings
    % ##############################################
    \usepackage[headsepline,draft=false]{scrlayer-scrpage}  % enable header line
    \usepackage{scrhack} % helps with issues with other packages
     % https://tex.stackexchange.com/questions/73248/what-packages-are-incompatible-with-koma-script
    
    \clearpairofpagestyles
    		% some example settings
    		%\KOMAoption{paper}{letter}
    		%\KOMAoption{DIV}{14}
    		%\KOMAoption{BCOR}{0mm}
    		%\KOMAoption{headlines}{2}
    		%\KOMAoption{footlines}{0}
    		%%%\usepackage{scrextend}  % not to be use with scr classes, but with article,letter etc to provide some koma features
    
    
    % ##############################################
    % Header and Footer
    % ##############################################
    
    	%% NOTE: should adjust top margin height in GeometryCustom depending on number of lines
    
    \addtokomafont{pageheadfoot}{\upshape}
    
    \lohead{set me with \textbackslash lohead\{\} command}
    \rohead{set me with \textbackslash rohead\{\} command}
    
    %\makeatletter
    %\if@twoside%
    %	\lehead{\textbf{\SPDcode}}
    %	\rehead{\CurrRelease}
    %	\rohead{\textit{A Title for this Report on one Line}}
    %	\lohead{\MakeUppercase{\ReportType}}
    %\else
    %	\lohead{\setstretch{0.8}\textbf{\SPDcode} \\ \CurrRelease}
    %	\rohead{\setstretch{0.8}\MakeUppercase{\ReportType}: \textit{\HeaderTitle}}
    %\fi%  finally do nothing
    %\makeatother
    
    
    % ##############################################
    %  Footnotes
    % ##############################################
    
    \usepackage{footnotebackref}  % must be loaded before footnote backref
    \usepackage[bottom]{footmisc}  %
    \setlength\footnotemargin{0pt}  % space between footnote and number.. might want to experiemnt with this
    % and will likely want to re-create my tabular footnote environment...
    
    \KOMAoptions{footnotes=multiple}% maybe you want to use this option?  # doesn't seem to do anything
    \setfootnoterule{0.5\textwidth}
    \newcommand*\footnotemarkspace{0.0ex} % set distance of the footnote text from the margin
    \deffootnote{\footnotemarkspace}% use distance from above
    {0em}% paragraph indent in footnotes (footnotes should never have paragraphs!)
    % allows for back-references footnotes
    % can put a llap before \textsuper to have a hanging footnote!
    {\makebox[\footnotemarkspace][l]{\llap{{\hyperref[\BackrefFootnoteTag]{\toglnums\thefootnotemark}}}}.\enspace} % footfont with period for footnote marks in footnote
    % hanging footnote
    
    \addtolength{\skip\footins}{12pt plus 5pt}
    
    %footnotebackref breaks footnotetext and footnotemark pairs, this patches it up!!!
    
    \LetLtxMacro{\BHFN@Old@footnotemark}{\@footnotemark}%
    \renewcommand*{\@footnotemark}{%
    	\refstepcounter{BackrefHyperFootnoteCounter}%
    	\xdef\BackrefFootnoteTag{bhfn:\theBackrefHyperFootnoteCounter}%
    	\label{\BackrefFootnoteTag}%
    	{\toglnums\BHFN@Old@footnotemark}%
    }
    
    
    %{\makebox[\footnotemarkspace][l]{\llap{{\hyperref[\BackrefFootnoteTag]{\thefootnotemark}}}}.\enspace} % footfont with period for footnote marks in footnote
    % https://tex.stackexchange.com/questions/339506/right-align-one-and-two-digit-footnote-marks-with-koma


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            SectionsToC+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% References %%%%%
    % KOMA-Script: https://texdoc.org/serve/scrbook/0
    \RequirePackage{etoolbox} % https://texdoc.org/serve/etoolbox/0
    \RequirePackage{chngcntr}
    \RequirePackage{needspace} % https://texdoc.org/serve/needspace/0
    
    
    %%% Header %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    \renewcommand{\chaptermark}[1]{%
      \markboth{\chapapp\ \thechapter\autodot}{#1}}
    \renewcommand{\addchapmark}[1]{\markboth{#1}{#1}}
    
    
    %%% Section Related %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    \providetoggle{ChapOnSamePage}
    \providetoggle{SimpleChaps}
    \providecommand{\cbp@secnumsize}{\smaller}
    
    
    \newlength{\cbp@chapTopSep}        \setlength{\cbp@chapTopSep}{0.2em}
    \newlength{\cbp@chapTopSepXtra}    \setlength{\cbp@chapTopSepXtra}{3.5em}
    \newlength{\cbp@chapBtwnSep}       \setlength{\cbp@chapBtwnSep}{2.5em}
    
    
    \pretocmd{\section}{\needspace{2em}}{}{}
    \pretocmd{\subsection}{\needspace{1em}}{}{}
    \pretocmd{\subsubsection}{\needspace{0.5em}}{}{}
    \pretocmd{\paragraph}{\needspace{0.5em}}{}{}
    
    
    \setkomafont{disposition}{\normalfont\bfseries} % section preference
    
    \def\FancyChapters{
      \global\setlength{\cbp@chapTopSep}{0.2em}
      \RedeclareSectionCommand[afterskip=16pt]{chapter}
      \addtokomafont{chapterprefix}{}
      \renewcommand*{\chapterformat}{%
      \mbox{\scalebox{3}{\raggedleft\color{chapCol}\toglnums\thechapter\autodot}}}
      \renewcommand\chapterlinesformat[3]{%
        \raggedleft\raisebox{0pt}[0pt][0pt]{##2\hspace{0.5in}}\hfill\\\smallskip \raggedright ##3%
      }
      \global\togglefalse{SimpleChaps}
    }%
    
    %\FancyChapters
    
    \def\SimpleChapters{
      \global\setlength{\cbp@chapTopSep}{0.2em}
      \RedeclareSectionCommand[afterskip=8pt]{chapter}
      \addtokomafont{chapterprefix}{\raggedright\cbp@secnumsize}
      \renewcommand*{\chapterformat}{\mbox{\thechapter\autodot\enskip}}  % https://tex.stackexchange.com/questions/25030/chapter-number-and-chapter-title-in-one-line
      \renewcommand\chapterlinesformat[3]{%
        \makebox[0pt][r]{\cbp@secnumsize##2\hspace{2pt}}\nobreak##3%
      }
      \global\toggletrue{SimpleChaps}
    }
    
    \SimpleChapters
    
    \gdef\chapterheadstartvskip{\vspace*{\cbp@chapTopSep}}
    
    
    % Hanging section, % NUMBERS IN LEFT MARGIN
    %https://tex.stackexchange.com/questions/381261/right-align-chapter-numbering-in-koma-script-toc?rq=1
    \renewcommand\sectionlinesformat[4]{%
    	\makebox[0pt][r]{\cbp@secnumsize#3\hspace{2pt}}#4%
    }
    \renewcommand\sectioncatchphraseformat[4]{% used by run-in headings with style=section
    	\makebox[0pt][r]{\cbp@secnumsize#3\hspace{1pt}}#4%
    }
    
    \addtokomafont{chapter}{\color{chapCol}\LARGE}
    \addtokomafont{section}{\color{secCol}\Large}
    \addtokomafont{subsection}{\color{subsecCol}\large}
    \addtokomafont{subsubsection}{\color{subsubsecCol}\normalsize}
    \addtokomafont{paragraph}{\color{parCol}}
    
    %%% ToC Related %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    \NewDocumentCommand{\tocpagebreak}{}{\addtocontents{toc}{\protect\pagebreak}} % add page break, use this before a chapter
    %\NewDocumentCommand{\tocpagebreak}{}{\addtocontents{toc}{\par\vspace*{1em}\par\vspace*{100em}}} % add page break, use this before a chapter
    
    \setcounter{tocdepth}{1} %%% TOC Depth down to sections
    
    \newcommand\tocmainfont[1]{{\cbp@secnumsize{}#1}}
    
    \providetoggle{showListOfFigsTabs}
    \providetoggle{samepgListOfFigsTabs}
    
    \renewcaptionname{english}{\listtablename}{List of Tables}
    \renewcaptionname{english}{\listfigurename}{List of Figures}
    
    \newcommand{\secwiselabelnums}{
      \counterwithin{figure}{chapter}
      \counterwithin{table}{chapter}
    %  \counterwithin{lstlisting}{chapter} %%% done automatically
    }
    
    \newcommand{\notsecwiselabelnums}{
      \counterwithout{figure}{chapter}
      \counterwithout{table}{chapter}
    %  \counterwithout{listing}{chapter}
      \gdef\thefigure{\arabic{figure}}
      \gdef\thetable{\arabic{table}}
      \gdef\autodot{}  %% for some reason this gets reset when above is used, force-hide autodot cause I don't like em
    %  \gdef\thelsting{\arabic{listing}}
    }
    
    
    \countdef\diamondcounter=255
    \def\diamondleaders{\global\advance\diamondcounter by 1
    	\ifodd\diamondcounter \kern-10pt \fi
    	\leaders\hbox to 20pt{\ifodd\diamondcounter \kern13pt \else\kern3pt \fi
    		.\hss}\hfil}
    
    
    \newcommand\cbp@chapterToCentryformat[1]{% define the new format for the chapter numbers in ToC
    	% \renewcommand\autodot{.}% dot after chapter
    	\hfill\cbp@secnumsize#1\enspace\hspace{1pt}% align chapter numbers right
    }
    
    
    \DeclareTOCStyleEntries[%
    linefill=\diamondleaders,
    level:=figure,
    indent=-5ex,
    numwidth=5ex,
    entryformat=\normalsize,
    entrynumberformat=\cbp@chapterToCentryformat,
    ]{tocline}{figure,table,lstlisting}
    
    
    
    %%% Major section formatting %%%%%%%%%%%%%%%%%%%%
    
    \newlength{\cbp@chapterToCskip}\setlength{\cbp@chapterToCskip}{1em}  % allow user to change in document easily
    
    \RedeclareSectionCommand[
    tocbeforeskip=1.2em plus 0.2em minus 1pt,
    tocindent=-4ex,
    tocnumwidth=4ex,
    tocbeforeskip=\cbp@chapterToCskip,
    toclinefill=\diamondleaders,
    tocentryformat=\large\bfseries,
    tocentrynumberformat=\cbp@chapterToCentryformat,
    %tocpagenumberformat=\tocmainfont,
    ]{chapter}
    
    \RedeclareSectionCommand[
    beforeskip=1.1em plus 3pt minus 1pt,  % negative will suppress first indent
    afterskip=3pt,
    tocbeforeskip=2pt,
    tocindent=0.5ex,
    tocnumwidth=6ex,
    toclinefill=\diamondleaders,
    tocentrynumberformat=\cbp@secnumsize,
    tocentryformat=\large,
    %tocpagenumberformat=\tocmainfont,
    ]{section}
    
    \RedeclareSectionCommand[
    beforeskip=0.8em plus 2pt minus 2pt,
    afterskip=0.01mm,%\baselineskip,
    tocindent=6.5ex,
    tocnumwidth=6ex,
    toclinefill=\diamondleaders,
    tocentrynumberformat=\cbp@secnumsize,
    tocentryformat=\normalsize,
    ]{subsection}
    
    \RedeclareSectionCommand[
    beforeskip=0.4em plus 2pt minus 2pt,
    afterskip=0.01mm,
    runin=false,  % text on same line
    tocindent=6ex,
    tocnumwidth=10ex,
    tocentrynumberformat=\cbp@secnumsize,
    tocentryformat=\small,
    ]{subsubsection}
    
    \RedeclareSectionCommand[
    beforeskip=0pt,
    afterskip=-1.2ex]{paragraph}
    
    \RedeclareSectionCommand[
    beforeskip=-.5\baselineskip,
    afterskip=-1.2ex]{subparagraph}
    
    \setcounter{secnumdepth}{3} % a.b.c.d for subsubsection, then numbering stops. Try to avoid though
    
    
    \NewDocumentCommand{\vspaceT}{m}{\vspace{-#1} \vspace*{#1}}
    
    
    
    % front matter chapter (acknowledgements or abstract), extra spacing, not in ToC
    \NewDocumentCommand{\chapterf}{m}{
      \gdef\chapterheadstartvskip{\vspace*{\cbp@chapTopSepXtra}}  % extra top sep of chapter
      \pdfbookmark[0]{#1}{Label#1PDF}%
      \chapter*{#1}%
      \gdef\chapterheadstartvskip{\vspace*{\cbp@chapTopSep}}  % restore top sep of chapter
    }
    
    \NewDocumentCommand{\chaptert}{ t- m }{% chapter Matter (front or back), ToC and pdf bookmark but no number. Use - to reduce ToC clearance
      \IfBooleanT{#1}{\addtocontents{toc}{\vspace*{-1.3ex}}}
      \chapter*{#2}
      \addtocentrydefault{chapter}{\phantom{.}}{#2}{}
      \chaptermark{#2}
    }
    
    
    \def\frontmatter{
      \pdfbookmark[-1]{Front-Matter}{LabelFMPDF}
      \pdfbookmark[0]{Title}{LabelTitlePDF}
    }
    
    
    %%% ToC tweaking / high level command
    \newlength{\ToCextrabottomroom}\setlength{\ToCextrabottomroom}{0.0em}
    \newlength{\pullToCcloser}\setlength{\pullToCcloser}{0pt}
    
    \def\tighterToCchap{\addtocontents{toc}{\vspace*{-1.3ex}}}
    
    \NewDocumentCommand{\tocvspace}{O{1.3ex}}{\addtocontents{toc}{\protect\vspace*{#1}}}
    
    \AfterTOCHead[lot]{\vspace*{-1.5em}} % hack to fix extra space under LoT.. investigate why..
    
    \NewDocumentCommand{\addcontentslist}{s m O{} O{listof#2} }{
        \iftbl{toc.#2}{
          \IfBooleanTF{#1}{}{\addtocentrydefault{chapter}{\phantom{.}}{#3}\tighterToCchap}%
          \begin{addmargin}[\gettbl{toc.left}]{\gettbl{toc.right}}
            \csname#4\endcsname
          \end{addmargin}
          \chaptermark{#3}
        }
    }
    
    % https://tex.stackexchange.com/questions/520257/changing-toc-spacing-and-adding-words-to-toc-using-scrbook
    \NewDocumentCommand{\addcontentslists}{O{}}{
      \tblfrkv{toc}{#1}[defaults=
        {contents=true,figures=false,tables=false,figtabsamepg=false,listings=false,
      right=0in,bottom=0in,left=0in,top=0in,chapsep=1em,  % top left are margins, sep is sep between Tasep
      levels=1,pdflevels=3}]
      \kvtblundefcheck
      \setlength{\cbp@chapterToCskip}{\gettbl{toc.chapsep}} % set length of chapter spacing, see \RedeclareSectionCommand for chapter
    %  \addtocontents{toc}{\protect\enlargethispage{\ToCextrabottomroom}} % enlarge toc page if needed
      \setcounter{tocdepth}{\gettbl{toc.levels}} %%% TOC Depth down to sections
      \pdfbookmark[0]{Contents}{LabelContentsPDF}
      \addcontentslist*{contents}[Contents][tableofcontents]
      \setcounter{tocdepth}{\gettbl{toc.pdflevels}} %%% restore toc levels for PDF bookmarks
      % todo could allow tables or figures order
      \addcontentslist{tables}[Tables]
      \iftbl{toc.figtabsamepg}{\toggletrue{ChapOnSamePage}}
      \vspace*{-0.5cm}
      \addcontentslist{figures}[Figures]
      \addcontentslist{listings}[Code Listings][lstlistoflistings]
    }
    
    \def\mainmatter{\bookmarksetup{startatroot}}
    
    \def\backmatter{\pdfbookmark[-1]{Back-Matter}{LabelBMPDF}}
    
    
    \def\moreroomlen{3em}
    \NewDocumentCommand{\moreroom}{m}{\enlargethispage{\dimeval{(\moreroomlen)*#1}}}
    
    %%%% Appendix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    \providecommand*\appendixname{Appendix}
    \let\originalappendix\appendix
    
    \providetoggle{AppendixPage}
    
    \renewcommand\appendix{%
    	%
      \addtocontents{toc}{%
        \vspace*{1.3ex}%
        \protect\contentsline{chapter}{\hspace{3.5ex}Appendix\hfill\ }{}{}}
      %
      \pdfbookmark[-1]{Appendix}{LabelAppendicesPDF}
    	%
    	\originalappendix
      \crefalias{chapter}{appsec}
      
      \iftoggle{useSerif}{
    	  \def\thechapter{{\scshape\alph{chapter}}}
    	  \def\theHchapter{{\scshape\alph{chapter}}}
      }{
    %    \def\thesection{\Alph{section}}
    %    \def\theHsection{\Alph{section}}
      }
      \iftoggle{AppendixPage}{
        \gdef\chapterheadstartvskip{\vspace*{\cbp@chapTopSepXtra}}  % extra top sep of chapter
        \chapter*{Appendix}
        \gdef\chapterheadstartvskip{\vspace*{\cbp@chapTopSep}}  % restore top sep of chapter
        \ \ \clearpage
      }{}
      
      \iftoggle{SimpleChaps}{
    	\renewcommand\chapterformat{{\appendixname~\thechapter\autodot}}
       \renewcommand\chapterlinesformat[3]{%
        \ifblank{##2}{}{##2\\}##3}% only if chapter has a number
      % % todo need to fix?
      %	\renewcommand\sectionlinesformat[4]{%
    %		\ifstr{##1}{section}
    %		{\clearpage\vspace*{\sectprespacelength}##3\\*##4}% appendix sections on new page
    %		{\makebox[0pt][r]{\cbp@secnumsize##3}{##4}}% subsections etc.
    %	}%
      }{}
    }
    
    
    %%% to allow same page chapters
    \patchcmd{\scr@startchapter}{\if@openright\cleardoublepage\else\clearpage\fi}{%
      \iftoggle{ChapOnSamePage}{\needspace{4em}\vspace{\cbp@chapBtwnSep}}{\if@openright\cleardoublepage\else\clearpage\fi}%
    }{}{}
    
    \def\NextChapOnSamePage{\toggletrue{ChapOnSamePage}\afterpage{\global\togglefalse{ChapOnSamePage}}}
    
    % a command used for memo / compact style
    \def\cbp@FirstPagePlain{\gdef\chapterpagestyle{plain}\thispagestyle{plain}\afterpage{\gdef\chapterpagestyle{scrheadings}}}
    
    \def\noSectionNumbers{%
      \setcounter{secnumdepth}{-\maxdimen}\notsecwiselabelnums
      \RedeclareSectionCommand[tocindent=0ex,tocnumwidth=0ex]{chapter}
    }  % remove sec num
    
    
    
    
    
    
    
    
    
    
    
    
    %\global\@nobreaktrue
    %\pretocmd{\chapter}{\iftoggle{ChapOnSamePage}{\cbp@zerochapspace}{}}{}{}
    %\apptocmd{\chapter}{\iftoggle{ChapOnSamePage}{\cbp@normalchapspace}{}}{}{}
    %\pretocmd{\chapter}{\cbp@samepgchapspace}{}{}
    
    
    %\NewCommandCopy\cbp@oldchapter\chapter
    %\RenewDocumentCommand{\chapter}{ s o m }{%
    %  \begingroup
    %  \iftoggle{ChapOnSamePage}{\def\clearpage{}\def\pagebreak{}\def\newpage{}\def\cleardoubleoddpage{}\def\cleardoublepage{}}{}% disable clearpage for this chapter call
    %    \expanded{%
    %        \noexpand\cbp@oldchapter%
    %          \IfBooleanT{#1}{*}%
    %          \IfValueT{#2}{\unexpanded{[#2]}}%
    %          \unexpanded{{#3}}%
    %    }%
    %  \endgroup
    %}
    
    
    % todo investifgate
    %
    %%  https://tex.stackexchange.com/questions/292397/how-to-use-patchcmd-to-insert-clearpage-before-chapter-to-avoid-breaking-page
    %   \RedeclareSectionCommand[
    %  style=section,
    %  indent=0pt
    %  ]{chapter}
    
    
    %\newcommand{\ShowChapterPrefix}{
    %  \renewcommand*{\chapterformat}{%
    %  \color{brown}%
    %  \mbox{\raisebox{5ex}{\normalsize
    %  \chapappifchapterprefix
    %  {\nobreakspace}}%
    %  \scalebox{3}{\thechapter\autodot}\enskip}}
    %}%
    
    %\newcommand{\HideChapterPrefix}{
    %\renewcommand*{\chapterformat}{%
    %\color{brown}%
    %\mbox{\scalebox{3}{\thechapter\autodot}\enskip}}}%
    %\HideChapterPrefix


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            PageNumberInMargin+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% DEPENDENCIES
    % KOMA-Script class
    %%%
    
    %%%%%%% IN ACTUAL FOOTER (WITH VERTICAL LINE RUNNING TO BOTTOM)
    %%%%%
    \newlength{\raiseFooterLen}
    \setlength{\raiseFooterLen}{-0.5\baselineskip}
    \newlength{\lineFooterLen}
    \setlength{\lineFooterLen}{1.25em}
    %https://tex.stackexchange.com/questions/114570/koma-script-scrpage2-footer-height
    
    % normal font for page number (not lowercase nums)
    \renewcommand*{\pnumfont}{\normalfont\small} % https://www.dickimaw-books.com/latex/thesis/html/newpagestyle.html
    %\renewcommand*{\pnumfont}{\normalfont\cbp@secnumsize} % https://www.dickimaw-books.com/latex/thesis/html/newpagestyle.html
    
    
    \newcommand{\PageRule}{\vline height 1em depth \lineFooterLen width \arrayrulewidth}
    
    \newcommand{\LeftPageMarkLine}{%
    	\vskip-\raiseFooterLen
    	\llap{\pagemark\enspace\PageRule\enspace\enspace\enspace}%
    }%
    
    \newcommand{\RightPageMarkLine}{%
    	\vskip-\raiseFooterLen
    	\hfill\rlap{\enspace\enspace\enspace\PageRule\enspace\pagemark}%
    }
    
    \rofoot[\RightPageMarkLine]{\RightPageMarkLine}
    
    \lefoot[\LeftPageMarkLine]{\LeftPageMarkLine}
    


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
%%%            DraftStuff+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Draft toggles to speed up compilation and help
    %\DarkModePDF
    %\DraftMark
    %\LowQuality
    %\ShowBadBoxes
    %\ShowRuler
    %\NoFigures
    %\NoPDFs
    
    
    \newcommand{\DraftMark}{\usepackage{background}
    	\backgroundsetup{%
    		scale=14,       %% change accordingly
    		angle=45,       %% change accordingly
    		opacity=.5,    %% change accordingly
    		color =lightgray,  %% change accordingly
    		contents={\texttt{DRAFT}}
    }}
    
    \newcommand{\PreMark}{\usepackage{background}
    	\backgroundsetup{%
    		scale=8,       %% change accordingly
    		angle=45,       %% change accordingly
    		opacity=.5,    %% change accordingly
    		color =lightgray,  %% change accordingly
    		contents={\texttt{PRELIMINARY}}
    }}
    
    \let\PreLimMark\PreMark % old def just in case
    
    
    
    \newcommand{\DarkModePDF}{%
    	\pagecolor[rgb]{0.192,0.2,0.208}
    	\color[rgb]{0.98,0.98,0.93}
    	\colorlet{secCol}{white}
    	\colorlet{subsecCol}{white}
    	\colorlet{subsubsecCol}{white}
    
    }
    
    
    \newcommand{\LowQuality}{
    	\pdfcompresslevel=0
    	\pdfobjcompresslevel=0
    }
    
    \newcommand{\ShowBadBoxes}{\KOMAoptions{draft=true}}
    
    \newcommand{\NoFigures}{\setkeys{Gin}{draft}}
    
    \newcommand{\NoPDFs}{\renewcommand{\includepdf}[2][]{}% replace includepdf with do nothing
    }
    
    \newcommand*\showlayer[2][black]{%
    	\IfLayerAtPageStyle{scrheadings}{#2}{%
    		\DeclareNewLayer[clone=#2,contents=\textcolor{#1}{\layercontentsmeasure}]{#2.size}%
    		\AddLayersToPageStyleAfterLayer{scrheadings}{#2.size}{#2}%
    	}{}%
    }
    \newcommand{\ShowRuler}{
    	\showlayer[red!30]{scrheadings.head.below.line}
    	\showlayer[red!30]{scrheadings.foot.above.line}%
    }
    
    \newcommand{\ShowGrid}{\usepackage[enable]{pagegrid}\pagegridsetup{tl,tr}}
    
    
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            BibAndGloss+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % requires enumitem for acronym styling
    \usepackage[sorting=none,style=ieee,backend=biber,style=numeric,uniquename=false,giveninits,maxcitenames=1]{biblatex}
    
    
    \renewrobustcmd*{\bibinitdelim}{\,}
    \renewcommand*{\multicitedelim}{\addcomma\,}  % tighten [1,2,3] multi citations
    
    \defbibenvironment{bibliography}
    {\begin{enumerate}[leftmargin=0pt,labelsep=1.5ex,itemsep=0.8ex,label={\unum{\arabic*}.}]}%
    {\end{enumerate}}
    {\item}
    
    
    \setlength\biblabelsep{1ex}
    % https://tex.stackexchange.com/questions/634490/biblatex-change-appearance-of-reference-number-as-they-appear-in-the-reference
    \DeclareFieldFormat{labelnumberwidth}{#1\addperiod}
    \defbibenvironment{bibliography}
      {\list
         {\printtext[labelnumberwidth]{%
    			 \unum*%
            \printfield{labelprefix}%
            \printfield{labelnumber}}}
         {\setlength{\labelwidth}{\labelnumberwidth}%
          \setlength{\leftmargin}{0pt}%
          \setlength{\labelsep}{\biblabelsep}%
          \setlength{\itemsep}{\bibitemsep}%
          \setlength{\parsep}{\bibparsep}}%
          \renewcommand*{\makelabel}[1]{\hss##1}}
      {\endlist}
      {\item}
    
    
    
    %% made possible by biblatex-ext,   https://tex.stackexchange.com/questions/22980/sentence-case-for-titles-in-biblatex
    
    \DeclareFieldFormat
      [@Article,Article,incollection,inproceedings,InProceedings,patent] % ,inbook,thesis,unpublished
      {titlecase:title}{\MakeSentenceCase*{#1}}
    
    
    %\DeclareFieldFormat{titlecase:title}{\MakeSentenceCase*{#1}}
    %% https://www.reddit.com/r/LaTeX/comments/xe2pl9/losing_title_case_in_bib_file_when_adding_to/
    %% https://www.ieee.org/content/dam/ieee-org/ieee/web/org/conferences/style_references_manual.pdf
    
    
    
    \renewcommand*{\citesetup}{%
    \togunums\biburlsetup}
    
    
    \NewDocumentCommand{\citea}{m}{\citename{#1}[family]{author}~(\citefield{#1}{year})~\cite{#1}}
    \newcommand{\citet}[1]{\citetitle{#1}~\cite{#1}}% cite title
    
    \NewDocumentCommand{\citeay}{m m}{#1~et~al.~(#2)~\cite{#1#2}}
    
    
    \newcommand{\citeT}[1]{\citetitle{#1}~\cite{#1}}% cite title
    \NewDocumentCommand{\citenumber}{m}{\citefield{#1}[]{number}}
    
    %% citing without pushing to bibliography
    \NewDocumentCommand{\fullcitenobib}{m}{\begin{refsection}\fullcite{#1}\end{refsection}}
    
    \NewDocumentCommand{\citestd}{m}{\begin{refsection}\citeauthor{#1} \citefield{#1}[]{number} -- \citefield{#1}[]{year}: \citetitle{#1}\end{refsection}}
    
    
    %% todo: possibly rebuild the cite commands but add a '-' decorator to supress referencing
    
    
    
    %%%%%%%%%
    %%% Glossaries / index / symbol %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%
    
    
    \usepackage[xindy,sanitizesort,acronym,index,symbols,
    	nohypertypes={acronym,index,symbols},
    ]{glossaries-extra}
    %,nonumberlist <<< dont use as custom styles are made
    % toc <<< dont use ToC option as manually entered
    
    \renewcommand{\glossarysection}[2][]{} % remove glossary section heading entirely, requires manual but more flexible
    
    
    
    \renewbibmacro{in:}{}
    %https://tex.stackexchange.com/questions/10682/suppress-in-biblatex
    
    
    % https://tex.stackexchange.com/questions/269565/glossaries-how-to-customize-list-of-symbols-with-additional-column-for-units
    %%% todo make symbols glossary OR just print a simple table with an excel macro, might be easiest
    %\newglossary[slg]{symbols}{syi}{syg}{Symbolslist} % create add. symbolslist
    
    %\newglossary[ilg]{index}{ind}{idx}{\indexname}
    % make a command
    % \gls, \ac,  \idx
    
    
    \GlsXtrEnableEntryCounting % % https://tex.stackexchange.com/questions/477581/glossaries-introduce-short-name-only-if-used-more-than-once-within-section-chap
     	{acronym}% list of categories to use entry counting
     	{1}% trigger value
    
    \glstoctrue  % ToC
    
    \makeglossaries
    
    
    \newglossarystyle{AcronymsTwoCol}{%
    	\renewcommand*{\glossaryheader}{}%
    	\renewcommand*{\glsgroupheading}[1]{}%
    	\renewcommand*{\glsgroupskip}{\vspace{7pt}}% space between alphabetized groups
    	\renewcommand{\glossentry}[2]{
    		\item[\glsentryshort{##1}]{\glsentrylong{##1}\glspostdescription}
    	}
    	\renewenvironment{theglossary}%
    		{\vspace*{1ex}\setlength{\columnsep}{30pt}\begin{multicols}{2}%
    			\begin{description}[font=\iftoggle{useSerif}{\rmfamily}{}\bfseries,leftmargin=1.7cm,style=multiline,itemsep=3pt]\raggedright
    		}{%
    			\end{description}\end{multicols}
    	}%
    % todo try below in item, try ifsymbol make a symbol else use glossary name, same style for symbols and acronyms
    %\renewcommand*{\glossentry}[2]{%
    %\item % bullet point
    %\glstarget{##1}{\glossentryname{##1}}% the entry name
    %\space (\glossentrysymbol{##1})% the symbol in brackets
    %\space \glossentrydesc{##1}% the description
    %\space [##2]% the number list in square brackets
    %}%
    }
    
    
    
    %\setabbreviationstyle[acronym]{long-sc-short}
    %\glsenableentrycount % enable \cgls, \cglspl, \cGls, \cGlspl  supposed to not show accronym if only one
    %\glsdisablehyper  % to disable hyperlinks
    
    
    
    \newglossarystyle{GlossList}{%
    	\renewcommand*{\glossaryheader}{}%
    	\renewcommand*{\glsgroupheading}[1]{}%
    	\newcommand*{\glossarysubentryfield}[6]{glssubentryitem{##2}{\strut\glstarget{##2}##4\glspostdescription\space ##6}}% caused error on update 2022 11 03
    	\renewcommand*{\glsgroupskip}{\vspace{7pt}}% space between alphabetized groups
    	\renewenvironment{theglossary}%
    		{\vspace*{1ex}%
    		\begin{description}[font=\bfseries,leftmargin=2.7cm,style=multiline,itemsep=3pt]\raggedright}%
    		{\end{description}}%
    	\newcommand*{\glossaryentryfield}[5]{%
    		\item[{\normalfont\bfseries\glsentryitem{##1}\glstarget{##1}{##2}}]{##3\glspostdescription} % \space ##5 argument 5, page numbers, are removed
    		}%
    }
    
    
    
    \newglossarystyle{mylist}{%
    % put the glossary in the itemize environment:
    \renewenvironment{theglossary}%
    {\begin{itemize}}{\end{itemize}}%
    % no header after \begin{theglossary}
    \renewcommand*{\glossaryheader}{}%
    % no visual distinction between glossary groups:
    \renewcommand*{\glsgroupheading}[1]{}%
    \renewcommand*{\glsgroupskip}{}%
    % set how each entry should appear:
    \renewcommand*{\glossentry}[2]{%
    \item % bullet point
    \glstarget{##1}{\glossentryname{##1}}% the entry name
    \space (\glossentrysymbol{##1})% the symbol in brackets
    \space \glossentrydesc{##1}% the description
    \space [##2]% the number list in square brackets
    }%
    % set how sub-entries appear:
    \renewcommand*{\subglossentry}[3]{%
    \glossentry{##2}{##3}}%
    }
    
    
    
    \newglossarystyle{TwoCol}{%
    	\renewcommand*{\glossaryheader}{}%
    	\renewcommand*{\glsgroupheading}[1]{}%
    	\renewcommand*{\glsgroupskip}{\vspace{7pt}}% space between alphabetized groups
    	\renewcommand{\glossentry}[2]{
    		\item[\glsentryshort{##1}]{\glsentrylong{##1}\glspostdescription}  % #2 would be page numbers
    	}
    	\renewenvironment{theglossary}%
    		{\vspace*{1ex}\setlength{\columnsep}{30pt}\begin{multicols}{2}%
    			\begin{description}[font=\iftoggle{useSerif}{\rmfamily}{}\bfseries,leftmargin=1.7cm,style=multiline,itemsep=3pt]\raggedright
    		}{%
    			\end{description}\end{multicols}
    	}%
    }
    
    
    	\setabbreviationstyle[acronym]{long-short}
    
    \iftoggle{useSerif}{
    %		\setabbreviationstyle[acronym]{long-short}
    %		\global\renewcommand{\acronymfont}[1]{\textsc{#1}}  % up for debate...i should define proper case]
    %		\setabbreviationstyle[acronym]{long-sc-short}
    	}{
    		\setabbreviationstyle[acronym]{long-short}
    }
    
    %\global\renewcommand{\acronymfont}[1]{{\scshape#1}}  % up for debate...i should define proper case]
    
    
    %\setabbreviationstyle[acronym]{long-em-short-em}
    %\renewcommand*{\glslongemfont}[1]{#1}% change the emphasize font to null for long-em-short-em style
    %\renewcommand*{\glsabbrvemfont}[1]{\textsc{#1}}% change abbreviation emphasis to small-caps
    %\glssetcategoryattribute{acronym}{glossnamefont}{textsc}
    
    
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
    				 {\pdftooltip{\gls*{#1}}{\getTheToolTipText{#1}}}%
    %         \pdftooltip{\textsc{\MakeLowercase{\gls*{#1}}}}{\getTheToolTipText{#1}}\xspace% todo consider small caps for serfif
        }{%
    %        \gls*{#1}\xspace%
    				{\gls*{#1}}% todo get to root, make sure acronyms specifically are small caps!
    %				{\textsc{\MakeLowercase{\gls*{#1}}}}
        }%
    }%
    
    
    \newcommand{\Ac}[1]{%
          \ifglsused{#1}{%
    %         \pdftooltip{\gls*{#1}}{\getTheToolTipText{#1}}\xspace%
    				 {\pdftooltip{\Gls*{#1}}{\getTheToolTipText{#1}}}%
    %         \pdftooltip{\textsc{\MakeLowercase{\gls*{#1}}}}{\getTheToolTipText{#1}}\xspace% todo consider small caps for serfif
        }{%
    %        \gls*{#1}\xspace%
    				{\Gls*{#1}}% todo get to root, make sure acronyms specifically are small caps!
    %				{\textsc{\MakeLowercase{\gls*{#1}}}}
        }%
    }%
    
    
    
    \let\acs\glsxtrshort  %  short and long acronym shortcuts
    \let\acl\glsxtrlong   %
    
    
    % todo :    add prefix on acronym ac.cnn, on index like idx.cnn, and on symbols like sym.X
    % then use a \ac \idx \sym that calls \ac = \gls{ac.#1}  \Idx = \Gls{idx.#1}  etc. etc.
    %
    %
    
    
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
%%%            Titles+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% document variables, title page, etc.
    % most doc vars update the pdf metedata by wriiting to main.xmpdata
    
    \def\overwritepdfwithdocvar{true}
    
    \RenewDocumentCommand{\title}{m}{\luadirect{
    	pl.tex.defcmdAT('@title', \luastringN{#1})
    	pl.tex.updatePDFtable('Title', pl.tex.makePDFvarstr(\luastringN{#1}), \overwritepdfwithdocvar)
    	pl.tex.defcmd('thetitle', pl.tex.makeInTextstr(\luastringN{#1}))
    }}
    
    \RenewDocumentCommand{\author}{m}{\luadirect{
    	pl.tex.defcmdAT('@author', \luastringN{#1})
    	pl.tex.updatePDFtable('Author', pl.tex.makePDFvarstr(\luastringN{#1}), \overwritepdfwithdocvar)
    	pl.tex.defcmd('theauthor', pl.tex.makeInTextstr(\luastringN{#1}))
    	}%
    	\NewDocumentCommand{\theauthors}{ o }{%
    		\IfValueTF{##1}%
    		{\luadirect{tex.sprint(token.get_macro('@author'):split([[\string\and]])[tonumber(\luastringO{##1})]:strip())}}%
    		{\splitToComma[o n]{\@author}{\and}}%
    	}%
    	\gdef\listauthors{\splitToItems[on]{\@author}{\and}}%
    }
    
    \RenewDocumentCommand{\date}{m}{\luadirect{
    	pl.tex.defcmdAT('@date', \luastringN{#1})
    	pl.tex.defcmd('thedate', pl.tex.makeInTextstr(\luastringN{#1}))
    }
    \luaexec{pl.tex.updatePDFtable('Date', os.date'\%Y-\%m-\%d', true)}
    }
    
    \NewDocumentCommand{\company}{m}{\luadirect{
    	pl.tex.defcmdAT('@publishers', \luastringN{#1})
    	pl.tex.updatePDFtable('Publisher', pl.tex.makePDFvarstr(\luastringN{#1}), \overwritepdfwithdocvar)
    	pl.tex.defcmd('thecompany', pl.tex.makeInTextstr(\luastringN{#1}))
    }}
    
    \let\publishers\company
    \let\thepublishers\thecompany
    % use @publishers to match KOMA, Publisher for PDFvar
    % for beamer, company = institute
    
    \def\@logoset{width=4cm} % additional logo settings
    \NewDocumentCommand\logoset{m}{\gdef\@logoset{#1}}
    
    \NewDocumentCommand{\logo}{ s >{\ExpArgOnceProc}O{\@logoset} m }{%
    % star to overwrite custom settings for image, otherwise, try to let the class place it
    	\IfBooleanTF{#1}%
    	{\gdef\@logo{#3}}%
    	{\gdef\@logo{\includegraphics[#2]{#3}}}
    }
    
    
    \newlength\cbp@titleheight
    \setlength\cbp@titleheight{8.0in} % additional logo settings
    
    
    \providetoggle{samepgTitle}
    %%% title pages
    
    \gdef\cbp@tpPage{
    \begin{titlepage}\thispagestyle{empty}
    	\rule{\heavyrulewidth}{\cbp@titleheight} % Vertical line
    	\hspace{0.5in} % Whitespace between the vertical line and title page text
    	\begin{minipage}[b][\cbp@titleheight][s]{4.6in}
    		\raggedright % Right align the title page
    		\toglnums
    		\thispagestyle{empty}
    	    \raggedright
    
    		\null\vfill\null\vfill
    
    		\parbox[t]{\linewidth}{\LARGE\bfseries\@title}% Title  \bfseries
    
    		\ifdef{\@subtitle}{
    		\null\vfill\par\vfill\par
    			\parbox[t]{\linewidth}{\normalsize\itshape\@subtitle} % Subtitle or further description
    		}{}
    		\ifdef{\@author}{\def\and{\\}
    			\null\vfill\par\vfill\par
    			\parbox[t]{\linewidth}{\bfseries\Large\@author}
    		}{}
    		\ifdef{\@publishers}{\def\and{\\}
    			\null\vfill\par\vfill\par
    			\parbox[t]{\linewidth}{\large\@publishers} % or company
    		}{}
    		\ifdef{\@date}{
    			\null\vfill\par\vfill\par\vfill\par
    			\parbox[t]{\linewidth}{\large\@date}
    		}{}
    		\ifdef{\@logo}{
    			\null\vfill
    			\null\vfill\par
    			\null\hfill\overlayBR{\@logo}\par
    		}{}
    
    		\null\vfill\null\vfill
    \end{minipage}
    \end{titlepage}
     \if@twoside\cleardoublepage \else \clearpage \fi
    }
    
    
    
    \gdef\cbp@tpMini{\global\toggletrue{samepgTitle}\cbp@FirstPagePlain
    		\gdef\And{\hspace*{3ex}}
    		\vspace*{-2.5cm}
    		{\RaggedRight
    		\hspace*{-10mm}\parbox[t]{\dimeval{0.99\linewidth+9mm}}{\LARGE\bfseries \@title} \hfill {\ifdef{\@logo}{\overlayTR{\LARGE\@logo}}{}} \medskip
    		
    		\ifdef{\@subtitle}{{\itshape\@subtitle}\medskip}{}
    		\ifdef{\@publishers}{{\def\and{\, }\large\@publishers}\smallskip}{}
    		\ifdef{\@author}{{\def\and{\, }\large\bfseries\@author}}{}    \ifdef{\@date}{{\large\@date}}{}   \\\smallskip
    		\ \hfill\llap{\rule{\dimexpr(\linewidth+1.0cm)\relax}{\heavyrulewidth}}\\[-2ex]%
    		\ \hfill\llap{\rule{\dimexpr(\linewidth-0.0pt)\relax}{\lightrulewidth}}\\%
    }
    \vspace*{-0.4cm}
    }
    
    
    
    \def\maketitle{%
    	\iftoggle{samepgTitle}{\iftoggle{useMemo}{\cbp@tpMemo}{\cbp@tpMini}}{\cbp@tpPage}%
    }
    
    


%% packages in folder

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            MarginNotes+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Custom command fpr the margin notes: \myMarginnote{Your Text}
    % Comment on the \lineskiplimit=-\maxdimen:
    % See http://tex.stackexchange.com/questions/49072/
    % Without it the line spacing of the normal text was changed (ugly).
    \newcommand{\myMarginnote}[1]{%
    	\marginnote{% needs marginnote package
    		\ifthispageodd{\RaggedRight}{\RaggedLeft}% needs ragged2e package
    		\color{red}%
    		\lineskiplimit=-\maxdimen% 
    		\normalfont\sffamily\scriptsize%
    		#1}%
    }



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            EndOf+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %\providelength{\floatindentlength}{10ex}
    
    %%% Intentionally blank page command
    \newcommand{\blankpage}{
    \pagebreak
    \thispagestyle{empty}
    \null\vfill
    {\noindent\hspace*{\floatindentlength}\large\slshape This\ page\ intentionally\ left\ blank.\hfill\vspace{5cm}}
    \null\vfill
    \pagebreak
    }
    
    
    %%% End of document command
    \NewDocumentCommand{\printenddocument}{ s O{document}}{%
    \IfBooleanTF{#1}{\vspace*{2.5cm}}{\pagebreak\null\vfill}
    {\noindent\hspace*{\floatindentlength}\large\slshape End\ of\ #2.\hfill\vspace{5cm}}
    \IfBooleanF{#1}{\null\vfill}
    \bookmarksetup{startatroot}  % to reset "End" in pdf bookmark
    \pdfbookmark{End}{End}
    }
    


\usepackage[pl,globals]{penlightplus}
\usepackage{lutabulartools}
\settabular{tbrule,nopad}
\usepackage{autopuncitems}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            YAMLvarsDec+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    \newcommand{\cbpheaderbox}[1]{\parbox[b][2em][b]{0.4\linewidth}{\setstretch{0.8}#1}}
    \usepackage{yamlvars}
    \begin{luacode*}
        YAMLvars.tabmidrule = 'gmidrule'
        function YAMLvars.xfm.headerbox(var, val)
          if var:find('r', 1, true) == 1 then
            val = '\\flushright '.. val
          end
          return '\\cbpheaderbox{'..val..'}'
        end
    \end{luacode*}
    
    
    \begin{luacode*}
        function YAMLvars.prc.setlogo(var, val)
          if type(val) == 'string' then -- if string passed treat as normal
            YAMLvars.prc.setdocvar('logo',val)
          elseif type(val) == 'table' then -- if list then second element is settings for graphics
          if val[2] ~= nil then
              YAMLvars.prc.setdocvar('logoset',val[2])
          end
          YAMLvars.prc.setdocvar('logo',val[1]) -- first element should be path
          end
        end
    \end{luacode*}
    
    \lowercasevarYVon
    %! language = yaml
    \begin{declareYAMLvars}
    title:
      xfm: lb2nl
      prc: setdocvar
    
    subtitle:
      xfm: lb2nl
      prc: setdocvar
    
    author:
      xfm: [list2and,lb2nl]
      prc: setdocvar
    
    company:
      xfm: [list2and,lb2nl]
      prc: setdocvar
    
    date:
      xfm: lb2nl
      prc: setdocvar
    
    logo:
      prc: setlogo
    logo*:
      prc: setdocvar
    logoset:
      prc: setdocvar
      
    institute:  # for beamer, company recommended though
      prc: setdocvar
    
    publishers:  # company recommended
      xfm: [list2and,lb2nl]
      prc: setdocvar
    
    lohead:
      xfm: [lb2nl, headerbox]
      prc: setdocvar
    
    rohead:
      xfm: [lb2nl, headerbox]
      prc: setdocvar
      
    pdf:
      prc: setPDFdata
      
    \end{declareYAMLvars}
    \lowercasevarYVoff


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
    % todo default units would be the next good feature to add
    
    % General Syntax
    % \olay(overlay key-vals)[node or image options]{content}
    %    overlay key-vals generally are
    %       xy=X Y (x-y shift), an=anchor of node, pgan=anchor on page (optional),
    %
    
    \NewDocumentCommand{\olayxfm}{ D(){} }{%  transform the overlay coordinate system
    \tblfrkv{olayxfm}{#1}[defaults={shift=0 0, scale=1 1, pgan=false, lastpgan=false}]%
    \tbldefxy{shift}{olayshift}%   lastpgan is an internal key
    \tbldefxy{scale}{olayscale}%
    }%
    \olayxfm  % blank is set to default, initialize comands
    
    
    % baseline offsets, if you want a marker at top, middle, or bottom (base)
    \def\cbp@olaybaseoffset@t{1.3ex}
    \def\cbp@olaybaseoffset@m{0.7ex}
    \def\cbp@olaybaseoffset@b{0ex}
    
    
    \NewDocumentCommand{\olaysetanchors}{}{% set page and node anchor
      \tblifv{olaykv.pgan}{\tblgdef{olaykv.pgan}{olaypgan}}[\tblgdef{olayxfm.pgan}{olaypgan}]%
      \tblifv{olaykv.an}{}[% if no an set, use the page anchor
        \luadirect{penlight.tbls.olaykv.an = \luastring{\olaypgan}
        if penlight.tbls.olaykv.an == 'false' then
          penlight.tbls.olaykv.an = 'bw'
        end
        }]%
    }
    
    
    \NewDocumentEnvironment{olaytikz}{+b}{% overlay environment
      \unskip\olaysetanchors%
      \begin{tikzpicture}[olay, x=\olayscalex cm, y=\olayscaley  cm]
        \ifdefstring{\olaypgan}{false}%
          {\coordinate (olayorigin) at (0,0);}%
          {\node[inner sep=0pt] (olayorigin) at (current page.\olaypgan){};}%
        \begin{scope}[shift={($ (\olayshiftx cm, \olayshifty cm) + (olayorigin) $)}]
          #1%
        \end{scope}%
      \end{tikzpicture}\luadirect{penlight.tbls.olaykv.pgan = false
                                penlight.tbls.olaykv.an = false
      }\ignorespaces}{}% set an and pgan to false just in case next olay doesnt use this feature
    
    
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
    
    
    
    %%% olay markers
    \NewDocumentCommand{\olaymkgeneric}{m D(){} m}{\unskip% olay marker on the line
      \tblfrkv{olaykv}{#2}[defaults={xy=0 0, an=false, pgan=false}]\tblkvundefcheck%
      \tbldefxy{xy}{olaymk}%
      \begin{olaytikz}
        \node[nosep, minimum size=0pt] (olaymk-#3) at ($(\olaymkx, \olaymky) + (0em, #1)$) {};
      \end{olaytikz}\ignorespaces}
    
    \NewDocumentCommand{\olaymkt}{D(){} m}{\olaymkgeneric{\cbp@olaybaseoffset@t}(#1){#2}}
    \NewDocumentCommand{\olaymkm}{D(){} m}{\olaymkgeneric{\cbp@olaybaseoffset@m}(#1){#2}}
    \NewDocumentCommand{\olaymkb}{D(){} m}{\olaymkgeneric{\cbp@olaybaseoffset@b}(#1){#2}}
    
    \NewDocumentCommand{\olaymkbox}{m}{% todo make a box around markers using node names todo need sep as padding
    \tblfrcsv{olaymks}{#1}\tbldef{olaymks/1}{olaymkA}\tbldef{olaymks/2}{olaymkB}%
    \begin{olaytikz}
      \node[inner sep=0.7ex,draw=red,thick,rounded corners,fit=(olaymk-\olaymkA) (olaymk-\olaymkB)] {};
    \end{olaytikz}}
    
    
    
    
    \NewDocumentCommand{\olay}{D(){} O{} m}{% general overlay of a node \olay[pos kv][tikz node kv]{stuff}
      \tblfrkv{olaykv}{#1}[defaults={xy=0 0, an=false, base=b, pgan=false}]\tblkvundefcheck%
      \tbldefxy{xy}{olaynd}%
      \luadirect{token.set_macro('olaybase',token.get_macro('cbp@olaybaseoffset@'..penlight.tbls.olaykv.base))}% todo should move this somewhere
      \begin{olaytikz}
         \node[anchor=\gettbl{an}, nosep, #2] (tkpgol) at ($(0ex, \olaybase) + (\olayndx, \olayndy)$) {#3};
      \end{olaytikz}%
    }% \tikzpgol{nd=se,pg=se,x=0,y=1}{floating node here}  % example usage
    
    
    \NewDocumentCommand{\olayimg}{D(){} O{} m}{\olay(#1){\includegraphics[#2]{#3}}} % tikz page overlay image/graphics
    
    \NewDocumentCommand{\olaytext}{D(){} O{} m}{%
      \olay(#1)[nosep,align=left,#2]{#3}% todo allow for width to show up in first set of keyword args... need to make a function
    }
    
    
    \NewDocumentCommand{\olaybox}{ O{} D(){} }{% todo allow for comma or space to be separator
      \tblfrcsv{olaykv}{#2}[defaults={an=false, base=b, pgan=false}]% todo allow option for inner sep
      \tbldef{/1}{xxi}\tbldef{/2}{yyi}\tbldef{/3}{xxii}\tbldef{/4}{yyii}%
    \begin{olaytikz}
      \draw[inner sep=0.0ex,draw=red,thick,rounded corners, #1] (\xxi,\yyi) rectangle (\xxii,\yyii);
    \end{olaytikz}}
    
    
    
    
    
    % todo include node settings, or consider overall olaytikz kev-val
    \NewDocumentCommand{\olaycapt}{ D(){} m }{% nd = node text box, ar = arrow,  an = anchor of text box pos, aran = arrow anchor on node, rel = relative text box to arrrow coords
    % ar can be coordinates (separated with space), or false. if false, no arrow is drawn
    \tblfrkv{olaykv}{#1}[defaults={ndxy=0 0, arxy=false, ndan=nw, aran=d, rel=false, pgan=false}]% todo ndan -> an
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
    
    
    
    \NewDocumentCommand{\olaycirc}{ D(){} }{%
    \tblfrkv{olaykv}{#1}[defaults={xy=0 0, r=1, rx=1, ry=1, rot=0, pgan=false, an=false}]\kvtblundefcheck%
    \tbldefxy{xy}{olaykv}%
    \tbldef{r}{olaykvr}%
    \tbldef{rx}{olaykvrx}%
    \tbldef{ry}{olaykvry}%
    \tbldef{rot}{olaykvrot}%
    \begin{olaytikz}\begin{scope}[shift={(\olaykvx,\olaykvy)},xscale=\olaykvrx,yscale=\olaykvry,
      rotate=\olaykvrot]
      \draw[red] (0,0) circle (\olaykvr);
    \end{scope}\end{olaytikz}}
    
    
    
    \NewDocumentCommand{\olaydimen}{ D(){} m }{%
    }% nd = node text box, ar = arrow,  an = anchor of text box pos, aran = arrow anchor on node, rel = relative text box to arrrow coords
    %overlay arrow-tips dimensioning something, with an optional caption
    
    
    
    
    
    
    
    
    
    
    
    % todo use better anchor system
    % specify box anchor , if no arrow anchor passed, assume it is the box anchor
    
    % todo need a dimension thing, sort of a measurement
    
    
    
    
    
    
    
    
    
    
    
    %%%5 legacy, pgan is universal now
    
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
    
    
    
    
    \NewDocumentCommand{\olaypgbox}{m m}{% todo allow for space
      \olayxfm[shift=-2 2]%
      \olaybox{#2}%
      \olayxfm{}%
    }

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            macros/UniRefs+            %%%
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
    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            macros/tweaks+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % This package is designed to help keep track of ``tweaks'' that you add to the document.
    % Any time you add a manual spacing (say vspace, enlargethispage, pagebreak or clearpage), and suppose
    % that you might want to delete/disable at a later time, save after a document revision, this package can help.
    % You could also use this package to track toggle blocks of arbitrary latex code.
    % The main command is \tweak*[id]{code}. * means that the code argument is arbitrary latex code.
    % If no *, a key or key-value is passed and applies code stored in a Lua table
    % options at this time are: en=space (enlarge this page), etc. etc.
    % [id] is an optional, but recommended name you give the tweak. if none is provided, they will be alphabetically assigned, "A", "B", etc.
    % \disabletweaks[csv] will disable selected tweaks, passed as comma-seprated value. If [*] is given, all tweaks are disabled
    % \enabletweaks[csv] (recommended to be used after disable) will re-enable any tweaks
    % \listoftweaks will print a table at the end of your document showing and hyper-linking all tweaks
    % When \listoftweaks is used, a toggle "\toggletrue{showtweakhints}" is activated.
    % you can re-define the two commands to show a "hint" of where the tweak is, for example, using a tikz overlay.
    %    \handleenabledtweakhint{m}
    %    \handledisabledtweakhint{m}
    %   where the argument is the tweak code. You can use \currenttweakname to get the name of the tweak
    
    
    \tblnew{tweakcode}
    \tblnew{tweakorder}
    \tblnew{disabledtweaks}
    \tblnew{enabledtweaks}
    
    \newtoggle{showtweakhints}\togglefalse{showtweakhints}
    
    \NewDocumentCommand{\handleenabledtweakhint}{m}{}
    \NewDocumentCommand{\handledisabledtweakhint}{m}{}
    
    \def\currenttweakname{}
    
    
    \begin{luacode*}
      penlight.disabledalltweaks = false
      penlight.unamedtweakcounter = 0
      penlight.tweak_shortcuts = {
          pg='\\pagebreak{', cl='\\clearpage{', en='\\enlargethispage{',vs='\\vspace*{',hs='\\hspace{'
        }
      
      function penlight.checktweak(p)  -- p is patch names
        return penlight.tablex.listcontains(penlight.tbls.enabledtweaks, p) or
                not(penlight.disabledalltweaks or penlight.tablex.listcontains(penlight.tbls.disabledtweaks, p))
      end
      
      function penlight.make_tweak(tweak)
        local tweak_sc = penlight.stringx.split(tweak,"=")
        tweak_sc[2] = tweak_sc[2] or ''
        local tweak_cmd = penlight.tweak_shortcuts[tweak_sc[1]] or 'ERROR!!! WRONG TWEAK USED {'
        token.set_macro('currenttweakcode', tweak_cmd .. tweak_sc[2]..'}', 'global')
      end
      
      function penlight.set_tweak_cmd(proposed)
      if proposed == '' then
      penlight.unamedtweakcounter = penlight.unamedtweakcounter + 1
        if math.mod(penlight.unamedtweakcounter,26) == 0 then
          penlight.unamedtweakcounter = penlight.unamedtweakcounter + 1
        end
        proposed = ('Z'):rep(math.floor(penlight.unamedtweakcounter/26)) .. penlight.Char(math.mod(penlight.unamedtweakcounter,26))
      end
        token.set_macro('currenttweakname', proposed, 'global')
      end
    \end{luacode*}
    
    
    \NewDocumentCommand{\disabletweaks}{O{*}}{% disable selected tweaks
      \ifstrequal{#1}{*}{\luadirect{penlight.disabledalltweaks = true}\tblnew{enabledtweaks}}{%
      \tblcon{disabledtweaks}{#1}% todo allow for csv input using luakeys!!!
    }}
    
    
    \NewDocumentCommand{\enabletweaks}{O{*}}{% enable only specific tweaks
      \ifstrequal{#1}{*}{\luadirect{penlight.disabledalltweaks = false}\tblnew{disabledtweaks}}{% % delete all disable tweaks and change flag
      \tblcon{enabledtweaks}{#1}%
    }} % recommended to be performed after disable, this will over-write an global or prior disables
    
    
    
    \NewDocumentCommand{\tweak}{s O{} m}{% apply tweak. If * is used, latex code is interpreted as is. If not, shortcuts are used
      \tweaks@makename{#2}%
      \label{tweaks.\currenttweakname}%
      \tblapp{tweakorder}{\currenttweakname}%
      \tbladdN{tweakcode}{\currenttweakname}{#3}%
      \ifluax{penlight.checktweak(\luastring{\currenttweakname})}{%
        \iftoggle{showtweakhints}{\handleenabledtweakhint{#3}}{}%
        \IfBooleanTF{#1}{#3}{\tweaks@makecode{#3}}%
      }[\handledisabledtweakhint{#3}]% TODO add an option on handling tweakhintsif inactive
    }
    %
    
    \NewDocumentCommand{\tweaks@makename}{m}{\luadirect{penlight.set_tweak_cmd(\luastring{#1})}}
    \NewDocumentCommand{\tweaks@makecode}{m}{\luadirect{penlight.make_tweak(\luastring{#1})}\currenttweakcode}
    
    
    
    \NewDocumentCommand{\listoftweaks}{}{% print a ToC-like list of tweaks
      \toggletrue{showtweakhints}%
      \AtEndDocument{\clearpage%
      \section*{List of tweaks}\pdfbookmark{List of tweaks}{List of tweaks}
      \begin{tabularx}{\linewidth}{l l l X}
        ID & Page & Enabled &  Code\\\midrule
      \luadirect{% todo add a filter option for enabled only
      %  pl.wrth(penlight.tbls.tweakorder, 'xyz')
        for _, k in ipairs(penlight.tbls.tweakorder) do
          local is_enabled = tostring(penlight.checktweak(k))
          tex.sprint('\\tweakslistentry{'..k..'}{'..penlight.tbls.tweakcode[k]..'}{'..is_enabled..'}')
        end
      }
      \end{tabularx}
    }
    %%%%%%
    } % this should come after enabling and disabling patches
    
    
    \NewDocumentCommand{\tweakslistentry}{ m m m }{%
      #1 &  \pageref{tweaks.#1} & #3 & \verb|#2|  \\%
    }
    
    
    
    \RenewDocumentCommand{\handleenabledtweakhint}{m}{%
      \olaycapt[ndxy=-3.3 0, ndan=nw]{\parbox{3cm}{\scriptsize\currenttweakname\\\texttt{\detokenize{#1}}}}%
    }
    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            MemoSty+            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% memo variabls
    \lowercasevarYVon
    \begin{declareYAMLvars}
    fileno:
      xfm: lb2nl
      prc: setATvar
      
    attachments:
      xfm: lb2nl
      prc: setATvar
    
    memoheader:
      xfm: lb2nl
      prc: setATvar
    
    memofr:
      xfm: lb2nl
      prc: setATvar
    
    memofraddr:
      xfm: lb2nl
      prc: setATvar
    
    memoto:
      xfm: lb2nl
      prc: setATvar
    
    memotoaddr:
      xfm: lb2nl
      prc: setATvar
    \end{declareYAMLvars}
    \lowercasevarYVoff
    
    % variables do not req declaring beforehand, but here they are for troubleshooting...
      %\@memoto
      %\@memofr
      %\@memofraddr
      %\@memotoaddr
      %\@memoheader
      %\@attachments
      %\@fileno
    
    \newcommand{\@HangingLabel}[1]{\leavevmode\llap{\scriptsize\uppercase{#1}:\enspace\hspace{3pt}}}
    
    
    \gdef\cbp@tpMemo{%
        \vspace*{-4.5em}
        \ifdef{\@memoheader}{\vspace*{-2em}  \ \hfill {\large\bfseries \@memoheader } \hfill \  \\[1.2em]}{}
        \begin{tabularx}{\textwidth}{lXl}
        	\@HangingLabel{to}\textit{\@memoto}  &&
        	      \@HangingLabel{fr}\textit{\@memofr}\\ \noalign{\vskip 0.5mm} % add a bit more space %%% todo need an ifdefOR{\cs1}{\cs2}{}{}
          \makecell[tl]{\@memotoaddr{}}  && \makecell[tl]{\@memofraddr{}} \\
        	\\\noalign{\vskip -1.3ex}
        	\midrule
        \end{tabularx}
        \par
    
        \vspace*{1em}
    
        \parbox{\linewidth}{\setstretch{1.3}
        	\ifdef{\@title}{\@HangingLabel{subject}\raggedright\textbf{\Large\@title}\\[8pt]}{}%
        	\ifdef{\@date}{\@HangingLabel{date}\textbf{\Large\@date}\\[8pt]}{}
        	\ifdef{\@fileno}{\@HangingLabel{file}\textbf{\Large\@fileno}\\[8pt]}{}
        	\ifdef{\@attachments}{\@HangingLabel{attached}\@attachments\\[8pt]}{}
        	\par
        }%
        \cbp@FirstPagePlain
    }
    
    \def\namedatememoheader{%
      \ifdef{\@memoto}{\lohead{\textit\@memoto}}{}%
      \ifdef{\@date}{\rohead{\@date}}{}%
    }
    
    \iftoggle{useMemo}{
    
        \toggletrue{ChapOnSamePage}         %%% PATCH sections
        \addtokomafont{chapter}{\Large}
        \addtokomafont{section}{\large}
        \addtokomafont{subsection}{\normalsize}
    %    \addtokomafont{subsubsection}{\color{black}}  % do not use in a memo
    
        \gdef\scr@section@beforeskip{17.1pt \@plus 1.7pt}
        \gdef\scr@section@afterskip{0.1pt}
        \gdef\scr@subsection@beforeskip{13.1pt \@plus 1.3pt}
    %    \gdef\scr@subsection@afterskip{0.1pt}
      
        
        \KOMAoptions{bibliography=totoc}  % uncomment if you want numbered reference section
        \floatsetup{objectset=raggedright}
        \captionsetup{labelformat=widecap}
    
      \renewcommand{\theequation}{\arabic{equation}}
      \renewcommand{\thetable}{\arabic{table}}
    }{}
    



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
