CREATE TABLE app_connection (connection_id BIGSERIAL, server VARCHAR(255), username VARCHAR(50), password VARCHAR(50), pathname VARCHAR(512), protocol VARCHAR(255), created_at TIMESTAMP NOT NULL, updated_at TIMESTAMP NOT NULL, PRIMARY KEY(connection_id));
CREATE TABLE app_connection_file_version (file_id BIGINT, fk_connection_id BIGINT NOT NULL, filename VARCHAR(255), created_at TIMESTAMP NOT NULL, updated_at TIMESTAMP NOT NULL, version BIGINT, PRIMARY KEY(file_id, version));
CREATE TABLE app_connection_file (file_id BIGSERIAL, fk_connection_id BIGINT NOT NULL, filename VARCHAR(255), created_at TIMESTAMP NOT NULL, updated_at TIMESTAMP NOT NULL, version BIGINT, PRIMARY KEY(file_id));
CREATE TABLE app_user_connection_file_content_version (fk_file_id BIGINT, fk_file_version BIGINT, content text, created_at TIMESTAMP NOT NULL, updated_at TIMESTAMP NOT NULL, deleted_at TIMESTAMP, version BIGINT, PRIMARY KEY(fk_file_id, version));
CREATE TABLE app_user_connection_file_content (fk_file_id BIGINT, fk_file_version BIGINT, content text, created_at TIMESTAMP NOT NULL, updated_at TIMESTAMP NOT NULL, deleted_at TIMESTAMP, version BIGINT, PRIMARY KEY(fk_file_id));
CREATE TABLE app_connection_share (share_id BIGSERIAL, fk_connection_id BIGINT, name VARCHAR(255), is_enabled BOOLEAN DEFAULT 'false', is_readable BOOLEAN DEFAULT 'false', is_writable BOOLEAN DEFAULT 'false', send_notifications BOOLEAN DEFAULT 'false', created_at TIMESTAMP NOT NULL, updated_at TIMESTAMP NOT NULL, PRIMARY KEY(share_id));
CREATE TABLE app_connection_share_file (fk_share_id BIGINT, fk_file_id BIGINT, created_at TIMESTAMP NOT NULL, updated_at TIMESTAMP NOT NULL, PRIMARY KEY(fk_share_id, fk_file_id));
CREATE TABLE app_user (user_id BIGSERIAL, username VARCHAR(50), password VARCHAR(50), email VARCHAR(50), is_enabled BOOLEAN DEFAULT 'false', created_at TIMESTAMP NOT NULL, updated_at TIMESTAMP NOT NULL, deleted_at TIMESTAMP, PRIMARY KEY(user_id));
CREATE TABLE app_user_connection (fk_user_id BIGINT, fk_connection_id BIGINT, type VARCHAR(255) DEFAULT 'guest', created_at TIMESTAMP NOT NULL, updated_at TIMESTAMP NOT NULL, PRIMARY KEY(fk_user_id, fk_connection_id));
CREATE UNIQUE INDEX app_connection_file_fk_connection_id_filename_unique_index ON app_connection_file (fk_connection_id, filename);
CREATE INDEX app_connection_file_fk_connection_id_index ON app_connection_file (fk_connection_id);
CREATE INDEX app_user_connection_file_content_fk_file_id_index ON app_user_connection_file_content (fk_file_id);
CREATE INDEX app_user_connection_file_content_fk_file_id_fk_file_version_index ON app_user_connection_file_content (fk_file_id, fk_file_version);
CREATE INDEX app_connection_share_share_id_is_enabled_id_index ON app_connection_share (share_id, is_enabled);
CREATE INDEX app_connection_share_fk_connection_id_index ON app_connection_share (fk_connection_id);
CREATE UNIQUE INDEX app_connection_share_file_all_unique_index ON app_connection_share_file (fk_share_id, fk_file_id);
CREATE INDEX app_connection_share_file_fk_share_id_index ON app_connection_share_file (fk_share_id);
CREATE INDEX app_connection_share_file_fk_file_id_index ON app_connection_share_file (fk_file_id);
CREATE UNIQUE INDEX app_user_email_unique_index ON app_user (email);
CREATE INDEX app_user_is_enabled_index ON app_user (is_enabled);
CREATE INDEX app_user_email_password_is_enabled_index ON app_user (email, password, is_enabled);
CREATE UNIQUE INDEX app_user_connection_all_unique_index ON app_user_connection (fk_user_id, fk_connection_id);
CREATE INDEX app_user_connection_fk_user_id_index ON app_user_connection (fk_user_id);
CREATE INDEX app_user_connection_fk_connection_id_index ON app_user_connection (fk_connection_id);
ALTER TABLE app_connection_file_version ADD CONSTRAINT app_connection_file_version_file_id_app_connection_file_file_id FOREIGN KEY (file_id) REFERENCES app_connection_file(file_id) ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE app_connection_file ADD CONSTRAINT afac FOREIGN KEY (fk_connection_id) REFERENCES app_connection(connection_id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE app_user_connection_file_content_version ADD CONSTRAINT afaf_3 FOREIGN KEY (fk_file_id) REFERENCES app_user_connection_file_content(fk_file_id) ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE app_connection_share ADD CONSTRAINT afac_1 FOREIGN KEY (fk_connection_id) REFERENCES app_connection(connection_id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE app_connection_share_file ADD CONSTRAINT app_connection_share_file_fk_file_id_app_connection_file_file_id FOREIGN KEY (fk_file_id) REFERENCES app_connection_file(file_id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE app_connection_share_file ADD CONSTRAINT afas FOREIGN KEY (fk_share_id) REFERENCES app_connection_share(share_id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE app_user_connection ADD CONSTRAINT app_user_connection_fk_user_id_app_user_user_id FOREIGN KEY (fk_user_id) REFERENCES app_user(user_id) NOT DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE app_user_connection ADD CONSTRAINT afac_2 FOREIGN KEY (fk_connection_id) REFERENCES app_connection(connection_id) NOT DEFERRABLE INITIALLY IMMEDIATE;
