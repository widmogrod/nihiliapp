-- Table: migration_version

--DROP TABLE migration_version;

CREATE TABLE migration_version
(
  "version" serial
)
WITH (
  OIDS=FALSE
);
ALTER TABLE migration_version OWNER TO gabrielhabryn;

