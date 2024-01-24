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
* Figure 3: Assessing the heterogeneity in the mortality effect of temperature measures by demographics
*
********************************************************************************

	*regression_baseline
	
use "$data/main.dta", clear
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 

	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	
	parmest , saving($figure/fig3/fig3_reg_baseline.dta, replace)
	
********************************************************************************

	*regression_sex
	
use "$data/main.dta", clear
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 

	
	reghdfe death c.mean_maxhi#i.sex c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig3/fig3_reg_mean_sex.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi#i.sex c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig3/fig3_reg_sd_sex.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi#i.sex c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig3/fig3_reg_tn_sex.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi#i.sex c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig3/fig3_reg_td_sex.dta, replace)
	
********************************************************************************

	*regression_age
	
use "$data/main.dta", clear
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil  
	
	gen group_age=1
	replace group_age=2 if(trueage>=75&trueage<85)
	replace group_age=3 if(trueage>=85&trueage<95)
	replace group_age=4 if(trueage>=95)
	replace group_age=. if trueage==.
	replace group_age=. if trueage<65

	
	reghdfe death c.mean_maxhi#i.group_age c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig3/fig3_reg_mean_age.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi#i.group_age c.TN95_adthi c.TD95_adthi c.annual_pre_365  $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig3/fig3_reg_sd_age.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi#i.group_age c.TD95_adthi c.annual_pre_365 i.group_age $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig3/fig3_reg_tn_age.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi#i.group_age c.annual_pre_365 i.group_age $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig3/fig3_reg_td_age.dta, replace)

********************************************************************************

	*regression_BMI
	
use "$data/main.dta", clear
	
	global control sex trueage g101 g1021 h3 d1 smoke drink exercise area f1 income  hypertension diabetes heartdisease stroke_cvd asthma tuberculosis cataract glaucoma cancer gastric_ulcer parkinson bedsore arthritis dementia a2 meat fish egg bean veg tea garl a51 vegeta fruit f41 chil 
	
	gen BMI=g101/((g1021/100)*(g1021/100))
	replace BMI=0 if BMI<24
	replace BMI=2 if BMI>=28
	replace BMI=1 if BMI>=24


	reghdfe death c.mean_maxhi#i.BMI c.sd_meanhi c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig3/fig3_reg_mean_BMI.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi#i.BMI c.TN95_adthi c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig3/fig3_reg_sd_BMI.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi#i.BMI c.TD95_adthi c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig3/fig3_reg_tn_BMI.dta, replace)
	
	reghdfe death c.mean_maxhi c.sd_meanhi c.TN95_adthi c.TD95_adthi#i.BMI c.annual_pre_365 $control , absorb(prov#year prov#month) cluster(gbcode)
	parmest , saving($figure/fig3/fig3_reg_td_BMI.dta, replace)
	
	
