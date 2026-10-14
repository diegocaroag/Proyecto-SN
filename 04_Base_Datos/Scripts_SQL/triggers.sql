drop table historial_pun;
CREATE TABLE historial_pun (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT,
    puntos_anteriores int,
   puntos_nuevos int,
    fecha_cambio DATETIME
);

DELIMITER //
create trigger tr_puntos
after update on progreso for each row
begin
if old.puntos_acumulados <> new.puntos_acumulados then
insert into historial_pun (id_estudiante, puntos_anteriores, puntos_nuevos, fecha_cambio)
values (new.id_estudiante,old.puntos_acumulados,new.puntos_acumulados, now());
end if;
end //
DELIMITER ;
update progreso set puntos_acumulados = puntos_acumulados - 2120 where id_estudiante =1;
select * from historial_pun;

DELIMITER //
create trigger tr_res_progreso
before delete on progreso
for each row 
begin
   
    insert into historial_eliminados (id_estudiante, puntos_finales, fecha_eliminacion)
    values (old.id_estudiante, old.puntos_acumulados, now());
end //
DELIMITER ;
delete from progreso where id_estudiante = 3;
select * from historial_eliminados;