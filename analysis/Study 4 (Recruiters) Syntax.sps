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

*Test the effect of voice on evaluations

T-TEST GROUPS=cond(0 1) 
  /MISSING=ANALYSIS 
  /VARIABLES=hire intellect impression
  /CRITERIA=CI(.95).

*Test the effect of voice on time viewing stimulus and memory test word count

T-TEST GROUPS=cond(0 1) 
  /MISSING=ANALYSIS 
  /VARIABLES=time wordcount
  /CRITERIA=CI(.95).

*Test whether intellect and general impressions sequentially mediate the effect of voice on hiring likelihood

MEDTHREE Y = hire/X = cond/M1 = intellect/M2 = impression/boot = 5000.

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

MIXED centintellect WITH cond
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT cond
/RANDOM = INTERCEPT | SUBJECT(speaker).

MIXED centimpression WITH cond
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT cond
/RANDOM = INTERCEPT | SUBJECT(speaker).

MIXED centhire WITH cond
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT cond
/RANDOM = INTERCEPT | SUBJECT(speaker).

