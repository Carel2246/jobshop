--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

-- Started on 2025-03-18 21:42:31

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 226 (class 1259 OID 16692)
-- Name: calendar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.calendar (
    id integer NOT NULL,
    weekday integer NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL
);


ALTER TABLE public.calendar OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16691)
-- Name: calendar_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.calendar_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.calendar_id_seq OWNER TO postgres;

--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 225
-- Name: calendar_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.calendar_id_seq OWNED BY public.calendar.id;


--
-- TOC entry 222 (class 1259 OID 16671)
-- Name: job; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job (
    id integer NOT NULL,
    job_number character varying(50) NOT NULL,
    description character varying(255),
    order_date timestamp without time zone NOT NULL,
    promised_date timestamp without time zone NOT NULL,
    quantity integer NOT NULL,
    price_each double precision NOT NULL,
    customer character varying(100),
    completed boolean DEFAULT false NOT NULL,
    blocked boolean DEFAULT false NOT NULL
);


ALTER TABLE public.job OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16670)
-- Name: job_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.job_id_seq OWNER TO postgres;

--
-- TOC entry 4971 (class 0 OID 0)
-- Dependencies: 221
-- Name: job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.job_id_seq OWNED BY public.job.id;


--
-- TOC entry 233 (class 1259 OID 16745)
-- Name: material; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.material (
    id integer NOT NULL,
    job_number character varying(50) NOT NULL,
    description character varying(255) NOT NULL,
    quantity double precision NOT NULL,
    unit character varying(50) NOT NULL
);


ALTER TABLE public.material OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16744)
-- Name: material_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.material_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.material_id_seq OWNER TO postgres;

--
-- TOC entry 4972 (class 0 OID 0)
-- Dependencies: 232
-- Name: material_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.material_id_seq OWNED BY public.material.id;


--
-- TOC entry 218 (class 1259 OID 16653)
-- Name: resource; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    type character varying(1) NOT NULL
);


ALTER TABLE public.resource OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16662)
-- Name: resource_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_group (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    type character varying(1) NOT NULL
);


ALTER TABLE public.resource_group OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16700)
-- Name: resource_group_association; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_group_association (
    resource_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.resource_group_association OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16661)
-- Name: resource_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.resource_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resource_group_id_seq OWNER TO postgres;

--
-- TOC entry 4973 (class 0 OID 0)
-- Dependencies: 219
-- Name: resource_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.resource_group_id_seq OWNED BY public.resource_group.id;


--
-- TOC entry 217 (class 1259 OID 16652)
-- Name: resource_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.resource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resource_id_seq OWNER TO postgres;

--
-- TOC entry 4974 (class 0 OID 0)
-- Dependencies: 217
-- Name: resource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.resource_id_seq OWNED BY public.resource.id;


--
-- TOC entry 231 (class 1259 OID 16733)
-- Name: schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schedule (
    id integer NOT NULL,
    task_number character varying(50) NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    resources_used character varying(255) NOT NULL
);


ALTER TABLE public.schedule OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16732)
-- Name: schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.schedule_id_seq OWNER TO postgres;

--
-- TOC entry 4975 (class 0 OID 0)
-- Dependencies: 230
-- Name: schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.schedule_id_seq OWNED BY public.schedule.id;


--
-- TOC entry 229 (class 1259 OID 16716)
-- Name: task; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task (
    id integer NOT NULL,
    task_number character varying(50) NOT NULL,
    job_number character varying(50) NOT NULL,
    description character varying(255),
    setup_time double precision NOT NULL,
    time_each double precision NOT NULL,
    predecessors character varying(255),
    resources character varying(255) NOT NULL,
    completed boolean DEFAULT false NOT NULL
);


ALTER TABLE public.task OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16715)
-- Name: task_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.task_id_seq OWNER TO postgres;

--
-- TOC entry 4976 (class 0 OID 0)
-- Dependencies: 228
-- Name: task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.task_id_seq OWNED BY public.task.id;


--
-- TOC entry 224 (class 1259 OID 16682)
-- Name: template; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.template (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(255),
    price_each real DEFAULT 0
);


ALTER TABLE public.template OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16681)
-- Name: template_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.template_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.template_id_seq OWNER TO postgres;

--
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 223
-- Name: template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.template_id_seq OWNED BY public.template.id;


--
-- TOC entry 237 (class 1259 OID 16771)
-- Name: template_material; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.template_material (
    id integer NOT NULL,
    template_id integer NOT NULL,
    description character varying(255) NOT NULL,
    quantity double precision NOT NULL,
    unit character varying(50) NOT NULL
);


ALTER TABLE public.template_material OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16770)
-- Name: template_material_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.template_material_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.template_material_id_seq OWNER TO postgres;

--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 236
-- Name: template_material_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.template_material_id_seq OWNED BY public.template_material.id;


--
-- TOC entry 235 (class 1259 OID 16757)
-- Name: template_task; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.template_task (
    id integer NOT NULL,
    template_id integer NOT NULL,
    task_number character varying(50) NOT NULL,
    description character varying(255),
    setup_time integer NOT NULL,
    time_each integer NOT NULL,
    predecessors character varying(255),
    resources character varying(255) NOT NULL
);


ALTER TABLE public.template_task OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16756)
-- Name: template_task_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.template_task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.template_task_id_seq OWNER TO postgres;

--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 234
-- Name: template_task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.template_task_id_seq OWNED BY public.template_task.id;


--
-- TOC entry 4751 (class 2604 OID 16695)
-- Name: calendar id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calendar ALTER COLUMN id SET DEFAULT nextval('public.calendar_id_seq'::regclass);


--
-- TOC entry 4746 (class 2604 OID 16674)
-- Name: job id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job ALTER COLUMN id SET DEFAULT nextval('public.job_id_seq'::regclass);


--
-- TOC entry 4755 (class 2604 OID 16748)
-- Name: material id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material ALTER COLUMN id SET DEFAULT nextval('public.material_id_seq'::regclass);


