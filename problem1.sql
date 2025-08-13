-- Active: 1750240490853@@127.0.0.1@5432@conservation_db@public
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    region VARCHAR(50)
);

INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50),
    scientific_name VARCHAR(100),
    discovery_date DATE,
    conservation_status VARCHAR(50)
);

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species(species_id),
    ranger_id INT REFERENCES rangers(ranger_id),
    location VARCHAR(100),
    sighting_time TIMESTAMP,
    notes TEXT,
    -- FOREIGN KEY (species_id) REFERENCES species(species_id),
    -- FOREIGN KEY (ranger_id) REFERENCES rangers(ranger_id)
);

INSERT INTO sightings ( species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);



-- 1 Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO rangers (name , region) VALUES
('Derek Fox', 'Coastal  Plains');

-- 2 Count unique species ever sighted.
SELECT count(DISTINCT species_id)  FROM sightings
;

-- 3 Find all sightings where the location includes "Pass".
SELECT * FROM sightings 
WHERE location NOT LIKE '%Pass%';


-- 4 List each ranger's name and their total number of sightings.
SELECT name, count(ranger_id)  FROM rangers
JOIN sightings USING(ranger_id)
GROUP BY name
;
SELECT * FROM species;

SELECT common_name, species_id FROM species
LEFT JOIN sightings USING(species_id)
;
SELECT common_name, species_id FROM species
RIGHT JOIN sightings USING(species_id)
;

-- 6 Show the most recent 2 sightings.
SELECT common_name, sighting_time, name  FROM sightings
JOIN rangers USING(ranger_id )
JOIN species USING(species_id)
ORDER BY sighting_time DESC
LIMIT 2
;

-- 7 Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species
SET conservation_status = 'historic'
WHERE extract(YEAR FROM discovery_date) < 1800
 ;

