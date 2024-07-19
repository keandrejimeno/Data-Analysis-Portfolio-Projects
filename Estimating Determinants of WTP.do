// DO-FILE FOR STUDY "ESTIMATING WILLINGNESS TO PAY (WTP) FOR PHOTOVOLTAIC SYSTEMS AMONG HOUSEHOLDS IN CEBU CITY //

/// Note: The study performs six probit models (4 bivariate, 2 univariate) to test the proposed model and alternative models


// I. Setup Variables

** Generate log bid prices
capture drop lngridbid1 lngridbid2 lnhybrbid1 lnhybrbid2 // drop these variables if any

// generate natural logarithm values of bid prices
gen lngridbid1 = log(gridbid1)
gen lngridbid2 = log(gridbid2)
gen lnhybrbid1 = log(hybrbid1)
gen lnhybrbid2 = log(hybrbid2)

** summary of variables
sum age fem marr educ size gridbid1 gridbid2 lngridbid1 lngridbid2 hybrbid1 hybrbid2 renew risk aware conc cred own inc


// II. Model for Grid-tied product using joint dependent (bivariate) variables w/o income variable
**# Bookmark #2
** bivariate probit model for grid-tied with robust standard errors
biprobit (gridwtp1 = age fem marr educ size lngridbid1 renew risk aware conc cred own) (gridwtp2 = age fem marr educ size lngridbid2 renew risk aware conc cred own), robust

** Perform Wald test for parameters of recent model
test age female marr educ size [gridwtp1]lngridbid1 [gridwtp2]lngridbid2 renew risk aware conc cred own

** Wald test for parameters between the pairs of the parameters
test ([gridwtp1]_cons=[gridwtp2]_cons) ([gridwtp1]lngridbid1=[gridwtp2]lngridbid2) ([gridwtp1]age=[gridwtp2]age) ([gridwtp1]female=[gridwtp2]female) ([gridwtp1]marr=[gridwtp2]marr) ([gridwtp1]educ=[gridwtp2]educ) ([gridwtp1]size=[gridwtp2]size) ([gridwtp1]cred=[gridwtp2]cred) ([gridwtp1]own=[gridwtp2]own) ([gridwtp1]renew=[gridwtp2]renew) ([gridwtp1]aware=[gridwtp2]aware) ([gridwtp1]conc=[gridwtp2]conc)

** average marginal effects of the parameters which gives the actual percentage chance of each increased variable
margins, dydx(*)

** model without logging bid for more accurate WTP
biprobit (gridwtp1 = age fem marr educ size gridbid1 renew risk aware conc cred own) (gridwtp2 = age fem marr educ size gridbid2 renew risk aware conc cred own), robust

** estimating WTP using Krinsky & Robb procedure
wtpcikr gridbid1 age fem marr educ size renew risk aware conc cred own, reps(20000) equation(gridwtp1) meanl

** estimating WTP using Delta method
nlcom (meanwtp_q1: -([gridwtp1]_cons+[gridwtp1]age*49.51439+[gridwtp1]female*.5647482+[gridwtp1]marr*.6726619+[gridwtp1]educ*4.917266+[gridwtp1]size*4.920863+[gridwtp1]renew*0.7769784+[gridwtp1]aware*3.413669+[gridwtp1]risk*.5395683+[gridwtp1]conc*4.230216+[gridwtp1]cred*0.8848921+[gridwtp1]own*0.7517986/[gridwtp1]gridbid1))


// III. Model for Grid-tied product type using joint dependent (bivariate) variables w/ income variable
** bivariate probit model with robust standard errors
biprobit (gridwtp1 = age fem marr educ size lngridbid1 renew risk aware conc cred own inc) (gridwtp2 = age fem marr educ size lngridbid2 renew risk aware conc cred own inc), robust
*** in comparing its log pseudolikelihood between the first model

** Perform Wald test for parameters of recent model
test age female marr educ size [gridwtp1]lngridbid1 [gridwtp2]lngridbid2 renew risk aware conc cred own inc
*** results are jointly significant, indicating that the variables affect the outcome

