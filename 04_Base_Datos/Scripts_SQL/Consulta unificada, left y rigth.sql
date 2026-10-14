SELECT p_est.id_persona, c.codigo_curso, c.nombre_curso, concat(p_est.nombres, ' ' , p_est.apellidos) as nombre_estudiante, e.id_estudiante
FROM estudiante e
RIGHT  JOIN persona p_est ON e.id_persona = p_est.id_persona
LEFT JOIN curso c ON c.codigo_curso = e.codigo_curso