*******************************************************************************

	* fig3_1
		cd $figure/fig3
		openall, storefilename(fn)
		keep if (parm == "mean_maxhi" & fn=="fig3_reg_baseline.dta") | parm == "0b.sex#c.mean_maxhi" | parm == "1.sex#c.mean_maxhi" | parm == "1b.group_age#c.mean_maxhi" | parm == "2.group_age#c.mean_maxhi" | parm == "3.group_age#c.mean_maxhi" | parm == "4.group_age#c.mean_maxhi" | parm == "0b.BMI#c.mean_maxhi" | parm == "1.BMI#c.mean_maxhi" | parm == "2.BMI#c.mean_maxhi"
		
		* group
		gen y=13 
		replace y=11 if parm=="0b.sex#c.mean_maxhi"
		replace y=10 if parm=="1.sex#c.mean_maxhi"
		replace y=8 if parm=="1b.group_age#c.mean_maxhi"
		replace y=7 if parm=="2.group_age#c.mean_maxhi"
		replace y=6 if parm=="3.group_age#c.mean_maxhi"
		replace y=5 if parm=="4.group_age#c.mean_maxhi"
		replace y=3 if parm=="0b.BMI#c.mean_maxhi"
		replace y=2 if parm=="1.BMI#c.mean_maxhi"
		replace y=1 if parm=="2.BMI#c.mean_maxhi"
		
		replace estimate=estimate*100*4.949718 if y==1
		replace min95=min95*100*4.949718 if y==1
		replace max95=max95*100*4.949718 if y==1
		
		replace estimate=estimate*100*4.601998 if y==2
		replace min95=min95*100*4.601998 if y==2
		replace max95=max95*100*4.601998 if y==2
		
		replace estimate=estimate*100*4.717299 if y==3
		replace min95=min95*100*4.717299 if y==3
		replace max95=max95*100*4.717299 if y==3
		
		replace estimate=estimate*100*4.850742 if y==5
		replace min95=min95*100*4.850742 if y==5
		replace max95=max95*100*4.850742 if y==5
		
		replace estimate=estimate*100*4.692696 if y==6
		replace min95=min95*100*4.692696 if y==6
		replace max95=max95*100*4.692696 if y==6
		
		replace estimate=estimate*100*4.637835 if y==7
		replace min95=min95*100*4.637835 if y==7
		replace max95=max95*100*4.637835 if y==7
		
		replace estimate=estimate*100*4.81732 if y==8
		replace min95=min95*100*4.81732 if y==8
		replace max95=max95*100*4.81732 if y==8
		
		replace estimate=estimate*100*4.838326 if y==10
		replace min95=min95*100*4.838326 if y==10
		replace max95=max95*100*4.838326 if y==10
		
		replace estimate=estimate*100*4.677362 if y==11
		replace min95=min95*100*4.677362 if y==11
		replace max95=max95*100*4.677362 if y==11
		
		replace estimate=estimate*100*4.74924 if y==13
		replace min95=min95*100*4.74924 if y==13
		replace max95=max95*100*4.74924 if y==13
		
		sort y
		keep parm estimate min95 max95 y
		

		label define ylabel			///
				13 " {it:Baseline} "				///
				11  " {it:Group by sex},Male "				///
				10  " Female "				///  
				8  " {it:Group by age},65-75 "				///
				7  " 75-85 "				///
				6  " 85-95 " ///
				5  " Over 95 " ///
				3  " {it:Group by BMI},Less than 24 " ///
				2  " 24-28 " ///
				1  " Over 28 " ///
				0  " "				///
				
			label values y ylabel
			
		graph twoway (bar estimate y if y == 13, horizontal color(gold*0.5) lcolor(gold*0.6) barw(0.8) lwidth(0.8)) ///
		             (bar estimate y if y < 13 & y > 9, horizontal color(red*0.5) lcolor(red*0.6) barw(0.8) lwidth(0.8)) ///
					 (bar estimate y if y < 9 & y > 4, horizontal color(blue*0.5) lcolor(blue*0.6) barw(0.8) lwidth(0.8)) ///
					 (bar estimate y if y < 4, horizontal color(green*0.5) lcolor(green*0.6) barw(0.8) lwidth(0.8)) ///
		             (rcap min95 max95 y if y == 13, horizontal lcolor(gold*0.6) lwidth(1)) ///
					 (rcap min95 max95 y if y < 13 & y > 9, horizontal lcolor(red*0.6) lwidth(1)) ///
					 (rcap min95 max95 y if y < 9 & y > 4, horizontal lcolor(blue*0.6) lwidth(1)) ///
					 (rcap min95 max95 y if y < 4, horizontal lcolor(green*0.6) lwidth(1)) ///
				     , scheme(s1mono) 	///	
					 xline(0, lwidth(thin)) ///
					 text(1 6 "2.87%", place(l) size(4)) ///
					 text(2 6 "2.09%", place(l) size(4)) ///
					 text(3 6 "2.05%", place(l) size(4)) ///
					 text(5 6 "3.38%", place(l) size(4)) ///
					 text(6 6 "2.34%", place(l) size(4)) ///
					 text(7 6 "1.03%", place(l) size(4)) ///
					 text(8 6 "0.73%", place(l) size(4)) ///
					 text(10 6 "2.31%", place(l) size(4)) ///
					 text(11 6 "1.93%", place(l) size(4)) ///
					 text(13 6 "2.10%", place(l) size(4)) ///
				     legend(off) ///
					 ylabel(1 2 3 5 6 7 8 10 11 13, valuelabel angle(0) nogrid labsize(4)) ///
				     yscale(range(0.5 13.5)) ///
					 ytitle("") xtitle("") ///
					 title(" "" a. Annual mean temperature "" index ", pos(12) size(4.5)) ///
					 xlabel(0 (2) 6, nogrid labsize(4)) ///
					 xscale(range(-0.6 6)) ///
					 fxsize(144) fysize(200) xsize(20) ysize(10) ///
					 xtitle(" " "Marginal effect " " (% per 1-s.d. increase) ",size(4) color(black))
					  
		graph save "$figure/fig3/fig3_1", replace
	
