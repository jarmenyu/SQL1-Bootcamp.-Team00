DROP TABLE IF EXISTS nodes;
CREATE TABLE nodes
(
    point1 VARCHAR,
    point2 VARCHAR,
    cost   INTEGER
);

INSERT INTO nodes (point1,
                   point2,
                   cost)
VALUES ('a', 'b', 10),
       ('b', 'c', 35),
       ('b', 'a', 10),
       ('a', 'c', 15),
       ('c', 'a', 15),
       ('a', 'd', 20),
       ('d', 'a', 20),
       ('c', 'b', 35),
       ('b', 'd', 25),
       ('d', 'b', 25),
       ('d', 'c', 30),
       ('c', 'd', 30);

WITH RECURSIVE
    tours AS
        (SELECT point1,
                point2,
                cost,
                array [point1, point2] AS tour,
                cost                   AS total_cost

         FROM nodes

         UNION ALL


         SELECT n.point1,
                n.point2,
                n.cost,
                array_append(tour, n.point2) AS tour,
                total_cost + n.cost          AS total_cost
         FROM tours t
                  INNER JOIN nodes n ON n.point1 = t.point2
         WHERE array_length(tour, 1) <= 5
           AND (NOT n.point2 = ANY (t.tour) OR (array_length(t.tour, 1) = 4 AND t.tour[1] = n.point2))),
    min_cost AS (SELECT MIN(total_cost) as min_total_cost
                 FROM tours
                 WHERE array_length(tour, 1) = 5)


SELECT total_cost, tour
FROM tours
         JOIN min_cost ON tours.total_cost = min_cost.min_total_cost
WHERE tour[1] = 'a'
  AND array_length(tour, 1) = 5
ORDER BY total_cost, tour;