--
-- TOC entry 4744 (class 2604 OID 16656)
-- Name: resource id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource ALTER COLUMN id SET DEFAULT nextval('public.resource_id_seq'::regclass);


--
-- TOC entry 4745 (class 2604 OID 16665)
-- Name: resource_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_group ALTER COLUMN id SET DEFAULT nextval('public.resource_group_id_seq'::regclass);


--
-- TOC entry 4754 (class 2604 OID 16736)
-- Name: schedule id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule ALTER COLUMN id SET DEFAULT nextval('public.schedule_id_seq'::regclass);


--
-- TOC entry 4752 (class 2604 OID 16719)
-- Name: task id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task ALTER COLUMN id SET DEFAULT nextval('public.task_id_seq'::regclass);


--
-- TOC entry 4749 (class 2604 OID 16685)
-- Name: template id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.template ALTER COLUMN id SET DEFAULT nextval('public.template_id_seq'::regclass);


--
-- TOC entry 4757 (class 2604 OID 16774)
-- Name: template_material id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.template_material ALTER COLUMN id SET DEFAULT nextval('public.template_material_id_seq'::regclass);


--
-- TOC entry 4756 (class 2604 OID 16760)
-- Name: template_task id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.template_task ALTER COLUMN id SET DEFAULT nextval('public.template_task_id_seq'::regclass);


--
-- TOC entry 4953 (class 0 OID 16692)
-- Dependencies: 226
-- Data for Name: calendar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.calendar (id, weekday, start_time, end_time) FROM stdin;
1	0	07:00:00	16:00:00
2	1	07:00:00	16:00:00
3	2	07:00:00	16:00:00
4	3	07:00:00	16:00:00
5	4	07:00:00	13:00:00
6	5	00:00:00	00:00:00
7	6	00:00:00	00:00:00
\.


--
-- TOC entry 4949 (class 0 OID 16671)
-- Dependencies: 222
-- Data for Name: job; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job (id, job_number, description, order_date, promised_date, quantity, price_each, customer, completed, blocked) FROM stdin;
1	24330	FIXED RAMP	2025-01-14 22:21:00	2025-03-14 09:30:00	1	141730	FRANS DU TOIT	t	f
2	24356	J800	2025-02-03 08:00:00	2025-03-10 10:00:00	1	19337	PRO PROCESS	f	t
3	24366	LARGE GATE	2025-02-14 08:00:00	2025-03-12 10:00:00	6	3691	PFG	t	f
4	24367	Small Gate	2025-02-14 08:00:00	2025-03-12 10:00:00	4	3089	PFG	f	t
5	24369	Anderson A-raam	2025-02-14 08:00:00	2025-03-12 10:00:00	4	9624.35	PFG	f	f
6	24368	Anderson Fronts	2025-02-14 08:00:00	2025-03-12 10:00:00	8	1873	PFG	t	f
7	24370	IDC A-raam	2025-02-14 08:00:00	2025-03-12 10:00:00	4	9624.35	PFG	f	f
8	24371	IDC Fronts	2025-02-14 08:00:00	2025-03-12 10:00:00	8	1873	PFG	t	f
9	24385	Cantilver Raam	2025-02-20 08:00:00	2025-03-06 10:00:00	3	3780	Rackstar	t	f
10	24386	Carbide Bins	2025-02-21 08:00:00	2025-03-10 09:00:00	10	3473	Element 6	t	f
11	24388	Safety Cage	2025-02-27 08:00:00	2025-03-13 10:00:00	1	19430	ARROW	t	f
12	24389	MLR10	2025-03-03 08:00:00	2025-03-17 10:00:00	1	204069	EVEREST STEEL	f	f
13	24392	Cullet Bins	2025-03-01 08:00:00	2025-03-20 10:00:00	3	27120	PFG	t	f
14	24393	Slider Flex Bracket (prototipe)	2025-03-01 08:00:00	2025-03-06 09:00:00	1	733	PFG	t	f
15	24397&8	Tafelblad 1670x650	2025-03-05 07:00:00	2025-03-11 19:38:00	2	1415	Rackstar	t	f
16	25001	880 GRAB	2025-03-06 19:41:00	2025-03-12 17:00:00	1	16127.19	PFG	f	f
17	25002	Skudmasjien oordoen	2025-03-10 14:37:00	2025-04-07 14:37:00	1	0	ALTYDBO	f	f
18	25003	Nuwe Skudmasjien	2025-03-10 15:03:00	2025-04-14 15:03:00	1	0	ALTYDBO	f	t
19	25004	Grab wassers (3mm)	2025-03-11 15:09:00	2025-03-18 15:09:00	30	19.73	PFG	f	f
20	25005	Grab wassers (4.5mm)	2025-03-11 15:32:00	2025-03-18 15:32:00	30	23	PFG	f	f
21	25006	Grab wassers (6mm)	2025-03-11 15:33:00	2025-03-18 15:33:00	30	27.3	PFG	f	f
22	25007	Hek Stoppers	2025-03-12 15:54:00	2025-03-20 15:54:00	3	0	NIGEL METAL	f	f
23	25008	Drupplate (2450 seksie)	2025-03-12 16:14:00	2025-03-18 16:15:00	94	0	Estellae	f	f
24	25009	Cantilver Raam (modifikasie)	2025-03-12 16:36:00	2025-03-13 16:37:00	1	3430	Rackstar	f	f
25	25010	Handrail Brackets	2025-03-13 16:38:00	2025-03-21 16:38:00	6	47	Caldas	f	f
26	25011	Rear Handrail	2025-03-13 17:23:00	2025-03-21 17:23:00	2	2373	Caldas	f	f
27	25012	Tarp Protector Bend Refurb	2025-03-14 17:31:00	2025-03-21 17:31:00	5	197	PFG	f	f
28	25013	Tarp Protector Spring Replacement	2025-03-14 17:34:00	2025-03-21 17:34:00	5	78.7	PFG	f	f
29	25014	A-frame refurb	2025-03-14 17:41:00	2025-03-21 17:41:00	4	973	PFG	f	f
30	25015	Tarp Prot Straight Refurb	2025-03-14 17:56:00	2025-03-21 17:56:00	2	178	PFG	f	f
31	25016	880 Grab Refurbish	2025-03-14 18:18:00	2025-03-21 18:18:00	1	6505	PFG	f	f
32	25017	Step Ramp Huur	2025-03-17 18:19:00	2025-03-18 18:19:00	1	1575	Tamarin Bay Traders	f	f
33	25018	IPE Boog	2025-03-17 18:46:00	2025-03-20 18:46:00	1	0	Estellae	f	f
\.


