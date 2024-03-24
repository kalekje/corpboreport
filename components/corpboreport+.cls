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

\usepackage{LuaStuff+} %%% Lua Stuff

\usepackage{GeometryCustom+} %%% GEOMETRY
\usepackage{Utilities+} %%% GENERAL UTILITIES, FOR SHAPING, IMPORTING, ETC

\usepackage{TextAndParas+} %%% MAIN FONT SETTINGS

\usepackage{moreenum}  %% ensure this package does not get used by beamer
\newcounter{moreenumtempcounter}
\NewDocumentCommand{\nword}{m}{\setcounter{moreenumtempcounter}{#1}\nwords{moreenumtempcounter}}


\usepackage{lastpage}



\iftoggle{useSerif}{
      \usepackage{FontKPotf+}
}{%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      \usepackage{FontCMBotf+}
}

\usepackage{HeaderFooterFootnotes+} %%% HEADER AND FOOTER AND FOOTNOTES
\usepackage{SectionsToC+} %%% SECTION HEADINGS, TOC, AND FORMATTING
\usepackage{PageNumberInMargin+} %%% PLACING PAGE NUMBER IN THE LOWER RIGHT MARGIN
\usepackage{Colors+} %%% CUSTOM COLORS
\usepackage{MathSymbolsEtc+} %%% MATH RELATED PACKAGES
\usepackage{Lists+}
\usepackage{Tables+} %
\usepackage{FloatsCaptions+} %
\usepackage{CodeBoxes+}
\usepackage{ToDoNote+}
\usepackage{DraftStuff+}   %%% COMMANDS TO HELP WITH DRAFT
\usepackage{BibAndGloss+}
\usepackage{Hyperlinks+}  %%% CONTAINS hyperref and cleverref SETUP
\usepackage{Titles+}  %%% title page

%% packages in folder
\usepackage{MarginNotes+} % better looking margin notes

\usepackage{EndOf+}

\usepackage[pl,globals]{penlightplus}
\usepackage{lutabulartools}
\settabular{tbrule,nopad}
\usepackage{autopuncitems}
\usepackage{YAMLvarsDec+}

\usepackage{tikz+/libs+}
\usepackage{tikz+/anchors+}
\usepackage{tikz+/overlay+}
\usepackage{tikz+/colormaps+}

\usepackage{Macros+/UniRefs+}  % macro to create unique labels, useful for tabular notes
\usepackage{Macros+/symbolscbp+}  % macros for symbols

\usepackage{Macros+/tweaks+}

\usepackage{MemoSty+}

\usepackage{LegacyCommands+}
