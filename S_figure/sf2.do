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
* SF2 : Survey and mortality of CLHLS older adults
*
********************************************************************************
	
	* figure sf2_1
	
		use "$data/main.dta", clear
		gen numm=1
		gen death0=1 if death==0
		replace death0=-1 if death0==.
		gen death1=1 if death==1
		replace death1=0 if death1==.
		gen key=id*10000+year
		sort key
		bys id:gen temp=_n
		replace temp=1 if death==1
		replace death0=0 if temp>1
		gen date = mdy(month, day, year)
		format date %td
		collapse (sum) death0 death1 numm, by(date)
		gen death0s=sum(death0)
		gen death1s=sum(death1)
		gen numms=sum(numm)

		graph  twoway (area numms date, fcolor(orange*0.4%90) lcolor(orange*0.3)) ///
				(area death1s date, fcolor(red*0.7%90) lcolor(red*0.6)) ///
				(area death0s date, fcolor(blue*0.7%90) lcolor(blue*0.6)) ///
				(line death1s date if date <= 18324, lcolor(red*0.3) lpattern(shortdash)) ///
				,scheme(plotplain) ///
				xlabel(16439 "1Jan2005" 17167 "1Jan2007" 17898 "1Jan2009" 18628 "1Jan2011" 19359 "1Jan2013" 20089 "1Jan2015" 20820 "1Jan2017" 21550 "1Jan2019" ,nogrid)  ///
				ylabel(0 "       0"  10000 20000 30000 40000 50000,nogrid) ///
				title("CLHLS Cumulative Surveys, Surviving, and Cumulative Deaths"" ", position(11) size(3.5)) ///		
				legend(order(1 2 3) label(1 "Cumulative Surveys") label(2 "Cumulative Deaths") label(3 "Surviving") ring(0) pos(11) rowgap(0.5)) ///
				xtitle(" ""Date", size(2.7)) ytitle("Number of elders", size(2.7) axis(1)) ///
				fysize(90) fxsize(130) ///
				ysize(8) xsize(12) 
				
				graph save "$figure/sf2/sf2_1", replace
				graph export "$figure\sf2\sf2_1.png", replace width(3000)

********************************************************************************
	
	* figure sf2_2
	
		use "$data/main.dta", clear

	
		gen death0=1 if death==0
		replace death0=0 if death0==.
		gen death1=1 if death==1
		replace death1=0 if death1==.
	
		gen date = mdy(month, day, year)
		format date %td
		collapse (sum) death0 death1, by(date)

		graph  twoway (area death0 date, fcolor(blue*0.7) lcolor(blue*0.6)) ///
				(area death1 date, fcolor(red*0.7) lcolor(red*0.6)) /// 
				,scheme(plotplain) ///
				xlabel(16439 "1Jan2005" 17167 "1Jan2007" 17898 "1Jan2009" 18628 "1Jan2011" 19359 "1Jan2013" 20089 "1Jan2015" 20820 "1Jan2017" 21550 "1Jan2019" ,nogrid)  ///
				ylabel(0 "       0"  100 200 300 400,nogrid) ///
				title("CLHLS Non-death Surveys,Deaths"" ", position(11) size(3.5)) ///		
				legend(order(1 2) label(1 "Non-death Surveys") label(2 "Deaths") ring(0) pos(11) rowgap(0.5)) ///
				xtitle(" ""Date", size(2.7)) ytitle("Number of elders", size(2.7) axis(1)) ///
				fysize(90) fxsize(130) ///
				ysize(8) xsize(12) 
				
				graph save "$figure/sf2/sf2_2", replace
				graph export "$figure\sf2\sf2_2.png", replace width(3000)

********************************************************************************