** Wald test for parameters between the pairs of the parameters
test ([gridwtp1]_cons=[gridwtp2]_cons) ([gridwtp1]lngridbid1=[gridwtp2]lngridbid2) ([gridwtp1]inc=[gridwtp2]inc) ([gridwtp1]age=[gridwtp2]age) ([gridwtp1]female=[gridwtp2]female) ([gridwtp1]marr=[gridwtp2]marr) ([gridwtp1]educ=[gridwtp2]educ) ([gridwtp1]size=[gridwtp2]size) ([gridwtp1]cred=[gridwtp2]cred) ([gridwtp1]own=[gridwtp2]own) ([gridwtp1]renew=[gridwtp2]renew) ([gridwtp1]risk=[gridwtp2]risk) ([gridwtp1]aware=[gridwtp2]aware) ([gridwtp1]conc=[gridwtp2]conc)
*** results are not significant, the dependent variables can constrain their independent variables

** average marginal effects of the parameters which gives the actual percentage chance of each increased variable
margins, dydx(*)

** model without logging bid for more accurate WTP
biprobit (gridwtp1 = age fem marr educ size gridbid1 renew risk aware conc cred own inc) (gridwtp2 = age fem marr educ size gridbid2 renew risk aware conc cred own inc), robust

** estimating WTP using Krinsky & Robb procedure
wtpcikr gridbid1 age fem marr educ size renew risk aware conc cred own inc, reps(20000) equation(gridwtp1) meanl

** estimating WTP using Delta method
nlcom (meanwtp_q1: -([gridwtp1]_cons+[gridwtp1]age*49.51439+[gridwtp1]female*.5647482+[gridwtp1]marr*.6726619+[gridwtp1]educ*4.917266+[gridwtp1]size*4.920863+[gridwtp1]renew*0.7769784+[gridwtp1]risk*.5395683+[gridwtp1]aware*3.413669+[gridwtp1]conc*4.230216+[gridwtp1]cred*0.8848921+[gridwtp1]own*0.7517986+[gridwtp1]inc*2.539568/[gridwtp1]gridbid1))


// IV. Model for Grid-tied product using single dependent (univariate) variables

** define the constrained variables (determined through the Walds test for paired parameters)
constraint define 1 [gridwtp1]_cons=[gridwtp2]_cons
constraint define 2 [gridwtp1]lngridbid1=[gridwtp2]lngridbid2
constraint define 3 [gridwtp1]inc=[gridwtp2]inc
constraint define 4 [gridwtp1]age=[gridwtp2]age
constraint define 5 [gridwtp1]female=[gridwtp2]female
constraint define 6 [gridwtp1]marr=[gridwtp2]marr
constraint define 7 [gridwtp1]educ=[gridwtp2]educ
constraint define 8 [gridwtp1]size=[gridwtp2]size
constraint define 9 [gridwtp1]own=[gridwtp2]own
constraint define 10 [gridwtp1]renew=[gridwtp2]renew
constraint define 11 [gridwtp1]aware=[gridwtp2]aware
constraint define 12 [gridwtp1]conc=[gridwtp2]conc
constraint define 13 [gridwtp1]risk=[gridwtp2]risk

** bivariate probit model with robust standard errors
biprobit (gridwtp1 = age fem marr educ size lngridbid1 renew risk aware conc cred own inc) (gridwtp2 = age fem marr educ size lngridbid2 renew risk aware conc cred own inc), const(1 2 3 4 5 6 7 8 9 10 11 12 13) robust

** Perform Wald test for parameters of recent model
test age female marr educ size [gridwtp1]lngridbid1 [gridwtp2]lngridbid2 renew risk aware conc cred own inc

** average marginal effects of the parameters which gives the actual percentage chance of each increased variable
margins, dydx(*)

** model without logging bid for more accurate WTP
constraint define 2 [gridwtp1]gridbid1=[gridwtp2]gridbid2
biprobit (gridwtp1 = age fem marr educ size gridbid1 renew risk aware conc cred own inc) (gridwtp2 = age fem marr educ size gridbid2 renew risk aware conc cred own inc), const(1 2 3 4 5 6 7 8 9 10 11 12 13) robust

** estimating WTP using Krinsky & Robb procedure
wtpcikr gridbid1 age fem marr educ size renew risk aware conc cred own inc, reps(20000) equation(gridwtp1) meanl

** estimating WTP using Delta method
nlcom (meanwtp_q1: -([gridwtp1]_cons+[gridwtp1]age*49.51439+[gridwtp1]female*.5647482+[gridwtp1]marr*.6726619+[gridwtp1]educ*4.917266+[gridwtp1]size*4.920863+[gridwtp1]renew*0.7769784+[gridwtp1]aware*3.413669+[gridwtp1]risk*.5395683+[gridwtp1]conc*4.230216+[gridwtp1]cred*0.8848921+[gridwtp1]own*0.7517986+[gridwtp1]inc*2.539568/[gridwtp1]gridbid1))
*** the Delta method has significant p-value, thus this estimate is used for the population's average WTP

