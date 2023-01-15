*************   Install packages and set filepath   *************
pwd
clear all
* Install necessary packages (for your reference)
*ssc install schemepack, replace
*ssc install binscatter, replace
*ssc install estout, replace
*ssc install balancetable, replace
*ssc install outreg2, replace
* Set scheme for graphs to make them look nice
set scheme white_tableau

* Set font
graph set window fontface "Fira Sans" // my favorite font
*graph set window fontface "Arial"
*graph set window fontface default

display c(hostname)

if "`c(hostname)'" == "Shadow" {
	global root  	"D:\7550\project"
	di 				"You are on Rohit's computer"
}

cd "$root"
cd "$root\data\clean"
use finaldata, clear
set more off 
capture log close
log using final_code.smcl, replace 

*************   Clean the 71st round  *************
** dataset 3
use "$root\data\raw\HSCES71\B3.dta", clear 		
sort HH_ID
keep HH_ID religion social_grp dist1 dist2 dist3 internet hhcomp hh_cons_exp			 

save "$root\data\clean\HSCES71\dataset3.dta", replace

** dataset 4
use "$root\data\raw\HSCES71\B4.dta", clear 		
sort HH_ID
keep HH_ID round sector state_district age sex gen_edu psrl_no marital_status
					 
save "$root\data\clean\HSCES71\dataset4.dta", replace

** dataset 5
use "$root\data\raw\HSCES71\B5.dta", clear 			
sort HH_ID
keep HH_ID psrl_no inst_type edu_free scholarship schlor_type textbooks stationery midday_meal acad_session medium_instruction lang_home course_type tut_fee_wav mode_transport dist_inst private_coaching concession age age_entry present_class amt_wav changed_edu_inst
			 
save "$root\data\clean\HSCES71\dataset5.dta", replace

** dataset 6
use "$root\data\raw\HSCES71\B6.dta", clear 			
sort HH_ID
keep HH_ID psrl_no other_exp tot_exp
			 
save "$root\data\clean\HSCES71\dataset6.dta", replace


*************   Merge the datasets   *************

* merge dataset3 and dataset4
use "$root\data\clean\HSCES71\dataset4.dta"
merge m:1 HH_ID using "$root\data\clean\HSCES71\dataset3.dta"
gen IID = HH_ID + psrl_no
sort IID
drop _merge
save "$root\data\clean\HSCES71\merged_data_3&4.dta", replace
use "$root\data\clean\HSCES71\merged_data_3&4.dta"

*merge merged_data_3&4 and dataset5
use "$root\data\clean\HSCES71\dataset5.dta"
gen IID = HH_ID + psrl_no
sort IID
merge 1:1 IID using "$root\data\clean\HSCES71\merged_data_3&4.dta"
keep if _merge == 3
drop _merge
save "$root\data\clean\HSCES71\merged_data_3&4&5.dta", replace
use "$root\data\clean\HSCES71\merged_data_3&4&5.dta"

*merge merged_data_3&4&5 and dataset6
use "$root\data\clean\HSCES71\dataset6.dta"
gen IID = HH_ID + psrl_no
sort IID
merge 1:1 IID using "$root\data\clean\HSCES71\merged_data_3&4&5.dta"
keep if _merge == 3
drop _merge
save "$root\data\clean\HSCES71\merged_data_3&4&5&6.dta", replace
use "$root\data\clean\HSCES71\merged_data_3&4&5&6.dta"


*************   destring variable and save final data   *************

destring, replace
sort HH_ID
save "$root\data\clean\HSCES71\merged_data71.dta", replace
use "$root\data\clean\HSCES71\merged_data71.dta"

cd "$root\data\clean"
save cleaned71, replace
use "$root\data\clean\cleaned71"  // 40x93513

*************   Clean the 75th round  *************

clear all

** dataset 3
use "$root\data\raw\HSCES75\B3.dta", clear 			
sort HHID
keep HHID Religion Social_group Distance_primary_school Distance_upper_school Distance_secondary_school Member_internet HH_Computer HH_Con_exp_rs
			 
save "$root\data\clean\HSCES75\dataset3.dta", replace

