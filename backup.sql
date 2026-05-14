--
-- PostgreSQL database dump
--

\restrict HyjobFg4neqEfCIpQIf7eoIk7w0SMVAaZTyQGHreYlgSr3bEeiWDtaLpqfKUNgh

-- Dumped from database version 17.8 (9c8634e)
-- Dumped by pg_dump version 17.9 (Debian 17.9-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: MatchStatus; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public."MatchStatus" AS ENUM (
    'PENDING',
    'COMPLETED'
);


ALTER TYPE public."MatchStatus" OWNER TO neondb_owner;

--
-- Name: RoundPhase; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public."RoundPhase" AS ENUM (
    'GROUP_STAGE',
    'ELIMINATION'
);


ALTER TYPE public."RoundPhase" OWNER TO neondb_owner;

--
-- Name: TournamentFormat; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public."TournamentFormat" AS ENUM (
    'MIXED',
    'SINGLE_ELIMINATION',
    'ROUND_ROBIN'
);


ALTER TYPE public."TournamentFormat" OWNER TO neondb_owner;

--
-- Name: TournamentStatus; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public."TournamentStatus" AS ENUM (
    'ACTIVE',
    'COMPLETED'
);


ALTER TYPE public."TournamentStatus" OWNER TO neondb_owner;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Match; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE IF NOT EXISTS public."Match" (
    id integer NOT NULL,
    "roundId" integer NOT NULL,
    "homeParticipantId" integer,
    "awayParticipantId" integer,
    "homeTDs" integer,
    "awayTDs" integer,
    status public."MatchStatus" DEFAULT 'PENDING'::public."MatchStatus" NOT NULL,
    "winnerId" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "awayCas" integer,
    "homeCas" integer,
    "awayGold" integer,
    "homeGold" integer
);


ALTER TABLE public."Match" OWNER TO neondb_owner;

--
-- Name: Match_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE IF NOT EXISTS public."Match_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Match_id_seq" OWNER TO neondb_owner;

--
-- Name: Match_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public."Match_id_seq" OWNED BY public."Match".id;


--
-- Name: Participant; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE IF NOT EXISTS public."Participant" (
    id integer NOT NULL,
    "playerId" integer NOT NULL,
    "tournamentId" integer NOT NULL,
    "raceId" integer NOT NULL,
    "teamName" text,
    "groupNumber" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "hasApothecary" boolean DEFAULT false NOT NULL,
    rerolls integer DEFAULT 0 NOT NULL,
    "teamValue" integer DEFAULT 0 NOT NULL,
    "isVeteran" boolean DEFAULT false NOT NULL,
    "assistantCoaches" integer DEFAULT 0 NOT NULL,
    cheerleaders integer DEFAULT 0 NOT NULL,
    "fanFactor" integer DEFAULT 0 NOT NULL,
    treasury integer DEFAULT 1000000 NOT NULL
);


ALTER TABLE public."Participant" OWNER TO neondb_owner;

--
-- Name: Participant_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE IF NOT EXISTS public."Participant_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Participant_id_seq" OWNER TO neondb_owner;

--
-- Name: Participant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public."Participant_id_seq" OWNED BY public."Participant".id;


--
-- Name: Player; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE IF NOT EXISTS public."Player" (
    id integer NOT NULL,
    name text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Player" OWNER TO neondb_owner;

--
-- Name: Player_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE IF NOT EXISTS public."Player_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Player_id_seq" OWNER TO neondb_owner;

--
-- Name: Player_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public."Player_id_seq" OWNED BY public."Player".id;


--
-- Name: Position; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE IF NOT EXISTS public."Position" (
    id integer NOT NULL,
    "raceId" integer NOT NULL,
    name text NOT NULL,
    cost integer NOT NULL,
    ma integer NOT NULL,
    st integer NOT NULL,
    ag integer NOT NULL,
    pa integer,
    av integer NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "scrapedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Position" OWNER TO neondb_owner;

--
-- Name: PositionSkill; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE IF NOT EXISTS public."PositionSkill" (
    "positionId" integer NOT NULL,
    "skillId" integer NOT NULL
);


ALTER TABLE public."PositionSkill" OWNER TO neondb_owner;

--
-- Name: Position_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE IF NOT EXISTS public."Position_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Position_id_seq" OWNER TO neondb_owner;

--
-- Name: Position_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public."Position_id_seq" OWNED BY public."Position".id;


--
-- Name: Race; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE IF NOT EXISTS public."Race" (
    id integer NOT NULL,
    name text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "scrapedAt" timestamp(3) without time zone NOT NULL,
    "rerollCost" integer DEFAULT 0 NOT NULL,
    "imageUrl" text
);


ALTER TABLE public."Race" OWNER TO neondb_owner;

--
-- Name: Race_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE IF NOT EXISTS public."Race_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Race_id_seq" OWNER TO neondb_owner;

--
-- Name: Race_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public."Race_id_seq" OWNED BY public."Race".id;


--
-- Name: RosterEntry; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE IF NOT EXISTS public."RosterEntry" (
    id integer NOT NULL,
    "participantId" integer NOT NULL,
    "positionId" integer NOT NULL,
    "playerName" text,
    spp integer DEFAULT 0 NOT NULL,
    dorsal integer,
    "agUp" integer DEFAULT 0 NOT NULL,
    "avUp" integer DEFAULT 0 NOT NULL,
    injured boolean DEFAULT false NOT NULL,
    "mvUp" integer DEFAULT 0 NOT NULL,
    "paUp" integer DEFAULT 0 NOT NULL,
    "stUp" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."RosterEntry" OWNER TO neondb_owner;

--
-- Name: RosterEntrySkill; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE IF NOT EXISTS public."RosterEntrySkill" (
    "rosterEntryId" integer NOT NULL,
    "skillId" integer NOT NULL
);


ALTER TABLE public."RosterEntrySkill" OWNER TO neondb_owner;

--
-- Name: RosterEntry_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE IF NOT EXISTS public."RosterEntry_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."RosterEntry_id_seq" OWNER TO neondb_owner;

--
-- Name: RosterEntry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public."RosterEntry_id_seq" OWNED BY public."RosterEntry".id;


--
-- Name: RosterHistory; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE IF NOT EXISTS public."RosterHistory" (
    id integer NOT NULL,
    "participantId" integer NOT NULL,
    snapshot jsonb NOT NULL,
    "changedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    reason text
);


ALTER TABLE public."RosterHistory" OWNER TO neondb_owner;

--
-- Name: RosterHistory_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE IF NOT EXISTS public."RosterHistory_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."RosterHistory_id_seq" OWNER TO neondb_owner;

--
-- Name: RosterHistory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public."RosterHistory_id_seq" OWNED BY public."RosterHistory".id;


--
-- Name: Round; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE IF NOT EXISTS public."Round" (
    id integer NOT NULL,
    "tournamentId" integer NOT NULL,
    number integer NOT NULL,
    phase public."RoundPhase" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Round" OWNER TO neondb_owner;

--
-- Name: Round_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE IF NOT EXISTS public."Round_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Round_id_seq" OWNER TO neondb_owner;

--
-- Name: Round_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public."Round_id_seq" OWNED BY public."Round".id;


--
-- Name: Skill; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE IF NOT EXISTS public."Skill" (
    id integer NOT NULL,
    name text NOT NULL,
    category text NOT NULL,
    description text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "scrapedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Skill" OWNER TO neondb_owner;

--
-- Name: Skill_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE IF NOT EXISTS public."Skill_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Skill_id_seq" OWNER TO neondb_owner;

--
-- Name: Skill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public."Skill_id_seq" OWNED BY public."Skill".id;


--
-- Name: Tournament; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE IF NOT EXISTS public."Tournament" (
    id integer NOT NULL,
    name text NOT NULL,
    edition text NOT NULL,
    year integer NOT NULL,
    "startDate" timestamp(3) without time zone NOT NULL,
    description text,
    status public."TournamentStatus" DEFAULT 'ACTIVE'::public."TournamentStatus" NOT NULL,
    format public."TournamentFormat" DEFAULT 'MIXED'::public."TournamentFormat" NOT NULL,
    "groupCount" integer,
    "qualifiersPerGroup" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Tournament" OWNER TO neondb_owner;

--
-- Name: Tournament_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE IF NOT EXISTS public."Tournament_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Tournament_id_seq" OWNER TO neondb_owner;

--
-- Name: Tournament_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public."Tournament_id_seq" OWNED BY public."Tournament".id;


--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE IF NOT EXISTS public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO neondb_owner;

--
-- Name: Match id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Match" ALTER COLUMN id SET DEFAULT nextval('public."Match_id_seq"'::regclass);


--
-- Name: Participant id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Participant" ALTER COLUMN id SET DEFAULT nextval('public."Participant_id_seq"'::regclass);


--
-- Name: Player id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Player" ALTER COLUMN id SET DEFAULT nextval('public."Player_id_seq"'::regclass);


--
-- Name: Position id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Position" ALTER COLUMN id SET DEFAULT nextval('public."Position_id_seq"'::regclass);


--
-- Name: Race id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Race" ALTER COLUMN id SET DEFAULT nextval('public."Race_id_seq"'::regclass);


--
-- Name: RosterEntry id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."RosterEntry" ALTER COLUMN id SET DEFAULT nextval('public."RosterEntry_id_seq"'::regclass);


--
-- Name: RosterHistory id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."RosterHistory" ALTER COLUMN id SET DEFAULT nextval('public."RosterHistory_id_seq"'::regclass);


--
-- Name: Round id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Round" ALTER COLUMN id SET DEFAULT nextval('public."Round_id_seq"'::regclass);


--
-- Name: Skill id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Skill" ALTER COLUMN id SET DEFAULT nextval('public."Skill_id_seq"'::regclass);


--
-- Name: Tournament id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Tournament" ALTER COLUMN id SET DEFAULT nextval('public."Tournament_id_seq"'::regclass);


--
-- Data for Name: Match; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Match" (id, "roundId", "homeParticipantId", "awayParticipantId", "homeTDs", "awayTDs", status, "winnerId", "createdAt", "updatedAt", "awayCas", "homeCas", "awayGold", "homeGold") FROM stdin;
11	10	15	17	\N	\N	PENDING	\N	2026-05-03 22:39:49.632	2026-05-03 22:39:49.632	\N	\N	\N	\N
10	10	14	18	\N	\N	PENDING	\N	2026-05-03 22:39:49.631	2026-05-03 22:39:49.631	\N	\N	\N	\N
12	10	16	19	\N	\N	PENDING	\N	2026-05-03 22:39:49.631	2026-05-03 22:39:49.631	\N	\N	\N	\N
13	11	14	19	\N	\N	PENDING	\N	2026-05-03 22:39:50.22	2026-05-03 22:39:50.22	\N	\N	\N	\N
14	11	18	17	\N	\N	PENDING	\N	2026-05-03 22:39:50.221	2026-05-03 22:39:50.221	\N	\N	\N	\N
15	11	16	15	\N	\N	PENDING	\N	2026-05-03 22:39:50.22	2026-05-03 22:39:50.22	\N	\N	\N	\N
16	12	14	17	\N	\N	PENDING	\N	2026-05-03 22:39:50.482	2026-05-03 22:39:50.482	\N	\N	\N	\N
17	12	19	15	\N	\N	PENDING	\N	2026-05-03 22:39:50.483	2026-05-03 22:39:50.483	\N	\N	\N	\N
18	12	18	16	\N	\N	PENDING	\N	2026-05-03 22:39:50.483	2026-05-03 22:39:50.483	\N	\N	\N	\N
19	13	17	16	\N	\N	PENDING	\N	2026-05-03 22:39:50.873	2026-05-03 22:39:50.873	\N	\N	\N	\N
20	13	14	15	\N	\N	PENDING	\N	2026-05-03 22:39:50.873	2026-05-03 22:39:50.873	\N	\N	\N	\N
21	13	19	18	\N	\N	PENDING	\N	2026-05-03 22:39:50.874	2026-05-03 22:39:50.874	\N	\N	\N	\N
23	14	17	19	\N	\N	PENDING	\N	2026-05-03 22:39:51.148	2026-05-03 22:39:51.148	\N	\N	\N	\N
24	14	15	18	\N	\N	PENDING	\N	2026-05-03 22:39:51.147	2026-05-03 22:39:51.147	\N	\N	\N	\N
25	15	22	25	\N	\N	PENDING	\N	2026-05-03 22:39:51.535	2026-05-03 22:39:51.535	\N	\N	\N	\N
26	15	20	24	\N	\N	PENDING	\N	2026-05-03 22:39:51.536	2026-05-03 22:39:51.536	\N	\N	\N	\N
27	15	23	21	\N	\N	PENDING	\N	2026-05-03 22:39:51.535	2026-05-03 22:39:51.535	\N	\N	\N	\N
28	16	22	24	\N	\N	PENDING	\N	2026-05-03 22:39:51.802	2026-05-03 22:39:51.802	\N	\N	\N	\N
29	16	25	21	\N	\N	PENDING	\N	2026-05-03 22:39:51.803	2026-05-03 22:39:51.803	\N	\N	\N	\N
30	16	20	23	\N	\N	PENDING	\N	2026-05-03 22:39:51.803	2026-05-03 22:39:51.803	\N	\N	\N	\N
31	17	22	21	\N	\N	PENDING	\N	2026-05-03 22:39:52.063	2026-05-03 22:39:52.063	\N	\N	\N	\N
32	17	24	23	\N	\N	PENDING	\N	2026-05-03 22:39:52.064	2026-05-03 22:39:52.064	\N	\N	\N	\N
33	17	25	20	\N	\N	PENDING	\N	2026-05-03 22:39:52.064	2026-05-03 22:39:52.064	\N	\N	\N	\N
34	18	21	20	\N	\N	PENDING	\N	2026-05-03 22:39:52.331	2026-05-03 22:39:52.331	\N	\N	\N	\N
35	18	24	25	\N	\N	PENDING	\N	2026-05-03 22:39:52.331	2026-05-03 22:39:52.331	\N	\N	\N	\N
36	18	22	23	\N	\N	PENDING	\N	2026-05-03 22:39:52.33	2026-05-03 22:39:52.33	\N	\N	\N	\N
37	19	22	20	\N	\N	PENDING	\N	2026-05-03 22:39:52.595	2026-05-03 22:39:52.595	\N	\N	\N	\N
38	19	23	25	\N	\N	PENDING	\N	2026-05-03 22:39:52.595	2026-05-03 22:39:52.595	\N	\N	\N	\N
39	19	21	24	\N	\N	PENDING	\N	2026-05-03 22:39:52.596	2026-05-03 22:39:52.596	\N	\N	\N	\N
22	14	14	16	4	0	COMPLETED	14	2026-05-03 22:39:51.147	2026-05-10 18:55:09.204	4	1	\N	\N
\.


--
-- Data for Name: Participant; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Participant" (id, "playerId", "tournamentId", "raceId", "teamName", "groupNumber", "createdAt", "updatedAt", "hasApothecary", rerolls, "teamValue", "isVeteran", "assistantCoaches", cheerleaders, "fanFactor", treasury) FROM stdin;
16	16	5	18	All LiZZtards	2	2026-05-02 20:22:49.857	2026-05-04 11:59:31.36	f	2	970000	f	0	0	0	1000000
17	15	5	137	Zaidin ChaosHawks	2	2026-05-02 20:23:59.767	2026-05-05 10:19:50.132	f	2	1020000	f	0	0	0	1000000
14	14	5	156	Viejoz mitoz nunca mueren	2	2026-05-02 20:20:54.655	2026-05-10 22:08:43.421	t	3	950000	t	0	0	0	1000000
15	17	5	180	\N	2	2026-05-02 20:21:37.291	2026-05-02 20:21:42.338	f	0	0	t	0	0	0	1000000
18	19	5	152	\N	2	2026-05-02 20:24:53.742	2026-05-02 20:24:58.497	f	0	0	f	0	0	0	1000000
19	25	5	1	\N	2	2026-05-02 20:25:21.597	2026-05-02 20:25:26.171	f	0	0	t	0	0	0	1000000
20	21	5	143	Pelosos de Endor	1	2026-05-02 20:26:55.326	2026-05-02 20:27:01.859	f	0	0	f	0	0	0	1000000
21	23	5	151	Los demonios tombers	1	2026-05-02 20:28:09.18	2026-05-02 20:28:16.305	f	0	0	f	0	0	0	1000000
22	24	5	1	\N	1	2026-05-02 20:28:34.988	2026-05-02 20:28:40.122	f	0	0	t	0	0	0	1000000
23	20	5	17	\N	1	2026-05-03 22:37:01.741	2026-05-03 22:37:22.552	f	0	0	t	0	0	0	1000000
24	22	5	101	Rebanadoraz Pochaz	1	2026-05-03 22:38:43.903	2026-05-03 22:38:48.96	f	0	0	t	0	0	0	1000000
25	18	5	25	\N	1	2026-05-03 22:39:36.649	2026-05-03 22:39:43.203	f	0	0	f	0	0	0	1000000
\.


--
-- Data for Name: Player; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Player" (id, name, "createdAt", "updatedAt") FROM stdin;
14	Hynkel	2026-05-02 19:46:55.057	2026-05-02 19:46:55.057
15	Jose Antonio	2026-05-02 19:47:17.558	2026-05-02 19:47:17.558
17	Jorge	2026-05-02 19:47:46.493	2026-05-02 19:47:46.493
18	Salva Mtz	2026-05-02 19:48:15.083	2026-05-02 19:48:15.083
19	David	2026-05-02 19:48:26.085	2026-05-02 19:48:26.085
20	Pepin	2026-05-02 19:48:35.28	2026-05-02 19:48:35.28
21	Stephan	2026-05-02 19:48:44.235	2026-05-02 19:48:44.235
22	Sergio	2026-05-02 19:48:55.814	2026-05-02 19:48:55.814
23	Mike	2026-05-02 19:49:06.898	2026-05-02 19:49:06.898
24	Filler	2026-05-02 20:13:09.903	2026-05-02 20:13:09.903
25	Foller	2026-05-02 20:13:25.073	2026-05-02 20:13:25.073
16	Ray Portillo	2026-05-02 19:47:31.669	2026-05-04 03:35:03.864
\.


--
-- Data for Name: Position; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Position" (id, "raceId", name, cost, ma, st, ag, pa, av, "updatedAt", "scrapedAt") FROM stdin;
142	28	Lineman	60000	6	3	3	4	9	2026-04-30 10:07:45.131	2026-04-30 10:01:26.964
143	28	Catcher	80000	7	2	2	4	8	2026-04-30 10:07:45.531	2026-04-30 10:01:26.964
144	28	Blitzer	110000	7	3	3	4	9	2026-04-30 10:07:46.092	2026-04-30 10:01:26.964
152	30	Tomb King Thrower	65000	6	3	4	3	9	2026-04-30 10:08:00.652	2026-04-30 10:01:26.964
153	30	Tomb King Blitzer	85000	6	3	4	5	9	2026-04-30 10:08:01.375	2026-04-30 10:01:26.964
139	27	Daemonettes	60000	6	3	2	4	8	2026-04-30 10:07:44.118	2026-04-30 10:01:26.964
140	27	Slaangors	100000	7	3	2	3	8	2026-04-30 10:07:44.207	2026-04-30 10:01:26.964
141	27	Slaanesh Warriors	110000	6	4	3	5	9	2026-04-30 10:07:44.609	2026-04-30 10:01:26.964
145	28	Kroxigor	140000	6	5	5	\N	10	2026-04-30 10:07:46.826	2026-04-30 10:01:26.964
151	30	Skeleton Linemen	40000	5	3	4	6	8	2026-04-30 10:08:02.504	2026-04-30 10:01:26.964
155	30	Anointed Thrower	70000	6	3	4	3	8	2026-04-30 10:08:02.906	2026-04-30 10:01:26.964
156	30	Anointed Blitzer	90000	6	3	4	6	9	2026-04-30 10:08:03.625	2026-04-30 10:01:26.964
363	88	Gnoblar	15000	5	1	3	5	6	2026-04-30 10:07:11.596	2026-04-30 10:01:26.964
8	3	Squires	50000	6	3	3	4	8	2026-04-30 10:05:10.634	2026-04-30 10:01:26.964
9	3	Knight Catcher	85000	7	3	3	4	9	2026-04-30 10:05:10.888	2026-04-30 10:01:26.964
10	3	Knight Thrower	80000	6	3	3	3	9	2026-04-30 10:05:11.535	2026-04-30 10:01:26.964
31	7	Pit Fighters	60000	6	3	3	4	9	2026-04-30 10:05:40.352	2026-04-30 10:01:26.964
11	3	Grail Knight	95000	7	3	3	4	10	2026-04-30 10:05:12.114	2026-04-30 10:01:26.964
1	1	Eagle Warrior Linewomen	50000	6	3	3	4	8	2026-04-30 10:05:03.519	2026-04-30 10:01:26.964
2	1	Python Warrior Throwers	80000	6	3	3	3	8	2026-04-30 10:05:03.765	2026-04-30 10:01:26.964
32	7	Bloodletter	80000	6	3	3	4	8	2026-04-30 10:05:40.599	2026-04-30 10:01:26.964
3	1	Piranha Warrior Blitzers	90000	7	3	3	5	8	2026-04-30 10:05:04.502	2026-04-30 10:01:26.964
4	1	Jaguar Warrior Blockers	110000	6	4	3	5	9	2026-04-30 10:05:05.083	2026-04-30 10:01:26.964
92	18	Skink Linemen	60000	8	2	3	4	8	2026-04-30 10:06:45.921	2026-04-30 10:01:26.964
33	7	Khorne Heralds	90000	5	3	4	5	9	2026-04-30 10:05:41.176	2026-04-30 10:01:26.964
524	137	Hobgoblin Linemen	40000	6	3	3	4	8	2026-04-30 10:05:23.843	2026-04-30 10:01:26.964
525	137	Sneaky Stabba	70000	6	3	3	5	8	2026-04-30 10:05:23.926	2026-04-30 10:01:26.964
519	136	Beastman Linemen	60000	6	3	3	3	9	2026-04-30 10:05:16.692	2026-04-30 10:01:26.964
520	136	Chaos Chosen Blocker	100000	5	4	3	5	10	2026-04-30 10:05:16.939	2026-04-30 10:01:26.964
93	18	Chameleon Skink	70000	7	2	3	3	8	2026-04-30 10:06:46.321	2026-04-30 10:01:26.964
94	18	Saurus Blocker	85000	6	4	5	6	10	2026-04-30 10:06:47.087	2026-04-30 10:01:26.964
521	136	Chaos Troll	115000	4	5	5	5	10	2026-04-30 10:05:17.022	2026-04-30 10:01:26.964
522	136	Chaos Ogre	140000	5	5	4	5	10	2026-04-30 10:05:18.282	2026-04-30 10:01:26.964
523	136	Minotaur	150000	5	5	4	6	9	2026-04-30 10:05:19.186	2026-04-30 10:01:26.964
95	18	Kroxigor	140000	6	5	5	\N	10	2026-04-30 10:06:47.167	2026-04-30 10:01:26.964
365	88	Runt Punter	145000	5	5	4	4	10	2026-04-30 10:07:12.48	2026-04-30 10:01:26.964
364	88	Ogre	140000	5	5	4	5	10	2026-04-30 10:07:13.201	2026-04-30 10:01:26.964
154	30	Tomb Guardian	100000	4	5	5	\N	10	2026-04-30 10:08:04.187	2026-04-30 10:01:26.964
129	25	Skeleton Linemen	40000	5	3	4	6	8	2026-04-30 10:07:38.115	2026-04-30 10:01:26.964
526	137	Chaos Dwarf Blocker	70000	4	3	4	6	10	2026-04-30 10:05:24.337	2026-04-30 10:01:26.964
34	7	Bloodthirster	180000	6	5	5	\N	10	2026-04-30 10:05:41.768	2026-04-30 10:01:26.964
130	25	Zombie Linemen	40000	4	3	4	\N	9	2026-04-30 10:07:38.517	2026-04-30 10:01:26.964
88	17	Bloodborn Marauder Linemen	50000	6	3	3	4	8	2026-04-30 10:06:41.636	2026-04-30 10:01:26.964
89	17	Khorngors	70000	6	3	3	4	9	2026-04-30 10:06:41.875	2026-04-30 10:01:26.964
90	17	Bloodseekers	110000	5	4	4	6	10	2026-04-30 10:06:42.279	2026-04-30 10:01:26.964
131	25	Ghoul Runner	75000	7	3	3	4	8	2026-04-30 10:07:38.759	2026-04-30 10:01:26.964
91	17	Bloodspawn	160000	5	5	4	\N	9	2026-04-30 10:06:42.518	2026-04-30 10:01:26.964
134	26	Skaven Lineman	50000	7	3	3	4	8	2026-04-30 10:07:42.105	2026-04-30 10:01:26.964
135	26	Skaven Thrower	85000	7	3	3	2	8	2026-04-30 10:07:42.186	2026-04-30 10:01:26.964
136	26	Skaven Gutter Runner	85000	9	2	2	4	8	2026-04-30 10:07:42.592	2026-04-30 10:01:26.964
37	8	Dark Elf Assassin	90000	7	3	2	4	8	2026-04-30 10:05:43.685	2026-04-30 10:01:26.964
35	8	Dark Elf Linemen	70000	6	3	2	4	9	2026-04-30 10:05:45.106	2026-04-30 10:01:26.964
66	14	High Elf Phoenix Warrior Thrower	90000	6	3	2	2	9	2026-04-30 10:06:25.467	2026-04-30 10:01:26.964
67	14	High Elf White Lion Blitzer	110000	7	3	2	3	9	2026-04-30 10:06:26.036	2026-04-30 10:01:26.964
68	14	High Elf Dragon Prince	110000	8	3	2	4	9	2026-04-30 10:06:26.444	2026-04-30 10:01:26.964
46	10	Elf Linemen	60000	6	3	2	4	8	2026-04-30 10:05:56.164	2026-04-30 10:01:26.964
47	10	Elf Thrower	75000	6	3	2	2	8	2026-04-30 10:05:56.245	2026-04-30 10:01:26.964
48	10	Elf Catcher	100000	8	3	2	4	8	2026-04-30 10:05:56.49	2026-04-30 10:01:26.964
49	10	Elf Blitzers	115000	7	3	2	3	9	2026-04-30 10:05:56.901	2026-04-30 10:01:26.964
65	14	High Elf Linemen	70000	6	3	2	4	9	2026-04-30 10:06:27.013	2026-04-30 10:01:26.964
69	14	High Elf Phoenix Thrower	100000	6	3	2	2	9	2026-04-30 10:06:27.095	2026-04-30 10:01:26.964
70	14	High Elf Lion Warrior Catcher	90000	8	3	2	5	8	2026-04-30 10:06:27.665	2026-04-30 10:01:26.964
71	14	High Elf Dragon Warrior Blitzer	100000	7	3	2	4	9	2026-04-30 10:06:27.91	2026-04-30 10:01:26.964
132	25	Wight Blitzer	90000	6	3	3	5	9	2026-04-30 10:07:39	2026-04-30 10:01:26.964
133	25	Mummies	125000	3	5	5	\N	10	2026-04-30 10:07:39.402	2026-04-30 10:01:26.964
137	26	Skaven Blitzer	90000	7	3	3	5	9	2026-04-30 10:07:42.834	2026-04-30 10:01:26.964
138	26	Rat Ogre	150000	6	5	4	\N	9	2026-04-30 10:07:43.076	2026-04-30 10:01:26.964
558	145	Halfling Hopeful	30000	5	2	3	4	7	2026-04-30 10:06:21.86	2026-04-30 10:01:26.964
559	145	Halfling Hefty	50000	5	2	3	3	8	2026-04-30 10:06:22.432	2026-04-30 10:01:26.964
560	145	Halfling Catcher	55000	5	2	3	5	7	2026-04-30 10:06:23.008	2026-04-30 10:01:26.964
561	145	Altern Forest Treeman	120000	2	6	5	5	11	2026-04-30 10:06:23.918	2026-04-30 10:01:26.964
36	8	Dark Elf Runner	80000	7	3	2	3	8	2026-04-30 10:05:45.189	2026-04-30 10:01:26.964
38	8	Dark Elf Blitzer	100000	7	3	2	4	9	2026-04-30 10:05:45.434	2026-04-30 10:01:26.964
40	8	Assassin	85000	7	3	2	5	8	2026-04-30 10:05:45.681	2026-04-30 10:01:26.964
39	8	Witch Elf	110000	7	3	2	5	8	2026-04-30 10:05:46.093	2026-04-30 10:01:26.964
550	144	Goblin	40000	6	2	3	4	8	2026-04-30 10:06:12.484	2026-04-30 10:01:26.964
552	144	Bomma	45000	6	2	3	4	8	2026-04-30 10:06:13.055	2026-04-30 10:01:26.964
540	141	Dwarf Linemen	70000	4	3	4	5	10	2026-04-30 10:05:50.832	2026-04-30 10:01:26.964
541	141	Dwarf Runner	85000	6	3	3	4	9	2026-04-30 10:05:51.403	2026-04-30 10:01:26.964
542	141	Dwarf Blitzer	80000	5	3	3	4	10	2026-04-30 10:05:51.818	2026-04-30 10:01:26.964
543	141	Troll Slayer	95000	5	3	4	\N	9	2026-04-30 10:05:52.226	2026-04-30 10:01:26.964
545	143	Gnome linemen	40000	5	2	3	4	7	2026-04-30 10:06:01.608	2026-04-30 10:01:26.964
546	143	Gnome Illusionist	50000	5	2	3	3	7	2026-04-30 10:06:02.352	2026-04-30 10:01:26.964
547	143	Woodland Fox	50000	7	2	2	\N	6	2026-04-30 10:06:03.1	2026-04-30 10:01:26.964
548	143	Gnome Beastmaster	55000	5	2	3	4	8	2026-04-30 10:06:03.838	2026-04-30 10:01:26.964
549	143	Altern Forest Treeman	120000	2	6	5	5	11	2026-04-30 10:06:04.575	2026-04-30 10:01:26.964
590	153	Rotter	35000	5	3	4	6	9	2026-04-30 10:07:05.998	2026-04-30 10:01:26.964
573	148	Imperial Retainer Linemen	45000	6	3	4	4	8	2026-04-30 10:06:37.052	2026-04-30 10:01:26.964
574	148	Imperial Thrower	75000	6	3	3	3	9	2026-04-30 10:06:37.292	2026-04-30 10:01:26.964
575	148	Imperial Noble Blitzer	105000	7	3	3	4	9	2026-04-30 10:06:37.692	2026-04-30 10:01:26.964
576	148	Imperial Bodyguards	90000	6	3	3	5	9	2026-04-30 10:06:38.108	2026-04-30 10:01:26.964
577	148	Ogre	140000	5	5	4	5	10	2026-04-30 10:06:38.506	2026-04-30 10:01:26.964
578	151	Zombie	40000	4	3	4	\N	9	2026-04-30 10:06:51.329	2026-04-30 10:01:26.964
579	151	Ghoul Runners	75000	7	3	3	4	8	2026-04-30 10:06:51.572	2026-04-30 10:01:26.964
580	151	Wraith	95000	6	3	3	\N	9	2026-04-30 10:06:51.812	2026-04-30 10:01:26.964
581	151	Werewolf	125000	8	3	3	4	9	2026-04-30 10:06:52.693	2026-04-30 10:01:26.964
582	151	Flesh Golem	115000	4	4	4	\N	10	2026-04-30 10:06:53.252	2026-04-30 10:01:26.964
588	152	Yhetee	140000	5	5	4	6	9	2026-04-30 10:06:57.245	2026-04-30 10:01:26.964
562	147	Human Lineman	50000	6	3	3	4	9	2026-04-30 10:02:59.842	2026-04-30 10:01:26.964
563	147	Halfling Lineman	30000	5	2	3	4	7	2026-04-30 10:02:59.925	2026-04-30 10:01:26.964
564	147	Human Catcher	75000	8	3	3	4	8	2026-04-30 10:03:00.504	2026-04-30 10:01:26.964
565	147	Human Thrower	75000	6	3	3	3	9	2026-04-30 10:03:00.916	2026-04-30 10:01:26.964
566	147	Human Blitzer	85000	7	3	3	4	9	2026-04-30 10:03:01.334	2026-04-30 10:01:26.964
568	147	Lineman	50000	6	3	3	4	9	2026-04-30 10:03:02.66	2026-04-30 10:01:26.964
569	147	Thrower	80000	6	3	3	2	9	2026-04-30 10:03:02.742	2026-04-30 10:01:26.964
570	147	Catcher	65000	8	2	3	5	8	2026-04-30 10:03:03.155	2026-04-30 10:01:26.964
571	147	Blitzer	85000	7	3	3	4	9	2026-04-30 10:03:03.564	2026-04-30 10:01:26.964
572	147	Halfling	30000	5	2	3	4	7	2026-04-30 10:03:03.83	2026-04-30 10:01:26.964
567	147	Ogre	140000	5	5	4	5	10	2026-04-30 10:03:04.401	2026-04-30 10:01:26.964
583	152	Norse Raider Linemen	50000	6	3	3	4	8	2026-04-30 10:06:58.121	2026-04-30 10:01:26.964
584	152	Beer Boars	20000	5	1	3	\N	6	2026-04-30 10:06:58.68	2026-04-30 10:01:26.964
585	152	Norse Berserker	90000	6	3	3	5	8	2026-04-30 10:06:59.557	2026-04-30 10:01:26.964
586	152	Valkyrie	95000	7	3	3	3	8	2026-04-30 10:07:00.12	2026-04-30 10:01:26.964
587	152	Ulfwerener	105000	6	4	4	\N	9	2026-04-30 10:07:00.845	2026-04-30 10:01:26.964
589	152	Yhetee / Snow Troll	140000	5	5	4	\N	9	2026-04-30 10:07:01.086	2026-04-30 10:01:26.964
591	153	Pestigor	75000	6	3	3	4	9	2026-04-30 10:07:06.421	2026-04-30 10:01:26.964
592	153	Bloater	115000	4	4	4	6	10	2026-04-30 10:07:06.982	2026-04-30 10:01:26.964
593	153	Rotspawn	140000	4	5	5	\N	10	2026-04-30 10:07:07.704	2026-04-30 10:01:26.964
527	137	FlameSmith	80000	5	3	4	6	10	2026-04-30 10:05:24.914	2026-04-30 10:01:26.964
528	137	Bull Centaur	130000	6	4	4	6	10	2026-04-30 10:05:25.659	2026-04-30 10:01:26.964
529	137	Enslaved Minotaur	150000	5	5	4	\N	9	2026-04-30 10:05:26.234	2026-04-30 10:01:26.964
405	101	Goblin Bruiser	45000	6	2	3	4	8	2026-04-30 10:05:08.083	2026-04-30 10:01:26.964
406	101	Black Orcs	90000	4	4	4	5	10	2026-04-30 10:05:08.825	2026-04-30 10:01:26.964
544	141	Deathroller	170000	4	7	5	\N	11	2026-04-30 10:05:52.985	2026-04-30 10:01:26.964
551	144	Looney	40000	6	2	3	\N	8	2026-04-30 10:06:13.814	2026-04-30 10:01:26.964
555	144	Fanatic	70000	3	7	3	\N	8	2026-04-30 10:06:14.385	2026-04-30 10:01:26.964
556	144	Pogoer	75000	7	2	3	5	8	2026-04-30 10:06:15.129	2026-04-30 10:01:26.964
553	144	‘Ooligan	65000	6	2	3	6	8	2026-04-30 10:06:15.706	2026-04-30 10:01:26.964
554	144	Doom Diver	60000	6	2	3	6	8	2026-04-30 10:06:16.603	2026-04-30 10:01:26.964
557	144	Trained Troll	115000	4	5	5	5	10	2026-04-30 10:06:17.186	2026-04-30 10:01:26.964
630	165	Wood Elf Lineman	70000	7	3	2	4	8	2026-04-30 10:08:24.576	2026-04-30 10:01:26.964
631	165	Wood Elf Thrower	95000	7	3	2	2	8	2026-04-30 10:08:24.657	2026-04-30 10:01:26.964
611	161	Snotling Linemen	15000	5	1	3	5	6	2026-04-30 10:07:53.956	2026-04-30 10:01:26.964
612	161	Fungus Flinga	30000	5	1	3	4	6	2026-04-30 10:07:55.009	2026-04-30 10:01:26.964
613	161	Fun-hoppa	20000	6	1	3	5	6	2026-04-30 10:07:56.075	2026-04-30 10:01:26.964
614	161	Stilty Runna	20000	6	1	3	5	6	2026-04-30 10:07:56.96	2026-04-30 10:01:26.964
615	161	Pump Wagon	105000	4	5	5	\N	9	2026-04-30 10:07:57.844	2026-04-30 10:01:26.964
616	161	Trained Troll	115000	4	5	5	5	10	2026-04-30 10:07:58.889	2026-04-30 10:01:26.964
632	165	Wood Elf Catcher	90000	8	2	2	4	8	2026-04-30 10:08:24.9	2026-04-30 10:01:26.964
633	165	Wardancer	125000	8	3	2	4	8	2026-04-30 10:08:25.302	2026-04-30 10:01:26.964
634	165	Loren Forest Treeman	120000	2	6	5	5	11	2026-04-30 10:08:25.866	2026-04-30 10:01:26.964
625	164	Thrall Linemen	40000	6	3	3	4	8	2026-04-30 10:08:18.653	2026-04-30 10:01:26.964
626	164	Vampire Thrower	110000	6	4	2	2	9	2026-04-30 10:08:18.734	2026-04-30 10:01:26.964
627	164	Vampire Blitzer	110000	6	4	2	5	9	2026-04-30 10:08:19.455	2026-04-30 10:01:26.964
617	163	Underworld Goblin Linemen	40000	6	2	3	4	8	2026-04-30 10:08:10.365	2026-04-30 10:01:26.964
618	163	Underworld Snotling	15000	5	1	3	5	6	2026-04-30 10:08:10.927	2026-04-30 10:01:26.964
619	163	Skaven Clanrat	50000	7	3	3	4	8	2026-04-30 10:08:11.807	2026-04-30 10:01:26.964
620	163	Skaven Thrower	85000	7	3	3	2	8	2026-04-30 10:08:12.047	2026-04-30 10:01:26.964
628	164	Vampire Runner	100000	8	3	2	4	8	2026-04-30 10:08:20.176	2026-04-30 10:01:26.964
629	164	Vargheist	150000	5	5	4	\N	10	2026-04-30 10:08:20.746	2026-04-30 10:01:26.964
407	101	Trained Troll	115000	4	5	5	5	10	2026-04-30 10:05:09.235	2026-04-30 10:01:26.964
530	138	Renegade Human Linemen	50000	6	3	3	4	9	2026-04-30 10:05:33.928	2026-04-30 10:01:26.964
531	138	Renegade Human Thrower	75000	6	3	3	3	9	2026-04-30 10:05:34.011	2026-04-30 10:01:26.964
532	138	Renegade Goblin	40000	6	2	3	4	8	2026-04-30 10:05:34.584	2026-04-30 10:01:26.964
533	138	Renegade Orc	50000	5	3	3	5	10	2026-04-30 10:05:35.342	2026-04-30 10:01:26.964
534	138	Renegade Skaven	50000	7	3	3	4	8	2026-04-30 10:05:35.588	2026-04-30 10:01:26.964
535	138	Renegade Dark Elf	75000	6	3	2	3	9	2026-04-30 10:05:35.836	2026-04-30 10:01:26.964
536	138	Renegade Troll	115000	4	5	5	5	10	2026-04-30 10:05:36.084	2026-04-30 10:01:26.964
537	138	Renegade Ogre	140000	5	5	4	5	10	2026-04-30 10:05:37.328	2026-04-30 10:01:26.964
538	138	Renegade Minotaur	150000	5	5	4	\N	9	2026-04-30 10:05:38.236	2026-04-30 10:01:26.964
539	138	Renegade Rat Ogre	150000	6	5	4	\N	9	2026-04-30 10:05:39.307	2026-04-30 10:01:26.964
635	180	Human Lineman	50000	6	3	3	4	9	2026-04-30 10:06:28.69	2026-04-30 10:01:26.964
636	180	Halfling Lineman	30000	5	2	3	4	7	2026-04-30 10:06:28.823	2026-04-30 10:01:26.964
637	180	Human Catcher	75000	8	3	3	4	8	2026-04-30 10:06:29.54	2026-04-30 10:01:26.964
638	180	Human Thrower	75000	6	3	3	3	9	2026-04-30 10:06:29.937	2026-04-30 10:01:26.964
639	180	Human Blitzer	85000	7	3	3	4	9	2026-04-30 10:06:30.338	2026-04-30 10:01:26.964
641	180	Lineman	50000	6	3	3	4	9	2026-04-30 10:06:31.615	2026-04-30 10:01:26.964
642	180	Thrower	80000	6	3	3	2	9	2026-04-30 10:06:31.695	2026-04-30 10:01:26.964
643	180	Catcher	65000	8	2	3	5	8	2026-04-30 10:06:32.093	2026-04-30 10:01:26.964
644	180	Blitzer	85000	7	3	3	4	9	2026-04-30 10:06:32.491	2026-04-30 10:01:26.964
645	180	Halfling	30000	5	2	3	4	7	2026-04-30 10:06:32.745	2026-04-30 10:01:26.964
640	180	Ogre	140000	5	5	4	5	10	2026-04-30 10:06:33.306	2026-04-30 10:01:26.964
605	156	Orc Linemen	50000	5	3	3	4	10	2026-04-30 10:07:32.266	2026-04-30 10:01:26.964
607	156	Orc Thrower	65000	5	3	3	3	9	2026-04-30 10:07:32.507	2026-04-30 10:01:26.964
608	156	Orc Blitzer	80000	6	3	3	4	10	2026-04-30 10:07:33.068	2026-04-30 10:01:26.964
609	156	Orc Big Un	90000	5	4	4	\N	10	2026-04-30 10:07:33.476	2026-04-30 10:01:26.964
606	156	Goblin	40000	6	2	3	4	8	2026-04-30 10:07:33.716	2026-04-30 10:01:26.964
610	156	Untrained Troll	115000	4	5	5	5	10	2026-04-30 10:07:34.277	2026-04-30 10:01:26.964
621	163	Gutter Runner	85000	9	2	2	4	8	2026-04-30 10:08:12.61	2026-04-30 10:01:26.964
622	163	Skaven Blitzer	90000	7	3	3	5	9	2026-04-30 10:08:13.013	2026-04-30 10:01:26.964
623	163	Underworld Troll	115000	4	5	5	5	10	2026-04-30 10:08:13.413	2026-04-30 10:01:26.964
624	163	Mutant Rat Ogre	150000	6	5	4	\N	9	2026-04-30 10:08:14.631	2026-04-30 10:01:26.964
594	155	Old World Human Linemen	50000	6	3	3	4	9	2026-04-30 10:07:20.906	2026-04-30 10:01:26.964
595	155	Old World Human Thrower	75000	6	3	3	3	9	2026-04-30 10:07:20.988	2026-04-30 10:01:26.964
596	155	Old World Human Catcher	75000	8	3	3	4	8	2026-04-30 10:07:21.554	2026-04-30 10:01:26.964
597	155	Old World Human Blitzer	85000	7	3	3	4	9	2026-04-30 10:07:22.116	2026-04-30 10:01:26.964
603	155	Ogre	140000	5	5	4	5	10	2026-04-30 10:07:26.477	2026-04-30 10:01:26.964
598	155	Old World Dwarf Blocker	70000	4	3	4	5	10	2026-04-30 10:07:22.517	2026-04-30 10:01:26.964
599	155	Old World Dwarf Runner	80000	6	3	3	4	9	2026-04-30 10:07:23.239	2026-04-30 10:01:26.964
600	155	Old World Dwarf Blitzer	100000	5	3	4	4	10	2026-04-30 10:07:23.961	2026-04-30 10:01:26.964
601	155	Old World Troll Slayer	95000	5	3	4	5	9	2026-04-30 10:07:24.855	2026-04-30 10:01:26.964
602	155	Old World Halfling	30000	5	2	3	4	7	2026-04-30 10:07:25.739	2026-04-30 10:01:26.964
604	155	Altern Forest Treeman	120000	2	6	5	5	11	2026-04-30 10:07:27.358	2026-04-30 10:01:26.964
\.


--
-- Data for Name: PositionSkill; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."PositionSkill" ("positionId", "skillId") FROM stdin;
1	1
2	1
2	52
2	53
2	55
3	1
3	126
3	7
4	4
4	1
8	33
9	23
9	131
9	51
10	23
10	51
10	53
11	132
11	23
11	28
88	25
89	38
89	61
89	7
89	66
90	25
91	34
91	25
91	149
91	62
91	168
91	169
92	1
92	93
93	1
93	52
93	20
93	93
94	61
94	102
95	72
95	149
95	169
95	41
95	66
151	89
151	66
152	53
152	89
152	30
152	66
153	132
153	89
153	66
154	56
154	75
154	89
155	53
155	89
155	30
155	66
156	132
156	89
156	66
519	38
519	66
520	560
521	405
31	25
32	38
32	61
32	89
33	25
33	38
33	61
34	148
34	25
34	38
34	61
34	149
34	150
34	89
36	47
36	54
37	126
37	20
37	92
38	132
39	1
39	25
39	7
40	20
40	92
521	149
521	169
521	87
521	88
521	89
521	390
407	406
407	169
407	87
407	88
407	89
407	390
522	72
522	149
522	169
522	66
522	390
523	149
523	25
523	38
523	169
523	66
523	168
46	155
47	49
47	53
48	131
48	2
48	51
49	132
49	156
525	20
525	92
526	132
526	561
526	66
527	56
527	562
527	35
527	66
528	10
528	11
528	66
529	25
529	38
529	149
529	169
529	66
529	168
530	563
531	563
531	53
531	30
532	563
532	1
532	90
532	93
533	563
534	563
535	563
536	405
536	149
536	62
536	87
536	88
536	89
536	390
537	72
537	149
537	62
537	66
537	390
538	149
538	25
538	38
538	62
538	66
538	168
539	67
539	25
539	149
539	62
539	41
531	8
536	169
537	169
538	169
539	169
540	132
540	4
540	66
541	30
541	66
542	132
542	3
542	31
542	66
66	46
66	53
66	55
67	34
67	33
68	132
68	83
68	28
69	46
69	53
69	55
70	131
71	132
129	89
129	66
130	12
130	89
130	102
131	1
131	89
132	132
132	89
132	31
132	66
133	62
133	89
133	169
135	53
135	30
136	1
136	92
137	132
137	29
138	67
138	25
138	149
138	169
138	41
140	38
140	41
141	34
141	44
142	183
142	44
143	183
143	44
143	2
144	183
144	44
144	3
144	7
145	72
145	149
145	169
145	41
145	66
543	132
543	23
543	25
543	564
363	1
363	90
363	156
363	93
363	99
364	72
364	62
364	66
364	390
365	72
365	391
365	62
365	66
365	169
364	169
543	66
544	565
544	566
544	61
544	149
544	62
544	567
544	91
544	64
540	31
544	568
544	569
544	169
545	7
545	90
545	93
545	33
546	7
546	93
546	100
546	33
547	1
547	83
547	9
547	93
548	60
548	7
548	93
548	33
549	169
549	64
549	65
549	95
549	66
549	390
549	570
550	1
550	90
550	93
551	74
551	91
551	93
551	84
552	71
552	1
552	91
552	93
553	566
553	35
553	1
553	90
553	93
553	32
554	1
554	90
554	93
554	94
555	69
555	91
555	93
555	84
556	1
556	183
556	93
557	405
557	62
557	87
557	88
557	89
557	390
555	567
553	571
557	406
557	169
558	1
558	90
558	93
559	1
559	24
559	93
560	131
560	1
560	90
560	10
560	93
561	169
561	64
561	65
561	95
561	66
561	390
561	570
563	1
563	90
563	93
405	1
405	90
405	93
405	66
406	56
406	59
407	405
564	131
564	1
565	53
565	30
566	132
566	31
567	72
567	149
567	62
567	66
567	390
569	53
569	30
570	131
570	1
571	132
572	1
572	90
572	93
567	169
573	24
574	53
574	48
574	27
575	132
575	131
575	27
576	64
576	33
577	72
577	406
577	62
577	66
577	390
574	572
577	149
577	169
578	12
578	89
578	102
579	1
579	89
580	132
580	37
580	567
580	89
580	156
581	34
581	25
581	89
582	89
582	64
582	66
582	102
583	132
583	76
583	66
583	102
584	1
584	567
584	85
584	93
584	99
585	132
585	25
585	7
586	131
586	23
586	53
586	29
587	25
587	102
588	34
588	35
588	25
588	149
588	168
589	34
589	35
589	25
589	149
589	168
590	75
590	573
591	38
591	574
591	28
591	89
591	66
592	35
592	37
592	573
592	89
592	64
592	102
593	35
593	37
593	149
593	62
593	85
593	573
593	88
593	89
593	42
593	169
595	53
595	30
596	131
596	1
597	132
597	31
598	132
598	4
598	66
599	10
599	30
599	66
600	132
600	3
600	31
600	66
601	132
601	23
601	25
601	564
601	66
602	1
602	90
602	93
603	72
603	149
603	62
603	66
603	390
604	149
604	62
604	64
604	65
604	95
604	66
604	390
604	570
595	575
596	575
597	575
598	560
598	56
598	406
599	406
600	406
601	406
602	576
605	577
606	1
606	90
606	93
607	53
607	30
608	132
608	565
609	62
609	32
609	102
610	405
610	149
610	62
610	87
610	88
610	89
610	390
605	578
607	563
608	563
609	579
610	169
611	1
611	80
611	90
611	156
611	93
611	580
611	99
612	71
612	1
612	90
612	91
612	156
612	93
612	99
613	1
613	183
613	90
613	156
613	93
614	1
614	90
614	156
614	10
614	93
615	566
615	61
615	62
615	88
615	64
616	405
616	62
616	87
616	88
616	89
616	390
615	571
615	169
615	91
616	406
616	169
617	1
617	93
617	90
618	1
618	80
618	90
618	156
618	93
618	99
619	581
620	581
620	53
620	30
621	581
621	1
621	92
622	581
622	132
622	29
623	405
623	149
623	62
623	87
623	88
623	89
623	390
624	67
624	25
624	149
624	62
624	41
623	169
624	169
626	582
626	583
626	53
626	89
627	584
627	583
627	61
627	89
628	582
628	583
628	89
629	584
629	34
629	25
629	149
629	89
631	53
631	8
632	131
632	1
632	10
633	132
633	1
633	6
634	149
634	169
634	64
634	65
634	95
634	66
634	390
636	1
636	90
636	93
637	131
637	1
638	53
638	30
639	132
639	31
640	72
640	149
640	62
640	66
640	390
642	53
642	30
643	131
643	1
644	132
645	1
645	90
645	93
640	169
\.


--
-- Data for Name: Race; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Race" (id, name, "updatedAt", "scrapedAt", "rerollCost", "imageUrl") FROM stdin;
30	Tomb Kings	2026-04-30 10:08:00.167	2026-04-30 10:01:26.964	70000	\N
163	Underworld Denizens	2026-04-30 10:08:04.629	2026-04-30 10:01:26.964	70000	https://static.wikia.nocookie.net/blood-bowl/images/6/6d/Underworld_artwork.PNG/revision/latest/scale-to-width-down/245?cb=20180504184229
164	Vampires	2026-04-30 10:08:15.596	2026-04-30 10:01:26.964	60000	\N
165	Wood elf	2026-04-30 10:08:21.67	2026-04-30 10:01:26.964	50000	https://static.wikia.nocookie.net/blood-bowl/images/6/68/Wood_elf_artwork.jpg/revision/latest?cb=20180502154130
1	Amazons	2026-04-30 10:05:01.437	2026-04-30 10:01:26.964	60000	\N
14	High Elf	2026-04-30 10:06:25.304	2026-04-30 10:01:26.964	50000	https://static.wikia.nocookie.net/blood-bowl/images/3/3b/HighElfartwork.jpg/revision/latest/scale-to-width-down/207?cb=20180429005347
180	Human	2026-04-30 10:06:28.529	2026-04-30 10:01:26.964	50000	\N
148	Imperial Nobility	2026-04-30 10:06:34.305	2026-04-30 10:01:26.964	70000	\N
17	Khorne	2026-04-30 10:06:39.423	2026-04-30 10:01:26.964	60000	https://static.wikia.nocookie.net/blood-bowl/images/a/a0/Khorne_banner.png/revision/latest/scale-to-width-down/270?cb=20180526204255
18	Lizardmen	2026-04-30 10:06:43.446	2026-04-30 10:01:26.964	70000	https://static.wikia.nocookie.net/blood-bowl/images/3/31/Lizardman_bb_artwork.jpg/revision/latest/scale-to-width-down/237?cb=20180513233850
151	Necromantic Horrors	2026-04-30 10:06:48.129	2026-04-30 10:01:26.964	70000	\N
152	Norses	2026-04-30 10:06:53.853	2026-04-30 10:01:26.964	60000	https://static.wikia.nocookie.net/blood-bowl/images/6/61/Norse_bb_artwork.jpg/revision/latest/scale-to-width-down/210?cb=20180513232152
153	Nurgle	2026-04-30 10:07:02.03	2026-04-30 10:01:26.964	70000	https://static.wikia.nocookie.net/blood-bowl/images/b/be/Nurgle_beast_of_artwork.PNG/revision/latest/scale-to-width-down/245?cb=20180429001407
88	Ogres	2026-04-30 10:07:09.177	2026-04-30 10:01:26.964	70000	https://static.wikia.nocookie.net/blood-bowl/images/d/d4/Ogre_artwork.jpg/revision/latest/scale-to-width-down/210?cb=20180515010935
155	Old World Aliance	2026-04-30 10:07:13.98	2026-04-30 10:01:26.964	70000	\N
156	Orc	2026-04-30 10:07:28.808	2026-04-30 10:01:26.964	60000	\N
25	Shambling Undead	2026-04-30 10:07:35.524	2026-04-30 10:01:26.964	70000	\N
147	Humanos	2026-04-30 10:02:59.759	2026-04-30 10:01:26.964	50000	\N
101	Black Orcs	2026-04-30 10:05:05.609	2026-04-30 10:01:26.964	60000	\N
3	Bretonnia	2026-04-30 10:05:10.551	2026-04-30 10:01:26.964	60000	\N
136	Chaos Chosen	2026-04-30 10:05:12.733	2026-04-30 10:01:26.964	60000	\N
137	Chaos Dwarf	2026-04-30 10:05:20.297	2026-04-30 10:01:26.964	70000	\N
138	Chaos Renegade	2026-04-30 10:05:27.397	2026-04-30 10:01:26.964	70000	https://static.wikia.nocookie.net/blood-bowl/images/d/d7/Chaos_Renegades_video_game.PNG/revision/latest/scale-to-width-down/280?cb=20180502170121
7	Daemons of Khorne	2026-04-30 10:05:40.267	2026-04-30 10:01:26.964	70000	https://static.wikia.nocookie.net/blood-bowl/images/a/a0/Khorne_banner.png/revision/latest/scale-to-width-down/270?cb=20180526204255
8	Dark Elf	2026-04-30 10:05:43.112	2026-04-30 10:01:26.964	50000	https://static.wikia.nocookie.net/blood-bowl/images/e/ee/DarkElf_Artwork.jpg/revision/latest/scale-to-width-down/185?cb=20180502153000
141	Dwarf	2026-04-30 10:05:46.708	2026-04-30 10:01:26.964	50000	\N
10	Elven Union	2026-04-30 10:05:54.433	2026-04-30 10:01:26.964	50000	https://static.wikia.nocookie.net/blood-bowl/images/1/15/Pro_Elf_Artwork.jpg/revision/latest/scale-to-width-down/210?cb=20180429004026
143	Gnomes	2026-04-30 10:05:57.35	2026-04-30 10:01:26.964	50000	\N
144	Goblins	2026-04-30 10:06:06.14	2026-04-30 10:01:26.964	60000	https://static.wikia.nocookie.net/blood-bowl/images/0/0b/Goblin_artwork.jpg/revision/latest/scale-to-width-down/215?cb=20180502155710
145	Halflings	2026-04-30 10:06:18.467	2026-04-30 10:01:26.964	60000	https://static.wikia.nocookie.net/blood-bowl/images/6/66/Halfling_artwork_bb.jpg/revision/latest/scale-to-width-down/212?cb=20180514001248
26	Skavens	2026-04-30 10:07:39.846	2026-04-30 10:01:26.964	50000	https://static.wikia.nocookie.net/blood-bowl/images/9/96/Skaven_3rd_edition.jpg/revision/latest/scale-to-width-down/300?cb=20180428160436
27	Slaanesh	2026-04-30 10:07:44.037	2026-04-30 10:01:26.964	70000	https://static.wikia.nocookie.net/blood-bowl/images/9/93/Mark_of_slaanesh.png/revision/latest/scale-to-width-down/300?cb=20180526210846
28	Slann	2026-04-30 10:07:45.05	2026-04-30 10:01:26.964	50000	https://static.wikia.nocookie.net/blood-bowl/images/6/63/Slann.jpg/revision/latest/scale-to-width-down/203?cb=20180625021827
161	Snotlings	2026-04-30 10:07:47.748	2026-04-30 10:01:26.964	60000	\N
\.


--
-- Data for Name: RosterEntry; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."RosterEntry" (id, "participantId", "positionId", "playerName", spp, dorsal, "agUp", "avUp", injured, "mvUp", "paUp", "stUp") FROM stdin;
143	16	94	Robbie Sinclaire (8)	0	\N	0	0	f	0	0	0
144	16	94	Wrath-Amon (4)	0	\N	0	0	f	0	0	0
145	16	94	Dr. Curt Connors (9)	0	\N	0	0	f	0	0	0
146	16	94	Bowser (7)	0	\N	0	0	f	0	0	0
147	16	94	el lagarto Juancho (11)	0	\N	0	0	f	0	0	0
148	16	93	Rango (1)	0	\N	0	0	f	0	0	0
149	16	92	Fran Sinclair (2)	0	\N	0	0	f	0	0	0
150	16	93	whip (3)	0	\N	0	0	f	0	0	0
151	16	92	Charlene Sinclair (6)	0	\N	0	0	f	0	0	0
152	16	94	Earl sinclair (5)	0	\N	0	0	f	0	0	0
153	16	92	Bebé Sinclair (00)	0	\N	0	0	f	0	0	0
166	17	524	Zaltar	0	\N	0	0	f	0	0	0
167	17	527	Mirzahk Barballama	0	\N	0	0	f	0	0	0
168	17	526	Glom Muerdecascos	0	\N	0	0	f	0	0	0
169	17	525	Puñalez	0	\N	0	0	f	0	0	0
170	17	527	Kargoth Rompefuego	0	\N	0	0	f	0	0	0
171	17	525	Navajez	0	\N	0	0	f	0	0	0
172	17	526	Zhoro Pinchoarmado	0	\N	0	0	f	0	0	0
173	17	526	Vharg Devorasangre	0	\N	0	0	f	0	0	0
174	17	526	Drakhar Ferroscuro	0	\N	0	0	f	0	0	0
175	17	528	Islero	0	\N	0	0	f	0	0	0
176	17	528	Avispado	0	\N	0	0	f	0	0	0
249	14	609	Big'o'wulf	3	\N	0	0	f	0	0	0
250	14	608	Per-sy-of	5	\N	0	0	f	0	0	0
251	14	608	Da Boss	8	\N	0	0	f	0	0	0
252	14	605	Ja-zoff	3	\N	0	0	f	0	0	0
253	14	605	Fil-oc-tes	0	\N	0	0	f	0	0	0
254	14	605	Or-Geof	0	\N	0	0	f	0	0	0
255	14	607	Ene-az	2	\N	0	0	f	0	0	0
256	14	607	Old goergy	2	\N	0	0	f	0	0	0
257	14	609	Herra-klez	0	\N	0	0	f	0	0	0
258	14	605	Hodr	0	\N	0	0	f	0	0	0
259	14	605	Odi-seok	0	\N	0	0	f	0	0	0
260	14	605	Te-sy-of	0	\N	0	0	f	0	0	0
\.


--
-- Data for Name: RosterEntrySkill; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."RosterEntrySkill" ("rosterEntryId", "skillId") FROM stdin;
\.


--
-- Data for Name: RosterHistory; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."RosterHistory" (id, "participantId", snapshot, "changedAt", reason) FROM stdin;
1	16	[]	2026-05-04 04:00:58.004	Actualización de alineación
2	16	[]	2026-05-04 04:01:34.657	Actualización de alineación
3	16	[{"id": 1, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}]	2026-05-04 04:02:39.127	Actualización de alineación
4	16	[{"id": 2, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 3, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}]	2026-05-04 04:14:55.009	Actualización de alineación
5	16	[{"id": 4, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 5, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}, {"id": 6, "spp": 0, "injuries": null, "playerName": "Whip (3)", "positionId": 94, "participantId": 16}]	2026-05-04 04:15:23.321	Actualización de alineación
6	16	[{"id": 7, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 8, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}]	2026-05-04 09:59:47.792	Actualización de alineación
7	16	[{"id": 9, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 10, "spp": 0, "injuries": null, "playerName": "sada", "positionId": 94, "participantId": 16}, {"id": 11, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}]	2026-05-04 10:00:14.97	Actualización de alineación
8	16	[{"id": 12, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 13, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}]	2026-05-04 10:13:36.411	Actualización de alineación
9	16	[{"id": 14, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 15, "spp": 0, "injuries": null, "playerName": "pepe el lagarto", "positionId": 93, "participantId": 16}, {"id": 16, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}]	2026-05-04 10:14:21.014	Actualización de alineación
10	16	[{"id": 17, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 18, "spp": 0, "injuries": null, "playerName": "pepe el lagarto", "positionId": 92, "participantId": 16}, {"id": 19, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}]	2026-05-04 10:15:55.918	Actualización de alineación
11	16	[{"id": 22, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 21, "spp": 0, "injuries": null, "playerName": "pepe el lagarto", "positionId": 92, "participantId": 16}, {"id": 20, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}]	2026-05-04 10:16:10.542	Actualización de alineación
12	16	[{"id": 23, "spp": 0, "injuries": null, "playerName": "pepe el lagarto", "positionId": 92, "participantId": 16}, {"id": 24, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}, {"id": 25, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}]	2026-05-04 10:19:22.831	Actualización de alineación
13	16	[{"id": 26, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 27, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}, {"id": 28, "spp": 0, "injuries": null, "playerName": "pepe el lagarto", "positionId": 92, "participantId": 16}]	2026-05-04 11:32:33.741	Actualización de alineación
14	16	[{"id": 29, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}, {"id": 30, "spp": 0, "injuries": null, "playerName": "whip (3)", "positionId": 93, "participantId": 16}, {"id": 31, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 32, "spp": 0, "injuries": null, "playerName": "Wrath-Amon", "positionId": 94, "participantId": 16}]	2026-05-04 11:36:01.198	Actualización de alineación
15	16	[{"id": 33, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 34, "spp": 0, "injuries": null, "playerName": "whip (3)", "positionId": 93, "participantId": 16}, {"id": 35, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}, {"id": 36, "spp": 0, "injuries": null, "playerName": "Robbie Sinclaire (8)", "positionId": 94, "participantId": 16}, {"id": 37, "spp": 0, "injuries": null, "playerName": "Charlene Sinclair (6)", "positionId": 92, "participantId": 16}, {"id": 38, "spp": 0, "injuries": null, "playerName": "Dr. Curt Connors (9)", "positionId": 94, "participantId": 16}, {"id": 39, "spp": 0, "injuries": null, "playerName": "el lagarto Juancho (11)", "positionId": 94, "participantId": 16}, {"id": 40, "spp": 0, "injuries": null, "playerName": "Wrath-Amon (4)", "positionId": 94, "participantId": 16}, {"id": 41, "spp": 0, "injuries": null, "playerName": "Bowser (7)", "positionId": 94, "participantId": 16}, {"id": 42, "spp": 0, "injuries": null, "playerName": "Earl sinclair (5)", "positionId": 94, "participantId": 16}, {"id": 43, "spp": 0, "injuries": null, "playerName": "Bebé Sinclair", "positionId": 92, "participantId": 16}]	2026-05-04 11:36:36.831	Actualización de alineación
16	16	[{"id": 44, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 45, "spp": 0, "injuries": null, "playerName": "el lagarto Juancho (11)", "positionId": 94, "participantId": 16}, {"id": 46, "spp": 0, "injuries": null, "playerName": "whip (3)", "positionId": 93, "participantId": 16}, {"id": 47, "spp": 0, "injuries": null, "playerName": "Robbie Sinclaire (8)", "positionId": 94, "participantId": 16}, {"id": 48, "spp": 0, "injuries": null, "playerName": "Wrath-Amon (4)", "positionId": 94, "participantId": 16}, {"id": 49, "spp": 0, "injuries": null, "playerName": "Dr. Curt Connors (9)", "positionId": 94, "participantId": 16}, {"id": 50, "spp": 0, "injuries": null, "playerName": "Charlene Sinclair (6)", "positionId": 92, "participantId": 16}, {"id": 51, "spp": 0, "injuries": null, "playerName": "Bowser (7)", "positionId": 94, "participantId": 16}, {"id": 52, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}, {"id": 53, "spp": 0, "injuries": null, "playerName": "Earl sinclair (5)", "positionId": 94, "participantId": 16}, {"id": 54, "spp": 0, "injuries": null, "playerName": "Bebé Sinclair (00)", "positionId": 92, "participantId": 16}]	2026-05-04 11:37:28.951	Actualización de alineación
17	16	[{"id": 55, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 56, "spp": 0, "injuries": null, "playerName": "whip (3)", "positionId": 93, "participantId": 16}, {"id": 57, "spp": 0, "injuries": null, "playerName": "el lagarto Juancho (11)", "positionId": 94, "participantId": 16}, {"id": 58, "spp": 0, "injuries": null, "playerName": "Bowser (7)", "positionId": 94, "participantId": 16}, {"id": 59, "spp": 0, "injuries": null, "playerName": "Wrath-Amon (4)", "positionId": 94, "participantId": 16}, {"id": 60, "spp": 0, "injuries": null, "playerName": "Charlene Sinclair (6)", "positionId": 92, "participantId": 16}, {"id": 61, "spp": 0, "injuries": null, "playerName": "Dr. Curt Connors (9)", "positionId": 94, "participantId": 16}, {"id": 62, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}, {"id": 63, "spp": 0, "injuries": null, "playerName": "Robbie Sinclaire (8)", "positionId": 94, "participantId": 16}, {"id": 64, "spp": 0, "injuries": null, "playerName": "Earl sinclair (5)", "positionId": 94, "participantId": 16}, {"id": 65, "spp": 0, "injuries": null, "playerName": "Bebé Sinclair (00)", "positionId": 92, "participantId": 16}]	2026-05-04 11:41:14.406	Actualización de alineación
18	16	[{"id": 66, "spp": 0, "injuries": null, "playerName": "whip (3)", "positionId": 93, "participantId": 16}, {"id": 67, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 68, "spp": 0, "injuries": null, "playerName": "Charlene Sinclair (6)", "positionId": 92, "participantId": 16}, {"id": 69, "spp": 0, "injuries": null, "playerName": "el lagarto Juancho (11)", "positionId": 94, "participantId": 16}, {"id": 70, "spp": 0, "injuries": null, "playerName": "Bowser (7)", "positionId": 94, "participantId": 16}, {"id": 71, "spp": 0, "injuries": null, "playerName": "Dr. Curt Connors (9)", "positionId": 94, "participantId": 16}, {"id": 72, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}, {"id": 73, "spp": 0, "injuries": null, "playerName": "Robbie Sinclaire (8)", "positionId": 94, "participantId": 16}, {"id": 74, "spp": 0, "injuries": null, "playerName": "Wrath-Amon (4)", "positionId": 94, "participantId": 16}, {"id": 75, "spp": 0, "injuries": null, "playerName": "Earl sinclair (5)", "positionId": 94, "participantId": 16}, {"id": 76, "spp": 0, "injuries": null, "playerName": "Bebé Sinclair (00)", "positionId": 92, "participantId": 16}]	2026-05-04 11:43:11.715	Actualización de alineación
19	16	[{"id": 77, "spp": 0, "injuries": null, "playerName": "whip (3)", "positionId": 93, "participantId": 16}, {"id": 78, "spp": 0, "injuries": null, "playerName": "Wrath-Amon (4)", "positionId": 94, "participantId": 16}, {"id": 79, "spp": 0, "injuries": null, "playerName": "el lagarto Juancho (11)", "positionId": 94, "participantId": 16}, {"id": 80, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}, {"id": 81, "spp": 0, "injuries": null, "playerName": "Robbie Sinclaire (8)", "positionId": 94, "participantId": 16}, {"id": 82, "spp": 0, "injuries": null, "playerName": "Charlene Sinclair (6)", "positionId": 92, "participantId": 16}, {"id": 83, "spp": 0, "injuries": null, "playerName": "Bowser (7)", "positionId": 94, "participantId": 16}, {"id": 84, "spp": 0, "injuries": null, "playerName": "Dr. Curt Connors (9)", "positionId": 94, "participantId": 16}, {"id": 85, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 86, "spp": 0, "injuries": null, "playerName": "Earl sinclair (5)", "positionId": 94, "participantId": 16}, {"id": 87, "spp": 0, "injuries": null, "playerName": "Bebé Sinclair (00)", "positionId": 92, "participantId": 16}]	2026-05-04 11:43:45.099	Actualización de alineación
20	16	[{"id": 88, "spp": 0, "injuries": null, "playerName": "whip (3)", "positionId": 93, "participantId": 16}, {"id": 89, "spp": 0, "injuries": null, "playerName": "Wrath-Amon (4)", "positionId": 94, "participantId": 16}, {"id": 90, "spp": 0, "injuries": null, "playerName": "el lagarto Juancho (11)", "positionId": 94, "participantId": 16}, {"id": 91, "spp": 0, "injuries": null, "playerName": "Robbie Sinclaire (8)", "positionId": 94, "participantId": 16}, {"id": 92, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 93, "spp": 0, "injuries": null, "playerName": "Bowser (7)", "positionId": 94, "participantId": 16}, {"id": 94, "spp": 0, "injuries": null, "playerName": "Charlene Sinclair (6)", "positionId": 92, "participantId": 16}, {"id": 95, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}, {"id": 96, "spp": 0, "injuries": null, "playerName": "Dr. Curt Connors (9)", "positionId": 94, "participantId": 16}, {"id": 97, "spp": 0, "injuries": null, "playerName": "Earl sinclair (5)", "positionId": 94, "participantId": 16}, {"id": 98, "spp": 0, "injuries": null, "playerName": "Bebé Sinclair (00)", "positionId": 92, "participantId": 16}]	2026-05-04 11:51:23.251	Actualización de alineación
21	16	[{"id": 99, "spp": 0, "injuries": null, "playerName": "whip (3)", "positionId": 93, "participantId": 16}, {"id": 100, "spp": 0, "injuries": null, "playerName": "el lagarto Juancho (11)", "positionId": 94, "participantId": 16}, {"id": 101, "spp": 0, "injuries": null, "playerName": "Wrath-Amon (4)", "positionId": 94, "participantId": 16}, {"id": 102, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 103, "spp": 0, "injuries": null, "playerName": "Bowser (7)", "positionId": 94, "participantId": 16}, {"id": 104, "spp": 0, "injuries": null, "playerName": "Dr. Curt Connors (9)", "positionId": 94, "participantId": 16}, {"id": 105, "spp": 0, "injuries": null, "playerName": "Robbie Sinclaire (8)", "positionId": 94, "participantId": 16}, {"id": 106, "spp": 0, "injuries": null, "playerName": "Charlene Sinclair (6)", "positionId": 92, "participantId": 16}, {"id": 107, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}, {"id": 108, "spp": 0, "injuries": null, "playerName": "Earl sinclair (5)", "positionId": 94, "participantId": 16}, {"id": 109, "spp": 0, "injuries": null, "playerName": "Bebé Sinclair (00)", "positionId": 92, "participantId": 16}]	2026-05-04 11:51:51.456	Actualización de alineación
22	16	[{"id": 110, "spp": 0, "injuries": null, "playerName": "Wrath-Amon (4)", "positionId": 94, "participantId": 16}, {"id": 111, "spp": 0, "injuries": null, "playerName": "whip (3)", "positionId": 93, "participantId": 16}, {"id": 112, "spp": 0, "injuries": null, "playerName": "Bowser (7)", "positionId": 94, "participantId": 16}, {"id": 113, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 114, "spp": 0, "injuries": null, "playerName": "Charlene Sinclair (6)", "positionId": 92, "participantId": 16}, {"id": 115, "spp": 0, "injuries": null, "playerName": "Robbie Sinclaire (8)", "positionId": 94, "participantId": 16}, {"id": 116, "spp": 0, "injuries": null, "playerName": "Dr. Curt Connors (9)", "positionId": 94, "participantId": 16}, {"id": 117, "spp": 0, "injuries": null, "playerName": "el lagarto Juancho (11)", "positionId": 94, "participantId": 16}, {"id": 118, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}, {"id": 119, "spp": 0, "injuries": null, "playerName": "Earl sinclair (5)", "positionId": 94, "participantId": 16}, {"id": 120, "spp": 0, "injuries": null, "playerName": "Bebé Sinclair (00)", "positionId": 92, "participantId": 16}]	2026-05-04 11:57:12.578	Actualización de alineación
23	16	[{"id": 121, "spp": 0, "injuries": null, "playerName": "Wrath-Amon (4)", "positionId": 94, "participantId": 16}, {"id": 122, "spp": 0, "injuries": null, "playerName": "Bowser (7)", "positionId": 94, "participantId": 16}, {"id": 123, "spp": 0, "injuries": null, "playerName": "whip (3)", "positionId": 93, "participantId": 16}, {"id": 124, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 125, "spp": 0, "injuries": null, "playerName": "Dr. Curt Connors (9)", "positionId": 94, "participantId": 16}, {"id": 126, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}, {"id": 127, "spp": 0, "injuries": null, "playerName": "Charlene Sinclair (6)", "positionId": 92, "participantId": 16}, {"id": 128, "spp": 0, "injuries": null, "playerName": "Robbie Sinclaire (8)", "positionId": 94, "participantId": 16}, {"id": 129, "spp": 0, "injuries": null, "playerName": "el lagarto Juancho (11)", "positionId": 94, "participantId": 16}, {"id": 130, "spp": 0, "injuries": null, "playerName": "Earl sinclair (5)", "positionId": 94, "participantId": 16}, {"id": 131, "spp": 0, "injuries": null, "playerName": "Bebé Sinclair (00)", "positionId": 92, "participantId": 16}]	2026-05-04 11:59:00.768	Actualización de alineación
24	16	[{"id": 132, "spp": 0, "injuries": null, "playerName": "Wrath-Amon (4)", "positionId": 94, "participantId": 16}, {"id": 133, "spp": 0, "injuries": null, "playerName": "Robbie Sinclaire (8)", "positionId": 94, "participantId": 16}, {"id": 134, "spp": 0, "injuries": null, "playerName": "whip (3)", "positionId": 93, "participantId": 16}, {"id": 135, "spp": 0, "injuries": null, "playerName": "Dr. Curt Connors (9)", "positionId": 94, "participantId": 16}, {"id": 136, "spp": 0, "injuries": null, "playerName": "Charlene Sinclair (6)", "positionId": 92, "participantId": 16}, {"id": 137, "spp": 0, "injuries": null, "playerName": "Fran Sinclair (2)", "positionId": 92, "participantId": 16}, {"id": 138, "spp": 0, "injuries": null, "playerName": "el lagarto Juancho (11)", "positionId": 94, "participantId": 16}, {"id": 139, "spp": 0, "injuries": null, "playerName": "Bowser (7)", "positionId": 94, "participantId": 16}, {"id": 140, "spp": 0, "injuries": null, "playerName": "Rango (1)", "positionId": 93, "participantId": 16}, {"id": 141, "spp": 0, "injuries": null, "playerName": "Earl sinclair (5)", "positionId": 94, "participantId": 16}, {"id": 142, "spp": 0, "injuries": null, "playerName": "Bebé Sinclair (00)", "positionId": 92, "participantId": 16}]	2026-05-04 11:59:28.989	Actualización de alineación
25	14	[]	2026-05-04 22:39:13.816	Actualización de alineación
26	17	[]	2026-05-05 10:19:46.391	Actualización de alineación
27	14	[{"id": 154, "spp": 0, "injuries": null, "playerName": "Te-sy-of", "positionId": 609, "participantId": 14}, {"id": 155, "spp": 0, "injuries": null, "playerName": "Per-sy-of", "positionId": 609, "participantId": 14}, {"id": 156, "spp": 0, "injuries": null, "playerName": "Old goergy", "positionId": 608, "participantId": 14}, {"id": 157, "spp": 0, "injuries": null, "playerName": "Odi-seok", "positionId": 605, "participantId": 14}, {"id": 158, "spp": 0, "injuries": null, "playerName": "Fil-oc-tes", "positionId": 607, "participantId": 14}, {"id": 159, "spp": 0, "injuries": null, "playerName": "Herra-klez", "positionId": 605, "participantId": 14}, {"id": 160, "spp": 0, "injuries": null, "playerName": "Ja-zoff", "positionId": 605, "participantId": 14}, {"id": 161, "spp": 0, "injuries": null, "playerName": "Da boss", "positionId": 608, "participantId": 14}, {"id": 162, "spp": 0, "injuries": null, "playerName": "Hodr", "positionId": 607, "participantId": 14}, {"id": 163, "spp": 0, "injuries": null, "playerName": "Big'o'wulf", "positionId": 605, "participantId": 14}, {"id": 164, "spp": 0, "injuries": null, "playerName": "Or-Geof", "positionId": 605, "participantId": 14}, {"id": 165, "spp": 0, "injuries": null, "playerName": "Ene-az", "positionId": 605, "participantId": 14}]	2026-05-05 18:26:03.738	Actualización de alineación
28	14	[{"id": 177, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Te-sy-of", "positionId": 609, "participantId": 14}, {"id": 178, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Per-sy-of", "positionId": 609, "participantId": 14}, {"id": 179, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Odi-seok", "positionId": 605, "participantId": 14}, {"id": 180, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Herra-klez", "positionId": 605, "participantId": 14}, {"id": 181, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Fil-oc-tes", "positionId": 607, "participantId": 14}, {"id": 182, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Old goergy", "positionId": 608, "participantId": 14}, {"id": 183, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Hodr", "positionId": 607, "participantId": 14}, {"id": 184, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Da boss", "positionId": 608, "participantId": 14}, {"id": 185, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Or-Geof", "positionId": 605, "participantId": 14}, {"id": 186, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Big'o'wulf", "positionId": 605, "participantId": 14}, {"id": 187, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Ja-zoff", "positionId": 605, "participantId": 14}, {"id": 188, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Ene-az", "positionId": 605, "participantId": 14}]	2026-05-05 19:05:30.697	Actualización de alineación
29	14	[{"id": 189, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Per-sy-of", "positionId": 609, "participantId": 14}, {"id": 190, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Odi-seok", "positionId": 605, "participantId": 14}, {"id": 191, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Herra-klez", "positionId": 605, "participantId": 14}, {"id": 192, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Hodr", "positionId": 607, "participantId": 14}, {"id": 193, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Big'o'wulf", "positionId": 605, "participantId": 14}, {"id": 194, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Or-Geof", "positionId": 605, "participantId": 14}, {"id": 195, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Ja-zoff", "positionId": 605, "participantId": 14}, {"id": 196, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 1, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Te-sy-of", "positionId": 609, "participantId": 14}, {"id": 197, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Old goergy", "positionId": 608, "participantId": 14}, {"id": 198, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Fil-oc-tes", "positionId": 607, "participantId": 14}, {"id": 199, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Da boss", "positionId": 608, "participantId": 14}, {"id": 200, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Ene-az", "positionId": 605, "participantId": 14}]	2026-05-05 19:06:04.696	Actualización de alineación
30	14	[{"id": 201, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Per-sy-of", "positionId": 609, "participantId": 14}, {"id": 202, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Odi-seok", "positionId": 605, "participantId": 14}, {"id": 203, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Fil-oc-tes", "positionId": 607, "participantId": 14}, {"id": 204, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 5, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Te-sy-of", "positionId": 609, "participantId": 14}, {"id": 205, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Big'o'wulf", "positionId": 605, "participantId": 14}, {"id": 206, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Or-Geof", "positionId": 605, "participantId": 14}, {"id": 207, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Herra-klez", "positionId": 605, "participantId": 14}, {"id": 208, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Hodr", "positionId": 607, "participantId": 14}, {"id": 209, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Ja-zoff", "positionId": 605, "participantId": 14}, {"id": 210, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Ene-az", "positionId": 605, "participantId": 14}, {"id": 211, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Old goergy", "positionId": 608, "participantId": 14}, {"id": 212, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Da boss", "positionId": 608, "participantId": 14}]	2026-05-05 19:06:25.585	Actualización de alineación
31	14	[{"id": 213, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Per-sy-of", "positionId": 609, "participantId": 14}, {"id": 214, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Big'o'wulf", "positionId": 605, "participantId": 14}, {"id": 215, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Herra-klez", "positionId": 605, "participantId": 14}, {"id": 216, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Fil-oc-tes", "positionId": 607, "participantId": 14}, {"id": 217, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Hodr", "positionId": 607, "participantId": 14}, {"id": 218, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Or-Geof", "positionId": 605, "participantId": 14}, {"id": 219, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Ja-zoff", "positionId": 605, "participantId": 14}, {"id": 220, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Te-sy-of", "positionId": 609, "participantId": 14}, {"id": 221, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Da boss", "positionId": 608, "participantId": 14}, {"id": 222, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Odi-seok", "positionId": 605, "participantId": 14}, {"id": 223, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Ene-az", "positionId": 605, "participantId": 14}, {"id": 224, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injuries": null, "playerName": "Old goergy", "positionId": 608, "participantId": 14}]	2026-05-05 19:51:26.018	Actualización de alineación
32	14	[{"id": 225, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Big'o'wulf", "positionId": 605, "participantId": 14}, {"id": 226, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Herra-klez", "positionId": 605, "participantId": 14}, {"id": 227, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Per-sy-of", "positionId": 609, "participantId": 14}, {"id": 228, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Fil-oc-tes", "positionId": 607, "participantId": 14}, {"id": 229, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Ene-az", "positionId": 605, "participantId": 14}, {"id": 230, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Old goergy", "positionId": 608, "participantId": 14}, {"id": 231, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Ja-zoff", "positionId": 605, "participantId": 14}, {"id": 232, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Da boss", "positionId": 608, "participantId": 14}, {"id": 233, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Or-Geof", "positionId": 605, "participantId": 14}, {"id": 234, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Hodr", "positionId": 607, "participantId": 14}, {"id": 235, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Odi-seok", "positionId": 605, "participantId": 14}, {"id": 236, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Te-sy-of", "positionId": 609, "participantId": 14}]	2026-05-10 22:08:03.106	Actualización de alineación
33	14	[{"id": 237, "spp": 3, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Big'o'wulf", "positionId": 609, "participantId": 14}, {"id": 238, "spp": 8, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Da Boss", "positionId": 608, "participantId": 14}, {"id": 239, "spp": 5, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Per-sy-of", "positionId": 608, "participantId": 14}, {"id": 240, "spp": 2, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Old goergy", "positionId": 607, "participantId": 14}, {"id": 241, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Herra-klez", "positionId": 609, "participantId": 14}, {"id": 242, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": true, "playerName": "Fil-oc-tes", "positionId": 605, "participantId": 14}, {"id": 243, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Or-Geof", "positionId": 605, "participantId": 14}, {"id": 244, "spp": 3, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Ja-zoff", "positionId": 605, "participantId": 14}, {"id": 245, "spp": 2, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Ene-az", "positionId": 607, "participantId": 14}, {"id": 246, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Hodr", "positionId": 605, "participantId": 14}, {"id": 247, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Odi-seok", "positionId": 605, "participantId": 14}, {"id": 248, "spp": 0, "agUp": 0, "avUp": 0, "mvUp": 0, "paUp": 0, "stUp": 0, "injured": false, "playerName": "Te-sy-of", "positionId": 605, "participantId": 14}]	2026-05-10 22:08:40.933	Actualización de alineación
\.


--
-- Data for Name: Round; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Round" (id, "tournamentId", number, phase, "createdAt") FROM stdin;
10	5	2	GROUP_STAGE	2026-05-03 22:39:49.355
12	5	4	GROUP_STAGE	2026-05-03 22:39:50.351
11	5	3	GROUP_STAGE	2026-05-03 22:39:49.956
14	5	1	GROUP_STAGE	2026-05-03 22:39:51.016
13	5	5	GROUP_STAGE	2026-05-03 22:39:50.614
15	5	1	GROUP_STAGE	2026-05-03 22:39:51.405
16	5	2	GROUP_STAGE	2026-05-03 22:39:51.668
18	5	4	GROUP_STAGE	2026-05-03 22:39:52.196
17	5	3	GROUP_STAGE	2026-05-03 22:39:51.934
19	5	5	GROUP_STAGE	2026-05-03 22:39:52.462
\.


--
-- Data for Name: Skill; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Skill" (id, name, category, description, "updatedAt", "scrapedAt") FROM stdin;
4	Defensive	Agility	(ACTIVE)During your opponent’s Turn, opposition players Marked by this player cannot use the Guard or Put the Boot In Skills.	2026-04-30 10:01:27.512	2026-04-30 10:01:26.964
7	Jump Up	Agility	(ACTIVE)This Skill can be used whilst a player is Prone. A Prone Player wuth this Skill can stand up for free without having to spend 3 squares of movement to do so. Additionally, a Prone player with this Skill can declare a Block Action whilst Prone, If they do, they must make an Agility Test, applying a +1 modifier to the result, if the Agility Test is passed, they may immediately stand uo and perform the Block Action. If the Agility Test failed, then the player remains Prone an their activation immediately ends.	2026-04-30 10:01:27.641	2026-04-30 10:01:26.964
8	Safe Pair of Hands	Agility	(ACTIVE)If this player would be Knocked Down, Fall Over or be Placed Prone Whilst in possession of the ball then, before they become Prone, they may place the ball in any adjacent unnoccupied square to the square they will become Prone in Instead of Bouncing the ball as normal.	2026-04-30 10:01:27.685	2026-04-30 10:01:26.964
9	Sidestep	Agility	(ACTIVE)Whenever this player is Pushed Back for any reason, then instead of the opposing Coach choosing where this player is Pushed Back to, this player’s Coach may choose any adjacent unoccupied square for this player to be Pushed Back into instead. If there are no adjacent unoccupied squares, then this Skill cannot be used.	2026-04-30 10:01:27.728	2026-04-30 10:01:26.964
10	Sprint	Agility	(ACTIVE)When this player performs a Move Action they may attempt to Rush one additional time than they would normally be allowed to.	2026-04-30 10:01:27.771	2026-04-30 10:01:26.964
11	Sure Feet	Agility	(ACTIVE)Once per Turn, this player may re-roll a single D6 when attempting to Rush.	2026-04-30 10:01:27.813	2026-04-30 10:01:26.964
12	Eye Gouge	General	(ACTIVE)When an opposition player is Pushed Back by this player, the opposition player cannot provide Offensive or Defensive Assists until after they are next activated.	2026-04-30 10:01:27.856	2026-04-30 10:01:26.964
13	Fumblerooski	General	(ACTIVE)When this player performs a Move Action while they are in possession of the ball, they may choose to place the ball on the ground in any square they move out of during their move action. This will not cause a Turnover. No longer works on a blitz action.	2026-04-30 10:01:27.899	2026-04-30 10:01:26.964
14	Lethal Flight	General	(ACTIVE)When this player is thrown as part of a Throw Team-mate Action, if they land in a square that contains an opposition player, including if they Bounce into a square containing an opposition player, and the opposition player is Knocked Down,, then they may apply a +1 modifier ot either the Armour Roll or Injury Roll This modifier may be applied after the roll has been made. If an opposition player suffers a Casualty as a result of being Knocked Down by the thrown player with this Skill, then this player will count as having caused that Casualty and will receive Star Player Points as appropriate. A player without the Right Stuff Trait cannot have this skill.	2026-04-30 10:01:27.943	2026-04-30 10:01:26.964
15	Lone Fouler	General	(ACTIVA)When this player performs a Foul Action, if there are no players providing an Offensive or Defensive Assist, then this player may re-roll a failed Armour Roll.	2026-04-30 10:01:27.985	2026-04-30 10:01:26.964
16	Pile Diver	General	(ACTIVE)When an opposition player is Knocked Down by this player during a Block Action, this player may perform a free Foul Action against the opposition player so long as they are still Standing and are still Marking the opposition player. This player is then Placed Prone and their activation immediately ends.	2026-04-30 10:01:28.029	2026-04-30 10:01:26.964
17	Put the Boot In	General	(ACTIVE)This player can provide Offensive Assist when a team-mate performs a Foul Action regardless of how many opposition players are Marking this player.	2026-04-30 10:01:28.071	2026-04-30 10:01:26.964
18	Quick Fool	General	(ACTIVE)This player’s activation does not end after performing a Foul Action, and they may continue with their Move Action with any movement they have remaining.	2026-04-30 10:01:28.115	2026-04-30 10:01:26.964
19	Saboteur	General	(ACTIVE)When this player is Knocked Down as a result of an opposition player’s Block Action, before the Armor Roll is made, they may roll a D6. On 1-3, nothing happens and the Armour Roll is made as normal. On a 4+, this player’s sabotaged weapon goes off and the opposition player is also Knocked Down, though this will not cause a Turnover unless the opposition player was holding the ball. If this player’s sabotaged weapon goes off, then they are automatically Knocked Out and the Armour Roll is not made for them. A player without the Secret Weapon Trait cannot have this Skill.	2026-04-30 10:01:28.158	2026-04-30 10:01:26.964
20	Shadowing	General	(ACTIVE)Each time an opposing player attempts to Dodge 0ut of a square Within this player’s Tackle Zone, this player may use this Skill. When this player uses this Skill, roll a D6. On a 1-3, nothing happens. On a 4+, this player immediately placed into the square that the opposition player vacated. This player may only use this Skill a number of times per Turn equal to their MA. If a player tries to leave the Tackle Zone of multiple players with this Skill at the same time only one of those players may use this Skill.	2026-04-30 10:01:28.216	2026-04-30 10:01:26.964
56	Brawler	Strength	(ACTIVE)When this player declared a Block Action, they may re-roll a single Both Down result.	2026-04-30 10:01:29.765	2026-04-30 10:01:26.964
5	Hit & Run	Agility	(ACTIVE)When a player with this Skill performs a Block Action or a Stab Special Action, after fully resolving the Action, they may immediately move one free square ignoring Tackle Zones, so long as they are still Standing. The player must ensure that after this free move they are not Marked by or Marking any opposition players.	2026-04-30 10:01:27.555	2026-04-30 10:01:26.964
6	Leap	Agility	(ACTIVE)During their Move Action, a player with this Skill can attempt to leap over a single adjacent square regardless of what is in the square. Leaping works the same way as Jumping, with the exception that the Leaping player may reduce the negative modifiers they would receive by Leaping by 1, to a minimum of -1. A player with this Skill cannot also have the Pogo Trait.	2026-04-30 10:01:27.598	2026-04-30 10:01:26.964
24	Fend	General	(ACTIVE)When a player with this Skill is Pushed Back as a result of a Block Action performed against them, then the opposition player may not Follow-up. This Skill cannot be used against a player with the Ball & Chain Trait or against a player with the Juggernaut Skill that is performing a Blitz Action.	2026-04-30 10:01:28.388	2026-04-30 10:01:26.964
26	Kick	General	(ACTIVE)If this player is nominated as the kicking player, then when kick Deviates this player’s Coach may choose to only Deviate D3 squaresrather than the usual D6.	2026-04-30 10:01:28.474	2026-04-30 10:01:26.964
27	Pro	General	(ACTIVE)During this player’s activation, they may attempt to re-roll a single dice. This can be a dice rolled on its own, as part of a multiple dice roll or as a dice pool. To use this Skill, the player must roll a D6; on a 3+ the dice may be re-rolled, on a 1-2 the dice may not be re-rolled. The Skill cannot be used to re-roll a dice made as part of an Armour Roll,, Injury Roll, Casualty Roll, a roll made outside of the player’s activation, or any dice roll not made on the player’s behalf (such as Argue the Call or if the Crowd Takes Action). Once a player has attempted to use this Skill, they cannot use are-roll from any other source to re-roll the dice.	2026-04-30 10:01:28.517	2026-04-30 10:01:26.964
28	Steady Footing	General	(PASSIVE)Whenever this player would be Knocked Down or Fall Over, roll a D6. On a 6, this player does not get Knocked Down or Fall Over. If this happens during their activation, they may continue their activation as normal and no Turnover Will be caused.	2026-04-30 10:01:28.56	2026-04-30 10:01:26.964
29	Strip Ball	General	(ACTIVE)When this player performs a Block Action against an opposition player holding the ball, the opposition player is Pushed Back, then they will drop the ball in the square they are Pushed Back into, at which point it will Bounce from that Square. This Bounce will happen before the opposition player becomes Prone (if appiclable) but after this player choose to Follow-up.	2026-04-30 10:01:28.603	2026-04-30 10:01:26.964
30	Sure Hands	General	(ACTIVE)This player may re-roll the D6 when attempting to pick up the ball, though not when making a Secure the Ball Action. Additionally, the Strip Ball Skill cannot be used against this player.	2026-04-30 10:01:28.647	2026-04-30 10:01:26.964
31	Tackle	General	(ACTIVE)When an opposition player attempts to Dodge away from a square in this player’s Tackle Zone, they cannot use the Dodge Skill. Additionally, when this player performs a Block Action against an opposition player, the opposition player doe snot count as having the Dodge Skill if a Stumble result is selected.	2026-04-30 10:01:28.69	2026-04-30 10:01:26.964
33	Wrestle	General	(ACTIVE)When this player performs a Block Action, or is the target of a Block Action, if the Both Down result is selected then this player can choose to use this Skill. If they do, both players in the Block Action are Placed Prone, regardless of any other Skills they may possess.	2026-04-30 10:01:28.775	2026-04-30 10:01:26.964
34	Claws	Mutation	(PASSIVE)Whenever an Armour Roll is made for an opposition player thas has been Knocked Down by this player  during a Block action, even if this player is also Knocked Down , then any roll of a natural 8+ on the Armour Roll will break the opposotion player’s armour regardless of their actual Armour Value.	2026-04-30 10:01:28.817	2026-04-30 10:01:26.964
35	Disturbing Presence	Mutation	(PASSIVE)Any opposition player that performs a Pass Action, Throw Team-mate Action or a Throw Bomb Special Action, or attempts to Intercept or Catch the ball, applies a -1 modifier to the Passing Ability Test or Agility Test, for each player on your team with this Skill within 3 squares of them.	2026-04-30 10:01:28.861	2026-04-30 10:01:26.964
36	Extra Arms	Mutation	(ACTIVE)This player may add a +1 modifier to their Agility Test when attempting to pick up, catch or intercept the ball.	2026-04-30 10:01:28.904	2026-04-30 10:01:26.964
37	Foul Appearance	Mutation	(PASSIVE)When an opposition player atempt to make a Block Action against this player, or a Special Action that targets this player directly , they must roll 1D6 before make any other rolls. On a 2+ the Actions may continue as normal. On a 1 the Action is canceled and the opposition player’s activations ends immediately.	2026-04-30 10:01:28.946	2026-04-30 10:01:26.964
38	Horns	Mutation	(ACTIVE)Whenever this player declares a Blitz Action, then they apply a +1 modifier to their Strength Characteristic for any Block Actions performing during that Blitz Action.	2026-04-30 10:01:28.989	2026-04-30 10:01:26.964
39	Iron Hard Skin	Mutation	(ACTIVE)Opposition players cannot apply any modifiers when making an Armour Roll against this player. Additionally, the Claws Skill cannot be used against this player.	2026-04-30 10:01:29.032	2026-04-30 10:01:26.964
57	Breack Tackle	Strength	(ACTIVE)Once per Turn, when this player attempts to Dodge, they may apply a +1 modifier to the Agility Test if they have a Strength Characteristic of 3 or lower, a +2 modifier to the Agility Test if they have a Strength Characteristic of 4, or a +3 modifier to the Agility Test if they have a Strength Characteristic of 5 or higher.	2026-04-30 10:01:29.807	2026-04-30 10:01:26.964
25	Frenzy	General	(ACTIVE)Every time this player performs a Block Action, if the target is Pushed Back, then this player must Follow-up after the Block Action. If, after the target is Pushed Back they are still Standing, then this player must perform a second Block Action targeting the same opposition player and must again Follow-up if the target is Pushed Back. If this player is performing a Blitz Action, performing a second Block Action will also cost the player a square of movement. If this player has no movement left, then they must Rush. If this player cannot Rush then they cannot perform the second Block Action. A player with this Skill cannot have the Grab, Hit & Run or Multiple Block Skills.	2026-04-30 10:01:28.43	2026-04-30 10:01:26.964
32	Taunt	General	(ACTIVE)When a player with this Skill is Pushed Back as a result of a Block Action performed against the, this player’s Coach may choose to make the opposition player Follow-up. This Skill cannot be used against an opposition player with the Take Root Trait that has become Rooted.	2026-04-30 10:01:28.732	2026-04-30 10:01:26.964
3	Diving Tackle	Agility	(ACTIVE)When a opposition player attempts to leave this player’s Tackle Zone as a result of a Dodge, Leap or Jump, after the Agility Test has been rolled and any modifiers and re-rolls have been applied, this player may use this Skill. Immediately apply a -2 modifier to the opposition player’s Agility Test and place this player Prone in the square the opposition player vacated. If a player tries to leave the Tackle Zone of multiple players with this Skill as the same time, only one of those players may use this Skill.	2026-04-30 10:01:27.469	2026-04-30 10:01:26.964
22	Violent Innovator	General	(ACTIVE)If an opposition player suffers a Casualty as a result of a Special Action this player performed, this player will earn Star Player Points for cousin a Casualty as appropriate. A player can only have this Skill if they have a Trait that allows them to perform a Special Action.	2026-04-30 10:01:28.302	2026-04-30 10:01:26.964
42	Tentacles	Mutation	(ACTIVE)When an opposition player attempts to Dodge, Jump, or Leap away from a square in this player’s Tackle Zone, this player may use this Skill. When a player uses this Skill they roll a D6 and add their Strength Characteristic to the roll; they then subtract the Strength Characteristic of the opposition player from the result. If the result is a 6 or higher, or the roll is a natural 6, then the opposition player does not leave the square they attempted to leave and their activation comes to an end. If the result if a 5 or lower, or the roll is a natural 1, this Skill has no effect. If a player tried to leave the Tackle Zone of multiple players with this Skill at the same time, only one of those players may use this Skill	2026-04-30 10:01:29.161	2026-04-30 10:01:26.964
43	Two Heads	Mutation	(ACTIVE)This player may apply a +1 modifier to the Agíllty Test whenever they attempt to Dodge.	2026-04-30 10:01:29.204	2026-04-30 10:01:26.964
45	Cannoneer	Passing	(ACTIVE) When this player performs a Pass Action which is a Long Pass or a Long Bomb, this player may apply a +1 modifier to the Passing Ability Test.	2026-04-30 10:01:29.289	2026-04-30 10:01:26.964
46	Cloud Burster	Passing	(ACTIVE)When this player performs a Pass Action, the opposition players may not attempt to intercept the ball.	2026-04-30 10:01:29.332	2026-04-30 10:01:26.964
47	Dump-Off	Passing	(ACTIVE)Whenever an opposition player attempts to perform a Block Action against this player, or a Special Action that targets this player directly, this player may use this Skill. When they do, this player may immediately perform a Quick Pass before the Action targeting them is resolved. This Quick Pass cannot cause a Turnover but otherwise follows all the normal rules for making a Quick Pass. Once the Quick Pass has been resolved, this Action targeting this player continues.	2026-04-30 10:01:29.375	2026-04-30 10:01:26.964
48	Give and Go	Passing	(ACTIVE)If this player performs a Pass Action that is a Quick Pass, or performs a Hand-off Action, then, so long as a Turnover isn’t caused, their activation does not end once the Pass or Hand-off is resolved. Instead they may continue with their Move Action using any movement the have remaining.	2026-04-30 10:01:29.418	2026-04-30 10:01:26.964
49	Hail Mary Pass	Passing	(ACTIVE)When this player performs a Pass Action or a Throw bomb Special Action, they may declare any square on the pitch as the target square rather than using the Range Ruler. Make a Passing Ability Test as normal treating the throw as a Long Bomb, and treating any result of an Accurate Pass as an Inaccurate Pass. A Hail Mary Pass cannot be intercepted.	2026-04-30 10:01:29.461	2026-04-30 10:01:26.964
50	Leader	Passing	(PASSIVE) A team that have one or more players with this Skill on the pitch at the start of a half may gain a single extra Team Re-roll – this is called a Leader Re-roll. A team can only use a Leader Re-roll if they have a player with the Leader Skill on the pitch, and if all players with this Skill are removed from play, either as a Casualty or by being Sent-off, before the Leader Re-roll is used the it is lost. A Leader Re-roll follows all of the usual rules for standard Team Re-rolls, with the exception that it cannot be lost as a result of a Halfling Master Chef.	2026-04-30 10:01:29.504	2026-04-30 10:01:26.964
51	Nerves of Steel	Passing	(ACTIVE)This player may ignore any modifiers for being Marked when making an Agility Test to Catch the ball, or when making a Passing Ability Test to Pass the ball.	2026-04-30 10:01:29.548	2026-04-30 10:01:26.964
53	Pass	Passing	(ACTIVE)This player may re-roll any failed Passing Abillty Test when performing a Pass Action.	2026-04-30 10:01:29.635	2026-04-30 10:01:26.964
55	Safe Pass	Passing	(ACTIVE)If this player rolls a natural 1 when making a Passing Ability Test, then it will not result in a Fumbled Pass. Instead, the player retains possession of the ball and their activation immediately ends. No turnover is caused.	2026-04-30 10:01:29.722	2026-04-30 10:01:26.964
41	Prehensile Tail	Mutation	(ACTIVE)When an opposition player attempts to Dodge Jump or Leap away from a square in this player’s Tackle Zone, they apply an additional -1 modifier to the Agility Test.If a player tries to leave the Tackle Zone of multiple players with this Skill at the same time, only on eof those players may use this Skill.	2026-04-30 10:01:29.118	2026-04-30 10:01:26.964
44	Very Long Legs	Mutation	(ACTIVE)This player may apply a +1 modifier to the Agility Test whenever they attempt to Leap or Jump, and may apply a +2 modifier to the Agility Test whenever they attempt to Intercept the ball. Additionally, this player ignores the Cloud Burster skill.	2026-04-30 10:01:29.247	2026-04-30 10:01:26.964
52	On the Ball	Passing	(ACTIVE) When an opposition player performs a Pass Action, after the target square has been declared but before the Passing Ability Tes is rolled, this player may move 3 squares following all the usual rules for a Move Action with the exception that they cannot Rush. Should this player Fall Over during this move, then their move immediately ends and the Pass Action resumes. If multiple players have this Skill, then they may all use it during the same Pass Action, though they must do so on at a time, and if one of them Falls Over before the others have had the chance to move, then they may not do so. Additionally, during the Star of Drive Sequence, adter the Kick Deviates but before the Kick-off Event is rolled, a single Open Player on the recieving team with this Skill may move up to 3 squares, following all the usual rules for a Move Action, with the exception that they cannot Rush. A player may not use this Skill if a Touchback is Caused and meu not move into the opposition half. Should this player Fall Over during this move, then their move immediately ends and the Kick-off Event is rolled.	2026-04-30 10:01:29.591	2026-04-30 10:01:26.964
54	Punt	Passing	(ACTIVE)This player may declare a Punt Special Action; only a single player may declare a Punt Special Action each Turn. When a player declares a Punt Special Action, they are first allowed to make a Move Action, though they cannot continue to move after the Punt Special Action has been resolved. If after their Move Action this player iis in possession of the ball, they can Punt it downfield. Position the Throw-in Template over this player so it faces one of the two End Zones or either Sideline. Roll a D6 to determine the direction the ball is kicked, and then a second D6 to determine how many squares in that direction the ball will travel. If this player has the Kick Skill, they may re-roll either one or both of these dice – though they must decide whether to re-roll the direction or not before rolling for the distance. If the ball lands in a square containing a player, then they must attempt to Catch the ball, otherwise it will Bounce. When performing a Punt Special Action, no Turnover is caused if the ball comes to rest on the ground; however, if after the Punt Special Action is resolved the ball is in possession of an opposition player, or the crowd, a Turnover is caused.	2026-04-30 10:01:29.678	2026-04-30 10:01:26.964
59	Grab	Strength	(ACTIVE)When this player declares a Block action, if the opposition player is Pushed Back, then this…	2026-04-30 10:01:29.895	2026-04-30 10:01:26.964
60	Guard	Strength	(ACTIVE)This player can provide Offensive and Defensive Assists when a player performs a Block Action regardless of how many opposition players are Marking this player.	2026-04-30 10:01:29.938	2026-04-30 10:01:26.964
62	Mighty Blow	Strength	(ACTIVE)(ELITE)Whenever this player Knocks Down an opposition player during a Block Action, even if this player is also Knocked Down, they may apply a +1 modifier to either the Armour Roll or Injury Roll. This modifier may be applied after the roll has been made.	2026-04-30 10:01:30.023	2026-04-30 10:01:26.964
64	Stand Firm	Strength	(ACTIVE)When this player would be Pushed Back during a Block Action, including during a Chain Push, they can choose to not be Pushed Back and instead remain in their current square. Using this Skill will not prevent a player with theFrenzy Skill from performing a second Block Action, so long as this player is still Standing.	2026-04-30 10:01:30.123	2026-04-30 10:01:26.964
65	Strong Arm	Strength	(ACTIVA)When this player performs a Throw Team-mate Action, this player may apply a +1 modifier to the Passing Ability Test. A player without the Throw Team-mate Trait cannot have this Skill.	2026-04-30 10:01:30.166	2026-04-30 10:01:26.964
66	Thick Skull	Strength	(ACTIVE)When an Injury Roll is made for this player, they will only be Knocked-out on the roll of a 9; a roll of an 8 will be treated as a Stunned result. If this player also has the Stunty Trait then they will only be Knocked-out on the roll of an 8; a roll of a 7 will be treated as a Stunned result.	2026-04-30 10:01:30.209	2026-04-30 10:01:26.964
68	Animosity	Trait	(ACTIVE)Whenever this player attempts to perform a Pass Action or a Hand-off Action to a team-mate with the same Keyword as the one shown in brackets, roll a D6. On a 1, the player refuses to perform the action and their activationimmediately ends. Some players may have the Animosity (all) Trait, in which case they will apply this rule to all of their team-mates, regardless of the Keywords they have.	2026-04-30 10:01:30.295	2026-04-30 10:01:26.964
85	Pick-Me-Up	Trait	(ACTIVE)At the end of each of the opposition’s Turns, roll a D6 for each Prone team-mate within 3 squares of one or more Standing players with this Trait. On a 5+, the Prone player may immediately stand up. Should a player with this Trail stand up as a result of a team-mate using this Trait, they may not also use this Trait during the same Turn.	2026-04-30 10:01:31.031	2026-04-30 10:01:26.964
86	Pogo	Trait	(ACTIVE)During their movement, a player with this Trait can attempt to Pogo over a single adjacent square regardless of what is in the square. Pogoing works the same way as Jumping, as described on page 56, with the exception that the Poging player may ignore all negative modifiers they would receive by Jumping. A player with this Trait cannot also have the Leap Skill.	2026-04-30 10:01:31.073	2026-04-30 10:01:26.964
63	Multiple Block	Strength	(ACTIVE)When this player declares a Block Action, they may perform two Block Actions each targeting a different opposition player they are Marking, if they do, then this player will reduce their Strength Characteristic by 2 for the duration of the Block Actions. These Block Actions happen simultaneously, though you may wish to roll them separately for clarity. This means that both Block Actions are resolved in full, even if one of them results in a Turnover. This playercannot Follow-up during either of these Block Actions. A player with this Skill cannot also have the Frenzy Skill.	2026-04-30 10:01:30.08	2026-04-30 10:01:26.964
70	BloodLust	Trait	(PASSIVE)Whenever this player is activated, after declaring their action, they must roll a D6, adding 1 to the roll if they declared a Block ACtion or a Blitz Action. If they roll equal to or higher than the number shown in brackets, they may activate as normal. If the player rolls lower than the number shown in brackets, or rolls a natural 1, they may continue their action as roam though they may change their declared action to a Move Action if they wish. If the player declared an Action that can only be performed one per Turn (such as a Blitz Action), this will still count as the one Blitz action for the Turn. At the end of their activation, this player may ite an adjacent Thrall Lineman team-mate regardless of the status of the Thrall Lineman. If they do, immediately make an Injury Roll for the Thrall Lineman, treating any Casualty result as Badly Hurt this will not cause a Turnover unless the Thrall Lineman was holding the ball. If this player does not bite a Thrall Lineman for any reason, then a Turnover is caused, this player becomes Distracted, and will immediately drop the ball if they were holding it. If this player was in the opposing End Zone, no Touchdown is scored. Of a player who failed this roll wants to perform a Pass Action, Hand-off Action, or score then they must bite aThrall Lineman before they perform the Action or score.	2026-04-30 10:01:30.382	2026-04-30 10:01:26.964
72	Bone Head	Trait	(PASSIVE)Whenever this player is activated, after declaring their Action they must roll a D6. On a 2+ the player may perform the declared Action as normal. On a 1, the player becomes Distracted.	2026-04-30 10:01:30.469	2026-04-30 10:01:26.964
73	Breath Fire	Trait	(ACTIVE)When this player is activated, they can declare a Breathe Fire Special Action; there is no limit to the number of players that can declare this Special Action each Turn,When a player makes a Breathe Fire Special Action, they may choose one Standing opposition player they are Marking and roll…	2026-04-30 10:01:30.512	2026-04-30 10:01:26.964
75	Decay	Trait	(PASSIVE)Apply a +1 modifier to any Casualty Roll made against this player.	2026-04-30 10:01:30.599	2026-04-30 10:01:26.964
76	Drunkard	Trait	(PASSIVE)This player applies a -1 modifier to test whenever they attempt to Rush.	2026-04-30 10:01:30.642	2026-04-30 10:01:26.964
77	Hatred	Trait	(PASSIVE)Whenever this player performs a Block action against a player with the same keyword as that shown in brackets, this player may re-roll a single Player Down result.	2026-04-30 10:01:30.685	2026-04-30 10:01:26.964
78	Hipnotic Gaze	Trait	(ACTIVE)When this player is activated, they can declare a Hypnotic Gaze Special Action; there iis no limit to the number of players that can declare this Special Action each Turn. When a player declares a Hypnotic Gaze Special Action they are first allowed to make a Move Action, though they cannot continue to move after the Hypnotic Gaze Special Action has been attempted. When a player performs a Hypnotic Gaze Special Action, they select a Standing opposition player adjacent to them and roll a D6. On a 1-2, nothing happens and this player’s activation immediately ends. On a 3+, the selected opposition player becomes Distracted and this player’s activation immediately ends.	2026-04-30 10:01:30.728	2026-04-30 10:01:26.964
79	Infected	Trait	(PASSIVE)Once per game, when a player with this Trait causes a Casualty against an opposition player as a result of a Block Action, and that player suffers a Dead result on their Casualty Roll and is not saved by an Apothecary, you may immediately add one new Lineman player from your team’s Team Roster to your Reserves Box. This may cause you to have more than 16 players for the remainder of the game. During the Post-game Sequence, this player may be hired in the same manner as any Journeymen players. This Trait cannot be used against Big Guy players, or any player with the Decay, Regeneration, or Stunty Traits.	2026-04-30 10:01:30.771	2026-04-30 10:01:26.964
80	Insignificant	Trait	(PASSIVE)When creating a Team Draft List, you may not include more players with this Trait than players without this Trait.	2026-04-30 10:01:30.814	2026-04-30 10:01:26.964
82	Loner	Trait	(PASSIVE)Whenever this player wishes to use a Team Re-roll, they must roll a D6. If they roll equal to or higher than the number shown in brackets, then they may use the Team Re-roll as normal.If they roll lower than the number shown in brackets, then they may not re-roll the dice and the Team Re-roll is lost just as if it had been used.	2026-04-30 10:01:30.902	2026-04-30 10:01:26.964
83	My Ball	Trait	(PASSIVE)A player with this Trait may not willingly give up the ball when in possession of it, and so may not declare Pass Actions, Hand-0ff Actions, or use any other Skill or Trait that would allow them to relinquish possession of the ball. Theonly way they can losee possession of the ball is by being Knocked Down, Placed Prone, Falling Over or by the effcet of a Skill, Trait, or special rule of an opposing model.	2026-04-30 10:01:30.945	2026-04-30 10:01:26.964
84	No Ball	Trait	(PASSIVE)A player with this Trait may never have possession ot the ball. If this player would be requíred to attempt to Catch or Pick-up the Ball, they will automatically fail to do so as if they had rolled a natural 1.A player with this Trait may not attempt lo Intercept a Pass.	2026-04-30 10:01:30.988	2026-04-30 10:01:26.964
88	Really Stupid	Trait	(PASSIVE)Whenever this player is activated, after declaring their Action, they must roll a D6. They may apply a +2 modifier to the roll if they have any Standing team-mates who are not Distracted, and do not have the Really Stupid Trait, adjacent to them. On a 4+, the player mau perform the declared Action as normal. On a 1-3, this player becomes Distracted.	2026-04-30 10:01:31.16	2026-04-30 10:01:26.964
89	Regeneration	Trait	(PASSIVE)Whenever this player suffers a Casualty, before making the Casualty roll for them, roll a D6. On a 1-3, this player suffers the Casualty; make the Casualty Roll as normal. On a 4+, this player regenerates and ignores the Casualty (though any Star Player Points earned for causing the Casualty are still earned) and is instead placed in their team’s Reserves Box.	2026-04-30 10:01:31.203	2026-04-30 10:01:26.964
90	Right Stuff	Trait	(PASSIVE)This player can be thrown bu a team-mate with the Throw Team-mate Trait, even if this player is Prone.	2026-04-30 10:01:31.245	2026-04-30 10:01:26.964
92	Stab	Trait	(ACTIVE)When this player is activated, they can declare a Stab Special Action; there is no limit to the number of players that can declare this Special Action each Turn. When this player performs a Stab Special Action, select a Standing opposition player adjacent to this player and make an Armour Roll for the selected player. This Armour Roll cannot be modified in any way. If the player’s Armour is broken, make an Injury Roll for them, otherwise nothing happens. This player may use the Stab Special Action to replace the Block Action made as part of a Blitz Action if they wish, though their activation will still end as soon as they have performed the Stab Special Action.	2026-04-30 10:01:31.332	2026-04-30 10:01:26.964
93	Stunty	Trait	(PASSIVE)When this player attempts to Dodge, they do not suffer any negative modifiers to their AgilityTest for being Marked by opposition players.Additionally this player applies a -1 modifier to the Agility Test when attempting to Intercept the ball. A player with this Trait is more prone to injury and so if an Injury Roll is made for them, orll on the Stunty Injury Table instead.	2026-04-30 10:01:31.376	2026-04-30 10:01:26.964
94	Swoop	Trait	(ACTIVE)When this player is thrown by a Throw Team-mate Action, they may choose not to Scatter before landing as normal. If they do, position the Throw-in Template over this player so it faces one of the two End Zones or either Sideline. Rolla D6 to determine the direction this player will travel ,and then a second D6 to determine how many squares in that direction this player will travel. Additionally, if they choose not to Scatter as normal, this player may re-roll the Agility Test when attempting to land.	2026-04-30 10:01:31.419	2026-04-30 10:01:26.964
95	Take Root	Trait	(PASSIVE)Whenever this player is activated, after declaring their Action, if they are Standing they must roll a D6. On a 2+ the player may perform the declared Action as normal. On a 1, the player becomes Rooted. Whilst Rooted, a player cannot perform Move Actions, may not Follow-up after performing a Block Action, cannot be Pushed Back, and may not leave their current square for any reason, with the exception of being Knocked Out or suffering a Casualty. A Rooted player will immediately stop being Rooted at the end of a Drive, or if they are ever Knocked Down or Placed Prone.	2026-04-30 10:01:31.462	2026-04-30 10:01:26.964
96	Throw Team-Mate	Trait	(ACTIVE)During each Turn, a single player on the active team may declare a Throw Team-mate Action in other to attempt to launch a team-mate across the pitch. A player may only declare this Action if they have the Throw Team-mate Trait. When a player declares a Throw Team-mate Action they are first allowed to make a Move Action, Though they cannot continue to move after the Throw Team-mate Action has been attempted. When a player performs a Throw Team-mate Action they may pick up an adjacent team-mate with the Right Stuff Trait to be Thrown, and then follor these steps in order:	2026-04-30 10:01:31.505	2026-04-30 10:01:26.964
97	Declare Target Square	Trait	Mesure Range (Max 6 Squares)	2026-04-30 10:01:31.548	2026-04-30 10:01:26.964
98	Test for Accuracy (Pass Ability Test)	Trait	Landing Timm-ber!	2026-04-30 10:01:31.591	2026-04-30 10:01:26.964
100	Trickster	Trait	(PASSIVE)Whenever an opposition player attempts to perform a Block Action against this player, or a Special Action that targets this player directly (with the exception 0f a Block Action caused by the Ball & Chain Special Action), this player may use this Trait. Bef0re determining how many dice are rolled, this player may be removed from the pitch and placed in any other unoccupied square adjacent to the player performing the Action. The Action then takes place as nornal. If the player using this Trait is holding the ball and places themselves on the opposition End Zone, the Action will still be fully resolved before any touchd0wn is resolved. If this player uses this Trait to be placed on the ball, they may attempt to pick it up before any dice are rolled.	2026-04-30 10:01:31.677	2026-04-30 10:01:26.964
101	Unchaneled Fury	Trait	(PASSIVE)Whenever this player is activated, after declaring their Action, they must roll a D6. They may apply a +1 modifier to the roll if they have declared a Block Action or a Blitz Action. On a 4+, the player may perform the declared Actionas normal. On a 1-3, this player rages incoherently but nothing really happens. Their activation immediately ends.	2026-04-30 10:01:31.72	2026-04-30 10:01:26.964
102	Unsteady	Trait	(PASSIVE)This player may not declare Secure the Ball Actions. .blockspare-61941fa3-820a-4 .blockspare-block-button{text-align:center;margin-top:30px;margin-bottom:30px}.blockspare-61941fa3-820a-4 .blockspare-block-button span{color:#fff;border-width:1px;font-size:16px;font-weight:500}.blockspare-61941fa3-820a-4.wp-block-blockspare-blockspare-buttons .blockspare-block-button .blockspare-button{background-image:linear-gradient(-120deg,#000000 0%,#cf2e2e 37%)}.blockspare-61941fa3-820a-4.wp-block-blockspare-blockspare-buttons .blockspare-block-button .blockspare-button:visited{background-image:linear-gradient(-120deg,#000000 0%,#cf2e2e 37%)}.blockspare-61941fa3-820a-4.wp-block-blockspare-blockspare-buttons .blockspare-block-button .blockspare-button:focus{background-image:linear-gradient(-120deg,#000000 0%,#cf2e2e 37%)}@media screen and (max-width:1025px){.blockspare-61941fa3-820a-4 .blockspare-block-button span{font-size:14px}}@media screen and (max-width:768px){.blockspare-61941fa3-820a-4 .blockspare-block-button span{font-size:12px}}Contacto .blockspare-2164e32f-d672-4 .blockspare-block-button{text-align:center;margin-top:30px;margin-bottom:30px;margin-left:0px;margin-right:0px}.blockspare-2164e32f-d672-4 .blockspare-block-button span{color:#fff;border-width:2px;font-size:16px}.blockspare-2164e32f-d672-4.wp-block-blockspare-blockspare-buttons .blockspare-block-button .blockspare-button{background-image:linear-gradient(-120deg,#000000 0%,#cf2e2e 37%)}.blockspare-2164e32f-d672-4.wp-block-blockspare-blockspare-buttons .blockspare-block-button .blockspare-button:visited{background-image:linear-gradient(-120deg,#000000 0%,#cf2e2e 37%)}.blockspare-2164e32f-d672-4.wp-block-blockspare-blockspare-buttons .blockspare-block-button .blockspare-button:focus{background-image:linear-gradient(-120deg,#000000 0%,#cf2e2e 37%)}.blockspare-2164e32f-d672-4 .blockspare-block-button a{padding-top:12px;padding-bottom:12px;padding-right:22px;padding-left:22px}@media screen and (max-width:1025px){.blockspare-2164e32f-d672-4 .blockspare-block-button span{font-size:14px}}@media screen and (max-width:768px){.blockspare-2164e32f-d672-4 .blockspare-block-button span{font-size:14px}}Patreon .blockspare-d203a464-ecac-4 .blockspare-block-button{text-align:center;margin-top:30px;margin-bottom:30px}.blockspare-d203a464-ecac-4 .blockspare-block-button span{color:#fff;border-width:1px;font-size:16px;font-weight:500}.blockspare-d203a464-ecac-4.wp-block-blockspare-blockspare-buttons .blockspare-block-button .blockspare-button{background-image:linear-gradient(-120deg,#000000 0%,#cf2e2e 37%)}.blockspare-d203a464-ecac-4.wp-block-blockspare-blockspare-buttons .blockspare-block-button .blockspare-button:visited{background-image:linear-gradient(-120deg,#000000 0%,#cf2e2e 37%)}.blockspare-d203a464-ecac-4.wp-block-blockspare-blockspare-buttons .blockspare-block-button .blockspare-button:focus{background-image:linear-gradient(-120deg,#000000 0%,#cf2e2e 37%)}@media screen and (max-width:1025px){.blockspare-d203a464-ecac-4 .blockspare-block-button span{font-size:14px}}@media screen and (max-width:768px){.blockspare-d203a464-ecac-4 .blockspare-block-button span{font-size:12px}}Buy me a coffee This is an unofficial and non-commercial fan website.	2026-04-30 10:01:31.763	2026-04-30 10:01:26.964
91	Secret Weapon	Trait	(PASSIVE)At the end of a Drive in wich this player took part, even if they are not in the pitch at the end of the Drive, they are Sent-Off for committing a Foul.	2026-04-30 10:01:31.289	2026-04-30 10:01:26.964
99	Titchy	Trait	(ACTIVE)A player with this Trait may apply a +1 modifier to the Agility Test when attempting to Dodge. However, when anopposition player attempts to Dodge lnto a square within this player’s Tackle Zone, this player will not apply a -1 modifier to the opposition player’s Agillty Test for Marking the opposition player.	2026-04-30 10:01:31.634	2026-04-30 10:01:26.964
71	Bombardier	Trait	(ACTIVE)When this player is activated, they can declare a Throw Bomb Special Action only one player can declare this Special Action each Turn. When a player performs a Throw Bomb Special Action, they throw a bomb in the same manner as when a player performs a Pass Action, following all the usual rules for a Pass Action. Though this i snot a Pass Action itself, any Skills or Traits that come into play when a player performs a Pass Action will also apple to a Throw Bomb Special Action, with the exception of the On the Ball Skill A player that declared a Tow Bomb Special Action may not perform a Move Action before throwing the bomb. If at any point a bomb comes to rest on the ground then it will immediately explode in that square. Should a bomb be Fumbled by the thrower, or dropped when a player attempts to Catch it, then it will not Bounce and will instead explode in that player’s square. When a bomb explodes, any player in the square it exploded in is hit by the explosion. Additionally, roll a d6 for each player adjacent to the square in which the bomb exploded. O a 4+ they are hit by the explosion. Any Standing player that is hit by the explosion is immediately Knocked Down. Additionally, make an Amrour Roll for any Prone or Stunned players hit by the explosion.If a player successfully Catches or Intercepts a thrown bomb, the player that caught the bomb must immediately throw it again, following all the same rules for making a throw Bomb Special Action as described above.	2026-04-30 10:01:30.426	2026-04-30 10:01:26.964
104	Manage Cookie Consent	Trait	To provide the best experiences, we use technologies like cookies to store and/or access device information. Consenting to these technologies will allow us to process data such as browsing behavior or unique IDs on this site. Not consenting or withdrawing consent, may adversely affect certain features and functions.	2026-04-30 10:01:31.85	2026-04-30 10:01:26.964
105	Functional	Trait	Functional Always active The technical storage or access is strictly necessary for the legitimate purpose of enabling the use of a specific service explicitly requested by the subscriber or user, or for the sole purpose of carrying out the transmission of a communication over an electronic communications network.	2026-04-30 10:01:31.893	2026-04-30 10:01:26.964
106	Preferences	Trait	Preferences The technical storage or access is necessary for the legitimate purpose of storing preferences that are not requested by the subscriber or user.	2026-04-30 10:01:31.936	2026-04-30 10:01:26.964
107	Statistics	Trait	Statistics The technical storage or access that is used exclusively for statistical purposes. The technical storage or access that is used exclusively for anonymous statistical purposes. Without a subpoena, voluntary compliance on the part of your Internet Service Provider, or additional records from a third party, information stored or retrieved for this purpose alone cannot usually be used to identify you.	2026-04-30 10:01:31.979	2026-04-30 10:01:26.964
108	Marketing	Trait	Marketing The technical storage or access is required to create user profiles to send advertising, or to track the user on a website or across several websites for similar marketing purposes.	2026-04-30 10:01:32.022	2026-04-30 10:01:26.964
109	Manage options	Trait	Manage services Manage {vendor_count} vendors	2026-04-30 10:01:32.065	2026-04-30 10:01:26.964
110	Read more about these purposes	Trait	Accept Deny View preferences	2026-04-30 10:01:32.107	2026-04-30 10:01:26.964
111	Save preferences	Trait	View preferences {title}	2026-04-30 10:01:32.15	2026-04-30 10:01:26.964
113	/* <![CDATA[ */	Trait	jqueryParams.length&&$.each(jqueryParams,function(e,r){if("function"==typeof r){var n=String(r);n.replace("$","jQuery");var a=new Function("return "+n)();$(document).ready(a)}});	2026-04-30 10:01:32.247	2026-04-30 10:01:26.964
114	//# sourceURL=jquery-js-after	Trait	/* ]]> */ /* <![CDATA[ */ var bbdcData = {"ajaxurl":"https://nufflezone.com/wp-admin/admin-ajax.php","nonce":"6d630af24d","strings":{"error":"Error al calcular la probabilidad","success":"C\\u00e1lculo completado"}};	2026-04-30 10:01:32.29	2026-04-30 10:01:26.964
115	//# sourceURL=bbdc-script-js-extra	Trait	/* ]]> */ /* <![CDATA[ */ var eztoc_smooth_local = {"scroll_offset":"30","add_request_uri":"","add_self_reference_link":""};	2026-04-30 10:01:32.333	2026-04-30 10:01:26.964
117	//# sourceURL=eztoc-js-js-extra	Trait	/* ]]> */ /* <![CDATA[ */ var DIVI = {"item_count":"%d Item","items_count":"%d Items"}; var et_builder_utils_params = {"condition":{"diviTheme":true,"extraTheme":false},"scrollLocations":["app","top"],"builderScrollLocations":{"desktop":"app","tablet":"app","phone":"app"},"onloadScrollLocation":"app","builderType":"fe"}; var et_frontend_scripts = {"builderCssContainerPrefix":"#et-boc","builderCssLayoutPrefix":"#et-boc .et-l"}; var et_pb_custom = {"ajaxurl":"https://nufflezone.com/wp-admin/admin-ajax.php","images_uri":"https://nufflezone.com/wp-content/themes/Divi/images","builder_images_uri":"https://nufflezone.com/wp-content/themes/Divi/includes/builder/images","et_frontend_nonce":"745d73725a","subscription_failed":"Please, check the fields below to make sure you entered the correct information.","et_ab_log_nonce":"e08e9e5bf3","fill_message":"Please, fill in the following fields:","contact_error_message":"Please, fix the following errors:","invalid":"Invalid email","captcha":"Captcha","prev":"Prev","previous":"Previous","next":"Next","wrong_captcha":"You entered the wrong number in captcha.","wrong_checkbox":"Checkbox","ignore_waypoints":"no","is_divi_theme_used":"1","widget_search_selector":".widget_search","ab_tests":[],"is_ab_testing_active":"","page_id":"9127","unique_test_id":"","ab_bounce_rate":"5","is_cache_plugin_active":"no","is_shortcode_tracking":"","tinymce_uri":"https://nufflezone.com/wp-content/themes/Divi/includes/builder/frontend-builder/assets/vendors","accent_color":"#7EBEC5","waypoints_options":[]};	2026-04-30 10:01:32.419	2026-04-30 10:01:26.964
118	var et_pb_box_shadow_elements = [];	Trait	//# sourceURL=divi-custom-script-js-extra	2026-04-30 10:01:32.462	2026-04-30 10:01:26.964
1	Dodge	Agility	(ACTIVE)One per Turn, this player may re-roll a single Agility Test when attempting to Dodge. Additionaly, this Skill will impact the Stumble result when an opposition player performs a Block Action against this player, causing the result to be “Push Back”.	2026-04-30 10:01:27.34	2026-04-30 10:01:26.964
126	Hit and Run	Trait	Hit and Run	2026-04-30 09:46:17.017	2026-04-30 09:46:09.083
2	Diving Catch	Agility	(ACTIVE)This player may attempt to Catch the ball if it lands in a square in their Tackle Zone as a result of a Pass, Throw-in or Kick-off. They may not use this Skill to attempt to Catch the ball if it lands in a square in their Tackle Zone as a result of a Bounce. Additionaly, this player may apply a +1 modifier to their Agility Test when attempting to Catch the ball as part of a Pass Action if they are in the target square.	2026-04-30 10:01:27.426	2026-04-30 10:01:26.964
21	Sneaky Git	General	(ACTIVE)This player is not Sent-off when performing a Foul Action if a natural double is rolled for the Armour Roll, so long as the target player’s Armour is not broken. If the target player’s Armour is broken, this player will sitll be sent off as normal.	2026-04-30 10:01:28.26	2026-04-30 10:01:26.964
23	Dauntless	General	(ACTIVE)When a player with this Skill peforms a Block Action against an opposition player with a higher Strength Characteristic (before any modifiers are aplied to etheir player), this player may roll a D6 and add their own Strength Characteristic. If the result is higher than the opposition player’s unmodified Strength Characteristic, then this player increases their unmodified Strength Characteristic to match that of the opposition player for the duration ofthe Block Action. Modifiers are then applied as normal. If this player also has a Skill that allows them to perform multiple Block Actions, such as the Frenzy Skill, then they must make a separate roll for each Block Action.	2026-04-30 10:01:28.344	2026-04-30 10:01:26.964
40	Monstrous Mouth	Mutation	(ACTIVE)When this player is activated, they may declare a Chomp Special Action; there is no limit to the number of players that can declare this Special Action each Turn. When this player declares a Chomp Special Action, they may select one Standing opposition player they are MMarking and roll a D6. On a 1-2 nothing happens. On a 3+, the opposition player is considered to be Chomped. Whilst Chomped, the opposition player cannot leave the square they are in whilst this player remains Marking them This condition ends immediately if this player is no longer Marking the opposition player for any reason. This player may use the Chomp Special Action to replace the Block Action made as part of a Blitz Action if they wish. Additionally, the Stirp Ball Skill cannot be used assist this player.	2026-04-30 10:01:29.075	2026-04-30 10:01:26.964
131	Catch	Trait	Catch	2026-04-30 09:46:26.416	2026-04-30 09:46:09.083
132	Block	Trait	Block	2026-04-30 09:46:27.517	2026-04-30 09:46:09.083
81	Kick Team-mate	Trait	(ACTIVE)When this player is activated, they can declare a Kick Team-mate Special Action; only one player can declare this Special Action each Turn. A Kick Team-mate Speclal Action works exactly the same as a Throw Team-mate Action, with the following exceptions: Performing a Kick Team-mate Special Action does not count as a team’s Throw Team-mate Action for the Turn, and so a team can perform both a Kick Team-mate Special Action and a Throw Team-mate Action in the same turn tfthey wish. However, if a Kick Team-mate Special Action results in a Fumbled Throw, immediately make an injury Roll for the team-mate being kicked, treating any result of Stunned as Knocked Out. lf the kicked player was holding the ball, it will Bounce from the square they were in. Any Skills or Traits that come into play when a player performs a Throw Team-mate Action will also apply to a Kick Teem-mate Special Action. This player will also gain Star Player Points in the same manner as a Throw Team-mate Action.	2026-04-30 10:01:30.858	2026-04-30 10:01:26.964
103	Facebook	Trait	X Instagram RSS Designed by Elegant Themes | Powered by WordPress {"prefetch":[{"source":"document","where":{"and":[{"href_matches":"/*"},{"not":{"href_matches":["/wp-*.php","/wp-admin/*","/wp-content/uploads/*","/wp-content/*","/wp-content/plugins/*","/wp-content/themes/Divi/*","/*\\\\?(.+)"]}},{"not":{"selector_matches":"a[rel~=\\"nofollow\\"]"}},{"not":{"selector_matches":".no-prefetch, .no-prefetch a"}}]},"eagerness":"conservative"}]}	2026-04-30 10:01:31.808	2026-04-30 10:01:26.964
120	//# sourceURL=cmplz-cookiebanner-js-extra	Trait	/* ]]> */ /* <![CDATA[ */	2026-04-30 10:01:32.548	2026-04-30 10:01:26.964
121	let cmplz_activated_divi_recaptcha = false;	Trait	document.addEventListener("cmplz_enable_category", function (e) { if (!cmplz_activated_divi_recaptcha && (e.detail.category==='marketing' || e.detail.service === 'google-recaptcha') ){	2026-04-30 10:01:32.592	2026-04-30 10:01:26.964
122	cmplz_divi_init_recaptcha();	Trait	} }); function cmplz_divi_init_recaptcha() { if ('undefined' === typeof window.jQuery || 'undefined' === typeof window.etCore ) {	2026-04-30 10:01:32.634	2026-04-30 10:01:26.964
123	setTimeout(cmplz_divi_init_recaptcha, 500);	Trait	} else { window.etCore.api.spam.recaptcha.init();	2026-04-30 10:01:32.677	2026-04-30 10:01:26.964
124	cmplz_activated_divi_recaptcha = true;	Trait	} } let cmplzBlockedContent = document.querySelector('.cmplz-blocked-content-notice');	2026-04-30 10:01:32.72	2026-04-30 10:01:26.964
148	Claw	Trait	Claw	2026-04-30 09:46:45.056	2026-04-30 09:46:09.083
149	Loner (4+)	Trait	Loner (4+)	2026-04-30 09:46:45.809	2026-04-30 09:46:09.083
150	Unchanneled Fury	Trait	Unchanneled Fury	2026-04-30 09:46:46.03	2026-04-30 09:46:09.083
125	if ( cmplzBlockedContent) {	Trait	cmplzBlockedContent.addEventListener('click', function(event) { event.stopPropagation();	2026-04-30 10:01:32.763	2026-04-30 10:01:26.964
155	Fumblerooskie	Trait	Fumblerooskie	2026-04-30 09:46:55.678	2026-04-30 09:46:09.083
156	Side Step	Trait	Side Step	2026-04-30 09:46:57.223	2026-04-30 09:46:09.083
168	Unchannelled Fury	Trait	Unchannelled Fury	2026-04-30 09:47:29.267	2026-04-30 09:46:09.083
169	Mighty Blow (+1)	Trait	Mighty Blow (+1)	2026-04-30 09:47:31.013	2026-04-30 09:46:09.083
183	Pogo Stick	Trait	Pogo Stick	2026-04-30 09:48:16.976	2026-04-30 09:46:09.083
58	Bullseye	Strength	(ACTIVE)When this player performs a Throw Team-mate Action, if the result of the throw is a Superb Throw then the thrown player will not Scatter before landing and will instead land in the target square. A player without the Throw Team-mate Trait cannot have this skill.	2026-04-30 10:01:29.852	2026-04-30 10:01:26.964
61	Juggernaut	Strength	(ACTIVE)When this player declares a Blitz Action, they may treat any result of Both Down as Pushed Back during any Block Action they perform during the Blitz Action. Additionally, when this player performs a Block Action as part of a Blitz Action, opposition players cannot use the Fend, Stand Firm or Wrestle Skills.	2026-04-30 10:01:29.98	2026-04-30 10:01:26.964
67	Animal Savagery	Trait	(PASSIVE) Whenever this player is activated, after declaring their action they must roll a 1D6. They may apply a +2 modifier to the roll if they have declared a Block Action or a Blitz Action. On a 4+, the player may perform the declared actionas normal. On a 1-3, this player lashes out at one of their team-mates. Choose one Standing team-mate adjacent to this player; the chosen player is immediately Knocked Down. This will not cause a Tunrover unless the player was holding theball. If this player has either the Claws or Migty Blow Skill, then they must use them when making the Armour roll for the Knocked Down Player. If this player rolls a 1-3 and there are no Standing  team-mate adjacent to them, they are Distracted.	2026-04-30 10:01:30.252	2026-04-30 10:01:26.964
69	Ball & Chain	Trait	(ACTIVE)When this player is activades, the only action they can declare is a Ball & Chain Special Action; there is no limit to the number of players that can declare this Special Action each Turn. When a player performs a Ball & Chain Special Action, position the Throw-in Template over this player so it faces one of the two End Zones or either Sideline.Then roll a D6 and move this player into the square as indicated by the Throw-in Template. A player that moves in this manner does not have to make an Agility Test to Dodge away from another player’s Tackle Zone; they will automatically pass. Opposition players cannot use the Shadowing or Tentacles Skill against a player performing a Ball & Chain Action. If this move takes this players off the pitch they will risk Injury by the Crowd. If this move takes this player into a square containing a Standing player (from either team) they will automatically perform a Block Action against that player; this Block Action will ignore the Foul Appearence Skill. If this is a team-mate, then this player’s Coach will choos which result to apply after the Block Dice have been rolled. If this move takes this player into a square containing a Prone or Stunned player, that player is Pushed Back and an Armour Roll is made against them. If this move takes this player into a square containing the ball, it will immediately Bounce. This will not cause a Turnover. A player performing a Ball & Chain Special Action can move a number of squares up to their MA. They may Rush as normal, though if they roll a 1, they will move into the square as normal firts, including performing any Block Actions, Pushing Back any players or causing the ball to Bounce, before Falling Over in the square they have moved into. If a player is Knocked Down, Falls Over or Placed Prone for any reason, immediately make an Injury Roll for them threathing any result of Stunned as Knocked-out instead. A player with this Trait cannot have any of the following Skills: Diving Tackle, Eye Gouge, Frenzy, Grab, Hit & Run, Leap, Multiple Block, On the Ball, Shadowing, Steady Footing.	2026-04-30 10:01:30.338	2026-04-30 10:01:26.964
74	Chainsaw	Trait	(ACTIVE)When this player is activated, they can declare a Chainsaw Attack Special Action; there is no limit to the number of players that can declare this Special Action each Turn.When a player performs a Chainsaw Attack Special Action, roll a D6. On 2+, this player may immediately make an Armour Roll against one adjacent Standing opposition player applying a +3 modifier to the Armour Roll. On a 1, the Chainsaw will Kick-back and this player is Knocked Down instead. If this player is Knocked Down or Falls Over for any reason, regardless of how it ocurred, then, a +3 modifier is applied when the opposition Coach makes an Armour Roll fot his player. This +3 modifier must always be applied. Should they wish, this player may also use the chainsaw when performing a Foul Action. In which case they may apply a +3 modifier when making the Armour Roll for the opposition player. They will still need to roll for Kick-back as normal. This player may use the Chainsaw Attack Special Action to replace the Block Action made as part of a Blitz Action if they wish, though their activation will still and as soon as they have performed the Chainsaw Attack Special Action.	2026-04-30 10:01:30.555	2026-04-30 10:01:26.964
87	Projectile Vomit	Trait	(ACTIVE)When this player is activated, they can declare a Projectile Vomit Special Action; there is no limit to the number of players that can declare this Special Action each turn. When this player performs a Projectile Vomit Special Action, select a Standing opposition player adjacent to this player and roll a D6 On a 2+, this player vomits on their target make an Armour Roll for the selected player. This Armour Roll cannot be modified in any way. If the player’s armour is broken, make an Injury Roll for them, ,otherwise nothing happens. On a 1, this player covers themselves in acidic bile; make an Armour Roll for this player. This Armour Roll cannot be modified in any way. If this player’s armour is broken, make an Injury Roll for them, otherwise nothing happens. This player may use the Projectile Vomit Special Action to replace the Block Action made as part of a blitz Action if they wish, though their activation will end as soon as they have performed the Projectile Vomit Special Action.	2026-04-30 10:01:31.116	2026-04-30 10:01:26.964
112	{title}	Trait	{title} Manage consent var et_link_options_data = [{"class":"et_pb_text_0_tb_header","url":"https:\\/\\/nufflezone.com\\/en\\/blood-bowl-team-roster-creator\\/","target":"_self"},{"class":"et_pb_text_1_tb_header","url":"https:\\/\\/nufflezone.com\\/en\\/blood-bowl-teams\\/","target":"_self"},{"class":"et_pb_text_2_tb_header","url":"https:\\/\\/nufflezone.com\\/en\\/blood-bowl-star-players\\/","target":"_self"},{"class":"et_pb_text_3_tb_header","url":"https:\\/\\/nufflezone.com\\/en\\/blood-bowl-skills-traits\\/","target":"_self"},{"class":"et_pb_text_4_tb_header","url":"https:\\/\\/nufflezone.com\\/en\\/naf-world-cup-malta-2027\\/","target":"_self"},{"class":"et_pb_text_5_tb_header","url":"https:\\/\\/nufflezone.com\\/creador-equipo-blood-bowl\\/","target":"_self"},{"class":"et_pb_text_6_tb_header","url":"https:\\/\\/nufflezone.com\\/en\\/blood-bowl-team-roster-creator\\/","target":"_self"},{"class":"et_pb_text_7_tb_header","url":"https:\\/\\/nufflezone.com\\/en\\/blood-bowl-teams\\/","target":"_self"},{"class":"et_pb_text_8_tb_header","url":"https:\\/\\/nufflezone.com\\/jugadores-estrella-blood-bowl\\/","target":"_self"},{"class":"et_pb_text_9_tb_header","url":"https:\\/\\/nufflezone.com\\/habilidades-blood-bowl\\/","target":"_self"}];	2026-04-30 10:01:32.193	2026-04-30 10:01:26.964
116	//# sourceURL=eztoc-scroll-scriptjs-js-extra	Trait	/* ]]> */ /* <![CDATA[ */ var ezTOC = {"smooth_scroll":"1","visibility_hide_by_default":"","scroll_offset":"30","fallbackIcon":"\\u003Cspan class=\\"\\"\\u003E\\u003Cspan class=\\"eztoc-hide\\" style=\\"display:none;\\"\\u003EToggle\\u003C/span\\u003E\\u003Cspan class=\\"ez-toc-icon-toggle-span\\"\\u003E\\u003Csvg style=\\"fill: #999;color:#999\\" xmlns=\\"http://www.w3.org/2000/svg\\" class=\\"list-377408\\" width=\\"20px\\" height=\\"20px\\" viewBox=\\"0 0 24 24\\" fill=\\"none\\"\\u003E\\u003Cpath d=\\"M6 6H4v2h2V6zm14 0H8v2h12V6zM4 11h2v2H4v-2zm16 0H8v2h12v-2zM4 16h2v2H4v-2zm16 0H8v2h12v-2z\\" fill=\\"currentColor\\"\\u003E\\u003C/path\\u003E\\u003C/svg\\u003E\\u003Csvg style=\\"fill: #999;color:#999\\" class=\\"arrow-unsorted-368013\\" xmlns=\\"http://www.w3.org/2000/svg\\" width=\\"10px\\" height=\\"10px\\" viewBox=\\"0 0 24 24\\" version=\\"1.2\\" baseProfile=\\"tiny\\"\\u003E\\u003Cpath d=\\"M18.2 9.3l-6.2-6.3-6.2 6.3c-.2.2-.3.4-.3.7s.1.5.3.7c.2.2.4.3.7.3h11c.3 0 .5-.1.7-.3.2-.2.3-.5.3-.7s-.1-.5-.3-.7zM5.8 14.7l6.2 6.3 6.2-6.3c.2-.2.3-.5.3-.7s-.1-.5-.3-.7c-.2-.2-.4-.3-.7-.3h-11c-.3 0-.5.1-.7.3-.2.2-.3.5-.3.7s.1.5.3.7z\\"/\\u003E\\u003C/svg\\u003E\\u003C/span\\u003E\\u003C/span\\u003E","chamomile_theme_is_on":""};	2026-04-30 10:01:32.375	2026-04-30 10:01:26.964
119	/* ]]> */	Trait	/* <![CDATA[ */ var complianz = {"prefix":"cmplz_","user_banner_id":"1","set_cookies":[],"block_ajax_content":"","banner_version":"41","version":"7.4.5","store_consent":"","do_not_track_enabled":"1","consenttype":"optin","region":"eu","geoip":"","dismiss_timeout":"","disable_cookiebanner":"","soft_cookiewall":"1","dismiss_on_scroll":"","cookie_expiry":"365","url":"https://nufflezone.com/wp-json/complianz/v1/","locale":"lang=en&locale=en_GB","set_cookies_on_root":"","cookie_domain":"","current_policy_id":"14","cookie_path":"/","categories":{"statistics":"statistics","marketing":"marketing"},"tcf_active":"","placeholdertext":"Click to accept {category} cookies and enable this content","css_file":"https://nufflezone.com/wp-content/uploads/complianz/css/banner-{banner_id}-{type}.css?v=41","page_links":{"eu":{"cookie-statement":{"title":"Politica de Cookies","url":"https://nufflezone.com/politica-de-cookies/"},"privacy-statement":{"title":"Pol\\u00edtica de privacidad","url":"https://nufflezone.com/politica-de-privacidad/"},"impressum":{"title":"Aviso Legal","url":"https://nufflezone.com/aviso-legal/"}},"us":{"impressum":{"title":"Aviso Legal","url":"https://nufflezone.com/aviso-legal/"}},"uk":{"impressum":{"title":"Aviso Legal","url":"https://nufflezone.com/aviso-legal/"}},"ca":{"impressum":{"title":"Aviso Legal","url":"https://nufflezone.com/aviso-legal/"}},"au":{"impressum":{"title":"Aviso Legal","url":"https://nufflezone.com/aviso-legal/"}},"za":{"impressum":{"title":"Aviso Legal","url":"https://nufflezone.com/aviso-legal/"}},"br":{"impressum":{"title":"Aviso Legal","url":"https://nufflezone.com/aviso-legal/"}}},"tm_categories":"1","forceEnableStats":"","preview":"","clean_cookies":"","aria_label":"Click to accept {category} cookies and enable this content"};	2026-04-30 10:01:32.504	2026-04-30 10:01:26.964
560	Arm Bar	Trait	Arm Bar	2026-04-30 10:01:44.988	2026-04-30 10:01:26.964
561	Iron-hard Skin	Trait	Iron-hard Skin	2026-04-30 10:01:52.868	2026-04-30 10:01:26.964
562	Breathe Fire	Trait	Breathe Fire	2026-04-30 10:01:53.486	2026-04-30 10:01:26.964
563	Animosity (all team-mates)	Trait	Animosity (all team-mates)	2026-04-30 10:01:59.341	2026-04-30 10:01:26.964
564	Hatred (Troll)	Trait	Hatred (Troll)	2026-04-30 10:02:20.717	2026-04-30 10:01:26.964
565	Break Tackle	Trait	Break Tackle	2026-04-30 10:02:21.167	2026-04-30 10:01:26.964
566	Dirty Player	Trait	Dirty Player	2026-04-30 10:02:21.373	2026-04-30 10:01:26.964
567	No Hands	Trait	No Hands	2026-04-30 10:02:22.086	2026-04-30 10:01:26.964
568	Dirty Player (+2)	Trait	Dirty Player (+2)	2026-04-30 10:02:25.02	2026-04-30 10:01:26.964
569	Loner (5+)	Trait	Loner (5+)	2026-04-30 10:02:25.39	2026-04-30 10:01:26.964
570	Timmm-ber!	Trait	Timmm-ber!	2026-04-30 10:02:33.33	2026-04-30 10:01:26.964
571	Dirty Player (+1)	Trait	Dirty Player (+1)	2026-04-30 10:02:47.37	2026-04-30 10:01:26.964
572	Running Pass	Trait	Running Pass	2026-04-30 10:03:08.71	2026-04-30 10:01:26.964
573	Plague Ridden	Trait	Plague Ridden	2026-04-30 10:03:34.108	2026-04-30 10:01:26.964
574	Plague Ridde	Trait	Plague Ridde	2026-04-30 10:03:34.557	2026-04-30 10:01:26.964
575	Animosity (Dwarf and Halfling Team-mates)	Trait	Animosity (Dwarf and Halfling Team-mates)	2026-04-30 10:03:53.199	2026-04-30 10:01:26.964
576	Animosity (Dwarf and Human Team-mates)	Trait	Animosity (Dwarf and Human Team-mates)	2026-04-30 10:03:58.061	2026-04-30 10:01:26.964
577	None	Trait	None	2026-04-30 10:04:01.316	2026-04-30 10:01:26.964
578	Animosity (Orc Linemen)	Trait	Animosity (Orc Linemen)	2026-04-30 10:04:04.824	2026-04-30 10:01:26.964
579	Animosity (Big Uns)	Trait	Animosity (Big Uns)	2026-04-30 10:04:06.122	2026-04-30 10:01:26.964
580	Swarming	Trait	Swarming	2026-04-30 10:04:21.758	2026-04-30 10:01:26.964
581	Animosity (Goblins)	Trait	Animosity (Goblins)	2026-04-30 10:04:40.05	2026-04-30 10:01:26.964
582	Blood Lust (2+)	Trait	Blood Lust (2+)	2026-04-30 10:04:49.761	2026-04-30 10:01:26.964
583	Hypnotic Gaze	Trait	Hypnotic Gaze	2026-04-30 10:04:49.966	2026-04-30 10:01:26.964
390	Throw Team Mate	Trait	Throw Team Mate	2026-04-30 09:55:41.13	2026-04-30 09:53:59.968
391	Kick Team Mate	Trait	Kick Team Mate	2026-04-30 09:55:41.586	2026-04-30 09:53:59.968
584	Blood Lust (3+)	Trait	Blood Lust (3+)	2026-04-30 10:04:50.589	2026-04-30 10:01:26.964
405	Always Hungry	Trait	Always Hungry	2026-04-30 09:56:37.11	2026-04-30 09:53:59.968
406	Loner (3+)	Trait	Loner (3+)	2026-04-30 09:56:37.312	2026-04-30 09:53:59.968
\.


--
-- Data for Name: Tournament; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Tournament" (id, name, edition, year, "startDate", description, status, format, "groupCount", "qualifiersPerGroup", "createdAt", "updatedAt") FROM stdin;
5	Torneo Dragón de entrenamiento	1	2026	2026-05-04 00:00:00	\N	ACTIVE	MIXED	2	2	2026-05-02 19:50:07.911	2026-05-03 22:41:33.815
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
e29f0602-266f-43ed-8f68-7bf11844bb75	3f17e60b09fdbeedfaf0184d32a516f888e6a5f2556f5f00ee11f27f38ec61f3	2026-04-30 09:43:40.953331+00	20260413152323_init	\N	\N	2026-04-30 09:43:40.598841+00	1
5c758b18-a1f6-4cd9-bbc8-999cbfba8c80	a5e0d99748f0b0e7a9a5671d01db3ba7b9215ebc53fa324e23007d7af8a87c34	2026-04-30 09:43:41.249548+00	20260413194139_add_team_sheet_fields	\N	\N	2026-04-30 09:43:41.037121+00	1
664d20e5-7aca-4752-9c05-127eda306f3f	f388c67dac7c8c8cdde4c242ce4c5a40be19ac4f5e438c3653998d6ecdf31cf5	2026-04-30 09:43:41.543456+00	20260413204839_add_race_image_url	\N	\N	2026-04-30 09:43:41.333636+00	1
297da4e6-af3a-4d64-80e6-d47fd577c92b	f4719cac28a5b2377806aa4760c12ef583a3e3d45b795beb98521b73172772ca	2026-04-30 09:43:41.838808+00	20260413210419_remove_player_alias_email_phone	\N	\N	2026-04-30 09:43:41.627256+00	1
a4471d33-9d4a-4eee-897d-d0f2051c7850	c2ec924bde813345d49f8a4fea2d5f07cff36b83fc546c5d320a976436505fa0	2026-04-30 09:43:59.288215+00	20260430094358_ligabloodbowl	\N	\N	2026-04-30 09:43:59.056432+00	1
565ad743-54b3-4143-bb8d-1c67a2b03839	99fcbecd38e9e4e53184b4e75a8e5f42a2026296956acad6880e3f0ae2825f1e	2026-05-01 21:51:31.651952+00	20260501000000_add_player_name_unique	\N	\N	2026-05-01 21:51:31.377106+00	1
59307284-baf5-4493-b345-efbf1186d76c	b295cd49e534aa9ab09220a3b96a1a14106e2bd3065e04fe2dc24209fbd10fc1	2026-05-04 10:06:18.691431+00	20260504100618_remove_position_max_count	\N	\N	2026-05-04 10:06:18.480187+00	1
1d52880f-3380-482c-8a8f-866a2d3f13e3	e609994e55d27dcb7e2be7d3727d275d6235345aa81f55d9aee626a76a671f83	2026-05-05 18:59:12.723068+00	20260505120000_add_roster_attribute_upgrades	\N	\N	2026-05-05 18:59:12.212994+00	1
a2fabd95-29d4-4663-9184-0cc0da25cf50	b4157a6dfb2a4e637c303bb19d28b0e9a0d6074974643a8ee9e7c7ce185c898b	2026-05-05 19:44:25.034448+00	20260505140000_add_cheerleaders_assistant_coaches		\N	2026-05-05 19:44:25.034448+00	0
9c23f310-efc2-4321-aee6-dc2cacf30107	5a1a2d70f0b8592873be05e1e4d1cd81f568843a6d044bb209da0c20919ecb0e	2026-05-05 19:44:31.792809+00	20260505150000_add_fan_factor		\N	2026-05-05 19:44:31.792809+00	0
c7439ba2-261c-4948-aa4a-0ba0165deb3b	bd64c98886f1e927bfc79476f373b436a6c1c4bd38c6079b96dd10afb5e32d1e	2026-05-05 19:44:38.531011+00	20260505160000_add_treasury_and_match_gold		\N	2026-05-05 19:44:38.531011+00	0
04ef527b-ca93-4d7a-9b3d-c175cd3db47d	06d27a1965b8eeae623aac431a829bc6cdcbe751971dc1973b0334f64bd8c0b7	2026-05-05 20:03:02.056674+00	20260505170000_replace_injuries_with_injured_boolean		\N	2026-05-05 20:03:02.056674+00	0
\.


--
-- Name: Match_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public."Match_id_seq"', 39, true);


--
-- Name: Participant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public."Participant_id_seq"', 25, true);


--
-- Name: Player_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public."Player_id_seq"', 25, true);


--
-- Name: Position_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public."Position_id_seq"', 645, true);


--
-- Name: Race_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public."Race_id_seq"', 198, true);


--
-- Name: RosterEntry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public."RosterEntry_id_seq"', 260, true);


--
-- Name: RosterHistory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public."RosterHistory_id_seq"', 33, true);


--
-- Name: Round_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public."Round_id_seq"', 19, true);


--
-- Name: Skill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public."Skill_id_seq"', 584, true);


--
-- Name: Tournament_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public."Tournament_id_seq"', 5, true);


--
-- Name: Match Match_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Match"
    ADD CONSTRAINT "Match_pkey" PRIMARY KEY (id);


--
-- Name: Participant Participant_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Participant"
    ADD CONSTRAINT "Participant_pkey" PRIMARY KEY (id);


--
-- Name: Player Player_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Player"
    ADD CONSTRAINT "Player_pkey" PRIMARY KEY (id);


--
-- Name: PositionSkill PositionSkill_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."PositionSkill"
    ADD CONSTRAINT "PositionSkill_pkey" PRIMARY KEY ("positionId", "skillId");


--
-- Name: Position Position_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Position"
    ADD CONSTRAINT "Position_pkey" PRIMARY KEY (id);


--
-- Name: Race Race_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Race"
    ADD CONSTRAINT "Race_pkey" PRIMARY KEY (id);


--
-- Name: RosterEntrySkill RosterEntrySkill_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."RosterEntrySkill"
    ADD CONSTRAINT "RosterEntrySkill_pkey" PRIMARY KEY ("rosterEntryId", "skillId");


--
-- Name: RosterEntry RosterEntry_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."RosterEntry"
    ADD CONSTRAINT "RosterEntry_pkey" PRIMARY KEY (id);


--
-- Name: RosterHistory RosterHistory_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."RosterHistory"
    ADD CONSTRAINT "RosterHistory_pkey" PRIMARY KEY (id);


--
-- Name: Round Round_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Round"
    ADD CONSTRAINT "Round_pkey" PRIMARY KEY (id);


--
-- Name: Skill Skill_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Skill"
    ADD CONSTRAINT "Skill_pkey" PRIMARY KEY (id);


--
-- Name: Tournament Tournament_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Tournament"
    ADD CONSTRAINT "Tournament_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: Participant_playerId_tournamentId_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX IF NOT EXISTS "Participant_playerId_tournamentId_key" ON public."Participant" USING btree ("playerId", "tournamentId");


--
-- Name: Player_name_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX IF NOT EXISTS "Player_name_key" ON public."Player" USING btree (name);


--
-- Name: Race_name_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX IF NOT EXISTS "Race_name_key" ON public."Race" USING btree (name);


--
-- Name: Skill_name_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX IF NOT EXISTS "Skill_name_key" ON public."Skill" USING btree (name);


--
-- Name: Tournament_name_year_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX IF NOT EXISTS "Tournament_name_year_key" ON public."Tournament" USING btree (name, year);


--
-- Name: Match Match_awayParticipantId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Match"
    ADD CONSTRAINT "Match_awayParticipantId_fkey" FOREIGN KEY ("awayParticipantId") REFERENCES public."Participant"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Match Match_homeParticipantId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Match"
    ADD CONSTRAINT "Match_homeParticipantId_fkey" FOREIGN KEY ("homeParticipantId") REFERENCES public."Participant"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Match Match_roundId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Match"
    ADD CONSTRAINT "Match_roundId_fkey" FOREIGN KEY ("roundId") REFERENCES public."Round"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Participant Participant_playerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Participant"
    ADD CONSTRAINT "Participant_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES public."Player"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Participant Participant_raceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Participant"
    ADD CONSTRAINT "Participant_raceId_fkey" FOREIGN KEY ("raceId") REFERENCES public."Race"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Participant Participant_tournamentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Participant"
    ADD CONSTRAINT "Participant_tournamentId_fkey" FOREIGN KEY ("tournamentId") REFERENCES public."Tournament"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: PositionSkill PositionSkill_positionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."PositionSkill"
    ADD CONSTRAINT "PositionSkill_positionId_fkey" FOREIGN KEY ("positionId") REFERENCES public."Position"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: PositionSkill PositionSkill_skillId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."PositionSkill"
    ADD CONSTRAINT "PositionSkill_skillId_fkey" FOREIGN KEY ("skillId") REFERENCES public."Skill"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Position Position_raceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Position"
    ADD CONSTRAINT "Position_raceId_fkey" FOREIGN KEY ("raceId") REFERENCES public."Race"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: RosterEntrySkill RosterEntrySkill_rosterEntryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."RosterEntrySkill"
    ADD CONSTRAINT "RosterEntrySkill_rosterEntryId_fkey" FOREIGN KEY ("rosterEntryId") REFERENCES public."RosterEntry"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: RosterEntrySkill RosterEntrySkill_skillId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."RosterEntrySkill"
    ADD CONSTRAINT "RosterEntrySkill_skillId_fkey" FOREIGN KEY ("skillId") REFERENCES public."Skill"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: RosterEntry RosterEntry_participantId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."RosterEntry"
    ADD CONSTRAINT "RosterEntry_participantId_fkey" FOREIGN KEY ("participantId") REFERENCES public."Participant"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: RosterEntry RosterEntry_positionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."RosterEntry"
    ADD CONSTRAINT "RosterEntry_positionId_fkey" FOREIGN KEY ("positionId") REFERENCES public."Position"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: RosterHistory RosterHistory_participantId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."RosterHistory"
    ADD CONSTRAINT "RosterHistory_participantId_fkey" FOREIGN KEY ("participantId") REFERENCES public."Participant"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Round Round_tournamentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Round"
    ADD CONSTRAINT "Round_tournamentId_fkey" FOREIGN KEY ("tournamentId") REFERENCES public."Tournament"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO neon_superuser WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON TABLES TO neon_superuser WITH GRANT OPTION;


--
-- PostgreSQL database dump complete
--

\unrestrict HyjobFg4neqEfCIpQIf7eoIk7w0SMVAaZTyQGHreYlgSr3bEeiWDtaLpqfKUNgh

