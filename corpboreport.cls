%%% shortcut to use all format files of
\let\footref\relax % if footref error appears

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{corpboreport}[2021-09-21]

%%% Document Class
\LoadClass[11pt,
letterpaper,
twoside=false,
%twoside,% for two sided doc
open=right,
hidelinks,
parskip=full-,
bibliography=numbered,
numbers=noenddot,
fleqn,
%listof=totoc,% for list of figures, tables
%draft=true,
]{scrartcl}

\RequirePackage{etoolbox}
\newtoggle{samepgTitle}
\newtoggle{useMemo}
\newtoggle{useSerif}
\newtoggle{showListOfFigsTabs}
\newtoggle{samepgListOfFigsTabs}

\newtoggle{SectionOnNewPage}  % todo work this in to the template

\newlength{\pullToCcloser}
\setlength{\pullToCcloser}{-12pt}
\newlength{\moreToCbottom}
\setlength{\moreToCbottom}{2em}


\gdef\TitleLogoPlaceDefault{tl}

\DeclareOption{memo}{\toggletrue{useMemo}}
\DeclareOption{compact}{\toggletrue{samepgTitle}\gdef\TitleLogoPlaceDefault{bl}}
\DeclareOption{serif}{\toggletrue{useSerif}}
\ProcessOptions\relax

%https://github.com/mrpiggi/svg/issues/18
\providecommand*{\Ifstr}{\ifstr}  % little hack that supposed to fix ifstr warning, see https://komascript.de/faq_deprecatedif

\usepackage{ifluatex}
\ifluatex
    \usepackage{luapackageloader}
    \usepackage{luacode}
\else
    \ClassWarning{corpboreport}{You did not use LuaLaTeX to compile, many packages will be skipped and you will lose features}{}
    \usepackage[utf8]{inputenc}  % apparently this can be slow and is loaded by default % https://texfaq.org/FAQ-why-inp-font
\fi



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

%\usepackage{scrextend}  % not to be use with scr classes, but with article,letter etc to provide some koma features


% ####################################################################################
%
% Styling for this document
%
% ####################################################################################

%%%%%%%%%%%%GeometryCustom.sty%%%%%%%%
    % ##############################################
    % Geometry
    % ##############################################
    
    % Check if two-sided https://tex.stackexchange.com/questions/360785/how-do-i-check-if-a-document-is-oneside-or-twoside  %
     % https://tex.stackexchange.com/questions/470752/section-numbers-in-margins-in-double-sided-document
    %preamble
    \if@twoside% if two-sided, put the section headings to right side and numbers in right margin 
    	\usepackage[
    		top=1.25in,
    		headheight=2em, % 17pt as per the warning by fancyhdr 17pt = about 0.6cm
    		headsep=0.25in,  % about 1.25 * 13.7 (baseline skip),
    		footskip=0.01pt,
    		bottom=1.125in,
    		bindingoffset=0.5in,
    		left=1.25in,%1.125in,
    		right=1.25in%,1.125in,
    		%showframe=true,
    	]{geometry} 
    \else%
    \usepackage[
    		top=1.25in,
    		headheight=2em,
    		headsep=0.25in,  % about 1.25 * 13.7 (baseline skip),
    		footskip=0.01pt,
    		bottom=1.25in, % 1.125
    		bindingoffset=0.0in,
    		left=1.375in,%1.25in,%1.125in,
    		right=1.375in,%1.25in%,1.125in,
    		%showframe=true,
    	]{geometry}
    \fi%  finally do nothing
    
    %%% https://ctan.math.illinois.edu/macros/latex/contrib/geometry/geometry.pdf
    %%% Logic: want header and footer space that is larger than the margin width
    %%% approximately fit a mini page (of same ratio) in the corners and touch the text
    %%% I take the footer in the margin so that I can lengthen a page to squeeze in material where needed
    %%%

