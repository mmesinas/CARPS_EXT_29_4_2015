*Compute measures for intellect and general impression 

COMPUTE negR=12-neg. 
EXECUTE.
COMPUTE intellect=mean(comp,thought,intell). 
EXECUTE. 
COMPUTE impress=mean(like,pos,negR). 
EXECUTE.

*Measure reliability of factors

RELIABILITY 
  /VARIABLES=comp thought intell
  /SCALE('ALL VARIABLES') ALL 
  /MODEL=ALPHA.

RELIABILITY 
  /VARIABLES=like pos negR
  /SCALE('ALL VARIABLES') ALL 
  /MODEL=ALPHA.

*Test the effect of communication medium on evaluations

T-TEST GROUPS=condition(1 0) 
  /MISSING=ANALYSIS 
  /VARIABLES=intellect impress hire
  /CRITERIA=CI(.95).

*Test whether intellect and general impressions sequentially mediate the effect of communication medium on hiring likelihood

MEDTHREE Y = hire/X = condition/M1 = intellect/M2 = impress/boot = 5000.

*Create evaluation variables centered around speaker.

AGGREGATE 
/BREAK=candidatenum
/meanhire=MEAN(hire)
/meanintellect=MEAN(intellect)
/meanimpression=MEAN(impress)

COMPUTE centhire=hire-meanhire.
COMPUTE centintellect=intellect-meanintellect.
COMPUTE centimpression=impress-meanimpression.
execute.

*Test the effect of voice on evaluations, accounting for speaker variance.

MIXED centintellect WITH condition
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT condition
/RANDOM = INTERCEPT | SUBJECT(candidatenum).

MIXED centimpression WITH condition
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT condition
/RANDOM = INTERCEPT | SUBJECT(candidatenum).

MIXED centhire WITH condition
/PRINT = SOLUTION TESTCOV
/FIXED = INTERCEPT condition
/RANDOM = INTERCEPT | SUBJECT(candidatenum).