--
-- TOC entry 4960 (class 0 OID 16745)
-- Dependencies: 233
-- Data for Name: material; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.material (id, job_number, description, quantity, unit) FROM stdin;
3	25005	4.5mm Plaat	0.1	2500x1200
4	25007	3mm / 4.5mm / 6mm	3	off-cut soos nodig
6	25010	6mm Plaat	0.1	2500x1200
7	25011	4.5mm Plaat	0.25	2500x1200
8	25011	42.9x2.5 Rount Tube	4	6m lengte
9	25013	Veer	5	elk
10	25013	M10 spring washer	5	elk
11	25013	10mm Rond	250	mm
12	25006	6mm Plaat	0.1	2500x1200
13	25008	1mm Galv Plaat	14	2450
16	25004	3mm Plaat	0.1	2450x1225
\.


--
-- TOC entry 4945 (class 0 OID 16653)
-- Dependencies: 218
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource (id, name, type) FROM stdin;
1	Andrew	H
2	Gert	H
3	James	H
4	Dean	H
5	Fernando	H
6	Ruan	H
7	Pieter	H
8	Quinton	H
9	Thys	H
10	Vince	H
11	Wikus	H
12	Boor1	M
13	Boor2	M
14	Cincinatti	M
15	Cupgun	M
16	Groot_guillotine	M
17	Hamburger	M
18	Klein_buig	M
19	Klein_guillotine	M
20	Magboor	M
21	Promecam	M
22	Saag1	M
23	Saag2	M
25	Verflyn	M
\.


--
-- TOC entry 4947 (class 0 OID 16662)
-- Dependencies: 220
-- Data for Name: resource_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_group (id, name, type) FROM stdin;
1	Sweis	H
2	Handlanger	H
3	Verf	H
4	Saag	M
5	HSaag	H
6	Grind	H
7	Boor	M
8	HBoor	H
\.


--
-- TOC entry 4954 (class 0 OID 16700)
-- Dependencies: 227
-- Data for Name: resource_group_association; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_group_association (resource_id, group_id) FROM stdin;
1	1
2	1
3	1
1	2
4	2
5	2
3	2
7	2
8	2
6	2
9	2
10	2
7	3
8	3
22	4
23	4
1	5
2	5
3	5
9	5
10	5
11	5
4	6
5	6
3	6
7	6
8	6
6	6
9	6
10	6
12	7
13	7
2	8
3	8
10	8
11	8
\.


