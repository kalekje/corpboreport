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
\usepackage{\FormatDir GeometryCustom} %%% GEOMETRY
\usepackage{\FormatDir Utilities} %%% GENERAL UTILITIES, FOR SHAPING, IMPORTING, ETC
\usepackage{\FormatDir FontAndParas} %%% MAIN FONT SETTINGS
\usepackage{\FormatDir HeaderFooterFootnotes} %%% HEADER AND FOOTER AND FOOTNOTES
\usepackage{\FormatDir PageNumberInMargin} %%% PLACING PAGE NUMBER IN THE LOWER RIGHT MARGIN
\usepackage{\FormatDir SectionsToCCustom} %%% SECTION HEADINGS, TOC, AND FORMATTING
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
\usepackage{\FormatDir macros/unirefs}  % macro to create unique labels, useful for tabular notes
\usepackage{\FormatDir macros/smcaps}  % custom small caps for fonts that dont have it (ie CM BRIGHT) simply makes font size smaller
\usepackage{\FormatDir macros/secletter}  % allows for 2a, 2b sectioning
\usepackage{\FormatDir macros/marginnote} % better looking margin notes

% some lua  stuff
\ifluatex
    \usepackage{\FormatDir macros/AutoPuncLists}

    \usepackage[pl,extras]{penlight}
    \usepackage{YAMLvars}
    \usepackage{lutabulartools}

    \begin{luacode*}
        YAMLvars.tabmidrule = 'gmidrule'
    \end{luacode*}
\else
\fi




\usepackage{\FormatDir MemoSty}



\usepackage{\FormatDir EndOf}



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