********************************************************************************

	* fig3_2
		cd $figure/fig3
		openall, storefilename(fn)
		keep if (parm == "sd_meanhi" & fn=="fig3_reg_baseline.dta") | parm == "0b.sex#c.sd_meanhi" | parm == "1.sex#c.sd_meanhi" | parm == "1b.group_age#c.sd_meanhi" | parm == "2.group_age#c.sd_meanhi" | parm == "3.group_age#c.sd_meanhi" | parm == "4.group_age#c.sd_meanhi" | parm == "0b.BMI#c.sd_meanhi" | parm == "1.BMI#c.sd_meanhi" | parm == "2.BMI#c.sd_meanhi"
		
		* group
		gen y=13 
		replace y=11 if parm=="0b.sex#c.sd_meanhi"
		replace y=10 if parm=="1.sex#c.sd_meanhi"
		replace y=8 if parm=="1b.group_age#c.sd_meanhi"
		replace y=7 if parm=="2.group_age#c.sd_meanhi"
		replace y=6 if parm=="3.group_age#c.sd_meanhi"
		replace y=5 if parm=="4.group_age#c.sd_meanhi"
		replace y=3 if parm=="0b.BMI#c.sd_meanhi"
		replace y=2 if parm=="1.BMI#c.sd_meanhi"
		replace y=1 if parm=="2.BMI#c.sd_meanhi"
		
		replace estimate=estimate*100*0.472572 if y==1
		replace min95=min95*100*0.472572 if y==1
		replace max95=max95*100*0.472572 if y==1
		
		replace estimate=estimate*100*0.4552368 if y==2
		replace min95=min95*100*0.4552368 if y==2
		replace max95=max95*100*0.4552368 if y==2
		
		replace estimate=estimate*100*0.453162 if y==3
		replace min95=min95*100*0.453162 if y==3
		replace max95=max95*100*0.453162 if y==3
		
		replace estimate=estimate*100*0.4750382 if y==5
		replace min95=min95*100*0.4750382 if y==5
		replace max95=max95*100*0.4750382 if y==5
		
		replace estimate=estimate*100*0.4450092 if y==6
		replace min95=min95*100*0.4450092 if y==6
		replace max95=max95*100*0.4450092 if y==6
		
		replace estimate=estimate*100*0.4483271 if y==7
		replace min95=min95*100*0.4483271 if y==7
		replace max95=max95*100*0.4483271 if y==7
		
		replace estimate=estimate*100*0.4510975 if y==8
		replace min95=min95*100*0.4510975 if y==8
		replace max95=max95*100*0.4510975 if y==8
		
		replace estimate=estimate*100*0.4609812 if y==10
		replace min95=min95*100*0.4609812 if y==10
		replace max95=max95*100*0.4609812 if y==10
		
		replace estimate=estimate*100*0.4510029 if y==11
		replace min95=min95*100*0.4510029 if y==11
		replace max95=max95*100*0.4510029 if y==11
		
		replace estimate=estimate*100*0.4553658 if y==13
		replace min95=min95*100*0.4553658 if y==13
		replace max95=max95*100*0.4553658 if y==13
		
		sort y
		keep parm estimate min95 max95 y
		

			
		graph twoway (bar estimate y if y == 13, horizontal color(gold*0.5) lcolor(gold*0.6) barw(0.8) lwidth(0.8)) ///
		             (bar estimate y if y < 13 & y > 9, horizontal color(red*0.5) lcolor(red*0.6) barw(0.8) lwidth(0.8)) ///
					 (bar estimate y if y < 9 & y > 4, horizontal color(blue*0.5) lcolor(blue*0.6) barw(0.8) lwidth(0.8)) ///
					 (bar estimate y if y < 4, horizontal color(green*0.5) lcolor(green*0.6) barw(0.8) lwidth(0.8)) ///
		             (rcap min95 max95 y if y == 13, horizontal lcolor(gold*0.6) lwidth(1)) ///
					 (rcap min95 max95 y if y < 13 & y > 9, horizontal lcolor(red*0.6) lwidth(1)) ///
					 (rcap min95 max95 y if y < 9 & y > 4, horizontal lcolor(blue*0.6) lwidth(1)) ///
					 (rcap min95 max95 y if y < 4, horizontal lcolor(green*0.6) lwidth(1)) ///
				     , scheme(s1mono) 	///	
					 xline(0, lwidth(thin)) ///
					 text(1 6 "1.70%", place(l) size(4)) ///
					 text(2 6 "1.34%", place(l) size(4)) ///
					 text(3 6 "1.30%", place(l) size(4)) ///
					 text(5 6 "2.20%", place(l) size(4)) ///
					 text(6 6 "1.49%", place(l) size(4)) ///
					 text(7 6 "0.61%", place(l) size(4)) ///
					 text(8 6 "0.40%", place(l) size(4)) ///
					 text(10 6 "1.44%", place(l) size(4)) ///
					 text(11 6 "1.23%", place(l) size(4)) ///
					 text(13 6 "1.32%", place(l) size(4)) ///
				     legend(off) ///
					 ylabel("", valuelabel) ///
				     yscale(range(0.5 13.5)) ///
					 ytitle("") xtitle("") ///
					 title(" "" b. Day-to-day temperature "" index variability ", pos(12) size(4.5)) ///
					 xlabel(0 (2) 6, nogrid labsize(4)) ///
					 xscale(range(-0.6 6)) ///
					 fxsize(70) fysize(200) ///
					 xtitle(" " "Marginal effect " " (% per 1-s.d. increase) ",size(4) color(black))
					  
		graph save "$figure/fig3/fig3_2", replace
	
	
