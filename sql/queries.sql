-- Query xyz cluster;

-- By id --
WITH RECURSIVE tree(id,cid) AS (
SELECT c.id, c.cid FROM cluster c
INNER JOIN star s ON s.id = c.id
WHERE s.id = '4'
UNION ALL
SELECT c.id, c.cid FROM cluster c
JOIN tree t ON c.id = t.cid
)
SELECT DISTINCT t.cid from tree t;
