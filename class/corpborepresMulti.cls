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

\usepackage{\FormatDir TextandParas} %%% MATH RELATED PACKAGES
\usepackage{\FormatDir FontCMBlua} %%% MATH RELATED PACKAGES
\usepackage{\FormatDir MathSymbolsEtc} %%% MATH RELATED PACKAGES
\usepackage{\FormatDir Utilities} %%% GENERAL UTILITIES, FOR SHAPING, IMPORTING, ETC
\usepackage{\FormatDir Tables} %
\usepackage{\FormatDir ColorsCustom} %

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
\usepackage{\FormatDir CodeBoxes}  % todo really should make colors work independently
%\use package{\FormatDir ToDoNote}
\usepackage{\FormatDir macros/unirefs}
%\use package{\FormatDir BibAndGloss}
\usepackage{graphbox}


\usepackage{\FormatDir TikZstuff}


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

\newlength{\cbp@TPheight}
\setlength{\cbp@TPheight}{8cm}

\setbeamertemplate{title page}
{   \Vfill\vspace*{5mm}
	\hspace{1mm} %
	\rule{\heavyrulewidth}{\cbp@TPheight} % Vertical line
	\hspace{3mm} % Whitespace between the vertical line and title page text
	\begin{minipage}[b][\cbp@TPheight][t]{0.7\textwidth}
	\Vfill\vfill\vfill
	\ifinsert{title}{{\usebeamerfont{title}\usebeamercolor[fg]{title}\inserttitle\par\vspace{0.8ex}}}
	\ifinsert{subtitle}{{\usebeamerfont{subtitle}\usebeamercolor[fg]{subtitle}\insertsubtitle\vspace{0.4ex}}}
	\Vfill
	\ifinsert{author}{\vfill{\usebeamerfont{author}\insertauthor}}
	\ifinsert{institute}{\vfill{\usebeamerfont{institute}\insertinstitute}}
	\ifinsert{date}{\vfill{\usebeamerfont{date}\insertdate}}
	\ifinsert{logo}{\vfill\vfill\hfill\insertlogo}
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

%% fifty-fifty
\newcommand{\begColFF}{\vspace{2ex}\begin{columns}[t,onlytextwidth]\begin{column}[T]{0.46\textwidth}}
\newcommand{\nextColFF}{\end{column}\hfill\begin{column}[T]{0.46\textwidth}}
\def\endColFF{\end{column}\end{columns}}

%% narrow-wide
\newcommand{\begColNW}{\begin{columns}[t,onlytextwidth]\begin{column}[T]{0.31\textwidth}}
\newcommand{\nextColNW}{\end{column}\hfill\begin{column}[T]{0.61\textwidth}}
\def\endColNW{\end{column}\end{columns}}

%% wide-narrow
\newcommand{\begColWN}{\begin{columns}[t,onlytextwidth]\begin{column}[T]{0.61\textwidth}}
\newcommand{\nextColWN}{\end{column}\hfill\begin{column}[T]{0.31\textwidth}}
\def\endColWN{\end{column}\end{columns}}

\usepackage{multicol}
\newcommand{\twoCol}[1]{%
    \begin{multicols}{2}
		#1
	\end{multicols}%
}
\setlength{\columnsep}{0.08\textwidth}  % for two column, good for long lists, but use begCol otherwise

