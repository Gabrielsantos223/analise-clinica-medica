-- QUERYs de Mercado --

-- TOTAL DE PACIENTES POR CIDADE --
SELECT e.cidade,
	COUNT(p.id) AS Total_Pacientes
FROM enderecos e
JOIN pacientes p ON p.id = e.paciente_id
GROUP BY e.cidade
ORDER BY total_pacientes DESC; 

-- TOTAL DE CONSULTAS PACIENTES --
SELECT p.nome,
	COUNT(c.id) AS total_consultas,
    SUM(CASE WHEN c.status_consulta = 'realizada' THEN 1 ELSE 0 END ) AS consultas_realizadas,
    SUM(CASE WHEN c.status_consulta = 'cancelada' THEN 1 ELSE 0 END ) AS consultas_canceladas,
    SUM(CASE WHEN c.status_consulta = 'agendada' THEN 1 ELSE 0 END ) AS consultas_agendadas
FROM consultas c
JOIN pacientes p ON c.paciente_id = p.id
GROUP BY p.id, p.nome
ORDER BY total_consultas DESC;


-- PACIENTES QUE MAIS FIZERAM CONSULTAS -- 
WITH consultas_por_paciente AS (

SELECT 
    p.nome,
    COUNT(c.id) AS total_consultas
FROM consultas c
JOIN pacientes p 
    ON c.paciente_id = p.id
GROUP BY p.id, p.nome

)

SELECT *,
       ROW_NUMBER() OVER (ORDER BY total_consultas DESC) AS ranking
FROM consultas_por_paciente;



-- PACIENTES QUE MAIS FALTARAM E A TAXA DE AUSENCIA --

WITH consultas_por_pacientes AS (
SELECT p.nome,
	COUNT(c.id) AS total_consultas,
    SUM(CASE WHEN c.status_consulta = 'realizada' THEN 1 ELSE 0 END ) AS consultas_realizadas,
    SUM(CASE WHEN c.status_consulta = 'cancelada' THEN 1 ELSE 0 END ) AS consultas_canceladas,
    SUM(CASE WHEN c.status_consulta = 'agendada' THEN 1 ELSE 0 END ) AS consultas_agendadas
FROM consultas c
JOIN pacientes p ON c.paciente_id = p.id
GROUP BY p.id, p.nome
),

taxas AS (
SELECT 
	nome,
    total_consultas,
    consultas_canceladas,
    ROUND(consultas_canceladas * 100.0 / total_consultas, 2) AS taxa_ausencia
FROM consultas_por_pacientes
)

SELECT 
    nome,
    total_consultas,
    consultas_canceladas,
    taxa_ausencia,
    ROW_NUMBER() OVER (ORDER BY taxa_ausencia DESC) AS ranking
FROM taxas;


-- RANKING DOS MEDICOS QUE MAIS CONSULTARAM --

WITH consultas_por_medicos AS (
SELECT m.nome,
	  COUNT(c.id) AS total_consultas,
      SUM(c.valor) AS faturamento_do_medico
FROM medicos m
JOIN consultas c ON m.id = c.medico_id
GROUP BY m.nome, m.id
)
SELECT 
	nome,
    total_consultas,
    faturamento_do_medico,
    ROW_NUMBER() OVER( ORDER BY total_consultas DESC) ranking
FROM consultas_por_medicos;


-- CONSULTAS POR MÊS E SEU FATURAMENTO --
SELECT
		MONTH(data_consulta) as numero_mes,
		MONTHNAME(data_consulta) AS mes,
        COUNT(*) AS total_consultas,
        SUM(valor) AS fatumento_do_mes
FROM consultas
GROUP BY mes
ORDER BY numero_mes;


-- ESPECIALIDADE COM O MAIOR FATURAMENTO --
WITH faturamento_especialidade AS (
SELECT
	m.especialidade,
    COUNT(c.id) AS total_consultas,
    SUM(valor) AS faturamento
FROM medicos m
JOIN consultas c ON m.id = c.medico_id
GROUP BY m.especialidade
)
SELECT
	especialidade,
    total_consultas,
    faturamento,
    ROUND(faturamento / total_consultas ,2) AS ticket_medio,
    ROW_NUMBER() OVER(ORDER BY faturamento DESC) AS ranking
    FROM faturamento_especialidade
ORDER BY faturamento DESC

-- PROGRESSÃO DE FATURAMENTO POR MÊS -- 
SELECT
	MONTH(data_consulta) AS numero_mes,
	MONTHNAME(data_consulta) AS mes,
    SUM(valor) AS faturamento,
    SUM(SUM(valor)) OVER(ORDER BY MONTH(data_consulta)) AS faturamento_acumulado,
    COALESCE(SUM(valor) - LAG(SUM(valor)) OVER(ORDER BY MONTH(data_consulta)),0) AS diferença
FROM consultas
GROUP BY mes, numero_mes
ORDER BY numero_mes;


-- PACIENTES QUE GERARAM MAIS RECEITAS COM CONSULTAS --
WITH gasto_clientes AS (
SELECT
	ROW_NUMBER() OVER(ORDER BY SUM(c.valor) DESC) AS ranking,
	p.nome,
    COUNT(c.id) AS total_consultas,
    SUM(c.valor) AS gasto_total
FROM pacientes p
JOIN consultas c ON p.id = c.paciente_id
GROUP BY p.nome, p.id
)
SELECT
		ranking,
        nome,
        total_consultas,
        gasto_total,
        ROUND(gasto_total / total_consultas ,2) AS ticket_medio
FROM gasto_clientes
ORDER BY ranking;
