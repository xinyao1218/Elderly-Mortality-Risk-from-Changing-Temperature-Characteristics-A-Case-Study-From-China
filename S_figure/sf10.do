*==============================================================================* 
* Project: Temperature and China Elderly Death          					   *
* Version:    									    				           *   
* Date:  				                                                       *
* Author: Xin Yao  					                                           *    
*==============================================================================*


* set directories 
clear all
set maxvar  30000
set more off



global dir "C:\Users\yaoxin\Desktop\Death_elderly_Temperature_China"
global data "$dir/data"
global table "$dir/table"
global figure "$dir/figure"

********************************************************************************
*
* sf10:Residence and income heterogeneity on mortality risk of older adults to changes in temperature 
*
********************************************************************************
	
	use "$data/main.dta", clear
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	
	gen group_income=1
	replace group_income=2 if(income>=0.22&income<0.6)
	replace group_income=3 if(income>=0.6&income<1.5)
	replace group_income=4 if(income>=1.5&income<3.8)
	replace group_income=5 if(income>=3.8)
	replace group_income=. if(income==.)
	gen inn=area*5+group_income
	
	
	reghdfe death c.mean_maxhi##c.mean_maxhi#i.area c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	sum mean_maxhi
	global Min: dis %4.0f r(min)
	global Max: dis %4.0f r(max)
	global Grid = ($Max-$Min)/100
	
    margins area, dydx(mean_maxhi) at(mean_maxhi=($Max($Grid)$Min)) post
	parmest , saving($figure/sf10/sf10_mean_area.dta, replace)
	
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi##c.TD95_adthi#i.area c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	sum TD95_adthi
	global Min: dis %4.0f r(min)
	global Max: dis %4.0f r(max)
	global Grid = ($Max-$Min)/100
	
    margins area, dydx(TD95_adthi) at(TD95_adthi=($Max($Grid)$Min)) post
	parmest , saving($figure/sf10/sf10_td95_area.dta, replace)
	


	reghdfe death c.mean_maxhi##c.mean_maxhi#i.inn c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	sum mean_maxhi
	global Min: dis %4.0f r(min)
	global Max: dis %4.0f r(max)
	global Grid = ($Max-$Min)/100
	
    margins inn, dydx(mean_maxhi) at(mean_maxhi=($Max($Grid)$Min)) post
	parmest , saving($figure/sf10/sf10_mean_inn.dta, replace)
	
	
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi##c.TD95_adthi#i.inn c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	
	sum TD95_adthi
	global Min: dis %4.0f r(min)
	global Max: dis %4.0f r(max)
	global Grid = ($Max-$Min)/100
	
    margins inn, dydx(TD95_adthi) at(TD95_adthi=($Max($Grid)$Min)) post
	parmest , saving($figure/sf10/sf10_td95_inn.dta, replace)
	
	
