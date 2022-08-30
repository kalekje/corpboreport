## Packages
* Upload ALL packages for updates
* add debug code to more YAMLvars functions


## This class
* update \date with ISO format (YYYY-MM-DD) for pdf var
* pdfx trimbox printarea etc reddit question, see if that applies
* clean all .sty files and use a similar comment format for sections
* fix the logo command--not sure if I like the smash=
* Make better front/back/main matter and appendix commands. Redefine section commands, and then revert. Still group front, back, appendix. But keep sectionF sectionM "hidden" from the user such that they don't need to use it.
* confirm label-text spacing (eg \enspace), choose a good number
* MATH: good environments for "Where: x= etc."
* adjust toc space factor for front and back matter


### Other
* Test kv settings?
* kv-pdf var command (title= etc.)
* add `luakeys` package and test with various options.
* acro/gloss test tooltip--not workig with sumatra only it seems
* work with subcaption... might need an option there
* equation: same indent as float. I don't like centered!
* itemize--spacing between paras, should really fix.
* clean document examples would be nice


### Fonts
* Fonts: test python matching, siunitx with MPL
* FIX cmbright, use otf among the classes, now use otf!!
** look into siunitx math mode for new numbers 
  ideally I would like mode=match then set lining  for serif
*if using serif, 
    should I rely on CBP serif option??? probably, and make it work between presentation and lone class!
    * must patch caption package for sans and serif?
* check upper/lowercase numbers -- need to patch footnotes 
* USE SLANT SHAPE FOR serif, define slant as just italic for CMU.
* The idea: use slant for notes etc. like table or listings continued. Use true italic otherwise
* tighter 1's for kp fonts would be great...  maybe ask a stack exchange question?


### Thesis?
appendx normal vs thesis - test
todo must modify format for appendix-- if using serif, we use small caps on the section letter
make a \def\donothing#1{#1} that does nothing, if serif, re-populate this..
* front/main/backmatter





