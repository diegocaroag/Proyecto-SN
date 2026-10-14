SELECT e.id_estudiante,e.estado,CONCAT(p_est.nombres, ' ', p_est.apellidos) AS nombre_estudiante,a.parentesco,CONCAT(p_acu.nombres, ' ', p_acu.apellidos) AS nombre_acudiente
FROM estudiante e
INNER JOIN persona p_est ON e.id_persona = p_est.id_persona
INNER JOIN acudiente_estudiante ae ON e.id_estudiante = ae.id_estudiante
INNER JOIN acudiente a ON ae.id_acudiente = a.id_acudiente
INNER JOIN persona p_acu ON a.id_persona = p_acu.id_persona;