--
-- TOC entry 4958 (class 0 OID 16733)
-- Dependencies: 231
-- Data for Name: schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schedule (id, task_number, start_time, end_time, resources_used) FROM stdin;
109	24369-200	2025-03-19 07:00:00	2025-03-19 07:41:00	Wikus, Dean
110	24369-300	2025-03-19 07:41:00	2025-03-19 11:52:00	Andrew, Andrew
111	24369-400	2025-03-19 09:42:00	2025-03-19 14:54:00	Vince, Fernando, Dean
112	24369-500	2025-03-24 07:00:00	2025-03-24 15:08:00	Pieter, Quinton
113	24369-600	2025-03-25 07:00:00	2025-03-25 08:30:00	Quinton
114	24370-20	2025-03-18 07:00:00	2025-03-18 15:16:00	Saag1, Vince
115	24370-200	2025-03-19 07:41:00	2025-03-19 12:01:00	Wikus, Pieter
116	24370-300	2025-03-20 07:00:00	2025-03-20 07:12:00	Gert, Andrew
117	24370-400	2025-03-20 07:00:00	2025-03-20 10:14:00	Vince, Fernando, Dean
118	24370-500	2025-03-21 07:00:00	2025-03-21 09:48:00	Pieter, Quinton
119	24370-600	2025-03-21 07:00:00	2025-03-21 12:10:00	Quinton
120	24389-600	2025-03-19 07:00:00	2025-03-19 14:21:00	Quinton
121	25001-10	2025-03-20 07:00:00	2025-03-20 14:32:00	Quinton
122	25001-11	2025-03-20 07:00:00	2025-03-20 15:39:00	Quinton, Pieter
123	25002-3	2025-03-25 07:00:00	2025-03-25 07:48:00	Wikus, Dean
124	25002-4	2025-03-25 07:00:00	2025-03-25 12:50:00	Pieter
125	25002-5	2025-03-25 07:00:00	2025-03-25 15:52:00	Wikus, James
126	25004-3	2025-03-18 07:00:00	2025-03-18 15:02:00	Pieter
127	25005-3	2025-03-24 07:00:00	2025-03-24 09:14:00	Quinton
128	25007-1	2025-03-19 07:00:00	2025-03-19 07:31:00	Gert
129	25007-2	2025-03-19 08:16:00	2025-03-19 11:41:00	Gert, Fernando
130	25010-1	2025-03-19 07:00:00	2025-03-19 07:04:00	Gert
131	25010-3	2025-03-19 07:00:00	2025-03-19 07:55:00	Gert
132	25010-4	2025-03-19 07:00:00	2025-03-19 08:16:00	Pieter
133	25011-1	2025-03-20 07:00:00	2025-03-20 11:58:00	Saag1, James
134	25011-2	2025-03-18 07:00:00	2025-03-18 14:46:00	Gert
135	25011-3	2025-03-19 07:13:00	2025-03-19 09:06:00	Gert, Pieter
136	25011-4	2025-03-25 07:00:00	2025-03-25 10:01:00	Gert, Quinton
137	25011-5	2025-03-25 07:00:00	2025-03-25 11:02:00	Andrew
138	25011-6	2025-03-26 07:00:00	2025-03-26 07:14:00	Quinton
139	25011-7	2025-03-26 07:00:00	2025-03-26 08:10:00	Pieter, Quinton
140	25012-1	2025-03-19 10:25:00	2025-03-19 15:30:00	Wikus
141	25012-2	2025-03-19 07:41:00	2025-03-19 10:26:00	Gert, Dean
142	25013-1	2025-03-18 14:46:00	2025-03-18 15:27:00	Gert
143	25013-2	2025-03-19 07:00:00	2025-03-19 08:29:00	Gert
144	25013-3	2025-03-25 07:00:00	2025-03-25 11:22:00	Quinton
145	25014-1	2025-03-19 10:00:00	2025-03-19 14:54:00	Wikus
146	25014-2	2025-03-20 07:00:00	2025-03-20 09:46:00	James
147	25014-3	2025-03-20 07:00:00	2025-03-20 13:12:00	Pieter
148	25015-1	2025-03-19 09:51:00	2025-03-19 14:20:00	Wikus
149	25015-2	2025-03-20 07:00:00	2025-03-20 12:26:00	James
150	25015-3	2025-03-21 07:00:00	2025-03-21 11:24:00	Pieter
151	25016-1	2025-03-19 07:00:00	2025-03-19 07:08:00	Pieter
152	25016-2	2025-03-19 10:36:00	2025-03-19 15:52:00	Wikus
153	25016-3	2025-03-20 07:00:00	2025-03-20 10:23:00	Gert, Andrew
154	25016-4	2025-03-20 07:00:00	2025-03-20 12:19:00	Andrew
155	25016-5	2025-03-25 07:00:00	2025-03-25 13:23:00	Pieter, Quinton
156	25017-1	2025-03-24 07:00:00	2025-03-24 07:57:00	Pieter, Quinton
157	25018-1	2025-03-19 07:00:00	2025-03-19 07:21:00	Saag1, James
158	25018-2	2025-03-19 07:00:00	2025-03-19 12:11:00	James
159	25002-2	2025-03-24 07:00:00	2025-03-24 11:46:00	Quinton, Pieter
160	25007-3	2025-03-25 07:00:00	2025-03-25 15:13:00	Pieter, Quinton
161	25010-2	2025-03-19 07:00:00	2025-03-19 07:28:00	Fernando
162	25006-3	2025-03-21 07:00:00	2025-03-21 07:56:00	Pieter, Quinton
\.


