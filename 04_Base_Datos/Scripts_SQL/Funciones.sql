drop function calificacion_promes;
DELIMITER //

create function calificacion_promes (p_id_estudiante INt)
returns decimal (4,2)
reads sql data
begin
declare v_promedio decimal(4,2);
select avg(nota) into v_promedio
from calificacion
where id_estudiante = p_id_estudiante;
if v_promedio is null then 
set v_promedio = 0.00;
end if;
   return v_promedio;
end //
DELIMITER ;
SELECT calificacion_promes(1) AS promedio_estudiante;


drop function rango_gm;
DELIMITER //
create function  rango_gm(p_id_estudiante INT) 
returns varchar(30)
reads sql data
begin
declare v_puntos int;
select puntos_acumulados into v_puntos
from progreso
where id_estudiante = p_id_estudiante;
    if v_puntos >= 500 then
        RETURN 'Leyenda';
    elseif v_puntos >= 200 then
        return 'Avanzado';
    elseif v_puntos >= 100 then
        return 'Intermedio';
    else
        return 'Novato';
    end if;
end //
DELIMITER ;

SELECT rango_gm(3) AS puntos_estudiante;