********************************************************************************

	* fig3_3
		cd $figure/fig3
		openall, storefilename(fn)
		keep if (parm == "TN95_adthi" & fn=="fig3_reg_baseline.dta") | parm == "0b.sex#c.TN95_adthi" | parm == "1.sex#c.TN95_adthi" | parm == "1b.group_age#c.TN95_adthi" | parm == "2.group_age#c.TN95_adthi" | parm == "3.group_age#c.TN95_adthi" | parm == "4.group_age#c.TN95_adthi" | parm == "0b.BMI#c.TN95_adthi" | parm == "1.BMI#c.TN95_adthi" | parm == "2.BMI#c.TN95_adthi"
		
		* group
		gen y=13 
		replace y=11 if parm=="0b.sex#c.TN95_adthi"
		replace y=10 if parm=="1.sex#c.TN95_adthi"
		replace y=8 if parm=="1b.group_age#c.TN95_adthi"
		replace y=7 if parm=="2.group_age#c.TN95_adthi"
		replace y=6 if parm=="3.group_age#c.TN95_adthi"
		replace y=5 if parm=="4.group_age#c.TN95_adthi"
		replace y=3 if parm=="0b.BMI#c.TN95_adthi"
		replace y=2 if parm=="1.BMI#c.TN95_adthi"
		replace y=1 if parm=="2.BMI#c.TN95_adthi"
		
		replace estimate=estimate*100*3.961343 if y==1
		replace min95=min95*100*3.961343 if y==1
		replace max95=max95*100*3.961343 if y==1
		
		replace estimate=estimate*100*3.687696 if y==2
		replace min95=min95*100*3.687696 if y==2
		replace max95=max95*100*3.687696 if y==2
		
		replace estimate=estimate*100*3.320768 if y==3
		replace min95=min95*100*3.320768 if y==3
		replace max95=max95*100*3.320768 if y==3
		
		replace estimate=estimate*100*3.455919 if y==5
		replace min95=min95*100*3.455919 if y==5
		replace max95=max95*100*3.455919 if y==5
		
		replace estimate=estimate*100*3.420999 if y==6
		replace min95=min95*100*3.420999 if y==6
		replace max95=max95*100*3.420999 if y==6
		
		replace estimate=estimate*100*3.489755 if y==7
		replace min95=min95*100*3.489755 if y==7
		replace max95=max95*100*3.489755 if y==7
		
		replace estimate=estimate*100*3.326613 if y==8
		replace min95=min95*100*3.326613 if y==8
		replace max95=max95*100*3.326613 if y==8
		
		replace estimate=estimate*100*3.458867 if y==10
		replace min95=min95*100*3.458867 if y==10
		replace max95=max95*100*3.458867 if y==10
		
		replace estimate=estimate*100*3.406009 if y==11
		replace min95=min95*100*3.406009 if y==11
		replace max95=max95*100*3.406009 if y==11
		
		replace estimate=estimate*100*3.429071 if y==13
		replace min95=min95*100*3.429071 if y==13
		replace max95=max95*100*3.429071 if y==13
		
		sort y
		keep parm estimate min95 max95 y
		

			
		graph twoway (bar estimate y if y == 13, horizontal color(gold*0.5) lcolor(gold*0.6) barw(0.8) lwidth(0.8)) ///
		             (bar estimate y if y < 13 & y > 9, horizontal color(red*0.5) lcolor(red*0.6) barw(0.8) lwidth(0.8)) ///
					 (bar estimate y if y < 9 & y > 4, horizontal color(blue*0.5) lcolor(blue*0.6) barw(0.8) lwidth(0.8)) ///
					 (bar estimate y if y < 4, horizontal color(green*0.5) lcolor(green*0.6) barw(0.8) lwidth(0.8)) ///
		             (rcap min95 max95 y if y == 13, horizontal lcolor(gold*0.6) lwidth(1)) ///
					 (rcap min95 max95 y if y < 13 & y > 9, horizontal lcolor(red*0.6) lwidth(1)) ///
					 (rcap min95 max95 y if y < 9 & y > 4, horizontal lcolor(blue*0.6) lwidth(1)) ///
					 (rcap min95 max95 y if y < 4, horizontal lcolor(green*0.6) lwidth(1)) ///
				     , scheme(s1mono) 	///	
					 xline(0, lwidth(thin)) ///
					 text(1 6 "3.43%", place(l) size(4)) ///
					 text(2 6 "2.08%", place(l) size(4)) ///
					 text(3 6 "1.65%", place(l) size(4)) ///
					 text(5 6 "2.25%", place(l) size(4)) ///
					 text(6 6 "1.67%", place(l) size(4)) ///
					 text(7 6 "1.60%", place(l) size(4)) ///
					 text(8 6 "1.51%", place(l) size(4)) ///
					 text(10 6 "2.00%", place(l) size(4)) ///
					 text(11 6 "1.62%", place(l) size(4)) ///
					 text(13 6 "1.79%", place(l) size(4)) ///
				     legend(off) ///
					 ylabel("", valuelabel) ///
				     yscale(range(0.5 13.5)) ///
					 ytitle("") xtitle("") ///
					 title(" "" c. Annual mean EHF "" ", pos(12) size(4.5)) ///
					 xlabel(0 (2) 6, nogrid labsize(4)) ///
					 xscale(range(-0.6 6)) ///
					 fxsize(70) fysize(200) ///
					 xtitle(" " "Marginal effect " " (% per 1-s.d. increase) ",size(4) color(black))
					  
		graph save "$figure/fig3/fig3_3", replace
	
	