** dataset 4
use "$root\data\raw\HSCES75\B4.dta", clear 			
sort HHID
keep HHID Round Sector StateDistrict Age Gender Edu_level_general Per_serialno	Marital_status				 

save "$root\data\clean\HSCES75\dataset4.dta", replace

** dataset 5
use "$root\data\raw\HSCES75\B5.dta", clear 			
sort HHID
keep HHID Per_serialno Institution_type Free_education Scholarship_stipend Reimbursement_type Whether_free_textbooks Whether_free_stationary Midday_meal_tiffin Course_duration_mnth Medium_instruction Language_spoken Type_course Tution_free_payable Transport_mode Residance_insttn_distance Taking_pvt_coaching Concession_received School_entry_age Whether_same_grade Tution_fee_waived_amt Change_insttn_365days
	 
save "$root\data\clean\HSCES75\dataset5.dta", replace

** dataset 6
use "$root\data\raw\HSCES75\B6.dta", clear 			
sort HHID
keep HHID Per_serialno Other_expenditure_amt Total_expenditure_amt
	 
save "$root\data\clean\HSCES75\dataset6.dta", replace


*************   Merge the datasets   *************

* merge dataset3 and dataset4
use "$root\data\clean\HSCES75\dataset4.dta"
merge m:1 HHID using "$root\data\clean\HSCES75\dataset3.dta"
gen IID = HHID + Per_serialno
sort IID
drop _merge
save "$root\data\clean\HSCES75\merged_data_3&4.dta", replace
use "$root\data\clean\HSCES75\merged_data_3&4.dta"

*merge merged_data_3&4 and dataset5
use "$root\data\clean\HSCES75\dataset5.dta"
gen IID = HHID + Per_serialno
sort IID
merge 1:1 IID using "$root\data\clean\HSCES75\merged_data_3&4.dta"
keep if _merge == 3
drop _merge
save "$root\data\clean\HSCES75\merged_data_3&4&5", replace
use "$root\data\clean\HSCES75\merged_data_3&4&5.dta"
sort IID

*merge merged_data_3&4&5 and dataset6
use "$root\data\clean\HSCES75\dataset6.dta"
gen IID = HHID + Per_serialno
sort IID
merge 1:1 IID using "$root\data\clean\HSCES75\merged_data_3&4&5.dta"
keep if _merge == 3
drop _merge
save "$root\data\clean\HSCES75\merged_data_3&4&5&6.dta", replace
use "$root\data\clean\HSCES75\merged_data_3&4&5&6.dta"


*************   destring variable and save final data   *************

destring, replace
sort HHID
save "$root\data\clean\HSCES75\merged_data75.dta", replace
use "$root\data\clean\HSCES75\merged_data75.dta"

cd "$root\data\clean"
save cleaned75, replace
use "$root\data\clean\cleaned75" 

************   Rename 75th round variables to match 71st round   *************

order HHID IID Per_serialno  StateDistrict Round Age Gender Edu_level_general Free_education Scholarship_stipend Reimbursement_type Institution_type Religion Social_group Sector  Whether_free_stationary Whether_free_textbooks Midday_meal_tiffin

// #3
rename Religion religion
rename Social_group social_grp
rename Distance_primary_school dist1
rename Distance_upper_school dist2
rename Distance_secondary_school dist3
rename HH_Computer hhcomp
rename Member_internet internet
rename HH_Con_exp_rs hh_cons_exp

// #4
rename HHID HH_ID
rename Round round
rename Sector sector
rename StateDistrict state_district
rename Age age
rename Gender sex
rename Edu_level_general gen_edu
rename Per_serialno psrl_no
rename Marital_status marital_status

// #5
rename Institution_type inst_type
rename Free_education edu_free
rename Scholarship_stipend scholarship
rename Reimbursement_type schlor_type 
rename Whether_free_textbooks textbooks
rename Whether_free_stationary stationery	
rename Midday_meal_tiffin midday_meal
rename Course_duration_mnth acad_session
rename Medium_instruction medium_instruction
rename Language_spoken lang_home
rename Type_course course_type
rename Tution_free_payable tut_fee_wav 
rename Transport_mode mode_transport
rename Residance_insttn_distance dist_inst
rename Taking_pvt_coaching private_coaching
rename Concession_received concession
rename School_entry_age age_entry
rename Whether_same_grade present_class
rename Tution_fee_waived_amt amt_wav
rename Change_insttn_365days changed_edu_inst

