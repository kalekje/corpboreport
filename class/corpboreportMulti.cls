\let\footref\relax % if footref error appears
\providecommand{\FormatDir}{C:/Users/Kale/Projects/LaTeXpackages/corpboreport/class/} %%% shortcut to use all format files of

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{corpboreport}[2022-10-28]

\PassOptionsToClass{%
      11pt,
      letterpaper,
      twoside=false,
      hidelinks,
      parskip=half,
      bibliography=totoc,
      open=right,%
      chapterprefix=false,
      fleqn,
      leqno,
      numbers=noenddot
      titlepage=firstiscover,
}{scrbook}  % default options for basepass

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrbook}} %% pass cbp class options to scrbook
\ProcessOptions\relax

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

\usepackage{\FormatDir LuaStuff} %%% Lua Stuff

\usepackage{\FormatDir GeometryCustom} %%% GEOMETRY
\usepackage{\FormatDir Utilities} %%% GENERAL UTILITIES, FOR SHAPING, IMPORTING, ETC

\usepackage{\FormatDir TextAndParas} %%% MAIN FONT SETTINGS

\usepackage[fleqn,leqno]{amsmath} % need to load before kpfonts-otf

\iftoggle{useSerif}{
      \usepackage{\FormatDir FontKPotf}
}{%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      \usepackage{\FormatDir FontCMBotf}
}

\usepackage{\FormatDir HeaderFooterFootnotes} %%% HEADER AND FOOTER AND FOOTNOTES
\usepackage{\FormatDir SectionsToC} %%% SECTION HEADINGS, TOC, AND FORMATTING
\usepackage{\FormatDir PageNumberInMargin} %%% PLACING PAGE NUMBER IN THE LOWER RIGHT MARGIN
\usepackage{\FormatDir Colors} %%% CUSTOM COLORS
\usepackage{\FormatDir MathSymbolsEtc} %%% MATH RELATED PACKAGES
\usepackage{\FormatDir Lists}
\usepackage{\FormatDir Tables} %
\usepackage{\FormatDir FloatsCaptions} %
\usepackage{\FormatDir CodeBoxes}
\usepackage{\FormatDir ToDoNote}
\usepackage{\FormatDir DraftStuff}   %%% COMMANDS TO HELP WITH DRAFT
\usepackage{\FormatDir BibAndGloss}
\usepackage{\FormatDir Hyperlinks}  %%% CONTAINS hyperref and cleverref SETUP
\usepackage{\FormatDir Titles}  %%% title page

%% packages in folder
\usepackage{\FormatDir MarginNotes} % better looking margin notes

\usepackage{\FormatDir EndOf}

\usepackage[pl,extrasglobals]{penlight}
\usepackage{lutabulartools}
\settabular{tbrule,nopad}
\usepackage{autopuncitems}
\usepackage{\FormatDir YAMLvarsDec}

\usepackage{\FormatDir macros/UniRefs}  % macro to create unique labels, useful for tabular notes
\usepackage{\FormatDir macros/symbolscbp}  % macros for symbols

\usepackage{\FormatDir MemoSty}