// V. Model for Hybrid product type using joint dependent (bivariate) variables w/o income variable

** bivariate probit model for grid-tied with robust standard errors
biprobit (hybrwtp1 = age fem marr educ size lnhybrbid1 renew aware risk conc cred own) (hybrwtp2 = age fem marr educ size lnhybrbid2 renew aware risk conc cred own), robust

** Perform Wald test for parameters of recent model
test age female marr educ size [hybrwtp1]lnhybrbid1 [hybrwtp2]lnhybrbid2 renew aware risk conc cred own

** Wald test for parameters between the pairs of the parameters
test ([hybrwtp1]_cons=[hybrwtp2]_cons) ([hybrwtp1]lnhybrbid1=[hybrwtp2]lnhybrbid2) ([hybrwtp1]age=[hybrwtp2]age) ([hybrwtp1]female=[hybrwtp2]female) ([hybrwtp1]marr=[hybrwtp2]marr) ([hybrwtp1]educ=[hybrwtp2]educ) ([hybrwtp1]size=[hybrwtp2]size) ([hybrwtp1]cred=[hybrwtp2]cred) ([hybrwtp1]own=[hybrwtp2]own) ([hybrwtp1]renew=[hybrwtp2]renew) ([hybrwtp1]aware=[hybrwtp2]aware) ([hybrwtp1]conc=[hybrwtp2]conc) ([hybrwtp1]risk=[hybrwtp2]risk) 

** average marginal effects of the parameters which gives the actual percentage chance of each increased variable
margins, dydx(*)

** model without logging bid for more accurate WTP
biprobit (hybrwtp1 = age fem marr educ size hybrbid1 renew aware risk conc cred own) (hybrwtp2 = age fem marr educ size hybrbid2 renew aware risk conc cred own), robust

** estimating WTP using Krinsky & Robb procedure
wtpcikr hybrbid1 age fem marr educ size renew aware risk conc cred own, reps(20000) equation(hybrwtp1) meanl

** estimating WTP using Delta method
nlcom (meanwtp_q1: -([hybrwtp1]_cons+[hybrwtp1]age*49.51439+[hybrwtp1]female*.5647482+[hybrwtp1]marr*.6726619+[hybrwtp1]educ*4.917266+[hybrwtp1]size*4.920863+[hybrwtp1]renew*.7769784+[hybrwtp1]aware*3.413669+[hybrwtp1]risk*.5395683 +[hybrwtp1]conc*4.230216+[hybrwtp1]cred*0.8848921+[hybrwtp1]own*0.7517986/[hybrwtp1]hybrbid1))


// VI. Model for Hybrid product type using joint dependent (bivariate) variables w/ income variable

** bivariate probit model for grid-tied with robust standard errors
biprobit (hybrwtp1 = age fem marr educ size lnhybrbid1 renew aware risk conc cred own inc) (hybrwtp2 = age fem marr educ size lnhybrbid2 renew aware risk conc cred own inc), robust

** Perform Wald test for parameters of recent model
test age female marr educ size [hybrwtp1]lnhybrbid1 [hybrwtp2]lnhybrbid2 renew aware risk conc cred own inc
*** significant, the variables are jointly significant

** Wald test for parameters between the pairs of the parameters
test ([hybrwtp1]_cons=[hybrwtp2]_cons) ([hybrwtp1]lnhybrbid1=[hybrwtp2]lnhybrbid2) ([hybrwtp1]inc=[hybrwtp2]inc) ([hybrwtp1]age=[hybrwtp2]age) ([hybrwtp1]female=[hybrwtp2]female) ([hybrwtp1]marr=[hybrwtp2]marr) ([hybrwtp1]educ=[hybrwtp2]educ) ([hybrwtp1]size=[hybrwtp2]size) ([hybrwtp1]cred=[hybrwtp2]cred) ([hybrwtp1]own=[hybrwtp2]own) ([hybrwtp1]renew=[hybrwtp2]renew) ([hybrwtp1]aware=[hybrwtp2]aware) ([hybrwtp1]conc=[hybrwtp2]conc) ([hybrwtp1]risk=[hybrwtp2]risk) 
***not significant, the dependent variables can have the same coefficients

