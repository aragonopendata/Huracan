--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: tracks; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tracks (
    ogc_fid integer NOT NULL,
    wkb_geometry bytea,
    name character varying,
    cmt character varying,
    "desc" character varying,
    src character varying,
    link1_href character varying,
    link1_text character varying,
    link1_type character varying,
    link2_href character varying,
    link2_text character varying,
    link2_type character varying,
    number integer,
    type character varying
);


ALTER TABLE public.tracks OWNER TO postgres;

--
-- Name: tracks_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tracks_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tracks_ogc_fid_seq OWNER TO postgres;

--
-- Name: tracks_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tracks_ogc_fid_seq OWNED BY tracks.ogc_fid;


--
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tracks ALTER COLUMN ogc_fid SET DEFAULT nextval('tracks_ogc_fid_seq'::regclass);


--
-- Name: tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tracks
    ADD CONSTRAINT tracks_pkey PRIMARY KEY (ogc_fid);


--
-- PostgreSQL database dump complete
--