* figure sf2_3
	
		use "$data/main.dta", clear
		keep if death==1
		
		gen provid=floor(gbcode/10000)
		gen key=provid*100000000+year*10000+month*100+day
		bys key:gen filter=_n
		bys key:gen deaths=_N
		keep if filter==1
		sort key
		bys provid:gen cdeaths=sum(deaths)
		keep provid year month day cdeaths
		order provid year month day cdeaths
		
		gen date = mdy(month, day, year)
		format date %td
		
		tab provid, gen(province)
		for num 1/23: gen c_deathsX = cdeaths if provinceX == 1
		
		gen provinceid = 0
		for num 1/23: replace provinceid = X if provinceX == 1
		
		graph twoway ///
			(line c_deaths1 date, lcolor(red*0.25) lwidth(thin) lpattern(solid)) ///
			(line c_deaths2 date, lcolor(red*0.5) lwidth(thin) lpattern(solid)) ///
			(line c_deaths3 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
			(line c_deaths4 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
			(line c_deaths5 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
			(line c_deaths6 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
			(line c_deaths7 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
			(line c_deaths8 date, lcolor(orange*1) lwidth(thin) lpattern(solid)) ///
			(line c_deaths9 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
			(line c_deaths10 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
			(line c_deaths11 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
			(line c_deaths12 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
			(line c_deaths13 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
			(line c_deaths14 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
			(line c_deaths15 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
			(line c_deaths16 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
			(line c_deaths17 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
			(line c_deaths18 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
			(line c_deaths19 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
			(line c_deaths20 date, lcolor(blue*1) lwidth(thin) lpattern(solid)) ///
			(line c_deaths21 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
			(line c_deaths22 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
			(line c_deaths23 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
			,scheme(plotplain) ///
			xlabel(16439 "1Jan2005" 17167 "1Jan2007" 17898 "1Jan2009" 18628 "1Jan2011" 19359 "1Jan2013" 20089 "1Jan2015" 20820 "1Jan2017" 21550 "1Jan2019" ,nogrid)  ///
			ylabel(0 "       0"  600 1200 1800 2400 3000,nogrid) ///
			title("CLHLS Cumulative Deaths of Province"" ", position(11) size(3.5)) ///		
			legend(order(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23) label(1 "Beijing") label(2 "Tianjin") label(3 "Hebei") label(4 "Shanxi") label(5 "Liaoning") label(6 "Jilin") label(7 "Heilongjiang") label(8 "Shanghai") label(9 "Jiangsu") label(10 "Zhejiang") label(11 "Anhui") label(12 "Fujian") label(13 "Jiangxi") label(14 "Shandong") label(15 "Henan") label(16 "Hubei") label(17 "Hunan") label(18 "Guangdong") label(19 "Guangxi") label(20 "Hainan") label(21 "Chongqing") label(22 "Sichuan") label(23 "Shaanxi") ring(0) pos(11) col(2) rowgap(0.5) size(2)) ///
			xtitle(" ""Date", size(2.7)) ytitle("Number of elders", size(2.7) axis(1)) ///
			fysize(90) fxsize(130) ///
			ysize(8) xsize(12) 
			
			graph save "$figure/sf2/sf2_3", replace
			graph export "$figure\sf2\sf2_3.png", replace width(3000)

********************************************************************************
* figure sf2_4
	
		use "$data/main.dta", clear
		keep if death==1
		
		gen key=gbcode*100000000+year*10000+month*100+day
		bys key:gen filter=_n
		bys key:gen deaths=_N
		keep if filter==1
		sort key
		bys gbcode:gen cdeaths=sum(deaths)
		keep gbcode year month day cdeaths
		order gbcode year month day cdeaths
		
		gen date = mdy(month, day, year)
		format date %td
		
		tab gbcode, gen(county)
		for num 1/827: gen c_deathsX = cdeaths if countyX == 1
		
		gen countyid = 0
		for num 1/827: replace countyid = X if countyX == 1
		gen provid=floor(gbcode/10000)
		
		graph twoway ///
		     (line c_deaths74 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths75 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths76 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths77 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths78 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths79 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths80 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths81 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths82 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths83 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths84 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths85 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths86 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths87 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths88 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths89 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths90 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths91 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths92 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths93 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths94 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths95 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths96 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths97 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths98 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths99 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths100 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths101 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths102 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths103 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths104 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths105 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths106 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths107 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths108 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths109 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths110 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
			 (line c_deaths111 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths112 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths113 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths114 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths115 date, lcolor(orange*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths116 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths117 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths118 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths119 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths120 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths121 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths122 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths123 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths124 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths125 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths126 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths127 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths128 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths129 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths130 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths131 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths132 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths133 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths134 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths135 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths136 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths137 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths138 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths139 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths140 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths141 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths142 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths143 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths144 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths145 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths146 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths147 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths148 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths149 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths150 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths151 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths152 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths153 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths154 date, lcolor(orange*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths155 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths156 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths157 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths158 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths159 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths160 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths161 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths162 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths163 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths164 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths165 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths166 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths167 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths168 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths169 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths170 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths171 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths172 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths173 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths174 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths175 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths176 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths177 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths178 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths179 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths180 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths181 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths182 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths183 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths184 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths185 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths186 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths187 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths188 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths189 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths190 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths191 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths192 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths193 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths194 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths195 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths196 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths197 date, lcolor(orange*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths198 date, lcolor(orange*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths199 date, lcolor(orange*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths200 date, lcolor(orange*1) lwidth(thin) lpattern(solid)) ///
			 (line c_deaths201 date, lcolor(orange*1) lwidth(thin) lpattern(solid)) ///
			 (line c_deaths202 date, lcolor(orange*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths203 date, lcolor(orange*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths204 date, lcolor(orange*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths205 date, lcolor(orange*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths206 date, lcolor(orange*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths207 date, lcolor(orange*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths208 date, lcolor(orange*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths209 date, lcolor(orange*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths210 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///  
		     (line c_deaths211 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths212 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths213 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths214 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths215 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths216 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths217 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths218 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths219 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths220 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths221 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths222 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths223 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths224 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths225 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths226 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths227 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths228 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths229 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths230 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths231 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths232 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths233 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths234 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths235 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths236 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths237 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths238 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths239 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths240 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths241 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths242 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths243 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths244 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths245 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths246 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths247 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths248 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths249 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths250 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths251 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths252 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths253 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths254 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths255 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths256 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths257 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths258 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths259 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths260 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths261 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths262 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths263 date, lcolor(gold*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths264 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths265 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths266 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths267 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths268 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths269 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths270 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths271 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths272 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths273 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths274 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths275 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths276 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths277 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths278 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths279 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths280 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths281 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths282 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths283 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths284 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths285 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths286 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths287 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths288 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths289 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths290 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths291 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths292 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths293 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths294 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths295 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths296 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths297 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths298 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths299 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths300 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
			 (line c_deaths301 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
			 (line c_deaths302 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths303 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths304 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths305 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths306 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths307 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths308 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths309 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths310 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///  
		     (line c_deaths311 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths312 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths313 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths314 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths315 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths316 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths317 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths318 date, lcolor(gold*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths319 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths320 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths321 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths322 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths323 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths324 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths325 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths326 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths327 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths328 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths329 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths330 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths331 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths332 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths333 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths334 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths335 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths336 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths337 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths338 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths339 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths340 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths341 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths342 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths343 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths344 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths345 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths346 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths347 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths348 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths349 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths350 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths351 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths352 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths353 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths354 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths355 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths356 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths357 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths358 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths359 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths360 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths361 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths362 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths363 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths364 date, lcolor(gold*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths365 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths366 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths367 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths368 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths369 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths370 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths371 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths372 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths373 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths374 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths375 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths376 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths377 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths378 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths379 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths380 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths381 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths382 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths383 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths384 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths385 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths386 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths387 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths388 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths389 date, lcolor(gold*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths390 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths391 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths392 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths393 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths394 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths395 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths396 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths397 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths398 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths399 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths400 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
			 (line c_deaths401 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
			 (line c_deaths402 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths403 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths404 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths405 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths406 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths407 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths408 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths409 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths410 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///  
		     (line c_deaths411 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths412 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths413 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths414 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths415 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths416 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths417 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths418 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths419 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths420 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths421 date, lcolor(green*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths422 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths423 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths424 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths425 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths426 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths427 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths428 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths429 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths430 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths431 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths432 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths433 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths434 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths435 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths436 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths437 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths438 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths439 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths440 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths441 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths442 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths443 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths444 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths445 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths446 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths447 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths448 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths449 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths450 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths451 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths452 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths453 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths454 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths455 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths456 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths457 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths458 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths459 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths460 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths461 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths462 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths463 date, lcolor(green*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths464 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths465 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths466 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths467 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths468 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths469 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths470 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths471 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths472 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths473 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths474 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths475 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths476 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths477 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths478 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths479 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths480 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths481 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths482 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths483 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths484 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths485 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths486 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths487 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths488 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths489 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths490 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths491 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths492 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths493 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths494 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths495 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths496 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths497 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths498 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths499 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths500 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
			 (line c_deaths501 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
			 (line c_deaths502 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths503 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths504 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths505 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths506 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths507 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths508 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths509 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths510 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///  
		     (line c_deaths511 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths512 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths513 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths514 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths515 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths516 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths517 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths518 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths519 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths520 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths521 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths522 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths523 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths524 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths525 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths526 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths527 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths528 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths529 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths530 date, lcolor(green*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths531 date, lcolor(green*1) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths532 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths533 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths534 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths535 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths536 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths537 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths538 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths539 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths540 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths541 date, lcolor(green*1) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths542 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths543 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths544 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths545 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths546 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths547 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths548 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths549 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths550 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths551 date, lcolor(green*1) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths552 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths553 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths554 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths555 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths556 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths557 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths558 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths559 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths560 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths561 date, lcolor(green*1) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths562 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths563 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths564 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths565 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths566 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths567 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths568 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths569 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths570 date, lcolor(green*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths571 date, lcolor(green*1) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths572 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths573 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths574 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths575 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths576 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths577 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths578 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths579 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths580 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths581 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths582 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths583 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths584 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths585 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths586 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths587 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths588 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths589 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths590 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths591 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths592 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths593 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths594 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths595 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths596 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths597 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths598 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths599 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths600 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
			 (line c_deaths601 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
			 (line c_deaths602 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths603 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths604 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths605 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths606 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths607 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths608 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths609 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths610 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///  
		     (line c_deaths611 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths612 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths613 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths614 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths615 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths616 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths617 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths618 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths619 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths620 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths621 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths622 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths623 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths624 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths625 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths626 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths627 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths628 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths629 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths630 date, lcolor(blue*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths631 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths632 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths633 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths634 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths635 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths636 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths637 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths638 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths639 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths640 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths641 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths642 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths643 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths644 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths645 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths646 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths647 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths648 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths649 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths650 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths651 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths652 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths653 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths654 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths655 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths656 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths657 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths658 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths659 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths660 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths661 date, lcolor(blue*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths662 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths663 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths664 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths665 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths666 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths667 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths668 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths669 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths670 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths671 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths672 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths673 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths674 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths675 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths676 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths677 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths678 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths679 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths680 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths681 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths682 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths683 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths684 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths685 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths686 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths687 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths688 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths689 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths690 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths691 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths692 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths693 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths694 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths695 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths696 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths697 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths698 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths699 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths700 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
			 (line c_deaths701 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
			 (line c_deaths702 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths703 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths704 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths705 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths706 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths707 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths708 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths709 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths710 date, lcolor(blue*0.75) lwidth(thin) lpattern(solid)) ///  
		     (line c_deaths711 date, lcolor(blue*1) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths712 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths713 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths714 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths715 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths716 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths717 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths718 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths719 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths720 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths721 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths722 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths723 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths724 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths725 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths726 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths727 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths728 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths729 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths730 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths731 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths732 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths733 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths734 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths735 date, lcolor(purple*0.3) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths736 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths737 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths738 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths739 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths740 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths741 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths742 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths743 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths744 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths745 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths746 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths747 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths748 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths749 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths750 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths751 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths752 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths753 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths754 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths755 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths756 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths757 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths758 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths759 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths760 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths761 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths762 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths763 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths764 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths765 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths766 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths767 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths768 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths769 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths770 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths771 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths772 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths773 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths774 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths775 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths776 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths777 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths778 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths779 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths780 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths781 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths782 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths783 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths784 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths785 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths786 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths787 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths788 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths789 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths790 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths791 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths792 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths793 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths794 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths795 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths796 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths797 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths798 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths799 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths800 date, lcolor(purple*0.7) lwidth(thin) lpattern(solid)) ///
			 (line c_deaths801 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
			 (line c_deaths802 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths803 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths804 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths805 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths806 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths807 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths808 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths809 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths810 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///  
		     (line c_deaths811 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths812 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths813 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths814 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths815 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths816 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths817 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths818 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths819 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths820 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths821 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths822 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths823 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths824 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths825 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths826 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths827 date, lcolor(purple*1) lwidth(thin) lpattern(solid)) ///
			 (line c_deaths1 date, lcolor(red*0.25) lwidth(thin) lpattern(solid)) ///
			 (line c_deaths2 date, lcolor(red*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths3 date, lcolor(red*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths4 date, lcolor(red*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths5 date, lcolor(red*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths6 date, lcolor(red*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths7 date, lcolor(red*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths8 date, lcolor(red*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths9 date, lcolor(red*0.25) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths10 date, lcolor(red*0.25) lwidth(thin) lpattern(solid)) ///  
		     (line c_deaths11 date, lcolor(red*0.25) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths12 date, lcolor(red*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths13 date, lcolor(red*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths14 date, lcolor(red*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths15 date, lcolor(red*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths16 date, lcolor(red*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths17 date, lcolor(red*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths18 date, lcolor(red*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths19 date, lcolor(red*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths20 date, lcolor(red*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths21 date, lcolor(red*0.5) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths22 date, lcolor(red*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths23 date, lcolor(red*0.5) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths24 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths25 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths26 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths27 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths28 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths29 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths30 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths31 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths32 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths33 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths34 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths35 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths36 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths37 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths38 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths39 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths40 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths41 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths42 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths43 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths44 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths45 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths46 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths47 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths48 date, lcolor(red*0.75) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths49 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths50 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths51 date, lcolor(red*1) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths52 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths53 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths54 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths55 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths56 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths57 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths58 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths59 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths60 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths61 date, lcolor(red*1) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths62 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths63 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths64 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths65 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths66 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths67 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths68 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths69 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths70 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths71 date, lcolor(red*1) lwidth(thin) lpattern(solid)) /// 
		     (line c_deaths72 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
		     (line c_deaths73 date, lcolor(red*1) lwidth(thin) lpattern(solid)) ///
			 ,scheme(plotplain) ///
			 xlabel(16439 "1Jan2005" 17167 "1Jan2007" 17898 "1Jan2009" 18628 "1Jan2011" 19359 "1Jan2013" 20089 "1Jan2015" 20820 "1Jan2017" 21550 "1Jan2019" ,nogrid)  ///
			 ylabel(0 "       0"  100 200 300 400 500,nogrid) ///
			 title("CLHLS Cumulative Deaths of District or County"" ", position(11) size(3.5)) ///		
			 legend(order(755 766 778 803 1 43 82 125 137 191 246 292 317 349 391 458 499 558 589 638 639 663 728) label(755 "District of Beijing") label(766 "District of Tianjin") label(778 "District of Hebei") label(803 "District of Shanxi") label(1 "District of Liaoning") label(43 "District of Jilin") label(82 "District of Heilongjiang") label(125 "District of Shanghai") label(137 "District of Jiangsu") label(191 "District of Zhejiang") label(246 "District of Anhui") label(292 "District of Fujian") label(317 "District of Jiangxi") label(349 "District of Shandong") label(391 "District of Henan") label(458 "District of Hubei") label(499 "District of Hunan") label(558 "District of Guangdong") label(589 "District of Guangxi") label(638 "District of Hainan") label(639 "District of Chongqing") label(663 "District of Sichuan") label(728 "District of Shaanxi") ring(0) pos(11) col(2) rowgap(0.5) size(2)) ///
			xtitle(" ""Date", size(2.7)) ytitle("Number of elders", size(2.7) axis(1)) ///
			fysize(90) fxsize(130) ///
			ysize(8) xsize(12) 
			
			graph save "$figure/sf2/sf2_4", replace
			graph export "$figure\sf2\sf2_4.png", replace width(3000)

********************************************************************************			
