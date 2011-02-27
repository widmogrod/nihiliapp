--
-- PostgreSQL database dump
--

-- Dumped from database version 9.0.3
-- Dumped by pg_dump version 9.0.0
-- Started on 2011-02-26 23:02:34 CET

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- TOC entry 1813 (class 0 OID 0)
-- Dependencies: 1519
-- Name: app_connection_connection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gabrielhabryn
--

SELECT pg_catalog.setval('app_connection_connection_id_seq', 7, true);


--
-- TOC entry 1810 (class 0 OID 17251)
-- Dependencies: 1520
-- Data for Name: app_connection; Type: TABLE DATA; Schema: public; Owner: gabrielhabryn
--

INSERT INTO app_connection (connection_id, server, username, password, pathname, protocol, created_at, updated_at) VALUES (2, 'ftp.laksa.pl', 'laksa', 'for6ba!', NULL, 'FTP', '2011-02-27', '2011-02-27');
INSERT INTO app_connection (connection_id, server, username, password, pathname, protocol, created_at, updated_at) VALUES (3, 'ykp.krakow.pl', 'ykp', '@!YkpKrakow', NULL, 'FTP', '2011-02-27', '2011-02-27');
INSERT INTO app_connection (connection_id, server, username, password, pathname, protocol, created_at, updated_at) VALUES (4, 'ftp.prawnicy.krakow.pl', 'prawnicy', '@!Prawnik.2010', NULL, 'FTP', '2011-02-27', '2011-02-27');
INSERT INTO app_connection (connection_id, server, username, password, pathname, protocol, created_at, updated_at) VALUES (5, 'test2', 'test', 'test', '<CPNull 0x000b4f>', 'FTP', '2011-02-27', '2011-02-27');
INSERT INTO app_connection (connection_id, server, username, password, pathname, protocol, created_at, updated_at) VALUES (1, 'ftp.widmogrod.info', 'widmogrod', 'for6ba!', '', 'FTP', '2011-02-27', '2011-02-27');
INSERT INTO app_connection (connection_id, server, username, password, pathname, protocol, created_at, updated_at) VALUES (6, 'ftp.krak-plast.pl', 'krakplast', '@!KrakPlast', NULL, 'FTP', '2011-02-27', '2011-02-27');
INSERT INTO app_connection (connection_id, server, username, password, pathname, protocol, created_at, updated_at) VALUES (7, 'ftp.mostowy.com.pl', 'mostowy', 'KancelariA2010', NULL, 'FTP', '2011-02-27', '2011-02-27');


-- Completed on 2011-02-26 23:02:34 CET

--
-- PostgreSQL database dump complete
--

