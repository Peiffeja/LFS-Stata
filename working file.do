cd //directory

*comand to change csv to .dta 
*to use this loop i had to change the filenames into just their years as names
forvalues i = 2003/2018 {
	clear
	import delimited `i'.csv
	save `i'.dta, replace
}

//string variablen bestimmter variablen zu int anpassen. formate in allen files anpassen um zusammenfassung zu erleichtern
*nace1d
forvalues i = 2003/2018 {
	clear
	use `i'.dta
	*passendes command finden
	save `i'.dta, replace
}

*na111d
forvalues i = 2003/2018 {
	clear
	*passendes command finden
	save `i'.dta, replace
}


*speichere älteste als neue zusammenfassungsdatei ab
use 2003
save Länderkürzel_2003-2018.dta, replace //Länderkürzel mit 2 Buchstaben für Land ersetzen, auch bei folgendem append

*füge alle anderen nötigen Jahre hinzu
forvalues i = 2004/2018 {
	append using `i'.dta, force
	save Länderkürzel_2003-2018.dta, replace
}

* Daten aufräumen und dann neugebildeten Datensatz aufrufen
clear
use Länderkürzel_2003-2018

*use do-file Labels Variable LFS to label all variables
do "D:\Stata\LFS\Label Variable LFS.do"

*use do file Label Var Value LFS to give different specific var values description
do "D:\Stata\LFS\Label Var Value LFS.do"

*nur variablen behalten die villeicht interessant sind für mich (weiterer Sinn)
keep wstator stapro nace1d na111d ISCO3C isco3d is883d countryw ftpt temp exist2j stapro2j nace2j1d na112j1d existpr hat97lev refyear country na11s isco1d is881d na112js hatlev1d
*manche können vielleich auch noch interessant sein --> hatvoc educvoc hat11lev --> aber keine Werte in ihren Spalten?

*variable die ich min. behalten sollte
keep wstator stapro nace1d na111d isco3d is883d refyear country na11s isco1d is881d na112js harlev1d

*Fasse ISCOs in einer Variable zusammen
gen ISCO3C = max(isco3d,is883d)
order ISCO3C, after(na111d)

*möglichkeit isco1d und is881d zu vereinen um nach 1 digit occupation zu sortieren
gen ISCO1DU = max(isco1d,is881d)
order ISCO1DU, after(na11s)

*anzahl aller ISCO 3 digits p.y if Wstator gleich/kleiner 3
table ( ISCO3C ) ( refyear ) () if wstator  <= 3, zerocounts
*Möglichkeit es auf ISCO1DU oder nace1d anzupassen