USE gestion_escolar;
-- Ruan Piñon Caeri Vladimir

-- Listar el nombre de la materia con el mayor
-- número de alumnos no aprobados.
WITH Reprobados AS (
    SELECT M.id_materia,
           M.nombre_materia,
           COUNT(DISTINCT C.id_alumno) AS total_reprobados
    FROM Materia M
    JOIN Oferta_Academica OA
        ON M.id_materia = OA.id_materia
    JOIN Cursa C
        ON OA.id_oferta = C.id_oferta
    WHERE C.calificacion < 6
    GROUP BY M.id_materia, M.nombre_materia
)

SELECT nombre_materia, total_reprobados
FROM Reprobados
WHERE total_reprobados = (
    SELECT MAX(total_reprobados)
    FROM Reprobados
);

-- Listar el nombre del profesor que tiene 
-- al menos un curso con todos sus alumnos aprobados.

SELECT DISTINCT P.nombre,
       P.apellido_paterno,
       P.apellido_materno
FROM Profesor P
JOIN Oferta_Academica OA
    ON P.id_profesor = OA.id_profesor
JOIN Cursa C
    ON OA.id_oferta = C.id_oferta
GROUP BY P.id_profesor,
         P.nombre,
         P.apellido_paterno,
         P.apellido_materno,
         OA.id_oferta
HAVING COUNT(*) = SUM(
    CASE
        WHEN C.calificacion >= 6 THEN 1
        ELSE 0
    END
);
