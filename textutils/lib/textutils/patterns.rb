# encoding: utf-8

module TextUtils

# collection of regex patterns for reuse

### todo: add a patterns.md page to  github ??
##  - add regexper pics??

############
# about ruby regexps
#
# try the rubular - Ruby regular expression editor and tester
#  -> http://rubular.com
#   code -> ??  by ??
#
#
# Jeff Avallone's Regexper - Shows State-Automata Diagrams
#  try -> http://regexper.com
#    code -> https://github.com/javallone/regexper
#
#
#  Regular Expressions | The Bastards Book of Ruby by Dan Nguyen
# http://ruby.bastardsbook.com/chapters/regexes/
#
# move to notes  regex|patterns on  geraldb.github.io ??
#

  EMPTY_LINE_PATTERN = '^\s*$'
  
  #################################
  ### Start of Line Comment Patterns
  
  COMMENT_LINE_PATTERN = '^\s*#'   # e.g. Ruby/Shell style  starting w/  # this is a comment

  COMMENT_LINE_HASKELL_PATTERN = '^\s*--'   # e.g. Haskell/Ada? style starting w/ -- 
  COMMENT_LINE_ALT_PATTERN = COMMENT_LINE_HASKELL_PATTERN

  COMMENT_LINE_TEX_PATTERN = '^\s*%'   # e.g. TeX/LaTeX style starting w/ %
  COMMENT_LINE_ALT_II_PATTERN = COMMENT_LINE_TEX_PATTERN

  #############################
  ### End of Line (EOL) Comment Patterns

  EOL_COMMENT_PATTERN = '\s+#.+$'    # fix: use \b word boundry instead of \s - why why not?
  # why /b  - everything but a-z0-9, that is, spaces but also includes umlauts, special chars etc.

  ##############
  ## Dates
  #
  # some info at www.regular-expressions.info/dates.html

  YYYY_STRICT_19_20_PATTERN = '(?:19|20)\d\d'
  YYYY_STRICT_20_PATTERN = '20\d\d'

  MM_STRICT_PATTERN = '0[1-9]|1[012]'
  M_STRICT_PATTERN =  '0?[1-9]|1[012]'

  DD_STRICT_PATTERN = '0[1-9]|[12][0-9]|3[01]'
  D_STRICT_PATTERN =  '0?[1-9]|[12][0-9]|3[01]'

  ######
  ## Time


end # TextUtils