--
-- TOC entry 4956 (class 0 OID 16716)
-- Dependencies: 229
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task (id, task_number, job_number, description, setup_time, time_each, predecessors, resources, completed) FROM stdin;
1	24330-500	24330	Verf	1	180	nan	Pieter, Quinton	t
2	24356-10	24356	Sny kante	10	20	nan	Gert	f
3	24356-20	24356	Sny body	10	10	nan	Gert	f
4	24356-50	24356	Buig body	15	10	24356-20	Gert, Andrew, Handlanger	f
5	24356-60	24356	Sny en buig channels	5	15	nan	Gert	f
6	24356-70	24356	Sny 10mm parte	5	10	nan	Gert	f
7	24356-80	24356	Buig en boor spore	10	30	24356-70	Wikus	f
8	24356-100	24356	Bou body	10	40	24356-10, 24356-50, 24356-60	Gert, Handlanger	f
9	24356-110	24356	Sweis body	1	45	24356-100	Sweis	f
10	24356-120	24356	Grind body	1	30	24356-110	Grind	f
11	24356-200	24356	Sny pockets	5	10	nan	Gert	f
12	24356-210	24356	Buig pockets	10	2	24356-200	Gert, Handlanger	f
13	24356-220	24356	Saag bullets	1	5	nan	Saag, HSaag	f
14	24356-230	24356	Draai bullets	10	20	24356-220	Quinton	f
15	24356-250	24356	Bou pockets	1	15	24356-210, 24356-230	Gert	f
16	24356-260	24356	Sweis pockets	1	25	24356-250	Sweis	f
17	24356-270	24356	Grind pockets	1	15	24356-260	Grind	f
18	24356-300	24356	Bou bin	10	45	24356-120, 24356-270	Wikus, Handlanger	f
19	24356-310	24356	Sweis bin	1	60	24356-300	Sweis	f
20	24356-400	24356	Grind bin	1	30	24356-310	Grind	f
21	24356-500	24356	Verf bin	1	120	24356-400	Pieter	f
22	24366-10	24366	Saag tubing	5	5	nan	Saag, HSaag	t
23	24366-20	24366	Saag round bars	1	2	nan	Saag, HSaag	t
24	24366-30	24366	Sny end caps en gussets	5	1	nan	Groot_guillotine, Andrew	t
25	24366-100	24366	Boor tubing	5	8	24366-10	Boor, HBoor	t
26	24366-200	24366	Bou hekkie	10	30	24366-20, 24366-30, 24366-100	Wikus, Handlanger	t
27	24366-300	24366	Sweis hekkie	1	30	24366-200	Sweis	t
28	24366-400	24366	Grind hekkie	1	30	24366-300	Grind	t
29	24366-500	24366	Verf hekkie	1	10	24366-400	Verf	t
30	24366-600	24366	Plak rubber	1	10	24366-500	Quinton	t
31	24367-10	24367	Saag tubing	5	5	nan	Saag, HSaag	f
32	24367-20	24367	Saag round bars	1	2	nan	Saag, HSaag	t
33	24367-30	24367	Sny end caps en gussets	5	1	nan	Groot_guillotine, Andrew	t
34	24367-100	24367	Boor tubing	5	8	24367-10	Boor, HBoor	f
35	24367-200	24367	Bou hekkie	10	30	24367-20, 24367-30, 24367-100	Wikus, Handlanger	f
36	24367-300	24367	Sweis hekkie	1	30	24367-200	Sweis	f
37	24367-400	24367	Grind hekkie	1	30	24367-300	Grind	f
38	24367-500	24367	Verf hekkie	1	10	24367-400	Verf	f
39	24367-600	24367	Plak rubber	1	10	24367-500	Quinton	f
40	24368-10	24368	Saag tubing	5	2	nan	Saag, HSaag	t
41	24368-20	24368	Saag pypies	5	5	nan	Saag, HSaag	t
42	24368-30	24368	Sny plaatparte	5	5	nan	Gert	t
43	24368-100	24368	Bou front	10	5	24368-10, 24368-20, 24368-30	Wikus	t
44	24368-200	24368	Sweis front	1	20	24368-100	Sweis	t
45	24368-300	24368	Grind front	1	10	24368-200	Grind	t
46	24368-400	24368	Verf front	1	10	24368-300	Verf	t
47	24368-500	24368	Plak rubber	1	3	24368-400	Quinton	t
48	24371-10	24371	Saag tubing	5	2	nan	Saag, HSaag	t
49	24371-20	24371	Saag pypies	5	5	nan	Saag, HSaag	t
50	24371-30	24371	Sny plaatparte	5	5	nan	Gert	t
51	24371-100	24371	Bou front	10	5	24371-10, 24371-20, 24371-30	Wikus	t
52	24371-200	24371	Sweis front	1	20	24371-100	Sweis	t
53	24371-300	24371	Grind front	1	10	24371-200	Grind	t
54	24371-400	24371	Verf front	1	10	24371-300	Verf	t
55	24371-500	24371	Plak rubber	1	3	24371-400	Quinton	t
56	24369-10	24369	Saag channels	5	5	nan	Saag, HSaag	t
57	24369-20	24369	Saag tubing	5	10	nan	Saag, HSaag	t
58	24369-30	24369	Sny plaatparte	5	5	nan	Gert	t
59	24369-40	24369	Saag pyp	1	2	nan	Saag, HSaag	t
60	24369-110	24369	Plasma channels	5	8	24369-10	Wikus, Handlanger	t
61	24369-120	24369	Buig plaatparte	10	2	24369-30	Gert, Handlanger	t
62	24369-200	24369	Bou in jig	10	30	24369-20, 24369-40, 24369-110, 24369-120	Wikus, Handlanger	f
63	24369-300	24369	Sweis A-raam	1	30	24369-200	Sweis, Andrew	f
64	24369-400	24369	Grind A-raam	1	15	24369-300	Grind, Fernando, Dean	f
65	24369-500	24369	Verf A-raam	1	20	24369-400	Pieter, Quinton	f
66	24369-600	24369	Plak rubber	1	15	24369-500	Quinton	f
69	24370-30	24370	Sny plaatparte	5	5	nan	Gert	t
71	24370-110	24370	Plasma channels	5	8	24370-10	Wikus, Handlanger	t
73	24370-200	24370	Bou in jig	10	30	24370-20, 24370-40, 24370-110, 24370-120	Wikus, Handlanger	f
74	24370-300	24370	Sweis A-raam	1	30	24370-200	Sweis, Andrew	f
75	24370-400	24370	Grind A-raam	1	15	24370-300	Grind, Fernando, Dean	f
76	24370-500	24370	Verf A-raam	1	20	24370-400	Pieter, Quinton	f
77	24370-600	24370	Plak rubber	1	15	24370-500	Quinton	f
78	24385-10	24385	Saag tubing	10	30	nan	Saag, HSaag	t
79	24385-20	24385	Sny plaatparte	5	15	nan	Gert	t
80	24385-100	24385	Bou raam	45	15	24385-10, 24385-20	Wikus, Handlanger	t
81	24385-200	24385	Sweis raam	1	30	24385-100	Sweis	t
82	24385-300	24385	Grind raam	1	15	24385-200	Grind	t
83	24385-400	24385	Verf raam	1	30	24385-300	Verf	t
84	24386-10	24386	Sny plaatparte	5	15	nan	Groot_guillotine, Gert, Handlanger	t
85	24386-20	24386	Corrugate parte	10	10	24386-10	Gert, Andrew, Handlanger	t
86	24386-30	24386	Buig parte	15	10	24386-20	Gert, Andrew, Handlanger	t
87	24386-100	24386	Saag bene	5	5	nan	Saag, HSaag	t
88	24386-200	24386	Sny voete plate	5	2	nan	Groot_guillotine, Quinton	t
89	24386-210	24386	Press voete	30	1	24386-200	Quinton	t
90	24386-300	24386	Bou bins	30	20	24386-30, 24386-100, 24386-210	Gert, Handlanger	t
91	24386-400	24386	Sweis bins	1	20	24386-300	Sweis, Andrew	t
92	24386-500	24386	Grind bins	1	15	24386-400	Grind, Fernando, Dean	t
93	24386-600	24386	Verf bins	1	30	24386-500	Pieter	t
94	24388-10	24388	Saag tubing	5	45	nan	Wikus, Handlanger	t
95	24388-20	24388	Sny plaatparte	5	45	nan	Groot_guillotine, Gert, Handlanger	t
96	24388-30	24388	Sny mesh	1	20	nan	Wikus, Handlanger	t
97	24388-100	24388	Bou cage	30	180	24388-10, 24388-20	Wikus, Handlanger	t
98	24388-200	24388	Sweis cage	1	90	24388-100, 24388-30	Sweis	t
99	24388-300	24388	Grind cage	1	60	24388-200	Grind, Fernando, Dean	t
100	24388-400	24388	Verf cage	1	90	24388-300	Pieter	t
101	24389-10	24389	Plasma tubings	15	570	nan	Wikus, Handlanger	t
102	24389-11	24389	Grind plasma tubes	1	180	24389-10	Grind, Fernando, Dean	t
103	24389-12	24389	Sny plaatparte	10	45	nan	Gert	t
104	24389-20	24389	Saag tubing	30	360	nan	Saag, HSaag	t
105	24389-30	24389	Bou ribbes	30	510	24389-11, 24389-20	Gert, Handlanger	t
106	24389-40	24389	Sweis ribbes	1	300	24389-30	Sweis, Andrew	t
107	24389-50	24389	Grind ribbes	1	180	24389-40	Grind, Fernando, Dean	t
108	24389-100	24389	Bou raam	45	360	24389-50	Wikus, Handlanger	t
109	24389-200	24389	Sweis raam	1	300	24389-100	Sweis, Andrew	t
110	24389-300	24389	Sit grating op	1	180	24389-200	Wikus, Handlanger	t
111	24389-400	24389	Bou flappe	10	120	24389-12	Gert, Handlanger	t
112	24389-410	24389	Bou onderstel	15	60	24389-20	Gert, Handlanger	t
113	24389-420	24389	Sweis flappe	1	30	24389-400	Sweis	t
114	24389-430	24389	Sweis onderstel	1	20	24389-410	Sweis	t
115	24389-500	24389	Sit raam aanmekaar	1	60	24389-300, 24389-420, 24389-430	Wikus, Handlanger	t
116	24389-600	24389	Verf raam	20	510	24389-500	Verf	f
117	24392-10	24392	Sny kante	10	20	nan	Gert	t
118	24392-20	24392	Sny body	10	10	nan	Gert	t
119	24392-50	24392	Buig body	15	10	24392-20	Gert, Andrew, Handlanger	t
120	24392-60	24392	Sny en buig channels	5	15	nan	Gert	t
121	24392-70	24392	Sny 10mm parte	5	10	nan	Gert	t
122	24392-80	24392	Buig en boor spore	10	30	24392-70	Wikus	t
123	24392-100	24392	Bou body	10	40	24392-10, 24392-50, 24392-60	Gert, Handlanger	t
124	24392-110	24392	Sweis body	1	45	24392-100	Sweis	t
125	24392-120	24392	Grind body	1	30	24392-110	Grind	t
126	24392-200	24392	Sny pockets	5	10	nan	Gert	t
127	24392-210	24392	Buig pockets	10	2	24392-200	Gert, Handlanger	t
128	24392-220	24392	Saag bullets	1	5	nan	Saag, HSaag	t
129	24392-230	24392	Draai bullets	10	20	24392-220	Quinton	t
130	24392-250	24392	Bou pockets	1	15	24392-210, 24392-230	Gert	t
131	24392-260	24392	Sweis pockets	1	25	24392-250	Sweis	t
132	24392-270	24392	Grind pockets	1	15	24392-260	Grind	t
133	24392-300	24392	Bou bin	10	45	24392-120, 24392-270	Wikus, Handlanger	t
134	24392-310	24392	Sweis bin	1	60	24392-300	Sweis	t
135	24392-400	24392	Grind bin	1	30	24392-310	Grind	t
136	24392-500	24392	Verf bin	1	120	24392-400	Pieter	t
137	24393-10	24393	Saag EA	1	10	nan	Saag, HSaag	t
138	24393-20	24393	Saag pyp	1	2	nan	Saag, HSaag	t
139	24393-30	24393	Sny plaatparte	5	5	nan	Gert	t
140	24393-100	24393	Bou T-nuts	10	2	24393-30	Wikus, Handlanger	t
141	24393-110	24393	Sweis T-nuts	1	3	24393-100	Sweis	t
142	24393-200	24393	Bou bracket	10	4	24393-10, 24393-20, 24393-30	Wikus, Handlanger	t
143	24393-210	24393	Sweis bracket	1	3	24393-200	Sweis	t
144	24393-300	24393	Grind	1	10	24393-110, 24393-210	Grind	t
145	24393-400	24393	Verf	1	5	24393-300	Pieter	t
146	24397-10	24397&8	Plasma	5	5		Gert	t
148	25001-1	25001	Saag raam	10	30		Saag, HSaag	t
149	25001-2	25001	Plasma	1	15		Gert	t
150	25001-3	25001	Bou raam	10	90	25001-1, 25001-2	Wikus, Vince	t
151	25001-4	25001	Sweis raam	1	60	25001-3	Andrew	t
152	25001-5	25001	Saag los parte	5	30		Saag, HSaag	t
153	25001-6	25001	Sit los parte op	1	60	25001-4, 25001-5	Wikus, Vince	t
154	25001-7	25001	Sweis grab volledig	1	30	25001-6	Sweis	t
155	25001-8	25001	Grind	1	30	25001-7	Dean, Grind	t
156	25001-9	25001	Verf	10	60	25001-8	Quinton, Pieter	t
157	25001-10	25001	Plak rubber	1	20	25001-9	Quinton	f
158	25001-11	25001	Maak grab klaar	1	45	25001-10	Quinton, Pieter	f
159	25002-1	25002	Strip	1	60		James	t
161	25002-3	25002	Deurgaan en regmaak	1	180	25002-2	Wikus, Handlanger	f
162	25002-4	25002	Oorverf	1	120	25002-3	Verf	f
163	25002-5	25002	Aanmekaarsit	1	60	25002-4	Wikus, James	f
164	25003-1	25003	Plasma plaatparte	15	30		Gert	f
165	25003-2	25003	Saag seksies	1	60		HSaag, Saag	f
166	25003-3	25003	Berei parte voor	1	60	25003-1, 25003-2	Wikus, Handlanger	f
167	25003-4	25003	Bou skudmasjien	1	180	25003-3	Wikus, Handlanger	f
168	25003-5	25003	Sweis	1	120	25003-4	Andrew	f
169	25003-6	25003	Verf	1	120	25003-5	Verf	f
170	25003-7	25003	Sit aanmekaar	1	240	25003-6	Wikus, Gert	f
171	25004-1	25004	Plasma	1	1		Gert	t
174	25005-1	25005	Plasma	1	1		Gert	t
176	25005-3	25005	Verf	1	1	25005-2	Verf	f
180	25007-1	25007	Sny plaatjies	1	5		Gert	f
181	25007-2	25007	Sit plaatjies op	10	10	25007-1	Gert, Handlanger	f
185	25009-1	25009	Modifikasie	1	480		Wikus, Gert, Andrew, Vince	t
186	25010-1	25010	Plasma	5	1		Gert	f
188	25010-3	25010	Buig	5	0.5	25010-2	Gert	f
189	25010-4	25010	Verf	1	2	25010-3	Verf	f
190	25011-1	25011	Saag	5	1		Saag, HSaag	f
191	25011-2	25011	Plasma	5	5		Gert	f
192	25011-3	25011	Buig	10	0.5	25011-2	Gert, Handlanger	f
193	25011-4	25011	Bou Raam	10	10	25011-1, 25011-3	Gert, Handlanger	f
194	25011-5	25011	Sweis	1	15	25011-4	Sweis	f
195	25011-6	25011	Grind	1	10	25011-5	Grind	f
196	25011-7	25011	Verf	5	15	25011-6	Pieter, Quinton	f
197	25012-1	25012	Deurgaan	1	2		Wikus	f
198	25012-2	25012	Regmaak	10	5		Gert, Handlanger	f
199	25013-1	25013	Bou komponente	1	5		Gert	f
200	25013-2	25013	Tack op	1	5	25013-1	Gert	f
201	25013-3	25013	Verf	1	10	25013-2	Verf	f
202	25014-1	25014	Deurgaan	5	5		Wikus	f
203	25014-2	25014	Regmaak	5	30	25014-1	James	f
204	25014-3	25014	Verf	1	20	25014-2	Verf	f
205	25015-1	25015	Deurgaan	5	2		Wikus	f
206	25015-2	25015	Regmaak	1	10	25015-1	James	f
207	25015-3	25015	Verf	5	5	25015-2	Verf	f
208	25016-1	25016	Strip	5	30		Handlanger	f
209	25016-2	25016	Deurgaan	1	10	25016-1	Wikus	f
210	25016-3	25016	Regmaak	10	60	25016-2	Gert, Andrew	f
211	25016-4	25016	Sweis	1	45	25016-3	Andrew	f
212	25016-5	25016	Verf	10	60	25016-4	Pieter, Quinton	f
213	25017-1	25017	Skoonmaak	1	45		Pieter, Quinton	f
214	25018-1	25018	Saag	5	15		Saag,HSaag	f
215	25018-2	25018	Buig	30	240	25018-1	James	f
160	25002-2	25002	Skoonmaak	1	120	25002-1	Quinton, Handlanger	f
173	25004-3	25004	Verf	1	1	25004-2	Cupgun,Verf	t
175	25005-2	25005	Grind	1	1	25005-1	Grind	t
182	25007-3	25007	Verf	10	10	25007-2	Pieter, Quinton	f
187	25010-2	25010	Skoonmaak	1	2	25010-1	Grind	f
216	25006-1	25006	Plasma	1	1		Gert	t
217	25006-2	25006	Grind	1	1	25006-1	Grind	t
218	25006-3	25006	Verf	1	1	25006-2	Pieter, Quinton	f
219	25008-1	25008	Sny plaat	5	0.5		Gert	t
220	25008-2	25008	Buig	15	0.3	25008-1	Gert, Handlanger	t
67	24370-10	24370	Saag channels	5	5	nan	Saag,HSaag	t
68	24370-20	24370	Saag tubing	5	10	nan	Saag,HSaag	f
70	24370-40	24370	Saag pyp	1	2	nan	Saag,HSaag	t
72	24370-120	24370	Buig plaatparte	10	2	24370-30	Gert, Handlanger	f
172	25004-2	25004	Grind	1	1	25004-1	Grind	f
\.