// #6
rename Other_expenditure_amt other_exp
rename Total_expenditure_amt tot_exp

* renaming the labels level 
label define Genderi 1 "Male" 0 "Female" 3 "others"
label values sex Genderi

label define Free_education 1 "Yes" 2 "No"
label values edu_free Free_education

label define Scholarship_stipend 1 "Yes" 2 "No"
label values scholarship Scholarship_stipend

label define Reimbursement_type 1 "ST" 2 "SC" 3 "OBC" 4 "Handicapped" 5 "Merit" 6 "Financially weak" 7 "Others"
label values schlor_type Reimbursement_type

label define Institution_type 1 "Government" 2 "Private aided" 3 "Private un-aided" 4 "Not Known"
label values inst_type Institution_type

label define Religion 1 "Hinduism" 2 "Islam" 3 "Christianity" 4 "Sikhism" 5 "Jainism" 6 "Buddhism" 7 "Zoroastrianism" 9 "others" 
label values religion Religion

label define Social_group 1 "scheduled tribe" 2 "scheduled caste" 3 "other backward class" 4 "others"
label values social_grp Social_group

label define Sector 1 "Rural" 2 "Urban"
label values sector Sector

label define Whether_free_stationary 1 "All free" 2 "Some free" 3 "All subsidised" 4 "Some subsidised" 5 "Some free and some subsideised" 6 "No"
label values stationery Whether_free_stationary

label define Whether_free_textbooks 1 "All free" 2 "Some free" 3 "All subsidised" 4 "Some subsidised" 5 "Some free and some subsideised" 6 "No"
label values textbooks Whether_free_textbooks

label define Midday_meal_tiffin	1 "Yes" 2 "No" 
label values midday_meal Midday_meal_tiffin

cd "$root\data\clean"
save cleaned75label,replace

*************   Append rounds 75 and 71   *************

clear all

use "$root\data\clean\cleaned71"
append using "$root\data\clean\cleaned75label", generate (new_obs) nolabel nonotes
drop new_obs 
order IID HH_ID psrl_no round state_district age sex religion social_grp gen_edu
save "$root\data\clean\append7175", replace

use "$root\data\clean\append7175"
duplicates drop IID, force

************************ Dropping all the missing values and unnecessary variables  *****************

** dropping the other languages as medium_instruction only keeping if it's hindi/ english not considering all other regional langages.

drop if medium_instruction >2 

drop if missing(hh_cons_exp)
drop if missing(internet)
drop if missing(hhcomp)
drop if missing(dist3)
drop if missing(dist2)
drop if missing(dist1)
drop if missing(private_coaching)
drop if missing(dist_inst)
drop if missing(mode_transport)
drop if missing(midday_meal)
drop if missing(stationery)
drop if missing(textbooks)
drop if missing(scholarship)
drop if missing(tut_fee_wav)
drop if missing(edu_free)
drop if missing(course_type)
drop if missing(lang_home)
drop if missing(medium_instruction)
drop if missing(inst_type)
drop if missing(acad_session)
drop if missing(social_grp)
drop if missing(religion)
drop if missing(present_class)


* recoding the variables and changing the labels 
*round 0 "71 round" 1 "75 round"
recode round 71 = 0 75 = 1, generate(Round)

label define rounds 0 "71th" 1 "75th" 
label values Round rounds

*sex 0 "Female" 1 "Male"
recode sex 2 = 0 1 =1, generate(Gender)

label define Genderi 1 "Male" 0 "Female" 3 "others"
label values Gender Genderi

*religion 1 "Hinduism" 2 "Islam" 3 "Christianity" 4 "Sikhism" 5 "Jainism" 6 "Buddhism" 7 "Zoroastrianism" 9 "others"
recode religion 1=0 2=1 3=2 4=3 5=4 6=5 7=6 9=7, generate(Religion)

label define religions 0 "Hinduism" 1 "Islam" 2 "Christianity" 3 "Sikhism" 4 "Jainism" 5 "Buddhism" 6 "Zoroastrianism" 7 "others" 
label values Religion religions

