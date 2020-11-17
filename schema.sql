--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4 (Ubuntu 12.4-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.4 (Ubuntu 12.4-0ubuntu0.20.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: lessons; Type: TABLE; Schema: public; Owner: milez
--

CREATE TABLE public.lessons (
    url character varying,
    contents text,
    contents_ts timestamp with time zone,
    title character varying,
    video_download_url character varying
);


ALTER TABLE public.lessons OWNER TO milez;

--
-- Name: stats; Type: VIEW; Schema: public; Owner: milez
--

CREATE VIEW public.stats AS
 SELECT (lessons.title IS NOT NULL) AS t,
    (lessons.video_download_url IS NOT NULL) AS v,
    (lessons.contents_ts IS NOT NULL) AS cts,
    (length(lessons.contents) > 0) AS c,
    count(*) AS count,
    avg(length(lessons.contents)) AS avg
   FROM public.lessons
  GROUP BY (lessons.video_download_url IS NOT NULL), (lessons.title IS NOT NULL), (length(lessons.contents) > 0), (lessons.contents_ts IS NOT NULL);


ALTER TABLE public.stats OWNER TO milez;

--
-- PostgreSQL database dump complete
--

