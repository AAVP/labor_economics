/*
	Trabajo Final Economía Laboral
	Profesor: Rafael Sánchez
	Autor: Alexander Valenzuela
*/

clear all

cd "/Users/avalenzuela/Library/CloudStorage/OneDrive-UniversidadCatólicadeChile/Universidad/8vo_semestre/Economía Laboral/Trabajo/Entrega 3" // Espacio de trabajo

use base_post_terremoto_2010, replace

drop if folio_2009 == "" | folio_2010 == ""
keep folio_2010 o_2010 zona_2009 numper_2009 edad_2009 e7c_2009 e7t_2009 yoprcor_2009 yoprcorh_2009 yautcor_2009 yautcorh_2009 ytotcor_2009 ytotcorh_2009 zona_2010 numper_2010 edad_2010 e4c_2010 e4t_2010 yoprcor_2010 yoprcorh_2010 yautcor_2010 yautcorh_2010 ytotcor_2010 ytotcorh_2010

gen folio_2009 = folio_2010
gen o_2009 = o_2010
stack folio_2009 o_2009 zona_2009 numper_2009 edad_2009 e7c_2009 e7t_2009 yoprcor_2009 yoprcorh_2009 yautcorh_2009 ytotcor_2009 yautcor_2009 ytotcorh_2009  folio_2010 o_2010 zona_2010 numper_2010 edad_2010 e4c_2010 e4t_2010 yoprcor_2010 yoprcorh_2010 yautcor_2010 yautcorh_2010 ytotcor_2010 ytotcorh_2010, into(folio orden zona numper edad curso tipo_estudios yoprcor yoprcorh yautcor yautcorh ytotcor ytotcorh)
replace _stack = 2009 if _stack == 1
replace _stack = 2010 if _stack == 2
rename _stack año

save datos_matriz_transicion, replace

use datos_matriz_transicion, replace

egen id = group(folio orden)
xtset id año, yearly

**** Matriz de transición 2009-2010 ****

gen yautcorhind = yautcorh * sqrt(numper)

xtile percentil_2009 = yautcorhind if año == 2009 & orden == 1, nq(100)
xtile percentil_2010 = yautcorhind if año == 2010 & orden == 1, nq(100)
drop if percentil_2009 == 1 | percentil_2009 == 100
drop if percentil_2010 == 1 | percentil_2010 == 100
xtile decil_2009 = yautcorhind if año == 2009 & orden == 1, nq(10)
xtile decil_2010 = yautcorhind if año == 2010 & orden == 1, nq(10)
gen decil = decil_2009 if año == 2009 & orden == 1
replace decil = decil_2010 if año == 2010 & orden == 1
drop if decil == .

xttrans decil

count if decil_2009 != .


**** Cambio en los ingresos individuales 2009-2010 ****

use datos_matriz_transicion, replace
egen id = group(folio orden)
xtset id año, yearly

matrix cambio_ingresos = J(3,4,.)
matrix rownames cambio_ingresos = Aumenta Sin_cambio Disminuye
matrix colnames cambio_ingresos = Cambio_ytot_(%) Cambio_ytoth_(%) Cambio_yopr_(%) Cambio_yoprh_(%)

bysort folio orden: gen variacion_ytot_2010 = (ytotcor[2]-ytotcor[1])/ytotcor[1]
count if variacion_ytot >= .05 & año == 2010 & variacion_ytot != .
local aumenta = r(N)
count if variacion_ytot < .05 & variacion_ytot > -.05 & año == 2010 & variacion_ytot != .
local sin_cambio = r(N)
count if variacion_ytot <= -.05 & año == 2010 & variacion_ytot != .
local disminuye = r(N)
count if año == 2010 & variacion_ytot != .
local total = r(N)