*social_grp 1 "scheduled tribe" 2 "scheduled caste" 3 "other backward class" 9 "others"
recode social_grp 1=0 2=1 3=2 9=3, generate(Social_group)

label define social_grps 0 "scheduled tribe" 1 "scheduled caste" 2 "other backward class" 3 "others" 
label values Social_group social_grps

*inst_type 1 "Government" 2 "Private aided" 3 "Private un-aided" 4 "Not Known"
recode inst_type 1=0 2=1 3=2 4=3, generate(Institution_type)

label define inst_types 0 "Government" 1 "Private aided" 2 "Private un-aided" 3 "Not Known" 
label values Institution_type inst_types

*medium_instruction 1 "Hindi" 2 "English" 
recode medium_instruction 1=0 2=1, generate(Medium_instruction)

label define medium_instructions 0 "Hindi" 1 "English"
label values Medium_instruction medium_instructions

*course_type
recode course_type 1=0 2=1, generate(Course_type)

label define course_types 0 "Full Time" 1 "Part Time"
label values Course_type course_types

*edu_free
recode edu_free 1=0 2=1, generate(Free_education)

label define edu_frees 0 "Yes" 1 "No"
label values Free_education edu_frees

*tut_fee_wav
recode tut_fee_wav 1=0 2=1 3=2, generate(Tution_fee_wav)

label define tut_fee_wavs 0 "Yes Fully" 1 "Yes Partly" 2 "No"
label values Tution_fee_wav tut_fee_wavs

*scholarship
recode scholarship 1=0 2=1, generate(Scholarship)

label define scholarships 0 "Yes" 1 "No"
label values Scholarship scholarships

*textbooks
recode textbooks 1=0 2=1 3=2 4=3 5=4 6=5, generate(Textbooks)

label define textbookss 0 "All Free" 1 "Some Free" 2 "All subsidised" 3 "Some subsidised" 4 "Mixture" 5 "No"
label values Textbooks textbookss

*stationery
recode stationery 1=0 2=1 3=2 4=3 5=4 6=5, generate(Stationary)

label define stationeryy 0 "All Free" 1 "Some Free" 2 "All subsidised" 3 "Some subsidised" 4 "Mixture" 5 "No"
label values Stationary stationeryy

*midday_meal
recode midday_meal 1=0 2=1, generate(Midday_meal)

label define midday_meals 0 "Yes" 1 "No"
label values Midday_meal midday_meals

*mode_transport
recode mode_transport 1=0 2=1 3=2 4=3 9=4, generate(Transport_mode)

label define mode_transports 0 "On Foot" 1 "School/Inst. Bus" 2 "Public transport" 3 "Bicycle" 4 "Others"
label values Transport_mode mode_transports

*dist_inst
recode dist_inst 1=0 2=1 3=2 4=3 9=4, generate(Dist_inst)

label define dist_insts 0 "d< 1 km" 1 "1 km < = d < 2 kms" 2 "2 Km <= d < 3 kms" 3 "3 kms <= d < 5 kms" 4 "d >= 5 kms"
label values Dist_inst dist_insts

*private_coaching
recode private_coaching 1=0 2=1, generate(Private_coaching)

label define private_coachings 0 "Yes" 1 "No"
label values Private_coaching private_coachings

*sector
recode sector 1=0 2=1, generate(Sector)

label define sectors 0 "Rural" 1 "Urban"
label values Sector sectors

*dist1
recode dist1 1=0 2=1 3=2 4=3 9=4, generate(Distance_primary)

label define dist1s 0 "d< 1 km" 1 "1 km < = d < 2 kms" 2 "2 Km <= d < 3 kms" 3 "3 kms <= d < 5 kms" 4 "d >= 5 kms"
label values Distance_primary dist1s

*dist2
recode dist2 1=0 2=1 3=2 4=3 9=4, generate(Distance_upper)

label define dist2s 0 "d< 1 km" 1 "1 km < = d < 2 kms" 2 "2 Km <= d < 3 kms" 3 "3 kms <= d < 5 kms" 4 "d >= 5 kms"
label values Distance_upper dist2s

