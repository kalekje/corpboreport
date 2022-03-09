\let\footref\relax % if footref error appears
\providecommand{\standaloneOptions}{}
\LoadClass[11pt,multi=pg,crop,\standaloneOptions]{standalone}
% \use the \begin{pg} enviroment for separate pages


\usepackage{\FormatDir Utilities} %%% GENERAL UTILITIES, FOR SHAPING, IMPORTING, ETC

\newtoggle{useSerif}
\DeclareOption{serif}{\toggletrue{useSerif}}
\ProcessOptions\relax

\usepackage{\FormatDir LuaStuff}
\usepackage{\FormatDir TextandParas}


\iftoggle{useSerif}{

    \usepackage{\FormatDir FontKPotf}

}{

	\usepackage{\FormatDir FontCMBotf}

}

\usepackage{\FormatDir MathSymbolsEtc}
\usepackage{\FormatDir Tables} %
\usepackage{\FormatDir ColorsCustom} %
\usepackage{\FormatDir Lists} %

\usepackage{\FormatDir CodeBoxes}
\usepackage{\FormatDir macros/unirefs}
\usepackage{graphbox}

\usepackage{\FormatDir TikZstuff}

\usepackage[pl,extras]{penlight}
\usepackage{YAMLvars}
\usepackage{lutabulartools}
\usepackage{autopuncitems}

\begin{luacode*}
	YAMLvars.tabmidrule = 'gmidrule'
\end{luacode*}