matrix cambio_ingresos[1,1] = round((`aumenta'/`total') * 100,.01)
matrix cambio_ingresos[2,1] = round((`sin_cambio'/`total') * 100,.01)
matrix cambio_ingresos[3,1] = round((`disminuye'/`total') * 100,.01)

bysort folio orden: gen variacion_ytoth_2010 = (ytotcorh[2]-ytotcorh[1])/ytotcorh[1]
count if variacion_ytoth >= .05 & año == 2010 & variacion_ytoth != .
local aumenta = r(N)
count if variacion_ytoth < .05 & variacion_ytoth > -.05 & año == 2010 & variacion_ytoth != .
local sin_cambio = r(N)
count if variacion_ytoth <= -.05 & año == 2010 & variacion_ytoth != .
local disminuye = r(N)
count if año == 2010 & variacion_ytoth != .
local total = r(N)

matrix cambio_ingresos[1,2] = round((`aumenta'/`total') * 100,.01)
matrix cambio_ingresos[2,2] = round((`sin_cambio'/`total') * 100,.01)
matrix cambio_ingresos[3,2] = round((`disminuye'/`total') * 100,.01)

bysort folio orden: gen variacion_yopr_2010 = (yoprcor[2]-yoprcor[1])/yoprcor[1]
count if variacion_yopr >= .05 & año == 2010 & variacion_yopr != .
local aumenta = r(N)
count if variacion_yopr < .05 & variacion_yopr > -.05 & año == 2010 & variacion_yopr != .
local sin_cambio = r(N)
count if variacion_yopr <= -.05 & año == 2010 & variacion_yopr != .
local disminuye = r(N)
count if año == 2010 & variacion_yopr != .
local total = r(N)

matrix cambio_ingresos[1,3] = round((`aumenta'/`total') * 100,.01)
matrix cambio_ingresos[2,3] = round((`sin_cambio'/`total') * 100,.01)
matrix cambio_ingresos[3,3] = round((`disminuye'/`total') * 100,.01)

bysort folio orden: gen variacion_yoprh_2010 = (yoprcorh[2]-yoprcorh[1])/yoprcorh[1]
count if variacion_yoprh >= .05 & año == 2010 & variacion_yoprh != .
local aumenta = r(N)
count if variacion_yoprh < .05 & variacion_yoprh > -.05 & año == 2010 & variacion_yoprh != .
local sin_cambio = r(N)
count if variacion_yoprh <= -.05 & año == 2010 & variacion_yoprh != .
local disminuye = r(N)
count if año == 2010 & variacion_yoprh != .
local total = r(N)

matrix cambio_ingresos[1,4] = round((`aumenta'/`total') * 100,.01)
matrix cambio_ingresos[2,4] = round((`sin_cambio'/`total') * 100,.01)
matrix cambio_ingresos[3,4] = round((`disminuye'/`total') * 100,.01)

matrix list cambio_ingresos

**** Regresión cambio de ingresos (1ra especificacion) 2009-2010 ****

use datos_matriz_transicion, replace

gen años_educacion = 0 if tipo_estudios == 1
replace años_educacion = curso if tipo_estudios == 2
replace años_educacion = curso if tipo_estudios == 3
replace años_educacion = curso if tipo_estudios == 4
replace años_educacion = 8 + curso if tipo_estudios == 5
replace años_educacion = 8 + curso if tipo_estudios == 6
replace años_educacion = 8 + curso if tipo_estudios == 7
replace años_educacion = 8 + curso if tipo_estudios == 8
replace años_educacion = 12 + curso if tipo_estudios == 9
replace años_educacion = 12 + curso if tipo_estudios == 10
replace años_educacion = 12 + curso if tipo_estudios == 11
replace años_educacion = 12 + curso if tipo_estudios == 12
replace años_educacion = 12 + curso if tipo_estudios == 13
replace años_educacion = 12 + curso if tipo_estudios == 14
replace años_educacion = 12 + curso if tipo_estudios == 15
replace años_educacion = 0 if curso == 16

drop if yautcor == . | yautcor == 0
bysort folio orden: drop if _N == 1
xtile percentil_2009 = yautcor if año == 2009, nq(100)
xtile percentil_2010 = yautcor if año == 2010, nq(100)
drop if percentil_2009 == 1 | percentil_2009 == 100 | percentil_2010 == 1 | percentil_2010 == 100
by folio orden: drop if _N == 1

by folio orden: gen cambio_ingreso = yautcor[2] - yautcor[1]

xtile percentil_cambio_2009 = cambio_ingreso if año == 2009, nq(100)
xtile percentil_cambio_2010 = cambio_ingreso if año == 2010, nq(100)
drop if percentil_cambio_2009 == 1 | percentil_cambio_2009 == 100 | percentil_cambio_2010 == 1 | percentil_cambio_2010 == 100
bysort folio orden: drop if _N == 1

gen años_educacion_cuadrado = años_educacion^2
gen edad_cuadrado = edad^2

reg cambio_ingreso yautcor if año == 2009
est store especificacion_1
reg cambio_ingreso yautcor años_educacion años_educacion_cuadrado if año == 2009
est store especificacion_2
reg cambio_ingreso yautcor años_educacion años_educacion_cuadrado edad edad_cuadrado zona if año == 2009
est store especificacion_3
outreg2 [*] using resultados_regresion.doc, replace


**** Regresión cambio de ingresos (2da especificacion) 2009-2010 ****

xtile decil_2009 = yautcor if año == 2009, nq(10)

reg cambio_ingreso años_educacion años_educacion_cuadrado i.decil_2009 if año == 2009
outreg2 using resultados_regresion_2.doc, replace


**** Movilidad intergeneracional 2010. Proxy: educación ****

* Basado en: Núñez Errázuriz, J. y Miranda, L. (2009).La movilidad intergeneracional del ingreso y la educación en Chile. Disponible en http://repositorio.uchile.cl/handle/2250/152218

/*
use base_post_terremoto_2010, replace

keep folio_2010 o_2010 pco1_2010 edad_2010 e4c_2010 e4t_2010
gen años_educacion = 0 if e4t_2010 == 1
replace años_educacion = e4c_2010 if e4t_2010 == 2
replace años_educacion = e4c_2010 if e4t_2010 == 3
replace años_educacion = e4c_2010 if e4t_2010 == 4
replace años_educacion = 8 + e4c_2010 if e4t_2010 == 5
replace años_educacion = 8 + e4c_2010 if e4t_2010 == 6
replace años_educacion = 8 + e4c_2010 if e4t_2010 == 7
replace años_educacion = 8 + e4c_2010 if e4t_2010 == 8
replace años_educacion = 12 + e4c_2010 if e4t_2010 == 9
replace años_educacion = 12 + e4c_2010 if e4t_2010 == 10
replace años_educacion = 12 + e4c_2010 if e4t_2010 == 11
replace años_educacion = 12 + e4c_2010 if e4t_2010 == 12
replace años_educacion = 12 + e4c_2010 if e4t_2010 == 13
replace años_educacion = 12 + e4c_2010 if e4t_2010 == 14
replace años_educacion = 12 + e4c_2010 if e4t_2010 == 15
replace años_educacion = 0 if e4t_2010 == 16

save datos_movilidad_educacion, replace
*/

use datos_movilidad_educacion, replace

gen padre = 1 if pco1_2010 == 1 | pco1_2010 == 2
replace padre = 0 if pco1_2010 == 3 | pco1_2010 == 4 | pco1_2010 == 5
drop if padre == .

reshape wide años_educacion, i(folio_2010 o_2010) j(padre)

by folio_2010: egen años_educacion_padres = mean(años_educacion1)
by folio_2010: egen edad_padres_no_final = mean(edad_2010) if años_educacion1 != .
by folio_2010: egen edad_padres = mean(edad_padres_no_final)
drop edad_padres_no_final
drop años_educacion1
drop if años_educacion0 == .
rename años_educacion0 años_educacion_hijos

reg años_educacion_hijos años_educacion_padres if edad_padres >= 23 & edad_padres <= 34
reg años_educacion_hijos años_educacion_padres if edad_padres >= 35 & edad_padres <= 44
reg años_educacion_hijos años_educacion_padres if edad_padres >= 45 & edad_padres <= 54
reg años_educacion_hijos años_educacion_padres if edad_padres >= 55 & edad_padres <= 65


scatter años_educacion_hijos años_educacion_padres if edad_padres >= 23 & edad_padres <= 34
scatter años_educacion_hijos años_educacion_padres if edad_padres >= 35 & edad_padres <= 44
scatter años_educacion_hijos años_educacion_padres if edad_padres >= 45 & edad_padres <= 54
scatter años_educacion_hijos años_educacion_padres if edad_padres >= 55 & edad_padres <= 65 
