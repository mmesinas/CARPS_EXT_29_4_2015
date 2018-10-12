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

*Test the effect of communication medium on evaluations

ONEWAY intellect impression hire BY cond2 
  /CONTRAST=0 1 -1 
  /CONTRAST=1 0 -1 
  /CONTRAST=1 -1 0 
  /CONTRAST=1 1 -2 
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS.

*Test whether intellect and general impressions sequentially mediate the effect of communication medium on hiring likelihood

MEDTHREE Y = hire/X = cond2/M1 = intellect/M2 = impression/boot = 5000.

*Create evaluation variables centered around speaker.

AGGREGATE 
/BREAK=speaker
/meanhire=MEAN(hire)
/meanintellect=MEAN(intellect)
/meanimpression=MEAN(impression)

COMPUTE centhire=hire-meanhire.
COMPUTE centintellect=intellect-meanintellect.
COMPUTE centimpression=impression-meanimpression.
execute.

*Test the effect of voice on evaluations, accounting for speaker variance.

MIXED centintellect WITH audio video
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT audio video
/RANDOM = INTERCEPT | SUBJECT(speaker).

MIXED centintellect WITH audio transcript
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT audio transcript
/RANDOM = INTERCEPT | SUBJECT(speaker).

MIXED centimpression WITH audio video
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT audio video
/RANDOM = INTERCEPT | SUBJECT(speaker).

MIXED centimpression WITH audio transcript
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT audio transcript
/RANDOM = INTERCEPT | SUBJECT(speaker).


MIXED centhire WITH audio video
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT audio video
/RANDOM = INTERCEPT | SUBJECT(speaker).

MIXED centhire WITH audio transcript
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT audio transcript
/RANDOM = INTERCEPT | SUBJECT(speaker).
