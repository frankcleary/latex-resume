% Copyright (C) 2014 Frank Cleary <frank at frankcleary dot com>
%
% This program can be redistributed and/or modified under
% the terms of the LaTeX Project Public License, either
% version 1.3 of this license or (at your option) any later
% version. The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all LaTeX distributions
% version 2005/12/01 or later.
%
% Based on the original class by Nicola Fontana found at
% http://dev.entidi.com/p/tccv/
%
% The most relevant changes from the previous work are:
%
% * Default paper size set to U.S. letter standard
% * \item is redefined as \olditem to allow itemized lists in the
%	eventlist section
% * tccv.cls now allows a custom subtitle under the name
% * The colored "personal info" is made more flexible by allowing
%	more of the content on each line to be customized by the user
% * Various changes to font weights/styles and text allignment

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tccv}
              [2014/09/28 v1.0
 Two Column Curriculum Vitae]
 
\LoadClassWithOptions{scrartcl}

\setcounter{secnumdepth}{-1}

\usepackage[usenames,dvipsnames]{xcolor}
\RequirePackage[hmargin=1.25cm,vmargin=1.25cm,twocolumn,columnsep=1.25cm,letterpaper]{geometry}
\RequirePackage{bookman,etoolbox,hyperref,needspace,pifont,tabularx,ifsym,enumitem,mdframed}
\definecolor{infobox}{HTML}{F5DD9D}

\setlist[itemize]{noitemsep, leftmargin=*, topsep=0pt}
\let\olditem\item
\usepackage[english]{babel}

% Capitalize words of at least a minimum length (default to 3 chars).
% The text is capitalized before being expanded.
%
% This macro uses Lua to do the job but fails gracefully (that is,
% return the text as is) if \directlua is not available.
%
% |[
% \ucwords[optional: miminum length]{text}
% ]|
\newcommand\ucwords[2][3]{%
    % Fails gracefully if not in LuaLaTeX
    \providecommand\directlua[1]{#2}%
    \directlua{%
	local minlen = tonumber("#1")
	local src = "\luaescapestring{\unexpanded{#2}}"
	local dst = {}
	% Put a % inside \directlua is tricky as hell. Use char(37)
	% instead: still no plans for supporting non-ASCII platforms.
	for w in src:gmatch(string.char(37) .. "S+") do
	    if w:len() >= minlen then
		table.insert(dst, w:sub(1,1):upper() .. w:sub(2))
	    else
		table.insert(dst, w)
	    end
	end
	tex.print(dst)}}

\pagestyle{empty}
\setlength\parindent{0pt}
\color[HTML]{303030} % Default foreground color
\definecolor{link}{HTML}{506060} % Hyperlinks
\hypersetup{colorlinks,breaklinks,urlcolor=link,linkcolor=link}
\setkomafont{disposition}{\color[HTML]{801010}}
\setkomafont{section}{\scshape\Large\mdseries}

% In tccv \part must contain your name and a short subtitle.
% The command will start a new page and output in onecolumn the
% subject (first and last name) with the subtitle under it.
\renewcommand\part[2]{%
    \twocolumn[%
    \begin{center}
	\vskip-\lastskip%
	{\usekomafont{part} #1} \medskip\\
	{\selectfont\Large #2}
	\bigskip
    \end{center}]}

% Overrides the \section command to capitalize every
% word for cosmetic purposes and draws a rule under it.
\makeatletter
\let\old@section\section
\renewcommand\section[2][]{%
    \old@section[#1]{\ucwords{#2}}%
    \newdimen\raising%
    \raising=\dimexpr-0.7\baselineskip\relax%
    \vskip\raising\hrule height 0.4pt\vskip-\raising}
\makeatother

% Renders a personal data box. Use \SYMBOL{num} to render
% \ding{num}
%
% |[
% \SYMBOL{37} & (424) 225-2486
% \smallskip\\
% \SYMBOL{41} &
% \href{mailto:my@address.com}{my@address.com}
% \smallskip\\
% FC  & \href{http://www.frankcleary.com}{www.frankcleary.com}
% ...
% ]|
\newenvironment{infobox}{%
    \newcommand\SYMBOL[1]{\raisebox{-2pt}{\Large\ding{##1}}}%
    \needspace{0.5\textheight}%
    \newdimen\boxwidth%
    \boxwidth=\dimexpr\linewidth-2\fboxsep\relax%
    \tabularx{\boxwidth}{c|X}}
	{\endtabularx}

% Every \item can be followed by one or more paragraphs
% of description. Can use \olditem for bulleted lists
%
% |[
% \item{date range}{company}{role}
%
% Description of what achieved during this application.
% \olditem Acheivement 1
% \olditem Acheivement 2
% ]|
\newenvironment{eventlist}{%
    \newcommand*\inskip{}
    \renewcommand\item[3]{%
	\inskip%
	{\raggedright \textbf{##3\\}}
	{\raggedright \textit{##2\\}}
	{\raggedleft \textsc{##1}\\}
	\smallskip
	\renewcommand\inskip{\vspace{20pt}}}}
    {\bigskip}

% Use only \item inside this environment: no other macros
% are allowed:
%
% |[
% \item[optional: what has been achieved]{years}{subject}{notes}
% ]|
\newenvironment{yearlist}{%
    \renewcommand\item[4][]{%
	{\textsc{##2}} & {\textbf{##3}} \\
	\ifstrempty{##1}{}{& {\textsc{\small{##1}}} \\}
	& {\textit{##4}}\medskip\\}
    \tabularx{\linewidth}{rX}}
    {\endtabularx}


% Use only \item inside this environment: no other macros
% are allowed:
%
% |[
% \item{fact}{description}
% ]|
\newenvironment{factlist}{%
    \newdimen\unbaseline
    \unbaseline=\dimexpr-\baselinestretch\baselineskip\relax
    \renewcommand\item[2]{%
	\textsc{##1} & {\raggedright ##2\medskip\\}\\[\unbaseline]}
    \tabularx{\linewidth}{rX}}
    {\endtabularx}
%%
%% End of file `tccv.cls'.
