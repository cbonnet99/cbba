--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'Standard public schema';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: articles; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE articles (
    id integer NOT NULL,
    title character varying(255),
    body text,
    slug character varying(255),
    author_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    introduction character varying(255),
    state character varying(255) DEFAULT 'draft'::character varying,
    published_at timestamp without time zone,
    reason_reject text,
    rejected_at timestamp without time zone,
    rejected_by_id integer,
    comment_approve text,
    approved_at timestamp without time zone,
    approved_by_id integer
);


ALTER TABLE public.articles OWNER TO postgres;

--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE articles_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.articles_id_seq OWNER TO postgres;

--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE articles_id_seq OWNED BY articles.id;


--
-- Name: articles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('articles_id_seq', 913227992, true);


--
-- Name: articles_subcategories; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE articles_subcategories (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    subcategory_id integer,
    article_id integer
);


ALTER TABLE public.articles_subcategories OWNER TO postgres;

--
-- Name: articles_subcategories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE articles_subcategories_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.articles_subcategories_id_seq OWNER TO postgres;

--
-- Name: articles_subcategories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE articles_subcategories_id_seq OWNED BY articles_subcategories.id;


--
-- Name: articles_subcategories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('articles_subcategories_id_seq', 81209146, true);


--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    "position" integer,
    users_counter integer DEFAULT 0
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE categories_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('categories_id_seq', 405780866, true);


