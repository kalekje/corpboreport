%%% shortcut to use all format files of
\let\footref\relax % if footref error appears

\providecommand{\FormatDir}{class/}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{corpboreport}[2021-09-21]

%%% Document Class
\LoadClass[11pt,
%letterpaper,  %
paper=letter,  % paper size
pagesize,      % force given paper size in pdf
twoside=false,
%twoside,% for two sided doc
%open=right,
hidelinks,
parskip=full-,
bibliography=numbered,
numbers=noenddot,
fleqn,
leqno,
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
\DeclareOption{compact}{\toggletrue{samepgTitle}\gdef\TitleLogoPlaceDefault{bl}\AtBeginDocument{\togglefalse{SecOnNewPage}}}
\DeclareOption{serif}{\toggletrue{useSerif}}
\ProcessOptions\relax

%https://github.com/mrpiggi/svg/issues/18
\providecommand*{\Ifstr}{\ifstr}  % little hack that supposed to fix ifstr warning, see https://komascript.de/faq_deprecatedif


\usepackage{\FormatDir LuaStuff} %%% Lua Stuff

\usepackage{\FormatDir GeometryCustom} %%% GEOMETRY
\usepackage{\FormatDir Utilities} %%% GENERAL UTILITIES, FOR SHAPING, IMPORTING, ETC

\usepackage{\FormatDir TextAndParas} %%% MAIN FONT SETTINGS

\usepackage[fleqn,leqno]{amsmath} % need to load before kpfonts-otf

\iftoggle{useSerif}{

    \usepackage{\FormatDir FontKPotf}

}{

        \usepackage{\FormatDir FontCMBotf}

}

\usepackage{\FormatDir HeaderFooterFootnotes} %%% HEADER AND FOOTER AND FOOTNOTES
\usepackage{\FormatDir SectionsToCCustom} %%% SECTION HEADINGS, TOC, AND FORMATTING
\usepackage{\FormatDir PageNumberInMargin} %%% PLACING PAGE NUMBER IN THE LOWER RIGHT MARGIN
\usepackage{\FormatDir AppendixFormat} %%% APPENDIX FORMATTINGS (depends on some ToC)
\usepackage{\FormatDir ColorsCustom} %%% CUSTOM COLORS
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

\usepackage{\FormatDir macros/UniRefs}  % macro to create unique labels, useful for tabular notes
\usepackage{\FormatDir macros/symbolscbp}  % macros for symbols

\usepackage{\FormatDir EndOf}


\usepackage[pl,extrasglobals]{penlight}
\usepackage{lutabulartools}
\usepackage{autopuncitems}
\usepackage{\FormatDir YAMLvarsDec}





\usepackage{\FormatDir MemoSty}
