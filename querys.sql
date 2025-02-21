SELECT 
    c.id,
    c.nombre,
    c.apellido,
    SUM(v.monto) AS total_ventas
FROM clientes c
JOIN ventas v ON c.id = v.cliente_id
WHERE v.fecha >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY c.id, c.nombre, c.apellido
ORDER BY total_ventas DESC
LIMIT 5;

SELECT 
    c.id,
    c.nombre,
    c.apellido,
    AVG(v.monto) AS ticket_promedio
FROM clientes c
JOIN ventas v ON c.id = v.cliente_id
WHERE v.fecha >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY c.id, c.nombre, c.apellido;

SELECT 
    CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo,
    SUM(v.monto) AS total_ventas
FROM clientes c
JOIN ventas v ON c.id = v.cliente_id
GROUP BY c.id, c.nombre, c.apellido;


SELECT 
    AVG(monto_total) AS ingreso_promedio_mensual
FROM (
    SELECT 
        DATE_FORMAT(fecha, '%Y-%m') AS mes,
        SUM(monto) AS monto_total
    FROM ventas
    GROUP BY mes
) AS ventas_por_mes;

SELECT 
    c.id,
    CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo,
    SUM(v.monto) AS total_ventas,
    RANK() OVER (ORDER BY SUM(v.monto) DESC) AS ranking
FROM clientes c
JOIN ventas v ON c.id = v.cliente_id
WHERE v.fecha >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY c.id, c.nombre, c.apellido
ORDER BY ranking;

SELECT 
    c.id,
    CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo,
    t.total_ventas
FROM (
    SELECT 
        cliente_id,
        SUM(monto) AS total_ventas
    FROM ventas
    GROUP BY cliente_id
) AS t
JOIN clientes c ON t.cliente_id = c.id
WHERE t.total_ventas > (
    SELECT AVG(total_ventas)
    FROM (
        SELECT SUM(monto) AS total_ventas
        FROM ventas
        GROUP BY cliente_id
    ) AS sub
);
