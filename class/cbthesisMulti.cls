%%% shortcut to use all format files of
\let\footref\relax % if footref error appears

\providecommand{\FormatDir}{class/}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cbthesis}[2022-02-19]

%%% Document Class
\LoadClass[11pt,
letterpaper,
twoside=false,
hidelinks,
parskip=half-,
bibliography=totoc,
open=right,%
chapterprefix=true,
fleqn,
%listof=totoc,% for list of figures, tables
numbers=noenddot]{scrreprt}

\RequirePackage{etoolbox}
\newtoggle{samepgTitle}
\newtoggle{useMemo}
\newtoggle{useSerif}\toggletrue{useSerif}


\newlength{\pullToCcloser}
\setlength{\pullToCcloser}{-12pt}
\newlength{\moreToCbottom}
\setlength{\moreToCbottom}{2em}


\gdef\TitleLogoPlaceDefault{tl}


%https://github.com/mrpiggi/svg/issues/18
\providecommand*{\Ifstr}{\ifstr}  % little hack that supposed to fix ifstr warning, see https://komascript.de/faq_deprecatedif


\usepackage{\FormatDir LuaStuff} %%% Lua Stuff

\usepackage{\FormatDir GeometryCustom} %%% GEOMETRY
\usepackage{\FormatDir Utilities} %%% GENERAL UTILITIES, FOR SHAPING, IMPORTING, ETC

\usepackage{\FormatDir TextAndParas} %%% MAIN FONT SETTINGS

\usepackage[fleqn]{amsmath} % need to load before kpfonts-otf

\usepackage{\FormatDir FontKPotf}


\usepackage{\FormatDir HeaderFooterFootnotes} %%% HEADER AND FOOTER AND FOOTNOTES
\usepackage{\FormatDir PageNumberInMargin} %%% PLACING PAGE NUMBER IN THE LOWER RIGHT MARGIN

%\usepackage{\FormatDir SectionsToCCustom} %%% SECTION HEADINGS, TOC, AND FORMATTING
\usepackage{\FormatDir SecThesis}

%\usepackage{\FormatDir AppendixFormat} %%% APPENDIX FORMATTINGS (depends on some ToC)
\usepackage{\FormatDir AppendixFormatThesis} %%% APPENDIX FORMATTINGS (depends on some ToC)

\usepackage{\FormatDir ColorsCustom} %%% CUSTOM COLORS
\usepackage{\FormatDir MathSymbolsEtc} %%% MATH RELATED PACKAGES
\usepackage{\FormatDir Lists}

\usepackage{\FormatDir Tables} %
%\setlength\heavyrulewidth{0.7pt}

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


\usepackage[pl,extras]{penlight}
\usepackage{lutabulartools}
\usepackage{autopuncitems}

\usepackage{YAMLvars}
\begin{luacode*}
    YAMLvars.tabmidrule = 'gmidrule'
\end{luacode*}




\usepackage{\FormatDir EndOf}

\rohead{}

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

publishers:
  xfm: lb2nl
  prc: setdocvar

logo:
  prc: setdocvarOpts
  
pdf:
  prc: setPDFdata
  
\end{declareYAMLvars}
