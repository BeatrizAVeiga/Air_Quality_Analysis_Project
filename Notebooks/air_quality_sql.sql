USE air_quality_database;

SELECT * FROM districts;

/* Creating a combined table with each distric, municipality and parish data */ 
CREATE TABLE combined_air_quality AS
SELECT 
    'District' AS location_level,
    location AS location_name,
    date,
    latitude,
    longitude,
    dust,
    uv_index,
    uv_index_clear_sky,
    alder_pollen,
    birch_pollen,
    grass_pollen,
    mugwort_pollen,
    olive_pollen,
    ragweed_pollen,
    ozone,
    pm2_5,
    pm10,
    carbon_monoxide,
    carbon_dioxide,
    nitrogen_dioxide,
    sulphur_dioxide,
    european_aqi,
    temperature_2m,
    apparent_temperature,
    rain,
    precipitation,
    relative_humidity_2m,
    wind_speed_10m,
    wind_speed_100m,
    wind_direction_10m,
    wind_direction_100m,
    soil_temperature_0_to_7cm,
    soil_moisture_0_to_7cm,
    cloud_cover,
    pressure_msl,
    cloud_cover_mid,
    cloud_cover_low,
    date_only,
    time_of_day,
    is_holiday, 
    aqi_category 
FROM districts

UNION ALL

SELECT 
    'Municipality' AS location_level,
    location AS location_name,
    date,
    latitude,
    longitude,
    dust,
    uv_index,
    uv_index_clear_sky,
    alder_pollen,
    birch_pollen,
    grass_pollen,
    mugwort_pollen,
    olive_pollen,
    ragweed_pollen,
    ozone,
    pm2_5,
    pm10,
    carbon_monoxide,
    carbon_dioxide,
    nitrogen_dioxide,
    sulphur_dioxide,
    european_aqi,
    temperature_2m,
    apparent_temperature,
    rain,
    precipitation,
    relative_humidity_2m,
    wind_speed_10m,
    wind_speed_100m,
    wind_direction_10m,
    wind_direction_100m,
    soil_temperature_0_to_7cm,
    soil_moisture_0_to_7cm,
    cloud_cover,
    pressure_msl,
    cloud_cover_mid,
    cloud_cover_low,
    date_only,
    time_of_day,
    is_holiday, 
    aqi_category
FROM mun

UNION ALL

SELECT 
    'Parish' AS location_level,
    location AS location_name,
    date,
    latitude,
    longitude,
    dust,
    uv_index,
    uv_index_clear_sky,
    alder_pollen,
    birch_pollen,
    grass_pollen,
    mugwort_pollen,
    olive_pollen,
    ragweed_pollen,
    ozone,
    pm2_5,
    pm10,
    carbon_monoxide,
    carbon_dioxide,
    nitrogen_dioxide,
    sulphur_dioxide,
    european_aqi,
    temperature_2m,
    apparent_temperature,
    rain,
    precipitation,
    relative_humidity_2m,
    wind_speed_10m,
    wind_speed_100m,
    wind_direction_10m,
    wind_direction_100m,
    soil_temperature_0_to_7cm,
    soil_moisture_0_to_7cm,
    cloud_cover,
    pressure_msl,
    cloud_cover_mid,
    cloud_cover_low,
    date_only,
    time_of_day,
    is_holiday, 
    aqi_category
FROM parishes;


SELECT * FROM combined_air_quality;

SET SQL_SAFE_UPDATES = 0;

/* Creating a season column */ 
ALTER TABLE combined_air_quality ADD COLUMN season TEXT;

/* Since I have too much data and SQL keeps disconnecting I'm creating a temporary table for the seasons */ 
CREATE TEMPORARY TABLE temp_season AS
SELECT date, 
       CASE 
           WHEN MONTH(date) IN (12, 1, 2) THEN 'Winter'
           WHEN MONTH(date) IN (3, 4, 5) THEN 'Spring'
           WHEN MONTH(date) IN (6, 7, 8) THEN 'Summer'
           WHEN MONTH(date) IN (9, 10, 11) THEN 'Autumn'
       END AS season
FROM combined_air_quality;

/* I'm joining the temporary table to the one I combined */ 
UPDATE combined_air_quality AS ca
JOIN temp_season AS ts ON ca.date = ts.date
SET ca.season = ts.season;

/* Dropping the temporary table as it's not necessary anymore */ 
DROP TEMPORARY TABLE IF EXISTS temp_season;

SET SQL_SAFE_UPDATES = 1;

SELECT date, season FROM combined_air_quality LIMIT 10;

SELECT DISTINCT season FROM combined_air_quality;