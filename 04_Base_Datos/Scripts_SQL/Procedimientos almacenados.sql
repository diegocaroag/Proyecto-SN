drop procedure if exists suma_puntos;
DELIMITER //
create procedure suma_puntos( in p_id_estudiante int, out p_puntos_totales int)
begin 
select sum(puntos_acumulados) into p_puntos_totales
from progreso 
where id_estudiante = p_id_estudiante;
if p_puntos_totales is null then 
set p_puntos_totales = 0;
end if;
end //
DELIMITER ;
CALL suma_puntos(1, @resultado);
SELECT @resultado AS puntos_totales;


drop procedure if exists actu_racha
DELIMITER //
create procedure actu_racha(in p_id_estudiante int, in p_nueva_racha int)
begin 
update progreso
set racha_dias = p_nueva_racha
where id_estudiante = p_id_estudiante;
end //
DELIMITER ;
call actu_racha(1, 2);
select * from progreso where id_estudiante = 1;