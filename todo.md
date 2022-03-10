* add `luakeys` package and test the default options


Fonts: test python matching? siu

FIX cmbright, use otf among the classes, now use otf!!

look into siunitx math mode for new numbers -- why isn't match working?
  ideally I would like mode=match then set lining  for serif

acro/gloss test tooltip

if using serif, 
	should I rely on CBP serif option??? probably, and make it work between presentation and lone class!
	must patch caption package

confirm label-text spacing, choose a good number

debate on lower vs uppercase numbers if using both:
	upper-case for math, numbers, and citations
	lower-case for everything else (footnotes, years, section/page/figure labels)
	

appendx normal vs thesis - test
todo must modify format for appendix-- if using serif, we use small caps on the section letter
make a \def\donothing#1{#1} that does nothing, if serif, re-populate this..

hanging list of figs and tables for report


adjust toc space factor for front and back matter

tighter 1's for kp fonts would be great...
	maybe ask a stack exchange question?

clean document examples would be nice

USE SLANT SHAPE FOR serif, define slant as just italic for CMU.
The idea: use slant for notes etc. like table or listings continued. Use true italic otherwise
work with subcaption... might need an option there
  
  CLEAN UP TEXT in the floats file
    equation: same indent as float. I don't like centered!
  itemize--spacing between paras, should really fix.
  
  PDF/A compliant + meta data:
    https://shen.hong.io/reproducible-pdfa-compliant-latex/
	parse yaml to lua table, then luatable to file
	make a global meta data table in lua. Option to create new or add on
	
	
YAMLvars bud for undeclared... the backslash is getting missed.. might be the cause of missing{} inserted
	YAMLvars--incorporate penlight deeper with pakcage warn and declare functions

