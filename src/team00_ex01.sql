SELECT DISTINCT
    t1.name,
    t1.lastname,
    t1.currency_name,
    t1.money * COALESCE((
        SELECT cur1.rate_to_usd
        FROM currency cur1
        WHERE t1.currency_id = cur1.id
        AND cur1.updated <= t1.updated
        ORDER BY cur1.updated DESC
        LIMIT 1), (
        SELECT cur2.rate_to_usd
        FROM currency cur2
        WHERE t1.currency_id = cur2.id
        AND cur2.updated > t1.updated
        ORDER BY cur2.updated ASC
        LIMIT 1
    )) AS currency_in_usd
FROM (
    SELECT
        CASE
            WHEN "user".name IS NOT NULL THEN "user".name
            ELSE 'not defined'
        END AS name,
        CASE
            WHEN "user".lastname IS NOT NULL THEN "user".lastname
            ELSE 'not defined'
        END AS lastname,
        currency.name AS currency_name,
        balance.money,
        balance.currency_id,
        balance.updated
    FROM balance
    LEFT JOIN "user" ON balance.user_id = "user".id
    LEFT JOIN currency ON balance.currency_id = currency.id
) t1
WHERE currency_name IS NOT NULL
ORDER BY name DESC, lastname ASC, currency_name ASC;