*dist3
recode dist3 1=0 2=1 3=2 4=3 9=4, generate(Distance_secondary)

label define dist3s 0 "d< 1 km" 1 "1 km < = d < 2 kms" 2 "2 Km <= d < 3 kms" 3 "3 kms <= d < 5 kms" 4 "d >= 5 kms"
label values Distance_secondary dist3s

*hhcomp
recode hhcomp 1=0 2=1, generate(HH_Computer)

label define hhcomps 0 "Yes" 1 "No"
label values HH_Computer hhcomps

*internet
recode internet 1=0 2=1, generate(Internet)

label define internets 0 "Yes" 1 "No"
label values Free_education internets

** Need further recoding
*present_class  
recode present_class 1=0 2=1 3=2 , generate(Present_class)

label define present_classs 0 "Yes" 1 "No" 2 "Other" 
label values Present_class present_classs

*schlor_type 
recode schlor_type 1=0 2=1 3=2 4=3 5=4 6=5 9=6, generate(Scholarship_type)

label define schlor_types 0 "ST" 1 "SC" 2 "OBC" 3 "Handicapped" 4 "Merit" 5 "Financially weak" 6 "Others"
label values Scholarship_type schlor_types

*concession 
recode concession 1=0 2=1, generate(Transport_concession)

label define Trans_concessions 0 "Yes" 1 "No"
label values Transport_concession Trans_concessions

*changed_edu_inst 
recode changed_edu_inst 1=0 2=1 3=2 4=3 5=4, generate(Change_insttn_365days)

label define changed_edu_insts 0 "No" 1 "Yes Govt-Private" 2 "Yes Private-Govt" 3 "Yes Gov-Gov" 4 "Yes Private-Private" 
label values Change_insttn_365days changed_edu_insts

*marital_status
recode marital_status 1=0 2=1 3=2 4=3 , generate(Marital_status)

label define marital_statuss 0 "Never Married" 1 "Currently Married" 2 "Widowed" 3 "Divorced/Separated" 
label values Marital_status marital_statuss


* Dropping the old variables
drop sex round religion social_grp inst_type medium_instruction course_type edu_free tut_fee_wav scholarship textbooks stationery midday_meal mode_transport dist_inst private_coaching sector dist1 dist2 dist3 hhcomp internet marital_status changed_edu_inst concession schlor_type present_class
drop lang_home

pwd
clear all
save finaldata1, replace
*save finaldata, replace
use finaldata1, clear
*use finaldata, clear
export delimited using "$root\data\clean\finaldata", replace

/***************************************************************
			using the data for the analysis
***************************************************************/
order IID Round Sector gen_edu age_entry Institution_type age Gender Marital_status Religion Social_group Medium_instruction lang_home Course_type Free_education Tution_fee_wav Scholarship Textbooks Stationary Midday_meal Transport_mode Dist_inst Distance_primary Distance_upper Distance_secondary Private_coaching acad_session other_exp tot_exp HH_Computer Internet Present_class Transport_concession Change_insttn_365days amt_wav Scholarship_type

******************* Regression OLS *****************************

* generating global covariates
global control i.Round  ib4.Change_insttn_365days ib1.HH_Computer ib1.Private_coaching i.Course_type ib1.Sector age_entry age ib1.Gender i.Marital_status ib3.Social_group i.Religion ib1.Medium_instruction lang_home  ib1.Free_education ib2.Tution_fee_wav ib1.Scholarship Textbooks Stationary Midday_meal Transport_mode Dist_inst Distance_primary Distance_upper Distance_secondary  acad_session other_exp tot_exp  i.Internet ib1.Present_class  hh_cons_exp

* OLS regression 

// considering the largest group as reference which is private un-aided schools
reg gen_edu ib2.Institution_type  
eststo: reg gen_edu ib2.Institution_type $control, cl(state_district)

matrix list r(table)
ereturn list


esttab using "$root\outputs\tables\result_1.tex", ///
			replace b(2) se(3) label ///
				ar2 star(* 0.10 ** 0.05 *** 0.01) ///
				mtitle("Multi Regression Output")

eststo clear

view final_code.smcl 

log close 