--
-- TOC entry 4951 (class 0 OID 16682)
-- Dependencies: 224
-- Data for Name: template; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.template (id, name, description, price_each) FROM stdin;
1	J450	J450	0
2	880 Refurb	880 Grab Refurbish	6505
\.


--
-- TOC entry 4964 (class 0 OID 16771)
-- Dependencies: 237
-- Data for Name: template_material; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.template_material (id, template_id, description, quantity, unit) FROM stdin;
1	1	3mm Plaat	2	2450x1225
2	1	4.5mm Plaat	1	2500x1200
3	1	25mm Bright Bar	300	mm
4	1	10mm Plaat	0.1	2500x1200
5	1	6mm Ketting	3	m
6	1	8mm carabine hook	2	ea
\.


--
-- TOC entry 4962 (class 0 OID 16757)
-- Dependencies: 235
-- Data for Name: template_task; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.template_task (id, template_id, task_number, description, setup_time, time_each, predecessors, resources) FROM stdin;
1	1	1	Sny kante	10	10		Gert
2	1	2	Sny body	10	3		Gert, Handlanger
3	1	3	Buig body	15	10	2	Gert, Andrew, Handlanger
4	1	4	Sny en buig channels	5	15		Wikus
5	1	5	Sny 10mm parte	5	10		Gert
6	1	6	Buig en boor spore	10	30	5	Wikus
7	1	7	Bou body	10	40	1, 3, 4	Gert, Handlanger
8	1	8	Sweis body	5	40	7	Sweis
9	1	9	Grind body	1	30	8	Grind
10	1	10	Sny pockets	5	5		Gert
11	1	11	Buig pockets	10	2	10	Gert, Handlanger
12	1	12	Saag bullets	1	5		Saag, HSaag
13	1	13	Draai bullets	10	20	12	Quinton
14	1	14	Bou pockets	1	15	11, 13	Gert
15	1	15	Sweis pockets	1	25	14	Sweis
16	1	16	Grind pockets	1	15	15	Grind
17	1	17	Bou bin	10	45	6, 9, 16 	Wikus
18	1	18	Sweis bin	1	45	17	Sweis
19	1	19	Grind bin	1	30	18	Grind
20	1	20	Verf bin	1	120	19	Verf
21	2	1	Strip	5	30		Handlanger
22	2	2	Deurgaan	1	10	1	Wikus
23	2	3	Regmaak	10	60	2	Gert, Andrew
24	2	4	Sweis	1	45	3	Andrew
25	2	5	Verf	10	60	4	Pieter, Quinton
\.