********************************************************************************

	* fig3_4
		cd $figure/fig3
		openall, storefilename(fn)
		keep if (parm == "TD95_adthi" & fn=="fig3_reg_baseline.dta") | parm == "0b.sex#c.TD95_adthi" | parm == "1.sex#c.TD95_adthi" | parm == "1b.group_age#c.TD95_adthi" | parm == "2.group_age#c.TD95_adthi" | parm == "3.group_age#c.TD95_adthi" | parm == "4.group_age#c.TD95_adthi" | parm == "0b.BMI#c.TD95_adthi" | parm == "1.BMI#c.TD95_adthi" | parm == "2.BMI#c.TD95_adthi"
		
		* group
		gen y=13 
		replace y=11 if parm=="0b.sex#c.TD95_adthi"
		replace y=10 if parm=="1.sex#c.TD95_adthi"
		replace y=8 if parm=="1b.group_age#c.TD95_adthi"
		replace y=7 if parm=="2.group_age#c.TD95_adthi"
		replace y=6 if parm=="3.group_age#c.TD95_adthi"
		replace y=5 if parm=="4.group_age#c.TD95_adthi"
		replace y=3 if parm=="0b.BMI#c.TD95_adthi"
		replace y=2 if parm=="1.BMI#c.TD95_adthi"
		replace y=1 if parm=="2.BMI#c.TD95_adthi"
		
		replace estimate=estimate*100*7.219665 if y==1
		replace min95=min95*100*7.219665 if y==1
		replace max95=max95*100*7.219665 if y==1
		
		replace estimate=estimate*100*6.950091 if y==2
		replace min95=min95*100*6.950091 if y==2
		replace max95=max95*100*6.950091 if y==2
		
		replace estimate=estimate*100*6.938681 if y==3
		replace min95=min95*100*6.938681 if y==3
		replace max95=max95*100*6.938681 if y==3
		
		replace estimate=estimate*100*7.142057 if y==5
		replace min95=min95*100*7.142057 if y==5
		replace max95=max95*100*7.142057 if y==5
		
		replace estimate=estimate*100*7.095044 if y==6
		replace min95=min95*100*7.095044 if y==6
		replace max95=max95*100*7.095044 if y==6
		
		replace estimate=estimate*100*6.945769 if y==7
		replace min95=min95*100*6.945769 if y==7
		replace max95=max95*100*6.945769 if y==7
		
		replace estimate=estimate*100*6.541455 if y==8
		replace min95=min95*100*6.541455 if y==8
		replace max95=max95*100*6.541455 if y==8
		
		replace estimate=estimate*100*6.952793 if y==10
		replace min95=min95*100*6.952793 if y==10
		replace max95=max95*100*6.952793 if y==10
		
		replace estimate=estimate*100*6.996572 if y==11
		replace min95=min95*100*6.996572 if y==11
		replace max95=max95*100*6.996572 if y==11
		
		replace estimate=estimate*100*6.977581 if y==13
		replace min95=min95*100*6.977581 if y==13
		replace max95=max95*100*6.977581 if y==13
		
		sort y
		keep parm estimate min95 max95 y
		

			
		graph twoway (bar estimate y if y == 13, horizontal color(gold*0.5) lcolor(gold*0.6) barw(0.8) lwidth(0.8)) ///
		             (bar estimate y if y < 13 & y > 9, horizontal color(red*0.5) lcolor(red*0.6) barw(0.8) lwidth(0.8)) ///
					 (bar estimate y if y < 9 & y > 4, horizontal color(blue*0.5) lcolor(blue*0.6) barw(0.8) lwidth(0.8)) ///
					 (bar estimate y if y < 4, horizontal color(green*0.5) lcolor(green*0.6) barw(0.8) lwidth(0.8)) ///
		             (rcap min95 max95 y if y == 13, horizontal lcolor(gold*0.6) lwidth(1)) ///
					 (rcap min95 max95 y if y < 13 & y > 9, horizontal lcolor(red*0.6) lwidth(1)) ///
					 (rcap min95 max95 y if y < 9 & y > 4, horizontal lcolor(blue*0.6) lwidth(1)) ///
					 (rcap min95 max95 y if y < 4, horizontal lcolor(green*0.6) lwidth(1)) ///
				     , scheme(s1mono) 	///	
					 xline(0, lwidth(thin)) ///
					 text(1 9 "4.42%", place(l) size(4)) ///
					 text(2 9 "3.55%", place(l) size(4)) ///
					 text(3 9 "3.68%", place(l) size(4)) ///
					 text(5 9 "4.57%", place(l) size(4)) ///
					 text(6 9 "3.73%", place(l) size(4)) ///
					 text(7 9 "3.07%", place(l) size(4)) ///
					 text(8 9 "2.84%", place(l) size(4)) ///
					 text(10 9 "3.84%", place(l) size(4)) ///
					 text(11 9 "3.60%", place(l) size(4)) ///
					 text(13 9 "3.71%", place(l) size(4)) ///
				     legend(off) ///
					 ylabel("", valuelabel) ///
				     yscale(range(0.5 13.5)) ///
					 ytitle("") xtitle("") ///
					 title(" "" d. Number of days "" with EHF>0 ", pos(12) size(4.5)) ///
					 xlabel(0 (3) 9, nogrid labsize(4)) ///
					 xscale(range(-0.9 9)) ///
					 fxsize(70) fysize(200) ///
					 xtitle(" " "Marginal effect " " (% per 1-s.d. increase) ",size(4) color(black))
					  
		graph save "$figure/fig3/fig3_4", replace
	