** average marginal effects of the parameters which gives the actual percentage chance of each increased variable
margins, dydx(*)

** model without logging bid for more accurate WTP
biprobit (hybrwtp1 = age fem marr educ size hybrbid1 renew aware risk conc cred own inc) (hybrwtp2 = age fem marr educ size hybrbid2 renew aware risk conc cred own inc), robust

** estimating WTP using Krinsky & Robb procedure
wtpcikr hybrbid1 age fem marr educ size renew aware risk conc cred own inc, reps(20000) equation(hybrwtp1) meanl

** estimating WTP using Delta method
nlcom (meanwtp_q1: -([hybrwtp1]_cons+[hybrwtp1]age*49.51439+[hybrwtp1]female*.5647482+[hybrwtp1]marr*.6726619+[hybrwtp1]educ*4.917266+[hybrwtp1]size*4.920863+[hybrwtp1]renew*.7769784+[hybrwtp1]aware*3.413669+[hybrwtp1]risk*.5395683 +[hybrwtp1]conc*4.230216+[hybrwtp1]cred*0.8848921+[hybrwtp1]own*0.7517986+[hybrwtp1]inc*2.539568/[hybrwtp1]hybrbid1))


// VII. Model for Hybrid product type using single dependent (univariate) variables w/ income variable

** define the constrained variables (determined through the Walds test for paired parameters)
constraint define 1 [hybrwtp1]_cons=[hybrwtp2]_cons
constraint define 2 [hybrwtp1]lnhybrbid1=[hybrwtp2]lnhybrbid2
constraint define 3 [hybrwtp1]inc=[hybrwtp2]inc
constraint define 4 [hybrwtp1]age=[hybrwtp2]age
constraint define 5 [hybrwtp1]female=[hybrwtp2]female
constraint define 6 [hybrwtp1]marr=[hybrwtp2]marr
constraint define 7 [hybrwtp1]educ=[hybrwtp2]educ
constraint define 8 [hybrwtp1]size=[hybrwtp2]size
constraint define 9 [hybrwtp1]own=[hybrwtp2]own
constraint define 10 [hybrwtp1]renew=[hybrwtp2]renew
constraint define 11 [hybrwtp1]aware=[hybrwtp2]aware
constraint define 12 [hybrwtp1]conc=[hybrwtp2]conc
constraint define 13 [hybrwtp1]risk=[hybrwtp2]risk

** bivariate probit model with robust standard errors
biprobit (hybrwtp1 = age fem marr educ size lnhybrbid1 renew aware risk conc cred own inc) (hybrwtp2 = age fem marr educ size lnhybrbid2 renew aware risk conc cred own inc), const(1 2 3 4 5 6 7 8 9 10 11 12 13) robust

** Perform Wald test for parameters of recent model
test age female marr educ size [hybrwtp1]lnhybrbid1 [hybrwtp2]lnhybrbid2 renew aware risk conc cred own inc
*** significant, the variables are jointly significant

** average marginal effects of the parameters which gives the actual percentage chance of each increased variable
margins, dydx(*)

** model without logging bid for more accurate WTP
constraint define 2 [hybrwtp1]hybrbid1=[hybrwtp2]hybrbid2
biprobit (hybrwtp1 = age fem marr educ size hybrbid1 renew aware risk conc cred own inc) (hybrwtp2 = age fem marr educ size hybrbid2 renew aware risk conc cred own inc), const(1 2 3 4 5 6 7 8 9 10 11 12 13) robust

** estimating WTP using Krinsky & Robb procedure
wtpcikr hybrbid1 age fem marr educ size renew aware risk conc cred own inc, reps(20000) equation(hybrwtp1) meanl

** estimating WTP using Delta method
nlcom (meanwtp_q1: -([hybrwtp1]_cons+[hybrwtp1]age*49.51439+[hybrwtp1]female*.5647482+[hybrwtp1]marr*.6726619+[hybrwtp1]educ*4.917266+[hybrwtp1]size*4.920863+[hybrwtp1]renew*.7769784+[hybrwtp1]aware*3.413669+[hybrwtp1]risk*.5395683 +[hybrwtp1]conc*4.230216+[hybrwtp1]cred*0.8848921+[hybrwtp1]own*0.7517986+[hybrwtp1]inc*2.539568/[hybrwtp1]hybrbid1))