--
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 225
-- Name: calendar_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.calendar_id_seq', 7, true);


--
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 221
-- Name: job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_id_seq', 33, true);


--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 232
-- Name: material_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.material_id_seq', 16, true);


--
-- TOC entry 4983 (class 0 OID 0)
-- Dependencies: 219
-- Name: resource_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.resource_group_id_seq', 8, true);


--
-- TOC entry 4984 (class 0 OID 0)
-- Dependencies: 217
-- Name: resource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.resource_id_seq', 25, true);


--
-- TOC entry 4985 (class 0 OID 0)
-- Dependencies: 230
-- Name: schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.schedule_id_seq', 162, true);


--
-- TOC entry 4986 (class 0 OID 0)
-- Dependencies: 228
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.task_id_seq', 220, true);


--
-- TOC entry 4987 (class 0 OID 0)
-- Dependencies: 223
-- Name: template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.template_id_seq', 2, true);


--
-- TOC entry 4988 (class 0 OID 0)
-- Dependencies: 236
-- Name: template_material_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.template_material_id_seq', 6, true);


--
-- TOC entry 4989 (class 0 OID 0)
-- Dependencies: 234
-- Name: template_task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.template_task_id_seq', 25, true);


--
-- TOC entry 4775 (class 2606 OID 16697)
-- Name: calendar calendar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pkey PRIMARY KEY (id);


