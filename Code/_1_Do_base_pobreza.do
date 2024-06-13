	cls
	clear all
	gl path 	"C:\Users\et396\Dropbox"
	gl enaho 	"${path}\BASES\ENAHO"
	gl Dofile	"${path}\BASES\ENAHO\DISEL-MTPE"
	gl Output 	"${enaho}\Salida_indicadores"

	use "${enaho}/2022/sumaria-2022.dta",clear

	* Creacion de variables
	do "${Dofile}/2.- rArea.do"
	do "${Dofile}/2.- rdominio.do"
	do "${Dofile}/3.- rDpto y rDpto2.do"

	* Calculo y estimacion de la pobreza 
	* segun: area, dominio y departamento
	*Utilizar el comando svy
	*h svy
	g pobre = (pobreza<3)
	g factor_new = factor07*mieperho
	svyset conglome [pweight=factor_new], strata(estrato)
	svy : mean pobre
	svy : mean pobre, over(rArea) coeflegend
	svy : mean pobre, over(rdominio) 
	svy : mean pobre, over(rDpto) 
	
	*findit sepov
	g rgasto = gashog2d/ (12*mieperho)
	sepov rgasto [w=factor_new] , povline(linea) psu(conglome) strata(estrato)
	
	* Manual
*** Calculo de brecha de pobreza

	gen rbrecha=(linea-rgasto)/linea if pobre==1
	replace rbrecha=0 if pobre==0
	label variable rbrecha "Brecha de pobreza (%)"
	
	sum rbrecha [aw=factor_new]
	tabstat rbrecha [aw=factor_new], by(rArea) stat(mean sd)
	
*** Calculo de Severidad de pobreza total

	gen rseveri=rbrecha^2
	label variable rseveri "Severidad de la pobreza"
	sum rseveri [aw=factor_new]
	