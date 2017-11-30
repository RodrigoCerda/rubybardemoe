-- Database: BarDeMoe

-- DROP DATABASE "BarDeMoe";

CREATE DATABASE "BarDeMoe"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Spain.1252'
    LC_CTYPE = 'Spanish_Spain.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE "BarDeMoe"
    IS 'Base De proyecto';