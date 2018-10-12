*Compute measures for intellect and general impression 

COMPUTE negimpressionR=10-negative_impression. 
EXECUTE.
COMPUTE intellect=mean(competent,thoughtful,intelligent). 
EXECUTE. 
COMPUTE impression=mean(like,positive_impression,negimpressionR). 
EXECUTE.

*Measure reliability of factors

RELIABILITY 
  /VARIABLES=competent thoughtful intelligent 
  /SCALE('ALL VARIABLES') ALL 
  /MODEL=ALPHA.

RELIABILITY 
  /VARIABLES=like positive_impression negimpressionR 
  /SCALE('ALL VARIABLES') ALL 
  /MODEL=ALPHA.

*Test the effect of communication medium on evaluations using 5 conditions: male actor 1, male actor 2, female actor 1, female actor 2, and writing.

ONEWAY intellect impression hire BY cond2
  /CONTRAST=0 1 -1 
  /CONTRAST=1 0 -1 
  /CONTRAST=1 -1 0 
  /CONTRAST=1 1 -2 
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS.

* Test the effect of communication medium on evaluations using 3 conditions: male actors, female actors, and writing.

ONEWAY intellect impression hire BY cond3
  /CONTRAST=0 1 -1 
  /CONTRAST=1 0 -1 
  /CONTRAST=1 -1 0 
  /CONTRAST=1 1 -2 
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS.

*Test whether intellect and general impressions sequentially mediate the effect of communication medium on hiring likelihood

MEDTHREE Y = hire/X = cond3/M1 = intellect/M2 = impression/boot = 5000.

*Create evaluation variables centered around writer.

AGGREGATE 
/BREAK=Writer
/meanhire=MEAN(hire)
/meanintellect=MEAN(intellect)
/meanimpression=MEAN(impression)

COMPUTE centhire=hire-meanhire.
COMPUTE centintellect=intellect-meanintellect.
COMPUTE centimpression=impression-meanimpression.
execute.

*Test the effect of voice on evaluations, accounting for speaker variance.

MIXED centintellect WITH malevoice femalevoice
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT malevoice femalevoice
/RANDOM = INTERCEPT | SUBJECT(Writer).

MIXED centintellect WITH femalevoice writing
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT femalevoice writing
/RANDOM = INTERCEPT | SUBJECT(Writer).

MIXED centimpression WITH malevoice femalevoice
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT malevoice femalevoice
/RANDOM = INTERCEPT | SUBJECT(Writer).

MIXED centimpression WITH femalevoice writing
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT femalevoice writing
/RANDOM = INTERCEPT | SUBJECT(Writer).

MIXED centhire WITH malevoice femalevoice
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT malevoice femalevoice
/RANDOM = INTERCEPT | SUBJECT(Writer).

MIXED centhire WITH femalevoice writing
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT femalevoice writing
/RANDOM = INTERCEPT | SUBJECT(Writer).


MIXED centintellect WITH voice
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT voice
/RANDOM = INTERCEPT | SUBJECT(Writer).

MIXED centimpression WITH voice
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT voice
/RANDOM = INTERCEPT | SUBJECT(Writer).

MIXED centhire WITH voice
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT voice
/RANDOM = INTERCEPT | SUBJECT(Writer).

