*********************************************
*
* Institucion:			UPN
* Autor:				Edinson Tolentino
*********************************************
	cls
	clear all
	*--------------------------------------------------
	*Paso 1: Direccion de carpeta
	*--------------------------------------------------
	*Dirección de carpeta de bases ENAHO
	glo path 	"C:\Users\et396\Dropbox" // ET
	glo main 	"${path}\Docencia\UPN\2024\Talleres\1_Pobreza"
	glo data 	"${main}/Aplicacion"
	glo Tabla 	"${main}/Tablas"

*******************************************************
	cls
	u "${data}/BD_Eleccion_2021.dta",clear
	d
	******************
	*	Estimación   *
	******************
	tab r2r_b
	tab r2r_b, gen(neduc)
	
	gl Xs "rpobre  rluz  lnr6 neduc2 neduc3 neduc4 neduc5 redad"
	gl Zs "rluz  lnr6 neduc2 neduc3 neduc4 neduc5 redad"
	
	* Estadisticas descriptivas
	sum $Xs
		
	* Modelo empirico
	reg rpobre    $Zs , r /*OLS*/
	probit rpobre $Zs , r 	/*PROBIT*/		
	
	* Efecto marginales
	reg rpobre    $Zs  
	estimate store me1
	
	logit rpobre    $Zs  
	margins , dydx(*) post	
	estimate store me2
	
	probit rpobre    $Zs  
	margins , dydx(*) post		
	estimate store me3
	
	estimate table me1 me2 me3 , b(%7.4f) 