--
-- Name: districts; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE districts (
    id integer NOT NULL,
    name character varying(255),
    region_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.districts OWNER TO postgres;

--
-- Name: districts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE districts_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.districts_id_seq OWNER TO postgres;

--
-- Name: districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE districts_id_seq OWNED BY districts.id;


--
-- Name: districts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('districts_id_seq', 1030444652, true);


--
-- Name: passwords; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE passwords (
    id integer NOT NULL,
    user_id integer,
    reset_code character varying(255),
    expiration_date timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.passwords OWNER TO postgres;

--
-- Name: passwords_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE passwords_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.passwords_id_seq OWNER TO postgres;

--
-- Name: passwords_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE passwords_id_seq OWNED BY passwords.id;


--
-- Name: passwords_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('passwords_id_seq', 1, false);


--
-- Name: regions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE regions (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.regions OWNER TO postgres;

--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE regions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.regions_id_seq OWNER TO postgres;

--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE regions_id_seq OWNED BY regions.id;


--
-- Name: regions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('regions_id_seq', 1073681813, true);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(255)
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE roles_id_seq
    START WITH 1070524019
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('roles_id_seq', 1070524019, false);


--
-- Name: roles_users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE roles_users (
    id integer NOT NULL,
    role_id integer,
    user_id integer
);


ALTER TABLE public.roles_users OWNER TO postgres;

--
-- Name: roles_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE roles_users_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.roles_users_id_seq OWNER TO postgres;

--
-- Name: roles_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE roles_users_id_seq OWNED BY roles_users.id;


--
-- Name: roles_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('roles_users_id_seq', 888757677, true);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sessions (
    id integer NOT NULL,
    session_id character varying(255) NOT NULL,
    data text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sessions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sessions_id_seq OWNER TO postgres;

--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE sessions_id_seq OWNED BY sessions.id;


--
-- Name: sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sessions_id_seq', 2, true);


--
-- Name: subcategories; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE subcategories (
    id integer NOT NULL,
    category_id integer,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    users_counter integer DEFAULT 0
);


ALTER TABLE public.subcategories OWNER TO postgres;

--
-- Name: subcategories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE subcategories_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.subcategories_id_seq OWNER TO postgres;

--
-- Name: subcategories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE subcategories_id_seq OWNED BY subcategories.id;


--
-- Name: subcategories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('subcategories_id_seq', 913228053, true);


--
-- Name: subcategories_users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE subcategories_users (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    subcategory_id integer,
    user_id integer
);


ALTER TABLE public.subcategories_users OWNER TO postgres;

--
-- Name: subcategories_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE subcategories_users_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.subcategories_users_id_seq OWNER TO postgres;

--
-- Name: subcategories_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE subcategories_users_id_seq OWNED BY subcategories_users.id;


--
-- Name: subcategories_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('subcategories_users_id_seq', 831879030, true);


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    taggable_id integer,
    tag_id integer,
    taggable_type character varying(255)
);


ALTER TABLE public.taggings OWNER TO postgres;

--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE taggings_id_seq
    START WITH 984775211
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.taggings_id_seq OWNER TO postgres;

--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: taggings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('taggings_id_seq', 984775211, false);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255)
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tags_id_seq
    START WITH 984775211
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tags_id_seq', 984775211, false);


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    first_name character varying(100) DEFAULT ''::character varying,
    last_name character varying(100) DEFAULT ''::character varying,
    email character varying(100),
    crypted_password character varying(40),
    salt character varying(40),
    remember_token character varying(40),
    activation_code character varying(40),
    state character varying(255) DEFAULT 'passive'::character varying,
    remember_token_expires_at timestamp without time zone,
    activated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    region_id integer,
    receive_newsletter boolean DEFAULT true,
    professional boolean DEFAULT false,
    free_listing boolean,
    business_name character varying(255),
    address1 character varying(255),
    suburb character varying(255),
    city character varying(255),
    district_id integer,
    phone character varying(255),
    mobile character varying(255)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('users_id_seq', 1046772548, true);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE articles ALTER COLUMN id SET DEFAULT nextval('articles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE articles_subcategories ALTER COLUMN id SET DEFAULT nextval('articles_subcategories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE districts ALTER COLUMN id SET DEFAULT nextval('districts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE passwords ALTER COLUMN id SET DEFAULT nextval('passwords_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE regions ALTER COLUMN id SET DEFAULT nextval('regions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE roles_users ALTER COLUMN id SET DEFAULT nextval('roles_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE sessions ALTER COLUMN id SET DEFAULT nextval('sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE subcategories ALTER COLUMN id SET DEFAULT nextval('subcategories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE subcategories_users ALTER COLUMN id SET DEFAULT nextval('subcategories_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: articles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO articles VALUES (692675549, 'Article with a very long title, how far can we go', 'This is a test', NULL, 696603906, '2008-11-27 09:14:47', '2008-11-27 09:14:47', NULL, 'published', NULL, NULL, NULL, NULL, NULL, '2008-11-25 09:14:47', 289014436);
INSERT INTO articles VALUES (913227991, 'Yoga is good for you', 'This is a test', 'yoga-is-good-for-you', 696603906, '2008-11-27 09:14:47', '2008-11-28 08:17:49.094848', NULL, 'published', '2008-11-28 08:17:40.710581', NULL, NULL, NULL, NULL, '2008-11-28 08:17:49.091275', 696603906);
INSERT INTO articles VALUES (913227992, 'asdasdas', 'asdasdsad', 'asdasdas', 696603906, '2008-11-28 10:12:00.386816', '2008-11-28 10:12:16.690947', 'asdasdsad', 'draft', '2008-11-28 10:12:04.483054', 'sdasdasdasdas', '2008-11-28 10:12:16.687251', 696603906, NULL, NULL, NULL);


--
-- Data for Name: articles_subcategories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO articles_subcategories VALUES (81209146, '2008-11-28 08:17:49.100898', '2008-11-28 08:17:49.100898', 913227991, 913227991);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO categories VALUES (280080977, 'Courses', '2008-11-27 09:14:47', '2008-11-27 09:14:56.479388', 2, 23);
INSERT INTO categories VALUES (405780862, 'Practitioners', '2008-11-27 09:14:47', '2008-11-27 09:14:56.493216', 1, 132);
INSERT INTO categories VALUES (405780863, 'Coaching', '2008-11-27 09:14:48.735422', '2008-11-27 09:14:56.503698', 3, 25);
INSERT INTO categories VALUES (405780864, 'Health centre', '2008-11-27 09:14:48.813765', '2008-11-27 09:14:56.514205', 4, 4);
INSERT INTO categories VALUES (405780865, 'Massage', '2008-11-27 09:14:49.387048', '2008-11-27 09:14:56.525104', 5, 42);
INSERT INTO categories VALUES (405780866, 'Beauty salons', '2008-11-27 09:14:50.480509', '2008-11-27 09:14:56.536182', 6, 2);


--
-- Data for Name: districts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO districts VALUES (266910087, 'Christchurch City', 880982500, '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO districts VALUES (1030444527, 'Auckland City', 151679809, '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO districts VALUES (583778593, 'Wellington City', 408794758, '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO districts VALUES (211474625, 'Akaroa', 880982500, '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO districts VALUES (88893504, 'Featherston', 921797898, '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO districts VALUES (1030444528, 'Dargaville', 1073681812, '2008-11-27 09:14:47.872773', '2008-11-27 09:14:47.872773');
INSERT INTO districts VALUES (1030444529, 'Kaikohe', 1073681812, '2008-11-27 09:14:47.882864', '2008-11-27 09:14:47.882864');
INSERT INTO districts VALUES (1030444530, 'Kaitaia', 1073681812, '2008-11-27 09:14:47.886963', '2008-11-27 09:14:47.886963');
INSERT INTO districts VALUES (1030444531, 'Kawakawa', 1073681812, '2008-11-27 09:14:47.891202', '2008-11-27 09:14:47.891202');
INSERT INTO districts VALUES (1030444532, 'Kerikeri', 1073681812, '2008-11-27 09:14:47.897092', '2008-11-27 09:14:47.897092');
INSERT INTO districts VALUES (1030444533, 'Maungaturoto', 1073681812, '2008-11-27 09:14:47.901322', '2008-11-27 09:14:47.901322');
INSERT INTO districts VALUES (1030444534, 'Paihia', 1073681812, '2008-11-27 09:14:47.905553', '2008-11-27 09:14:47.905553');
INSERT INTO districts VALUES (1030444535, 'Whangarei', 1073681812, '2008-11-27 09:14:47.909347', '2008-11-27 09:14:47.909347');
INSERT INTO districts VALUES (1030444536, 'Franklin', 151679809, '2008-11-27 09:14:47.916139', '2008-11-27 09:14:47.916139');
INSERT INTO districts VALUES (1030444537, 'Great Barrier Island', 151679809, '2008-11-27 09:14:47.921825', '2008-11-27 09:14:47.921825');
INSERT INTO districts VALUES (1030444538, 'Helensville', 151679809, '2008-11-27 09:14:47.92833', '2008-11-27 09:14:47.92833');
INSERT INTO districts VALUES (1030444539, 'Hibiscus Coast', 151679809, '2008-11-27 09:14:47.934604', '2008-11-27 09:14:47.934604');
INSERT INTO districts VALUES (1030444540, 'Manukau City', 151679809, '2008-11-27 09:14:47.939932', '2008-11-27 09:14:47.939932');
INSERT INTO districts VALUES (1030444541, 'North Shore', 151679809, '2008-11-27 09:14:47.945523', '2008-11-27 09:14:47.945523');
INSERT INTO districts VALUES (1030444542, 'Papakura City', 151679809, '2008-11-27 09:14:47.94951', '2008-11-27 09:14:47.94951');
INSERT INTO districts VALUES (1030444543, 'Waiheke Island', 151679809, '2008-11-27 09:14:47.953537', '2008-11-27 09:14:47.953537');
INSERT INTO districts VALUES (1030444544, 'Waitakere City', 151679809, '2008-11-27 09:14:47.958781', '2008-11-27 09:14:47.958781');
INSERT INTO districts VALUES (1030444545, 'Warkworth', 151679809, '2008-11-27 09:14:47.965433', '2008-11-27 09:14:47.965433');
INSERT INTO districts VALUES (1030444546, 'Wellsford', 151679809, '2008-11-27 09:14:47.971783', '2008-11-27 09:14:47.971783');
INSERT INTO districts VALUES (1030444547, 'Cambridge', 152815033, '2008-11-27 09:14:47.977966', '2008-11-27 09:14:47.977966');
INSERT INTO districts VALUES (1030444548, 'Coromandel', 152815033, '2008-11-27 09:14:47.98415', '2008-11-27 09:14:47.98415');
INSERT INTO districts VALUES (1030444549, 'Hamilton', 152815033, '2008-11-27 09:14:47.988246', '2008-11-27 09:14:47.988246');
INSERT INTO districts VALUES (1030444550, 'Huntly', 152815033, '2008-11-27 09:14:47.992437', '2008-11-27 09:14:47.992437');
INSERT INTO districts VALUES (1030444551, 'Matamata', 152815033, '2008-11-27 09:14:47.996548', '2008-11-27 09:14:47.996548');
INSERT INTO districts VALUES (1030444552, 'Morrinsville', 152815033, '2008-11-27 09:14:48.000643', '2008-11-27 09:14:48.000643');
INSERT INTO districts VALUES (1030444553, 'Otorohanga', 152815033, '2008-11-27 09:14:48.004845', '2008-11-27 09:14:48.004845');
INSERT INTO districts VALUES (1030444554, 'Paeroa', 152815033, '2008-11-27 09:14:48.010192', '2008-11-27 09:14:48.010192');
INSERT INTO districts VALUES (1030444555, 'Raglan', 152815033, '2008-11-27 09:14:48.016294', '2008-11-27 09:14:48.016294');
INSERT INTO districts VALUES (1030444556, 'Taumarunui', 152815033, '2008-11-27 09:14:48.021942', '2008-11-27 09:14:48.021942');
INSERT INTO districts VALUES (1030444557, 'Te Awamutu', 152815033, '2008-11-27 09:14:48.027692', '2008-11-27 09:14:48.027692');
INSERT INTO districts VALUES (1030444558, 'Te Kuiti', 152815033, '2008-11-27 09:14:48.033656', '2008-11-27 09:14:48.033656');
INSERT INTO districts VALUES (1030444559, 'Thames', 152815033, '2008-11-27 09:14:48.039165', '2008-11-27 09:14:48.039165');
INSERT INTO districts VALUES (1030444560, 'Tokoroa/Putaruru', 152815033, '2008-11-27 09:14:48.126011', '2008-11-27 09:14:48.126011');
INSERT INTO districts VALUES (1030444561, 'Waihi', 152815033, '2008-11-27 09:14:48.132189', '2008-11-27 09:14:48.132189');
INSERT INTO districts VALUES (1030444562, 'Waihi Beach', 152815033, '2008-11-27 09:14:48.138064', '2008-11-27 09:14:48.138064');
INSERT INTO districts VALUES (1030444563, 'Whangamata', 152815033, '2008-11-27 09:14:48.144154', '2008-11-27 09:14:48.144154');
INSERT INTO districts VALUES (1030444564, 'Katikati', 1073681813, '2008-11-27 09:14:48.159077', '2008-11-27 09:14:48.159077');
INSERT INTO districts VALUES (1030444565, 'Mt. Maunganui', 1073681813, '2008-11-27 09:14:48.164883', '2008-11-27 09:14:48.164883');
INSERT INTO districts VALUES (1030444566, 'Opotiki', 1073681813, '2008-11-27 09:14:48.170381', '2008-11-27 09:14:48.170381');
INSERT INTO districts VALUES (1030444567, 'Rotorua', 1073681813, '2008-11-27 09:14:48.174415', '2008-11-27 09:14:48.174415');
INSERT INTO districts VALUES (1030444568, 'Taupo', 1073681813, '2008-11-27 09:14:48.180869', '2008-11-27 09:14:48.180869');
INSERT INTO districts VALUES (1030444569, 'Tauranga', 1073681813, '2008-11-27 09:14:48.185744', '2008-11-27 09:14:48.185744');
INSERT INTO districts VALUES (1030444570, 'Te Puke', 1073681813, '2008-11-27 09:14:48.191184', '2008-11-27 09:14:48.191184');
INSERT INTO districts VALUES (1030444571, 'Turangi', 1073681813, '2008-11-27 09:14:48.197355', '2008-11-27 09:14:48.197355');
INSERT INTO districts VALUES (1030444572, 'Whakatane', 1073681813, '2008-11-27 09:14:48.2033', '2008-11-27 09:14:48.2033');
INSERT INTO districts VALUES (1030444573, 'Gisborne', 844805764, '2008-11-27 09:14:48.208436', '2008-11-27 09:14:48.208436');
INSERT INTO districts VALUES (1030444574, 'Ruatoria', 844805764, '2008-11-27 09:14:48.214163', '2008-11-27 09:14:48.214163');
INSERT INTO districts VALUES (1030444575, 'Dannevirke', 285931426, '2008-11-27 09:14:48.219697', '2008-11-27 09:14:48.219697');
INSERT INTO districts VALUES (1030444576, 'Hastings', 285931426, '2008-11-27 09:14:48.223964', '2008-11-27 09:14:48.223964');
INSERT INTO districts VALUES (1030444577, 'Napier', 285931426, '2008-11-27 09:14:48.229608', '2008-11-27 09:14:48.229608');
INSERT INTO districts VALUES (1030444578, 'Waipukurau', 285931426, '2008-11-27 09:14:48.234728', '2008-11-27 09:14:48.234728');
INSERT INTO districts VALUES (1030444579, 'Wairoa', 285931426, '2008-11-27 09:14:48.238949', '2008-11-27 09:14:48.238949');
INSERT INTO districts VALUES (1030444580, 'Hawera', 748770647, '2008-11-27 09:14:48.243115', '2008-11-27 09:14:48.243115');
INSERT INTO districts VALUES (1030444581, 'Mokau', 748770647, '2008-11-27 09:14:48.248274', '2008-11-27 09:14:48.248274');
INSERT INTO districts VALUES (1030444582, 'New Plymouth', 748770647, '2008-11-27 09:14:48.254399', '2008-11-27 09:14:48.254399');
INSERT INTO districts VALUES (1030444583, 'Opunake', 748770647, '2008-11-27 09:14:48.260575', '2008-11-27 09:14:48.260575');
INSERT INTO districts VALUES (1030444584, 'Stratford', 748770647, '2008-11-27 09:14:48.26671', '2008-11-27 09:14:48.26671');
INSERT INTO districts VALUES (1030444585, 'Ohakune', 596760357, '2008-11-27 09:14:48.271571', '2008-11-27 09:14:48.271571');
INSERT INTO districts VALUES (1030444586, 'Taihape', 596760357, '2008-11-27 09:14:48.27763', '2008-11-27 09:14:48.27763');
INSERT INTO districts VALUES (1030444587, 'Waiouru', 596760357, '2008-11-27 09:14:48.284493', '2008-11-27 09:14:48.284493');
INSERT INTO districts VALUES (1030444588, 'Wanganui', 596760357, '2008-11-27 09:14:48.288996', '2008-11-27 09:14:48.288996');
INSERT INTO districts VALUES (1030444589, 'Bulls', 647785004, '2008-11-27 09:14:48.293314', '2008-11-27 09:14:48.293314');
INSERT INTO districts VALUES (1030444590, 'Feilding', 647785004, '2008-11-27 09:14:48.298568', '2008-11-27 09:14:48.298568');
INSERT INTO districts VALUES (1030444591, 'Levin', 647785004, '2008-11-27 09:14:48.304165', '2008-11-27 09:14:48.304165');
INSERT INTO districts VALUES (1030444592, 'Manawatu', 647785004, '2008-11-27 09:14:48.310315', '2008-11-27 09:14:48.310315');
INSERT INTO districts VALUES (1030444593, 'Marton', 647785004, '2008-11-27 09:14:48.31586', '2008-11-27 09:14:48.31586');
INSERT INTO districts VALUES (1030444594, 'Palmerston North', 647785004, '2008-11-27 09:14:48.321241', '2008-11-27 09:14:48.321241');
INSERT INTO districts VALUES (1030444595, 'Carterton', 921797898, '2008-11-27 09:14:48.326943', '2008-11-27 09:14:48.326943');
INSERT INTO districts VALUES (1030444596, 'Greytown', 921797898, '2008-11-27 09:14:48.335028', '2008-11-27 09:14:48.335028');
INSERT INTO districts VALUES (1030444597, 'Martinborough', 921797898, '2008-11-27 09:14:48.340731', '2008-11-27 09:14:48.340731');
INSERT INTO districts VALUES (1030444598, 'Masterton', 921797898, '2008-11-27 09:14:48.346396', '2008-11-27 09:14:48.346396');
INSERT INTO districts VALUES (1030444599, 'Pahiatua', 921797898, '2008-11-27 09:14:48.351915', '2008-11-27 09:14:48.351915');
INSERT INTO districts VALUES (1030444600, 'Woodville', 921797898, '2008-11-27 09:14:48.357137', '2008-11-27 09:14:48.357137');
INSERT INTO districts VALUES (1030444601, 'Kapiti', 408794758, '2008-11-27 09:14:48.362232', '2008-11-27 09:14:48.362232');
INSERT INTO districts VALUES (1030444602, 'Lower Hutt City', 408794758, '2008-11-27 09:14:48.367683', '2008-11-27 09:14:48.367683');
INSERT INTO districts VALUES (1030444603, 'Porirua', 408794758, '2008-11-27 09:14:48.373167', '2008-11-27 09:14:48.373167');
INSERT INTO districts VALUES (1030444604, 'Upper Hutt City', 408794758, '2008-11-27 09:14:48.37968', '2008-11-27 09:14:48.37968');
INSERT INTO districts VALUES (1030444605, 'Golden Bay', 783123194, '2008-11-27 09:14:48.387365', '2008-11-27 09:14:48.387365');
INSERT INTO districts VALUES (1030444606, 'Motueka', 783123194, '2008-11-27 09:14:48.392821', '2008-11-27 09:14:48.392821');
INSERT INTO districts VALUES (1030444607, 'Murchison', 783123194, '2008-11-27 09:14:48.398266', '2008-11-27 09:14:48.398266');
INSERT INTO districts VALUES (1030444608, 'Nelson', 783123194, '2008-11-27 09:14:48.404433', '2008-11-27 09:14:48.404433');
INSERT INTO districts VALUES (1030444609, 'Picton', 783123194, '2008-11-27 09:14:48.408995', '2008-11-27 09:14:48.408995');
INSERT INTO districts VALUES (1030444610, 'Blenheim', 324053799, '2008-11-27 09:14:48.413347', '2008-11-27 09:14:48.413347');
INSERT INTO districts VALUES (1030444611, 'Marlborough Sounds', 324053799, '2008-11-27 09:14:48.41744', '2008-11-27 09:14:48.41744');
INSERT INTO districts VALUES (1030444612, 'Greymouth', 546112473, '2008-11-27 09:14:48.422477', '2008-11-27 09:14:48.422477');
INSERT INTO districts VALUES (1030444613, 'Hokitika', 546112473, '2008-11-27 09:14:48.428025', '2008-11-27 09:14:48.428025');
INSERT INTO districts VALUES (1030444614, 'Westport', 546112473, '2008-11-27 09:14:48.432995', '2008-11-27 09:14:48.432995');
INSERT INTO districts VALUES (1030444615, 'Amberley', 880982500, '2008-11-27 09:14:48.438748', '2008-11-27 09:14:48.438748');
INSERT INTO districts VALUES (1030444616, 'Ashburton', 880982500, '2008-11-27 09:14:48.442652', '2008-11-27 09:14:48.442652');
INSERT INTO districts VALUES (1030444617, 'Cheviot', 880982500, '2008-11-27 09:14:48.447888', '2008-11-27 09:14:48.447888');
INSERT INTO districts VALUES (1030444618, 'Darfield', 880982500, '2008-11-27 09:14:48.453705', '2008-11-27 09:14:48.453705');
INSERT INTO districts VALUES (1030444619, 'Fairlie', 880982500, '2008-11-27 09:14:48.459045', '2008-11-27 09:14:48.459045');
INSERT INTO districts VALUES (1030444620, 'Geraldine', 880982500, '2008-11-27 09:14:48.464374', '2008-11-27 09:14:48.464374');
INSERT INTO districts VALUES (1030444621, 'Hanmer Springs', 880982500, '2008-11-27 09:14:48.470233', '2008-11-27 09:14:48.470233');
INSERT INTO districts VALUES (1030444622, 'Kaiapoi', 880982500, '2008-11-27 09:14:48.476251', '2008-11-27 09:14:48.476251');
INSERT INTO districts VALUES (1030444623, 'Kaikoura', 880982500, '2008-11-27 09:14:48.483899', '2008-11-27 09:14:48.483899');
INSERT INTO districts VALUES (1030444624, 'Mt Cook', 880982500, '2008-11-27 09:14:48.488519', '2008-11-27 09:14:48.488519');
INSERT INTO districts VALUES (1030444625, 'Rangiora', 880982500, '2008-11-27 09:14:48.492607', '2008-11-27 09:14:48.492607');
INSERT INTO districts VALUES (1030444626, 'Kurow', 852992224, '2008-11-27 09:14:48.497155', '2008-11-27 09:14:48.497155');
INSERT INTO districts VALUES (1030444627, 'Oamaru', 852992224, '2008-11-27 09:14:48.501078', '2008-11-27 09:14:48.501078');
INSERT INTO districts VALUES (1030444628, 'Timaru', 852992224, '2008-11-27 09:14:48.506697', '2008-11-27 09:14:48.506697');
INSERT INTO districts VALUES (1030444629, 'Twizel', 852992224, '2008-11-27 09:14:48.512168', '2008-11-27 09:14:48.512168');
INSERT INTO districts VALUES (1030444630, 'Waimate', 852992224, '2008-11-27 09:14:48.517876', '2008-11-27 09:14:48.517876');
INSERT INTO districts VALUES (1030444631, 'Alexandra', 914667441, '2008-11-27 09:14:48.523971', '2008-11-27 09:14:48.523971');
INSERT INTO districts VALUES (1030444632, 'Balclutha', 914667441, '2008-11-27 09:14:48.52968', '2008-11-27 09:14:48.52968');
INSERT INTO districts VALUES (1030444633, 'Cromwell', 914667441, '2008-11-27 09:14:48.535193', '2008-11-27 09:14:48.535193');
INSERT INTO districts VALUES (1030444634, 'Dunedin', 914667441, '2008-11-27 09:14:48.541018', '2008-11-27 09:14:48.541018');
INSERT INTO districts VALUES (1030444635, 'Lawrence', 914667441, '2008-11-27 09:14:48.546557', '2008-11-27 09:14:48.546557');
INSERT INTO districts VALUES (1030444636, 'Milton', 914667441, '2008-11-27 09:14:48.5528', '2008-11-27 09:14:48.5528');
INSERT INTO districts VALUES (1030444637, 'Palmerston', 914667441, '2008-11-27 09:14:48.558385', '2008-11-27 09:14:48.558385');
INSERT INTO districts VALUES (1030444638, 'Queenstown', 914667441, '2008-11-27 09:14:48.563955', '2008-11-27 09:14:48.563955');
INSERT INTO districts VALUES (1030444639, 'Ranfurly', 914667441, '2008-11-27 09:14:48.569072', '2008-11-27 09:14:48.569072');
INSERT INTO districts VALUES (1030444640, 'Roxburgh', 914667441, '2008-11-27 09:14:48.573174', '2008-11-27 09:14:48.573174');
INSERT INTO districts VALUES (1030444641, 'Wanaka', 914667441, '2008-11-27 09:14:48.579756', '2008-11-27 09:14:48.579756');
INSERT INTO districts VALUES (1030444642, 'Bluff', 552557784, '2008-11-27 09:14:48.587128', '2008-11-27 09:14:48.587128');
INSERT INTO districts VALUES (1030444643, 'Edendale', 552557784, '2008-11-27 09:14:48.593338', '2008-11-27 09:14:48.593338');
INSERT INTO districts VALUES (1030444644, 'Gore', 552557784, '2008-11-27 09:14:48.599122', '2008-11-27 09:14:48.599122');
INSERT INTO districts VALUES (1030444645, 'Invercargill', 552557784, '2008-11-27 09:14:48.604769', '2008-11-27 09:14:48.604769');
INSERT INTO districts VALUES (1030444646, 'Lumsden', 552557784, '2008-11-27 09:14:48.609563', '2008-11-27 09:14:48.609563');
INSERT INTO districts VALUES (1030444647, 'Otautau', 552557784, '2008-11-27 09:14:48.615386', '2008-11-27 09:14:48.615386');
INSERT INTO districts VALUES (1030444648, 'Riverton', 552557784, '2008-11-27 09:14:48.620815', '2008-11-27 09:14:48.620815');
INSERT INTO districts VALUES (1030444649, 'Stewart Island', 552557784, '2008-11-27 09:14:48.626852', '2008-11-27 09:14:48.626852');
INSERT INTO districts VALUES (1030444650, 'Te Anau', 552557784, '2008-11-27 09:14:48.634754', '2008-11-27 09:14:48.634754');
INSERT INTO districts VALUES (1030444651, 'Tokanui', 552557784, '2008-11-27 09:14:48.640385', '2008-11-27 09:14:48.640385');
INSERT INTO districts VALUES (1030444652, 'Winton', 552557784, '2008-11-27 09:14:48.645974', '2008-11-27 09:14:48.645974');


--
-- Data for Name: passwords; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO regions VALUES (647785004, 'Manawatu', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (285931426, 'Hawkes Bay', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (324053799, 'Marlborough', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (921797898, 'Wairarapa', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (329691176, 'Bay Of Plenty', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (844805764, 'Gisborne', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (880982500, 'Canterbury', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (152815033, 'Waikato', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (1073681812, 'Northland', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (852992224, 'Timaru-Oamaru', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (748770647, 'Taranaki', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (552557784, 'Southland', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (783123194, 'Nelson Bays', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (151679809, 'Auckland', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (596760357, 'Wanganui', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (914667441, 'Otago', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (408794758, 'Wellington', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (546112473, 'West Coast', '2008-11-27 09:14:47', '2008-11-27 09:14:47');
INSERT INTO regions VALUES (1073681813, 'Bay of Plenty', '2008-11-27 09:14:48.14972', '2008-11-27 09:14:48.14972');


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO roles VALUES (918195489, 'full_member');
INSERT INTO roles VALUES (10424698, 'free_listing');
INSERT INTO roles VALUES (546333068, 'reviewer');
INSERT INTO roles VALUES (1070524018, 'user');
INSERT INTO roles VALUES (364965917, 'admin');


--
-- Data for Name: roles_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO roles_users VALUES (398949508, 364965917, 696603906);
INSERT INTO roles_users VALUES (888757452, 546333068, 289014436);
INSERT INTO roles_users VALUES (7138230, 10424698, 812569211);
INSERT INTO roles_users VALUES (217493193, 10424698, 1046772323);
INSERT INTO roles_users VALUES (17749010, 918195489, 851558154);
INSERT INTO roles_users VALUES (888757453, 918195489, 1046772324);
INSERT INTO roles_users VALUES (888757454, 10424698, 1046772325);
INSERT INTO roles_users VALUES (888757455, 10424698, 1046772326);
INSERT INTO roles_users VALUES (888757456, 10424698, 1046772327);
INSERT INTO roles_users VALUES (888757457, 10424698, 1046772328);
INSERT INTO roles_users VALUES (888757458, 10424698, 1046772329);
INSERT INTO roles_users VALUES (888757459, 10424698, 1046772330);
INSERT INTO roles_users VALUES (888757460, 10424698, 1046772331);
INSERT INTO roles_users VALUES (888757461, 10424698, 1046772332);
INSERT INTO roles_users VALUES (888757462, 10424698, 1046772333);
INSERT INTO roles_users VALUES (888757463, 10424698, 1046772334);
INSERT INTO roles_users VALUES (888757464, 10424698, 1046772335);
INSERT INTO roles_users VALUES (888757465, 10424698, 1046772336);
INSERT INTO roles_users VALUES (888757466, 10424698, 1046772337);
INSERT INTO roles_users VALUES (888757467, 10424698, 1046772338);
INSERT INTO roles_users VALUES (888757468, 10424698, 1046772339);
INSERT INTO roles_users VALUES (888757469, 10424698, 1046772340);
INSERT INTO roles_users VALUES (888757470, 10424698, 1046772341);
INSERT INTO roles_users VALUES (888757471, 10424698, 1046772342);
INSERT INTO roles_users VALUES (888757472, 10424698, 1046772343);
INSERT INTO roles_users VALUES (888757473, 10424698, 1046772344);
INSERT INTO roles_users VALUES (888757474, 10424698, 1046772345);
INSERT INTO roles_users VALUES (888757475, 10424698, 1046772346);
INSERT INTO roles_users VALUES (888757476, 918195489, 1046772347);
INSERT INTO roles_users VALUES (888757477, 10424698, 1046772348);
INSERT INTO roles_users VALUES (888757478, 10424698, 1046772349);
INSERT INTO roles_users VALUES (888757479, 10424698, 1046772350);
INSERT INTO roles_users VALUES (888757480, 10424698, 1046772351);
INSERT INTO roles_users VALUES (888757481, 10424698, 1046772352);
INSERT INTO roles_users VALUES (888757482, 10424698, 1046772353);
INSERT INTO roles_users VALUES (888757483, 10424698, 1046772354);
INSERT INTO roles_users VALUES (888757484, 10424698, 1046772355);
INSERT INTO roles_users VALUES (888757485, 10424698, 1046772356);
INSERT INTO roles_users VALUES (888757486, 10424698, 1046772357);
INSERT INTO roles_users VALUES (888757487, 10424698, 1046772358);
INSERT INTO roles_users VALUES (888757488, 10424698, 1046772359);
INSERT INTO roles_users VALUES (888757489, 10424698, 1046772360);
INSERT INTO roles_users VALUES (888757490, 10424698, 1046772361);
INSERT INTO roles_users VALUES (888757491, 918195489, 1046772362);
INSERT INTO roles_users VALUES (888757492, 10424698, 1046772363);
INSERT INTO roles_users VALUES (888757493, 918195489, 1046772364);
INSERT INTO roles_users VALUES (888757494, 10424698, 1046772365);
INSERT INTO roles_users VALUES (888757495, 10424698, 1046772366);
INSERT INTO roles_users VALUES (888757496, 10424698, 1046772367);
INSERT INTO roles_users VALUES (888757497, 10424698, 1046772368);
INSERT INTO roles_users VALUES (888757498, 10424698, 1046772369);
INSERT INTO roles_users VALUES (888757499, 10424698, 1046772370);
INSERT INTO roles_users VALUES (888757500, 918195489, 1046772371);
INSERT INTO roles_users VALUES (888757501, 10424698, 1046772372);
INSERT INTO roles_users VALUES (888757502, 10424698, 1046772373);
INSERT INTO roles_users VALUES (888757503, 10424698, 1046772374);
INSERT INTO roles_users VALUES (888757504, 10424698, 1046772375);
INSERT INTO roles_users VALUES (888757505, 918195489, 1046772376);
INSERT INTO roles_users VALUES (888757506, 10424698, 1046772377);
INSERT INTO roles_users VALUES (888757507, 10424698, 1046772378);
INSERT INTO roles_users VALUES (888757508, 10424698, 1046772379);
INSERT INTO roles_users VALUES (888757509, 10424698, 1046772380);
INSERT INTO roles_users VALUES (888757510, 10424698, 1046772381);
INSERT INTO roles_users VALUES (888757511, 10424698, 1046772382);
INSERT INTO roles_users VALUES (888757512, 10424698, 1046772383);
INSERT INTO roles_users VALUES (888757513, 10424698, 1046772384);
INSERT INTO roles_users VALUES (888757514, 10424698, 1046772385);
INSERT INTO roles_users VALUES (888757515, 10424698, 1046772386);
INSERT INTO roles_users VALUES (888757516, 10424698, 1046772387);
INSERT INTO roles_users VALUES (888757517, 10424698, 1046772388);
INSERT INTO roles_users VALUES (888757518, 10424698, 1046772389);
INSERT INTO roles_users VALUES (888757519, 10424698, 1046772390);
INSERT INTO roles_users VALUES (888757520, 10424698, 1046772391);
INSERT INTO roles_users VALUES (888757521, 918195489, 1046772392);
INSERT INTO roles_users VALUES (888757522, 918195489, 1046772393);
INSERT INTO roles_users VALUES (888757523, 10424698, 1046772394);
INSERT INTO roles_users VALUES (888757524, 10424698, 1046772395);
INSERT INTO roles_users VALUES (888757525, 10424698, 1046772396);
INSERT INTO roles_users VALUES (888757526, 10424698, 1046772397);
INSERT INTO roles_users VALUES (888757527, 10424698, 1046772398);
INSERT INTO roles_users VALUES (888757528, 10424698, 1046772399);
INSERT INTO roles_users VALUES (888757529, 10424698, 1046772400);
INSERT INTO roles_users VALUES (888757530, 10424698, 1046772401);
INSERT INTO roles_users VALUES (888757531, 10424698, 1046772402);
INSERT INTO roles_users VALUES (888757532, 10424698, 1046772403);
INSERT INTO roles_users VALUES (888757533, 10424698, 1046772404);
INSERT INTO roles_users VALUES (888757534, 10424698, 1046772405);
INSERT INTO roles_users VALUES (888757535, 10424698, 1046772406);
INSERT INTO roles_users VALUES (888757536, 10424698, 1046772407);
INSERT INTO roles_users VALUES (888757537, 10424698, 1046772408);
INSERT INTO roles_users VALUES (888757538, 10424698, 1046772409);
INSERT INTO roles_users VALUES (888757539, 10424698, 1046772410);
INSERT INTO roles_users VALUES (888757540, 10424698, 1046772411);
INSERT INTO roles_users VALUES (888757541, 918195489, 1046772412);
INSERT INTO roles_users VALUES (888757542, 10424698, 1046772413);
INSERT INTO roles_users VALUES (888757543, 918195489, 1046772414);
INSERT INTO roles_users VALUES (888757544, 10424698, 1046772415);
INSERT INTO roles_users VALUES (888757545, 10424698, 1046772416);
INSERT INTO roles_users VALUES (888757546, 10424698, 1046772417);
INSERT INTO roles_users VALUES (888757547, 10424698, 1046772418);
INSERT INTO roles_users VALUES (888757548, 10424698, 1046772419);
INSERT INTO roles_users VALUES (888757549, 918195489, 1046772420);
INSERT INTO roles_users VALUES (888757550, 10424698, 1046772421);
INSERT INTO roles_users VALUES (888757551, 10424698, 1046772422);
INSERT INTO roles_users VALUES (888757552, 10424698, 1046772423);
INSERT INTO roles_users VALUES (888757553, 918195489, 1046772424);
INSERT INTO roles_users VALUES (888757554, 10424698, 1046772425);
INSERT INTO roles_users VALUES (888757555, 10424698, 1046772426);
INSERT INTO roles_users VALUES (888757556, 10424698, 1046772427);
INSERT INTO roles_users VALUES (888757557, 10424698, 1046772428);
INSERT INTO roles_users VALUES (888757558, 10424698, 1046772429);
INSERT INTO roles_users VALUES (888757559, 10424698, 1046772430);
INSERT INTO roles_users VALUES (888757560, 10424698, 1046772431);
INSERT INTO roles_users VALUES (888757561, 10424698, 1046772432);
INSERT INTO roles_users VALUES (888757562, 10424698, 1046772433);
INSERT INTO roles_users VALUES (888757563, 10424698, 1046772434);
INSERT INTO roles_users VALUES (888757564, 10424698, 1046772435);
INSERT INTO roles_users VALUES (888757565, 10424698, 1046772436);
INSERT INTO roles_users VALUES (888757566, 10424698, 1046772437);
INSERT INTO roles_users VALUES (888757567, 10424698, 1046772438);
INSERT INTO roles_users VALUES (888757568, 10424698, 1046772439);
INSERT INTO roles_users VALUES (888757569, 10424698, 1046772440);
INSERT INTO roles_users VALUES (888757570, 10424698, 1046772441);
INSERT INTO roles_users VALUES (888757571, 10424698, 1046772442);
INSERT INTO roles_users VALUES (888757572, 10424698, 1046772443);
INSERT INTO roles_users VALUES (888757573, 10424698, 1046772444);
INSERT INTO roles_users VALUES (888757574, 10424698, 1046772445);
INSERT INTO roles_users VALUES (888757575, 10424698, 1046772446);
INSERT INTO roles_users VALUES (888757576, 10424698, 1046772447);
INSERT INTO roles_users VALUES (888757577, 10424698, 1046772448);
INSERT INTO roles_users VALUES (888757578, 10424698, 1046772449);
INSERT INTO roles_users VALUES (888757579, 10424698, 1046772450);
INSERT INTO roles_users VALUES (888757580, 10424698, 1046772451);
INSERT INTO roles_users VALUES (888757581, 10424698, 1046772452);
INSERT INTO roles_users VALUES (888757582, 10424698, 1046772453);
INSERT INTO roles_users VALUES (888757583, 10424698, 1046772454);
INSERT INTO roles_users VALUES (888757584, 10424698, 1046772455);
INSERT INTO roles_users VALUES (888757585, 10424698, 1046772456);
INSERT INTO roles_users VALUES (888757586, 10424698, 1046772457);
INSERT INTO roles_users VALUES (888757587, 10424698, 1046772458);
INSERT INTO roles_users VALUES (888757588, 10424698, 1046772459);
INSERT INTO roles_users VALUES (888757589, 10424698, 1046772460);
INSERT INTO roles_users VALUES (888757590, 10424698, 1046772461);
INSERT INTO roles_users VALUES (888757591, 918195489, 1046772462);
INSERT INTO roles_users VALUES (888757592, 10424698, 1046772463);
INSERT INTO roles_users VALUES (888757593, 10424698, 1046772464);
INSERT INTO roles_users VALUES (888757594, 10424698, 1046772465);
INSERT INTO roles_users VALUES (888757595, 10424698, 1046772466);
INSERT INTO roles_users VALUES (888757596, 10424698, 1046772467);
INSERT INTO roles_users VALUES (888757597, 10424698, 1046772468);
INSERT INTO roles_users VALUES (888757598, 10424698, 1046772469);
INSERT INTO roles_users VALUES (888757599, 10424698, 1046772470);
INSERT INTO roles_users VALUES (888757600, 10424698, 1046772471);
INSERT INTO roles_users VALUES (888757601, 918195489, 1046772472);
INSERT INTO roles_users VALUES (888757602, 10424698, 1046772473);
INSERT INTO roles_users VALUES (888757603, 10424698, 1046772474);
INSERT INTO roles_users VALUES (888757604, 10424698, 1046772475);
INSERT INTO roles_users VALUES (888757605, 10424698, 1046772476);
INSERT INTO roles_users VALUES (888757606, 10424698, 1046772477);
INSERT INTO roles_users VALUES (888757607, 10424698, 1046772478);
INSERT INTO roles_users VALUES (888757608, 10424698, 1046772479);
INSERT INTO roles_users VALUES (888757609, 10424698, 1046772480);
INSERT INTO roles_users VALUES (888757610, 10424698, 1046772481);
INSERT INTO roles_users VALUES (888757611, 10424698, 1046772482);
INSERT INTO roles_users VALUES (888757612, 10424698, 1046772483);
INSERT INTO roles_users VALUES (888757613, 10424698, 1046772484);
INSERT INTO roles_users VALUES (888757614, 10424698, 1046772485);
INSERT INTO roles_users VALUES (888757615, 10424698, 1046772486);
INSERT INTO roles_users VALUES (888757616, 10424698, 1046772487);
INSERT INTO roles_users VALUES (888757617, 10424698, 1046772488);
INSERT INTO roles_users VALUES (888757618, 10424698, 1046772489);
INSERT INTO roles_users VALUES (888757619, 10424698, 1046772490);
INSERT INTO roles_users VALUES (888757620, 10424698, 1046772491);
INSERT INTO roles_users VALUES (888757621, 10424698, 1046772492);
INSERT INTO roles_users VALUES (888757622, 10424698, 1046772493);
INSERT INTO roles_users VALUES (888757623, 10424698, 1046772494);
INSERT INTO roles_users VALUES (888757624, 10424698, 1046772495);
INSERT INTO roles_users VALUES (888757625, 10424698, 1046772496);
INSERT INTO roles_users VALUES (888757626, 10424698, 1046772497);
INSERT INTO roles_users VALUES (888757627, 10424698, 1046772498);
INSERT INTO roles_users VALUES (888757628, 10424698, 1046772499);
INSERT INTO roles_users VALUES (888757629, 10424698, 1046772500);
INSERT INTO roles_users VALUES (888757630, 10424698, 1046772501);
INSERT INTO roles_users VALUES (888757631, 10424698, 1046772502);
INSERT INTO roles_users VALUES (888757632, 918195489, 1046772503);
INSERT INTO roles_users VALUES (888757633, 918195489, 1046772504);
INSERT INTO roles_users VALUES (888757634, 10424698, 1046772505);
INSERT INTO roles_users VALUES (888757635, 10424698, 1046772506);
INSERT INTO roles_users VALUES (888757636, 10424698, 1046772507);
INSERT INTO roles_users VALUES (888757637, 10424698, 1046772508);
INSERT INTO roles_users VALUES (888757638, 10424698, 1046772509);
INSERT INTO roles_users VALUES (888757639, 10424698, 1046772510);
INSERT INTO roles_users VALUES (888757640, 918195489, 1046772511);
INSERT INTO roles_users VALUES (888757641, 10424698, 1046772512);
INSERT INTO roles_users VALUES (888757642, 10424698, 1046772513);
INSERT INTO roles_users VALUES (888757643, 10424698, 1046772514);
INSERT INTO roles_users VALUES (888757644, 10424698, 1046772515);
INSERT INTO roles_users VALUES (888757645, 10424698, 1046772516);
INSERT INTO roles_users VALUES (888757646, 10424698, 1046772517);
INSERT INTO roles_users VALUES (888757647, 10424698, 1046772518);
INSERT INTO roles_users VALUES (888757648, 10424698, 1046772519);
INSERT INTO roles_users VALUES (888757649, 10424698, 1046772520);
INSERT INTO roles_users VALUES (888757650, 10424698, 1046772521);
INSERT INTO roles_users VALUES (888757651, 10424698, 1046772522);
INSERT INTO roles_users VALUES (888757652, 10424698, 1046772523);
INSERT INTO roles_users VALUES (888757653, 10424698, 1046772524);
INSERT INTO roles_users VALUES (888757654, 10424698, 1046772525);
INSERT INTO roles_users VALUES (888757655, 10424698, 1046772526);
INSERT INTO roles_users VALUES (888757656, 10424698, 1046772527);
INSERT INTO roles_users VALUES (888757657, 10424698, 1046772528);
INSERT INTO roles_users VALUES (888757658, 10424698, 1046772529);
INSERT INTO roles_users VALUES (888757659, 10424698, 1046772530);
INSERT INTO roles_users VALUES (888757660, 918195489, 1046772531);
INSERT INTO roles_users VALUES (888757661, 10424698, 1046772532);
INSERT INTO roles_users VALUES (888757662, 10424698, 1046772533);
INSERT INTO roles_users VALUES (888757663, 10424698, 1046772534);
INSERT INTO roles_users VALUES (888757664, 918195489, 1046772535);
INSERT INTO roles_users VALUES (888757665, 10424698, 1046772536);
INSERT INTO roles_users VALUES (888757666, 10424698, 1046772537);
INSERT INTO roles_users VALUES (888757667, 10424698, 1046772538);
INSERT INTO roles_users VALUES (888757668, 10424698, 1046772539);
INSERT INTO roles_users VALUES (888757669, 10424698, 1046772540);
INSERT INTO roles_users VALUES (888757670, 10424698, 1046772541);
INSERT INTO roles_users VALUES (888757671, 10424698, 1046772542);
INSERT INTO roles_users VALUES (888757672, 10424698, 1046772543);
INSERT INTO roles_users VALUES (888757673, 10424698, 1046772544);
INSERT INTO roles_users VALUES (888757674, 10424698, 1046772545);
INSERT INTO roles_users VALUES (888757675, 10424698, 1046772546);
INSERT INTO roles_users VALUES (888757676, 10424698, 1046772547);
INSERT INTO roles_users VALUES (888757677, 918195489, 1046772548);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO schema_migrations VALUES ('20080811093045');
INSERT INTO schema_migrations VALUES ('20080811094730');
INSERT INTO schema_migrations VALUES ('20080811135317');
INSERT INTO schema_migrations VALUES ('20080912160708');
INSERT INTO schema_migrations VALUES ('20081102092502');
INSERT INTO schema_migrations VALUES ('20081103083643');
INSERT INTO schema_migrations VALUES ('20081103102010');
INSERT INTO schema_migrations VALUES ('20081103184102');
INSERT INTO schema_migrations VALUES ('20081103185932');
INSERT INTO schema_migrations VALUES ('20081109191611');
INSERT INTO schema_migrations VALUES ('20081112041348');
INSERT INTO schema_migrations VALUES ('20081116083933');
INSERT INTO schema_migrations VALUES ('20081116085310');
INSERT INTO schema_migrations VALUES ('20081116090946');
INSERT INTO schema_migrations VALUES ('20081117043904');
INSERT INTO schema_migrations VALUES ('20081123015806');
INSERT INTO schema_migrations VALUES ('20081123191124');
INSERT INTO schema_migrations VALUES ('20081125044029');
INSERT INTO schema_migrations VALUES ('20081125181814');
INSERT INTO schema_migrations VALUES ('20081126225136');
INSERT INTO schema_migrations VALUES ('20081126232724');


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO sessions VALUES (2, 'c8a72df34853bb2789522ec8e0dea4d3', 'BAh7BzoOcmV0dXJuX3RvMCIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6
Rmxhc2g6OkZsYXNoSGFzaHsABjoKQHVzZWR7AA==
', '2008-11-30 23:48:48.470018', '2008-11-30 23:48:51.15439');


--
-- Data for Name: subcategories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO subcategories VALUES (263204183, 405780862, 'Hypnotherapy', '2008-11-27 09:14:47', '2008-11-27 09:14:56.548844', 10);
INSERT INTO subcategories VALUES (913227991, 280080977, 'Yoga', '2008-11-27 09:14:47', '2008-11-27 09:14:56.555979', 8);
INSERT INTO subcategories VALUES (913227992, 405780863, 'Life coaching', '2008-11-27 09:14:48.744409', '2008-11-27 09:14:56.564741', 18);
INSERT INTO subcategories VALUES (913227993, 405780862, 'Therapeutic massage', '2008-11-27 09:14:48.783394', '2008-11-27 09:14:56.576459', 2);
INSERT INTO subcategories VALUES (913227994, 405780864, 'Day spa', '2008-11-27 09:14:48.817548', '2008-11-27 09:14:56.585892', 1);
INSERT INTO subcategories VALUES (913227995, 405780862, 'Reiki', '2008-11-27 09:14:48.846224', '2008-11-27 09:14:56.59495', 9);
INSERT INTO subcategories VALUES (913227996, 405780862, 'Energy therapies', '2008-11-27 09:14:48.8739', '2008-11-27 09:14:56.601353', 2);
INSERT INTO subcategories VALUES (913227997, 280080977, 'Pilates', '2008-11-27 09:14:48.905155', '2008-11-27 09:14:56.60974', 8);
INSERT INTO subcategories VALUES (913227998, 405780862, 'Acupuncture', '2008-11-27 09:14:49.021066', '2008-11-27 09:14:56.62076', 11);
INSERT INTO subcategories VALUES (913227999, 405780862, 'Nlp', '2008-11-27 09:14:49.052022', '2008-11-27 09:14:56.632648', 11);
INSERT INTO subcategories VALUES (913228000, 405780862, 'Migraine relief', '2008-11-27 09:14:49.118266', '2008-11-27 09:14:56.639515', 1);
INSERT INTO subcategories VALUES (913228001, 405780862, 'Psychotherapy', '2008-11-27 09:14:49.175722', '2008-11-27 09:14:56.648591', 2);
INSERT INTO subcategories VALUES (913228002, 405780862, 'Homeobotanicals', '2008-11-27 09:14:49.206132', '2008-11-27 09:14:56.655168', 1);
INSERT INTO subcategories VALUES (913228003, 405780863, 'Business coaching', '2008-11-27 09:14:49.264987', '2008-11-27 09:14:56.661563', 1);
INSERT INTO subcategories VALUES (913228004, 405780862, 'Reflexology', '2008-11-27 09:14:49.297011', '2008-11-27 09:14:56.669668', 3);
INSERT INTO subcategories VALUES (913228005, 405780862, 'Neuromuscular therapy', '2008-11-27 09:14:49.354935', '2008-11-27 09:14:56.676421', 1);
INSERT INTO subcategories VALUES (913228006, 405780865, 'Therapeutic massage', '2008-11-27 09:14:49.390705', '2008-11-27 09:14:56.688718', 24);
INSERT INTO subcategories VALUES (913228007, 405780862, 'Nutrition', '2008-11-27 09:14:49.585588', '2008-11-27 09:14:56.697538', 1);
INSERT INTO subcategories VALUES (913228008, 405780862, 'Clairvoyant', '2008-11-27 09:14:49.617753', '2008-11-27 09:14:56.706945', 2);
INSERT INTO subcategories VALUES (913228009, 405780865, 'Neuromuscular therapy', '2008-11-27 09:14:49.650576', '2008-11-27 09:14:56.715127', 3);
INSERT INTO subcategories VALUES (913228010, 405780862, 'Naturopathy', '2008-11-27 09:14:49.679168', '2008-11-27 09:14:56.723345', 10);
INSERT INTO subcategories VALUES (913228011, 405780865, 'Relaxation massage', '2008-11-27 09:14:49.709418', '2008-11-27 09:14:56.732176', 10);
INSERT INTO subcategories VALUES (913228012, 405780862, 'Craniosacral therapy', '2008-11-27 09:14:49.877519', '2008-11-27 09:14:56.742918', 3);
INSERT INTO subcategories VALUES (913228013, 405780862, 'Emotional freedom technique', '2008-11-27 09:14:49.936522', '2008-11-27 09:14:56.75001', 5);
INSERT INTO subcategories VALUES (913228014, 405780862, 'Homeopathy', '2008-11-27 09:14:49.963893', '2008-11-27 09:14:56.758578', 14);
INSERT INTO subcategories VALUES (913228015, 405780862, 'Osteopathy', '2008-11-27 09:14:49.992852', '2008-11-27 09:14:56.770298', 3);
INSERT INTO subcategories VALUES (913228016, 280080977, 'Meditation', '2008-11-27 09:14:50.106437', '2008-11-27 09:14:56.778311', 4);
INSERT INTO subcategories VALUES (913228017, 405780862, 'Aromatherapy', '2008-11-27 09:14:50.135926', '2008-11-27 09:14:56.787413', 3);
INSERT INTO subcategories VALUES (913228018, 405780862, 'Herbal medicine', '2008-11-27 09:14:50.168233', '2008-11-27 09:14:56.795068', 1);
INSERT INTO subcategories VALUES (913228019, 405780862, 'Kinesiology', '2008-11-27 09:14:50.199478', '2008-11-27 09:14:56.806341', 4);
INSERT INTO subcategories VALUES (913228020, 405780862, 'Relaxation massage', '2008-11-27 09:14:50.366702', '2008-11-27 09:14:56.813157', 1);
INSERT INTO subcategories VALUES (913228021, 405780866, 'Beauty salons', '2008-11-27 09:14:50.484411', '2008-11-27 09:14:56.824876', 2);
INSERT INTO subcategories VALUES (913228022, 405780862, 'Counselling', '2008-11-27 09:14:50.768814', '2008-11-27 09:14:56.836847', 5);
INSERT INTO subcategories VALUES (913228023, 405780862, 'Chiropractor', '2008-11-27 09:14:50.877961', '2008-11-27 09:14:56.845699', 6);
INSERT INTO subcategories VALUES (913228024, 405780862, 'Fractology', '2008-11-27 09:14:51.215966', '2008-11-27 09:14:56.854134', 1);
INSERT INTO subcategories VALUES (913228025, 405780865, 'Lomi lomi massage', '2008-11-27 09:14:51.553537', '2008-11-27 09:14:56.863462', 1);
INSERT INTO subcategories VALUES (913228026, 405780862, 'Health & safety', '2008-11-27 09:14:51.841394', '2008-11-27 09:14:56.87', 1);
INSERT INTO subcategories VALUES (913228027, 405780863, 'Health coaching', '2008-11-27 09:14:51.920628', '2008-11-27 09:14:56.876551', 1);
INSERT INTO subcategories VALUES (913228028, 405780862, 'Bowen therapy', '2008-11-27 09:14:51.981798', '2008-11-27 09:14:56.890858', 3);
INSERT INTO subcategories VALUES (913228029, 405780865, 'Sports massage', '2008-11-27 09:14:52.06448', '2008-11-27 09:14:56.898157', 1);
INSERT INTO subcategories VALUES (913228030, 405780865, 'Shiatsu massage', '2008-11-27 09:14:52.093278', '2008-11-27 09:14:56.906794', 1);
INSERT INTO subcategories VALUES (913228031, 405780864, 'Health store', '2008-11-27 09:14:52.234629', '2008-11-27 09:14:56.916051', 3);
INSERT INTO subcategories VALUES (913228032, 405780863, 'Career coaching', '2008-11-27 09:14:52.428099', '2008-11-27 09:14:56.928038', 3);
INSERT INTO subcategories VALUES (913228033, 405780862, 'Sound healing', '2008-11-27 09:14:52.759835', '2008-11-27 09:14:56.935136', 1);
INSERT INTO subcategories VALUES (913228034, 405780862, 'Personal training', '2008-11-27 09:14:52.789193', '2008-11-27 09:14:56.942996', 2);
INSERT INTO subcategories VALUES (913228035, 405780862, 'Spiritual healing', '2008-11-27 09:14:52.904786', '2008-11-27 09:14:56.950113', 2);
INSERT INTO subcategories VALUES (913228036, 280080977, 'Public speaking', '2008-11-27 09:14:53.110333', '2008-11-27 09:14:56.958704', 1);
INSERT INTO subcategories VALUES (913228037, 405780862, 'Ear candling', '2008-11-27 09:14:53.396974', '2008-11-27 09:14:56.9677', 1);
INSERT INTO subcategories VALUES (913228038, 405780863, 'Executive coaching', '2008-11-27 09:14:53.505962', '2008-11-27 09:14:56.97474', 1);
INSERT INTO subcategories VALUES (913228039, 405780865, 'Detox massage', '2008-11-27 09:14:53.593529', '2008-11-27 09:14:56.981456', 1);
INSERT INTO subcategories VALUES (913228040, 405780862, 'Allergy testing', '2008-11-27 09:14:54.238787', '2008-11-27 09:14:56.992971', 1);
INSERT INTO subcategories VALUES (913228041, 405780862, 'Bowen', '2008-11-27 09:14:54.384475', '2008-11-27 09:14:57.001675', 1);
INSERT INTO subcategories VALUES (913228042, 280080977, 'Reiki', '2008-11-27 09:14:54.41237', '2008-11-27 09:14:57.010502', 1);
INSERT INTO subcategories VALUES (913228043, 405780862, 'Sacred design', '2008-11-27 09:14:54.583137', '2008-11-27 09:14:57.017295', 1);
INSERT INTO subcategories VALUES (913228044, 405780862, 'Ayurvedic medicine', '2008-11-27 09:14:54.61104', '2008-11-27 09:14:57.023997', 1);
INSERT INTO subcategories VALUES (913228045, 405780862, 'Astrology', '2008-11-27 09:14:54.643691', '2008-11-27 09:14:57.030741', 1);
INSERT INTO subcategories VALUES (913228046, 405780862, 'Alexander technique', '2008-11-27 09:14:54.872372', '2008-11-27 09:14:57.037452', 1);
INSERT INTO subcategories VALUES (913228047, 405780862, 'Feldenkrais method', '2008-11-27 09:14:54.90159', '2008-11-27 09:14:57.044133', 1);
INSERT INTO subcategories VALUES (913228048, 405780862, 'Watsu', '2008-11-27 09:14:54.9595', '2008-11-27 09:14:57.052161', 1);
INSERT INTO subcategories VALUES (913228049, 405780862, 'Lymphatic drainage', '2008-11-27 09:14:55.827891', '2008-11-27 09:14:57.061524', 1);
INSERT INTO subcategories VALUES (913228050, 405780863, 'Relationship coaching', '2008-11-27 09:14:56.114938', '2008-11-27 09:14:57.070584', 1);
INSERT INTO subcategories VALUES (913228051, 280080977, 'Chi kung', '2008-11-27 09:14:56.143291', '2008-11-27 09:14:57.07725', 1);
INSERT INTO subcategories VALUES (913228052, 405780865, 'Shiatsu', '2008-11-27 09:14:56.170913', '2008-11-27 09:14:57.085656', 1);
INSERT INTO subcategories VALUES (913228053, 405780862, 'Sports massage', '2008-11-27 09:14:56.233717', '2008-11-27 09:14:57.093743', 1);


--
-- Data for Name: subcategories_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO subcategories_users VALUES (831878805, '2008-11-27 09:14:47', '2008-11-27 09:14:47', 263204183, 1046772323);
INSERT INTO subcategories_users VALUES (621523841, '2008-11-27 09:14:47', '2008-11-27 09:14:47', 263204183, 812569211);
INSERT INTO subcategories_users VALUES (644790292, '2008-11-27 09:14:47', '2008-11-27 09:14:47', 263204183, 851558154);
INSERT INTO subcategories_users VALUES (831878806, '2008-11-27 09:14:48.723484', '2008-11-27 09:14:48.723484', 263204183, 1046772324);
INSERT INTO subcategories_users VALUES (831878807, '2008-11-27 09:14:48.771067', '2008-11-27 09:14:48.771067', 913227992, 1046772325);
INSERT INTO subcategories_users VALUES (831878808, '2008-11-27 09:14:48.807002', '2008-11-27 09:14:48.807002', 913227993, 1046772326);
INSERT INTO subcategories_users VALUES (831878809, '2008-11-27 09:14:48.839506', '2008-11-27 09:14:48.839506', 913227994, 1046772327);
INSERT INTO subcategories_users VALUES (831878810, '2008-11-27 09:14:48.867458', '2008-11-27 09:14:48.867458', 913227995, 1046772328);
INSERT INTO subcategories_users VALUES (831878811, '2008-11-27 09:14:48.897716', '2008-11-27 09:14:48.897716', 913227996, 1046772329);
INSERT INTO subcategories_users VALUES (831878812, '2008-11-27 09:14:49.013644', '2008-11-27 09:14:49.013644', 913227997, 1046772330);
INSERT INTO subcategories_users VALUES (831878813, '2008-11-27 09:14:49.045069', '2008-11-27 09:14:49.045069', 913227998, 1046772331);
INSERT INTO subcategories_users VALUES (831878814, '2008-11-27 09:14:49.075003', '2008-11-27 09:14:49.075003', 913227999, 1046772332);
INSERT INTO subcategories_users VALUES (831878815, '2008-11-27 09:14:49.111852', '2008-11-27 09:14:49.111852', 913227992, 1046772333);
INSERT INTO subcategories_users VALUES (831878816, '2008-11-27 09:14:49.142379', '2008-11-27 09:14:49.142379', 913228000, 1046772334);
INSERT INTO subcategories_users VALUES (831878817, '2008-11-27 09:14:49.168989', '2008-11-27 09:14:49.168989', 913227991, 1046772335);
INSERT INTO subcategories_users VALUES (831878818, '2008-11-27 09:14:49.199278', '2008-11-27 09:14:49.199278', 913228001, 1046772336);
INSERT INTO subcategories_users VALUES (831878819, '2008-11-27 09:14:49.228737', '2008-11-27 09:14:49.228737', 913228002, 1046772337);
INSERT INTO subcategories_users VALUES (831878820, '2008-11-27 09:14:49.257658', '2008-11-27 09:14:49.257658', 913227999, 1046772338);
INSERT INTO subcategories_users VALUES (831878821, '2008-11-27 09:14:49.289238', '2008-11-27 09:14:49.289238', 913228003, 1046772339);
INSERT INTO subcategories_users VALUES (831878822, '2008-11-27 09:14:49.319498', '2008-11-27 09:14:49.319498', 913228004, 1046772340);
INSERT INTO subcategories_users VALUES (831878823, '2008-11-27 09:14:49.347694', '2008-11-27 09:14:49.347694', 913227998, 1046772341);
INSERT INTO subcategories_users VALUES (831878824, '2008-11-27 09:14:49.379644', '2008-11-27 09:14:49.379644', 913228005, 1046772342);
INSERT INTO subcategories_users VALUES (831878825, '2008-11-27 09:14:49.41196', '2008-11-27 09:14:49.41196', 913228006, 1046772343);
INSERT INTO subcategories_users VALUES (831878826, '2008-11-27 09:14:49.437976', '2008-11-27 09:14:49.437976', 913227991, 1046772344);
INSERT INTO subcategories_users VALUES (831878827, '2008-11-27 09:14:49.550348', '2008-11-27 09:14:49.550348', 913227992, 1046772345);
INSERT INTO subcategories_users VALUES (831878828, '2008-11-27 09:14:49.57845', '2008-11-27 09:14:49.57845', 913227991, 1046772346);
INSERT INTO subcategories_users VALUES (831878829, '2008-11-27 09:14:49.610136', '2008-11-27 09:14:49.610136', 913228007, 1046772347);
INSERT INTO subcategories_users VALUES (831878830, '2008-11-27 09:14:49.642618', '2008-11-27 09:14:49.642618', 913228008, 1046772348);
INSERT INTO subcategories_users VALUES (831878831, '2008-11-27 09:14:49.672539', '2008-11-27 09:14:49.672539', 913228009, 1046772349);
INSERT INTO subcategories_users VALUES (831878832, '2008-11-27 09:14:49.701911', '2008-11-27 09:14:49.701911', 913228010, 1046772350);
INSERT INTO subcategories_users VALUES (831878833, '2008-11-27 09:14:49.733284', '2008-11-27 09:14:49.733284', 913228011, 1046772351);
INSERT INTO subcategories_users VALUES (831878834, '2008-11-27 09:14:49.761997', '2008-11-27 09:14:49.761997', 913227999, 1046772352);
INSERT INTO subcategories_users VALUES (831878835, '2008-11-27 09:14:49.787897', '2008-11-27 09:14:49.787897', 913227992, 1046772353);
INSERT INTO subcategories_users VALUES (831878836, '2008-11-27 09:14:49.815324', '2008-11-27 09:14:49.815324', 913227991, 1046772354);
INSERT INTO subcategories_users VALUES (831878837, '2008-11-27 09:14:49.842132', '2008-11-27 09:14:49.842132', 913227995, 1046772355);
INSERT INTO subcategories_users VALUES (831878838, '2008-11-27 09:14:49.870315', '2008-11-27 09:14:49.870315', 263204183, 1046772356);
INSERT INTO subcategories_users VALUES (831878839, '2008-11-27 09:14:49.902657', '2008-11-27 09:14:49.902657', 913228012, 1046772357);
INSERT INTO subcategories_users VALUES (831878840, '2008-11-27 09:14:49.929581', '2008-11-27 09:14:49.929581', 913227999, 1046772358);
INSERT INTO subcategories_users VALUES (831878841, '2008-11-27 09:14:49.957405', '2008-11-27 09:14:49.957405', 913228013, 1046772359);
INSERT INTO subcategories_users VALUES (831878842, '2008-11-27 09:14:49.985759', '2008-11-27 09:14:49.985759', 913228014, 1046772360);
INSERT INTO subcategories_users VALUES (831878843, '2008-11-27 09:14:50.098554', '2008-11-27 09:14:50.098554', 913228015, 1046772361);
INSERT INTO subcategories_users VALUES (831878844, '2008-11-27 09:14:50.128553', '2008-11-27 09:14:50.128553', 913228016, 1046772362);
INSERT INTO subcategories_users VALUES (831878845, '2008-11-27 09:14:50.159737', '2008-11-27 09:14:50.159737', 913228017, 1046772363);
INSERT INTO subcategories_users VALUES (831878846, '2008-11-27 09:14:50.191034', '2008-11-27 09:14:50.191034', 913228018, 1046772364);
INSERT INTO subcategories_users VALUES (831878847, '2008-11-27 09:14:50.225819', '2008-11-27 09:14:50.225819', 913228019, 1046772365);
INSERT INTO subcategories_users VALUES (831878848, '2008-11-27 09:14:50.253084', '2008-11-27 09:14:50.253084', 913228006, 1046772366);
INSERT INTO subcategories_users VALUES (831878849, '2008-11-27 09:14:50.278752', '2008-11-27 09:14:50.278752', 913228006, 1046772367);
INSERT INTO subcategories_users VALUES (831878850, '2008-11-27 09:14:50.307246', '2008-11-27 09:14:50.307246', 913228014, 1046772368);
INSERT INTO subcategories_users VALUES (831878851, '2008-11-27 09:14:50.333975', '2008-11-27 09:14:50.333975', 913227997, 1046772369);
INSERT INTO subcategories_users VALUES (831878852, '2008-11-27 09:14:50.359653', '2008-11-27 09:14:50.359653', 913228011, 1046772370);
INSERT INTO subcategories_users VALUES (831878853, '2008-11-27 09:14:50.389456', '2008-11-27 09:14:50.389456', 913228020, 1046772371);
INSERT INTO subcategories_users VALUES (831878854, '2008-11-27 09:14:50.420122', '2008-11-27 09:14:50.420122', 913228008, 1046772372);
INSERT INTO subcategories_users VALUES (831878855, '2008-11-27 09:14:50.448359', '2008-11-27 09:14:50.448359', 913228011, 1046772373);
INSERT INTO subcategories_users VALUES (831878856, '2008-11-27 09:14:50.474476', '2008-11-27 09:14:50.474476', 913228011, 1046772374);
INSERT INTO subcategories_users VALUES (831878857, '2008-11-27 09:14:50.506879', '2008-11-27 09:14:50.506879', 913228021, 1046772375);
INSERT INTO subcategories_users VALUES (831878858, '2008-11-27 09:14:50.619194', '2008-11-27 09:14:50.619194', 913228010, 1046772376);
INSERT INTO subcategories_users VALUES (831878859, '2008-11-27 09:14:50.646695', '2008-11-27 09:14:50.646695', 913228006, 1046772377);
INSERT INTO subcategories_users VALUES (831878860, '2008-11-27 09:14:50.673626', '2008-11-27 09:14:50.673626', 263204183, 1046772378);
INSERT INTO subcategories_users VALUES (831878861, '2008-11-27 09:14:50.702087', '2008-11-27 09:14:50.702087', 913227998, 1046772379);
INSERT INTO subcategories_users VALUES (831878862, '2008-11-27 09:14:50.732396', '2008-11-27 09:14:50.732396', 913228013, 1046772380);
INSERT INTO subcategories_users VALUES (831878863, '2008-11-27 09:14:50.76169', '2008-11-27 09:14:50.76169', 913228011, 1046772381);
INSERT INTO subcategories_users VALUES (831878864, '2008-11-27 09:14:50.790959', '2008-11-27 09:14:50.790959', 913228022, 1046772382);
INSERT INTO subcategories_users VALUES (831878865, '2008-11-27 09:14:50.819531', '2008-11-27 09:14:50.819531', 913228014, 1046772383);
INSERT INTO subcategories_users VALUES (831878866, '2008-11-27 09:14:50.845763', '2008-11-27 09:14:50.845763', 263204183, 1046772384);
INSERT INTO subcategories_users VALUES (831878867, '2008-11-27 09:14:50.871092', '2008-11-27 09:14:50.871092', 263204183, 1046772385);
INSERT INTO subcategories_users VALUES (831878868, '2008-11-27 09:14:50.899005', '2008-11-27 09:14:50.899005', 913228023, 1046772386);
INSERT INTO subcategories_users VALUES (831878869, '2008-11-27 09:14:50.933014', '2008-11-27 09:14:50.933014', 913228023, 1046772387);
INSERT INTO subcategories_users VALUES (831878870, '2008-11-27 09:14:50.960191', '2008-11-27 09:14:50.960191', 913228023, 1046772388);
INSERT INTO subcategories_users VALUES (831878871, '2008-11-27 09:14:50.986159', '2008-11-27 09:14:50.986159', 913228014, 1046772389);
INSERT INTO subcategories_users VALUES (831878872, '2008-11-27 09:14:51.015177', '2008-11-27 09:14:51.015177', 913228014, 1046772390);
INSERT INTO subcategories_users VALUES (831878873, '2008-11-27 09:14:51.041698', '2008-11-27 09:14:51.041698', 913227999, 1046772391);
INSERT INTO subcategories_users VALUES (831878874, '2008-11-27 09:14:51.153654', '2008-11-27 09:14:51.153654', 913228006, 1046772392);
INSERT INTO subcategories_users VALUES (831878875, '2008-11-27 09:14:51.180798', '2008-11-27 09:14:51.180798', 913228011, 1046772393);
INSERT INTO subcategories_users VALUES (831878876, '2008-11-27 09:14:51.207666', '2008-11-27 09:14:51.207666', 913228006, 1046772394);
INSERT INTO subcategories_users VALUES (831878877, '2008-11-27 09:14:51.244364', '2008-11-27 09:14:51.244364', 913228024, 1046772395);
INSERT INTO subcategories_users VALUES (831878878, '2008-11-27 09:14:51.27374', '2008-11-27 09:14:51.27374', 913228011, 1046772396);
INSERT INTO subcategories_users VALUES (831878879, '2008-11-27 09:14:51.303216', '2008-11-27 09:14:51.303216', 913228006, 1046772397);
INSERT INTO subcategories_users VALUES (831878880, '2008-11-27 09:14:51.331286', '2008-11-27 09:14:51.331286', 913227991, 1046772398);
INSERT INTO subcategories_users VALUES (831878881, '2008-11-27 09:14:51.357033', '2008-11-27 09:14:51.357033', 913227998, 1046772399);
INSERT INTO subcategories_users VALUES (831878882, '2008-11-27 09:14:51.384893', '2008-11-27 09:14:51.384893', 913228015, 1046772400);
INSERT INTO subcategories_users VALUES (831878883, '2008-11-27 09:14:51.409774', '2008-11-27 09:14:51.409774', 913228019, 1046772401);
INSERT INTO subcategories_users VALUES (831878884, '2008-11-27 09:14:51.438605', '2008-11-27 09:14:51.438605', 913228016, 1046772402);
INSERT INTO subcategories_users VALUES (831878885, '2008-11-27 09:14:51.466979', '2008-11-27 09:14:51.466979', 913228013, 1046772403);
INSERT INTO subcategories_users VALUES (831878886, '2008-11-27 09:14:51.49265', '2008-11-27 09:14:51.49265', 913228006, 1046772404);
INSERT INTO subcategories_users VALUES (831878887, '2008-11-27 09:14:51.518158', '2008-11-27 09:14:51.518158', 913228014, 1046772405);
INSERT INTO subcategories_users VALUES (831878888, '2008-11-27 09:14:51.54653', '2008-11-27 09:14:51.54653', 913228014, 1046772406);
INSERT INTO subcategories_users VALUES (831878889, '2008-11-27 09:14:51.574539', '2008-11-27 09:14:51.574539', 913228025, 1046772407);
INSERT INTO subcategories_users VALUES (831878890, '2008-11-27 09:14:51.683917', '2008-11-27 09:14:51.683917', 913227997, 1046772408);
INSERT INTO subcategories_users VALUES (831878891, '2008-11-27 09:14:51.710761', '2008-11-27 09:14:51.710761', 913227998, 1046772409);
INSERT INTO subcategories_users VALUES (831878892, '2008-11-27 09:14:51.747528', '2008-11-27 09:14:51.747528', 913228022, 1046772410);
INSERT INTO subcategories_users VALUES (831878893, '2008-11-27 09:14:51.774692', '2008-11-27 09:14:51.774692', 913227999, 1046772411);
INSERT INTO subcategories_users VALUES (831878894, '2008-11-27 09:14:51.8031', '2008-11-27 09:14:51.8031', 913227992, 1046772412);
INSERT INTO subcategories_users VALUES (831878895, '2008-11-27 09:14:51.833618', '2008-11-27 09:14:51.833618', 913227991, 1046772413);
INSERT INTO subcategories_users VALUES (831878896, '2008-11-27 09:14:51.862466', '2008-11-27 09:14:51.862466', 913228026, 1046772414);
INSERT INTO subcategories_users VALUES (831878897, '2008-11-27 09:14:51.888071', '2008-11-27 09:14:51.888071', 913227995, 1046772415);
INSERT INTO subcategories_users VALUES (831878898, '2008-11-27 09:14:51.913923', '2008-11-27 09:14:51.913923', 913228009, 1046772416);
INSERT INTO subcategories_users VALUES (831878899, '2008-11-27 09:14:51.943201', '2008-11-27 09:14:51.943201', 913228027, 1046772417);
INSERT INTO subcategories_users VALUES (831878900, '2008-11-27 09:14:51.973756', '2008-11-27 09:14:51.973756', 263204183, 1046772418);
INSERT INTO subcategories_users VALUES (831878901, '2008-11-27 09:14:52.002959', '2008-11-27 09:14:52.002959', 913228028, 1046772419);
INSERT INTO subcategories_users VALUES (831878902, '2008-11-27 09:14:52.030207', '2008-11-27 09:14:52.030207', 913228013, 1046772420);
INSERT INTO subcategories_users VALUES (831878903, '2008-11-27 09:14:52.057497', '2008-11-27 09:14:52.057497', 913228011, 1046772421);
INSERT INTO subcategories_users VALUES (831878904, '2008-11-27 09:14:52.086503', '2008-11-27 09:14:52.086503', 913228029, 1046772422);
INSERT INTO subcategories_users VALUES (831878905, '2008-11-27 09:14:52.199695', '2008-11-27 09:14:52.199695', 913228030, 1046772423);
INSERT INTO subcategories_users VALUES (831878906, '2008-11-27 09:14:52.227272', '2008-11-27 09:14:52.227272', 913228014, 1046772424);
INSERT INTO subcategories_users VALUES (831878907, '2008-11-27 09:14:52.258', '2008-11-27 09:14:52.258', 913228031, 1046772425);
INSERT INTO subcategories_users VALUES (831878908, '2008-11-27 09:14:52.284464', '2008-11-27 09:14:52.284464', 913228006, 1046772426);
INSERT INTO subcategories_users VALUES (831878909, '2008-11-27 09:14:52.312016', '2008-11-27 09:14:52.312016', 913228010, 1046772427);
INSERT INTO subcategories_users VALUES (831878910, '2008-11-27 09:14:52.343262', '2008-11-27 09:14:52.343262', 913228010, 1046772428);
INSERT INTO subcategories_users VALUES (831878911, '2008-11-27 09:14:52.37024', '2008-11-27 09:14:52.37024', 913227991, 1046772429);
INSERT INTO subcategories_users VALUES (831878912, '2008-11-27 09:14:52.3956', '2008-11-27 09:14:52.3956', 913228006, 1046772430);
INSERT INTO subcategories_users VALUES (831878913, '2008-11-27 09:14:52.421342', '2008-11-27 09:14:52.421342', 913228006, 1046772431);
INSERT INTO subcategories_users VALUES (831878914, '2008-11-27 09:14:52.451948', '2008-11-27 09:14:52.451948', 913228032, 1046772432);
INSERT INTO subcategories_users VALUES (831878915, '2008-11-27 09:14:52.477537', '2008-11-27 09:14:52.477537', 913228031, 1046772433);
INSERT INTO subcategories_users VALUES (831878916, '2008-11-27 09:14:52.505744', '2008-11-27 09:14:52.505744', 913227998, 1046772434);
INSERT INTO subcategories_users VALUES (831878917, '2008-11-27 09:14:52.532173', '2008-11-27 09:14:52.532173', 913227995, 1046772435);
INSERT INTO subcategories_users VALUES (831878918, '2008-11-27 09:14:52.560684', '2008-11-27 09:14:52.560684', 913227999, 1046772436);
INSERT INTO subcategories_users VALUES (831878919, '2008-11-27 09:14:52.587057', '2008-11-27 09:14:52.587057', 913228022, 1046772437);
INSERT INTO subcategories_users VALUES (831878920, '2008-11-27 09:14:52.61214', '2008-11-27 09:14:52.61214', 913227992, 1046772438);
INSERT INTO subcategories_users VALUES (831878921, '2008-11-27 09:14:52.722934', '2008-11-27 09:14:52.722934', 913227999, 1046772439);
INSERT INTO subcategories_users VALUES (831878922, '2008-11-27 09:14:52.752444', '2008-11-27 09:14:52.752444', 913227995, 1046772440);
INSERT INTO subcategories_users VALUES (831878923, '2008-11-27 09:14:52.782119', '2008-11-27 09:14:52.782119', 913228033, 1046772441);
INSERT INTO subcategories_users VALUES (831878924, '2008-11-27 09:14:52.809822', '2008-11-27 09:14:52.809822', 913228034, 1046772442);
INSERT INTO subcategories_users VALUES (831878925, '2008-11-27 09:14:52.839963', '2008-11-27 09:14:52.839963', 913228006, 1046772443);
INSERT INTO subcategories_users VALUES (831878926, '2008-11-27 09:14:52.869348', '2008-11-27 09:14:52.869348', 913228013, 1046772444);
INSERT INTO subcategories_users VALUES (831878927, '2008-11-27 09:14:52.8975', '2008-11-27 09:14:52.8975', 913227991, 1046772445);
INSERT INTO subcategories_users VALUES (831878928, '2008-11-27 09:14:52.929867', '2008-11-27 09:14:52.929867', 913228035, 1046772446);
INSERT INTO subcategories_users VALUES (831878929, '2008-11-27 09:14:52.966891', '2008-11-27 09:14:52.966891', 913228019, 1046772447);
INSERT INTO subcategories_users VALUES (831878930, '2008-11-27 09:14:53.013611', '2008-11-27 09:14:53.013611', 913228035, 1046772448);
INSERT INTO subcategories_users VALUES (831878931, '2008-11-27 09:14:53.044093', '2008-11-27 09:14:53.044093', 913228031, 1046772449);
INSERT INTO subcategories_users VALUES (831878932, '2008-11-27 09:14:53.077663', '2008-11-27 09:14:53.077663', 913227995, 1046772450);
INSERT INTO subcategories_users VALUES (831878933, '2008-11-27 09:14:53.103585', '2008-11-27 09:14:53.103585', 913228006, 1046772451);
INSERT INTO subcategories_users VALUES (831878934, '2008-11-27 09:14:53.131066', '2008-11-27 09:14:53.131066', 913228036, 1046772452);
INSERT INTO subcategories_users VALUES (831878935, '2008-11-27 09:14:53.15739', '2008-11-27 09:14:53.15739', 913227996, 1046772453);
INSERT INTO subcategories_users VALUES (831878936, '2008-11-27 09:14:53.273949', '2008-11-27 09:14:53.273949', 913227992, 1046772454);
INSERT INTO subcategories_users VALUES (831878937, '2008-11-27 09:14:53.301036', '2008-11-27 09:14:53.301036', 913227998, 1046772455);
INSERT INTO subcategories_users VALUES (831878938, '2008-11-27 09:14:53.327472', '2008-11-27 09:14:53.327472', 913227997, 1046772456);
INSERT INTO subcategories_users VALUES (831878939, '2008-11-27 09:14:53.35839', '2008-11-27 09:14:53.35839', 913227993, 1046772457);
INSERT INTO subcategories_users VALUES (831878940, '2008-11-27 09:14:53.389669', '2008-11-27 09:14:53.389669', 913227992, 1046772458);
INSERT INTO subcategories_users VALUES (831878941, '2008-11-27 09:14:53.418617', '2008-11-27 09:14:53.418617', 913228037, 1046772459);
INSERT INTO subcategories_users VALUES (831878942, '2008-11-27 09:14:53.444957', '2008-11-27 09:14:53.444957', 913228006, 1046772460);
INSERT INTO subcategories_users VALUES (831878943, '2008-11-27 09:14:53.472726', '2008-11-27 09:14:53.472726', 913228023, 1046772461);
INSERT INTO subcategories_users VALUES (831878944, '2008-11-27 09:14:53.499061', '2008-11-27 09:14:53.499061', 913227992, 1046772462);
INSERT INTO subcategories_users VALUES (831878945, '2008-11-27 09:14:53.530481', '2008-11-27 09:14:53.530481', 913228038, 1046772463);
INSERT INTO subcategories_users VALUES (831878946, '2008-11-27 09:14:53.558302', '2008-11-27 09:14:53.558302', 913227997, 1046772464);
INSERT INTO subcategories_users VALUES (831878947, '2008-11-27 09:14:53.58692', '2008-11-27 09:14:53.58692', 913228022, 1046772465);
INSERT INTO subcategories_users VALUES (831878948, '2008-11-27 09:14:53.614174', '2008-11-27 09:14:53.614174', 913228039, 1046772466);
INSERT INTO subcategories_users VALUES (831878949, '2008-11-27 09:14:53.640534', '2008-11-27 09:14:53.640534', 913228028, 1046772467);
INSERT INTO subcategories_users VALUES (831878950, '2008-11-27 09:14:53.669006', '2008-11-27 09:14:53.669006', 913228006, 1046772468);
INSERT INTO subcategories_users VALUES (831878951, '2008-11-27 09:14:53.695888', '2008-11-27 09:14:53.695888', 913228014, 1046772469);
INSERT INTO subcategories_users VALUES (831878952, '2008-11-27 09:14:53.811083', '2008-11-27 09:14:53.811083', 913227992, 1046772470);
INSERT INTO subcategories_users VALUES (831878953, '2008-11-27 09:14:53.83907', '2008-11-27 09:14:53.83907', 913228014, 1046772471);
INSERT INTO subcategories_users VALUES (831878954, '2008-11-27 09:14:53.867554', '2008-11-27 09:14:53.867554', 913228032, 1046772472);
INSERT INTO subcategories_users VALUES (831878955, '2008-11-27 09:14:53.897285', '2008-11-27 09:14:53.897285', 913227997, 1046772473);
INSERT INTO subcategories_users VALUES (831878956, '2008-11-27 09:14:53.925869', '2008-11-27 09:14:53.925869', 913227999, 1046772474);
INSERT INTO subcategories_users VALUES (831878957, '2008-11-27 09:14:53.952431', '2008-11-27 09:14:53.952431', 913228010, 1046772475);
INSERT INTO subcategories_users VALUES (831878958, '2008-11-27 09:14:53.980811', '2008-11-27 09:14:53.980811', 913228006, 1046772476);
INSERT INTO subcategories_users VALUES (831878959, '2008-11-27 09:14:54.006797', '2008-11-27 09:14:54.006797', 913228022, 1046772477);
INSERT INTO subcategories_users VALUES (831878960, '2008-11-27 09:14:54.033202', '2008-11-27 09:14:54.033202', 913228023, 1046772478);
INSERT INTO subcategories_users VALUES (831878961, '2008-11-27 09:14:54.066736', '2008-11-27 09:14:54.066736', 263204183, 1046772479);
INSERT INTO subcategories_users VALUES (831878962, '2008-11-27 09:14:54.094788', '2008-11-27 09:14:54.094788', 913228006, 1046772480);
INSERT INTO subcategories_users VALUES (831878963, '2008-11-27 09:14:54.12058', '2008-11-27 09:14:54.12058', 913228006, 1046772481);
INSERT INTO subcategories_users VALUES (831878964, '2008-11-27 09:14:54.147225', '2008-11-27 09:14:54.147225', 913228010, 1046772482);
INSERT INTO subcategories_users VALUES (831878965, '2008-11-27 09:14:54.175833', '2008-11-27 09:14:54.175833', 913228010, 1046772483);
INSERT INTO subcategories_users VALUES (831878966, '2008-11-27 09:14:54.201516', '2008-11-27 09:14:54.201516', 913228034, 1046772484);
INSERT INTO subcategories_users VALUES (831878967, '2008-11-27 09:14:54.230601', '2008-11-27 09:14:54.230601', 913228017, 1046772485);
INSERT INTO subcategories_users VALUES (831878968, '2008-11-27 09:14:54.347464', '2008-11-27 09:14:54.347464', 913228040, 1046772486);
INSERT INTO subcategories_users VALUES (831878969, '2008-11-27 09:14:54.377554', '2008-11-27 09:14:54.377554', 913228023, 1046772487);
INSERT INTO subcategories_users VALUES (831878970, '2008-11-27 09:14:54.405964', '2008-11-27 09:14:54.405964', 913228041, 1046772488);
INSERT INTO subcategories_users VALUES (831878971, '2008-11-27 09:14:54.434557', '2008-11-27 09:14:54.434557', 913228042, 1046772489);
INSERT INTO subcategories_users VALUES (831878972, '2008-11-27 09:14:54.469136', '2008-11-27 09:14:54.469136', 913227992, 1046772490);
INSERT INTO subcategories_users VALUES (831878973, '2008-11-27 09:14:54.496016', '2008-11-27 09:14:54.496016', 913228012, 1046772491);
INSERT INTO subcategories_users VALUES (831878974, '2008-11-27 09:14:54.52092', '2008-11-27 09:14:54.52092', 913227998, 1046772492);
INSERT INTO subcategories_users VALUES (831878975, '2008-11-27 09:14:54.547562', '2008-11-27 09:14:54.547562', 913228028, 1046772493);
INSERT INTO subcategories_users VALUES (831878976, '2008-11-27 09:14:54.576292', '2008-11-27 09:14:54.576292', 913228015, 1046772494);
INSERT INTO subcategories_users VALUES (831878977, '2008-11-27 09:14:54.603989', '2008-11-27 09:14:54.603989', 913228043, 1046772495);
INSERT INTO subcategories_users VALUES (831878978, '2008-11-27 09:14:54.63554', '2008-11-27 09:14:54.63554', 913228044, 1046772496);
INSERT INTO subcategories_users VALUES (831878979, '2008-11-27 09:14:54.665313', '2008-11-27 09:14:54.665313', 913228045, 1046772497);
INSERT INTO subcategories_users VALUES (831878980, '2008-11-27 09:14:54.693873', '2008-11-27 09:14:54.693873', 913228004, 1046772498);
INSERT INTO subcategories_users VALUES (831878981, '2008-11-27 09:14:54.720523', '2008-11-27 09:14:54.720523', 913227998, 1046772499);
INSERT INTO subcategories_users VALUES (831878982, '2008-11-27 09:14:54.750436', '2008-11-27 09:14:54.750436', 913228011, 1046772500);
INSERT INTO subcategories_users VALUES (831878983, '2008-11-27 09:14:54.862317', '2008-11-27 09:14:54.862317', 913227998, 1046772501);
INSERT INTO subcategories_users VALUES (831878984, '2008-11-27 09:14:54.894654', '2008-11-27 09:14:54.894654', 913228046, 1046772502);
INSERT INTO subcategories_users VALUES (831878985, '2008-11-27 09:14:54.923469', '2008-11-27 09:14:54.923469', 913228047, 1046772503);
INSERT INTO subcategories_users VALUES (831878986, '2008-11-27 09:14:54.952908', '2008-11-27 09:14:54.952908', 913227992, 1046772504);
INSERT INTO subcategories_users VALUES (831878987, '2008-11-27 09:14:54.989036', '2008-11-27 09:14:54.989036', 913228048, 1046772505);
INSERT INTO subcategories_users VALUES (831878988, '2008-11-27 09:14:55.015805', '2008-11-27 09:14:55.015805', 913227992, 1046772506);
INSERT INTO subcategories_users VALUES (831878989, '2008-11-27 09:14:55.042497', '2008-11-27 09:14:55.042497', 913228019, 1046772507);
INSERT INTO subcategories_users VALUES (831878990, '2008-11-27 09:14:55.071435', '2008-11-27 09:14:55.071435', 913228004, 1046772508);
INSERT INTO subcategories_users VALUES (831878991, '2008-11-27 09:14:55.098191', '2008-11-27 09:14:55.098191', 913227992, 1046772509);
INSERT INTO subcategories_users VALUES (831878992, '2008-11-27 09:14:55.126095', '2008-11-27 09:14:55.126095', 913227995, 1046772510);
INSERT INTO subcategories_users VALUES (831878993, '2008-11-27 09:14:55.154863', '2008-11-27 09:14:55.154863', 913227992, 1046772511);
INSERT INTO subcategories_users VALUES (831878994, '2008-11-27 09:14:55.183989', '2008-11-27 09:14:55.183989', 913228014, 1046772512);
INSERT INTO subcategories_users VALUES (831878995, '2008-11-27 09:14:55.211872', '2008-11-27 09:14:55.211872', 913228009, 1046772513);
INSERT INTO subcategories_users VALUES (831878996, '2008-11-27 09:14:55.241058', '2008-11-27 09:14:55.241058', 913228006, 1046772514);
INSERT INTO subcategories_users VALUES (831878997, '2008-11-27 09:14:55.267381', '2008-11-27 09:14:55.267381', 913228010, 1046772515);
INSERT INTO subcategories_users VALUES (831878998, '2008-11-27 09:14:55.295581', '2008-11-27 09:14:55.295581', 913227997, 1046772516);
INSERT INTO subcategories_users VALUES (831878999, '2008-11-27 09:14:55.40924', '2008-11-27 09:14:55.40924', 913228016, 1046772517);
INSERT INTO subcategories_users VALUES (831879000, '2008-11-27 09:14:55.436157', '2008-11-27 09:14:55.436157', 913228006, 1046772518);
INSERT INTO subcategories_users VALUES (831879001, '2008-11-27 09:14:55.462948', '2008-11-27 09:14:55.462948', 913227995, 1046772519);
INSERT INTO subcategories_users VALUES (831879002, '2008-11-27 09:14:55.495768', '2008-11-27 09:14:55.495768', 913228006, 1046772520);
INSERT INTO subcategories_users VALUES (831879003, '2008-11-27 09:14:55.522537', '2008-11-27 09:14:55.522537', 913227999, 1046772521);
INSERT INTO subcategories_users VALUES (831879004, '2008-11-27 09:14:55.548978', '2008-11-27 09:14:55.548978', 913228021, 1046772522);
INSERT INTO subcategories_users VALUES (831879005, '2008-11-27 09:14:55.575784', '2008-11-27 09:14:55.575784', 913227992, 1046772523);
INSERT INTO subcategories_users VALUES (831879006, '2008-11-27 09:14:55.602767', '2008-11-27 09:14:55.602767', 913228014, 1046772524);
INSERT INTO subcategories_users VALUES (831879007, '2008-11-27 09:14:55.628383', '2008-11-27 09:14:55.628383', 913227999, 1046772525);
INSERT INTO subcategories_users VALUES (831879008, '2008-11-27 09:14:55.656155', '2008-11-27 09:14:55.656155', 913228001, 1046772526);
INSERT INTO subcategories_users VALUES (831879009, '2008-11-27 09:14:55.686619', '2008-11-27 09:14:55.686619', 913228017, 1046772527);
INSERT INTO subcategories_users VALUES (831879010, '2008-11-27 09:14:55.714344', '2008-11-27 09:14:55.714344', 913228014, 1046772528);
INSERT INTO subcategories_users VALUES (831879011, '2008-11-27 09:14:55.742463', '2008-11-27 09:14:55.742463', 913228011, 1046772529);
INSERT INTO subcategories_users VALUES (831879012, '2008-11-27 09:14:55.768768', '2008-11-27 09:14:55.768768', 913228016, 1046772530);
INSERT INTO subcategories_users VALUES (831879013, '2008-11-27 09:14:55.796592', '2008-11-27 09:14:55.796592', 913228006, 1046772531);
INSERT INTO subcategories_users VALUES (831879014, '2008-11-27 09:14:55.821298', '2008-11-27 09:14:55.821298', 913227997, 1046772532);
INSERT INTO subcategories_users VALUES (831879015, '2008-11-27 09:14:55.938125', '2008-11-27 09:14:55.938125', 913228049, 1046772533);
INSERT INTO subcategories_users VALUES (831879016, '2008-11-27 09:14:55.965291', '2008-11-27 09:14:55.965291', 913227992, 1046772534);
INSERT INTO subcategories_users VALUES (831879017, '2008-11-27 09:14:55.99536', '2008-11-27 09:14:55.99536', 913228032, 1046772535);
INSERT INTO subcategories_users VALUES (831879018, '2008-11-27 09:14:56.027501', '2008-11-27 09:14:56.027501', 913228006, 1046772536);
INSERT INTO subcategories_users VALUES (831879019, '2008-11-27 09:14:56.053981', '2008-11-27 09:14:56.053981', 913228010, 1046772537);
INSERT INTO subcategories_users VALUES (831879020, '2008-11-27 09:14:56.082216', '2008-11-27 09:14:56.082216', 913227992, 1046772538);
INSERT INTO subcategories_users VALUES (831879021, '2008-11-27 09:14:56.107992', '2008-11-27 09:14:56.107992', 913228010, 1046772539);
INSERT INTO subcategories_users VALUES (831879022, '2008-11-27 09:14:56.136469', '2008-11-27 09:14:56.136469', 913228050, 1046772540);
INSERT INTO subcategories_users VALUES (831879023, '2008-11-27 09:14:56.164003', '2008-11-27 09:14:56.164003', 913228051, 1046772541);
INSERT INTO subcategories_users VALUES (831879024, '2008-11-27 09:14:56.198256', '2008-11-27 09:14:56.198256', 913228052, 1046772542);
INSERT INTO subcategories_users VALUES (831879025, '2008-11-27 09:14:56.226545', '2008-11-27 09:14:56.226545', 913227998, 1046772543);
INSERT INTO subcategories_users VALUES (831879026, '2008-11-27 09:14:56.257456', '2008-11-27 09:14:56.257456', 913228053, 1046772544);
INSERT INTO subcategories_users VALUES (831879027, '2008-11-27 09:14:56.288126', '2008-11-27 09:14:56.288126', 913228012, 1046772545);
INSERT INTO subcategories_users VALUES (831879028, '2008-11-27 09:14:56.315212', '2008-11-27 09:14:56.315212', 913228006, 1046772546);
INSERT INTO subcategories_users VALUES (831879029, '2008-11-27 09:14:56.34179', '2008-11-27 09:14:56.34179', 913228014, 1046772547);
INSERT INTO subcategories_users VALUES (831879030, '2008-11-27 09:14:56.456521', '2008-11-27 09:14:56.456521', 913227995, 1046772548);


--
-- Data for Name: taggings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO taggings VALUES (984775210, 692675549, 984775210, 'Article');
INSERT INTO taggings VALUES (913227991, 913227991, 913227991, 'Article');


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO tags VALUES (984775210, 'acupuncture');
INSERT INTO tags VALUES (913227991, 'yoga');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO users VALUES (812569211, 'Roger', 'Moore', 'moore@jolly.co.nz', '261fd559c11e3931bd9f87fe8babb4ee8b196c56', '356a192b7913b04c54574d18c28d46e6395428ab', '77de68daecd823babbb58edb1c8e14d7106e83bb', NULL, 'active', '2008-11-28 22:14:00', '2008-11-22 09:14:47', NULL, '2008-11-22 09:14:47', '2008-11-27 09:14:47', 880982500, true, true, false, NULL, '23 Queen St', 'One tree Hill', NULL, 211474625, '03 333 44444', '021 567 234');
INSERT INTO users VALUES (851558154, 'Stephanie', 'Gardiner', 'peaceofmind2@xtra.co.nz', '261fd559c11e3931bd9f87fe8babb4ee8b196c56', '356a192b7913b04c54574d18c28d46e6395428ab', '77de68daecd823babbb58edb1c8e14d7106e83bb', NULL, 'active', '2008-11-28 22:14:00', '2008-11-22 09:14:47', NULL, '2008-11-22 09:14:47', '2008-11-27 09:14:47', 880982500, true, true, false, 'Peace of Mind Clinical Hypnotherapy', '5/21 Humphreys Drive', 'Heathcote', NULL, 266910087, '03 384 8506', '021 313 161');
INSERT INTO users VALUES (289014436, 'Norma', 'Stein', 'norma2@eurekacoaching.co.nz', '261fd559c11e3931bd9f87fe8babb4ee8b196c56', '356a192b7913b04c54574d18c28d46e6395428ab', '77de68daecd823babbb58edb1c8e14d7106e83bb', NULL, 'active', '2008-11-28 22:14:00', '2008-11-22 09:14:47', NULL, '2008-11-22 09:14:47', '2008-11-27 09:14:47', 408794758, true, true, false, NULL, NULL, NULL, NULL, 583778593, NULL, NULL);
INSERT INTO users VALUES (1046772323, 'Aaron', 'McLoughlin', 'office2@vervecreative.co.nz', '261fd559c11e3931bd9f87fe8babb4ee8b196c56', '356a192b7913b04c54574d18c28d46e6395428ab', '77de68daecd823babbb58edb1c8e14d7106e83bb', NULL, 'active', '2008-11-28 22:14:00', '2008-11-22 09:14:47', NULL, '2008-11-22 09:14:47', '2008-11-27 09:14:47', 880982500, true, true, false, 'Verve Creative', '23 Queen St', 'One tree Hill', NULL, 266910087, '03 333 44444', '021 567 234');
INSERT INTO users VALUES (1046772324, 'Stephanie', 'Gardiner', 'peaceofmind@xtra.co.nz', 'c0e4dfe2ab5e8bc1f1be910a501e892de625865a', '292624e420c2b9fbe2006b369299d705ff238fe6', NULL, NULL, 'active', NULL, '2008-11-27 09:14:48.705756', NULL, '2008-11-27 09:14:48.665621', '2008-11-27 09:14:48.706754', 880982500, true, true, false, 'Peace of Mind Clinical Hypnotherapy', '5/21 Humphreys Drive', 'Heathcote', NULL, 266910087, '03 384 8506', '021 313 161');
INSERT INTO users VALUES (1046772325, 'Aaron', 'McLoughlin', 'office@vervecreative.co.nz', '0d7247d2a702c53b1c2d4e5c44f9532f97d45c32', '8e20aa952bdf0de1107525ad6504872e0fe30ee3', NULL, NULL, 'active', NULL, '2008-11-27 09:14:48.761187', NULL, '2008-11-27 09:14:48.751354', '2008-11-27 09:14:48.761946', 151679809, true, true, true, 'Verve Creative', NULL, 'Oneroa', NULL, 1030444543, '0508 327 486', '027 560 0094');
INSERT INTO users VALUES (1046772326, 'Adrian', 'Metcalfe', 'marstonhouse@kol.co.nz', '95074b09a3a87a7dab70025e28c96aa593462deb', '327a024011ab765d0f459e4e2cb5d30c0642f021', NULL, NULL, 'active', NULL, '2008-11-27 09:14:48.797903', NULL, '2008-11-27 09:14:48.786896', '2008-11-27 09:14:48.798619', 880982500, true, true, true, 'Marston Health Clinic', NULL, NULL, NULL, 266910087, '03 327 4041', '-');
INSERT INTO users VALUES (1046772327, 'Aida', 'Warrenhiven', 'enquiries@skinworks.co.nz', '5a68620c56643fd3aaea7e2b27a3b05922293ef7', 'b10394ac50a13523cf10a6fd4b31efa34ac66e4e', NULL, NULL, 'active', NULL, '2008-11-27 09:14:48.829959', NULL, '2008-11-27 09:14:48.820178', '2008-11-27 09:14:48.830686', 880982500, true, true, true, 'Skinworks', NULL, NULL, NULL, 266910087, '03 379 0606', '-');
INSERT INTO users VALUES (1046772328, 'Aisling', 'Shea', 'reikiparnell@hotmail.com', '943d95a304d4d24a2a3e394fddf66b8279aa3d46', 'a732d76508dcf32f7f91d6882337dac7bf12870a', NULL, NULL, 'active', NULL, '2008-11-27 09:14:48.858141', NULL, '2008-11-27 09:14:48.848719', '2008-11-27 09:14:48.85891', 151679809, true, true, true, 'Reiki on Parnell', '8 Weston Ave', 'Parnell', NULL, 1030444527, '-', '021 529 667');
INSERT INTO users VALUES (1046772329, 'Albino', 'Gola', 'ar_gola@clear.net.nz', '2c77406ec1745d011889bbf7f9e1fc66c13016c9', '0beea62d50f61d32ad4617988b2b9ed9f45180a9', NULL, NULL, 'active', NULL, '2008-11-27 09:14:48.887414', NULL, '2008-11-27 09:14:48.876507', '2008-11-27 09:14:48.888181', 151679809, true, true, true, 'Albino Gola', NULL, NULL, NULL, 1030444527, '09 638 8622', '-');
INSERT INTO users VALUES (1046772330, 'Alice', 'Latham', 'pilates@nzsites.com', '0790306b809746e602a779daf141ee0a877f77c7', '1a67b715033f14fbb90d93b0b5c439421d04be6c', NULL, NULL, 'active', NULL, '2008-11-27 09:14:48.918493', NULL, '2008-11-27 09:14:48.907997', '2008-11-27 09:14:48.919282', 408794758, true, true, true, 'Pilates Ex Speciaists', 'L3 99 WillisStreet', NULL, NULL, 583778593, '04 472 1907', '027 635 0540');
INSERT INTO users VALUES (1046772331, 'Alice', 'Maguire', 'alicemaguire@hotmail.com', 'de3e2b776b9eec6f7329380939aa9e04d0fc6b00', '6898511f314a05fd419537b755df02d78afaf5b8', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.035326', NULL, '2008-11-27 09:14:49.023887', '2008-11-27 09:14:49.036105', 408794758, true, true, true, 'Head to Toe Therapies', '27/4 Drummond Street', 'Mt Cook', NULL, 583778593, '-', '021 217 4043');
INSERT INTO users VALUES (1046772332, 'Alison', 'Gallate', 'gallate@paradise.net.nz', '83443f65e2b99489065f2518c328f762e6a30b96', 'e76e146b6152efdd486921a3a8c3c42bb0e94143', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.065659', NULL, '2008-11-27 09:14:49.054839', '2008-11-27 09:14:49.066429', 880982500, true, true, true, 'Evolution NLP Consultancy & Coaching', NULL, NULL, NULL, 266910087, '03 981 4657', '-');
INSERT INTO users VALUES (1046772333, 'Alison', 'Mountfort', 'alison@thinklifecoaching.co.nz', 'ca73aaee8abf63e0ea24fc90735e446bba69d60b', '0fc9c8ba89b2c7312f97d654ce5d5dc59fc76837', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.095852', NULL, '2008-11-27 09:14:49.083246', '2008-11-27 09:14:49.096744', 880982500, true, true, true, 'Think Life Coaching', NULL, NULL, NULL, 266910087, '03 981 1650', '-');
INSERT INTO users VALUES (1046772334, 'Alistair', 'McKenzie', '2letgo@gmail.com', '7c4d7ba671b4ec75644a21a6b2f5f0d7922cc5bd', '7d2006143531dbc6f0971f14840a708c8f0e2a8e', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.132828', NULL, '2008-11-27 09:14:49.120788', '2008-11-27 09:14:49.133625', 880982500, true, true, true, 'McKenzie Alistair', NULL, NULL, NULL, 266910087, '03 960 7222', '-');
INSERT INTO users VALUES (1046772335, 'Alistair', 'Radford', 'info@yogaindailylife.org.nz', '80efe2e85236876e4273c2aa60a54e3d888ef4f4', '6acb26d2f02633afcb65816fbd5acd7fd2831c17', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.159075', NULL, '2008-11-27 09:14:49.149673', '2008-11-27 09:14:49.159814', 408794758, false, true, true, 'Alistair Radford', NULL, NULL, NULL, 583778593, '04 801 7012', '-');
INSERT INTO users VALUES (1046772336, 'Allan', 'Fayter', 'info@optimum-mind.co.nz', 'f80cf06074907973416f3d01e9667578f9ea0c62', 'e6281ff307ae4324575c1330100be2c055240118', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.190133', NULL, '2008-11-27 09:14:49.178372', '2008-11-27 09:14:49.190955', 880982500, true, true, true, 'Optimum Mind', NULL, NULL, NULL, 266910087, '03 942 2103', '-');
INSERT INTO users VALUES (1046772337, 'Amanda', 'Reid', 'samadhiyoga@paradise.net.nz', 'e43824506dfe0ab7828737661905bc23b982fed1', '1c7ff081db5314027160686660f3ffa127ab95ed', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.219782', NULL, '2008-11-27 09:14:49.208952', '2008-11-27 09:14:49.220467', 408794758, false, true, true, 'Amanda Reid', NULL, NULL, NULL, 583778593, '04 905 1503', '-');
INSERT INTO users VALUES (1046772338, 'Anastasia', 'Benaki', 'abenaki@xtra.co.nz', '685f65a2fd2fe5bbc991c2e1d15165f326560b7d', 'c19b4f7b65b8c97f6b3c001c83b3d8403dfd2b50', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.247164', NULL, '2008-11-27 09:14:49.236146', '2008-11-27 09:14:49.248173', 408794758, false, true, true, 'Anastasia Benaki', NULL, NULL, NULL, 583778593, '-', '021 709 242');
INSERT INTO users VALUES (1046772339, 'Andrew', 'Thiele', 'andrewthiele@lifecoach.org.nz', '866736210a36f363648e4aaaaca96dfdcc2cef7d', 'a2b115fb455e10c27e9e972004ff1fb5f85d1e6d', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.277666', NULL, '2008-11-27 09:14:49.267509', '2008-11-27 09:14:49.278528', 880982500, true, true, true, 'Andrew Thiele - Life Coach', '596 Ferry Road', NULL, NULL, 266910087, '03 385 5745', '021 121 7846');
INSERT INTO users VALUES (1046772340, 'Angela', 'Baines', 'angela.baines@paradise.net', 'f4ec5c07c860ae744ce0f54a7620c8983d135881', '4be0353a43b2596b8eee2ff415ef3cec6dbb16cd', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.310489', NULL, '2008-11-27 09:14:49.299846', '2008-11-27 09:14:49.311273', 408794758, true, true, true, 'Origin Health', '1 Horopito Road', 'Waikanae', NULL, 1030444601, '04 905 1451', '021 110 3239');
INSERT INTO users VALUES (1046772341, 'Anna', 'Deng', 'annadc@sohu.com', '3d0b81d358d1c9468f6d3f1ca7fb15f97b1ca245', '0aacdd07b0ff6c6bbd90db3d505ccacac2b3d10b', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.336656', NULL, '2008-11-27 09:14:49.326513', '2008-11-27 09:14:49.337771', 880982500, true, true, true, 'Able Acupuncture', NULL, NULL, NULL, 266910087, '03 357 9528', '-');
INSERT INTO users VALUES (1046772342, 'Anna', 'Roughan', 'annaroughan@clear.net.nz', 'a304dd44a98def464894ba033733fccf28b67a81', 'a93948ebd59ca878ab356db8f1d9772b30b042d2', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.370698', NULL, '2008-11-27 09:14:49.357569', '2008-11-27 09:14:49.371407', 880982500, true, true, true, 'Roughan Massage Therapy', NULL, NULL, NULL, 266910087, '03 365 7828', '-');
INSERT INTO users VALUES (1046772343, 'Anne ', 'Batcher', 'bodynsport@yahoo.com', '3632707a294efa92efad7ee0f99b439bb51d65ee', 'ef570ce8f48c95d1a3c4d0ff3ccb8878f9cbbe39', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.402749', NULL, '2008-11-27 09:14:49.393241', '2008-11-27 09:14:49.403554', 880982500, true, true, true, 'Body & Sport Massage Therapy', NULL, NULL, NULL, 266910087, '-', '021 406 402');
INSERT INTO users VALUES (1046772344, 'Anne ', 'van Den Bergh', 'anne@yogasanctuary.co.nz', 'd1f9e1870c2476ae830957d048e9192c114968ad', 'fbe096c50738e800a5c9a71b506505137fde2876', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.42872', NULL, '2008-11-27 09:14:49.418917', '2008-11-27 09:14:49.429438', 151679809, true, true, true, 'Yoga Sanctuary', '16 Maxwelton Dr', 'Mairangi Bay', NULL, 1030444541, '09 479 3888', '-');
INSERT INTO users VALUES (1046772345, 'Anne ', 'Young', 'admin@peoplecoachingpeople.co.nz', '36ebbfaebea9e620c351853c8efaa90b67d06a57', '8b514992878484508184cc55509380266349ae85', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.454694', NULL, '2008-11-27 09:14:49.445229', '2008-11-27 09:14:49.455353', 151679809, true, true, true, 'People Coaching PeopleCo', 'PO Box17-093 or 25218?', NULL, NULL, 1030444527, '-', '021 2014609');
INSERT INTO users VALUES (1046772346, 'Anneliese', 'Kuegler', 'anneliesekuegler@gmail.com', '753d84082cfe82a5dbd1aa35af360d1b89031a95', '2e6e7de084459030694ce651a630fec9cc9b9ec8', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.568872', NULL, '2008-11-27 09:14:49.558562', '2008-11-27 09:14:49.56969', 151679809, true, true, true, 'Anneliese Kuegler', 'PO Box 39751', 'Kingsland', NULL, 1030444527, '-', '021 066 7765');
INSERT INTO users VALUES (1046772347, 'Annette', 'Davidson', 'annette@bodysystems.co.nz', '0a95a8d7c727498566df0512d8eee53f0d04b3bd', '4ba4b94810905f1f22cd3c77cb26d9e548312a6d', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.599747', NULL, '2008-11-27 09:14:49.588242', '2008-11-27 09:14:49.600607', 408794758, true, true, false, 'Body Systems', '368 Tinakori Road', 'Thorndon', NULL, 583778593, '04 499 7515', '-');
INSERT INTO users VALUES (1046772348, 'Annette', 'K', 'mysticsnz@hotmail.com', '930b93b92c1bdd4bf911821ebfccbc1e916dc959', '042298c63f365941a2646da861ea2066943d4c58', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.633279', NULL, '2008-11-27 09:14:49.621147', '2008-11-27 09:14:49.634111', 880982500, true, true, true, 'Annette K', NULL, 'Burwood', NULL, 266910087, '-', '021 1128484');
INSERT INTO users VALUES (1046772349, 'Ann-Marie', 'McAndrew', 'mcandrew.neuromuscular@xtra.co.nz', '33d2b7a0888ef824194d162d49d13e458d277a21', 'b73ac97ef65c2c523409177386953af8955e675b', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.663284', NULL, '2008-11-27 09:14:49.653063', '2008-11-27 09:14:49.664094', 408794758, true, true, true, 'McAndrew Natural Health Therapy', 'Lev 1 Johnsonville Medical Centre', 'Johnsonville', NULL, 583778593, '04 920 0978', '021 234 0430');
INSERT INTO users VALUES (1046772350, 'Anya', 'Nidd', 'anya_nidd@earthling.net', 'a9f6d6618e27f7e515bc40178275aa6c0a0012e2', '943bf9afc26a4164f337887a1c773a67863f37f3', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.69142', NULL, '2008-11-27 09:14:49.68187', '2008-11-27 09:14:49.692206', 408794758, false, true, true, 'Anya Nidd', NULL, NULL, NULL, 583778593, '-', '021 257 6116');
INSERT INTO users VALUES (1046772351, 'April', 'Campbell', 'rebalance@paradise.net.nz', '1f01d40330807a10d58c4d93218d620db9ac289f', '0fe208fb6aa96ddab0ec712bfb23bedae2ee250f', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.722623', NULL, '2008-11-27 09:14:49.711966', '2008-11-27 09:14:49.723441', 408794758, false, true, true, 'April Campbell', NULL, NULL, NULL, 583778593, '04 905 1037', '-');
INSERT INTO users VALUES (1046772352, 'Averil ', 'Maher', 'stressless@xtra.co.nz', 'd88f4e5e44bf94603d3a4e9c46bb4424fa0e3104', '5e8a53e21ee1c6ea61e7b8dea85288bd1d6b29b7', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.752476', NULL, '2008-11-27 09:14:49.742038', '2008-11-27 09:14:49.753205', 408794758, true, true, true, 'Stressless', '158 Peka Peka Road', 'Peka Peka', NULL, 1030444601, '04 293 3232', '021 150 4722');
INSERT INTO users VALUES (1046772353, 'Barbara', 'Clegg', 'barbara@walkyourtalkinternational.co.nz', 'b69b33a9f8bc40fc057b0c0457d8d14db5bbf54c', 'a1173aff1db4bc03006034bd7d05abf43ac058bf', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.779131', NULL, '2008-11-27 09:14:49.769486', '2008-11-27 09:14:49.779985', 880982500, true, true, true, 'Walk Your Talk Intl Ltd.', NULL, 'Waimakariri', NULL, 1030444625, '03 313 0521', '-');
INSERT INTO users VALUES (1046772354, 'Barbara', 'Coley', 'barbara@soulintegration.co.nz', 'aca800bbd72bd34bca370059f963066d5ff9852e', 'eaff7f154e87ed10421c3ee54e5bca423f33ffc7', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.806007', NULL, '2008-11-27 09:14:49.79501', '2008-11-27 09:14:49.806847', 151679809, true, true, true, 'Soul Integration', '14 Horotutu Road', 'Grey Lynn', NULL, 1030444527, '09 360 8869', '021 170 2640');
INSERT INTO users VALUES (1046772355, 'Barbara', 'Hedger', 'whitewolfnz@hotmail.com', '46aea9c8cf84d81c3172e9c8517f069c709f0c3c', 'c828215563415f45e3e8c75363c16425b6851a76', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.832728', NULL, '2008-11-27 09:14:49.822972', '2008-11-27 09:14:49.833535', 647785004, true, true, true, 'Crystal Harmony Ltd.', 'Cherry Tree Place, Ohau, RD20', 'Horowhenua', NULL, 1030444591, '06 368 7234', '021 435285');
INSERT INTO users VALUES (1046772356, 'Barron', ' Braden', 'trance@clear.net.nz', '02f6d91e9d5bb2532dc056107f0be7282d774363', '932a14a7f5350cda6b662f48ae44517ab7c192e3', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.859416', NULL, '2008-11-27 09:14:49.849584', '2008-11-27 09:14:49.860109', 151679809, true, true, true, 'TranceFormations Hypnotherapy', NULL, 'Piha', NULL, 1030444544, '09 8129007', '027 444 9766');
INSERT INTO users VALUES (1046772357, 'Beth', 'Jones', 'tides@paradise.net.nz', '98d435763370a334f6eb0a452a6b6dd324b3d8d9', '834066edc44be7ad792835d03202bb6c0b6699e3', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.891305', NULL, '2008-11-27 09:14:49.880311', '2008-11-27 09:14:49.891982', 408794758, true, true, true, 'Beth Jones', '108a Darlington Road', 'Miramar', NULL, 583778593, '04 934 2389', '027 3244 842');
INSERT INTO users VALUES (1046772358, 'Bob', 'Cavanagh', 'bob@bobcavanagh.co.nz', '765ad8be04e84d9e00664ee7cf8b3d9d8b2165f1', 'e146d5320de25be92729a1eaf21ab4423ac0ff6e', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.920778', NULL, '2008-11-27 09:14:49.911188', '2008-11-27 09:14:49.92144', 408794758, true, true, true, 'Bob Cavanagh', NULL, NULL, NULL, 583778593, '04 934 2492', '021 406 260');
INSERT INTO users VALUES (1046772359, 'Brian ', 'Lamb', 'lambkinz@xtra.co.nz', '9f8934bdc52d4ed9b42eb93dc0699aa0ecd68cc2', 'b53178372253ae7f3841d08d52495c65eada23bb', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.94853', NULL, '2008-11-27 09:14:49.939106', '2008-11-27 09:14:49.949264', 844805764, true, true, true, 'Your Mind', '451 Muhunoa East Road', NULL, NULL, 1030444573, '06 863 2280', '027 4717772');
INSERT INTO users VALUES (1046772360, 'Bron', 'Deed', 'homeopathyplus@ihug.co.nz', '187485c253063d68f692d0ef6cf0d0d9e8180a29', 'be0bfecce0bc036e1a9b62fb973ce03757f2cb49', NULL, NULL, 'active', NULL, '2008-11-27 09:14:49.976412', NULL, '2008-11-27 09:14:49.966667', '2008-11-27 09:14:49.977147', 151679809, true, true, true, 'Bron Deed', NULL, NULL, NULL, 1030444527, '09 810 7188', '-');
INSERT INTO users VALUES (1046772361, 'Bruce', 'Harper', 'wellness4u@xtra.co.nz', '41a0d85ee8561aa75e523371f52bbf423851159c', '0687b4042285eb0aa401d2dde172d5bee728378f', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.087803', NULL, '2008-11-27 09:14:49.995598', '2008-11-27 09:14:50.088523', 151679809, true, true, true, 'Wellness4u Clinic Ltd', '782a Remuera Road', 'Remuera', NULL, 1030444527, '09 522 2225', '-');
INSERT INTO users VALUES (1046772362, 'Camilla', 'Watson', 'watson.c.s@paradise.net.nz', 'a4089766313cb9ec0abe6fd66391edb8754cd3ac', 'c6a383f5dfe20bcae02985a4348968f31b7c20cd', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.119117', NULL, '2008-11-27 09:14:50.10933', '2008-11-27 09:14:50.119895', 408794758, true, true, false, 'Psychic Development', 'level 6, 75 Ghuznee Street', NULL, NULL, 583778593, '04 234 7522', '-');
INSERT INTO users VALUES (1046772363, 'Carmel', 'Hotai Cochrane', 'carmelhotai@xtra.co.nz', '7c850dc17fe0ba072209fc6c066f88fb8a686b21', 'e09319a3de6bdcf46ca8f81753eee82955837df6', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.148325', NULL, '2008-11-27 09:14:50.138609', '2008-11-27 09:14:50.149294', 151679809, true, true, true, 'Manaki Wellbeing', '10 Richborne Street', 'Kingsland', NULL, 1030444527, '09 845 8048', '-');
INSERT INTO users VALUES (1046772364, 'Catherine', 'Falconer', 'arborvitae2004@yahoo.com.au', '723807c758758748ffa7e174ac16ea8aa29fabbc', '6121aa6fc978770b34e4c63f8431d700d4ab3221', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.181088', NULL, '2008-11-27 09:14:50.171052', '2008-11-27 09:14:50.181883', 408794758, true, true, false, 'Arborvitae', NULL, NULL, NULL, 583778593, '04 977 9435', '027 300 6637');
INSERT INTO users VALUES (1046772365, 'Catherine', 'Goldenhill', 'catherine@goldenhil.co.nz', 'a7d56f367d2052cabd13713c3cb0625f1995edb7', 'b0c5686e9d52c88dac57594914f12e88b4ee3c32', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.215364', NULL, '2008-11-27 09:14:50.202322', '2008-11-27 09:14:50.216077', 151679809, true, true, true, 'Goldenhill School of Healing Arts', '782a Remuera Road', 'Remuera', NULL, 1030444527, '09 833 3108', '-');
INSERT INTO users VALUES (1046772366, 'Chai', 'Deva', 'Chai@bodyexcel.com', '597571cae274acea096063d93f1abacdaa6e8e23', '8a1702d2bead8376f80ce015393af60e0f3aaed5', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.244115', NULL, '2008-11-27 09:14:50.233394', '2008-11-27 09:14:50.244822', 880982500, true, true, true, 'Body Excel', NULL, NULL, NULL, 266910087, '0800 263 995', '-');
INSERT INTO users VALUES (1046772367, 'Charles', 'McGrosky', 'theramass@xtra.co.nz', '9ea1f76c1787c8263c26cf93b91ebe6aff26b956', '501a9a9639e3c33cb157daae2d7548dc757a7444', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.269696', NULL, '2008-11-27 09:14:50.260292', '2008-11-27 09:14:50.270466', 880982500, true, true, true, 'Charles McGrosky', NULL, NULL, NULL, 266910087, '03 385 0544', '-');
INSERT INTO users VALUES (1046772368, 'Charlotte', 'Hathaway', 'charlotte.h@actrix.co.nz', 'c8ecefac8b58e3cdea143b36607fb58495bfaad4', 'cbae70f55e3ff5e05a01671ef112389b4e7ce3cd', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.296832', NULL, '2008-11-27 09:14:50.287212', '2008-11-27 09:14:50.297592', 408794758, true, true, true, 'Charlotte Hathaway', NULL, NULL, NULL, 583778593, '04 499 4069', '021 067 4841');
INSERT INTO users VALUES (1046772369, 'Charrette', 'Boyce', 'charrette@gmail.com', 'e029baadaf916a9190f3cc7276b0bfb063409366', '8ca64c970411bb2f0dafc80be7e1b3ae5363a598', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.32485', NULL, '2008-11-27 09:14:50.314787', '2008-11-27 09:14:50.325568', 880982500, true, true, true, 'Mount Pleasant Pilates', '181 Moncks Spur Rd', 'Mount Pleasant', NULL, 266910087, '03 384 8005', '027 413 9605');
INSERT INTO users VALUES (1046772370, 'Cherie', 'Anslow', 'Cherie_anslow@yahoo.com', 'cbd34d5f9a6afae23fa20a8e94093bbefc52807a', '47a1cc0a180e553d89dfb5a0b3b1707cf9dde60c', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.350896', NULL, '2008-11-27 09:14:50.3412', '2008-11-27 09:14:50.351631', 408794758, true, true, true, 'Cherie Anslow', 'PO Box 22014', 'Khandallah', NULL, 583778593, '-', '027 282 8919');
INSERT INTO users VALUES (1046772371, 'Cherry ', 'King', 'cherry-massage@paradise.net.nz', 'ae79a7add0a9bebb5664468bfd32e030a6bd277a', 'd7ec792eac388b15015194742c40e18f1560c6d3', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.379058', NULL, '2008-11-27 09:14:50.369384', '2008-11-27 09:14:50.379963', 408794758, true, true, false, 'Cherry  King', NULL, NULL, NULL, 583778593, '04 473 3776', '021 207 8989');
INSERT INTO users VALUES (1046772372, 'Chris', NULL, 'mishmash1188@xtra.co.nz', 'bc94f43bdaaf5927d570ace91e8ed589afc4264a', 'ddef18ab4c0e4abc3af5225b00b16b0835810d37', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.410133', NULL, '2008-11-27 09:14:50.397422', '2008-11-27 09:14:50.410833', 880982500, true, true, true, 'Chris ', '29 NewsteadLane', 'Addington', NULL, 266910087, '-', '-');
INSERT INTO users VALUES (1046772373, 'Christine ', 'Toner', 'christine@toner.co.nz', 'edc345257aa76d3b07c1a342116e81b7a3d93a31', 'd37a19173aa46a103165dd0ed6f3bfddff413f63', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.438629', NULL, '2008-11-27 09:14:50.42826', '2008-11-27 09:14:50.439355', 880982500, true, true, true, 'Christine  Toner', '77 Mount Pleasant Rd', 'Redcliffs', NULL, 266910087, '03 384 9167', '027 4339598');
INSERT INTO users VALUES (1046772374, 'Claudine', 'Alony', 'terschip@hotmail.com', 'df8e639f5837f3329bfbe98797c9210bd1271dce', '829628cef15e5480d534b6205c6c7028b68dab5a', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.465497', NULL, '2008-11-27 09:14:50.455611', '2008-11-27 09:14:50.466275', 151679809, true, true, true, 'Healing Massage', '21 Starlight Cove ', 'Howick', NULL, 1030444540, '-', '021 899 978');
INSERT INTO users VALUES (1046772375, 'Colleen', NULL, 'info@thevillabeauty.co.nz', 'b1b36eb5b56bc6a87b29fd0761451141663f99d9', '7402fe8172d371a9f7287946d7342a76e1b3075a', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.496275', NULL, '2008-11-27 09:14:50.486778', '2008-11-27 09:14:50.49694', 921797898, true, true, true, 'The Villa Beauty Therapy', '10-12 Church Street', NULL, NULL, 1030444598, '06 370 4561', '027 4191005');
INSERT INTO users VALUES (1046772376, 'Cushla', 'Reid', 'cushey@ihug.co.nz', 'fe2c3bf7f34acac0321bac52dcb1c730242acc71', '1d28e410c65211c87e5db9e45d1cf946952d90aa', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.524523', NULL, '2008-11-27 09:14:50.51485', '2008-11-27 09:14:50.609973', 408794758, true, true, false, 'Cushla Reid', 'Natural Health Centre, 2nd Floor,53 Courtney Place', NULL, NULL, 583778593, '04 385 4342', '0274 214 900');
INSERT INTO users VALUES (1046772377, 'Daniel', 'Condor', 'dmassageworks@xtra.co.nz', 'ebf7834db4276f035f406313d8d1af760310a831', 'b7e6b0882f43a85a8d5f010cd37fa28eb4d192ab', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.637315', NULL, '2008-11-27 09:14:50.62686', '2008-11-27 09:14:50.638104', 1073681813, true, true, true, 'massageworks', '31 Gillies Ave', NULL, NULL, 1030444568, '-', '-');
INSERT INTO users VALUES (1046772378, 'David ', 'Mason', 'info@hypknowsis.com', 'aef5320f02b959183a41b65a930673e337da620d', '9aad7017cf71789d2a8cd26f2fc1d1d0f334bd82', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.663991', NULL, '2008-11-27 09:14:50.653871', '2008-11-27 09:14:50.664812', 408794758, true, true, true, 'Wellingtom Hypnotherapy', '34 Hawtrey Terrace', 'Johnsonville', NULL, 583778593, '04 478 4100', '027 404 8003');
INSERT INTO users VALUES (1046772379, 'Debbie', 'Mann', 'info@anoukherbals.co.nz', 'e4dc5e29107a58b89317f54ff717625e4c00873d', '185211ddc19925f0e4fd93e3b3d547022af779be', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.692059', NULL, '2008-11-27 09:14:50.680649', '2008-11-27 09:14:50.692996', 880982500, true, true, true, 'Anouk', NULL, NULL, NULL, 266910087, '03 942 2103', '-');
INSERT INTO users VALUES (1046772380, 'Debby ', 'Guddee', 'pmt_therapies@xtra.co.nz', 'd50b39d1d68953b8cb9cd38994d4788d8cd01ad7', 'e11828887b81f7f2012950f00d6af56b80c4d6e5', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.721832', NULL, '2008-11-27 09:14:50.711691', '2008-11-27 09:14:50.72346', 408794758, true, true, true, 'Mystical Therapies', '42 Percy Street', NULL, NULL, 1030444604, '-', '021 332 427');
INSERT INTO users VALUES (1046772381, 'Dee', 'Smith', 'justmassage@xtra.co.nz', '01839600dde6a30382b2d819e3fdaf8103f47f06', '29070c1f72c57054722923c1acce7f864726d9b8', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.751001', NULL, '2008-11-27 09:14:50.739673', '2008-11-27 09:14:50.75188', 151679809, true, true, true, 'Just Massage', '40 St Benedict Street', NULL, NULL, 1030444541, '09 486 3335', '-');
INSERT INTO users VALUES (1046772382, 'Delia', 'Crozier', 'delia_crozier@yahoo.com.au', '9af5486d1da064337461eeacd4ef7137e80e57c5', '6d6d7704ed5ae3051e3538cf3e6639c8a8f767e5', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.782053', NULL, '2008-11-27 09:14:50.771456', '2008-11-27 09:14:50.782732', 408794758, true, true, true, 'Holistic Counselling', 'Natural Health Centre, 2nd Floor, 53 Courtney Place', NULL, NULL, 583778593, '04 385 4342', '027 256 6800');
INSERT INTO users VALUES (1046772383, 'Denise ', 'O''Malley', 'homeopath@ihug.co.nz', '031ff87d02d5d164ff542d6a427ffa479182eee0', 'd56231e2f6be30b07aca7d4a74e83b7078884b8b', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.810196', NULL, '2008-11-27 09:14:50.798428', '2008-11-27 09:14:50.811331', 151679809, true, true, true, 'Denise  O''Malley', '1/102 Remuera Rd', 'Remuera', NULL, 1030444527, '09 520 1260', '021 520 081');
INSERT INTO users VALUES (1046772384, 'Diane', 'White', 'clinicalhypnotherapy@mail.com', '500370526e061fd0d58d441dc194eb58cafb5719', '34e1fbdac27674f5de637af29d8a0f5e6224240e', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.837027', NULL, '2008-11-27 09:14:50.826729', '2008-11-27 09:14:50.837726', 880982500, true, true, true, 'Diane White-Clinical Hypnotherapist Life Coach', NULL, NULL, NULL, 266910087, '03 358 9792', '-');
INSERT INTO users VALUES (1046772385, 'Dr Ian', 'Ball', 'drianball@mac.com', '2ecdd28e191c88c79ea27d466412168ddb476b06', '8d34ad32779742aa6b519b8403eaebe2e8c91163', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.862297', NULL, '2008-11-27 09:14:50.853008', '2008-11-27 09:14:50.862991', 151679809, true, true, true, 'Dr Ian Ball', NULL, NULL, NULL, 1030444527, '09 307 1123', '027 272 2715');
INSERT INTO users VALUES (1046772386, 'Dr. Dov', 'Phillips', 'connecttolife@gmail.co.nz', 'a8e5f5579435b69fda1db2afccc0161201e34003', '721cda4463714c3b48823e9a126649426ba57ee1', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.890097', NULL, '2008-11-27 09:14:50.880508', '2008-11-27 09:14:50.890766', 151679809, true, true, true, 'Connect to life', NULL, NULL, NULL, 1030444527, '09 488 0781', '021 286 5433');
INSERT INTO users VALUES (1046772387, 'Dr. Graeme', 'Teague', 'gteague@xtra.co.nz', '4c36dfa2656f5e7ffa6cbfe9b575a18be3edba6a', '7ec545eb0342fc76dad132e5a5f66a5c914ec349', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.920212', NULL, '2008-11-27 09:14:50.906574', '2008-11-27 09:14:50.921071', 880982500, true, true, true, 'Graeme Teague Ltd', '21 Len Hale Place', 'Ferrymead', NULL, 266910087, '03 384 0160', '-');
INSERT INTO users VALUES (1046772388, 'Dr. Hayden', 'Sharp', 'hayden@equilibriumchiropractic.com', 'ca99e613795095107d5c105da10f974dd8b566c0', 'f9cb282d0d43b94216d04a01297b8de3ffe8d68b', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.951323', NULL, '2008-11-27 09:14:50.940852', '2008-11-27 09:14:50.951986', 783123194, true, true, true, 'Equilibrium Chiropractic', '114 Milton Street', NULL, NULL, 1030444608, '03 548 0082', '-');
INSERT INTO users VALUES (1046772389, 'Dr. Pratibha', 'Dalvi', 'pratibha@paradise.net.nz', '786e8cf0c195b8e240c1e522a37da83d8bb50122', '04bed878699dc8942f44d853dafc8958e2ea785d', NULL, NULL, 'active', NULL, '2008-11-27 09:14:50.977175', NULL, '2008-11-27 09:14:50.967709', '2008-11-27 09:14:50.977837', 151679809, true, true, true, 'Wilcott Street Health Care Centre', NULL, NULL, NULL, 1030444527, '09 815 5560', '-');
INSERT INTO users VALUES (1046772390, 'Dr. Singh', 'Saini', 'Dr.N.S.Saini@xtra.co.nz', '6536851184c58b4e4265140a45bfaab9785ec2e8', '2e6f0e33fd748b865fcea547ec06ff81a0cb52c1', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.002993', NULL, '2008-11-27 09:14:50.993172', '2008-11-27 09:14:51.003719', 151679809, true, true, true, 'Dr. Singh Saini', NULL, NULL, NULL, 1030444527, '09  630 3909', '-');
INSERT INTO users VALUES (1046772391, 'Dreenagh', 'Heppleston', 'unique_nlp@paradise.net.nz', '96fb423fa99492f1af2e9e51260a0e091411e42d', 'bfc200dbceb3aa37d0e2fbce4f5c60b1baf0ed2a', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.033007', NULL, '2008-11-27 09:14:51.022109', '2008-11-27 09:14:51.033707', 408794758, false, true, true, 'Dreenagh Heppleston', NULL, NULL, NULL, 583778593, '04 562 0071', '-');
INSERT INTO users VALUES (1046772392, 'Elissa', 'Brittenden', 'konagirlnz@gmail.com', '6a889ef54c75398729c594f4fee522e458a4077f', 'ab36bdbdf69fa5fa8bb232c115531d7a812ce9e7', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.144398', NULL, '2008-11-27 09:14:51.049063', '2008-11-27 09:14:51.145112', 880982500, true, true, false, 'Rangiora Clinical Massage', NULL, 'Waimakariri', NULL, 1030444625, '03 313 7672', '021 441323');
INSERT INTO users VALUES (1046772393, 'Emma', 'Van Veen', 'ameliorate@paradise.net.nz', '293fd2e53834ddc29265369ce72ebdcb0a1d44df', '69e345742678dd99b30f20d6d1c52d5c616a88f4', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.171379', NULL, '2008-11-27 09:14:51.161257', '2008-11-27 09:14:51.172091', 408794758, true, true, false, 'Ameliorate', NULL, NULL, NULL, 583778593, '04 478 6982', '-');
INSERT INTO users VALUES (1046772394, 'Eric', 'Saxby', 'esax@paradise.net.nz', '31e8c09ccfb42cdbfbe1053ea8f3d5438e389e4a', '7fc1d10bef4403296c0620b6952381cdd4583d88', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.197641', NULL, '2008-11-27 09:14:51.187958', '2008-11-27 09:14:51.198339', 880982500, true, true, true, 'Eric Saxby', NULL, NULL, NULL, 266910087, '03 980 3130', '-');
INSERT INTO users VALUES (1046772395, 'Estelle', 'Cainey', 'info@infiniteintegrity.co.nz', 'fbbb7ab9078e9d68dafca7b18991535075bed932', '25ab194737c5648976b8e6bdf5c3bc49409a41c7', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.234524', NULL, '2008-11-27 09:14:51.224097', '2008-11-27 09:14:51.235221', 408794758, true, true, true, 'infinite integrity', NULL, NULL, NULL, 583778593, '04 383 6166', '027 208 3836');
INSERT INTO users VALUES (1046772396, 'Fiona', 'Dolan', 'fiona.dolan@hotmail.com', '9f749a417cb5201d20ea0fa571191a040f1d9bef', '5c19384e5c58c06516d0d54ff93ff4503dc3289b', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.261414', NULL, '2008-11-27 09:14:51.251478', '2008-11-27 09:14:51.262446', 408794758, true, true, true, 'Fiona Dolan', '1/54 Whites Line West', NULL, NULL, 1030444602, '04 587 0053', '021 913 224');
INSERT INTO users VALUES (1046772397, 'Fiona', 'Goulding', 'fiona.goulding@actrix.co.nz', 'd83ca3927edeae03d8c154f902fd9acc117e0259', 'b56b7bbd70c33e8b42ebe2212772de7b8fa7f20c', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.294521', NULL, '2008-11-27 09:14:51.28217', '2008-11-27 09:14:51.295218', 880982500, true, true, true, 'Fiona Goulding', NULL, NULL, NULL, 266910087, '03 326 6226', '-');
INSERT INTO users VALUES (1046772398, 'Fiona', 'Links', 'flinks@xtra.co.nz', 'bb8347a9ee28941bee6b9819a598037e26f3d631', 'bf3e6745128a655dd149a98b04dd0398326e561e', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.321598', NULL, '2008-11-27 09:14:51.310258', '2008-11-27 09:14:51.322346', 1073681813, true, true, true, 'Taupo Yoga Studio', '54 Ayrshire Drive', NULL, NULL, 1030444568, '07 378 3372', '021 063 9249');
INSERT INTO users VALUES (1046772399, 'Georgia', 'Bryant', 'acuhealth1@xtra.co.nz', '50e7bac136f6c4c21c7516eb9278a87ba018dfbf', '1efaef05b089a1d6286fc6d898f3e330d1884561', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.347811', NULL, '2008-11-27 09:14:51.338294', '2008-11-27 09:14:51.348483', 880982500, true, true, true, 'Acupuncture for Health', NULL, NULL, NULL, 266910087, '03 388 7346', '-');
INSERT INTO users VALUES (1046772400, 'Glyn', 'Flutey', 'glyn@osteopathicedge.co.nz', '6fac00cf9ad61269c54ce5d8b9f713aa6ffb13a4', 'f50660a95147fc78dd39422ad5d876899f58c3c2', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.375401', NULL, '2008-11-27 09:14:51.364248', '2008-11-27 09:14:51.376203', 151679809, true, true, true, 'Osteopathic Edge', '48 Bellevue Road', 'Mt. Eden', NULL, 1030444527, '09 630 3790', '-');
INSERT INTO users VALUES (1046772401, 'Hamish', 'Abbie', 'pulsept@xtra.co.nz', '8d7e48fabc0511e62ab0ab3955e4deaa217ee3ac', 'b4f78b094d6c84097bad5208d97475112887cb9b', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.40118', NULL, '2008-11-27 09:14:51.391583', '2008-11-27 09:14:51.401847', 408794758, false, true, true, 'Hamish Abbie', NULL, NULL, NULL, 583778593, '-', '021 730 281');
INSERT INTO users VALUES (1046772402, 'Hayley', 'Nicholls', 'hayley@energycoach.co.nz', 'eb3904cba2af45ad3aedd16a72cc73655b07b830', '3a1faf6021584e42d2b34049f9b12ae79027bd02', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.42855', NULL, '2008-11-27 09:14:51.416994', '2008-11-27 09:14:51.429289', 151679809, true, true, true, 'Compassion Buddist Centre', NULL, NULL, NULL, 1030444527, '09 828 0687', '027 338 0009');
INSERT INTO users VALUES (1046772403, 'Heather', 'Todd', 'heather@EFTclinic.co.nz', 'ed5e990027d73ce29957032ca70d55595ae12509', 'd61be0c1465c3fba0e3bc0a5ca629449bc399023', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.457086', NULL, '2008-11-27 09:14:51.446605', '2008-11-27 09:14:51.457848', 408794758, true, true, true, 'EFT Clinic', '149-3 Hill Road', NULL, NULL, 1030444602, '04 565 3692', '027 437 0785');
INSERT INTO users VALUES (1046772404, 'Heather', 'Wright', 'theramass2@xtra.co.nz', '15996af59e131ff001f8f44815691e90db68004d', 'c4df725edbb2c6be58b4a85aea57f2e6b63507a9', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.483884', NULL, '2008-11-27 09:14:51.474247', '2008-11-27 09:14:51.484585', 880982500, true, true, true, 'Heather Wright', '118 Bealey Ave', NULL, NULL, 266910087, '03 385 0544', '-');
INSERT INTO users VALUES (1046772405, 'Helena ', 'Tobin', 'helenatobin@paradise.net.nz', 'f59755c377330d0ded8a70f8ccf4ff0f62b56da6', '8429402dc6da953ec8331c036351930a8e4047da', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.508985', NULL, '2008-11-27 09:14:51.499405', '2008-11-27 09:14:51.509758', 408794758, true, true, true, 'Helena  Tobin', NULL, NULL, NULL, 583778593, '04 569 6164', '-');
INSERT INTO users VALUES (1046772406, 'Ingrid', 'Bryant', 'inbryant@clear.net.nz', '338d55610f9fa4c8e20360022afcf23b93b86659', 'ce1b6463c53839d5716b90e81702c0475985d792', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.53754', NULL, '2008-11-27 09:14:51.527808', '2008-11-27 09:14:51.53825', 285931426, true, true, true, 'Lifeforce Health', NULL, NULL, NULL, 1030444576, '06 876 7948', '027 335 5673');
INSERT INTO users VALUES (1046772407, 'Isha', 'Doellgasr', 'isha1728@yahoo.com', 'ab07905bea88004545f95fcbfbecf881bf86fd2f', '7ca656a8cf01a45ba95b1025ef15987345fef2a8', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.56572', NULL, '2008-11-27 09:14:51.556067', '2008-11-27 09:14:51.566393', 408794758, true, true, true, 'Aloha Massage', '46 Jackson Street', 'Island Bay', NULL, 583778593, '04 973 6055', '021 152 4438');
INSERT INTO users VALUES (1046772408, 'Jackie ', 'Pratley', 'jackiepratley@hotmail.com', '40b6c27dacd2c2b5f0e661d3ca554d22eaf2d919', 'd179fd218d20f3f1f2c48f18a72515d63e25b829', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.674408', NULL, '2008-11-27 09:14:51.664014', '2008-11-27 09:14:51.675173', 880982500, true, true, true, 'Jackie  Pratley', NULL, NULL, NULL, 266910087, '03 383 3084', '-');
INSERT INTO users VALUES (1046772409, 'Jacob', 'Munz', 'jacob@harahealth.co.nz', 'dc674c64e60052da7fe035b62a6b82460d57b0b8', 'c4805eba57e704cbd76de9474e36e6ced831ada6', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.701388', NULL, '2008-11-27 09:14:51.691297', '2008-11-27 09:14:51.702145', 408794758, true, true, true, 'Hara Health', 'L3, 41 Dixon Street', NULL, NULL, 583778593, '04 3828175', '-');
INSERT INTO users VALUES (1046772410, 'Jacqui', 'Vestergaard', 'starlightrising@xtra.co.nz', 'bd7027df61fdc1d52ef4cf4ba21907c29496405a', '7a56c75fea4ade421970bdb0e2c807cef4a4c036', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.737535', NULL, '2008-11-27 09:14:51.718352', '2008-11-27 09:14:51.738269', 408794758, true, true, true, 'Starlightrising.com', '316 Paekak Hill Rd', 'Paekakariki', NULL, 1030444601, '04 237 6362', '021 141 2690');
INSERT INTO users VALUES (1046772411, 'Jan & Maree', 'Stachel-Williamson', 'jan@nwow.co.nz', 'd9041e7f7d8ea5f0bcb548cac40f0987254b1625', '042e8ced3335302f4c5e7ed775aa12434904d4d9', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.7656', NULL, '2008-11-27 09:14:51.754537', '2008-11-27 09:14:51.766317', 880982500, true, true, true, 'nWow! NLP & Kinesiology Solutions', NULL, NULL, NULL, 266910087, '-', '021 070 0132');
INSERT INTO users VALUES (1046772412, 'Jan', 'Canton', 'jan@directsuccess.co.nz', 'ede63e9f561975e00694a9da9cd56b341c95993b', '971e0538fcc3f4f2c23d378c034741df541ee4e4', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.793196', NULL, '2008-11-27 09:14:51.781936', '2008-11-27 09:14:51.794064', 152815033, true, true, false, 'Direct Success Coaching Ltd', 'POBox 102', NULL, NULL, 1030444549, '07 846 5486', '-');
INSERT INTO users VALUES (1046772413, 'Jane', 'Allan', 'jane@thehavencentre.co.nz', 'aa9275e4de9d1be2b75a4a13a8dcb8bd92dbbef8', 'b95cf6601f5e04a4016352740f1e9476ada19bc8', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.822524', NULL, '2008-11-27 09:14:51.811603', '2008-11-27 09:14:51.823749', 880982500, true, true, true, 'ISBT-Bowen Therapy', '3 York Street', NULL, NULL, 266910087, '03 313 8661', '021 2238838');
INSERT INTO users VALUES (1046772414, 'Jane', 'Cowan-Harris', 'jane@sitrightworkwell.co.nz', 'bf445b2e3f02b514b68b95049685c6cfacdb69eb', '1892a08187d245c72225c6f1440b8a6563b42c7f', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.853553', NULL, '2008-11-27 09:14:51.843934', '2008-11-27 09:14:51.854326', 880982500, true, true, false, 'SitRight Workwell', NULL, NULL, NULL, 266910087, '03 326 5450', '021 043 5342');
INSERT INTO users VALUES (1046772415, 'Jane', 'Hipkiss', 'jane@healingarts.co.nz', 'ba80777e044fddc8bf274fe03b71c80c83704786', '57e7da5c34c66efff8a1930aff5b4128ef71192e', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.879057', NULL, '2008-11-27 09:14:51.869614', '2008-11-27 09:14:51.87981', 408794758, false, true, true, 'Jane Hipkiss', NULL, NULL, NULL, 583778593, '04 293 7325', '-');
INSERT INTO users VALUES (1046772416, 'Jane', 'Logie', 'jane.logie@clear.net.nz', 'dd09855b6bd9a829d64ed27445b687ac8b2a2432', '09d81a5da8ea94d66abfa51fb01d5e4fffd28ef0', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.904669', NULL, '2008-11-27 09:14:51.895221', '2008-11-27 09:14:51.905443', 880982500, true, true, true, 'Jane Logie', NULL, NULL, NULL, 266910087, '03 302 8773', '-');
INSERT INTO users VALUES (1046772417, 'Jane', 'Manthorpe', 'jcm@rawinspiration.biz', 'dbf4519b5e7809639009a1dbe9c7cbf1caef2315', 'c02d7a79e13ead5aae89db88a2d85758330e568a', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.934578', NULL, '2008-11-27 09:14:51.923412', '2008-11-27 09:14:51.935327', 880982500, true, true, true, 'Jane Manthorpe', NULL, NULL, NULL, 266910087, '-', '-');
INSERT INTO users VALUES (1046772418, 'Jane', 'Valentine-Burt', 'hypnotherapy@actrix.co.nz', '322c81925edfefb14880dac3d8fc2a37e72ee293', 'e8bf3b0970a75b9e4ffd4b53305307b8901f683d', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.961568', NULL, '2008-11-27 09:14:51.950872', '2008-11-27 09:14:51.962361', 151679809, true, true, true, 'Professional Hypnotherapy', '22 Jervois Road', 'Hobsonville', NULL, 1030444544, '09 416 5385', '027 4444 104');
INSERT INTO users VALUES (1046772419, 'Janice', 'Denney', 'janice.denney@blazemail.com', '9e61811232db337f9d4cb1e9b4eb84f775ab8496', '405589c36f638a32d7748ec90b36e081537aa6c2', NULL, NULL, 'active', NULL, '2008-11-27 09:14:51.994358', NULL, '2008-11-27 09:14:51.984398', '2008-11-27 09:14:51.995041', 408794758, false, true, true, 'Janice Denney', NULL, NULL, NULL, 583778593, '04 970 1447', '-');
INSERT INTO users VALUES (1046772420, 'Jasmina', 'Kovacev', 'efthelp@gmail.com', 'ed17242ca0a51d33360f18958a9e4e8144190b13', '5fea45f2d130c641ba049d4450c3eb024f045b02', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.019749', NULL, '2008-11-27 09:14:52.010212', '2008-11-27 09:14:52.020545', 408794758, true, true, false, 'emo-free', NULL, NULL, NULL, 583778593, '04 565 3888', '027 608 0078');
INSERT INTO users VALUES (1046772421, 'Jason', 'Belch', 'actionmuscle@xtra.co.nz', 'bf7fc73b556c537d5bdac165788b6bd7bc285f93', '484284e075ee4be08ae6bf9c0d5dde57d28d2975', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.048431', NULL, '2008-11-27 09:14:52.038244', '2008-11-27 09:14:52.0491', 408794758, true, true, true, 'Action Muscle Therapy', '20/232 Middleton Road', 'Johnsonville', NULL, 583778593, '-', '0211 098 142');
INSERT INTO users VALUES (1046772422, 'Jason', 'MacDonald', 'jason.goodmassage@gmail.com', '7b6727479d5e1eca9e9494ce61172605cc5b1de2', '9f728c403cb0358429a1de1d688e71347950716e', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.077244', NULL, '2008-11-27 09:14:52.067002', '2008-11-27 09:14:52.077925', 880982500, true, true, true, 'Good Massage', '158 Bealey Road', 'Moncks Bay', NULL, 266910087, '03 365 5665', '027 514 5777');
INSERT INTO users VALUES (1046772423, 'Jax ', 'Storey', 'jaxstorey@ihug.co.nz', 'c7ad16aa5807ba5571c818a20e196a605592ab88', '5691f65f262128c4c7eb4aed28441975afabd6f2', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.105394', NULL, '2008-11-27 09:14:52.095804', '2008-11-27 09:14:52.190104', 880982500, true, true, true, 'Wellbeing Room', NULL, NULL, NULL, 266910087, '03 348 5733', '-');
INSERT INTO users VALUES (1046772424, 'Jennie', 'McMurran', 'vitality@paradise.net.nz', '505299fbc97baacbc4212c3f6e66c82c16baecaf', '6a431827843f534c18fbd5f1c9390d16208ca8dd', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.217579', NULL, '2008-11-27 09:14:52.207568', '2008-11-27 09:14:52.218401', 408794758, true, true, false, 'Jennie McMurran', NULL, NULL, NULL, 583778593, '04 389 9776', '021 725 751');
INSERT INTO users VALUES (1046772425, 'Jennifer', 'James', 'jennifer@juniperjunxion.c0.nz', 'a0b5fdc05c8c2ae82ea5cdcc5c7018d9f969113f', 'f5439e9fa2120c51a44a2420e6f05d458538c74d', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.248654', NULL, '2008-11-27 09:14:52.238291', '2008-11-27 09:14:52.249464', 151679809, true, true, true, 'Juniperjunxion', NULL, NULL, NULL, 1030444527, '09 476 0000', '-');
INSERT INTO users VALUES (1046772426, 'Jenny', 'Georgeson', 'jenny@bodha.co.nz', 'e054bf426a7acca2e3423a6638d9d984182e5233', 'fe13e94517abc071b7a94a809e763dcaef1fe62f', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.274993', NULL, '2008-11-27 09:14:52.265143', '2008-11-27 09:14:52.275798', 880982500, true, true, true, 'Bodha', NULL, NULL, NULL, 266910087, '03 384 0594', '-');
INSERT INTO users VALUES (1046772427, 'Jill', 'Casey', 'caseyjill@hotmail.com', '584adbf888c1be4ff6228aa372833437010ba7c3', 'a51e7001f45c0c2b6ebe0a32c32c2ff8023f7b8f', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.301073', NULL, '2008-11-27 09:14:52.29153', '2008-11-27 09:14:52.301795', 408794758, false, true, true, 'Jill Casey', NULL, NULL, NULL, 583778593, '04 472 9996', '-');
INSERT INTO users VALUES (1046772428, 'Jill', 'Casey', 'jkcasey@hydrohealthwellington.co.nz', '8ff45a2a7fc1c76d567dbaf60e153cc60cf7835e', 'f868073de660de85fb7ab700901d1d253d7d9949', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.330649', NULL, '2008-11-27 09:14:52.319855', '2008-11-27 09:14:52.331426', 408794758, true, true, true, 'Jill Casey', 'Dixon Street Health', NULL, NULL, 583778593, '04 802 0823', '-');
INSERT INTO users VALUES (1046772429, 'Jo ', 'Hampton', 'jokiwikid@yahoo.com', '2800690c3cb1f9c0dc2c83c4482557b3dadcf92a', '129a0e9336f4e5073947c44aea8fd071b7ef0b5b', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.361434', NULL, '2008-11-27 09:14:52.351508', '2008-11-27 09:14:52.362187', 880982500, true, true, true, 'Bikram Yoga College of India', NULL, NULL, NULL, 266910087, '03 383 9903', '-');
INSERT INTO users VALUES (1046772430, 'Jo ', 'Woods', 'jojoandayla@xtra.co.nz', '96355054fa2e65c276aacf7b597867443dc4e4f3', 'afcaf075bc718fe8371545b0c27dec83454192e4', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.386579', NULL, '2008-11-27 09:14:52.376986', '2008-11-27 09:14:52.387256', 880982500, true, true, true, 'M4U Corporate - Mobile Massage', NULL, NULL, NULL, 266910087, '-', '021 775215');
INSERT INTO users VALUES (1046772431, 'Joanne', 'Marama', 'theomarama@xtra.co.nz', '55d47b24e93d9e851a78ef098e67d6ea4c572366', 'e9f90b00ed5a489eafbb69f1f44bd64d7b98a519', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.412161', NULL, '2008-11-27 09:14:52.402627', '2008-11-27 09:14:52.412946', 880982500, true, true, true, 'Joanne Marama', NULL, NULL, NULL, 266910087, '03 347 7628', '-');
INSERT INTO users VALUES (1046772432, 'Joanne', 'Ostler', 'joanne@careerwise.co.nz', '6e18760e7576092ebaa3d4f1aa4c0b5dce99a1ad', 'f1cbacff2bce37db04893769e5cb38bb3005532c', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.44239', NULL, '2008-11-27 09:14:52.430752', '2008-11-27 09:14:52.443139', 152815033, true, true, true, 'Careerwise', NULL, 'Waipa', NULL, 1030444547, '-', '021 950 022');
INSERT INTO users VALUES (1046772433, 'Jodi', 'Salter', 'soulsticenz@yahoo.co.nz', '3ce4ba2ee7326a566ffd406f112447a26a757ab8', '6f3c02260f704ed5e266f4b6506472fc47f9d83c', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.468748', NULL, '2008-11-27 09:14:52.45902', '2008-11-27 09:14:52.469443', 880982500, true, true, true, 'Soulstice Natural Medicine', NULL, NULL, NULL, 266910087, '03 379 9303', '-');
INSERT INTO users VALUES (1046772434, 'John', 'Jing', 'john@acucentre.co.nz', '9e55c0abf59dbd12e17383d0336b80cdab0f6d7f', '8b1164f2bab28e6e48257b4298d517e00a8648a1', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.495482', NULL, '2008-11-27 09:14:52.484757', '2008-11-27 09:14:52.4962', 880982500, true, true, true, 'AcuCentre Chinese Healthcare', NULL, NULL, NULL, 266910087, '03 365 0688', '-');
INSERT INTO users VALUES (1046772435, 'John', 'Ramsey', 'john.ramsay@mail.com', 'ba3e96350831a16f729321ad42496927ff0cc475', '3c987b0d5efdc32b6bc2411ee1eac85e032968fe', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.523208', NULL, '2008-11-27 09:14:52.513411', '2008-11-27 09:14:52.523948', 151679809, true, true, true, 'John Ramsey', '1d-3 Cheshire Street', 'Parnell', NULL, 1030444527, '-', '021 0231 1633');
INSERT INTO users VALUES (1046772436, 'Joseph', 'Quinn', 'joseph@openroadassociates.com', 'dd4426ed86c13771370b7e3512d3b2e9a90545b6', 'f6adad4653fa8c2161a2d84e52db63724f4c4645', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.55138', NULL, '2008-11-27 09:14:52.541386', '2008-11-27 09:14:52.552089', 151679809, true, true, true, 'Open Road Associates', '28 Elmira Place', NULL, NULL, 1030444527, '09 357 0724', '021 022 46959');
INSERT INTO users VALUES (1046772437, 'Joyce', 'Puch', 'puch1996@gmail.com', 'f9af93aa27ae93879b8e5719a5a34b8e764320c0', 'd13c83a0d873ab72b588e2c5fa3ae0f70589ecfc', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.578231', NULL, '2008-11-27 09:14:52.568398', '2008-11-27 09:14:52.578964', 408794758, true, true, true, 'Choice Communication Group', 'Unit 3, 47-49 Wellington Road', 'Kilbernie', NULL, 583778593, '04 386 3454', '021 140 1180');
INSERT INTO users VALUES (1046772438, 'Judy ', 'Montgomery', 'judyonline@xtra.co.nz', 'fbc1b9d25eeb5648d6cf8c0ed977626918ddec02', 'ab4e8c0b769a351d5fed03353ad19e3d4ebe582a', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.603591', NULL, '2008-11-27 09:14:52.594391', '2008-11-27 09:14:52.6043', 408794758, true, true, true, 'Judy  Montgomery', NULL, NULL, NULL, 583778593, '-', '027 2229056');
INSERT INTO users VALUES (1046772439, 'Judy', 'Lynne', 'mayfly@paradise.net.nz', '5275d160530b446364c8a5857f009dbb27daed29', '157a4537ea88ffee342939f98f40f6ffd944cd80', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.713675', NULL, '2008-11-27 09:14:52.619286', '2008-11-27 09:14:52.714387', 408794758, true, true, true, 'Living Thinking Being', 'PO Box 31253', NULL, NULL, 1030444602, '-', '027 222 9056');
INSERT INTO users VALUES (1046772440, 'Jules', 'McRae', 'julesmcr@paradise.net.nz', '0360a1f5f784a503399e9e68aba22d5cd0cb8496', 'cfd6962f2840445d064656ea794e8c468c691318', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.742052', NULL, '2008-11-27 09:14:52.730325', '2008-11-27 09:14:52.742937', 408794758, false, true, true, 'Jules McRae', NULL, NULL, NULL, 583778593, '04 970 3554', '-');
INSERT INTO users VALUES (1046772441, 'Julia', 'Biermann', 'soundstrue@paradise.net.nz', '8247a34439154901989539e25bc3bc2d091680b1', '49f55adbd6aaa36dd705c98bc524b5384ab5d47b', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.772827', NULL, '2008-11-27 09:14:52.7626', '2008-11-27 09:14:52.773685', 151679809, true, true, true, 'Julia Biermann', NULL, 'Torbay ', NULL, 1030444541, '09 473 1022', '-');
INSERT INTO users VALUES (1046772442, 'Karen ', 'Shepherd', 'km.shephard@yahoo.co.nz', 'c1b300b886f6dbd889b5695910ddfae63bef8c98', 'c0d8148f0e4432611f0438576dc34f2045bd76ad', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.801105', NULL, '2008-11-27 09:14:52.79192', '2008-11-27 09:14:52.80181', 151679809, true, true, true, 'Karen  Shepherd', '162 Ocean View Road', 'Papatoetoe', NULL, 1030444540, '-', '021 0243 8620');
INSERT INTO users VALUES (1046772443, 'Karen', 'Newitt', 'karen@handsonhealth.co.nz', 'f7078963c677d9f06442506a882be1025fa29218', '4ea4dd9dfc94deadb1eace03d69aecf9ebc8e482', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.827376', NULL, '2008-11-27 09:14:52.816675', '2008-11-27 09:14:52.828141', 151679809, true, true, true, 'Hands On Health?', NULL, NULL, NULL, 1030444527, '09 413 7547', '-');
INSERT INTO users VALUES (1046772444, 'Kate', 'Harper', 'k8t@hushmail.com', 'd8e6808c9468740e7f082449b1b39b9914af5516', 'ed2afa7b0690b796c91aa379d96df8d5bce6d6f9', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.860176', NULL, '2008-11-27 09:14:52.849142', '2008-11-27 09:14:52.861025', 151679809, true, true, true, 'Kate Harper', '18 Grand View Road', 'Remuera', NULL, 1030444527, '09 522 2225', '027 240 5467');
INSERT INTO users VALUES (1046772445, 'Katie', 'Lane', 'lane@kiwiwebhost.sarcoma.netnz', '19551f423ec248f920c8f5923eb80d4775e38184', '390de5c7513964fecbdd57fda0d0c57ca9be802c', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.885943', NULL, '2008-11-27 09:14:52.876212', '2008-11-27 09:14:52.886624', 880982500, true, true, true, 'Yoga Kula NZ', '139 Main Rd', NULL, NULL, 266910087, '03 337 6522', '-');
INSERT INTO users VALUES (1046772446, 'Katrina', 'Rivers', 'katrina@healingart.co.nz', 'd611b1af0cad0f81322280b1dfd506cfc55917b9', '4c1a7c8c78e79dc5d589d97bbeb1d1958c319709', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.919188', NULL, '2008-11-27 09:14:52.907548', '2008-11-27 09:14:52.919937', 151679809, true, true, true, 'Katrina Rivers', '3/37 Allenby Road', 'Papatoetoe', NULL, 1030444540, '09 278 7991', '021 385 919');
INSERT INTO users VALUES (1046772447, 'Kaytee', 'Boyd', 'kayteeBoyd@xtra.co.nz', 'f0f962ae49932c7dd9cee1cccb1c1e5b1598b199', '32fe6befd0a1a519922015aeba95375f3015c8c8', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.956166', NULL, '2008-11-27 09:14:52.937623', '2008-11-27 09:14:52.957257', 151679809, true, true, true, 'Oomph', NULL, NULL, NULL, 1030444527, '-', '021 460 444');
INSERT INTO users VALUES (1046772448, 'Kevi', 'Hawkins', 'kevin.h@paradise.net.nz', 'a289a4dc211c20744b10c6903195b9e5415cf50c', 'f1d01ec032b9d77db8b9cfc7ae36ab68f1c45740', NULL, NULL, 'active', NULL, '2008-11-27 09:14:52.986223', NULL, '2008-11-27 09:14:52.975089', '2008-11-27 09:14:52.986992', 408794758, false, true, true, 'Kevi Hawkins', NULL, NULL, NULL, 583778593, '04 232 6585', '-');
INSERT INTO users VALUES (1046772449, 'Kim ', 'Marshall', 'kim.manna@xtra.co.nz', 'e65c14eb0adda5ed637cd0fadef9b855e9236aa1', 'aa725d8545f83deeedb05d66a3a1730249a9409d', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.033253', NULL, '2008-11-27 09:14:53.020751', '2008-11-27 09:14:53.033966', 151679809, true, true, true, 'FreeLife', NULL, NULL, NULL, 1030444527, '-', '021 823 224');
INSERT INTO users VALUES (1046772450, 'Kim ', 'Snell', 'body_mind_soul@hotmail.com', '631b027b86502008dbb758afae4db39e82cb7dc8', 'eec63add70c5ca288a873b2ebca2ac4370e4e856', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.068949', NULL, '2008-11-27 09:14:53.055123', '2008-11-27 09:14:53.069635', 151679809, true, true, true, 'BodyMindSoul', '2 Jervois Road', 'Piha', NULL, 1030444544, '-', '021 211 9847');
INSERT INTO users VALUES (1046772451, 'Kim ', 'Turton', 'kst.50@clear.net.nz', 'f5bf64e14bc089482bae96091531f443dadce03c', '135d62d500ede7f7aba91e02a3ede14e489be301', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.094488', NULL, '2008-11-27 09:14:53.084851', '2008-11-27 09:14:53.095255', 408794758, true, true, true, 'Kim  Turton', '79 Pretoria Street', NULL, NULL, 1030444602, '04 566 7130', '021 231 7878');
INSERT INTO users VALUES (1046772452, 'Kim', 'Chamberlain', 'kim@successfulspeaking.co.nz', 'c2389374c139c3df235984e1aed67ee328c1fd1e', '1cd4542e2d6bd0f4dfb88ba5fc3cad81a23d0e57', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.121884', NULL, '2008-11-27 09:14:53.112781', '2008-11-27 09:14:53.122635', 408794758, false, true, true, 'Kim Chamberlain', NULL, NULL, NULL, 583778593, '04 232 3726', '-');
INSERT INTO users VALUES (1046772453, 'Kip', 'Mazuy', 'kip@bliss-music.com', '67946e610f9f7bf9ff1371453fd601f2d0c65725', '3b71c70ef47a5d1bc8b5acdd8736997a11309cc4', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.147354', NULL, '2008-11-27 09:14:53.137727', '2008-11-27 09:14:53.148083', 151679809, true, true, true, 'Kip Mazuy', NULL, 'Piha', NULL, 1030444544, '09 812 8329', '-');
INSERT INTO users VALUES (1046772454, 'Kris ', 'Mills', 'Kmills@chevron.com', 'bf3573a7273f6b982dfbcfc0ba3357421c231066', 'fdc70e68825ea6cdb26f24ec4e7dbd55538a0fd0', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.174985', NULL, '2008-11-27 09:14:53.164742', '2008-11-27 09:14:53.175821', 408794758, true, true, true, 'Kris  Mills', '80 Beazley Ave', 'Paparangi', NULL, 583778593, '04 470 6832', '027 470 6832');
INSERT INTO users VALUES (1046772455, 'Laura', 'Bradburn', 'acudoc@ihug.co.nz', '5ec836334ba77cd7fe5977770828b576ac93ea01', 'ad2fee7ef6b76e2a8d9a33ff1f31f80fb6a3c707', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.291652', NULL, '2008-11-27 09:14:53.281111', '2008-11-27 09:14:53.292535', 151679809, true, true, true, 'Laura Bradburn', NULL, NULL, NULL, 1030444527, '09 626 7120', '-');
INSERT INTO users VALUES (1046772456, 'Linda', 'Spence', 'linda@bodymind.co.nz', '5c6de76ec0897bbc82ee9fbf4ad6ff1c72e3f4ba', '73abb4009b2efb1e9256f5c621bd6bedb15ebdc9', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.318412', NULL, '2008-11-27 09:14:53.308534', '2008-11-27 09:14:53.319214', 921797898, false, true, true, 'Linda Spence', NULL, NULL, NULL, 1030444598, '06 370 1121', '-');
INSERT INTO users VALUES (1046772457, 'Liz ', 'Ryan', 'lizryantherapy@xtra.co.nz', 'b85c2f4e7d6d669e49dfc3f84fcb0e4952e53e4f', 'b39073127710d394b32c176bffb37f20e66e5f32', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.346862', NULL, '2008-11-27 09:14:53.334748', '2008-11-27 09:14:53.347799', 880982500, true, true, true, 'Liz  Ryan', NULL, NULL, NULL, 266910087, '03 315 7310', '-');
INSERT INTO users VALUES (1046772458, 'Liz', 'Riversdale', 'liz.riversdale@vistacoaching.co.nz', 'f97569f396e56d641150e40605305e9fb757ea70', 'eb0f03a4793bf859c5ed39d41f80be3970f915ea', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.380448', NULL, '2008-11-27 09:14:53.368205', '2008-11-27 09:14:53.381271', 408794758, true, true, true, 'Vista Coaching', '51 Brussels Street', 'Miramar', NULL, 583778593, '-', '021 252 3234');
INSERT INTO users VALUES (1046772459, 'Liz', 'Wassenaar', 'liz@bodymindconnections.co.nz', '224bafe9110664bacebca70213594e0f972725c3', 'bd397108819046236c98a0baa9817e2cb8129370', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.409685', NULL, '2008-11-27 09:14:53.399586', '2008-11-27 09:14:53.410401', 408794758, true, true, true, 'Mind Body Connections', '97 Williams Street', 'Petone', NULL, 1030444602, '04 586 2246', '-');
INSERT INTO users VALUES (1046772460, 'Lorel', 'Julian', 'oasis.health@paradise.net.nz', '846eadb1d76e4abdbd126e54b2742400099ea15e', '5eaf4e6b269cfa2b5e220d0760681dc09df3b611', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.436053', NULL, '2008-11-27 09:14:53.426244', '2008-11-27 09:14:53.436746', 880982500, true, true, true, 'Oasis Holistic Health Limited', NULL, NULL, NULL, 266910087, '03 386 2414', '-');
INSERT INTO users VALUES (1046772461, 'Louise', 'Hockley', 'louise@chiro.co.nz', '06abab687dc6f7306b261e4b6a826ec0d9bf1923', '199f70ab68ca05fb8156ac7cea62e65dc23ee359', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.463181', NULL, '2008-11-27 09:14:53.451915', '2008-11-27 09:14:53.464002', 408794758, false, true, true, 'Louise Hockley', NULL, NULL, NULL, 583778593, '04 499 7755', '-');
INSERT INTO users VALUES (1046772462, 'Lynda ', 'Millar', 'lynda.millar@hotmail.com', '67e86c1ac435b3175a1a86be2e28da18089b482d', 'babe6c5447d54a579cfcc5018f4e7b7848eca270', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.489936', NULL, '2008-11-27 09:14:53.479862', '2008-11-27 09:14:53.490658', 408794758, true, true, false, 'Lynda  Millar', NULL, NULL, NULL, 583778593, '04 802 0820', '021 510 378');
INSERT INTO users VALUES (1046772463, 'Lynda', 'Moe', 'soar2success@paradise.net.nz', '3fda3a7ee101fe3a08d585a69ab901d660b95ac7', '9a225169cc33f52e46ac7c3015c98941055931df', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.518956', NULL, '2008-11-27 09:14:53.508449', '2008-11-27 09:14:53.519737', 151679809, true, true, true, 'Lynda Moe Trasnsformations', '25 Vermont Street', 'Point Chevalier', NULL, 1030444527, '09 820 0633', '021 252 5537');
INSERT INTO users VALUES (1046772464, 'Lynda', 'Molen', 'pilateswithlydia@paradise.net.nz', 'f1064997e4b73652c6479807c34030c192d7f26e', 'e7d086146c63735639e7a5ed0ca4145cdf80dcf2', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.548191', NULL, '2008-11-27 09:14:53.537772', '2008-11-27 09:14:53.54901', 408794758, false, true, true, 'Lynda Molen', NULL, NULL, NULL, 583778593, '04 938 0676', '-');
INSERT INTO users VALUES (1046772465, 'Malcolm', 'Idoine', 'malcolmi@xtra.co.nz', '492a78702a3e25e3016cfcc95f76e922f855473c', 'e133939ac4c06b460be2eded6b9f3a29ea790a6e', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.577722', NULL, '2008-11-27 09:14:53.568156', '2008-11-27 09:14:53.578397', 151679809, true, true, true, 'Malcolm Idoine', NULL, 'Ponsonby', NULL, 1030444527, '-', '027 2345 333');
INSERT INTO users VALUES (1046772466, 'Mandy ', 'Pickering', 'info@jettherapynorthwest.co.nz', '195758a8b8f3d89be9479c399115eab5466ebd90', '9555af2ca52763ec26535e0c789f3a8da5f5643f', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.605297', NULL, '2008-11-27 09:14:53.596122', '2008-11-27 09:14:53.606056', 880982500, true, true, true, 'Jet Therapy North West', NULL, NULL, NULL, 266910087, '03 359 0280', '-');
INSERT INTO users VALUES (1046772467, 'Marcia ', 'Pollack', 'marciapnz@paradise.net.nz', '91a7473c8631a5813b7ce0a207a51c6cb0ebd165', 'acd2fe27794ac4b748e6348651d3d0f4ac76ab20', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.631319', NULL, '2008-11-27 09:14:53.621384', '2008-11-27 09:14:53.632092', 408794758, false, true, true, 'Marcia  Pollack', NULL, NULL, NULL, 583778593, '04 569 7923', '-');
INSERT INTO users VALUES (1046772468, 'Maree', 'Mason', 'victoriakidd@paradise.net.nz', '07b26eed9d2e21667fc2b86a5108c532becc3a8c', 'bc6e66a792b8c406601d70096d46c54fb533c4a0', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.65749', NULL, '2008-11-27 09:14:53.647669', '2008-11-27 09:14:53.658467', 880982500, true, true, true, 'In Touch', NULL, NULL, NULL, 266910087, '03 942 3104', '-');
INSERT INTO users VALUES (1046772469, 'Maria', 'Gibbons', 'casajam@xtra.co.nz', 'df9c6ee97ce206dbfaeabc08b71bbaf31009a82d', 'a91e3ddbc1f50c5023c18ef27d33126444ea023d', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.685752', NULL, '2008-11-27 09:14:53.67609', '2008-11-27 09:14:53.686468', 408794758, false, true, true, 'Maria Gibbons', NULL, NULL, NULL, 583778593, '04 232 3343', '-');
INSERT INTO users VALUES (1046772470, 'Maricia', 'Churchward', 'maricia@mamalu.co.nz', '31bcb9a3c56187fada2beb4a46f4213c11095061', '081461ccc36a016270241de080d03616d3efbbae', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.71431', NULL, '2008-11-27 09:14:53.703731', '2008-11-27 09:14:53.801627', 408794758, true, true, true, 'Mamalu Coaching Ltd', '512 Evans Bay Pde', 'Evans Bay', NULL, 583778593, '04 386 1463', '0272 861 463');
INSERT INTO users VALUES (1046772471, 'Marie ', 'Cameron', 'homeopathclinic@orcon.net.nz', '334d65ebab1eb6bcdb41cb3f37d1b50c166a7d78', '0d47b503a13047793d8b239ade4a2e365a2679c4', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.829457', NULL, '2008-11-27 09:14:53.818736', '2008-11-27 09:14:53.830272', 151679809, true, true, true, 'Homeopathic Healing Clinic', '137 Whitney Street', 'Browns Bay', NULL, 1030444541, '09 486 7731', '027 351 5217');
INSERT INTO users VALUES (1046772472, 'Marion', 'Kerr', 'marian@mariankerr.co.nz', 'aea46595de30ca16c339ae2b8a022432dbd18a8a', 'd2dece3b079727d22f3992af3f190395acbe7db3', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.855953', NULL, '2008-11-27 09:14:53.846101', '2008-11-27 09:14:53.85665', 408794758, true, true, false, 'contemplatecoaching', 'PO Box 5157', 'Whitby', NULL, 1030444603, '04 234 1957', '021266 2699');
INSERT INTO users VALUES (1046772473, 'Mariska', 'Deventer', 'Mariska@paradise.net.nz', '5b116bb9830cde06bcaa1dadf7d529a8f03f67ca', 'c7b910dcd90482a4c4790fa1b542b9b4e8b71652', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.886187', NULL, '2008-11-27 09:14:53.874764', '2008-11-27 09:14:53.887019', 408794758, false, true, true, 'Mariska Deventer', NULL, NULL, NULL, 583778593, '04 934 3368', '-');
INSERT INTO users VALUES (1046772474, 'Mark', 'Cross', 'contact@envistaconsulting.com', 'd4f08a62ee076bd159bb9d4e60622a5ef77a964f', '8cbd12c560375b4748a7517701de72548c106554', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.916799', NULL, '2008-11-27 09:14:53.904772', '2008-11-27 09:14:53.917565', 408794758, true, true, true, 'Envista Consulting', '15 Lawson Place', 'Mt. Victoria', NULL, 583778593, '-', '021 251 6727');
INSERT INTO users VALUES (1046772475, 'Mary', 'Romanos', 'maryromanos@slingshot.co.nz', '07043ce02cf1b2146d79c746f358bdc057c6f053', '3ac0cee499786262f8b7929e92154a943b61739e', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.943504', NULL, '2008-11-27 09:14:53.933607', '2008-11-27 09:14:53.944248', 408794758, true, true, true, 'Mary Romanos', NULL, NULL, NULL, 583778593, '-', '-');
INSERT INTO users VALUES (1046772476, 'Maureen ', 'Graham', 'maureengnz@yahoo.co.nz', 'e28c3e175a2c80c001246046c3c803ff1e41eec3', '8b9adca4752d624b5592d74ccc580bf5af597bd0', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.971667', NULL, '2008-11-27 09:14:53.959446', '2008-11-27 09:14:53.972527', 880982500, true, true, true, 'Maureen  Graham', NULL, NULL, NULL, 266910087, '03 338 1338', '-');
INSERT INTO users VALUES (1046772477, 'May', 'Sahar', 'maysahar@quantumconsulting.co.nz', '85c464df31759c6a5feda5234601097a7f399a3f', 'e86eb2ac2f7f6e3273ec19b501877e0f51206703', NULL, NULL, 'active', NULL, '2008-11-27 09:14:53.997575', NULL, '2008-11-27 09:14:53.988017', '2008-11-27 09:14:53.998323', 408794758, false, true, true, 'May Sahar', NULL, NULL, NULL, 583778593, '04 970 8007', '-');
INSERT INTO users VALUES (1046772478, 'Melinda', 'Bredin', 'Chiropractictouch@clear.net.nz', 'fb98b6904a06c8c3e9d41a05e98b8231c4579b73', 'd2af8c9d667a2e5cc38c7b5aad12d011bc71b380', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.023774', NULL, '2008-11-27 09:14:54.013874', '2008-11-27 09:14:54.02458', 151679809, true, true, true, 'Chiropractic Touch', NULL, NULL, NULL, 1030444527, '09 488 8001', '-');
INSERT INTO users VALUES (1046772479, 'Meredith', 'McCarthy', 'emmccarthy@xtra.co.nz', '0bd954d2170f198a25a96e66141c4aabeba43fbe', '1fa1e22d5abe27aad9d16cfd7a476b48175d9387', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.051745', NULL, '2008-11-27 09:14:54.040659', '2008-11-27 09:14:54.052507', 408794758, true, true, true, 'Meredith McCarthy', 'Manuka Health Centre,11 HectorSt ', 'Petone', NULL, 1030444602, '04 577 1116', '027 699 3950');
INSERT INTO users VALUES (1046772480, 'Michaela', 'Ballard', 'qe2massage@xtra.co.nz', '5b1cda029b04c7a9e4c3f9103ff2a6712c7ea86e', '2f65a4c5c63fe4d8f999c975dcf80d48e54afc7e', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.086031', NULL, '2008-11-27 09:14:54.075085', '2008-11-27 09:14:54.086751', 880982500, true, true, true, 'QE11 Clinical massage Therapy', NULL, NULL, NULL, 266910087, '03 383 5809', '-');
INSERT INTO users VALUES (1046772481, 'Mike', 'Smith', 'mike.therapy@gmail.com', '3e3af6d61cede4a102a964ff1dce14cb9ebc7a36', '7b8b7da52af1de571e2eedbde13288b1e8148439', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.111392', NULL, '2008-11-27 09:14:54.101752', '2008-11-27 09:14:54.112188', 151679809, true, true, true, 'Mike Smith', NULL, 'Mt. Albert', NULL, 1030444527, '09 815 2534', '021 660728');
INSERT INTO users VALUES (1046772482, 'Monika', 'Vadai', 'mvadai@hotmail.com', '965a61b1539560a292f62190f97496d126508ee1', '5a5546ca6398aa04b55b3364e7eabb91e34bf29f', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.138275', NULL, '2008-11-27 09:14:54.128254', '2008-11-27 09:14:54.139082', 151679809, true, true, true, 'Medicina Healing Centre', 'Shop 5, 13 Kent Street ', 'Newton', NULL, 1030444527, '-', '0211 603 528');
INSERT INTO users VALUES (1046772483, 'Nahaia', 'Russ N.D', 'nahaia@xtra.co.nz', '648cc415faaa88fd40ff29eed5aa2b8e4e38a87e', '09dd770f2939fd982d9bf23cd4ea70557fb537c3', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.163996', NULL, '2008-11-27 09:14:54.154053', '2008-11-27 09:14:54.166476', 151679809, true, true, true, 'Divine Lotus Healing Spa', NULL, NULL, NULL, 1030444541, '09 489 6999', '-');
INSERT INTO users VALUES (1046772484, 'Nalisha', 'Patel', 'nalisha@healthmastery.co.nz', '86bad61766baea39e33e6b26e478041412336011', '1fd71c967dfb9ac9b5c3542263081898b7958d62', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.192524', NULL, '2008-11-27 09:14:54.183137', '2008-11-27 09:14:54.193263', 151679809, true, true, true, 'Health Mastery Ltd', NULL, 'Manukau', NULL, 1030444540, '0508 742 736', '-');
INSERT INTO users VALUES (1046772485, 'Naomi', 'Saito Chong Nee', 'healingroom.lapis@yahoo.co.nz', '5d59f1fa184eb25ec879347a6e279e7871a6ea41', '7a433e9f321207378a16f627410b0399f7fcb89d', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.218882', NULL, '2008-11-27 09:14:54.209147', '2008-11-27 09:14:54.219577', 408794758, true, true, true, 'Naomi Saito Chong Nee', '2 Hinau Street', 'Linden', NULL, 583778593, '04 232 2965', '021 037 5091');
INSERT INTO users VALUES (1046772486, 'Natasha', 'Berman', 'allergytesting@ihug.co.nz', 'f4778a8192133f5f3627e8d241ef6573931e3267', 'e6c31e60125e947b78165dd2de496c0254636f32', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.338149', NULL, '2008-11-27 09:14:54.241442', '2008-11-27 09:14:54.338875', 151679809, true, true, true, 'Allergenics', NULL, NULL, NULL, 1030444527, '09 817 6110', '-');
INSERT INTO users VALUES (1046772487, 'Neil ', 'Bossenger', 'neil@spinewave.co.nz', 'e1892c8e0409fe49e5aacc4948e7402415237880', 'a6b7bc896e099103672968b989ee8a1799d5f938', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.367374', NULL, '2008-11-27 09:14:54.355232', '2008-11-27 09:14:54.368188', 151679809, true, true, true, 'Spinewave Wellness Centre', 'PO Box 44036', 'Remuera', NULL, 1030444527, '09 522 0025', '021 239 7623');
INSERT INTO users VALUES (1046772488, 'Ngaire', 'Francis', 'ngaire@restorativehealth.co.nz', 'fd6f7703ecd98a1966faaa3491ca7a6230e5d2ca', '62d21f543f60100733fc780f54009e89cd783870', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.397255', NULL, '2008-11-27 09:14:54.38731', '2008-11-27 09:14:54.397954', 408794758, true, true, true, 'restorative Health', NULL, NULL, NULL, 583778593, '04 890 3880', '-');
INSERT INTO users VALUES (1046772489, 'Niel', 'Pryor', 'neilpryor@paradise.net.nz', '380fcfb189ec75fd55527f371e05a6db3de3072c', 'ee8fefe3f2813c0cb9d6b5711026f6e2f047e7fb', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.424529', NULL, '2008-11-27 09:14:54.414821', '2008-11-27 09:14:54.425357', 408794758, false, true, true, 'Niel Pryor', NULL, NULL, NULL, 583778593, '04 472 9222', '-');
INSERT INTO users VALUES (1046772490, 'Norma', 'Stein', 'norma@eurekacoaching.co.nz', 'c62efb67bad454f613804e673b6e31ee965e7226', 'd2f1fad7c5271d4e5b5218e38ad9e0f15ca991ce', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.457942', NULL, '2008-11-27 09:14:54.442057', '2008-11-27 09:14:54.458665', 408794758, true, true, true, 'Eureka!Coaching', '20 Finlay Terrace', 'Mt Cook', NULL, 583778593, '04 801 8847', '021 549 923');
INSERT INTO users VALUES (1046772491, 'Pamela', 'Mercer', 'dmercer@actrix.co.nz', '0cfc987f807ce78347613af6775b5de5b7ec311f', '3e8de542e0addf25a7ef60c78f82d063ab64f5d4', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.487115', NULL, '2008-11-27 09:14:54.47642', '2008-11-27 09:14:54.487881', 880982500, true, true, true, 'Cranio Sacral Therapy', NULL, NULL, NULL, 266910087, '03 352 0082', '-');
INSERT INTO users VALUES (1046772492, 'Pat', 'Guo', 'patguo@gmail.com', 'd12d160697ec64f1e525cb3d67834c87ca7cfead', '74c12f85be7c378f59257958efe735ebfaa1e70b', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.512122', NULL, '2008-11-27 09:14:54.502837', '2008-11-27 09:14:54.512843', 880982500, true, true, true, 'Christchurch Acupuncture Centre', NULL, NULL, NULL, 266910087, '03 354 2398', '-');
INSERT INTO users VALUES (1046772493, 'Paula ', 'Johnson', 'innerspirit@xtra.co.nz', 'fde5fb6cc277b119f3fdc46baf57a323cb91fe9d', 'e7c36450a7ca802dce74da1970e6c142bc549e66', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.538521', NULL, '2008-11-27 09:14:54.528369', '2008-11-27 09:14:54.539267', 408794758, true, true, true, 'Balance & Harmony', NULL, NULL, NULL, 583778593, '04 526 7842', '-');
INSERT INTO users VALUES (1046772494, 'Philip', 'Bayliss', 'phil.bayliss@orcon.net.nz', 'fa8f2721691ff7168ab1f1b7507d606fd7eaf7ca', '156ae2460865b00da4a6b1847906f080a35ef2b7', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.565501', NULL, '2008-11-27 09:14:54.554705', '2008-11-27 09:14:54.566877', 880982500, true, true, true, 'Philip Bayliss St Albans Osteopathy', NULL, NULL, NULL, 266910087, '03 356 1353', '-');
INSERT INTO users VALUES (1046772495, 'Phillipe', 'Campays', 'sol2@xtra.co.nz', '696b9b2d777826e56e6efc334f8705518d76737c', 'dd0c9722666b99abeda128220da6cdd1d9a5bf39', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.595069', NULL, '2008-11-27 09:14:54.58575', '2008-11-27 09:14:54.595732', 408794758, true, true, true, 'Sacred Design', NULL, NULL, NULL, 583778593, '04 380 1233', '021 501 502');
INSERT INTO users VALUES (1046772496, 'Priya', 'Punjabi', 'priya@ayurvedic.co.nz', '0edda02fdc8882328a7378edc543a4ff1e4629bf', '3a909d90d764fe260875bb07a111ccb68a35bb90', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.623169', NULL, '2008-11-27 09:14:54.613567', '2008-11-27 09:14:54.624204', 151679809, true, true, true, 'Ultimate Ayurveda Health Centre', '641 Sandringham Rd', 'Mt. Albert', NULL, 1030444527, '09 829 2045', '021 253 0961');
INSERT INTO users VALUES (1046772497, 'Rachael', 'Feather', 'rachael.feather@gmail.com', '99ff109b56a1fb87438196a608cc97c69526da61', '54309c43df3e6ceaf114d09bf2bfea6132211c57', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.656195', NULL, '2008-11-27 09:14:54.646448', '2008-11-27 09:14:54.65703', 151679809, true, true, true, 'Rachael Feather', NULL, NULL, NULL, 1030444527, '-', '021 067 4676');
INSERT INTO users VALUES (1046772498, 'Rae', 'Torrie', 'rae.torrie@clear.net.nz', '350ad31c4340aebabf07eaec617b78651ab8d623', 'e2259ca9327a1b871a88d85a3ba09357a91eed47', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.684951', NULL, '2008-11-27 09:14:54.67533', '2008-11-27 09:14:54.685684', 408794758, false, true, true, 'Rae Torrie', NULL, NULL, NULL, 583778593, '04 389 0488', '-');
INSERT INTO users VALUES (1046772499, 'Rebecca ', 'Erlwein', 'rebecca@japaneseacupuncture.co.nz', '7b5b6a062d00a181332f65bab7a896070c3c03c2', '12d1feaa216c14d23700881db29985f7b0fd043d', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.711047', NULL, '2008-11-27 09:14:54.701249', '2008-11-27 09:14:54.711745', 408794758, true, true, true, 'Japanese Acupuncture', '64 Hapua Street', 'Hataitai', NULL, 583778593, '04 938 1017', '-');
INSERT INTO users VALUES (1046772500, 'Rekha', 'Patel', 'rekha@globe.net.nz ', '2e284404d58ca309977c789cf2911e5f204f144c', 'add43d1209b9fd1db43e187e436be44b373f83a6', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.739492', NULL, '2008-11-27 09:14:54.727952', '2008-11-27 09:14:54.740166', 408794758, false, true, true, 'Rekha Patel', NULL, NULL, NULL, 583778593, '04 385 3569', '-');
INSERT INTO users VALUES (1046772501, 'Robin', 'Kerr', 'robin.kerr@zhengqi.co.nz', '66504c73a5a6b95c8e6d8093131858006052a266', '0866ad295cc0d927962629e795d47a43f21bdcdd', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.770469', NULL, '2008-11-27 09:14:54.757684', '2008-11-27 09:14:54.771306', 880982500, true, true, true, 'Zheng Qi', '57 Morgans Valley', 'Lyttelton', NULL, 266910087, '03 328 8295', '027 2411748');
INSERT INTO users VALUES (1046772502, 'Rose', 'Whyte', 'rose@backtobasics.co.nz', '09d971d5c94c855068fdacb344d153f65afd94a7', 'ec9853074351bb91c57a7517fb9e82d51696fe50', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.885238', NULL, '2008-11-27 09:14:54.875069', '2008-11-27 09:14:54.885978', 151679809, true, true, true, 'Back to Basics', 'PO Box 5911 Wellesley Street', NULL, NULL, 1030444527, '09 483 8580', '-');
INSERT INTO users VALUES (1046772503, 'Rupert', 'Watson', 'rupert.watson@paradise.co.nz', '6322599095f74b53a452175dbd62c516b414b3b9', '9b2905f864b08616a0091e29cdd115383e0d43b2', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.914156', NULL, '2008-11-27 09:14:54.904175', '2008-11-27 09:14:54.914945', 408794758, true, true, false, 'Ghuznee Health Associates', 'Level 2, The Terrace', NULL, NULL, 583778593, '04 801 6610', '-');
INSERT INTO users VALUES (1046772504, 'Ruth', 'Donde', 'ruth@onecoach.co.nz', '4dcd24d0c43bd3aa47c7bf2f97db7351456ce908', 'fd18dc76db4d82a0a10918fa1c45ed3bce0b26ac', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.942087', NULL, '2008-11-27 09:14:54.930729', '2008-11-27 09:14:54.942979', 151679809, true, true, false, 'One', '4/8 Kells Place, Highland Park', 'Howick', NULL, 1030444540, '09 534 8744', '027 2745625');
INSERT INTO users VALUES (1046772505, 'Ruth', 'van Dongen', 'ruth@watsu.co.nz', '65e5471094a7b9ce11d0524c0f08a03c683f8c48', '76b82524ba38c8134749065b5948429847903010', NULL, NULL, 'active', NULL, '2008-11-27 09:14:54.97888', NULL, '2008-11-27 09:14:54.962042', '2008-11-27 09:14:54.97966', 151679809, true, true, true, 'Ruth van Dongen', 'PO Box95027', 'Torbay', NULL, 1030444541, '09 473 0997', '-');
INSERT INTO users VALUES (1046772506, 'Sally ', 'Anderson', 'sal.anderson@xtra.co.nz', 'd93b2f52f56c66cbaebd034f7d8bbed1cb99f15d', '7af1df6f60f9e8f55a1a9fff3d015e0ae6c070b7', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.006917', NULL, '2008-11-27 09:14:54.996859', '2008-11-27 09:14:55.007614', 880982500, true, true, true, 'Sally Anderson Life Coach and Professional Mentor', NULL, NULL, NULL, 266910087, '-', '027 688 5551');
INSERT INTO users VALUES (1046772507, 'Sally ', 'Goldsworthy', 'f.goldsworthy@clear.net.nz', '9ecf01eb6edab40f7b09d766023dabcdddcd2d7d', 'd784310b3ac620eb4c46a7c0c3428dd4d4a17c63', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.033134', NULL, '2008-11-27 09:14:55.023074', '2008-11-27 09:14:55.033905', 880982500, true, true, true, 'Sally Goldsworthy - Kinesiologist', NULL, NULL, NULL, 266910087, '03 942 1193', '-');
INSERT INTO users VALUES (1046772508, 'Sally', 'Barret', 'sally.barrett@paradise.net.nz', 'f3a874ac87a1534ec9ef201459b27b1c49ed4152', 'e8ced65bc97a1489b47c925708981394494b1ac3', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.060113', NULL, '2008-11-27 09:14:55.049964', '2008-11-27 09:14:55.060813', 151679809, false, true, true, 'Sally Barret', NULL, NULL, NULL, 1030444527, '09 415 7046', '-');
INSERT INTO users VALUES (1046772509, 'Samantha ', 'Gadd', 'samantha@sweeten.co.nz', '16098a7b3281e5c5cfea264e844d6713dea0aedd', 'f85f96734dc323c9947c37196b3ac2b992fd794d', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.088759', NULL, '2008-11-27 09:14:55.078797', '2008-11-27 09:14:55.089557', 408794758, true, true, true, 'Sweeten Ltd', '10 Caprera Street', 'Melrose', NULL, 583778593, '-', '021 999 269');
INSERT INTO users VALUES (1046772510, 'Sarona', 'Hawkins', 'discoveryou@paradise.net.nz', '864d577b9133f3fd5cbceb1d72e72991468e0b2b', '331c0dfc9e20c47b7ad2c0d96b87802718a370b3', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.116171', NULL, '2008-11-27 09:14:55.105389', '2008-11-27 09:14:55.116975', 408794758, false, true, true, 'Sarona Hawkins', NULL, NULL, NULL, 583778593, '04 234 8472', '-');
INSERT INTO users VALUES (1046772511, 'Saskia', 'Clements', 'saskia@exceptionallife.co.nz', '021095a37d63344e6860dfd774f1b4dcf178d628', '8d156a606a74ee34877ee6061916edf737df0d4f', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.145695', NULL, '2008-11-27 09:14:55.135418', '2008-11-27 09:14:55.146437', 880982500, true, true, false, 'Exceptional Life', '26a Voelas Rd', 'Merivale', NULL, 266910087, '03 355 4276', '021 822 800');
INSERT INTO users VALUES (1046772512, 'Shabina', 'Yakub', 'info@bodytonic@xtra.co.nz', 'bfb44e6e8451fae3d8f3503f9e0da610760b5bcc', 'd0ec6b32bae7f1b171ef9f3776b4eb4fbb3b542d', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.174693', NULL, '2008-11-27 09:14:55.162101', '2008-11-27 09:14:55.175512', 408794758, true, true, true, 'Body Tonic', NULL, NULL, NULL, 583778593, '04 382 9980', '-');
INSERT INTO users VALUES (1046772513, 'Shane', 'Anderson', 'shane@bodyspeacialist.co.nz', '6b965a5c868ad389676b765a88818b2507423fec', '32a3286564d5c718f663479a7ebac06c23983fb2', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.20102', NULL, '2008-11-27 09:14:55.191437', '2008-11-27 09:14:55.20176', 151679809, true, true, true, 'Bodyline Massage Specialists', '45 Arran Street', 'Blockhouse Bay', NULL, 1030444527, '-', '021 277 7533');
INSERT INTO users VALUES (1046772514, 'Shane', 'Reeves', 'shany@body-alive.com', 'dc63998b0278036da0de012fe47c96f5bd2da71f', 'f96e3b80a3d31364c70b89934fd4fe37b712a990', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.229853', NULL, '2008-11-27 09:14:55.219986', '2008-11-27 09:14:55.230525', 151679809, true, true, true, 'Body Alive', NULL, NULL, NULL, 1030444527, '-', '021 132 4847');
INSERT INTO users VALUES (1046772515, 'Sharon', 'Erdrich', 'sharon@houseofhealth.co.nz', '99f9d3fe25d541b943f058514c4368ec920e6e21', '859942428fcb93258c73cbf77ad065c5f82f73f8', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.258351', NULL, '2008-11-27 09:14:55.248687', '2008-11-27 09:14:55.259096', 151679809, true, true, true, 'House of Health, Herne bay', 'Private Bag 78129, ', 'Herne Bay', NULL, 1030444527, '09 360 0550', '027 239 3003');
INSERT INTO users VALUES (1046772516, 'Sharon', 'Kearney', 'shaz.kev@xtra.co.nz', '088d6547802348ecb244247ad469ed9e0f8f0fb4', '92636546cc39fa10f9315dc2d64928c704002076', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.286534', NULL, '2008-11-27 09:14:55.276469', '2008-11-27 09:14:55.287209', 880982500, true, true, true, 'Papanui Physiotherapy Sports & Pilates Clinic', NULL, NULL, NULL, 266910087, '03 352 0395', '-');
INSERT INTO users VALUES (1046772517, 'Sharyn', 'Haigh', 'sharyn.haigh@xtra.co.nz', '36f988cb361ba11a707ccf1aa0dfe8a5b8833074', '53437990fa6d88c9613b7dd655dd3ff409ed3fa0', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.399139', NULL, '2008-11-27 09:14:55.30296', '2008-11-27 09:14:55.399873', 408794758, true, true, true, 'Sharyn Haigh', 'PO Box 22 316', 'Khandallah', NULL, 583778593, '04 4731940', '027 455 0949');
INSERT INTO users VALUES (1046772518, 'Sherie', 'Bajon', 'healingdirect@paradise.net.nz', '60d1e6bf4dca6c405fe86397db0629e97d202711', '4a9549b6f8ebe73d5e4c1b7e07d857d39a9b7d44', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.426413', NULL, '2008-11-27 09:14:55.41641', '2008-11-27 09:14:55.427117', 880982500, true, true, true, 'Healing Direct', NULL, NULL, NULL, 266910087, '03 942 0144', '-');
INSERT INTO users VALUES (1046772519, 'Simon', 'Elwell', 'simon@sacredspace.co.nz', 'e53ab64572bfecdacec4bb17b0c36cd8f4693666', '00d451f8221fed6a04fbc9cfc41b81b1ff2e8e7c', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.453759', NULL, '2008-11-27 09:14:55.44336', '2008-11-27 09:14:55.454533', 408794758, true, true, true, 'Simon Elwell', '2/2 Caprera Street', NULL, NULL, 583778593, '-', '021 799 330');
INSERT INTO users VALUES (1046772520, 'Simona', 'Fielder', 'simona@orcon.net.nz', '2a2563835eae9963ddcacc2f71d47b546823c85c', '26eda939299359d7231598994e693b93730c42a0', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.485136', NULL, '2008-11-27 09:14:55.470542', '2008-11-27 09:14:55.485883', 151679809, true, true, true, 'Simona Fielder', 'PO Box 276 171', 'Mission Bay', NULL, 1030444527, '-', '021 062 9972');
INSERT INTO users VALUES (1046772521, 'Stephanie', 'Philps', 'steph@metamorphosis.co.nz', '61f5bb8ee7d06d4c4e59e3511b5f3e593b81d248', '7e5601d91e96017ac4a8d3e7a1e5cc5be1ace15c', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.513383', NULL, '2008-11-27 09:14:55.503106', '2008-11-27 09:14:55.514113', 151679809, true, true, true, 'Stephanie Philps', '48 Bellevue Road', 'Greenlane', NULL, 1030444527, '09 636 3133', '-');
INSERT INTO users VALUES (1046772522, 'Sue', 'Boleyn', 'tudor@ihug.co.nz', 'cfbab657e9616c141ea12d3e42a29828ce750ea5', 'ee5ddcf3ed9c56b453bda0d095881066f845c3c5', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.539734', NULL, '2008-11-27 09:14:55.529901', '2008-11-27 09:14:55.540535', 880982500, true, true, true, 'Tudor Manor Massage & Beauty Therapy Clinic', NULL, NULL, NULL, 266910087, '03 338 8224', '-');
INSERT INTO users VALUES (1046772523, 'Sue', 'Jones', 'info@suejones.co.nz', '7ecc12664ed6160effd690858aa3e361fc1e16c5', '691198cfad04e09d477c3f36fc67ea1d7dc1edf0', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.565825', NULL, '2008-11-27 09:14:55.556232', '2008-11-27 09:14:55.5665', 880982500, true, true, true, 'Sue Jones', 'Aylesbury, RD 1', NULL, NULL, 266910087, '03 318 1293', '027 614 8701');
INSERT INTO users VALUES (1046772524, 'Susan', 'Finlay', 'finlaygroup@xtra.co.nz', '16ae2fed46700d152388c15ff1c2e03f257d1d23', 'ec51c00382b00ba3e4b7f733bbe272ee5e31bf6a', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.593937', NULL, '2008-11-27 09:14:55.583207', '2008-11-27 09:14:55.59466', 408794758, false, true, true, 'Susan Finlay', NULL, NULL, NULL, 583778593, '04 234 1463', '-');
INSERT INTO users VALUES (1046772525, 'Susie', 'Herriott', 'susieherriott@yahoo.com', '4a6b666236b9edd9ab3b1115c7e44ca254a43dde', '51640a5f35b658339a668128c47b6b01f8bfff01', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.619535', NULL, '2008-11-27 09:14:55.609809', '2008-11-27 09:14:55.620212', 408794758, false, true, true, 'Susie Herriott', NULL, NULL, NULL, 583778593, '04 234 8495', '-');
INSERT INTO users VALUES (1046772526, 'Tamara', 'Androsoff', 'healinglightnz@yahoo.co.nz', '49b075c56e6ca5b337368e1d3603555a569276a1', '634ad7a3c106baed84bbf5b74a3e06ca05db61dd', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.645692', NULL, '2008-11-27 09:14:55.635966', '2008-11-27 09:14:55.646397', 151679809, true, true, true, 'Tamara Androsoff', 'PO Box 11-939', 'Glen Eden', NULL, 1030444544, '09 813 5361', '-');
INSERT INTO users VALUES (1046772527, 'Tamara', 'Warrington', 'tamara_warrington@hotmail.com', '7b977e8df70b833db3c825acc424712ce51f774b', 'd6b50b5d2b6c969ab52ad687c80ec8a5a6ff64a7', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.676624', NULL, '2008-11-27 09:14:55.66417', '2008-11-27 09:14:55.677387', 880982500, true, true, true, 'ESSENCE Therapeutic Body Replenishment', NULL, NULL, NULL, 266910087, '03 981 5452', '-');
INSERT INTO users VALUES (1046772528, 'Tania', 'Laing', 'Laing@kiwiwebhost.sarcoma.net.nz', 'eb2c7a30dbf639fdcdda365ffd54556afe7d807b', '781440f65d0bed35a539ad3d86833b3d75bb7f86', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.703701', NULL, '2008-11-27 09:14:55.694299', '2008-11-27 09:14:55.70456', 151679809, true, true, true, 'Tania Laing Homeopathy', NULL, 'Ellerslie', NULL, 1030444527, '09 579 3055', '027 688 9204');
INSERT INTO users VALUES (1046772529, 'Tanya', 'Park', 'massagechi@gmail.com', 'fc96ef57b9607754be2f02aeb0706d0255597c6d', '98c50fa6740cd208bb224300c11eb253c2caac7b', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.732278', NULL, '2008-11-27 09:14:55.721926', '2008-11-27 09:14:55.733037', 151679809, true, true, true, 'Tanya Park', '578 Mt. Eden Road', 'Mt.Wellington', NULL, 1030444527, '-', '-');
INSERT INTO users VALUES (1046772530, 'Tejas', 'Ishaya', 'newzealand@ishaya.org', '1404be290f362d9411fbee4ff5bcce72cec154f3', 'ed1576abb2be18c9bf1bffd4e90d70dca59b716d', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.759716', NULL, '2008-11-27 09:14:55.74999', '2008-11-27 09:14:55.760468', 151679809, true, true, true, 'The NZ Ishayas', 'PO Box 291', 'Saint Heliers', NULL, 1030444527, '09 528 8315', '-');
INSERT INTO users VALUES (1046772531, 'Tim', 'Girvan', 'timgirvan@gmail.com', '17d9a0d30c0c990c257851d850971af944ffd1a9', '587b00d781aedc2d44b89ca9ff001288ee577c68', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.787875', NULL, '2008-11-27 09:14:55.778126', '2008-11-27 09:14:55.788612', 151679809, true, true, false, 'Bellevue Health Centre', '779 New North Road', 'Mt. Eden', NULL, 1030444527, '09 630 6331', '021 206 0487');
INSERT INTO users VALUES (1046772532, 'Tim', 'Green', 'tim@pilatespersonal.co.nz', '1b41999663ea4506fe95c0c4add7214be99dbeea', '3cad34a869832c7b40eeaa2ab7eb71faab7ee514', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.81263', NULL, '2008-11-27 09:14:55.803458', '2008-11-27 09:14:55.813298', 880982500, true, true, true, 'Pilates Personal Fitness Studio', NULL, NULL, NULL, 266910087, '03 377 4649', '-');
INSERT INTO users VALUES (1046772533, 'Toni ', 'Kenyon', 'heartofhealth@clear.net.nz', 'f99d3562bd3a736fea3c05160eeed2d8c33e4fc2', 'f7c5560d1e4c2e96913bb6d825db88d18f50f525', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.928571', NULL, '2008-11-27 09:14:55.83035', '2008-11-27 09:14:55.92932', 151679809, true, true, true, 'Toni  Kenyon', NULL, NULL, NULL, 1030444527, '09 4432788', '-');
INSERT INTO users VALUES (1046772534, 'Toni ', 'Stewart', 'toni@flourishcoaching.co.nz', 'bd00bc87b389ae4036aab57b1d9dc37372ba4126', '4a7765354f7fff9206f05c8688bb8e0ba500edc1', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.955883', NULL, '2008-11-27 09:14:55.945803', '2008-11-27 09:14:55.956673', 880982500, true, true, true, 'Flourish Coaching', NULL, 'Merivale', NULL, 266910087, '03 356 1188', '021 102 5578');
INSERT INTO users VALUES (1046772535, 'Tracy ', 'Keith', 'tracy@tmkconsulting.co.nz', 'a5653ce5bca3e33c919d8cd993dc7ed9b95568d5', '1a21d5c812a382593f8f4dfe206a3a71543473ec', NULL, NULL, 'active', NULL, '2008-11-27 09:14:55.985265', NULL, '2008-11-27 09:14:55.972794', '2008-11-27 09:14:55.985979', 408794758, true, true, false, 'tmkconsulting', NULL, NULL, NULL, 583778593, '04 479 7327', '021 044 5454');
INSERT INTO users VALUES (1046772536, 'Tralee', 'Clark', 'absolute-massage@xtra.co.nz', '533b7cef90a177138ef8989fa15f6638428040aa', 'b4622a8068e922295765fb6f3272a5a652425e78', NULL, NULL, 'active', NULL, '2008-11-27 09:14:56.016365', NULL, '2008-11-27 09:14:56.00451', '2008-11-27 09:14:56.017051', 408794758, true, true, true, 'Absolute Massage', NULL, NULL, NULL, 583778593, '04 801 8284', '-');
INSERT INTO users VALUES (1046772537, 'Trina', 'Burt', 'trina-burt@free.net.nz', 'dcabc47602541709ecf02af2fbb35a0db87e94d8', 'a0b4f36e6cd9ce0133e4b5b5d10b3c2d2d172cdd', NULL, NULL, 'active', NULL, '2008-11-27 09:14:56.044548', NULL, '2008-11-27 09:14:56.034708', '2008-11-27 09:14:56.045302', 880982500, true, true, true, 'Trina Burt', NULL, NULL, NULL, 266910087, '-', '-');
INSERT INTO users VALUES (1046772538, 'Trish', 'Pattison', 'Trish@freelivingbydesign.com', 'f1fd414c639c053854a1c91a68db103a60d80ace', '9d087874f7fd690ea5f1ad14a60df354ffaf0ae4', NULL, NULL, 'active', NULL, '2008-11-27 09:14:56.070959', NULL, '2008-11-27 09:14:56.061087', '2008-11-27 09:14:56.071698', 408794758, false, true, true, 'Trish Pattison', NULL, NULL, NULL, 583778593, '04 389 6609', '-');
INSERT INTO users VALUES (1046772539, 'Tui ', 'Parker', 'tuivolve@yahoo.com', 'eb10a9c71c3d7895666d68b305f21ffad3f39dba', '808984713175d051ab4d94be7f5b82071dbd0186', NULL, NULL, 'active', NULL, '2008-11-27 09:14:56.09911', NULL, '2008-11-27 09:14:56.089641', '2008-11-27 09:14:56.099873', 408794758, true, true, true, 'Ora Natural Therapies', NULL, NULL, NULL, 583778593, '04 499 9979', '021 238 0061');
INSERT INTO users VALUES (1046772540, 'Valee', 'More', 'oasisclinic@slingshot.co.nz', '277c9e8a6a871a83b87c349d390cab5eeb3fecd0', '31c659a39325a809f37417cd33746b3d4195d9ba', NULL, NULL, 'active', NULL, '2008-11-27 09:14:56.127354', NULL, '2008-11-27 09:14:56.11736', '2008-11-27 09:14:56.128279', 151679809, false, true, true, 'The Oasis Clinic', '12 Cooper Street', 'Massey', NULL, 1030444527, '09 8329273', '-');
INSERT INTO users VALUES (1046772541, 'Vanessa', 'Lukes', 'vanessalukes@chigong.co.nz', 'fdab3b25765f94ed0897a4fb7493e6e37dd714d0', '672bc229f22876fa84b6dc4694640e5e01f7f441', NULL, NULL, 'active', NULL, '2008-11-27 09:14:56.155505', NULL, '2008-11-27 09:14:56.14579', '2008-11-27 09:14:56.156264', 880982500, true, true, true, 'Chigong Christchurch', 'Upstairs Merivale Mall', 'Opawa', NULL, 266910087, '03 981 7580', '-');
INSERT INTO users VALUES (1046772542, 'Waveney', 'Reta', 'waveneyr@globe.net.nz', '39dd7622d70b865b6700c02fc1ed1ebcf38be49b', 'acf0d073abaff1720385f7b44ed00452e19de01d', NULL, NULL, 'active', NULL, '2008-11-27 09:14:56.184796', NULL, '2008-11-27 09:14:56.173691', '2008-11-27 09:14:56.185617', 408794758, true, true, true, 'Waveney Reta Therapies', '2nd Floor, 53 Courtney Place', NULL, NULL, 583778593, '04  385 4342', '021 384 308');
INSERT INTO users VALUES (1046772543, 'Wenchaun', 'Huang', 'hwenchuan@sina.com.cn', 'dbf1c7959151c6de9af86196c8f9bb00e70a9eca', '35bea59f7f4c4a31834e6ac80ee69db255f2aac7', NULL, NULL, 'active', NULL, '2008-11-27 09:14:56.216741', NULL, '2008-11-27 09:14:56.206132', '2008-11-27 09:14:56.21762', 151679809, true, true, true, 'Dr Win Acupuncture Clinic', NULL, 'Newmarket', NULL, 1030444527, '09 5296185', '021 1793736');
INSERT INTO users VALUES (1046772544, 'Wendy', 'Rushworth', 'wotzarushworth@yahoo.com', '74bf895524a81a7a8a5a682a35840a8da702bc98', 'd4d92f47f85cb267dd2e1f059344ab9beab9f7d4', NULL, NULL, 'active', NULL, '2008-11-27 09:14:56.247405', NULL, '2008-11-27 09:14:56.236367', '2008-11-27 09:14:56.248273', 880982500, true, true, true, 'Balance Massage Therapy', NULL, NULL, NULL, 266910087, '03 337 3237', '-');
INSERT INTO users VALUES (1046772545, 'Xanthe', 'Ashton', 'xanthe@reflexology.co.nz', '2bbbe97db38884ffd71ba7fbeccff289cd89bf33', '315803a5d513a448eae039e47092aafc9138340e', NULL, NULL, 'active', NULL, '2008-11-27 09:14:56.276484', NULL, '2008-11-27 09:14:56.264574', '2008-11-27 09:14:56.277285', 880982500, true, true, true, 'Xanthe Ashton', '100 Highstead Road', 'Halswell', NULL, 266910087, '03 322 4858', '-');
INSERT INTO users VALUES (1046772546, 'Yumi', 'Sato', 'yumis@xtra.co.nz', 'f7f2054ac7fd6b4e3484cd41ca81841ae62b2216', 'a3566741fdc3e1e7e46986447a0651cbb2677b23', NULL, NULL, 'active', NULL, '2008-11-27 09:14:56.306059', NULL, '2008-11-27 09:14:56.29657', '2008-11-27 09:14:56.306785', 880982500, true, true, true, 'Yumi Sato', NULL, NULL, NULL, 266910087, '03 331 7356', '-');
INSERT INTO users VALUES (1046772547, 'Yvette', 'Blades', 'ybb@actrix.co.nz', '7c6c94c935608f8a1bd06e55d9bdf81f271956fb', '8c725b38804db959f88ccc2b96a7e2b05ac3841b', NULL, NULL, 'active', NULL, '2008-11-27 09:14:56.332617', NULL, '2008-11-27 09:14:56.322373', '2008-11-27 09:14:56.333484', 408794758, false, true, true, 'Yvette Blades', NULL, NULL, NULL, 583778593, '04 589 1652', '-');
INSERT INTO users VALUES (1046772548, 'Yvonne', 'Louwers', 'ybml@xtra.co.nz', '4e9f7abc13f6140f8028582c6c6aa490072c5d69', '472001f33fd9d110c6f7a6e43860e4db8dbd3a28', NULL, NULL, 'active', NULL, '2008-11-27 09:14:56.359863', NULL, '2008-11-27 09:14:56.349987', '2008-11-27 09:14:56.360606', 408794758, true, true, false, 'Yvonne Louwers', NULL, NULL, NULL, 583778593, '04 232 3979', '021 127 3120');
INSERT INTO users VALUES (696603906, 'Cyrille', 'Bonnet', 'cbonnet99@gmail.com', '261fd559c11e3931bd9f87fe8babb4ee8b196c56', '356a192b7913b04c54574d18c28d46e6395428ab', NULL, NULL, 'active', NULL, '2008-11-22 09:14:47', NULL, '2008-11-22 09:14:47', '2008-11-28 08:16:59.341009', 408794758, true, true, false, NULL, NULL, NULL, NULL, 583778593, '-', '-');


--
-- Name: articles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: articles_subcategories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY articles_subcategories
    ADD CONSTRAINT articles_subcategories_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: districts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);


--
-- Name: passwords_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY passwords
    ADD CONSTRAINT passwords_pkey PRIMARY KEY (id);


--
-- Name: regions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: roles_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY roles_users
    ADD CONSTRAINT roles_users_pkey PRIMARY KEY (id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: subcategories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subcategories
    ADD CONSTRAINT subcategories_pkey PRIMARY KEY (id);


--
-- Name: subcategories_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subcategories_users
    ADD CONSTRAINT subcategories_users_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_articles_subcategories_on_article_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX index_articles_subcategories_on_article_id ON articles_subcategories USING btree (article_id);


--
-- Name: index_articles_subcategories_on_subcategory_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX index_articles_subcategories_on_subcategory_id ON articles_subcategories USING btree (subcategory_id);


--
-- Name: index_roles_users_on_role_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX index_roles_users_on_role_id ON roles_users USING btree (role_id);


--
-- Name: index_roles_users_on_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX index_roles_users_on_user_id ON roles_users USING btree (user_id);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX index_sessions_on_session_id ON sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX index_sessions_on_updated_at ON sessions USING btree (updated_at);


--
-- Name: index_subcategories_users_on_subcategory_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX index_subcategories_users_on_subcategory_id ON subcategories_users USING btree (subcategory_id);


--
-- Name: index_subcategories_users_on_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX index_subcategories_users_on_user_id ON subcategories_users USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