--
-- TOC entry 4777 (class 2606 OID 16699)
-- Name: calendar calendar_weekday_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_weekday_key UNIQUE (weekday);


--
-- TOC entry 4767 (class 2606 OID 16680)
-- Name: job job_job_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT job_job_number_key UNIQUE (job_number);


--
-- TOC entry 4769 (class 2606 OID 16678)
-- Name: job job_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT job_pkey PRIMARY KEY (id);


--
-- TOC entry 4787 (class 2606 OID 16750)
-- Name: material material_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_pkey PRIMARY KEY (id);


--
-- TOC entry 4779 (class 2606 OID 16704)
-- Name: resource_group_association resource_group_association_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_group_association
    ADD CONSTRAINT resource_group_association_pkey PRIMARY KEY (resource_id, group_id);


--
-- TOC entry 4763 (class 2606 OID 16669)
-- Name: resource_group resource_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_group
    ADD CONSTRAINT resource_group_name_key UNIQUE (name);


--
-- TOC entry 4765 (class 2606 OID 16667)
-- Name: resource_group resource_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_group
    ADD CONSTRAINT resource_group_pkey PRIMARY KEY (id);


--
-- TOC entry 4759 (class 2606 OID 16660)
-- Name: resource resource_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource
    ADD CONSTRAINT resource_name_key UNIQUE (name);


--
-- TOC entry 4761 (class 2606 OID 16658)
-- Name: resource resource_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (id);


--
-- TOC entry 4785 (class 2606 OID 16738)
-- Name: schedule schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_pkey PRIMARY KEY (id);


--
-- TOC entry 4781 (class 2606 OID 16724)
-- Name: task task_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);


--
-- TOC entry 4783 (class 2606 OID 16726)
-- Name: task task_task_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_task_number_key UNIQUE (task_number);


--
-- TOC entry 4791 (class 2606 OID 16776)
-- Name: template_material template_material_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.template_material
    ADD CONSTRAINT template_material_pkey PRIMARY KEY (id);


--
-- TOC entry 4771 (class 2606 OID 16690)
-- Name: template template_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.template
    ADD CONSTRAINT template_name_key UNIQUE (name);


--
-- TOC entry 4773 (class 2606 OID 16688)
-- Name: template template_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.template
    ADD CONSTRAINT template_pkey PRIMARY KEY (id);


--
-- TOC entry 4789 (class 2606 OID 16764)
-- Name: template_task template_task_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.template_task
    ADD CONSTRAINT template_task_pkey PRIMARY KEY (id);


--
-- TOC entry 4796 (class 2606 OID 16751)
-- Name: material material_job_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_job_number_fkey FOREIGN KEY (job_number) REFERENCES public.job(job_number);


--
-- TOC entry 4792 (class 2606 OID 16710)
-- Name: resource_group_association resource_group_association_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_group_association
    ADD CONSTRAINT resource_group_association_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.resource_group(id);


--
-- TOC entry 4793 (class 2606 OID 16705)
-- Name: resource_group_association resource_group_association_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_group_association
    ADD CONSTRAINT resource_group_association_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.resource(id);


--
-- TOC entry 4795 (class 2606 OID 16739)
-- Name: schedule schedule_task_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_task_number_fkey FOREIGN KEY (task_number) REFERENCES public.task(task_number);


--
-- TOC entry 4794 (class 2606 OID 16727)
-- Name: task task_job_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_job_number_fkey FOREIGN KEY (job_number) REFERENCES public.job(job_number);


--
-- TOC entry 4798 (class 2606 OID 16777)
-- Name: template_material template_material_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.template_material
    ADD CONSTRAINT template_material_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.template(id);


--
-- TOC entry 4797 (class 2606 OID 16765)
-- Name: template_task template_task_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.template_task
    ADD CONSTRAINT template_task_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.template(id);


-- Completed on 2025-03-18 21:42:32

--
-- PostgreSQL database dump complete
--

