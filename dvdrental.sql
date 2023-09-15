-- Section B, creating tables

--DROP TABLE IF EXISTS detailed_report, summary_report CASCADE;
/*
CREATE TABLE detailed_report (
	report_id SERIAL PRIMARY KEY,
	payment_date TIMESTAMP WITHOUT TIME ZONE,
	film_title VARCHAR(255),
	genre_name VARCHAR(255),
	amount NUMERIC(10,2)
);

CREATE TABLE summary_report (
	genre_name VARCHAR(255),
	total_amount NUMERIC(10,2),
	PRIMARY KEY (genre_name)
);
*/
/*
--Section D, custom transformation

--renaming animation section to animated
CREATE OR REPLACE FUNCTION transform_genre_name() RETURNS TRIGGER AS $$
BEGIN
	IF NEW.genre_name = 'Animation' THEN
		NEW.genre_name := 'Animated';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--applying transformation

CREATE TRIGGER transform_genre_name_trigger
BEFORE INSERT OR UPDATE ON detailed_report
FOR EACH ROW
EXECUTE FUNCTION transform_genre_name();
*/
/*
--Section E, creating trigger, updates summary table

CREATE OR REPLACE FUNCTION update_summary() RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO summary_report(genre_name, total_amount)
	VALUES (NEW.genre_name, NEW.amount)
	ON CONFLICT(genre_name)
	DO UPDATE SET total_amount = summary_report.total_amount + NEW.amount;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_summary_trigger
AFTER INSERT ON detailed_report
FOR EACH ROW
EXECUTE FUNCTION update_summary();
*/
/*
-- Section C, query to extract data for detailed section

INSERT INTO detailed_report(payment_date, film_title, genre_name, amount)
SELECT
	p.payment_date::TIMESTAMP WITHOUT TIME ZONE,
	f.title,
	c.name, 
	p.amount
FROM
	payment p
JOIN
	rental r ON p.rental_id = r.rental_id
JOIN
	inventory i ON r.inventory_id = i.inventory_id
JOIN
	film f ON i.film_id = f.film_id
JOIN
	film_category fc ON f.film_id = fc.film_id
JOIN
	category c ON fc.category_id = c.category_id;
SELECT * FROM detailed_report;
*/
/*
--Section F, stored proceedure, refreshes data in both tables

CREATE OR REPLACE PROCEDURE refresh_data() AS $$
BEGIN
	TRUNCATE TABLE detailed_report, summary_report;
	CALL extract_data_for_detailed_report();
END;
$$ LANGUAGE plpgsql;
*/
/*
INSERT INTO summary_report (genre_name, total_amount)
SELECT genre_name, SUM(amount)
FROM detailed_report
GROUP BY genre_name
ON CONFLICT(genre_name)
DO UPDATE SET total_amount = EXCLUDED.total_amount;

SELECT genre_name, total_amount
FROM summary_report
ORDER BY total_amount DESC
LIMIT 5;
*/