********************************************************************************

	* fig3_5
		cd $figure/fig3
		openall, storefilename(fn)
		keep if (parm == "TD95_adthi" & fn=="fig3_reg_baseline.dta") | parm == "0b.sex#c.TD95_adthi" | parm == "1.sex#c.TD95_adthi" | parm == "1b.group_age#c.TD95_adthi" | parm == "2.group_age#c.TD95_adthi" | parm == "3.group_age#c.TD95_adthi" | parm == "4.group_age#c.TD95_adthi" | parm == "0b.BMI#c.TD95_adthi" | parm == "1.BMI#c.TD95_adthi" | parm == "2.BMI#c.TD95_adthi"
		

		
		replace estimate=100 if parm=="TD95_adthi"
		replace estimate=56.59 if parm=="0b.sex#c.TD95_adthi"
		replace estimate=43.41 if parm=="1.sex#c.TD95_adthi"
		replace estimate=19.09 if parm=="1b.group_age#c.TD95_adthi"
		replace estimate=22.80 if parm=="2.group_age#c.TD95_adthi"
		replace estimate=31.04 if parm=="3.group_age#c.TD95_adthi"
		replace estimate=27.07 if parm=="4.group_age#c.TD95_adthi"
		replace estimate=80.87 if parm=="0b.BMI#c.TD95_adthi"
		replace estimate=11.26 if parm=="1.BMI#c.TD95_adthi"
		replace estimate=7.87 if parm=="2.BMI#c.TD95_adthi"
		
		* group
		gen y=13 
		replace y=11 if parm=="0b.sex#c.TD95_adthi"
		replace y=10 if parm=="1.sex#c.TD95_adthi"
		replace y=8 if parm=="1b.group_age#c.TD95_adthi"
		replace y=7 if parm=="2.group_age#c.TD95_adthi"
		replace y=6 if parm=="3.group_age#c.TD95_adthi"
		replace y=5 if parm=="4.group_age#c.TD95_adthi"
		replace y=3 if parm=="0b.BMI#c.TD95_adthi"
		replace y=2 if parm=="1.BMI#c.TD95_adthi"
		replace y=1 if parm=="2.BMI#c.TD95_adthi"
		sort y
		keep parm estimate y
		

			
		graph twoway (bar estimate y if y == 13, horizontal color(gold*0.5) lcolor(gold*0.6) barw(0.8) lwidth(0.8)) ///
		             (bar estimate y if y < 13 & y > 9, horizontal color(red*0.5) lcolor(red*0.6) barw(0.8) lwidth(0.8)) ///
					 (bar estimate y if y < 9 & y > 4, horizontal color(blue*0.5) lcolor(blue*0.6) barw(0.8) lwidth(0.8)) ///
					 (bar estimate y if y < 4, horizontal color(green*0.5) lcolor(green*0.6) barw(0.8) lwidth(0.8)) ///
				     , scheme(s1mono) 	///	
					 xline(0, lwidth(thin)) ///
					 text(1 133 "7.87%", place(l) size(4)) ///
					 text(2 133 "11.26%", place(l) size(4)) ///
					 text(3 133 "80.87%", place(l) size(4)) ///
					 text(5 133 "27.07%", place(l) size(4)) ///
					 text(6 133 "31.04%", place(l) size(4)) ///
					 text(7 133 "22.80%", place(l) size(4)) ///
					 text(8 133 "19.09%", place(l) size(4)) ///
					 text(10 133 "43.41%", place(l) size(4)) ///
					 text(11 133 "56.59%", place(l) size(4)) ///
					 text(13 133 "100%", place(l) size(4)) ///
				     legend(off) ///
					 ylabel("", valuelabel) ///
				     yscale(range(0.5 13.5)) ///
					 ytitle("") xtitle("") ///
					 title(" "" e. Sample distributions "" ", pos(12) size(4.5)) ///
					 xlabel(0 (20) 100, nogrid labsize(4)) ///
					 xscale(range(-13 130)) ///
					 fxsize(70) fysize(200) ///
					 xtitle(" " "Percentage (%)" " ",size(4) color(black))
					  
		graph save "$figure/fig3/fig3_5", replace
	
********************************************************************************

		graph combine "$figure/fig3/fig3_1" "$figure/fig3/fig3_2" "$figure/fig3/fig3_3" "$figure/fig3/fig3_4" "$figure/fig3/fig3_5", ///
				graphregion(fcolor(white) lcolor(white)) imargin(small) col(5) iscale(0.6) xsize(20) ysize(10)
		graph save "$figure/fig3/fig3", replace	
		graph export "$figure/fig3/fig3.eps", replace
		graph export "$figure/fig3/fig3.png", replace width(3000)