********************************************************************************

	* sf10_1
	
		cd $figure/sf10
		openall, storefilename(fn)
		keep if fn=="sf10_mean_area.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.3+1.7
		gen group=0 if parm2=="0.area"
		replace group=1 if parm2=="1.area"
		gen key=_n
		sort key
		save "$figure/sf10/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf10/temp.dta"
		gen yline=0
		replace estimate=estimate*100*4.49942 if group==0
		replace max95=max95*100*4.49942 if group==0
		replace min95=min95*100*4.49942 if group==0
		
		replace estimate=estimate*100*4.994595 if group==1
		replace max95=max95*100*4.994595 if group==1
		replace min95=min95*100*4.994595 if group==1
		
		graph twoway hist mean_maxhi if sex==0, width(0.5) percent color(ebblue*0.8%60) yaxis(2)        ///
			||   hist mean_maxhi if sex==1, width(0.5) percent color(orange_red*0.6%60) yaxis(2)       ///
            ||   rarea max95 min95 no if group==0,color(ebblue*0.8%60) ///
			||   rarea max95 min95 no if group==1,color(orange_red*0.6%60) ///
			||   line estimate  no if group==0,clpattern(solid) clwidth(medium) clcolor(ebblue*1.1) yaxis(1)  ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(orange_red*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(2 8 14 20 26 32, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///     
				 xscale(noline)  ///
				 legend(order(5 6) label(5 "Residence:Rural") label(6 "Residence:City or town")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				 xtitle("Annual mean temperature index (℃)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean temperature index"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf10/sf10_1", replace
		 graph export "$figure/sf10/sf10_1.png", replace width(3000)
		 erase "$figure/sf10/temp.dta"
		 
********************************************************************************

	* sf10_2
	
		cd $figure/sf10
		openall, storefilename(fn)
		keep if fn=="sf10_td95_area.dta"
		split parm, p("#")
		split parm1, p(".")
		gen no=real(parm11)
		replace no=(102-no)*0.37-0.37
		gen group=0 if parm2=="0.area"
		replace group=1 if parm2=="1.area"
		gen key=_n
		sort key
		save "$figure/sf10/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf10/temp.dta"
		gen yline=0
		replace estimate=estimate*100*7.183478 if group==0
		replace max95=max95*100*7.183478 if group==0
		replace min95=min95*100*7.183478 if group==0
		
		replace estimate=estimate*100*6.692994 if group==1
		replace max95=max95*100*6.692994 if group==1
		replace min95=min95*100*6.692994 if group==1
		
		graph twoway hist TD95_adthi if sex==0, width(0.5) percent color(ebblue*0.8%60) yaxis(2)        ///
			||   hist TD95_adthi if sex==1, width(0.5) percent color(orange_red*0.6%60) yaxis(2)       ///
            ||   rarea max95 min95 no if group==0,color(ebblue*0.8%60) ///
			||   rarea max95 min95 no if group==1,color(orange_red*0.6%60) ///
			||   line estimate  no if group==0,clpattern(solid) clwidth(medium) clcolor(ebblue*1.1) yaxis(1)  ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(orange_red*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 7 14 21 28 35, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///   
				 xscale(noline)  ///
				 legend(order(5 6) label(5 "Residence:Rural") label(6 "Residence:City or town")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				 xtitle("Number of days with EHF>0 (days)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Number of days with EHF>0 "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf10/sf10_2", replace
		 graph export "$figure/sf10/sf10_2.png", replace width(3000)
		 erase "$figure/sf10/temp.dta"
		 
********************************************************************************

	* sf10_3
	
		cd $figure/sf10
		openall, storefilename(fn)
		keep if fn=="sf10_mean_inn.dta"
		split parm, p("#")
		split parm1, p(".")
		keep if parm2=="1.inn"|parm2=="6.inn"
		gen no=real(parm11)
		replace no=(102-no)*0.3+1.7
		gen group=0 if parm2=="1.inn"
		replace group=1 if parm2=="6.inn"
		gen key=_n
		sort key
		save "$figure/sf10/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf10/temp.dta"
		gen yline=0
		replace estimate=estimate*100*4.473076 if group==0
		replace max95=max95*100*4.473076 if group==0
		replace min95=min95*100*4.473076 if group==0
		replace estimate=estimate*100*4.997981 if group==1
		replace max95=max95*100*4.997981 if group==1
		replace min95=min95*100*4.997981 if group==1
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen inn=area*5+group_income
		
		graph twoway hist mean_maxhi if inn==1, width(0.5) percent color(blue*0.8%60) yaxis(2)        ///
			||   hist mean_maxhi if inn==6, width(0.5) percent color(red*0.6%60) yaxis(2)       ///
            ||   rarea max95 min95 no if group==0,color(blue*0.8%60) ///
			||   rarea max95 min95 no if group==1,color(red*0.6%60) ///
			||   line estimate  no if group==0,clpattern(solid) clwidth(medium) clcolor(blue*1.1) yaxis(1)  ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(red*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(2 8 14 20 26 32, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(5 6) label(5 "Income:Lowest & Residence:Rural") label(6 "Income:Lowest & Residence:City or town")  ring(0) pos(12) rowgap(0.5) cols(1) size(2.8))  ///
				 xtitle("Annual mean temperature index (℃)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean temperature index"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf10/sf10_3", replace
		 graph export "$figure/sf10/sf10_3.png", replace width(3000)
		 erase "$figure/sf10/temp.dta"
		 
********************************************************************************

	* sf10_4
	
		cd $figure/sf10
		openall, storefilename(fn)
		keep if fn=="sf10_mean_inn.dta"
		split parm, p("#")
		split parm1, p(".")
		keep if parm2=="2.inn"|parm2=="7.inn"
		gen no=real(parm11)
		replace no=(102-no)*0.3+1.7
		gen group=0 if parm2=="2.inn"
		replace group=1 if parm2=="7.inn"
		gen key=_n
		sort key
		save "$figure/sf10/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf10/temp.dta"
		gen yline=0
		replace estimate=estimate*100*4.570945 if group==0
		replace max95=max95*100*4.570945 if group==0
		replace min95=min95*100*4.570945 if group==0
		replace estimate=estimate*100*5.062327 if group==1
		replace max95=max95*100*5.062327 if group==1
		replace min95=min95*100*5.062327 if group==1
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen inn=area*5+group_income
		
		graph twoway hist mean_maxhi if inn==2, width(0.5) percent color(blue*0.8%60) yaxis(2)        ///
			||   hist mean_maxhi if inn==7, width(0.5) percent color(red*0.6%60) yaxis(2)       ///
            ||   rarea max95 min95 no if group==0,color(blue*0.8%60) ///
			||   rarea max95 min95 no if group==1,color(red*0.6%60) ///
			||   line estimate  no if group==0,clpattern(solid) clwidth(medium) clcolor(blue*1.1) yaxis(1)  ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(red*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(2 8 14 20 26 32, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(5 6) label(5 "Income:Low & Residence:Rural") label(6 "Income:Low & Residence:City or town")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				 xtitle("Annual mean temperature index (℃)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean temperature index"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf10/sf10_4", replace
		 graph export "$figure/sf10/sf10_4.png", replace width(3000)
		 erase "$figure/sf10/temp.dta"
		 
********************************************************************************

	* sf10_5
	
		cd $figure/sf10
		openall, storefilename(fn)
		keep if fn=="sf10_mean_inn.dta"
		split parm, p("#")
		split parm1, p(".")
		keep if parm2=="3.inn"|parm2=="8.inn"
		gen no=real(parm11)
		replace no=(102-no)*0.3+1.7
		gen group=0 if parm2=="3.inn"
		replace group=1 if parm2=="8.inn"
		gen key=_n
		sort key
		save "$figure/sf10/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf10/temp.dta"
		gen yline=0
		replace estimate=estimate*100*4.545009 if group==0
		replace max95=max95*100*4.545009 if group==0
		replace min95=min95*100*4.545009 if group==0
		replace estimate=estimate*100*4.937198 if group==1
		replace max95=max95*100*4.937198 if group==1
		replace min95=min95*100*4.937198 if group==1
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen inn=area*5+group_income
		
		graph twoway hist mean_maxhi if inn==3, width(0.5) percent color(blue*0.8%60) yaxis(2)        ///
			||   hist mean_maxhi if inn==8, width(0.5) percent color(red*0.6%60) yaxis(2)       ///
            ||   rarea max95 min95 no if group==0,color(blue*0.8%60) ///
			||   rarea max95 min95 no if group==1,color(red*0.6%60) ///
			||   line estimate  no if group==0,clpattern(solid) clwidth(medium) clcolor(blue*1.1) yaxis(1)  ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(red*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(2 8 14 20 26 32, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(5 6) label(5 "Income:Middle & Residence:Rural") label(6 "Income:Middle & Residence:City or town")  ring(0) pos(12) rowgap(0.5) cols(1) size(2.8))  ///
				 xtitle("Annual mean temperature index (℃)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean temperature index"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf10/sf10_5", replace
		 graph export "$figure/sf10/sf10_5.png", replace width(3000)
		 erase "$figure/sf10/temp.dta"
		 
********************************************************************************

	* sf10_6
	
		cd $figure/sf10
		openall, storefilename(fn)
		keep if fn=="sf10_mean_inn.dta"
		split parm, p("#")
		split parm1, p(".")
		keep if parm2=="4.inn"|parm2=="9.inn"
		gen no=real(parm11)
		replace no=(102-no)*0.3+1.7
		gen group=0 if parm2=="4.inn"
		replace group=1 if parm2=="9.inn"
		gen key=_n
		sort key
		save "$figure/sf10/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf10/temp.dta"
		gen yline=0
		replace estimate=estimate*100*4.532459 if group==0
		replace max95=max95*100*4.532459 if group==0
		replace min95=min95*100*4.532459 if group==0
		replace estimate=estimate*100*5.087413 if group==1
		replace max95=max95*100*5.087413 if group==1
		replace min95=min95*100*5.087413 if group==1
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen inn=area*5+group_income
		
		graph twoway hist mean_maxhi if inn==4, width(0.5) percent color(blue*0.8%60) yaxis(2)        ///
			||   hist mean_maxhi if inn==9, width(0.5) percent color(red*0.6%60) yaxis(2)       ///
            ||   rarea max95 min95 no if group==0,color(blue*0.8%60) ///
			||   rarea max95 min95 no if group==1,color(red*0.6%60) ///
			||   line estimate  no if group==0,clpattern(solid) clwidth(medium) clcolor(blue*1.1) yaxis(1)  ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(red*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(2 8 14 20 26 32, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(5 6) label(5 "Income:High & Residence:Rural") label(6 "Income:High & Residence:City or town")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				 xtitle("Annual mean temperature index (℃)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean temperature index"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf10/sf10_6", replace
		 graph export "$figure/sf10/sf10_6.png", replace width(3000)
		 erase "$figure/sf10/temp.dta"
		 
********************************************************************************

	* sf10_7
	
		cd $figure/sf10
		openall, storefilename(fn)
		keep if fn=="sf10_mean_inn.dta"
		split parm, p("#")
		split parm1, p(".")
		keep if parm2=="5.inn"|parm2=="10.inn"
		gen no=real(parm11)
		replace no=(102-no)*0.3+1.7
		gen group=0 if parm2=="5.inn"
		replace group=1 if parm2=="10.inn"
		gen key=_n
		sort key
		save "$figure/sf10/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf10/temp.dta"
		gen yline=0
		replace estimate=estimate*100*4.216254 if group==0
		replace max95=max95*100*4.216254 if group==0
		replace min95=min95*100*4.216254 if group==0
		replace estimate=estimate*100*4.814611 if group==1
		replace max95=max95*100*4.814611 if group==1
		replace min95=min95*100*4.814611 if group==1
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen inn=area*5+group_income
		
		graph twoway hist mean_maxhi if inn==5, width(0.5) percent color(blue*0.8%60) yaxis(2)        ///
			||   hist mean_maxhi if inn==10, width(0.5) percent color(red*0.6%60) yaxis(2)       ///
            ||   rarea max95 min95 no if group==0,color(blue*0.8%60) ///
			||   rarea max95 min95 no if group==1,color(red*0.6%60) ///
			||   line estimate  no if group==0,clpattern(solid) clwidth(medium) clcolor(blue*1.1) yaxis(1)  ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(red*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(2 8 14 20 26 32, nogrid labsize(3.5))  ///
				 ylabel(-15 -10 -5 0 5 10 15 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(5 6) label(5 "Income:Highest & Residence:Rural") label(6 "Income:Highest & Residence:City or town")  ring(0) pos(12) rowgap(0.5) cols(1) size(2.8))  ///
				 xtitle("Annual mean temperature index (℃)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Annual mean temperature index"" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf10/sf10_7", replace
		 graph export "$figure/sf10/sf10_7.png", replace width(3000)
		 erase "$figure/sf10/temp.dta"
		 
********************************************************************************

	* sf10_8
	
		cd $figure/sf10
		openall, storefilename(fn)
		keep if fn=="sf10_td95_inn.dta"
		split parm, p("#")
		split parm1, p(".")
		keep if parm2=="1.inn"|parm2=="6.inn"
		gen no=real(parm11)
		replace no=(102-no)*0.37-0.37
		gen group=0 if parm2=="1.inn"
		replace group=1 if parm2=="6.inn"
		gen key=_n
		sort key
		save "$figure/sf10/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf10/temp.dta"
		gen yline=0
		replace estimate=estimate*100*6.54791 if group==0
		replace max95=max95*100*6.54791 if group==0
		replace min95=min95*100*6.54791 if group==0
		replace estimate=estimate*100*6.351492 if group==1
		replace max95=max95*100*6.351492 if group==1
		replace min95=min95*100*6.351492 if group==1
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen inn=area*5+group_income
		
		graph twoway hist TD95_adthi if inn==1, width(0.5) percent color(blue*0.8%60) yaxis(2)        ///
			||   hist TD95_adthi if inn==6, width(0.5) percent color(red*0.6%60) yaxis(2)       ///
            ||   rarea max95 min95 no if group==0,color(blue*0.8%60) ///
			||   rarea max95 min95 no if group==1,color(red*0.6%60) ///
			||   line estimate  no if group==0,clpattern(solid) clwidth(medium) clcolor(blue*1.1) yaxis(1)  ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(red*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 7 14 21 28 35, nogrid labsize(3.5))  ///
				 ylabel(-18 -12 -6 0 6 12 18 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(5 6) label(5 "Income:Lowest & Residence:Rural") label(6 "Income:Lowest & Residence:City or town")  ring(0) pos(12) rowgap(0.5) cols(1) size(2.8))  ///
				 xtitle("Number of days with EHF>0 (days)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Number of days with EHF>0 "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf10/sf10_8", replace
		 graph export "$figure/sf10/sf10_8.png", replace width(3000)
		 erase "$figure/sf10/temp.dta"
		 
********************************************************************************

	* sf10_9
	
		cd $figure/sf10
		openall, storefilename(fn)
		keep if fn=="sf10_td95_inn.dta"
		split parm, p("#")
		split parm1, p(".")
		keep if parm2=="2.inn"|parm2=="7.inn"
		gen no=real(parm11)
		replace no=(102-no)*0.37-0.37
		gen group=0 if parm2=="2.inn"
		replace group=1 if parm2=="7.inn"
		gen key=_n
		sort key
		save "$figure/sf10/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf10/temp.dta"
		gen yline=0
		replace estimate=estimate*100*7.087975 if group==0
		replace max95=max95*100*7.087975 if group==0
		replace min95=min95*100*7.087975 if group==0
		replace estimate=estimate*100*6.510437 if group==1
		replace max95=max95*100*6.510437 if group==1
		replace min95=min95*100*6.510437 if group==1
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen inn=area*5+group_income
		
		graph twoway hist TD95_adthi if inn==2, width(0.5) percent color(blue*0.8%60) yaxis(2)        ///
			||   hist TD95_adthi if inn==7, width(0.5) percent color(red*0.6%60) yaxis(2)       ///
            ||   rarea max95 min95 no if group==0,color(blue*0.8%60) ///
			||   rarea max95 min95 no if group==1,color(red*0.6%60) ///
			||   line estimate  no if group==0,clpattern(solid) clwidth(medium) clcolor(blue*1.1) yaxis(1)  ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(red*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 7 14 21 28 35, nogrid labsize(3.5))  ///
				 ylabel(-18 -12 -6 0 6 12 18 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(5 6) label(5 "Income:Low & Residence:Rural") label(6 "Income:Low & Residence:City or town")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				 xtitle("Number of days with EHF>0 (days)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Number of days with EHF>0 "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf10/sf10_9", replace
		 graph export "$figure/sf10/sf10_9.png", replace width(3000)
		 erase "$figure/sf10/temp.dta"
		 
********************************************************************************

	* sf10_10
	
		cd $figure/sf10
		openall, storefilename(fn)
		keep if fn=="sf10_td95_inn.dta"
		split parm, p("#")
		split parm1, p(".")
		keep if parm2=="3.inn"|parm2=="8.inn"
		gen no=real(parm11)
		replace no=(102-no)*0.37-0.37
		gen group=0 if parm2=="3.inn"
		replace group=1 if parm2=="8.inn"
		gen key=_n
		sort key
		save "$figure/sf10/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf10/temp.dta"
		gen yline=0
		replace estimate=estimate*100*7.538245 if group==0
		replace max95=max95*100*7.538245 if group==0
		replace min95=min95*100*7.538245 if group==0
		replace estimate=estimate*100*6.467514 if group==1
		replace max95=max95*100*6.467514 if group==1
		replace min95=min95*100*6.467514 if group==1
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen inn=area*5+group_income
		
		graph twoway hist TD95_adthi if inn==3, width(0.5) percent color(blue*0.8%60) yaxis(2)        ///
			||   hist TD95_adthi if inn==8, width(0.5) percent color(red*0.6%60) yaxis(2)       ///
            ||   rarea max95 min95 no if group==0,color(blue*0.8%60) ///
			||   rarea max95 min95 no if group==1,color(red*0.6%60) ///
			||   line estimate  no if group==0,clpattern(solid) clwidth(medium) clcolor(blue*1.1) yaxis(1)  ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(red*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 7 14 21 28 35, nogrid labsize(3.5))  ///
				 ylabel(-18 -12 -6 0 6 12 18 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(5 6) label(5 "Income:Middle & Residence:Rural") label(6 "Income:Middle & Residence:City or town")  ring(0) pos(12) rowgap(0.5) cols(1) size(2.8))  ///
				 xtitle("Number of days with EHF>0 (days)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Number of days with EHF>0 "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf10/sf10_10", replace
		 graph export "$figure/sf10/sf10_10.png", replace width(3000)
		 erase "$figure/sf10/temp.dta"
		 
********************************************************************************

	* sf10_11
	
		cd $figure/sf10
		openall, storefilename(fn)
		keep if fn=="sf10_td95_inn.dta"
		split parm, p("#")
		split parm1, p(".")
		keep if parm2=="4.inn"|parm2=="9.inn"
		gen no=real(parm11)
		replace no=(102-no)*0.37-0.37
		gen group=0 if parm2=="4.inn"
		replace group=1 if parm2=="9.inn"
		gen key=_n
		sort key
		save "$figure/sf10/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf10/temp.dta"
		gen yline=0
		replace estimate=estimate*100*7.746528 if group==0
		replace max95=max95*100*7.746528 if group==0
		replace min95=min95*100*7.746528 if group==0
		replace estimate=estimate*100*6.827972 if group==1
		replace max95=max95*100*6.827972 if group==1
		replace min95=min95*100*6.827972 if group==1
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen inn=area*5+group_income
		
		graph twoway hist TD95_adthi if inn==4, width(0.5) percent color(blue*0.8%60) yaxis(2)        ///
			||   hist TD95_adthi if inn==9, width(0.5) percent color(red*0.6%60) yaxis(2)       ///
            ||   rarea max95 min95 no if group==0,color(blue*0.8%60) ///
			||   rarea max95 min95 no if group==1,color(red*0.6%60) ///
			||   line estimate  no if group==0,clpattern(solid) clwidth(medium) clcolor(blue*1.1) yaxis(1)  ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(red*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 7 14 21 28 35, nogrid labsize(3.5))  ///
				 ylabel(-18 -12 -6 0 6 12 18 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(5 6) label(5 "Income:High & Residence:Rural") label(6 "Income:High & Residence:City or town")  ring(0) pos(12) rowgap(0.5) cols(1) size(3))  ///
				 xtitle("Number of days with EHF>0 (days)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Number of days with EHF>0 "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf10/sf10_11", replace
		 graph export "$figure/sf10/sf10_11.png", replace width(3000)
		 erase "$figure/sf10/temp.dta"
		 
********************************************************************************

	* sf10_12
	
		cd $figure/sf10
		openall, storefilename(fn)
		keep if fn=="sf10_td95_inn.dta"
		split parm, p("#")
		split parm1, p(".")
		keep if parm2=="5.inn"|parm2=="10.inn"
		gen no=real(parm11)
		replace no=(102-no)*0.37-0.37
		gen group=0 if parm2=="5.inn"
		replace group=1 if parm2=="10.inn"
		gen key=_n
		sort key
		save "$figure/sf10/temp.dta",replace
		use "$data/main.dta", clear
		gen key=_n
		sort key
		merge key using "$figure/sf10/temp.dta"
		gen yline=0
		replace estimate=estimate*100*7.142036 if group==0
		replace max95=max95*100*7.142036 if group==0
		replace min95=min95*100*7.142036 if group==0
		replace estimate=estimate*100*6.959673 if group==1
		replace max95=max95*100*6.959673 if group==1
		replace min95=min95*100*6.959673 if group==1
		gen group_income=1
		replace group_income=2 if(income>=0.22&income<0.6)
		replace group_income=3 if(income>=0.6&income<1.5)
		replace group_income=4 if(income>=1.5&income<3.8)
		replace group_income=5 if(income>=3.8)
		replace group_income=. if(income==.)
		gen inn=area*5+group_income
		
		graph twoway hist TD95_adthi if inn==5, width(0.5) percent color(blue*0.8%60) yaxis(2)        ///
			||   hist TD95_adthi if inn==10, width(0.5) percent color(red*0.6%60) yaxis(2)       ///
            ||   rarea max95 min95 no if group==0,color(blue*0.8%60) ///
			||   rarea max95 min95 no if group==1,color(red*0.6%60) ///
			||   line estimate  no if group==0,clpattern(solid) clwidth(medium) clcolor(blue*1.1) yaxis(1)  ///
			||   line estimate  no if group==1,clpattern(solid) clwidth(medium) clcolor(red*0.9) yaxis(1)  ///
			||   line yline  no,clpattern(dash) clwidth(medium)   clcolor(black)   ///
			||   ,    ///
				 xlabel(0 7 14 21 28 35, nogrid labsize(3.5))  ///
				 ylabel(-18 -12 -6 0 6 12 18 , axis(1) nogrid labsize(3.5))  ///
				 ylabel(0 4 8 12 16 20 24,axis(2) angle(270))  ///
				 yscale(noline alt)  ///
				 yscale(range(0 24) alt axis(2))  ///    
				 xscale(noline)  ///
				 legend(order(5 6) label(5 "Income:Highest & Residence:Rural") label(6 "Income:Highest & Residence:City or town")  ring(0) pos(12) rowgap(0.5) cols(1) size(2.8))  ///
				 xtitle("Number of days with EHF>0 (days)" , size(3.5))  ///
				 ytitle("Marginal effect on mortality risk of older adults""(% points per 1-s.d. increase)"" " , axis(1) size(3.5))  ///
				 ytitle("Frequency distributions of observed""moderating variables (%)"" ", axis(2) orientation(rvertical) size(3.5))  ///
				 title("Number of days with EHF>0 "" " , size(3.5)) ///
				 xsca(titlegap(2))  ///
				 ysca(titlegap(2))  ///
				 fysize(180) fxsize(200) ///
				 ysize(18) xsize(20) ///
				 scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
				 
		 graph save "$figure/sf10/sf10_12", replace
		 graph export "$figure/sf10/sf10_12.png", replace width(3000)
		 erase "$figure/sf10/temp.dta"
		 
********************************************************************************