%%%%%%%%%%%%Utilities.sty%%%%%%%%
    % ##############################################
    % Utilities (tools to help with scripting, automating etc.)
    % ##############################################
    
    \usepackage{etoolbox} %
    
    \usepackage{xparse} % smart definition of commands
    \usepackage{pdftexcmds}  % string comparison with expanded input args
    \usepackage{xpatch}  %add to e toolbox pre, app, etc. to command or environments, https://ctan.math.illinois.edu/macros/latex/contrib/xpatch/xpatch.pdf
    
    \usepackage{calc}  % allows us to use expressions like {\linewidth-2ex} in commands
    \usepackage{xfp}  % floating point math
    \usepackage{xspace}  % smartly looks at space after commands
    
    \usepackage{catchfile} % catches a .tex file as a command
    
    %%% pdf stuff
    \usepackage{pdflscape}
    \usepackage{pdfpages}  % provides \includepdf command
    \usepackage{grffile}  % removes the pdf file name for includegraphics with a pdf file type
    \usepackage{afterpage} % can add code after page done, helps with pdflscape with inserting a page randomly,
    
    %% Boxes and stuff
    \usepackage[usestackEOL]{stackengine}  % used for title page and stacking things
    \usepackage{setspace}  % enable onehalfspacing instyling
    
    \usepackage{pbox}  % create box of max width http://ctan.mirror.colo-serv.net/macros/latex/contrib/pbox/pbox.pdf
    \usepackage[export]{adjustbox} % provide additional commands for graphicsx allows us to adjust graphics,  http://mirrors.ibiblio.org/CTAN/macros/latex/contrib/adjustbox/adjustbox.pdf
    \usepackage{relsize}  % relative sizing
    
    \newtoggle{csdefined}
    
    
    \newcommand{\ifdefOR}[4]{%
    \togglefalse{csdefined}%
    \ifdef{#1}{\toggletrue{csdefined}}{}%
    \ifdef{#2}{\toggletrue{csdefined}}{}%
        \iftoggle{csdefined}{#3}{#4}%
    }
    
    
    \newcommand{\invtoggle}[1]{% invert a toggle
    \iftoggle{#1}{\togglefalse{#1}}{\toggletrue{#1}}%
    }
    
    \newcommand{\gettogglestate}[1]{% get a toggles state
    \iftoggle{#1}{true}{false}%
    }
    
    
    
    \let\strcmp\pdf@strcmp
    
    \NewDocumentCommand{\ifstringeqx}{m m m O{}}{%
        \ifnum\strcmp{#1}{#2}=0 #3\else#4\fi%
    }
    
    \NewDocumentCommand{\DoIfnotEmpty}{m m O{}}{%
        \ifstringeqx{#1}{}{#2}{#3}%
    }
    %\NewDocumentCommand{\DoIfnotEmpty}{m m O{}}{\ifthenelse{\equal{#1}{}}{#3}{#2}}
    
    % requires ifthen package, does #2 if #1 is NOT empty, othwerise (optionally) do #3 can take command inputs
    \newcommand{\DoWithoutPrinting}[1]{\setbox0\vbox{#1}} % https://tex.stackexchange.com/questions/417327/is-it-possible-to-compile-but-not-showing-a-part
    
    \newcommand{\DontDo}[1]{} %command that does nothing
    
    
    \newcommand*\makealph[1]{\symbol{\numexpr96+#1}}% also can use \numexpr`a-1+#1
    \newcommand*\makeAlph[1]{\symbol{\numexpr64+#1}}
    
    
    %% x parse pre-processor, expands an argument, use by putting >{\ExpArgOnceProc} in front of arg spec
    % https://tex.stackexchange.com/questions/616804/using-definitions-for-key-val-arguments/616814#616814
    \newcommand\ExpArgOnceProc[1]
      {\edef\ProcessedArgument{\unexpanded\expandafter{#1}}}
    
    
    \NewDocumentCommand{\providelength}{ m m }{%
    \ifdeflength{#1}{% It is already defined!
    }{% Not defined, so define it!
    \newlength{#1}%
    \setlength{#1}{#2}
    }%
    }%
    
    
    
    
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

%%%%%%%%%%%%FontAndParas.sty%%%%%%%%
    % ##############################################
    % Text Settings
    % ##############################################
    
    
    \usepackage[english]{babel} % helps with hyphenation
    \usepackage{csquotes} % helps with hyphenation
    
    
    %%% GENERAL FORMATTING
    \usepackage{ragged2e}
    \usepackage{blindtext}
    
    \iftoggle{useSerif}{
        \usepackage[T1]{fontenc}
        %frenchstyle,narrowiints,partialup < math settings for kp fonts
        \usepackage[light,notextcomp]{kpfonts} % the light is also decent, could consider
        \renewcommand{\ttdefault}{cmtl} % monospace that looks nice with light kpfont
        \usepackage[activate=true,% this package makes the font look nicer
            final,%
            tracking=true,%
        %	kerning=true, % only works with pdftex
        ]{microtype}
        \SetTracking{encoding=*, shape=sc}{18}  % adjust small caps letter spacing
    }{
        \ifluatex
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
                %kerning=true,  $ NOT ALLOWED IN LUA
                %spacing=true,  $ NOW ALLOWED IN LUA
                letterspace=120,
                factor=1000,% protrusion (/1000), subtle
                stretch=10,%(/1000 %)
                shrink=10]{microtype}
                \frenchspacing
        \else
            %\usepackage{microtype}  % helps with hyphen and scaling,
            % NOT SURE IF THIS DOES ANYTHING.. BUT ITS SUPPOSED TO
            \usepackage[T1]{fontenc}  % used for accented letter, OT1 works better with cmbright
            \let\CMserif\rmdefault % save the default family name
            \usepackage{cmbright}  % use hfbright and cm-super
            \renewcommand\bfdefault{sb}
            \newcommand\sbdefault{bx}
            \usepackage[%
            protrusion=true,
            expansion,
            final,
            tracking=true,
            kerning=true,
            spacing=true,
            letterspace=120,
            factor=1000,% protrusion (/1000), subtle
            stretch=10,%(/1000 %)
            shrink=10]{microtype}
        \fi
    %    https://comp.text.tex.narkive.com/KZW4PwZ4/cmbright-alternative
        \gdef\sbseries{\fontseries{sb}\selectfont}
    }
    
    
    %%% PAGE STYLING
    \usepackage{lastpage}
    
    %%% MARGIN NOTES
    %\usepackage{marginnote}  % better margin notes with koma script, apparently % CTAN: http://www.ctan.org/pkg/marginnote
    
    
    \let\oldcenter\center
    \let\oldendcenter\endcenter
    \renewenvironment{center}{\setlength\topsep{0pt}\oldcenter}{\oldendcenter}  % removes extra sep
    
    \let\oldflushleft\flushleft
    \let\oldendflushleft\endflushleft
    \renewenvironment{flushleft}{\setlength\topsep{0pt}\oldflushleft}{\oldendflushleft}
    
    
    
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
    
    
    
    


%%%%%%%%%%%%HeaderFooterFootnotes.sty%%%%%%%%
    % ##############################################
    % Header and Footer
    % ##############################################
    
    %% NOTE: should adjust top margin height in GeometryCustom depending on number of lines
    
    \addtokomafont{pageheadfoot}{\upshape}
    
    \lohead{set me with lohead command}
    \rohead{set me with rohead command}
    
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
    
    
    %
    %  Footnotes
    %
    \usepackage{footnotebackref}  % must be loaded before footnote backref
    \usepackage{footmisc}  %
    \setlength\footnotemargin{0pt}  % space between footnote and number.. might want to experiemnt with this
    % and will likely want to re-create my tabular footnote environment...
    
    \KOMAoptions{footnotes=multiple}% maybe you want to use this option?  # doesn't seem to do anything
    \setfootnoterule{0.5\textwidth}
    \newcommand*\footnotemarkspace{0.0ex} % set distance of the footnote text from the margin
    \deffootnote{\footnotemarkspace}% use distance from above
    {0em}% paragraph indent in footnotes (footnotes should never have paragraphs!)
    % allows for back-references footnotes
    % can put a llap before \textsuper to have a hanging footnote!
    {\makebox[\footnotemarkspace][l]{\llap{{\hyperref[\BackrefFootnoteTag]{\thefootnotemark}}}}.\enspace} % footfont with period for footnote marks in footnote
    % hanging footnote
    
    
    %footnotebackref breaks footnotetext and footnotemark pairs, this patches it up!!!
    
    \LetLtxMacro{\BHFN@Old@footnotemark}{\@footnotemark}
    \renewcommand*{\@footnotemark}{%
    	\refstepcounter{BackrefHyperFootnoteCounter}%
    	\xdef\BackrefFootnoteTag{bhfn:\theBackrefHyperFootnoteCounter}%
    	\label{\BackrefFootnoteTag}%
    	\BHFN@Old@footnotemark
    }
    
    
    %{\makebox[\footnotemarkspace][l]{\llap{{\hyperref[\BackrefFootnoteTag]{\thefootnotemark}}}}.\enspace} % footfont with period for footnote marks in footnote
    % https://tex.stackexchange.com/questions/339506/right-align-one-and-two-digit-footnote-marks-with-koma


%%%%%%%%%%%%PageNumberInMargin.sty%%%%%%%%
    %%% DEPENDENCIES
    % KOMA-Script class
    %%%
    
    %%%%%%% IN ACTUAL FOOTER (WITH VERTICAL LINE RUNNING TO BOTTOM)
    %%%%%
    \newlength{\raiseFooterLen}
    \setlength{\raiseFooterLen}{-0.5\baselineskip}
    \newlength{\lineFooterLen}
    \setlength{\lineFooterLen}{2em}
    %https://tex.stackexchange.com/questions/114570/koma-script-scrpage2-footer-height
    
    
    
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
    


%%%%%%%%%%%%SectionsToCCustom.sty%%%%%%%%
    % ##############################################
    % Section Headings
    % ##############################################
    
    %%% DEPENDENCIES
    % KOMA-Script class
    \usepackage{xcolor}
    % ColorsCustom.sty
    \usepackage{xpatch}
    %%%
    
    
    
    % ##############################################
    % Table of Contents
    % ##############################################
    
    %%% DEPENDENCIES
    % KOMA script class
    %%%
    
    %% ADJUST
    % todo consider switching to latex
    
    %%% EXTRA SPACE BEFORE SECTION AND START ON NEW PAGE
    
    \RequirePackage{etoolbox}
    
    \providetoggle{SecOnNewPage} %% only need one toggle
    \toggletrue{SecOnNewPage}
    
    
    \providetoggle{showListOfFigsTabs}
    \providetoggle{samepgListOfFigsTabs}
    \toggletrue{samepgListOfFigsTabs}
    
    
    
    \newdimen\tocsecskip  %%% todo rename this
    \tocsecskip=0.75em  % fit ToC as required
    
    \newdimen\tocsubsecwidth
    \newdimen\tocsubsubsecwidth
    
    \newdimen\tocsubindent  % should auto adjust
    \newdimen\tocsubsubindent  % should auto adjust
    
    \tocsubsecwidth=4.4ex   % adjust this as needed. 4.6 is  good with single digit sections and no letter
    \tocsubsubsecwidth=6.0ex   % adjust this as needed. 6.5 is  good with single digit sections and no letter (small size)
    
    \tocsubsubindent=0ex
    \addtolength{\tocsubsubindent}{\tocsubsecwidth}
    \addtolength{\tocsubsubindent}{4pt}  % correction to account for small vs medium size
    
    
    % diamond leaders.. staggered dots
    \countdef\counter=255
    \def\diamondleaders{\global\advance\counter by 1
    	\ifodd\counter \kern-10pt \fi
    	\leaders\hbox to 20pt{\ifodd\counter \kern13pt \else\kern3pt \fi
    		.\hss}\hfil}
    
    
    % Hanging section
    %https://tex.stackexchange.com/questions/381261/right-align-chapter-numbering-in-koma-script-toc?rq=1
    \newcommand\sectionentrynumberformat[1]{% define the new format for the chapter numbers in ToC
    	% \renewcommand\autodot{.}% dot after chapter
    	\hfill\smaller#1\enspace\hspace{1pt}% align chapter numbers right
    }
    
    
    % SECTION SPACING ON PAPER AND ToC - should change if section lettering is used
    % determine if you should use baselineskip or not...
    
    \RedeclareSectionCommand[beforeskip=21.pt plus 2.1pt,
    afterskip=0.01pt,
    %tocnumsep=1.5ex,
    %tocdynnumwidth=switch,
    tocindent=-4.3ex,
    tocnumwidth=4ex,
     tocbeforeskip=\tocsecskip,
    tocentryformat=\large\bfseries,
    tocentrynumberformat=\sectionentrynumberformat,
    ]{section}%
    %
    \RedeclareSectionCommand[beforeskip=17.1pt plus 1.71pt,  % 1.25 * 13.7 (baseline)
    toclinefill=\diamondleaders,
    afterskip=0.01pt,
    tocindent=0pt,
    tocbeforeskip=1pt,
    tocnumwidth=\tocsubsecwidth,
    tocentryformat=\normalsize,
    tocentrynumberformat=\smaller,
    ]{subsection}%
    %
    \RedeclareSectionCommand[beforeskip=13.7pt plus 1.37pt,
    toclinefill=\diamondleaders,
    afterskip=0.01pt,
    tocindent=\tocsubsecwidth,
    tocnumwidth=\tocsubsubsecwidth,
    tocentryformat=\small,
    tocentrynumberformat=\smaller,
    ]{subsubsection}
    
    \RedeclareSectionCommand[beforeskip=3.01pt,
    afterskip=-4ex,
    ]{paragraph}
    
    
    %%% if using list of tables and figures
    \DeclareTOCStyleEntry[%
    linefill=\diamondleaders,
    indent=0pt,
    numwidth=\tocsubsecwidth,
    entryformat=\normalsize,
    entrynumberformat=\smaller,
    ]{tocline}{table}
    
    
    \DeclareTOCStyleEntry[%
    linefill=\diamondleaders,
    indent=0pt,
    numwidth=\tocsubsecwidth,
    entryformat=\normalsize,
    entrynumberformat=\smaller,
    ]{tocline}{figure}
    
    %%%  How to use in document:
    %    \listoffigures
    %\renewcommand{\SecOnNewPage}{no}  % only if you want these on the same page...
    %    \listoftables
    %\renewcommand{\SecOnNewPage}{yes}
    
    
    \setkomafont{disposition}{\normalfont\bfseries} % section preference
    
    
    
    
    
    \if@twoside% if two-sided, put the section headings to right side and numbers in right margin
    	\raggedbottom
    \fi%  finally do nothing
    	\raggedbottom
    
    
    
    
    %%% SECTION NUMBERS IN MARGIN OF PAGE, for two sided documents
    % Check if two-sided https://tex.stackexchange.com/questions/360785/how-do-i-check-if-a-document-is-oneside-or-twoside  %
    %%% for flipped sections heads, kind of ugly
    %\makeatletter % https://tex.stackexchange.com/questions/470752/section-numbers-in-margins-in-double-sided-document
    %%preamble
    %\if@twoside% if two-sided, put the section headings to right side and numbers in right margin
    %\renewcommand\sectionlinesformat[4]{%  for section numbers in right margin for a two sided document
    %	\ifthispageodd
    %	{\raggedleft#4\makebox[0pt][l]{\hspace{\marginparsep}\smaller#3}}
    %	{\raggedright\makebox[0pt][r]{\smaller#3\hspace{\marginparsep}}#4}%
    %}
    %%\newcommand\side{stuff for twoside} %todo reconsider if this is needed
    %\else% if not two sided, only apply to one sided
    %\renewcommand\sectionlinesformat[4]{% used by free-standing headings with style=section
    %	\makebox[0pt][r]{\smaller#3}#4%  puts section number in margin
    %}	%\newcommand\side{stuff for onside} %todo reconsider if this is needed
    %\fi%  finally do nothing
    %\makeatother
    
    
    \renewcommand\sectionlinesformat[4]{% used by free-standing headings with style=section
    	\makebox[0pt][r]{\smaller#3\hspace{3pt}}#4%  puts section number in margin
    }
    
    %%% SECTION NUMBER SPACING:
    % \renewcommand*\sectionformat{\thesection\autodot\hspace{5mm}} % maybe 14pt enspace?
    
    
    %%% SECTION NUMBER AND HEADING COLOR CHANGE
    %\addtokomafont{chapter}{\color{secCol}}
    
    \addtokomafont{section}{\color{secCol}}
    \addtokomafont{subsection}{\color{subsecCol}}
    \addtokomafont{subsubsection}{\color{subsubsecCol}}
    
    
    
    \let\oldsection\section
    \RenewDocumentCommand{\section}{ s t! o m }{% add ! option for paragraph to allow section on the same page instead of new (can reverse this behavior as shown above)
    %    \IfBooleanTF{#2}{\let\SecOnNewPage\SecOnNewPageDefaultAnti }{\let\SecOnNewPage\SecOnNewPageDefault }
        \IfBooleanT{#2}{\invtoggle{SecOnNewPage}}
        \expanded{%
            \noexpand\oldsection
            \IfBooleanT{#1}{*}%
            \IfValueT{#3}{\unexpanded{[#3]}}%
            \unexpanded{{#4}}%
        }%
        \IfBooleanT{#2}{\invtoggle{SecOnNewPage}}
    }
    
    \newdimen\sectprespacelength
    \sectprespacelength=-20pt  % make less negative to increase spacing on new section title (always starts new page)
    \xpretocmd\sectionlinesformat
    {\ifstr{#1}{section}{%
        \iftoggle{SecOnNewPage}{\clearpage\vspace*{\sectprespacelength}}{}%
    }{}}  % THIS IS AUTOMATICALLY CHANGED IN APPENDIX
    {}{\PatchFailed}
    
    %{\ifstr{#1}{section}{\ifdefstring{\SecOnNewPage}{yes}{\clearpage\vspace*{\sectprespacelength}}{}}{}}  % THIS IS AUTOMATICALLY CHANGED IN APPENDIX
    
    
    \let\oldparagraph\paragraph
    %
    \RenewDocumentCommand\paragraph{ s t! o m }{% add ! option for paragraph to allow header on its own line
        \edef\scr@paragraph@afterskip {%
            \IfBooleanTF{#2}{0.1pt}{-4ex}%
        }%
        \expanded{%
            \noexpand\oldparagraph
                \IfBooleanT{#1}{*}%
                \IfValueT{#3}{\unexpanded{[#3]}}%
                \unexpanded{{#4}}%
        }%
    }
    %
    
    %\newcommand{\se}{def}
    
    %%%% FOR BLANK PAGE ON LEFT SIDE WHEN NEW SECTION STARTS:
    %\newcommand{\IntentBlank}{\vspace*{\fill}
    %	{\noindent\large\centering This Page Intentionally Left Blank \\[5cm]}
    %	\vspace*{\fill}}
    	%%% https://tex.stackexchange.com/questions/102451/have-cleardoublepage-working-in-oneside-scrreprt
    %\newcommand\cleartooddpage{\clearpage
    %	\ifodd\value{page}\else\null\IntentBlank\clearpage\fi}
    %\let\secSame\section  % section on same page 
    %\pretocmd{\section}{\cleartooddpage}{}{}
    
    
    %%% USED IN SCRBOOK AND SCRREPRT
    %\renewcommand*\othersectionlevelsformat[3]{%
    %	\llap{#3\autodot\enskip}%
    %}
    %\renewcommand*{\chapterformat}{%
    %	{\fontsize{20}{30}\scshape\chapappifchapterprefix{}}%
    %	\fontsize{120}{30}\selectfont\rlap{\thechapter\autodot}%
    %}
    
    


%%%%%%%%%%%%AppendixFormat.sty%%%%%%%%
    % ##############################################
    % Appendix Formatting
    % ##############################################
    
    %%% DEPENDENCIES
    % KOMA-script class
    % ToC.sty (for ToC skip)
    
    \providecommand*\appendixname{Appendix}
    \let\originalappendix\appendix
    
    \renewcommand\appendix{%
    	\originalappendix
    	% NOTE you cannot use the alphabetized subsections anymore
    	%
    	\def\thesubsection{\Alph{section}.\arabic{subsection}}  % restore subsection behaviour (I change it with macro seclettering)
    	\def\theHsubsection{\Alph{section}.\arabic{subsection}}
    	\def\thesubsubsection{\Alph{section}.\arabic{subsection}.\arabic{subsubsection}}
    	\def\theHsubsubsection{\Alph{section}.\arabic{subsection}.\arabic{subsubsection}}
    	%
    	\crefalias{section}{appsec}
    	%
    	\renewcommand\sectionformat{\appendixname~\thesection\autodot}
    	\renewcommand\sectionlinesformat[4]{%
    		\ifstr{##1}{section}
    		{\clearpage\vspace*{\sectprespacelength}##3\\*##4}% appendix sections on new page
    		{\makebox[0pt][r]{\smaller##3}{##4}}% subsections etc.
    	}%
    	\renewcommand\addsectiontocentry[2]{%
    		\addtocentrydefault{appendixsection}{##1}{##2}%
    	}%
    }
    
    
    \DeclareTOCStyleEntry[
    level=\sectiontocdepth,
    indent=0pt,
    numwidth=2ex,  % does not matter
    dynnumwidth,
    numsep=1.4ex, % uses numsep, but regular entries use numwidth.. might need to adjust
    entrynumberformat=\entrywithprefix{\appendixname},
    entryformat=\large\bfseries,
    beforeskip=\tocsecskip,
    ]{section}{appendixsection}
    
    \newcommand\entrywithprefix[2]{#1~#2}
    
    
    
    % for lettering, could be used for assignment template, type this \def\thesubsection{\arabic{section} (\alph{subsection})}
    


%%%%%%%%%%%%ColorsCustom.sty%%%%%%%%
    % ##############################################
    % Custom Colors
    % ##############################################
    
    \usepackage{xcolor}
    
    % todo confirm with xckd colors
    % https://xkcd.com/color/rgb/
    
    % make a consistent color set with mpl "rich colors"
    % define shades of gray to mtach
    
    
    %\definecolor{lightgray}{RGB}{216, 220, 214}
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


%%%%%%%%%%%%MathSymbolsEtc.sty%%%%%%%%
    % ##############################################
    % Math related packages and settings
    % ##############################################
    
    % rename to MathSciSymbols
    
    \usepackage{amssymb,amsmath,amsfonts,gensymb}  % math fonts and symbols
    \usepackage{xfrac}
    
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
    


%%%%%%%%%%%%Lists.sty%%%%%%%%
    % ##############################################
    % Lists
    % ##############################################
    
    % to change more: https://texblog.org/2008/10/16/lists-enumerate-itemize-description-and-how-to-change-them/
    
    %%% DEPENDENCIES
    
    \usepackage{enumitem} % https://muug.ca/mirror/ctan/macros/latex/contrib/enumitem/enumitem.pdf
    \usepackage{multicol}  % used for two column list
    %\usepackage{tabto}% possibly usful for two column lists %http://tug.ctan.org/tex-archive/macros/latex/contrib/tabto/tabto-doc.pdf
    %%%
    
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


%%%%%%%%%%%%Tables.sty%%%%%%%%
    % ##############################################
    % Tables
    % ##############################################
    
    %%% DEPENDENCIES
    % KOMA-Script class
    \usepackage{xparse}
    %\usepackage{siunitx} % see MathSymbolsEtc for usage, dont use as settings are changed
    \usepackage{xcolor}
    % ColorsCustom.sty
    % Macros
    %%%
    
    % How to make nice tables: https://inf.ethz.ch/personal/markusp/teaching/guides/guide-tables.pdf
    
    %%% TABLES
    \usepackage{array}
    \usepackage{multirow}
    \usepackage{makecell}
    \usepackage{colortbl} %
    \usepackage{rotating}
    
    \usepackage{tabularx}  % WARNING  supposed to be loaded after hyprref !!! investigate
    \usepackage{ltxtable}  % long table with tabularx
    \usepackage{longtable}
    
    \usepackage{booktabs}  % better for tables without vertical rules.
    % http://ctan.mirror.globo.tech/macros/latex/contrib/booktabs/booktabs.pdf
    
    % Table spacing
    %\renewcommand{\arraystretch}{1.0}  % normal table stretch.. can modify
    %\setlength\tabcolsep{2ex}  % additional padding on sides of tables
    
    \newcommand{\todash}{{\hspace{1.5ex}to\hspace{1.5ex}}} % used for tables with X ' to ' Y
    \setlength\heavyrulewidth{0.8pt}
    \setlength\lightrulewidth{0.4pt}  % latex default rule is 0.4 pt
    
    %% gmidrule now in lutabulartools
    
    
    
    
    
    \newcolumntype{P}[1]{>{\centering\arraybackslash}p{#1}}  % horizontally centered P column
    \newcolumntype{M}[1]{>{\centering\arraybackslash}m{#1}}  % vertically/horizontally centered column (might not need(
    \newcolumntype{Y}{>{\centering\arraybackslash}X} % centered tabular X 
    
    \newcolumntype{Z}{>{\raggedright\arraybackslash}X}  % ragged right , todo is this needed?
    
    
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
    \newcommand{\tnote}[1]{\textsuperscript{#1}} % use tnote{a} in the table, and \tfnote{a}Note here in the foot notes
    
    \newcommand{\atfnote}[1]{\tfnote{\uref{#1}}} % automatic table footnote
    \newcommand{\atnote}[1]{\tnote{\uref{#1}}} % automatic table footnote


%%%%%%%%%%%%FloatsCaptions.sty%%%%%%%%
    % ##############################################
    % Floats and Captions   (plus pbox and and adjustbox)
    % ##############################################
    
    \newlength{\floatindentlength}
    \setlength{\floatindentlength}{10ex}
    \newcommand{\FloatIndent}{\hspace*{\floatindentlength}}
    
    %%% DEPENDENCIES
    % KOMA-Script class
    \usepackage{xparse}
    \usepackage{afterpage}
    %%%
    
    \usepackage{graphicx}
    \graphicspath{{images/}}  % might want to use this and subfiles
    \usepackage{graphbox}  %% allows smash command for easier graphics placement
    
    \usepackage[%
    skip=3pt,%
    labelfont={bf},%
    justification=raggedright,
    %	singlelinecheck=on,%
    singlelinecheck=false,  % switch these to change centering
    format=hang,%
    figureposition=bottom,  % warning says does nothing with KOMA class
    tableposition=top%         but
    ]{caption} %
    
    
    \usepackage{floatrow}% http://tug.ctan.org/tex-archive/macros/latex/contrib/floatrow/floatrow.pdf  (dont use float pack)
    % patch below to not affect color after footnote
    
    \renewcommand\FB@putfoots{%
      \ifvoid\flrow@foot\else\FR@ifFOOT
        {\vskip\floatfootskip\color@begingroup\normalcolor
        \unvbox\flrow@foot\@@par\color@endgroup}\relax
      \fi}
    
    
    \usepackage{subcaption} % http://mirrors.ibiblio.org/CTAN/macros/latex/contrib/caption/subcaption.pdf
    
    % todo work on a left indent style of figure, wide and narrow.
    %\DeclareCaptionLabelFormat{capfmt}{\llap{\makebox[10ex][l]{#1\enspace#2}}}  % same width as indent, but pushed to the left
    %\captionsetup{labelformat=capfmt,labelsep=none}
    % todo
    \DeclareCaptionLabelFormat{capfmt}{\llap{#1 #2:\ }}
    \DeclareCaptionLabelFormat{default}{#1 #2}
    \captionsetup{labelformat=capfmt}
    \newcommand{\WideFloatCaption}{\captionsetup{labelformat=default}}
    
    
    
    
    %raggedright
    %RaggedRight
    
    % todo decide if you wanna go small for table... this is a big consideration % todo if small, must change your margin indent
    \floatsetup[table]{captionskip=3pt, capposition=top} %	 http://tug.ctan.org/tex-archive/macros/latex/contrib/floatrow/floatrow.pdf
    %\floatsetup[table]{captionskip=3pt, capposition=top, font=small} %	 http://tug.ctan.org/tex-archive/macros/latex/contrib/floatrow/floatrow.pdf
    \floatsetup[figure]{captionskip=5pt}  % use small font for tables (note that tabular note affected)
    % todo
    % two types of floats, narrow ad wide
    % if narrow, align caption label with left margin,
    % if float is too wide, it can pass under the label
    % maybe some hfil witchcraft?
    % I dont like centering, it breaks the flow
    % kind of need two
    \DeclareMarginSet{indented}{\setfloatmargins{\FloatIndent}{\hfil}} % pg 60 http://ctan.mirror.rafal.ca/macros/latex/contrib/floatrow/floatrow.pdf
    
    \floatsetup{justification=raggedright,objectset=raggedright,margins=indented}
    %\floatsetup{margins=raggedright}
    % todo
    \captionsetup[sub]{skip=8pt, aboveskip=5pt, font=small, labelfont={small,bf}, position=top}  % formats \subcaptionbox
    \setlength{\intextsep}{17pt}  % distance between floats on the top or the bottom and the text, baseline skip plus some
    \setlength{\floatsep}{24pt plus 2.0pt minus 2.0pt} % distance between two floats; add rubber here
    \setlength{\textfloatsep}{24pt plus 2.0pt minus 2.0pt} % distance between floats inserted inside the page text (using h) and the text proper, add rubber here
    
    
    
    % create an empty box that's the same size as of an image
    % useful for subfloats when you have an odd sized image and want to align
    \newlength{\imagewidth}% variable
    \newlength{\imageheight}%
    \NewDocumentCommand{\BoxSameSizeImg}{O{t} O{t} m m}{%
    	\settowidth{\imagewidth}{\includegraphics{#3}}% gets the width
    	\settoheight{\imageheight}{\includegraphics{#3}}%
    	\begin{minipage}[#1][\imageheight{}][#2]{\imagewidth{}}% create a mini page
    		#4%
    	\end{minipage}%
    }
    
    % maximum width, for graphics, or example, graphic that wont exceed margin: [width=\maxwidth{\linewidth}]
    
    \def\maxwidth#1{\ifdim\Gin@nat@width>#1 #1\else\Gin@nat@width\fi}
    
    
    
    
    \NewDocumentCommand{\RotPDF}{t+ s}{\IfBooleanT{#1}{\pagebreak}%
            \IfBooleanTF{#2}{\global\pdfpageattr\expandafter{\the\pdfpageattr/Rotate 0}}%
                            {\global\pdfpageattr\expandafter{\the\pdfpageattr/Rotate 90}}%
    } %%% + will add a page break before, * will restore it back to normal
    
    
    
    \newcommand{\RotFloatPage}[1]{% if a float takes up the whole page, just insert the float after the page, rotate, then restore
    	\afterpage{\RotPDF#1
    	\RotPDF+*}
    }
    \newcommand{\FloatNextPage}[1]{% if a float takes up the whole page
    	\afterpage{#1}
    }
    
    
    
    
    
    % Numbering for figures/tables as per section
    %\numberwithin{figure}{section}  % fig 4.1, 4.2, etc.
    %\numberwithin{table}{section}
    
    
    
    
    %     1      2         3           4         5            6            7         8
    %  *wide,  +just cap  [pos]  <pre-amble>  {content}  {caption} [short caption] {label}
    \NewDocumentCommand{\InsertFigure}{s t+ O{htbp} D<>{} m +m O{#6} m}{%
    	\IfBooleanT{#1}{\floatsetup{margins=raggedright}}% if star after command
    	\begin{figure}[#3]%
    		\IfBooleanT{#2}{\captionsetup{justification=justified}}%
    		#4% preamble
    		\IfBooleanTF{#1}% if star after command
    			{\captionsetup{labelformat=default}\caption[#7]{#6}#8}% pushes the label left aligned
    			{\ffigbox[\FBwidth]{\caption[#7]{#6}#8}}%%% use hanging label, make a box around graphic
    		{#5}%  includegraphics here
    	\end{figure}%
    	\floatsetup{margins=indented}%
    }%
    
    
    
    %     1      2         3           4         5            6            7      8
    %  *wide   +justified  [pos]  <pre-amble>  {content}  {caption} [short caption] {label}   [footnotes]
    %
    %    todo: should clean up the code and captionset
    %
    \NewDocumentCommand{\InsertTable}{ s t+ O{htbp} D<>{} m +m O{#6} m o }{%
    	\begin{table}[#3]% htbp! settings
    		#4% pre-amble
    		\IfBooleanT{#2}{\captionsetup{justification=justified}}%
    		\IfBooleanTF{#1}{% if star use the wide format
    		 	\captionsetup{labelformat=default,margin={0pt,-1\floatindentlength}}\floatsetup{margins=raggedright}%
    			\RawCaption{\caption[#7]{#6}#8}% caption outside ttbabbox, and freed from float width
    			\captionsetup{labelformat=default,margin=0pt}% restore margin
    			\ttabbox{}{#5\IfValueT{#9}{\vspace{\TabNoteSpace}\floatfoot*{#9}}}% if no star then use hanging
    		}{% if not, use the hanging style
    			\ttabbox{\caption[#7]{#6}#8}{#5\IfValueT{#9}{\vspace{\TabNoteSpace}\floatfoot*{#9}}}% if no star then use hanging
    		}%
    	\end{table}%
    }
    
    
    
    
    %
    %\NewDocumentCommand{\InsertTable}{ s O{htbp} D<>{} m m O{#5} m O{} }{%
    %	\begin{table}[#2]% htbp! settings
    %		#3% pre-amble
    %		\IfBooleanTF{#1}{% if star use the wide format
    %		 	\floatsetup{margins=raggedright}\captionsetup{labelformat=default,margin={0pt,-10ex}}%
    %			\RawCaption{\caption[#6]{#5}}#7% caption outside ttbabbox, and freed from float width
    %			\ttabbox{}{#4\DoIfnotEmpty{#8}{\vspace{\TabNoteSpace}{\floatfoot*{#8}\hspace{10ex}}}}% if no star then use hanging
    %		}{% if not, use the hanging style
    %			\ttabbox{\caption[#6]{#5}#7}{#4\DoIfnotEmpty{#8}{\vspace{\TabNoteSpace}\floatfoot*{#8}}}% if no star then use hanging
    %		}%
    %	\end{table}%
    %}
    
    
    
    %%     1      2         3           4         5            6            7
    %%  *wide,  [pos]  <pre-amble>  {content}  {caption} [short caption] {label}
    %\NewDocumentCommand{\InsertFigure}{s O{htbp} D<>{} m m O{#5} m}{%
    %	\begin{figure}[#2]%
    %		#3% preamble
    %		\IfBooleanTF{#1}% if star after command
    %			{\captionsetup{labelformat=default}\floatsetup{margins=raggedright}}% pushes the label left aligned
    %			{\ffigbox[\FBwidth]}%%% use hanging label, make a box around graphic
    %		{\caption[#6]{#5}#7}%
    %		{#4}%  includegraphics here
    %	\end{figure}%
    %}%
    


%%%%%%%%%%%%CodeBoxes.sty%%%%%%%%
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
    
    
    % http://texdoc.net/texmf-dist/doc/latex/listings/listings.pdf
    % requires xcolor
    
    \lstset{
    	language=Python,
    	basicstyle=\ttfamily\small,
    	aboveskip={1.0\baselineskip},
    	belowskip={1.0\baselineskip},
    	captionpos=t,
    	belowcaptionskip=5pt, % trial and error gve this a good result
    	frame=tb,
    	rulecolor=\color{black},
    	numbers=left,
    	numberstyle=\ttfamily\small\color{grayCol},
    	keywordstyle=\color{contCol},
    	commentstyle=\color{grayCol},
    	stringstyle=\color{greCode},
    	prebreak=\raisebox{0ex}[0ex][0ex]{\ensuremath{\hookleftarrow}},
    	extendedchars=true,
    	breaklines=true,
    	tabsize=4,
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
    
    


%%%%%%%%%%%%ToDoNote.sty%%%%%%%%
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

%%%%%%%%%%%%DraftStuff.sty%%%%%%%%
    % ##############################################
    % If Draft
    % ##############################################
    
    %%% Draft toggles
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
    
    \newcommand{\PreLimMark}{\usepackage{background}
    	\backgroundsetup{%
    		scale=8,       %% change accordingly
    		angle=45,       %% change accordingly
    		opacity=.5,    %% change accordingly
    		color =lightgray,  %% change accordingly
    		contents={\texttt{PRELIMINARY}}
    }}
    
    
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
    
    
    


%%%%%%%%%%%%BibAndGloss.sty%%%%%%%%
    % requires enumitem for acronym styling
    \usepackage[sorting=none]{biblatex}
    \newcommand{\citeT}[1]{\citetitle{#1}~\cite{#1}}
    \renewrobustcmd*{\bibinitdelim}{\,}
    \renewcommand*{\multicitedelim}{\addcomma\,}  % tighten [1,2,3] multi citations
    
    
    \usepackage[xindy,style=super,nopostdot, nogroupskip, nonumberlist, numberedsection, section=section,savewrites=true,acronym,nomain]{glossaries-extra}
    \setabbreviationstyle[acronym]{long-short}
    \GlsXtrEnableEntryCounting % % https://tex.stackexchange.com/questions/477581/glossaries-introduce-short-name-only-if-used-more-than-once-within-section-chap
     {acronym}% list of categories to use entry counting
     {1}% trigger value
    %\glsenableentrycount % enable \cgls, \cglspl, \cGls, \cGlspl  supposed to not show accronym if only one
    \glsdisablehyper  % to disable hyperlinks
    \glstoctrue  % ToC
    
    \makeglossaries
    
    
    \newglossarystyle{listwithwidth}{%
    	\renewcommand*{\glossaryheader}{}%
    	\renewcommand*{\glsgroupheading}[1]{}%
    	\renewcommand*{\glossarysubentryfield}[6]{glssubentryitem{##2}{\strut\glstarget{##2}##4\glspostdescription\space ##6}}%
    	\renewcommand*{\glsgroupskip}{\vspace{7pt}}% space between alphabetized groups
    	\renewenvironment{theglossary}%
    		{\enlargethispage{2em}\begin{description}[leftmargin=2.5cm,style=multiline,itemsep=3pt,format=\raggedright\sloppy]}%
    		{\end{description}}%
    	\renewcommand*{\glossaryentryfield}[5]{%
    		\item[{\normalfont\bfseries\glsentryitem{##1}\glstarget{##1}{##2}}]{##3\glspostdescription\space ##5}
    		}%
    }
    
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
    
    
    
    % todo do this for \Gls and \GLS, maybe * + to gls
    \usepackage{pdfcomment}
    \let\oldgls\gls
    \RenewDocumentCommand{\gls}{ O{} m O{} }{%
        \ifglsused{#2}{%
        	\pdftooltip{\oldgls[#1]{#2}[#3]}{\glsentrylong{#2}}%
    	}{%
    		\oldgls{#2}%
    	}%
    }%
    \let\oldglspl\glspl
    \RenewDocumentCommand{\glspl}{ O{} m O{} }{%
        \ifglsused{#2}{%
    	    \pdftooltip{\oldglspl[#1]{#2}[#3]}{\glsentrylong{#2}}%
    	}{%
    		\oldglspl{#2}%
    	}%
    }%


%%%%%%%%%%%%Hyperlinks.sty%%%%%%%%
    % ##############################################
    % References / Hyperlinks
    % ##############################################
    
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
    
    
    \usepackage[nameinlink,noabbrev,capitalize]{cleveref}  % cref
    
    %% REFERENCING SECTIONS - lowercase s for sections, uppercase everything else
    \Crefname{section}{Section}{Sections}% {<type>}{<singular>}{<plural>}
    \Crefname{equation}{equation}{equations}% {<type>}{<singular>}{<plural>}
    \Crefname{appsec}{Appendix}{Appendices}
    \Crefname{table}{Table}{Tables}
    \Crefname{figure}{Figure}{Figures}
    
    \creflabelformat{equation}{#2#1#3}
    \crefrangelabelformat{equation}{#3#1#4 to #5#2#6}


%%%%%%%%%%%%Titles.sty%%%%%%%%
    \let\company\publishers
    
    %%% todo do this for other paras
    \ExplSyntaxOn
    \RenewDocumentCommand{\title}{m}
     {
      \tl_gset:cn { @title } { #1 } % needed by \maketitle
      \tl_gset:Nn { \realtitle } { #1 }
      \seq_set_split:Nnn \l_tmpa_seq { \\ } { #1 }
      \tl_gset:Nx \inlinetitle { \seq_use:Nn \l_tmpa_seq { ~ } }
     \ExplSyntaxOff
     \hypersetup{pdftitle=\inlinetitle}
     }
    
    \ExplSyntaxOn
    \RenewDocumentCommand{\author}{m}
     {
      \tl_gset:cn { @author } { #1 } % needed by \maketitle
      \tl_gset:Nn { \realauthor } { #1 }
      \seq_set_split:Nnn \l_tmpa_seq { \\ } { #1 }
      \tl_gset:Nx \inlineauthor { \seq_use:Nn \l_tmpa_seq { ~ } }
     \ExplSyntaxOff
     \hypersetup{pdfauthor=\inlineauthor}
     }
    
    
    
    
    
    
    \NewDocumentCommand{\logo}{O{width=4cm} m >{\ExpArgOnceProc}O{\TitleLogoPlaceDefault} }{%
        \gdef\@logo{\includegraphics[#1,smash=#3]{#2}}%
    }
    
    
    \gdef\@tpOwn{
    \begin{titlepage} % Suppresses displaying the page number on the title page and the subsequent page counts as page 1
    
    	\newgeometry{bottom=2in, top=1.5in, left=1.75in, right=1.5in}%
    	\raggedright % Right align the title page
    	\rule{\heavyrulewidth}{7.4in} % Vertical line
    	\hspace{0.5in} % Whitespace between the vertical line and title page text
    	\begin{minipage}[b][7.4in][s]{4.4in}
    	    \raggedright
    
    		\null\vfill\null\vfill
    
    		{\Huge\bfseries \@title }% Title  \bfseries
    
    		\ifdef{\@subtitle}{
    		\null\vfill\par
    		{\large\itshape \@subtitle} % Subtitle or further description
    		}{}
    		\ifdef{\@publishers}{
    		\null\vfill\par
    		{\Large \@publishers} % or company
    		}{}
    		\ifdef{\@author}{
    		\null\vfill\par
    		{\Large \@author}
    		}{}
    		\ifdef{\@date}{
    		\null\vfill\par
    		{\Large \@date}
    		}{}
    		\ifdef{\@logo}{
    		\null\vfill
    		\null\vfill\par
    		\null\hfill\@logo\par
    		}{}
    
    		\null\vfill\null\vfill
    
    
    \end{minipage}
    
    \end{titlepage}
    }
    
    
    \gdef\titlesubbox#1{\hspace*{0.7cm}
    \pbox{\dimexpr(\linewidth-0.7cm)\relax}{#1}\par\vspace{-1ex}
    }
    
    \gdef\@tpSame{\thispagestyle{plain}
    		\gdef\And{\hspace*{3ex}}
    		{\RaggedRight                             % \pbox[t]{\linewidth}  %% todo top align logo with title
    		\pbox[t]{0.45\linewidth}{\LARGE\bfseries \@title} \hfill	 \ifdef{\@logo}{\@logo}{}\par
    
    		\vspace{0.5em}
    
    		\ifdef{\@subtitle}{\titlesubbox{\itshape \@subtitle}}{}
    		\ifdef{\@publishers}{\titlesubbox{\large \@publishers}}{}
    		\ifdef{\@author}{\titlesubbox{\large\bfseries \@author}}{}
    		\ifdef{\@date}{\titlesubbox{\large \@date}}{}
    
    		\vspace*{1em}
    		\rule{\linewidth}{\heavyrulewidth}\\[-2ex]
    		\ \hfill\rule{\dimexpr(\linewidth-0.7cm)\relax}{\lightrulewidth}
    		\vspace*{1em}
    }}
    
    
    
    \def\maketitle{%
    	\iftoggle{samepgTitle}{\togglefalse{SecOnNewPage}\@tpSame}{\@tpOwn}%
    }
    
    


%% packages in folder

%%%%%%%%%%%%macros/unirefs.sty%%%%%%%%
    %%%% todo maybe move this to a lua-based function
    
    \newcounter{unilabIN}% my referene counter withIN each new instance
    \newcounter{unilabOUT}% creates a new set of counters if incremented
    
    \setcounter{unilabIN}{0}
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

%%%%%%%%%%%%macros/smcaps.sty%%%%%%%%
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


%%%%%%%%%%%%macros/secletter.sty%%%%%%%%
    % FROM THIS WEBSITE, I ADAPATED IT TO WORK WITH SUBSECS AND SUBSUBSECS AS WELL. https://tex.stackexchange.com/questions/229068/appending-alphanumeric-character-to-chapter-numbers
    
    %%% SECTION LETTER SUFFIX
    
    \newcounter{repsection}
    \let\latex@section\section
    \renewcommand{\section}{\@ifstar{\latex@section*}{\guuk@section}}
    \newcommand{\guuk@section}{\@ifnextchar+{\repeat@section}{\restoresection\latex@section}}
    
    \newcommand{\repeat@section}[1]{    % #1 is +, see aboute @ifnextchar+\repeat...  
    	\ifnum\value{repsection}>0
    	\addtocounter{section}{-1}%
    	\fi
    	\stepcounter{repsection}%
    	\latex@section
    }
    
    \newcommand{\restoresection}{%
    	\setcounter{repsection}{0}%
    }
    
    \def\thesection{\arabic{section}\alph{repsection}}
    
    \def\theHsection{\arabic{section}\alph{repsection}} % this is for hyperref (it does nothing if not loaded)
    
    
    
    
    
    
    
    %%% SUB-SECTION LETTER SUFFIX
    
    \newcounter{repsubsection}
    \let\latex@subsection\subsection
    \renewcommand{\subsection}{\@ifstar{\latex@subsection*}{\guuk@subsection}}
    \newcommand{\guuk@subsection}{\@ifnextchar+{\repeat@subsection}{\restoresubsection\latex@subsection}}
    \newcommand{\repeat@subsection}[1]{% #1 is +
    	\ifnum\value{repsubsection}>0
    	\addtocounter{subsection}{-1}%
    	\fi
    	\stepcounter{repsubsection}%
    	\latex@subsection
    }
    \newcommand{\restoresubsection}{%
    	\setcounter{repsubsection}{0}%
    }  
    \def\thesubsection{\arabic{section}\alph{repsection}.\arabic{subsection}\alph{repsubsection}}
    % this is for hyperref (it does nothing if not loaded)
    \def\theHsubsection{\arabic{section}\alph{repsection}.\arabic{subsection}\alph{repsubsection}}
    
    
    
    
    
    
    
    
    
    %%% SUB-SUB SECTION LETTER SUFFIX
    
    \newcounter{repsubsubsection}
    \let\latex@subsubsection\subsubsection
    \renewcommand{\subsubsection}{\@ifstar{\latex@subsubsection*}{\guuk@subsubsection}}
    \newcommand{\guuk@subsubsection}{\@ifnextchar+{\repeat@subsubsection}{\restoresubsubsection\latex@subsubsection}}
    \newcommand{\repeat@subsubsection}[1]{% #1 is +
    	\ifnum\value{repsubsubsection}>0
    	\addtocounter{subsubsection}{-1}%
    	\fi
    	\stepcounter{repsubsubsection}%
    	\latex@subsubsection
    }
    \newcommand{\restoresubsubsection}{%
    	\setcounter{repsubsubsection}{0}%
    }
    \def\thesubsubsection{\arabic{section}\alph{repsection}.\arabic{subsection}\alph{repsubsection}.\arabic{subsubsection}\alph{repsubsubsection}}
    % this is for hyperref (it does nothing if not loaded)
    \def\theHsubsubsection{\arabic{section}\alph{repsection}.\arabic{subsection}\alph{repsubsection}.\arabic{subsubsection}\alph{repsubsubsection}}
    
    
    
    
    
    
    
    
    
    
    
    
    
    %%% EXAMPLE
    
    %\section{Steady-State Analysis}
    %\subsection{Details}
    %The objective is to..
    %\subsubsection{Contingencies}
    %These contingencies were studied..
    %\subsubsection{Monitored}
    %These quantities were monitored.
    %
    %The options are shown in sections \ref{sec:Ass:sync} and \cref{sec:Bss:svc}
    %
    %\subsection+{Results for Synchronous Condensor} \label{sec:Ass:sync}
    %Results for option A
    %\subsection+{Results for SVC} \label{sec:Bss:svc}
    %Results for Option B
    %
    %
    %\restoresubsection
    %
    %\section+{Dynamics Analysis for Synch. Condensor Option}
    %\subsection{Results}
    %\section+{Dynamics Analysis for SVC Option}
    %\subsection{Results}
    %
    
    


%%%%%%%%%%%%macros/marginnote.sty%%%%%%%%
    
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


% some lua  stuff
\ifluatex

%%%%%%%%%%%%macros/AutoPuncLists.sty%%%%%%%%
    \NewDocumentCommand{\AutoPuncItems}{ O{;} O{; and} O{.} m }{
        \luadirect{AutoPuncItems(
            \luastringN{#4xxxENDxxx},
            \luastringN{#1},
            \luastringN{#2},
            \luastringN{#3}
        )}
    }
    
    \begin{luacode*}
    function AutoPuncItems(s, btwn, seclast, last) -- add btwn and sec and last options
        local it = '\\item'
        local s_item = '%s*'..it
        btwn = btwn or ';'
        btwn = btwn..' '..it
        seclast = seclast or '; and'
        seclast = seclast..' '..it
        last = last or '.'
        local _, n_matches = string.gsub(s, s_item, "") -- find num items
        s, _ = string.gsub(s, s_item,    seclast,   n_matches) -- replace all items with second last type
        s, _ = string.gsub(s, seclast,   btwn,      n_matches-1) --replace all but last(ie second last) with the between
        s, _ = string.gsub(s, '%s*xxxENDxxx', last) -- add the final char
        s = string.sub(s, #btwn-#it+1, #s)
        tex.print(s)
    end
    
    --function remove_tex_comments(s)
            --return string.gsub(s, '%.*\n', '')
            --return string.gsub(s, '%%(.*\r)', '')
            --s, _ = remove_tex_comments(s)
        --end
    \end{luacode*}
    
    
    
    
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
    \NewDocumentCommand{\itertext}{O{} m O{, }}{%
    \foreach \n in {#2}{%
        #1\n#3%
    }}

    \usepackage[pl,extras]{penlight}
    \usepackage{YAMLvars}
    \usepackage{lutabulartools}

    \begin{luacode*}
        YAMLvars.tabmidrule = 'gmidrule'
    \end{luacode*}
\else
\fi





%%%%%%%%%%%%MemoSty.sty%%%%%%%%
    %%%% memo variabls
    
    
    \NewDocumentCommand{\memoTo}{m o o o o}{
    \gdef\@memoToA{#1}
    \IfValueT{#2}{\gdef\@memoToB{#2}}
    \IfValueT{#3}{\gdef\@memoToC{#3}}
    \IfValueT{#4}{\gdef\@memoToD{#4}}
    \IfValueT{#5}{\gdef\@memoToE{#5}}
    }
    \NewDocumentCommand{\memoFr}{m o o o o}{
    \gdef\@memoFrA{#1}
    \IfValueT{#2}{\gdef\@memoFrB{#2}}
    \IfValueT{#3}{\gdef\@memoFrC{#3}}
    \IfValueT{#4}{\gdef\@memoFrD{#4}}
    \IfValueT{#5}{\gdef\@memoFrE{#5}}
    }
    \newcommand{\memoHeader}[1]{\gdef\@memoHeader{#1}}
    \newcommand{\fileno}[1]{\gdef\@fileno{#1}}
    \newcommand{\attachments}[1]{\gdef\@attachments{#1}}
    
    \newcommand{\@HangingLabel}[1]{\leavevmode\llap{\scriptsize\uppercase{#1}:\enspace}}
    
    
    
    \gdef\makeMemotitle{%
        \thispagestyle{plain}
        \vspace*{-4.5em}
    
        \ifdef{\@memoHeader}{\vspace*{-2em}  \ \hfill {\large\bfseries \@memoHeader } \hfill \  \\[1.2em]}{}
    
        \begin{tabularx}{\textwidth}{lXl}
        	\@HangingLabel{to}\textit{\@memoToA}  &&
        	\@HangingLabel{fr}\textit{\@memoFrA}\\ \noalign{\vskip 0.5mm} % add a bit more space %%% todo need an ifdefOR{\cs1}{\cs2}{}{}
        %
        	\ifdefOR{\@memoToB}{\@memoFrB}{\ifdef{\@memoToB}{\@memoToB}{}	&&   \ifdef{\@memoFrB}{\@memoFrB}{}	 \\}{}
        	\ifdefOR{\@memoToC}{\@memoFrC}{\ifdef{\@memoToC}{\@memoToC}{}	&&   \ifdef{\@memoFrC}{\@memoFrC}{}	 \\}{}
        	\ifdefOR{\@memoToD}{\@memoFrD}{\ifdef{\@memoToD}{\@memoToD}{}	&&   \ifdef{\@memoFrD}{\@memoFrD}{}	 \\}{}
        	\ifdefOR{\@memoToE}{\@memoFrE}{\ifdef{\@memoToE}{\@memoToE}{}	&&   \ifdef{\@memoFrE}{\@memoFrE}{}	 \\}{}
        %
        	\\\noalign{\vskip -1.3ex}
        	\midrule
        \end{tabularx}
        \par
    
        \vspace*{1em}
    
        \parbox{\linewidth}{\setstretch{1.3}
        	\ifdef{\@subject}{\@HangingLabel{subject}\raggedright\textbf{\Large\@subject}\\[8pt]}{}%
        	\ifdef{\@date}{\@HangingLabel{date}\textbf{\Large\@date}\\[8pt]}{}
        	\ifdef{\@fileno}{\@HangingLabel{file}\textbf{\Large\@fileno}\\[8pt]}{}
        	\ifdef{\@attachments}{\@HangingLabel{attached}\@attachments\\[8pt]}{}
        	\par
        }%
    }
    
    
    \iftoggle{useMemo}{
    
      \AtBeginDocument{
            \ifdef{\@memoToA}{\lohead{\textit\@memoToA}}{}
            \ifdef{\@date}{\rohead{\@date}}{}
            \makeMemotitle
            }
    
        \togglefalse{SecOnNewPage}         %%% PATCH sections
        \addtokomafont{section}{\color{black}\large}
        \addtokomafont{subsection}{\color{black}\normalsize}
        \addtokomafont{subsubsection}{\color{black}}  % do not use in a memo
    
        \gdef\scr@section@beforeskip{17.1pt \@plus 1.7pt}
        \gdef\scr@section@afterskip{0.1pt}
        \gdef\scr@subsection@beforeskip{13.1pt \@plus 1.3pt}
        \gdef\scr@subsection@afterskip{0.1pt}
    
    
        \setcounter{secnumdepth}{-\maxdimen}  % remove sec num
        \KOMAoptions{bibliography=totoc}  % uncomment if you want numbered reference section
        \floatsetup[table]{objectset=raggedright}
    }{}
    





%%%%%%%%%%%%EndOf.sty%%%%%%%%
    
    \newcommand{\IntentionallyBlankPage}{
    \pagebreak
    \thispagestyle{empty}
    \null\vfill
    {\noindent\large\hfill This\ Page\ Intentionally\ Left\ Blank\hfill\vspace{5cm}}
    \null\vfill
    \pagebreak
    }
    
    
    %%% End of document
    \NewDocumentCommand{\PrintEndOfDocument}{ s }{%
    \IfBooleanTF{#1}{\vspace*{2.5cm}}{\pagebreak\null\vfill}
    {\noindent\large\hfill End\ of\ Document\hfill\vspace{5cm}}
    \IfBooleanF{#1}{\null\vfill}
    }
    




\ifluatex
%! language = yaml
\begin{declareYAMLvars}
title:
  xfm: lb2nl
  prc: setdocvar

subtitle:
  xfm: lb2nl
  prc: setdocvar

author:
  xfm: lb2nl
  prc: setdocvar

date:
  xfm: lb2nl
  prc: setdocvar

subject:
  xfm: lb2nl
  prc: setdocvar

fileno:
  xfm: lb2nl
  prc: setdocvar



attachments:
  xfm: lb2nl
  prc: setdocvar

memoHeader:
  xfm: lb2nl
  prc: setdocvar

memoFr:
  prc: setdocvarOpts

memoTo:
  prc: setdocvarOpts

logo:
  prc: setdocvarOpts
\end{declareYAMLvars}
\else
\fi