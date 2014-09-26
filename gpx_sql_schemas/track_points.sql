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
-- Name: track_points; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE track_points (
    ogc_fid integer NOT NULL,
    wkb_geometry bytea,
    track_fid integer,
    track_seg_id integer,
    track_seg_point_id integer,
    ele double precision,
    "time" timestamp with time zone,
    magvar double precision,
    geoidheight double precision,
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
    sym character varying,
    type character varying,
    fix character varying,
    sat integer,
    hdop double precision,
    vdop double precision,
    pdop double precision,
    ageofdgpsdata double precision,
    dgpsid integer
);


ALTER TABLE public.track_points OWNER TO postgres;

--
-- Name: track_points_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE track_points_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.track_points_ogc_fid_seq OWNER TO postgres;

--
-- Name: track_points_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE track_points_ogc_fid_seq OWNED BY track_points.ogc_fid;


--
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY track_points ALTER COLUMN ogc_fid SET DEFAULT nextval('track_points_ogc_fid_seq'::regclass);


--
-- Name: track_points_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY track_points
    ADD CONSTRAINT track_points_pkey PRIMARY KEY (ogc_fid);


--
-- PostgreSQL database dump complete
--

