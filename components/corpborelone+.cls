\let\footref\relax % if footref error appears
\providecommand{\standaloneOptions}{}
\LoadClass[11pt,multi=pg,crop,\standaloneOptions]{standalone}
% \use the \begin{pg} enviroment for separate pages


\usepackage{Utilities+} %%% GENERAL UTILITIES, FOR SHAPING, IMPORTING, ETC

\newtoggle{useSerif}
\DeclareOption{serif}{\toggletrue{useSerif}}
\ProcessOptions\relax

\usepackage{LuaStuff+}
\usepackage{TextandParas+}

\usepackage[fleqn]{amsmath} % need to load before kpfonts-otf

\iftoggle{useSerif}{

    \usepackage{FontKPotf+}

}{

	\usepackage{FontCMBotf+}

}

\usepackage{MathSymbolsEtc+}
\usepackage{Tables+} %
\usepackage{Colors+} %
\usepackage{Lists+} %

\usepackage{CodeBoxes+}
\usepackage{Macros+/unirefs+}
\usepackage{graphbox}



\usepackage[pl,globals]{penlightplus}
\usepackage{YAMLvars}
\usepackage{lutabulartools}
\usepackage{autopuncitems}

\begin{luacode*}
	YAMLvars.tabmidrule = 'gmidrule'
\end{luacode*}



\usepackage{tikz+/libs+}
\usepackage{tikz+/anchors+}
\usepackage{tikz+/overlay+}
\usepackage{tikz+/colormaps+}

