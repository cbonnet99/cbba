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
    START WITH 1
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

SELECT pg_catalog.setval('articles_id_seq', 1, false);


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
    START WITH 1
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

SELECT pg_catalog.setval('articles_subcategories_id_seq', 1, false);


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

SELECT pg_catalog.setval('categories_id_seq', 6, true);


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

SELECT pg_catalog.setval('districts_id_seq', 130, true);


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
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE payments (
    id integer NOT NULL,
    title character varying(255),
    user_id integer,
    amount integer,
    "comment" character varying(255),
    invoice_number character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.payments_id_seq OWNER TO postgres;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE payments_id_seq OWNED BY payments.id;


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('payments_id_seq', 1, false);


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

SELECT pg_catalog.setval('regions_id_seq', 18, true);


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

SELECT pg_catalog.setval('roles_id_seq', 3, true);


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

SELECT pg_catalog.setval('roles_users_id_seq', 230, true);


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
    START WITH 1
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

SELECT pg_catalog.setval('sessions_id_seq', 1, false);


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

SELECT pg_catalog.setval('subcategories_id_seq', 64, true);


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

SELECT pg_catalog.setval('subcategories_users_id_seq', 225, true);


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
    START WITH 1
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

SELECT pg_catalog.setval('taggings_id_seq', 1, false);


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
    START WITH 1
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

SELECT pg_catalog.setval('tags_id_seq', 1, false);


--
-- Name: user_events; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_events (
    id integer NOT NULL,
    source_url character varying(255),
    destination_url character varying(255),
    remote_ip character varying(255),
    logged_at timestamp without time zone,
    extra_data text,
    event_type character varying(255),
    user_id integer
);


ALTER TABLE public.user_events OWNER TO postgres;

--
-- Name: user_events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.user_events_id_seq OWNER TO postgres;

--
-- Name: user_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_events_id_seq OWNED BY user_events.id;


--
-- Name: user_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_events_id_seq', 1, false);


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

SELECT pg_catalog.setval('users_id_seq', 229, true);


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

ALTER TABLE payments ALTER COLUMN id SET DEFAULT nextval('payments_id_seq'::regclass);


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

ALTER TABLE user_events ALTER COLUMN id SET DEFAULT nextval('user_events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: articles; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: articles_subcategories; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO categories VALUES (1, 'Practitioners', '2008-12-02 22:48:58.483512', '2008-12-02 22:49:07.175354', 1, 129);
INSERT INTO categories VALUES (2, 'Coaching', '2008-12-02 22:48:58.621104', '2008-12-02 22:49:07.184273', 2, 25);
INSERT INTO categories VALUES (3, 'Health centre', '2008-12-02 22:48:58.681766', '2008-12-02 22:49:07.192116', 3, 4);
INSERT INTO categories VALUES (4, 'Courses', '2008-12-02 22:48:58.86005', '2008-12-02 22:49:07.201551', 4, 23);
INSERT INTO categories VALUES (5, 'Massage', '2008-12-02 22:48:59.326161', '2008-12-02 22:49:07.210039', 5, 42);
INSERT INTO categories VALUES (6, 'Beauty salons', '2008-12-02 22:49:00.448986', '2008-12-02 22:49:07.220171', 6, 2);


--
-- Data for Name: districts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO districts VALUES (1, 'Dargaville', 1, '2008-12-02 22:48:57.566455', '2008-12-02 22:48:57.566455');
INSERT INTO districts VALUES (2, 'Kaikohe', 1, '2008-12-02 22:48:57.578704', '2008-12-02 22:48:57.578704');
INSERT INTO districts VALUES (3, 'Kaitaia', 1, '2008-12-02 22:48:57.582877', '2008-12-02 22:48:57.582877');
INSERT INTO districts VALUES (4, 'Kawakawa', 1, '2008-12-02 22:48:57.587341', '2008-12-02 22:48:57.587341');
INSERT INTO districts VALUES (5, 'Kerikeri', 1, '2008-12-02 22:48:57.591599', '2008-12-02 22:48:57.591599');
INSERT INTO districts VALUES (6, 'Maungaturoto', 1, '2008-12-02 22:48:57.598618', '2008-12-02 22:48:57.598618');
INSERT INTO districts VALUES (7, 'Paihia', 1, '2008-12-02 22:48:57.607647', '2008-12-02 22:48:57.607647');
INSERT INTO districts VALUES (8, 'Whangarei', 1, '2008-12-02 22:48:57.611701', '2008-12-02 22:48:57.611701');
INSERT INTO districts VALUES (9, 'Auckland City', 2, '2008-12-02 22:48:57.618922', '2008-12-02 22:48:57.618922');
INSERT INTO districts VALUES (10, 'Franklin', 2, '2008-12-02 22:48:57.622858', '2008-12-02 22:48:57.622858');
INSERT INTO districts VALUES (11, 'Great Barrier Island', 2, '2008-12-02 22:48:57.628023', '2008-12-02 22:48:57.628023');
INSERT INTO districts VALUES (12, 'Helensville', 2, '2008-12-02 22:48:57.633297', '2008-12-02 22:48:57.633297');
INSERT INTO districts VALUES (13, 'Hibiscus Coast', 2, '2008-12-02 22:48:57.638009', '2008-12-02 22:48:57.638009');
INSERT INTO districts VALUES (14, 'Manukau City', 2, '2008-12-02 22:48:57.641634', '2008-12-02 22:48:57.641634');
INSERT INTO districts VALUES (15, 'North Shore', 2, '2008-12-02 22:48:57.645256', '2008-12-02 22:48:57.645256');
INSERT INTO districts VALUES (16, 'Papakura City', 2, '2008-12-02 22:48:57.648866', '2008-12-02 22:48:57.648866');
INSERT INTO districts VALUES (17, 'Waiheke Island', 2, '2008-12-02 22:48:57.65281', '2008-12-02 22:48:57.65281');
INSERT INTO districts VALUES (18, 'Waitakere City', 2, '2008-12-02 22:48:57.657546', '2008-12-02 22:48:57.657546');
INSERT INTO districts VALUES (19, 'Warkworth', 2, '2008-12-02 22:48:57.661145', '2008-12-02 22:48:57.661145');
INSERT INTO districts VALUES (20, 'Wellsford', 2, '2008-12-02 22:48:57.664843', '2008-12-02 22:48:57.664843');
INSERT INTO districts VALUES (21, 'Cambridge', 3, '2008-12-02 22:48:57.670593', '2008-12-02 22:48:57.670593');
INSERT INTO districts VALUES (22, 'Coromandel', 3, '2008-12-02 22:48:57.675752', '2008-12-02 22:48:57.675752');
INSERT INTO districts VALUES (23, 'Hamilton', 3, '2008-12-02 22:48:57.680586', '2008-12-02 22:48:57.680586');
INSERT INTO districts VALUES (24, 'Huntly', 3, '2008-12-02 22:48:57.68518', '2008-12-02 22:48:57.68518');
INSERT INTO districts VALUES (25, 'Matamata', 3, '2008-12-02 22:48:57.689439', '2008-12-02 22:48:57.689439');
INSERT INTO districts VALUES (26, 'Morrinsville', 3, '2008-12-02 22:48:57.693638', '2008-12-02 22:48:57.693638');
INSERT INTO districts VALUES (27, 'Otorohanga', 3, '2008-12-02 22:48:57.698693', '2008-12-02 22:48:57.698693');
INSERT INTO districts VALUES (28, 'Paeroa', 3, '2008-12-02 22:48:57.703321', '2008-12-02 22:48:57.703321');
INSERT INTO districts VALUES (29, 'Raglan', 3, '2008-12-02 22:48:57.707632', '2008-12-02 22:48:57.707632');
INSERT INTO districts VALUES (30, 'Taumarunui', 3, '2008-12-02 22:48:57.712057', '2008-12-02 22:48:57.712057');
INSERT INTO districts VALUES (31, 'Te Awamutu', 3, '2008-12-02 22:48:57.717697', '2008-12-02 22:48:57.717697');
INSERT INTO districts VALUES (32, 'Te Kuiti', 3, '2008-12-02 22:48:57.722053', '2008-12-02 22:48:57.722053');
INSERT INTO districts VALUES (33, 'Thames', 3, '2008-12-02 22:48:57.726379', '2008-12-02 22:48:57.726379');
INSERT INTO districts VALUES (34, 'Tokoroa/Putaruru', 3, '2008-12-02 22:48:57.730889', '2008-12-02 22:48:57.730889');
INSERT INTO districts VALUES (35, 'Waihi', 3, '2008-12-02 22:48:57.735634', '2008-12-02 22:48:57.735634');
INSERT INTO districts VALUES (36, 'Waihi Beach', 3, '2008-12-02 22:48:57.741083', '2008-12-02 22:48:57.741083');
INSERT INTO districts VALUES (37, 'Whangamata', 3, '2008-12-02 22:48:57.745441', '2008-12-02 22:48:57.745441');
INSERT INTO districts VALUES (38, 'Katikati', 4, '2008-12-02 22:48:57.752657', '2008-12-02 22:48:57.752657');
INSERT INTO districts VALUES (39, 'Mt. Maunganui', 4, '2008-12-02 22:48:57.757929', '2008-12-02 22:48:57.757929');
INSERT INTO districts VALUES (40, 'Opotiki', 4, '2008-12-02 22:48:57.762368', '2008-12-02 22:48:57.762368');
INSERT INTO districts VALUES (41, 'Rotorua', 4, '2008-12-02 22:48:57.766878', '2008-12-02 22:48:57.766878');
INSERT INTO districts VALUES (42, 'Taupo', 4, '2008-12-02 22:48:57.771435', '2008-12-02 22:48:57.771435');
INSERT INTO districts VALUES (43, 'Tauranga', 4, '2008-12-02 22:48:57.781048', '2008-12-02 22:48:57.781048');
INSERT INTO districts VALUES (44, 'Te Puke', 4, '2008-12-02 22:48:57.785632', '2008-12-02 22:48:57.785632');
INSERT INTO districts VALUES (45, 'Turangi', 4, '2008-12-02 22:48:57.790131', '2008-12-02 22:48:57.790131');
INSERT INTO districts VALUES (46, 'Whakatane', 4, '2008-12-02 22:48:57.794595', '2008-12-02 22:48:57.794595');
INSERT INTO districts VALUES (47, 'Gisborne', 5, '2008-12-02 22:48:57.803307', '2008-12-02 22:48:57.803307');
INSERT INTO districts VALUES (48, 'Ruatoria', 5, '2008-12-02 22:48:57.80769', '2008-12-02 22:48:57.80769');
INSERT INTO districts VALUES (49, 'Dannevirke', 6, '2008-12-02 22:48:57.81466', '2008-12-02 22:48:57.81466');
INSERT INTO districts VALUES (50, 'Hastings', 6, '2008-12-02 22:48:57.819845', '2008-12-02 22:48:57.819845');
INSERT INTO districts VALUES (51, 'Napier', 6, '2008-12-02 22:48:57.824318', '2008-12-02 22:48:57.824318');
INSERT INTO districts VALUES (52, 'Waipukurau', 6, '2008-12-02 22:48:57.828954', '2008-12-02 22:48:57.828954');
INSERT INTO districts VALUES (53, 'Wairoa', 6, '2008-12-02 22:48:57.833531', '2008-12-02 22:48:57.833531');
INSERT INTO districts VALUES (54, 'Hawera', 7, '2008-12-02 22:48:57.937112', '2008-12-02 22:48:57.937112');
INSERT INTO districts VALUES (55, 'Mokau', 7, '2008-12-02 22:48:57.942317', '2008-12-02 22:48:57.942317');
INSERT INTO districts VALUES (56, 'New Plymouth', 7, '2008-12-02 22:48:57.9466', '2008-12-02 22:48:57.9466');
INSERT INTO districts VALUES (57, 'Opunake', 7, '2008-12-02 22:48:57.951125', '2008-12-02 22:48:57.951125');
INSERT INTO districts VALUES (58, 'Stratford', 7, '2008-12-02 22:48:57.955383', '2008-12-02 22:48:57.955383');
INSERT INTO districts VALUES (59, 'Ohakune', 8, '2008-12-02 22:48:57.963167', '2008-12-02 22:48:57.963167');
INSERT INTO districts VALUES (60, 'Taihape', 8, '2008-12-02 22:48:57.967414', '2008-12-02 22:48:57.967414');
INSERT INTO districts VALUES (61, 'Waiouru', 8, '2008-12-02 22:48:57.971904', '2008-12-02 22:48:57.971904');
INSERT INTO districts VALUES (62, 'Wanganui', 8, '2008-12-02 22:48:57.976507', '2008-12-02 22:48:57.976507');
INSERT INTO districts VALUES (63, 'Bulls', 9, '2008-12-02 22:48:57.98407', '2008-12-02 22:48:57.98407');
INSERT INTO districts VALUES (64, 'Feilding', 9, '2008-12-02 22:48:57.988638', '2008-12-02 22:48:57.988638');
INSERT INTO districts VALUES (65, 'Levin', 9, '2008-12-02 22:48:57.997766', '2008-12-02 22:48:57.997766');
INSERT INTO districts VALUES (66, 'Manawatu', 9, '2008-12-02 22:48:58.005551', '2008-12-02 22:48:58.005551');
INSERT INTO districts VALUES (67, 'Marton', 9, '2008-12-02 22:48:58.010032', '2008-12-02 22:48:58.010032');
INSERT INTO districts VALUES (68, 'Palmerston North', 9, '2008-12-02 22:48:58.016433', '2008-12-02 22:48:58.016433');
INSERT INTO districts VALUES (69, 'Carterton', 10, '2008-12-02 22:48:58.025858', '2008-12-02 22:48:58.025858');
INSERT INTO districts VALUES (70, 'Featherston', 10, '2008-12-02 22:48:58.030978', '2008-12-02 22:48:58.030978');
INSERT INTO districts VALUES (71, 'Greytown', 10, '2008-12-02 22:48:58.035339', '2008-12-02 22:48:58.035339');
INSERT INTO districts VALUES (72, 'Martinborough', 10, '2008-12-02 22:48:58.041816', '2008-12-02 22:48:58.041816');
INSERT INTO districts VALUES (73, 'Masterton', 10, '2008-12-02 22:48:58.046299', '2008-12-02 22:48:58.046299');
INSERT INTO districts VALUES (74, 'Pahiatua', 10, '2008-12-02 22:48:58.050597', '2008-12-02 22:48:58.050597');
INSERT INTO districts VALUES (75, 'Woodville', 10, '2008-12-02 22:48:58.055222', '2008-12-02 22:48:58.055222');
INSERT INTO districts VALUES (76, 'Kapiti', 11, '2008-12-02 22:48:58.101325', '2008-12-02 22:48:58.101325');
INSERT INTO districts VALUES (77, 'Lower Hutt City', 11, '2008-12-02 22:48:58.106273', '2008-12-02 22:48:58.106273');
INSERT INTO districts VALUES (78, 'Porirua', 11, '2008-12-02 22:48:58.116212', '2008-12-02 22:48:58.116212');
INSERT INTO districts VALUES (79, 'Upper Hutt City', 11, '2008-12-02 22:48:58.121138', '2008-12-02 22:48:58.121138');
INSERT INTO districts VALUES (80, 'Wellington City', 11, '2008-12-02 22:48:58.126663', '2008-12-02 22:48:58.126663');
INSERT INTO districts VALUES (81, 'Golden Bay', 12, '2008-12-02 22:48:58.134361', '2008-12-02 22:48:58.134361');
INSERT INTO districts VALUES (82, 'Motueka', 12, '2008-12-02 22:48:58.138661', '2008-12-02 22:48:58.138661');
INSERT INTO districts VALUES (83, 'Murchison', 12, '2008-12-02 22:48:58.143511', '2008-12-02 22:48:58.143511');
INSERT INTO districts VALUES (84, 'Nelson', 12, '2008-12-02 22:48:58.147428', '2008-12-02 22:48:58.147428');
INSERT INTO districts VALUES (85, 'Picton', 12, '2008-12-02 22:48:58.151649', '2008-12-02 22:48:58.151649');
INSERT INTO districts VALUES (86, 'Blenheim', 13, '2008-12-02 22:48:58.157785', '2008-12-02 22:48:58.157785');
INSERT INTO districts VALUES (87, 'Marlborough Sounds', 13, '2008-12-02 22:48:58.162872', '2008-12-02 22:48:58.162872');
INSERT INTO districts VALUES (88, 'Greymouth', 14, '2008-12-02 22:48:58.170822', '2008-12-02 22:48:58.170822');
INSERT INTO districts VALUES (89, 'Hokitika', 14, '2008-12-02 22:48:58.176206', '2008-12-02 22:48:58.176206');
INSERT INTO districts VALUES (90, 'Westport', 14, '2008-12-02 22:48:58.181192', '2008-12-02 22:48:58.181192');
INSERT INTO districts VALUES (91, 'Akaroa', 15, '2008-12-02 22:48:58.189464', '2008-12-02 22:48:58.189464');
INSERT INTO districts VALUES (92, 'Amberley', 15, '2008-12-02 22:48:58.194609', '2008-12-02 22:48:58.194609');
INSERT INTO districts VALUES (93, 'Ashburton', 15, '2008-12-02 22:48:58.200307', '2008-12-02 22:48:58.200307');
INSERT INTO districts VALUES (94, 'Cheviot', 15, '2008-12-02 22:48:58.20617', '2008-12-02 22:48:58.20617');
INSERT INTO districts VALUES (95, 'Christchurch City', 15, '2008-12-02 22:48:58.21167', '2008-12-02 22:48:58.21167');
INSERT INTO districts VALUES (96, 'Darfield', 15, '2008-12-02 22:48:58.216868', '2008-12-02 22:48:58.216868');
INSERT INTO districts VALUES (97, 'Fairlie', 15, '2008-12-02 22:48:58.221687', '2008-12-02 22:48:58.221687');
INSERT INTO districts VALUES (98, 'Geraldine', 15, '2008-12-02 22:48:58.227051', '2008-12-02 22:48:58.227051');
INSERT INTO districts VALUES (99, 'Hanmer Springs', 15, '2008-12-02 22:48:58.232956', '2008-12-02 22:48:58.232956');
INSERT INTO districts VALUES (100, 'Kaiapoi', 15, '2008-12-02 22:48:58.238515', '2008-12-02 22:48:58.238515');
INSERT INTO districts VALUES (101, 'Kaikoura', 15, '2008-12-02 22:48:58.244273', '2008-12-02 22:48:58.244273');
INSERT INTO districts VALUES (102, 'Mt Cook', 15, '2008-12-02 22:48:58.25018', '2008-12-02 22:48:58.25018');
INSERT INTO districts VALUES (103, 'Rangiora', 15, '2008-12-02 22:48:58.295327', '2008-12-02 22:48:58.295327');
INSERT INTO districts VALUES (104, 'Kurow', 16, '2008-12-02 22:48:58.305085', '2008-12-02 22:48:58.305085');
INSERT INTO districts VALUES (105, 'Oamaru', 16, '2008-12-02 22:48:58.31023', '2008-12-02 22:48:58.31023');
INSERT INTO districts VALUES (106, 'Timaru', 16, '2008-12-02 22:48:58.316071', '2008-12-02 22:48:58.316071');
INSERT INTO districts VALUES (107, 'Twizel', 16, '2008-12-02 22:48:58.320724', '2008-12-02 22:48:58.320724');
INSERT INTO districts VALUES (108, 'Waimate', 16, '2008-12-02 22:48:58.326527', '2008-12-02 22:48:58.326527');
INSERT INTO districts VALUES (109, 'Alexandra', 17, '2008-12-02 22:48:58.334405', '2008-12-02 22:48:58.334405');
INSERT INTO districts VALUES (110, 'Balclutha', 17, '2008-12-02 22:48:58.339967', '2008-12-02 22:48:58.339967');
INSERT INTO districts VALUES (111, 'Cromwell', 17, '2008-12-02 22:48:58.345402', '2008-12-02 22:48:58.345402');
INSERT INTO districts VALUES (112, 'Dunedin', 17, '2008-12-02 22:48:58.350118', '2008-12-02 22:48:58.350118');
INSERT INTO districts VALUES (113, 'Lawrence', 17, '2008-12-02 22:48:58.354923', '2008-12-02 22:48:58.354923');
INSERT INTO districts VALUES (114, 'Milton', 17, '2008-12-02 22:48:58.359501', '2008-12-02 22:48:58.359501');
INSERT INTO districts VALUES (115, 'Palmerston', 17, '2008-12-02 22:48:58.365118', '2008-12-02 22:48:58.365118');
INSERT INTO districts VALUES (116, 'Queenstown', 17, '2008-12-02 22:48:58.370334', '2008-12-02 22:48:58.370334');
INSERT INTO districts VALUES (117, 'Ranfurly', 17, '2008-12-02 22:48:58.375956', '2008-12-02 22:48:58.375956');
INSERT INTO districts VALUES (118, 'Roxburgh', 17, '2008-12-02 22:48:58.38138', '2008-12-02 22:48:58.38138');
INSERT INTO districts VALUES (119, 'Wanaka', 17, '2008-12-02 22:48:58.387193', '2008-12-02 22:48:58.387193');
INSERT INTO districts VALUES (120, 'Bluff', 18, '2008-12-02 22:48:58.397006', '2008-12-02 22:48:58.397006');
INSERT INTO districts VALUES (121, 'Edendale', 18, '2008-12-02 22:48:58.402559', '2008-12-02 22:48:58.402559');
INSERT INTO districts VALUES (122, 'Gore', 18, '2008-12-02 22:48:58.407955', '2008-12-02 22:48:58.407955');
INSERT INTO districts VALUES (123, 'Invercargill', 18, '2008-12-02 22:48:58.413173', '2008-12-02 22:48:58.413173');
INSERT INTO districts VALUES (124, 'Lumsden', 18, '2008-12-02 22:48:58.418227', '2008-12-02 22:48:58.418227');
INSERT INTO districts VALUES (125, 'Otautau', 18, '2008-12-02 22:48:58.423332', '2008-12-02 22:48:58.423332');
INSERT INTO districts VALUES (126, 'Riverton', 18, '2008-12-02 22:48:58.429204', '2008-12-02 22:48:58.429204');
INSERT INTO districts VALUES (127, 'Stewart Island', 18, '2008-12-02 22:48:58.435329', '2008-12-02 22:48:58.435329');
INSERT INTO districts VALUES (128, 'Te Anau', 18, '2008-12-02 22:48:58.442817', '2008-12-02 22:48:58.442817');
INSERT INTO districts VALUES (129, 'Tokanui', 18, '2008-12-02 22:48:58.447898', '2008-12-02 22:48:58.447898');
INSERT INTO districts VALUES (130, 'Winton', 18, '2008-12-02 22:48:58.45315', '2008-12-02 22:48:58.45315');


--
-- Data for Name: passwords; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO regions VALUES (1, 'Northland', '2008-12-02 22:48:57.542314', '2008-12-02 22:48:57.542314');
INSERT INTO regions VALUES (2, 'Auckland', '2008-12-02 22:48:57.614717', '2008-12-02 22:48:57.614717');
INSERT INTO regions VALUES (3, 'Waikato', '2008-12-02 22:48:57.667676', '2008-12-02 22:48:57.667676');
INSERT INTO regions VALUES (4, 'Bay of Plenty', '2008-12-02 22:48:57.749015', '2008-12-02 22:48:57.749015');
INSERT INTO regions VALUES (5, 'Gisborne', '2008-12-02 22:48:57.799721', '2008-12-02 22:48:57.799721');
INSERT INTO regions VALUES (6, 'Hawkes Bay', '2008-12-02 22:48:57.81125', '2008-12-02 22:48:57.81125');
INSERT INTO regions VALUES (7, 'Taranaki', '2008-12-02 22:48:57.933676', '2008-12-02 22:48:57.933676');
INSERT INTO regions VALUES (8, 'Wanganui', '2008-12-02 22:48:57.958917', '2008-12-02 22:48:57.958917');
INSERT INTO regions VALUES (9, 'Manawatu', '2008-12-02 22:48:57.980626', '2008-12-02 22:48:57.980626');
INSERT INTO regions VALUES (10, 'Wairarapa', '2008-12-02 22:48:58.020746', '2008-12-02 22:48:58.020746');
INSERT INTO regions VALUES (11, 'Wellington', '2008-12-02 22:48:58.095488', '2008-12-02 22:48:58.095488');
INSERT INTO regions VALUES (12, 'Nelson Bays', '2008-12-02 22:48:58.130895', '2008-12-02 22:48:58.130895');
INSERT INTO regions VALUES (13, 'Marlborough', '2008-12-02 22:48:58.154726', '2008-12-02 22:48:58.154726');
INSERT INTO regions VALUES (14, 'West Coast', '2008-12-02 22:48:58.166673', '2008-12-02 22:48:58.166673');
INSERT INTO regions VALUES (15, 'Canterbury', '2008-12-02 22:48:58.185487', '2008-12-02 22:48:58.185487');
INSERT INTO regions VALUES (16, 'Timaru-Oamaru', '2008-12-02 22:48:58.300292', '2008-12-02 22:48:58.300292');
INSERT INTO regions VALUES (17, 'Otago', '2008-12-02 22:48:58.33025', '2008-12-02 22:48:58.33025');
INSERT INTO regions VALUES (18, 'Southland', '2008-12-02 22:48:58.39167', '2008-12-02 22:48:58.39167');


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO roles VALUES (1, 'free_listing');
INSERT INTO roles VALUES (2, 'full_member');
INSERT INTO roles VALUES (3, 'admin');


--
-- Data for Name: roles_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO roles_users VALUES (1, 2, 1);
INSERT INTO roles_users VALUES (2, 1, 2);
INSERT INTO roles_users VALUES (3, 1, 3);
INSERT INTO roles_users VALUES (4, 1, 4);
INSERT INTO roles_users VALUES (5, 1, 5);
INSERT INTO roles_users VALUES (6, 1, 6);
INSERT INTO roles_users VALUES (7, 1, 7);
INSERT INTO roles_users VALUES (8, 1, 8);
INSERT INTO roles_users VALUES (9, 1, 9);
INSERT INTO roles_users VALUES (10, 1, 10);
INSERT INTO roles_users VALUES (11, 1, 11);
INSERT INTO roles_users VALUES (12, 1, 12);
INSERT INTO roles_users VALUES (13, 1, 13);
INSERT INTO roles_users VALUES (14, 1, 14);
INSERT INTO roles_users VALUES (15, 1, 15);
INSERT INTO roles_users VALUES (16, 1, 16);
INSERT INTO roles_users VALUES (17, 1, 17);
INSERT INTO roles_users VALUES (18, 1, 18);
INSERT INTO roles_users VALUES (19, 1, 19);
INSERT INTO roles_users VALUES (20, 1, 20);
INSERT INTO roles_users VALUES (21, 1, 21);
INSERT INTO roles_users VALUES (22, 1, 22);
INSERT INTO roles_users VALUES (23, 1, 23);
INSERT INTO roles_users VALUES (24, 2, 24);
INSERT INTO roles_users VALUES (25, 1, 25);
INSERT INTO roles_users VALUES (26, 1, 26);
INSERT INTO roles_users VALUES (27, 1, 27);
INSERT INTO roles_users VALUES (28, 1, 28);
INSERT INTO roles_users VALUES (29, 1, 29);
INSERT INTO roles_users VALUES (30, 1, 30);
INSERT INTO roles_users VALUES (31, 1, 31);
INSERT INTO roles_users VALUES (32, 1, 32);
INSERT INTO roles_users VALUES (33, 1, 33);
INSERT INTO roles_users VALUES (34, 1, 34);
INSERT INTO roles_users VALUES (35, 1, 35);
INSERT INTO roles_users VALUES (36, 1, 36);
INSERT INTO roles_users VALUES (37, 1, 37);
INSERT INTO roles_users VALUES (38, 1, 38);
INSERT INTO roles_users VALUES (39, 2, 39);
INSERT INTO roles_users VALUES (40, 1, 40);
INSERT INTO roles_users VALUES (41, 2, 41);
INSERT INTO roles_users VALUES (42, 1, 42);
INSERT INTO roles_users VALUES (43, 1, 43);
INSERT INTO roles_users VALUES (44, 1, 44);
INSERT INTO roles_users VALUES (45, 1, 45);
INSERT INTO roles_users VALUES (46, 1, 46);
INSERT INTO roles_users VALUES (47, 1, 47);
INSERT INTO roles_users VALUES (48, 2, 48);
INSERT INTO roles_users VALUES (49, 1, 49);
INSERT INTO roles_users VALUES (50, 1, 50);
INSERT INTO roles_users VALUES (51, 1, 51);
INSERT INTO roles_users VALUES (52, 1, 52);
INSERT INTO roles_users VALUES (53, 2, 53);
INSERT INTO roles_users VALUES (54, 1, 54);
INSERT INTO roles_users VALUES (55, 1, 55);
INSERT INTO roles_users VALUES (56, 1, 56);
INSERT INTO roles_users VALUES (57, 1, 57);
INSERT INTO roles_users VALUES (58, 1, 58);
INSERT INTO roles_users VALUES (59, 1, 59);
INSERT INTO roles_users VALUES (60, 1, 60);
INSERT INTO roles_users VALUES (61, 1, 61);
INSERT INTO roles_users VALUES (62, 1, 62);
INSERT INTO roles_users VALUES (63, 1, 63);
INSERT INTO roles_users VALUES (64, 1, 64);
INSERT INTO roles_users VALUES (65, 1, 65);
INSERT INTO roles_users VALUES (66, 1, 66);
INSERT INTO roles_users VALUES (67, 1, 67);
INSERT INTO roles_users VALUES (68, 1, 68);
INSERT INTO roles_users VALUES (69, 2, 69);
INSERT INTO roles_users VALUES (70, 2, 70);
INSERT INTO roles_users VALUES (71, 1, 71);
INSERT INTO roles_users VALUES (72, 1, 72);
INSERT INTO roles_users VALUES (73, 1, 73);
INSERT INTO roles_users VALUES (74, 1, 74);
INSERT INTO roles_users VALUES (75, 1, 75);
INSERT INTO roles_users VALUES (76, 1, 76);
INSERT INTO roles_users VALUES (77, 1, 77);
INSERT INTO roles_users VALUES (78, 1, 78);
INSERT INTO roles_users VALUES (79, 1, 79);
INSERT INTO roles_users VALUES (80, 1, 80);
INSERT INTO roles_users VALUES (81, 1, 81);
INSERT INTO roles_users VALUES (82, 1, 82);
INSERT INTO roles_users VALUES (83, 1, 83);
INSERT INTO roles_users VALUES (84, 1, 84);
INSERT INTO roles_users VALUES (85, 1, 85);
INSERT INTO roles_users VALUES (86, 1, 86);
INSERT INTO roles_users VALUES (87, 1, 87);
INSERT INTO roles_users VALUES (88, 1, 88);
INSERT INTO roles_users VALUES (89, 2, 89);
INSERT INTO roles_users VALUES (90, 1, 90);
INSERT INTO roles_users VALUES (91, 2, 91);
INSERT INTO roles_users VALUES (92, 1, 92);
INSERT INTO roles_users VALUES (93, 1, 93);
INSERT INTO roles_users VALUES (94, 1, 94);
INSERT INTO roles_users VALUES (95, 1, 95);
INSERT INTO roles_users VALUES (96, 1, 96);
INSERT INTO roles_users VALUES (97, 2, 97);
INSERT INTO roles_users VALUES (98, 1, 98);
INSERT INTO roles_users VALUES (99, 1, 99);
INSERT INTO roles_users VALUES (100, 1, 100);
INSERT INTO roles_users VALUES (101, 2, 101);
INSERT INTO roles_users VALUES (102, 1, 102);
INSERT INTO roles_users VALUES (103, 1, 103);
INSERT INTO roles_users VALUES (104, 1, 104);
INSERT INTO roles_users VALUES (105, 1, 105);
INSERT INTO roles_users VALUES (106, 1, 106);
INSERT INTO roles_users VALUES (107, 1, 107);
INSERT INTO roles_users VALUES (108, 1, 108);
INSERT INTO roles_users VALUES (109, 1, 109);
INSERT INTO roles_users VALUES (110, 1, 110);
INSERT INTO roles_users VALUES (111, 1, 111);
INSERT INTO roles_users VALUES (112, 1, 112);
INSERT INTO roles_users VALUES (113, 1, 113);
INSERT INTO roles_users VALUES (114, 1, 114);
INSERT INTO roles_users VALUES (115, 1, 115);
INSERT INTO roles_users VALUES (116, 1, 116);
INSERT INTO roles_users VALUES (117, 1, 117);
INSERT INTO roles_users VALUES (118, 1, 118);
INSERT INTO roles_users VALUES (119, 1, 119);
INSERT INTO roles_users VALUES (120, 1, 120);
INSERT INTO roles_users VALUES (121, 1, 121);
INSERT INTO roles_users VALUES (122, 1, 122);
INSERT INTO roles_users VALUES (123, 1, 123);
INSERT INTO roles_users VALUES (124, 1, 124);
INSERT INTO roles_users VALUES (125, 1, 125);
INSERT INTO roles_users VALUES (126, 1, 126);
INSERT INTO roles_users VALUES (127, 1, 127);
INSERT INTO roles_users VALUES (128, 1, 128);
INSERT INTO roles_users VALUES (129, 1, 129);
INSERT INTO roles_users VALUES (130, 1, 130);
INSERT INTO roles_users VALUES (131, 1, 131);
INSERT INTO roles_users VALUES (132, 1, 132);
INSERT INTO roles_users VALUES (133, 1, 133);
INSERT INTO roles_users VALUES (134, 1, 134);
INSERT INTO roles_users VALUES (135, 1, 135);
INSERT INTO roles_users VALUES (136, 1, 136);
INSERT INTO roles_users VALUES (137, 1, 137);
INSERT INTO roles_users VALUES (138, 1, 138);
INSERT INTO roles_users VALUES (139, 2, 139);
INSERT INTO roles_users VALUES (140, 1, 140);
INSERT INTO roles_users VALUES (141, 1, 141);
INSERT INTO roles_users VALUES (142, 1, 142);
INSERT INTO roles_users VALUES (143, 1, 143);
INSERT INTO roles_users VALUES (144, 1, 144);
INSERT INTO roles_users VALUES (145, 1, 145);
INSERT INTO roles_users VALUES (146, 1, 146);
INSERT INTO roles_users VALUES (147, 1, 147);
INSERT INTO roles_users VALUES (148, 1, 148);
INSERT INTO roles_users VALUES (149, 2, 149);
INSERT INTO roles_users VALUES (150, 1, 150);
INSERT INTO roles_users VALUES (151, 1, 151);
INSERT INTO roles_users VALUES (152, 1, 152);
INSERT INTO roles_users VALUES (153, 1, 153);
INSERT INTO roles_users VALUES (154, 1, 154);
INSERT INTO roles_users VALUES (155, 1, 155);
INSERT INTO roles_users VALUES (156, 1, 156);
INSERT INTO roles_users VALUES (157, 1, 157);
INSERT INTO roles_users VALUES (158, 1, 158);
INSERT INTO roles_users VALUES (159, 1, 159);
INSERT INTO roles_users VALUES (160, 1, 160);
INSERT INTO roles_users VALUES (161, 1, 161);
INSERT INTO roles_users VALUES (162, 1, 162);
INSERT INTO roles_users VALUES (163, 1, 163);
INSERT INTO roles_users VALUES (164, 1, 164);
INSERT INTO roles_users VALUES (165, 1, 165);
INSERT INTO roles_users VALUES (166, 1, 166);
INSERT INTO roles_users VALUES (167, 1, 167);
INSERT INTO roles_users VALUES (168, 1, 168);
INSERT INTO roles_users VALUES (169, 1, 169);
INSERT INTO roles_users VALUES (170, 1, 170);
INSERT INTO roles_users VALUES (171, 1, 171);
INSERT INTO roles_users VALUES (172, 1, 172);
INSERT INTO roles_users VALUES (173, 1, 173);
INSERT INTO roles_users VALUES (174, 1, 174);
INSERT INTO roles_users VALUES (175, 1, 175);
INSERT INTO roles_users VALUES (176, 1, 176);
INSERT INTO roles_users VALUES (177, 1, 177);
INSERT INTO roles_users VALUES (178, 1, 178);
INSERT INTO roles_users VALUES (179, 1, 179);
INSERT INTO roles_users VALUES (180, 2, 180);
INSERT INTO roles_users VALUES (181, 2, 181);
INSERT INTO roles_users VALUES (182, 1, 182);
INSERT INTO roles_users VALUES (183, 1, 183);
INSERT INTO roles_users VALUES (184, 1, 184);
INSERT INTO roles_users VALUES (185, 1, 185);
INSERT INTO roles_users VALUES (186, 1, 186);
INSERT INTO roles_users VALUES (187, 1, 187);
INSERT INTO roles_users VALUES (188, 2, 188);
INSERT INTO roles_users VALUES (189, 1, 189);
INSERT INTO roles_users VALUES (190, 1, 190);
INSERT INTO roles_users VALUES (191, 1, 191);
INSERT INTO roles_users VALUES (192, 1, 192);
INSERT INTO roles_users VALUES (193, 1, 193);
INSERT INTO roles_users VALUES (194, 1, 194);
INSERT INTO roles_users VALUES (195, 1, 195);
INSERT INTO roles_users VALUES (196, 1, 196);
INSERT INTO roles_users VALUES (197, 1, 197);
INSERT INTO roles_users VALUES (198, 1, 198);
INSERT INTO roles_users VALUES (199, 1, 199);
INSERT INTO roles_users VALUES (200, 1, 200);
INSERT INTO roles_users VALUES (201, 1, 201);
INSERT INTO roles_users VALUES (202, 1, 202);
INSERT INTO roles_users VALUES (203, 1, 203);
INSERT INTO roles_users VALUES (204, 1, 204);
INSERT INTO roles_users VALUES (205, 1, 205);
INSERT INTO roles_users VALUES (206, 1, 206);
INSERT INTO roles_users VALUES (207, 1, 207);
INSERT INTO roles_users VALUES (208, 2, 208);
INSERT INTO roles_users VALUES (209, 1, 209);
INSERT INTO roles_users VALUES (210, 1, 210);
INSERT INTO roles_users VALUES (211, 1, 211);
INSERT INTO roles_users VALUES (212, 2, 212);
INSERT INTO roles_users VALUES (213, 1, 213);
INSERT INTO roles_users VALUES (214, 1, 214);
INSERT INTO roles_users VALUES (215, 1, 215);
INSERT INTO roles_users VALUES (216, 1, 216);
INSERT INTO roles_users VALUES (217, 1, 217);
INSERT INTO roles_users VALUES (218, 1, 218);
INSERT INTO roles_users VALUES (219, 1, 219);
INSERT INTO roles_users VALUES (220, 1, 220);
INSERT INTO roles_users VALUES (221, 1, 221);
INSERT INTO roles_users VALUES (222, 1, 222);
INSERT INTO roles_users VALUES (223, 1, 223);
INSERT INTO roles_users VALUES (224, 1, 224);
INSERT INTO roles_users VALUES (225, 2, 225);
INSERT INTO roles_users VALUES (226, 3, 226);
INSERT INTO roles_users VALUES (227, 3, 227);
INSERT INTO roles_users VALUES (228, 3, 228);
INSERT INTO roles_users VALUES (229, 3, 229);
INSERT INTO roles_users VALUES (230, 3, 167);


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
INSERT INTO schema_migrations VALUES ('20081202191136');
INSERT INTO schema_migrations VALUES ('20081202213611');


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: subcategories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO subcategories VALUES (1, 1, 'Hypnotherapy', '2008-12-02 22:48:58.500162', '2008-12-02 22:49:07.232132', 7);
INSERT INTO subcategories VALUES (2, 2, 'Life coaching', '2008-12-02 22:48:58.624345', '2008-12-02 22:49:07.241993', 18);
INSERT INTO subcategories VALUES (3, 1, 'Therapeutic massage', '2008-12-02 22:48:58.651225', '2008-12-02 22:49:07.24879', 2);
INSERT INTO subcategories VALUES (4, 3, 'Day spa', '2008-12-02 22:48:58.685363', '2008-12-02 22:49:07.256239', 1);
INSERT INTO subcategories VALUES (5, 1, 'Reiki', '2008-12-02 22:48:58.801725', '2008-12-02 22:49:07.266355', 9);
INSERT INTO subcategories VALUES (6, 1, 'Energy therapies', '2008-12-02 22:48:58.829142', '2008-12-02 22:49:07.273088', 2);
INSERT INTO subcategories VALUES (7, 4, 'Pilates', '2008-12-02 22:48:58.864389', '2008-12-02 22:49:07.282517', 8);
INSERT INTO subcategories VALUES (8, 1, 'Acupuncture', '2008-12-02 22:48:58.892976', '2008-12-02 22:49:07.291168', 11);
INSERT INTO subcategories VALUES (9, 1, 'Nlp', '2008-12-02 22:48:58.924238', '2008-12-02 22:49:07.302193', 11);
INSERT INTO subcategories VALUES (10, 1, 'Migraine relief', '2008-12-02 22:48:58.979854', '2008-12-02 22:49:07.309082', 1);
INSERT INTO subcategories VALUES (11, 4, 'Yoga', '2008-12-02 22:48:59.008483', '2008-12-02 22:49:07.316781', 8);
INSERT INTO subcategories VALUES (12, 1, 'Psychotherapy', '2008-12-02 22:48:59.042753', '2008-12-02 22:49:07.325571', 2);
INSERT INTO subcategories VALUES (13, 1, 'Homeobotanicals', '2008-12-02 22:48:59.071109', '2008-12-02 22:49:07.332618', 1);
INSERT INTO subcategories VALUES (14, 2, 'Business coaching', '2008-12-02 22:48:59.131036', '2008-12-02 22:49:07.339868', 1);
INSERT INTO subcategories VALUES (15, 1, 'Reflexology', '2008-12-02 22:48:59.15812', '2008-12-02 22:49:07.348343', 3);
INSERT INTO subcategories VALUES (16, 1, 'Neuromuscular therapy', '2008-12-02 22:48:59.214982', '2008-12-02 22:49:07.356138', 1);
INSERT INTO subcategories VALUES (17, 5, 'Therapeutic massage', '2008-12-02 22:48:59.329626', '2008-12-02 22:49:07.366019', 24);
INSERT INTO subcategories VALUES (18, 1, 'Nutrition', '2008-12-02 22:48:59.442908', '2008-12-02 22:49:07.372619', 1);
INSERT INTO subcategories VALUES (19, 1, 'Clairvoyant', '2008-12-02 22:48:59.47233', '2008-12-02 22:49:07.380201', 2);
INSERT INTO subcategories VALUES (20, 5, 'Neuromuscular therapy', '2008-12-02 22:48:59.508385', '2008-12-02 22:49:07.388174', 3);
INSERT INTO subcategories VALUES (21, 1, 'Naturopathy', '2008-12-02 22:48:59.537085', '2008-12-02 22:49:07.398946', 10);
INSERT INTO subcategories VALUES (22, 5, 'Relaxation massage', '2008-12-02 22:48:59.570263', '2008-12-02 22:49:07.408278', 10);
INSERT INTO subcategories VALUES (23, 1, 'Craniosacral therapy', '2008-12-02 22:48:59.737177', '2008-12-02 22:49:07.41715', 3);
INSERT INTO subcategories VALUES (24, 1, 'Emotional freedom technique', '2008-12-02 22:48:59.880163', '2008-12-02 22:49:07.424302', 5);
INSERT INTO subcategories VALUES (25, 1, 'Homeopathy', '2008-12-02 22:48:59.914717', '2008-12-02 22:49:07.433179', 14);
INSERT INTO subcategories VALUES (26, 1, 'Osteopathy', '2008-12-02 22:48:59.94293', '2008-12-02 22:49:07.441926', 3);
INSERT INTO subcategories VALUES (27, 4, 'Meditation', '2008-12-02 22:48:59.97377', '2008-12-02 22:49:07.452637', 4);
INSERT INTO subcategories VALUES (28, 1, 'Aromatherapy', '2008-12-02 22:49:00.002569', '2008-12-02 22:49:07.461145', 3);
INSERT INTO subcategories VALUES (29, 1, 'Herbal medicine', '2008-12-02 22:49:00.033818', '2008-12-02 22:49:07.467881', 1);
INSERT INTO subcategories VALUES (30, 1, 'Kinesiology', '2008-12-02 22:49:00.065259', '2008-12-02 22:49:07.475939', 4);
INSERT INTO subcategories VALUES (31, 1, 'Relaxation massage', '2008-12-02 22:49:00.256696', '2008-12-02 22:49:07.482584', 1);
INSERT INTO subcategories VALUES (32, 6, 'Beauty salons', '2008-12-02 22:49:00.45233', '2008-12-02 22:49:07.490668', 2);
INSERT INTO subcategories VALUES (33, 1, 'Counselling', '2008-12-02 22:49:00.656772', '2008-12-02 22:49:07.500606', 5);
INSERT INTO subcategories VALUES (34, 1, 'Chiropractor', '2008-12-02 22:49:00.771795', '2008-12-02 22:49:07.510705', 6);
INSERT INTO subcategories VALUES (35, 1, 'Fractology', '2008-12-02 22:49:01.114742', '2008-12-02 22:49:07.518317', 1);
INSERT INTO subcategories VALUES (36, 5, 'Lomi lomi massage', '2008-12-02 22:49:01.542523', '2008-12-02 22:49:07.525307', 1);
INSERT INTO subcategories VALUES (37, 1, 'Health & safety', '2008-12-02 22:49:01.749844', '2008-12-02 22:49:07.531967', 1);
INSERT INTO subcategories VALUES (38, 2, 'Health coaching', '2008-12-02 22:49:01.839763', '2008-12-02 22:49:07.539631', 1);
INSERT INTO subcategories VALUES (39, 1, 'Bowen therapy', '2008-12-02 22:49:01.895067', '2008-12-02 22:49:07.548116', 3);
INSERT INTO subcategories VALUES (40, 5, 'Sports massage', '2008-12-02 22:49:02.066631', '2008-12-02 22:49:07.555968', 1);
INSERT INTO subcategories VALUES (41, 5, 'Shiatsu massage', '2008-12-02 22:49:02.097634', '2008-12-02 22:49:07.56323', 1);
INSERT INTO subcategories VALUES (42, 3, 'Health store', '2008-12-02 22:49:02.166069', '2008-12-02 22:49:07.570237', 3);
INSERT INTO subcategories VALUES (43, 2, 'Career coaching', '2008-12-02 22:49:02.357091', '2008-12-02 22:49:07.581784', 3);
INSERT INTO subcategories VALUES (44, 1, 'Sound healing', '2008-12-02 22:49:02.692005', '2008-12-02 22:49:07.588704', 1);
INSERT INTO subcategories VALUES (45, 1, 'Personal training', '2008-12-02 22:49:02.725633', '2008-12-02 22:49:07.598281', 2);
INSERT INTO subcategories VALUES (46, 1, 'Spiritual healing', '2008-12-02 22:49:02.840053', '2008-12-02 22:49:07.606389', 2);
INSERT INTO subcategories VALUES (47, 4, 'Public speaking', '2008-12-02 22:49:03.087307', '2008-12-02 22:49:07.613253', 1);
INSERT INTO subcategories VALUES (48, 1, 'Ear candling', '2008-12-02 22:49:03.284465', '2008-12-02 22:49:07.621561', 1);
INSERT INTO subcategories VALUES (49, 2, 'Executive coaching', '2008-12-02 22:49:03.396931', '2008-12-02 22:49:07.629361', 1);
INSERT INTO subcategories VALUES (50, 5, 'Detox massage', '2008-12-02 22:49:03.478404', '2008-12-02 22:49:07.638291', 1);
INSERT INTO subcategories VALUES (51, 1, 'Allergy testing', '2008-12-02 22:49:04.197947', '2008-12-02 22:49:07.645404', 1);
INSERT INTO subcategories VALUES (52, 1, 'Bowen', '2008-12-02 22:49:04.256202', '2008-12-02 22:49:07.652206', 1);
INSERT INTO subcategories VALUES (53, 4, 'Reiki', '2008-12-02 22:49:04.284556', '2008-12-02 22:49:07.660067', 1);
INSERT INTO subcategories VALUES (54, 1, 'Sacred design', '2008-12-02 22:49:04.450526', '2008-12-02 22:49:07.667158', 1);
INSERT INTO subcategories VALUES (55, 1, 'Ayurvedic medicine', '2008-12-02 22:49:04.4797', '2008-12-02 22:49:07.675136', 1);
INSERT INTO subcategories VALUES (56, 1, 'Astrology', '2008-12-02 22:49:04.509097', '2008-12-02 22:49:07.682589', 1);
INSERT INTO subcategories VALUES (57, 1, 'Alexander technique', '2008-12-02 22:49:04.733631', '2008-12-02 22:49:07.689693', 1);
INSERT INTO subcategories VALUES (58, 1, 'Feldenkrais method', '2008-12-02 22:49:04.7672', '2008-12-02 22:49:07.697817', 1);
INSERT INTO subcategories VALUES (59, 1, 'Watsu', '2008-12-02 22:49:04.824069', '2008-12-02 22:49:07.704696', 1);
INSERT INTO subcategories VALUES (60, 1, 'Lymphatic drainage', '2008-12-02 22:49:06.472987', '2008-12-02 22:49:07.711535', 1);
INSERT INTO subcategories VALUES (61, 2, 'Relationship coaching', '2008-12-02 22:49:06.675938', '2008-12-02 22:49:07.718218', 1);
INSERT INTO subcategories VALUES (62, 4, 'Chi kung', '2008-12-02 22:49:06.705155', '2008-12-02 22:49:07.725742', 1);
INSERT INTO subcategories VALUES (63, 5, 'Shiatsu', '2008-12-02 22:49:06.733762', '2008-12-02 22:49:07.732557', 1);
INSERT INTO subcategories VALUES (64, 1, 'Sports massage', '2008-12-02 22:49:06.791098', '2008-12-02 22:49:07.740562', 1);


--
-- Data for Name: subcategories_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO subcategories_users VALUES (1, '2008-12-02 22:48:58.608643', '2008-12-02 22:48:58.608643', 1, 1);
INSERT INTO subcategories_users VALUES (2, '2008-12-02 22:48:58.644416', '2008-12-02 22:48:58.644416', 2, 2);
INSERT INTO subcategories_users VALUES (3, '2008-12-02 22:48:58.675209', '2008-12-02 22:48:58.675209', 3, 3);
INSERT INTO subcategories_users VALUES (4, '2008-12-02 22:48:58.794973', '2008-12-02 22:48:58.794973', 4, 4);
INSERT INTO subcategories_users VALUES (5, '2008-12-02 22:48:58.822763', '2008-12-02 22:48:58.822763', 5, 5);
INSERT INTO subcategories_users VALUES (6, '2008-12-02 22:48:58.853369', '2008-12-02 22:48:58.853369', 6, 6);
INSERT INTO subcategories_users VALUES (7, '2008-12-02 22:48:58.886266', '2008-12-02 22:48:58.886266', 7, 7);
INSERT INTO subcategories_users VALUES (8, '2008-12-02 22:48:58.916739', '2008-12-02 22:48:58.916739', 8, 8);
INSERT INTO subcategories_users VALUES (9, '2008-12-02 22:48:58.94672', '2008-12-02 22:48:58.94672', 9, 9);
INSERT INTO subcategories_users VALUES (10, '2008-12-02 22:48:58.972388', '2008-12-02 22:48:58.972388', 2, 10);
INSERT INTO subcategories_users VALUES (11, '2008-12-02 22:48:59.002031', '2008-12-02 22:48:59.002031', 10, 11);
INSERT INTO subcategories_users VALUES (12, '2008-12-02 22:48:59.034343', '2008-12-02 22:48:59.034343', 11, 12);
INSERT INTO subcategories_users VALUES (13, '2008-12-02 22:48:59.064861', '2008-12-02 22:48:59.064861', 12, 13);
INSERT INTO subcategories_users VALUES (14, '2008-12-02 22:48:59.094272', '2008-12-02 22:48:59.094272', 13, 14);
INSERT INTO subcategories_users VALUES (15, '2008-12-02 22:48:59.124253', '2008-12-02 22:48:59.124253', 9, 15);
INSERT INTO subcategories_users VALUES (16, '2008-12-02 22:48:59.151343', '2008-12-02 22:48:59.151343', 14, 16);
INSERT INTO subcategories_users VALUES (17, '2008-12-02 22:48:59.180394', '2008-12-02 22:48:59.180394', 15, 17);
INSERT INTO subcategories_users VALUES (18, '2008-12-02 22:48:59.208417', '2008-12-02 22:48:59.208417', 8, 18);
INSERT INTO subcategories_users VALUES (19, '2008-12-02 22:48:59.320717', '2008-12-02 22:48:59.320717', 16, 19);
INSERT INTO subcategories_users VALUES (20, '2008-12-02 22:48:59.350705', '2008-12-02 22:48:59.350705', 17, 20);
INSERT INTO subcategories_users VALUES (21, '2008-12-02 22:48:59.377741', '2008-12-02 22:48:59.377741', 11, 21);
INSERT INTO subcategories_users VALUES (22, '2008-12-02 22:48:59.40918', '2008-12-02 22:48:59.40918', 2, 22);
INSERT INTO subcategories_users VALUES (23, '2008-12-02 22:48:59.435464', '2008-12-02 22:48:59.435464', 11, 23);
INSERT INTO subcategories_users VALUES (24, '2008-12-02 22:48:59.465963', '2008-12-02 22:48:59.465963', 18, 24);
INSERT INTO subcategories_users VALUES (25, '2008-12-02 22:48:59.493714', '2008-12-02 22:48:59.493714', 19, 25);
INSERT INTO subcategories_users VALUES (26, '2008-12-02 22:48:59.530108', '2008-12-02 22:48:59.530108', 20, 26);
INSERT INTO subcategories_users VALUES (27, '2008-12-02 22:48:59.563473', '2008-12-02 22:48:59.563473', 21, 27);
INSERT INTO subcategories_users VALUES (28, '2008-12-02 22:48:59.591576', '2008-12-02 22:48:59.591576', 22, 28);
INSERT INTO subcategories_users VALUES (29, '2008-12-02 22:48:59.623204', '2008-12-02 22:48:59.623204', 9, 29);
INSERT INTO subcategories_users VALUES (30, '2008-12-02 22:48:59.648769', '2008-12-02 22:48:59.648769', 2, 30);
INSERT INTO subcategories_users VALUES (31, '2008-12-02 22:48:59.675068', '2008-12-02 22:48:59.675068', 11, 31);
INSERT INTO subcategories_users VALUES (32, '2008-12-02 22:48:59.703452', '2008-12-02 22:48:59.703452', 5, 32);
INSERT INTO subcategories_users VALUES (33, '2008-12-02 22:48:59.729887', '2008-12-02 22:48:59.729887', 1, 33);
INSERT INTO subcategories_users VALUES (34, '2008-12-02 22:48:59.84808', '2008-12-02 22:48:59.84808', 23, 34);
INSERT INTO subcategories_users VALUES (35, '2008-12-02 22:48:59.87361', '2008-12-02 22:48:59.87361', 9, 35);
INSERT INTO subcategories_users VALUES (36, '2008-12-02 22:48:59.907912', '2008-12-02 22:48:59.907912', 24, 36);
INSERT INTO subcategories_users VALUES (37, '2008-12-02 22:48:59.935934', '2008-12-02 22:48:59.935934', 25, 37);
INSERT INTO subcategories_users VALUES (38, '2008-12-02 22:48:59.966986', '2008-12-02 22:48:59.966986', 26, 38);
INSERT INTO subcategories_users VALUES (39, '2008-12-02 22:48:59.995425', '2008-12-02 22:48:59.995425', 27, 39);
INSERT INTO subcategories_users VALUES (40, '2008-12-02 22:49:00.026232', '2008-12-02 22:49:00.026232', 28, 40);
INSERT INTO subcategories_users VALUES (41, '2008-12-02 22:49:00.056761', '2008-12-02 22:49:00.056761', 29, 41);
INSERT INTO subcategories_users VALUES (42, '2008-12-02 22:49:00.086312', '2008-12-02 22:49:00.086312', 30, 42);
INSERT INTO subcategories_users VALUES (43, '2008-12-02 22:49:00.120218', '2008-12-02 22:49:00.120218', 17, 43);
INSERT INTO subcategories_users VALUES (44, '2008-12-02 22:49:00.166707', '2008-12-02 22:49:00.166707', 17, 44);
INSERT INTO subcategories_users VALUES (45, '2008-12-02 22:49:00.196375', '2008-12-02 22:49:00.196375', 25, 45);
INSERT INTO subcategories_users VALUES (46, '2008-12-02 22:49:00.223945', '2008-12-02 22:49:00.223945', 7, 46);
INSERT INTO subcategories_users VALUES (47, '2008-12-02 22:49:00.249027', '2008-12-02 22:49:00.249027', 22, 47);
INSERT INTO subcategories_users VALUES (48, '2008-12-02 22:49:00.277507', '2008-12-02 22:49:00.277507', 31, 48);
INSERT INTO subcategories_users VALUES (49, '2008-12-02 22:49:00.306388', '2008-12-02 22:49:00.306388', 19, 49);
INSERT INTO subcategories_users VALUES (50, '2008-12-02 22:49:00.417917', '2008-12-02 22:49:00.417917', 22, 50);
INSERT INTO subcategories_users VALUES (51, '2008-12-02 22:49:00.443324', '2008-12-02 22:49:00.443324', 22, 51);
INSERT INTO subcategories_users VALUES (52, '2008-12-02 22:49:00.474849', '2008-12-02 22:49:00.474849', 32, 52);
INSERT INTO subcategories_users VALUES (53, '2008-12-02 22:49:00.502368', '2008-12-02 22:49:00.502368', 21, 53);
INSERT INTO subcategories_users VALUES (54, '2008-12-02 22:49:00.531612', '2008-12-02 22:49:00.531612', 17, 54);
INSERT INTO subcategories_users VALUES (55, '2008-12-02 22:49:00.562411', '2008-12-02 22:49:00.562411', 1, 55);
INSERT INTO subcategories_users VALUES (56, '2008-12-02 22:49:00.591534', '2008-12-02 22:49:00.591534', 8, 56);
INSERT INTO subcategories_users VALUES (57, '2008-12-02 22:49:00.621941', '2008-12-02 22:49:00.621941', 24, 57);
INSERT INTO subcategories_users VALUES (58, '2008-12-02 22:49:00.64976', '2008-12-02 22:49:00.64976', 22, 58);
INSERT INTO subcategories_users VALUES (59, '2008-12-02 22:49:00.677502', '2008-12-02 22:49:00.677502', 33, 59);
INSERT INTO subcategories_users VALUES (60, '2008-12-02 22:49:00.708735', '2008-12-02 22:49:00.708735', 25, 60);
INSERT INTO subcategories_users VALUES (61, '2008-12-02 22:49:00.736196', '2008-12-02 22:49:00.736196', 1, 61);
INSERT INTO subcategories_users VALUES (62, '2008-12-02 22:49:00.764793', '2008-12-02 22:49:00.764793', 1, 62);
INSERT INTO subcategories_users VALUES (63, '2008-12-02 22:49:00.792041', '2008-12-02 22:49:00.792041', 34, 63);
INSERT INTO subcategories_users VALUES (64, '2008-12-02 22:49:00.821148', '2008-12-02 22:49:00.821148', 34, 64);
INSERT INTO subcategories_users VALUES (65, '2008-12-02 22:49:00.933265', '2008-12-02 22:49:00.933265', 34, 65);
INSERT INTO subcategories_users VALUES (66, '2008-12-02 22:49:00.958904', '2008-12-02 22:49:00.958904', 25, 66);
INSERT INTO subcategories_users VALUES (67, '2008-12-02 22:49:00.987374', '2008-12-02 22:49:00.987374', 25, 67);
INSERT INTO subcategories_users VALUES (68, '2008-12-02 22:49:01.016572', '2008-12-02 22:49:01.016572', 9, 68);
INSERT INTO subcategories_users VALUES (69, '2008-12-02 22:49:01.048526', '2008-12-02 22:49:01.048526', 17, 69);
INSERT INTO subcategories_users VALUES (70, '2008-12-02 22:49:01.073918', '2008-12-02 22:49:01.073918', 22, 70);
INSERT INTO subcategories_users VALUES (71, '2008-12-02 22:49:01.107349', '2008-12-02 22:49:01.107349', 17, 71);
INSERT INTO subcategories_users VALUES (72, '2008-12-02 22:49:01.136104', '2008-12-02 22:49:01.136104', 35, 72);
INSERT INTO subcategories_users VALUES (73, '2008-12-02 22:49:01.168363', '2008-12-02 22:49:01.168363', 22, 73);
INSERT INTO subcategories_users VALUES (74, '2008-12-02 22:49:01.194621', '2008-12-02 22:49:01.194621', 17, 74);
INSERT INTO subcategories_users VALUES (75, '2008-12-02 22:49:01.224458', '2008-12-02 22:49:01.224458', 11, 75);
INSERT INTO subcategories_users VALUES (76, '2008-12-02 22:49:01.252324', '2008-12-02 22:49:01.252324', 8, 76);
INSERT INTO subcategories_users VALUES (77, '2008-12-02 22:49:01.279876', '2008-12-02 22:49:01.279876', 26, 77);
INSERT INTO subcategories_users VALUES (78, '2008-12-02 22:49:01.307019', '2008-12-02 22:49:01.307019', 30, 78);
INSERT INTO subcategories_users VALUES (79, '2008-12-02 22:49:01.335368', '2008-12-02 22:49:01.335368', 27, 79);
INSERT INTO subcategories_users VALUES (80, '2008-12-02 22:49:01.361996', '2008-12-02 22:49:01.361996', 24, 80);
INSERT INTO subcategories_users VALUES (81, '2008-12-02 22:49:01.475091', '2008-12-02 22:49:01.475091', 17, 81);
INSERT INTO subcategories_users VALUES (82, '2008-12-02 22:49:01.500982', '2008-12-02 22:49:01.500982', 25, 82);
INSERT INTO subcategories_users VALUES (83, '2008-12-02 22:49:01.534961', '2008-12-02 22:49:01.534961', 25, 83);
INSERT INTO subcategories_users VALUES (84, '2008-12-02 22:49:01.563727', '2008-12-02 22:49:01.563727', 36, 84);
INSERT INTO subcategories_users VALUES (85, '2008-12-02 22:49:01.595258', '2008-12-02 22:49:01.595258', 7, 85);
INSERT INTO subcategories_users VALUES (86, '2008-12-02 22:49:01.622733', '2008-12-02 22:49:01.622733', 8, 86);
INSERT INTO subcategories_users VALUES (87, '2008-12-02 22:49:01.65656', '2008-12-02 22:49:01.65656', 33, 87);
INSERT INTO subcategories_users VALUES (88, '2008-12-02 22:49:01.682348', '2008-12-02 22:49:01.682348', 9, 88);
INSERT INTO subcategories_users VALUES (89, '2008-12-02 22:49:01.712285', '2008-12-02 22:49:01.712285', 2, 89);
INSERT INTO subcategories_users VALUES (90, '2008-12-02 22:49:01.743209', '2008-12-02 22:49:01.743209', 11, 90);
INSERT INTO subcategories_users VALUES (91, '2008-12-02 22:49:01.774528', '2008-12-02 22:49:01.774528', 37, 91);
INSERT INTO subcategories_users VALUES (92, '2008-12-02 22:49:01.804249', '2008-12-02 22:49:01.804249', 5, 92);
INSERT INTO subcategories_users VALUES (93, '2008-12-02 22:49:01.831678', '2008-12-02 22:49:01.831678', 20, 93);
INSERT INTO subcategories_users VALUES (94, '2008-12-02 22:49:01.860525', '2008-12-02 22:49:01.860525', 38, 94);
INSERT INTO subcategories_users VALUES (95, '2008-12-02 22:49:01.88785', '2008-12-02 22:49:01.88785', 1, 95);
INSERT INTO subcategories_users VALUES (96, '2008-12-02 22:49:01.919065', '2008-12-02 22:49:01.919065', 39, 96);
INSERT INTO subcategories_users VALUES (97, '2008-12-02 22:49:02.027853', '2008-12-02 22:49:02.027853', 24, 97);
INSERT INTO subcategories_users VALUES (98, '2008-12-02 22:49:02.059404', '2008-12-02 22:49:02.059404', 22, 98);
INSERT INTO subcategories_users VALUES (99, '2008-12-02 22:49:02.088622', '2008-12-02 22:49:02.088622', 40, 99);
INSERT INTO subcategories_users VALUES (100, '2008-12-02 22:49:02.123378', '2008-12-02 22:49:02.123378', 41, 100);
INSERT INTO subcategories_users VALUES (101, '2008-12-02 22:49:02.159014', '2008-12-02 22:49:02.159014', 25, 101);
INSERT INTO subcategories_users VALUES (102, '2008-12-02 22:49:02.188909', '2008-12-02 22:49:02.188909', 42, 102);
INSERT INTO subcategories_users VALUES (103, '2008-12-02 22:49:02.216268', '2008-12-02 22:49:02.216268', 17, 103);
INSERT INTO subcategories_users VALUES (104, '2008-12-02 22:49:02.241812', '2008-12-02 22:49:02.241812', 21, 104);
INSERT INTO subcategories_users VALUES (105, '2008-12-02 22:49:02.26795', '2008-12-02 22:49:02.26795', 21, 105);
INSERT INTO subcategories_users VALUES (106, '2008-12-02 22:49:02.295905', '2008-12-02 22:49:02.295905', 11, 106);
INSERT INTO subcategories_users VALUES (107, '2008-12-02 22:49:02.322975', '2008-12-02 22:49:02.322975', 17, 107);
INSERT INTO subcategories_users VALUES (108, '2008-12-02 22:49:02.350732', '2008-12-02 22:49:02.350732', 17, 108);
INSERT INTO subcategories_users VALUES (109, '2008-12-02 22:49:02.377565', '2008-12-02 22:49:02.377565', 43, 109);
INSERT INTO subcategories_users VALUES (110, '2008-12-02 22:49:02.40639', '2008-12-02 22:49:02.40639', 42, 110);
INSERT INTO subcategories_users VALUES (111, '2008-12-02 22:49:02.433617', '2008-12-02 22:49:02.433617', 8, 111);
INSERT INTO subcategories_users VALUES (112, '2008-12-02 22:49:02.461987', '2008-12-02 22:49:02.461987', 5, 112);
INSERT INTO subcategories_users VALUES (113, '2008-12-02 22:49:02.574897', '2008-12-02 22:49:02.574897', 9, 113);
INSERT INTO subcategories_users VALUES (114, '2008-12-02 22:49:02.603195', '2008-12-02 22:49:02.603195', 33, 114);
INSERT INTO subcategories_users VALUES (115, '2008-12-02 22:49:02.631974', '2008-12-02 22:49:02.631974', 2, 115);
INSERT INTO subcategories_users VALUES (116, '2008-12-02 22:49:02.660437', '2008-12-02 22:49:02.660437', 9, 116);
INSERT INTO subcategories_users VALUES (117, '2008-12-02 22:49:02.68585', '2008-12-02 22:49:02.68585', 5, 117);
INSERT INTO subcategories_users VALUES (118, '2008-12-02 22:49:02.718063', '2008-12-02 22:49:02.718063', 44, 118);
INSERT INTO subcategories_users VALUES (119, '2008-12-02 22:49:02.747263', '2008-12-02 22:49:02.747263', 45, 119);
INSERT INTO subcategories_users VALUES (120, '2008-12-02 22:49:02.777022', '2008-12-02 22:49:02.777022', 17, 120);
INSERT INTO subcategories_users VALUES (121, '2008-12-02 22:49:02.803357', '2008-12-02 22:49:02.803357', 24, 121);
INSERT INTO subcategories_users VALUES (122, '2008-12-02 22:49:02.83204', '2008-12-02 22:49:02.83204', 11, 122);
INSERT INTO subcategories_users VALUES (123, '2008-12-02 22:49:02.861604', '2008-12-02 22:49:02.861604', 46, 123);
INSERT INTO subcategories_users VALUES (124, '2008-12-02 22:49:02.888083', '2008-12-02 22:49:02.888083', 30, 124);
INSERT INTO subcategories_users VALUES (125, '2008-12-02 22:49:02.915248', '2008-12-02 22:49:02.915248', 46, 125);
INSERT INTO subcategories_users VALUES (126, '2008-12-02 22:49:02.942157', '2008-12-02 22:49:02.942157', 42, 126);
INSERT INTO subcategories_users VALUES (127, '2008-12-02 22:49:02.968345', '2008-12-02 22:49:02.968345', 5, 127);
INSERT INTO subcategories_users VALUES (128, '2008-12-02 22:49:03.080883', '2008-12-02 22:49:03.080883', 17, 128);
INSERT INTO subcategories_users VALUES (129, '2008-12-02 22:49:03.108346', '2008-12-02 22:49:03.108346', 47, 129);
INSERT INTO subcategories_users VALUES (130, '2008-12-02 22:49:03.137148', '2008-12-02 22:49:03.137148', 6, 130);
INSERT INTO subcategories_users VALUES (131, '2008-12-02 22:49:03.169018', '2008-12-02 22:49:03.169018', 2, 131);
INSERT INTO subcategories_users VALUES (132, '2008-12-02 22:49:03.195356', '2008-12-02 22:49:03.195356', 8, 132);
INSERT INTO subcategories_users VALUES (133, '2008-12-02 22:49:03.223512', '2008-12-02 22:49:03.223512', 7, 133);
INSERT INTO subcategories_users VALUES (134, '2008-12-02 22:49:03.251392', '2008-12-02 22:49:03.251392', 3, 134);
INSERT INTO subcategories_users VALUES (135, '2008-12-02 22:49:03.277695', '2008-12-02 22:49:03.277695', 2, 135);
INSERT INTO subcategories_users VALUES (136, '2008-12-02 22:49:03.308805', '2008-12-02 22:49:03.308805', 48, 136);
INSERT INTO subcategories_users VALUES (137, '2008-12-02 22:49:03.337483', '2008-12-02 22:49:03.337483', 17, 137);
INSERT INTO subcategories_users VALUES (138, '2008-12-02 22:49:03.364549', '2008-12-02 22:49:03.364549', 34, 138);
INSERT INTO subcategories_users VALUES (139, '2008-12-02 22:49:03.390266', '2008-12-02 22:49:03.390266', 2, 139);
INSERT INTO subcategories_users VALUES (140, '2008-12-02 22:49:03.420216', '2008-12-02 22:49:03.420216', 49, 140);
INSERT INTO subcategories_users VALUES (141, '2008-12-02 22:49:03.44608', '2008-12-02 22:49:03.44608', 7, 141);
INSERT INTO subcategories_users VALUES (142, '2008-12-02 22:49:03.471015', '2008-12-02 22:49:03.471015', 33, 142);
INSERT INTO subcategories_users VALUES (143, '2008-12-02 22:49:03.500909', '2008-12-02 22:49:03.500909', 50, 143);
INSERT INTO subcategories_users VALUES (144, '2008-12-02 22:49:03.611825', '2008-12-02 22:49:03.611825', 39, 144);
INSERT INTO subcategories_users VALUES (145, '2008-12-02 22:49:03.637231', '2008-12-02 22:49:03.637231', 17, 145);
INSERT INTO subcategories_users VALUES (146, '2008-12-02 22:49:03.665739', '2008-12-02 22:49:03.665739', 25, 146);
INSERT INTO subcategories_users VALUES (147, '2008-12-02 22:49:03.69158', '2008-12-02 22:49:03.69158', 2, 147);
INSERT INTO subcategories_users VALUES (148, '2008-12-02 22:49:03.721934', '2008-12-02 22:49:03.721934', 25, 148);
INSERT INTO subcategories_users VALUES (149, '2008-12-02 22:49:03.749853', '2008-12-02 22:49:03.749853', 43, 149);
INSERT INTO subcategories_users VALUES (150, '2008-12-02 22:49:03.776473', '2008-12-02 22:49:03.776473', 7, 150);
INSERT INTO subcategories_users VALUES (151, '2008-12-02 22:49:03.80651', '2008-12-02 22:49:03.80651', 9, 151);
INSERT INTO subcategories_users VALUES (152, '2008-12-02 22:49:03.834978', '2008-12-02 22:49:03.834978', 21, 152);
INSERT INTO subcategories_users VALUES (153, '2008-12-02 22:49:03.861244', '2008-12-02 22:49:03.861244', 17, 153);
INSERT INTO subcategories_users VALUES (154, '2008-12-02 22:49:03.888675', '2008-12-02 22:49:03.888675', 33, 154);
INSERT INTO subcategories_users VALUES (155, '2008-12-02 22:49:03.916189', '2008-12-02 22:49:03.916189', 34, 155);
INSERT INTO subcategories_users VALUES (156, '2008-12-02 22:49:03.944463', '2008-12-02 22:49:03.944463', 1, 156);
INSERT INTO subcategories_users VALUES (157, '2008-12-02 22:49:03.969993', '2008-12-02 22:49:03.969993', 17, 157);
INSERT INTO subcategories_users VALUES (158, '2008-12-02 22:49:03.996861', '2008-12-02 22:49:03.996861', 17, 158);
INSERT INTO subcategories_users VALUES (159, '2008-12-02 22:49:04.023954', '2008-12-02 22:49:04.023954', 21, 159);
INSERT INTO subcategories_users VALUES (160, '2008-12-02 22:49:04.135217', '2008-12-02 22:49:04.135217', 21, 160);
INSERT INTO subcategories_users VALUES (161, '2008-12-02 22:49:04.162201', '2008-12-02 22:49:04.162201', 45, 161);
INSERT INTO subcategories_users VALUES (162, '2008-12-02 22:49:04.191072', '2008-12-02 22:49:04.191072', 28, 162);
INSERT INTO subcategories_users VALUES (163, '2008-12-02 22:49:04.220254', '2008-12-02 22:49:04.220254', 51, 163);
INSERT INTO subcategories_users VALUES (164, '2008-12-02 22:49:04.249407', '2008-12-02 22:49:04.249407', 34, 164);
INSERT INTO subcategories_users VALUES (165, '2008-12-02 22:49:04.277946', '2008-12-02 22:49:04.277946', 52, 165);
INSERT INTO subcategories_users VALUES (166, '2008-12-02 22:49:04.309565', '2008-12-02 22:49:04.309565', 53, 166);
INSERT INTO subcategories_users VALUES (167, '2008-12-02 22:49:04.336241', '2008-12-02 22:49:04.336241', 2, 167);
INSERT INTO subcategories_users VALUES (168, '2008-12-02 22:49:04.363076', '2008-12-02 22:49:04.363076', 23, 168);
INSERT INTO subcategories_users VALUES (169, '2008-12-02 22:49:04.390147', '2008-12-02 22:49:04.390147', 8, 169);
INSERT INTO subcategories_users VALUES (170, '2008-12-02 22:49:04.416549', '2008-12-02 22:49:04.416549', 39, 170);
INSERT INTO subcategories_users VALUES (171, '2008-12-02 22:49:04.443429', '2008-12-02 22:49:04.443429', 26, 171);
INSERT INTO subcategories_users VALUES (172, '2008-12-02 22:49:04.471997', '2008-12-02 22:49:04.471997', 54, 172);
INSERT INTO subcategories_users VALUES (173, '2008-12-02 22:49:04.502564', '2008-12-02 22:49:04.502564', 55, 173);
INSERT INTO subcategories_users VALUES (174, '2008-12-02 22:49:04.532978', '2008-12-02 22:49:04.532978', 56, 174);
INSERT INTO subcategories_users VALUES (175, '2008-12-02 22:49:04.645222', '2008-12-02 22:49:04.645222', 15, 175);
INSERT INTO subcategories_users VALUES (176, '2008-12-02 22:49:04.670735', '2008-12-02 22:49:04.670735', 8, 176);
INSERT INTO subcategories_users VALUES (177, '2008-12-02 22:49:04.698109', '2008-12-02 22:49:04.698109', 22, 177);
INSERT INTO subcategories_users VALUES (178, '2008-12-02 22:49:04.726912', '2008-12-02 22:49:04.726912', 8, 178);
INSERT INTO subcategories_users VALUES (179, '2008-12-02 22:49:04.759355', '2008-12-02 22:49:04.759355', 57, 179);
INSERT INTO subcategories_users VALUES (180, '2008-12-02 22:49:04.787692', '2008-12-02 22:49:04.787692', 58, 180);
INSERT INTO subcategories_users VALUES (181, '2008-12-02 22:49:04.816615', '2008-12-02 22:49:04.816615', 2, 181);
INSERT INTO subcategories_users VALUES (182, '2008-12-02 22:49:04.845715', '2008-12-02 22:49:04.845715', 59, 182);
INSERT INTO subcategories_users VALUES (183, '2008-12-02 22:49:04.873604', '2008-12-02 22:49:04.873604', 2, 183);
INSERT INTO subcategories_users VALUES (184, '2008-12-02 22:49:04.900688', '2008-12-02 22:49:04.900688', 30, 184);
INSERT INTO subcategories_users VALUES (185, '2008-12-02 22:49:04.929457', '2008-12-02 22:49:04.929457', 15, 185);
INSERT INTO subcategories_users VALUES (186, '2008-12-02 22:49:04.957302', '2008-12-02 22:49:04.957302', 2, 186);
INSERT INTO subcategories_users VALUES (187, '2008-12-02 22:49:04.984382', '2008-12-02 22:49:04.984382', 5, 187);
INSERT INTO subcategories_users VALUES (188, '2008-12-02 22:49:05.057973', '2008-12-02 22:49:05.057973', 2, 188);
INSERT INTO subcategories_users VALUES (189, '2008-12-02 22:49:05.322808', '2008-12-02 22:49:05.322808', 25, 189);
INSERT INTO subcategories_users VALUES (190, '2008-12-02 22:49:05.754322', '2008-12-02 22:49:05.754322', 20, 190);
INSERT INTO subcategories_users VALUES (191, '2008-12-02 22:49:05.863888', '2008-12-02 22:49:05.863888', 17, 191);
INSERT INTO subcategories_users VALUES (192, '2008-12-02 22:49:05.889353', '2008-12-02 22:49:05.889353', 21, 192);
INSERT INTO subcategories_users VALUES (193, '2008-12-02 22:49:05.917425', '2008-12-02 22:49:05.917425', 7, 193);
INSERT INTO subcategories_users VALUES (194, '2008-12-02 22:49:05.945603', '2008-12-02 22:49:05.945603', 27, 194);
INSERT INTO subcategories_users VALUES (195, '2008-12-02 22:49:05.972742', '2008-12-02 22:49:05.972742', 17, 195);
INSERT INTO subcategories_users VALUES (196, '2008-12-02 22:49:05.999854', '2008-12-02 22:49:05.999854', 5, 196);
INSERT INTO subcategories_users VALUES (197, '2008-12-02 22:49:06.026625', '2008-12-02 22:49:06.026625', 17, 197);
INSERT INTO subcategories_users VALUES (198, '2008-12-02 22:49:06.060518', '2008-12-02 22:49:06.060518', 9, 198);
INSERT INTO subcategories_users VALUES (199, '2008-12-02 22:49:06.100515', '2008-12-02 22:49:06.100515', 32, 199);
INSERT INTO subcategories_users VALUES (200, '2008-12-02 22:49:06.12782', '2008-12-02 22:49:06.12782', 2, 200);
INSERT INTO subcategories_users VALUES (201, '2008-12-02 22:49:06.157124', '2008-12-02 22:49:06.157124', 25, 201);
INSERT INTO subcategories_users VALUES (202, '2008-12-02 22:49:06.184591', '2008-12-02 22:49:06.184591', 9, 202);
INSERT INTO subcategories_users VALUES (203, '2008-12-02 22:49:06.212124', '2008-12-02 22:49:06.212124', 12, 203);
INSERT INTO subcategories_users VALUES (204, '2008-12-02 22:49:06.24015', '2008-12-02 22:49:06.24015', 28, 204);
INSERT INTO subcategories_users VALUES (205, '2008-12-02 22:49:06.268774', '2008-12-02 22:49:06.268774', 25, 205);
INSERT INTO subcategories_users VALUES (206, '2008-12-02 22:49:06.294875', '2008-12-02 22:49:06.294875', 22, 206);
INSERT INTO subcategories_users VALUES (207, '2008-12-02 22:49:06.410096', '2008-12-02 22:49:06.410096', 27, 207);
INSERT INTO subcategories_users VALUES (208, '2008-12-02 22:49:06.435522', '2008-12-02 22:49:06.435522', 17, 208);
INSERT INTO subcategories_users VALUES (209, '2008-12-02 22:49:06.466303', '2008-12-02 22:49:06.466303', 7, 209);
INSERT INTO subcategories_users VALUES (210, '2008-12-02 22:49:06.494417', '2008-12-02 22:49:06.494417', 60, 210);
INSERT INTO subcategories_users VALUES (211, '2008-12-02 22:49:06.522794', '2008-12-02 22:49:06.522794', 2, 211);
INSERT INTO subcategories_users VALUES (212, '2008-12-02 22:49:06.551894', '2008-12-02 22:49:06.551894', 43, 212);
INSERT INTO subcategories_users VALUES (213, '2008-12-02 22:49:06.584004', '2008-12-02 22:49:06.584004', 17, 213);
INSERT INTO subcategories_users VALUES (214, '2008-12-02 22:49:06.613874', '2008-12-02 22:49:06.613874', 21, 214);
INSERT INTO subcategories_users VALUES (215, '2008-12-02 22:49:06.639', '2008-12-02 22:49:06.639', 2, 215);
INSERT INTO subcategories_users VALUES (216, '2008-12-02 22:49:06.66858', '2008-12-02 22:49:06.66858', 21, 216);
INSERT INTO subcategories_users VALUES (217, '2008-12-02 22:49:06.696794', '2008-12-02 22:49:06.696794', 61, 217);
INSERT INTO subcategories_users VALUES (218, '2008-12-02 22:49:06.727269', '2008-12-02 22:49:06.727269', 62, 218);
INSERT INTO subcategories_users VALUES (219, '2008-12-02 22:49:06.756546', '2008-12-02 22:49:06.756546', 63, 219);
INSERT INTO subcategories_users VALUES (220, '2008-12-02 22:49:06.784676', '2008-12-02 22:49:06.784676', 8, 220);
INSERT INTO subcategories_users VALUES (221, '2008-12-02 22:49:06.81192', '2008-12-02 22:49:06.81192', 64, 221);
INSERT INTO subcategories_users VALUES (222, '2008-12-02 22:49:06.925666', '2008-12-02 22:49:06.925666', 23, 222);
INSERT INTO subcategories_users VALUES (223, '2008-12-02 22:49:06.952589', '2008-12-02 22:49:06.952589', 17, 223);
INSERT INTO subcategories_users VALUES (224, '2008-12-02 22:49:06.983619', '2008-12-02 22:49:06.983619', 25, 224);
INSERT INTO subcategories_users VALUES (225, '2008-12-02 22:49:07.013479', '2008-12-02 22:49:07.013479', 5, 225);


--
-- Data for Name: taggings; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: user_events; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO users VALUES (1, 'Stephanie', 'Gardiner', 'peaceofmind@xtra.co.nz', '17519e50bda9250901b5454db07177cc71cccdea', '72dc619beba73e6b14b18fb86f7778df30c0a256', NULL, NULL, 'active', NULL, '2008-12-02 22:48:58.542355', NULL, '2008-12-02 22:48:58.513987', '2008-12-02 22:48:58.543045', 15, true, true, false, 'Peace of Mind Clinical Hypnotherapy', '5/21 Humphreys Drive', 'Heathcote', NULL, 95, '03 384 8506', '021 313 161');
INSERT INTO users VALUES (2, 'Aaron', 'McLoughlin', 'office@vervecreative.co.nz', '8d80419ffd2cc1b667e468b5e0b0cc29bc2ce24c', '86ce139a2599f0772c1656fc657a0042b59963e9', NULL, NULL, 'active', NULL, '2008-12-02 22:48:58.635881', NULL, '2008-12-02 22:48:58.626748', '2008-12-02 22:48:58.636553', 2, true, true, true, 'Verve Creative', NULL, 'Oneroa', NULL, 17, '0508 327 486', '027 560 0094');
INSERT INTO users VALUES (3, 'Adrian', 'Metcalfe', 'marstonhouse@kol.co.nz', 'f694f7e5629634d6d7f7a69e1c75bb9d13d676c3', 'd41150e5c2323e6ff395ff61d49b63a6c8880e4f', NULL, NULL, 'active', NULL, '2008-12-02 22:48:58.664985', NULL, '2008-12-02 22:48:58.653676', '2008-12-02 22:48:58.665791', 15, true, true, true, 'Marston Health Clinic', NULL, NULL, NULL, 95, '03 327 4041', '-');
INSERT INTO users VALUES (4, 'Aida', 'Warrenhiven', 'enquiries@skinworks.co.nz', '2f890aea6629956170196a435a6a6a89adb34c54', 'c9ac33c32a1a7001581ce0a47433fb96a76c2215', NULL, NULL, 'active', NULL, '2008-12-02 22:48:58.699503', NULL, '2008-12-02 22:48:58.687997', '2008-12-02 22:48:58.786276', 15, true, true, true, 'Skinworks', NULL, NULL, NULL, 95, '03 379 0606', '-');
INSERT INTO users VALUES (5, 'Aisling', 'Shea', 'reikiparnell@hotmail.com', 'bb4a29aa8454371e495cec6e0340dd103306fdcb', '252f82c5485920a915ffe165e28107407f5091de', NULL, NULL, 'active', NULL, '2008-12-02 22:48:58.814188', NULL, '2008-12-02 22:48:58.804433', '2008-12-02 22:48:58.814918', 2, true, true, true, 'Reiki on Parnell', '8 Weston Ave', 'Parnell', NULL, 9, '-', '021 529 667');
INSERT INTO users VALUES (6, 'Albino', 'Gola', 'ar_gola@clear.net.nz', '90e023182eeb6b1e35e1e5906efc1db360dbfc7e', '4c3f9c93b8c390ee4e2a6958368975e7f4eb0f3a', NULL, NULL, 'active', NULL, '2008-12-02 22:48:58.844056', NULL, '2008-12-02 22:48:58.831714', '2008-12-02 22:48:58.844847', 2, true, true, true, 'Albino Gola', NULL, NULL, NULL, 9, '09 638 8622', '-');
INSERT INTO users VALUES (7, 'Alice', 'Latham', 'pilates@nzsites.com', '685ef2bc7851c88da344efb70d3d35f19c1807cf', 'd58544e48bb0d73296ff20bb6146c25ca3aaed7c', NULL, NULL, 'active', NULL, '2008-12-02 22:48:58.876972', NULL, '2008-12-02 22:48:58.866899', '2008-12-02 22:48:58.877898', 11, true, true, true, 'Pilates Ex Speciaists', 'L3 99 WillisStreet', NULL, NULL, 80, '04 472 1907', '027 635 0540');
INSERT INTO users VALUES (8, 'Alice', 'Maguire', 'alicemaguire@hotmail.com', '80e997ae4771efc00fa3f581ea022ee335700c32', 'd2ad2a72beb4edf1f82faf2a9cd31974ea8b271f', NULL, NULL, 'active', NULL, '2008-12-02 22:48:58.907234', NULL, '2008-12-02 22:48:58.89551', '2008-12-02 22:48:58.907945', 11, true, true, true, 'Head to Toe Therapies', '27/4 Drummond Street', 'Mt Cook', NULL, 80, '-', '021 217 4043');
INSERT INTO users VALUES (9, 'Alison', 'Gallate', 'gallate@paradise.net.nz', '7d67f7b91e7c3138c4c5a4526fc4044736d590ea', '747b29d025c9964d1a4d3f65087a936ed489b535', NULL, NULL, 'active', NULL, '2008-12-02 22:48:58.936535', NULL, '2008-12-02 22:48:58.926757', '2008-12-02 22:48:58.937244', 15, true, true, true, 'Evolution NLP Consultancy & Coaching', NULL, NULL, NULL, 95, '03 981 4657', '-');
INSERT INTO users VALUES (10, 'Alison', 'Mountfort', 'alison@thinklifecoaching.co.nz', '603bb9e73b6bc41d8e3b7ddcb8edf1f82abc37eb', 'd9c70c2a3aa80bd58b30acf3c8d1e600cd5d16a3', NULL, NULL, 'active', NULL, '2008-12-02 22:48:58.962756', NULL, '2008-12-02 22:48:58.95376', '2008-12-02 22:48:58.963484', 15, true, true, true, 'Think Life Coaching', NULL, NULL, NULL, 95, '03 981 1650', '-');
INSERT INTO users VALUES (11, 'Alistair', 'McKenzie', '2letgo@gmail.com', '763166838c5784bd1cc36fffa941c3e4c691c3cf', 'c8eb276292bf8999ff31efc395daca569c196f0a', NULL, NULL, 'active', NULL, '2008-12-02 22:48:58.992804', NULL, '2008-12-02 22:48:58.982444', '2008-12-02 22:48:58.993525', 15, true, true, true, 'McKenzie Alistair', NULL, NULL, NULL, 95, '03 960 7222', '-');
INSERT INTO users VALUES (12, 'Alistair', 'Radford', 'info@yogaindailylife.org.nz', '40101ebbfaffc78dce91caaf11158db00934e8d3', 'aa7d7c8091ed77e43461b01cb801c7f6b7d678dd', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.023025', NULL, '2008-12-02 22:48:59.011189', '2008-12-02 22:48:59.023756', 11, false, true, true, 'Alistair Radford', NULL, NULL, NULL, 80, '04 801 7012', '-');
INSERT INTO users VALUES (13, 'Allan', 'Fayter', 'info@optimum-mind.co.nz', '65790d61caee067057ec7fdf5b62f79b5ce7c581', 'b5255bd263c85e0e89f5fd65feba2c13bbd4e49e', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.055005', NULL, '2008-12-02 22:48:59.045251', '2008-12-02 22:48:59.055721', 15, true, true, true, 'Optimum Mind', NULL, NULL, NULL, 95, '03 942 2103', '-');
INSERT INTO users VALUES (14, 'Amanda', 'Reid', 'samadhiyoga@paradise.net.nz', 'f63d3951a0a1add7f04acd71d883762dee1f134e', '7a390bd350fe505025128eb8f377df123b1ca24a', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.084305', NULL, '2008-12-02 22:48:59.073498', '2008-12-02 22:48:59.085052', 11, false, true, true, 'Amanda Reid', NULL, NULL, NULL, 80, '04 905 1503', '-');
INSERT INTO users VALUES (15, 'Anastasia', 'Benaki', 'abenaki@xtra.co.nz', '6229d68bc66327316c2850e94f9275d56c36cdfd', '38f5850045dbd0b91719c4b2ccc7cc69d32c3123', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.115103', NULL, '2008-12-02 22:48:59.104514', '2008-12-02 22:48:59.115812', 11, false, true, true, 'Anastasia Benaki', NULL, NULL, NULL, 80, '-', '021 709 242');
INSERT INTO users VALUES (16, 'Andrew', 'Thiele', 'andrewthiele@lifecoach.org.nz', '34b52d1b43a9122fe16f43e4855ee7daf29486fe', '15ceea9a227e4e7fe613ac0bfb12aebc3e0eb252', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.143049', NULL, '2008-12-02 22:48:59.133526', '2008-12-02 22:48:59.143716', 15, true, true, true, 'Andrew Thiele - Life Coach', '596 Ferry Road', NULL, NULL, 95, '03 385 5745', '021 121 7846');
INSERT INTO users VALUES (17, 'Angela', 'Baines', 'angela.baines@paradise.net', 'd18416150f85d6230b3604c766b5e86d8dcf4bec', '0cf0e9a7145c77d12b694fa41b31a6a2d7930af4', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.170884', NULL, '2008-12-02 22:48:59.160557', '2008-12-02 22:48:59.171611', 11, true, true, true, 'Origin Health', '1 Horopito Road', 'Waikanae', NULL, 76, '04 905 1451', '021 110 3239');
INSERT INTO users VALUES (18, 'Anna', 'Deng', 'annadc@sohu.com', '734e179804c3cea327bc064deb9e4e719c6b07f6', 'e26600e77572eb7a54187eb839119d319839d9f3', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.198805', NULL, '2008-12-02 22:48:59.188359', '2008-12-02 22:48:59.199551', 15, true, true, true, 'Able Acupuncture', NULL, NULL, NULL, 95, '03 357 9528', '-');
INSERT INTO users VALUES (19, 'Anna', 'Roughan', 'annaroughan@clear.net.nz', '84de231dc94d049fa31f70cfb449a8f54eb7172d', 'aecc9ab5608cdb627b7edd6016fdef5c88f4a251', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.226997', NULL, '2008-12-02 22:48:59.217683', '2008-12-02 22:48:59.311998', 15, true, true, true, 'Roughan Massage Therapy', NULL, NULL, NULL, 95, '03 365 7828', '-');
INSERT INTO users VALUES (20, 'Anne ', 'Batcher', 'bodynsport@yahoo.com', 'adc134a7d18eb99b901e4e20f4121e85a0a93fe9', '5e00e66093a233c854106bb61c18bd9ecaeee9d9', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.342143', NULL, '2008-12-02 22:48:59.33212', '2008-12-02 22:48:59.342845', 15, true, true, true, 'Body & Sport Massage Therapy', NULL, NULL, NULL, 95, '-', '021 406 402');
INSERT INTO users VALUES (21, 'Anne ', 'van Den Bergh', 'anne@yogasanctuary.co.nz', '7f7b1f3e8c3dc891b083aa40d2e22974fe4da8da', 'c98cb8027764d74b808678ea46edcaa7a71d2b0e', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.368154', NULL, '2008-12-02 22:48:59.357793', '2008-12-02 22:48:59.368895', 2, true, true, true, 'Yoga Sanctuary', '16 Maxwelton Dr', 'Mairangi Bay', NULL, 15, '09 479 3888', '-');
INSERT INTO users VALUES (22, 'Anne ', 'Young', 'admin@peoplecoachingpeople.co.nz', '04278aa76e75c99520d6a9617958714814ea0807', 'b581d918bf19cfd30ed57fa7efd857a2fbc3b65a', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.399503', NULL, '2008-12-02 22:48:59.386534', '2008-12-02 22:48:59.400272', 2, true, true, true, 'People Coaching PeopleCo', 'PO Box17-093 or 25218?', NULL, NULL, 9, '-', '021 2014609');
INSERT INTO users VALUES (23, 'Anneliese', 'Kuegler', 'anneliesekuegler@gmail.com', '3fb82e9571d9b4d421d3a8f92a2320a2a4a99459', '9f169f288abbc982e4ac5de6915ee8f30c2409cc', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.425818', NULL, '2008-12-02 22:48:59.416214', '2008-12-02 22:48:59.426677', 2, true, true, true, 'Anneliese Kuegler', 'PO Box 39751', 'Kingsland', NULL, 9, '-', '021 066 7765');
INSERT INTO users VALUES (24, 'Annette', 'Davidson', 'annette@bodysystems.co.nz', '3e8e8187ff7d9df8b2815c19dd2713d04787f670', '856aca265f1d2611b7955b79a586a68f9897ee47', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.456608', NULL, '2008-12-02 22:48:59.447196', '2008-12-02 22:48:59.457347', 11, true, true, false, 'Body Systems', '368 Tinakori Road', 'Thorndon', NULL, 80, '04 499 7515', '-');
INSERT INTO users VALUES (25, 'Annette', 'K', 'mysticsnz@hotmail.com', '60635c70fe6bc8c6f57d212f06b89ec954eef5cf', '7559d169d8f700497ae86c7491d3edd1fbbb5435', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.484161', NULL, '2008-12-02 22:48:59.474783', '2008-12-02 22:48:59.484866', 15, true, true, true, 'Annette K', NULL, 'Burwood', NULL, 95, '-', '021 1128484');
INSERT INTO users VALUES (26, 'Ann-Marie', 'McAndrew', 'mcandrew.neuromuscular@xtra.co.nz', '8e74d85bae602d7a2e25cf8b8d5217b40bc742e1', 'c59d4a2910e4237f30c9f4654ed72fa2ea71d0dc', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.520678', NULL, '2008-12-02 22:48:59.511121', '2008-12-02 22:48:59.521373', 11, true, true, true, 'McAndrew Natural Health Therapy', 'Lev 1 Johnsonville Medical Centre', 'Johnsonville', NULL, 80, '04 920 0978', '021 234 0430');
INSERT INTO users VALUES (27, 'Anya', 'Nidd', 'anya_nidd@earthling.net', '44d779630b0fbe52dbb41519d98f66bd335498a3', '72646e4f0567f8855e629ffe3dcb10b7a60a5a49', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.55082', NULL, '2008-12-02 22:48:59.540245', '2008-12-02 22:48:59.55157', 11, false, true, true, 'Anya Nidd', NULL, NULL, NULL, 80, '-', '021 257 6116');
INSERT INTO users VALUES (28, 'April', 'Campbell', 'rebalance@paradise.net.nz', '90d5fa0f83ea3f42c18c13bf3757a8a0f6bf7742', 'fb2b975d94acd02d6142a0c522b13c8b45da2d3a', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.58243', NULL, '2008-12-02 22:48:59.57289', '2008-12-02 22:48:59.583202', 11, false, true, true, 'April Campbell', NULL, NULL, NULL, 80, '04 905 1037', '-');
INSERT INTO users VALUES (29, 'Averil ', 'Maher', 'stressless@xtra.co.nz', 'a79cd529fdfd198056284dc0af6dd6cefcc9930b', '8833facf14aa6423529ce0d2d242fe215e20f116', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.614253', NULL, '2008-12-02 22:48:59.600133', '2008-12-02 22:48:59.614968', 11, true, true, true, 'Stressless', '158 Peka Peka Road', 'Peka Peka', NULL, 76, '04 293 3232', '021 150 4722');
INSERT INTO users VALUES (30, 'Barbara', 'Clegg', 'barbara@walkyourtalkinternational.co.nz', '83f3cc0504d41ada05b24aa16c85c35d493775c7', 'e4e7a5b61eccb43414f2050f7b226cc2a671c071', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.640285', NULL, '2008-12-02 22:48:59.630382', '2008-12-02 22:48:59.640997', 15, true, true, true, 'Walk Your Talk Intl Ltd.', NULL, 'Waimakariri', NULL, 103, '03 313 0521', '-');
INSERT INTO users VALUES (31, 'Barbara', 'Coley', 'barbara@soulintegration.co.nz', 'd2cd8da0a473c5dcdd785ba531094ab0fa849a7b', '7ce96df98478f747ad7bfef8edbf5dc6acdbbfef', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.665776', NULL, '2008-12-02 22:48:59.655566', '2008-12-02 22:48:59.66654', 2, true, true, true, 'Soul Integration', '14 Horotutu Road', 'Grey Lynn', NULL, 9, '09 360 8869', '021 170 2640');
INSERT INTO users VALUES (32, 'Barbara', 'Hedger', 'whitewolfnz@hotmail.com', 'fd0816d5c6f33bdb2d215aea3417b70250405aa0', '27d0a9ae6c670cd6980b0e8ba62a619018515acd', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.692765', NULL, '2008-12-02 22:48:59.683602', '2008-12-02 22:48:59.693573', 9, true, true, true, 'Crystal Harmony Ltd.', 'Cherry Tree Place, Ohau, RD20', 'Horowhenua', NULL, 65, '06 368 7234', '021 435285');
INSERT INTO users VALUES (33, 'Barron', ' Braden', 'trance@clear.net.nz', 'd19418de9506d23b4157a2b4736895412227c0c1', '7f142eb32611465686e6e56bd3d4f25c85ea8807', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.72032', NULL, '2008-12-02 22:48:59.711143', '2008-12-02 22:48:59.721342', 2, true, true, true, 'TranceFormations Hypnotherapy', NULL, 'Piha', NULL, 18, '09 8129007', '027 444 9766');
INSERT INTO users VALUES (34, 'Beth', 'Jones', 'tides@paradise.net.nz', '9af2a6ba342bac6fd3c78e110bf88fabaabfa743', 'c1f53bb04eff362014c5bf3a320f304ace47352e', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.751367', NULL, '2008-12-02 22:48:59.740791', '2008-12-02 22:48:59.752066', 11, true, true, true, 'Beth Jones', '108a Darlington Road', 'Miramar', NULL, 80, '04 934 2389', '027 3244 842');
INSERT INTO users VALUES (35, 'Bob', 'Cavanagh', 'bob@bobcavanagh.co.nz', 'b7002646ea47e78f01596ae03ad73d66d7e1d6b4', 'c01c0e2fe8cb5cd71e5062f814345e25559ec5b7', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.86486', NULL, '2008-12-02 22:48:59.855393', '2008-12-02 22:48:59.86556', 11, true, true, true, 'Bob Cavanagh', NULL, NULL, NULL, 80, '04 934 2492', '021 406 260');
INSERT INTO users VALUES (36, 'Brian ', 'Lamb', 'lambkinz@xtra.co.nz', 'afa3620b9d8d67276c64db8be9ad286552f58232', '199a2ac5fd2f72f965e8f6eb194598c9c431c80e', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.894021', NULL, '2008-12-02 22:48:59.882674', '2008-12-02 22:48:59.894769', 5, true, true, true, 'Your Mind', '451 Muhunoa East Road', NULL, NULL, 47, '06 863 2280', '027 4717772');
INSERT INTO users VALUES (37, 'Bron', 'Deed', 'homeopathyplus@ihug.co.nz', '8cab4eac18f738b8cb0d25f530de106877a1c586', 'b9f0a997ea2c32d0c00e11a2888e0d409cfaf05c', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.926926', NULL, '2008-12-02 22:48:59.917295', '2008-12-02 22:48:59.927635', 2, true, true, true, 'Bron Deed', NULL, NULL, NULL, 9, '09 810 7188', '-');
INSERT INTO users VALUES (38, 'Bruce', 'Harper', 'wellness4u@xtra.co.nz', 'e6a349d7cbe77d73bb32141a53652547e53b7044', '52ae7d727d1c4ebc9da36691488f79562aa72cc5', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.956207', NULL, '2008-12-02 22:48:59.945379', '2008-12-02 22:48:59.957049', 2, true, true, true, 'Wellness4u Clinic Ltd', '782a Remuera Road', 'Remuera', NULL, 9, '09 522 2225', '-');
INSERT INTO users VALUES (39, 'Camilla', 'Watson', 'watson.c.s@paradise.net.nz', '5d63810c85f0fd78d5e0d334fe12c404c8cb2312', 'b58806d0e292335c382018d50f92891b93b58a3b', NULL, NULL, 'active', NULL, '2008-12-02 22:48:59.986343', NULL, '2008-12-02 22:48:59.976243', '2008-12-02 22:48:59.987079', 11, true, true, false, 'Psychic Development', 'level 6, 75 Ghuznee Street', NULL, NULL, 80, '04 234 7522', '-');
INSERT INTO users VALUES (40, 'Carmel', 'Hotai Cochrane', 'carmelhotai@xtra.co.nz', '07a2e27085e1dc1f9e00b74cee8333a9830c4066', '24abfaf7735f6fdc4c7afc8e50a05cfb118215bb', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.016145', NULL, '2008-12-02 22:49:00.005543', '2008-12-02 22:49:00.01694', 2, true, true, true, 'Manaki Wellbeing', '10 Richborne Street', 'Kingsland', NULL, 9, '09 845 8048', '-');
INSERT INTO users VALUES (41, 'Catherine', 'Falconer', 'arborvitae2004@yahoo.com.au', '80d0d3cee94088e9c8a02919419a3cf8a92a1fdc', 'ed38c3e0e13c3717441c0fdf88b82ea8555b5359', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.047057', NULL, '2008-12-02 22:49:00.036405', '2008-12-02 22:49:00.047948', 11, true, true, false, 'Arborvitae', NULL, NULL, NULL, 80, '04 977 9435', '027 300 6637');
INSERT INTO users VALUES (42, 'Catherine', 'Goldenhill', 'catherine@goldenhil.co.nz', '291c29750d6e898c85e2c3ef0eff15c018513052', 'cd558a01e15f6b08b7eb8b75ab122ab946eda237', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.076931', NULL, '2008-12-02 22:49:00.067772', '2008-12-02 22:49:00.077648', 2, true, true, true, 'Goldenhill School of Healing Arts', '782a Remuera Road', 'Remuera', NULL, 9, '09 833 3108', '-');
INSERT INTO users VALUES (43, 'Chai', 'Deva', 'Chai@bodyexcel.com', '96ad6bf831658fafed5fad807f9341e779de0b32', '3f5a764801a7db98cce125e577d14664df75b680', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.110875', NULL, '2008-12-02 22:49:00.093165', '2008-12-02 22:49:00.11163', 15, true, true, true, 'Body Excel', NULL, NULL, NULL, 95, '0800 263 995', '-');
INSERT INTO users VALUES (44, 'Charles', 'McGrosky', 'theramass@xtra.co.nz', '1074e65c82873ab5128aae3e213680b7f18380a1', '9bcc17b3bc9c8645325bd8f52ed270844e6e9969', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.139696', NULL, '2008-12-02 22:49:00.126861', '2008-12-02 22:49:00.140434', 15, true, true, true, 'Charles McGrosky', NULL, NULL, NULL, 95, '03 385 0544', '-');
INSERT INTO users VALUES (45, 'Charlotte', 'Hathaway', 'charlotte.h@actrix.co.nz', '14ee3beca41542d3149475b978e72f5c94c34500', '062a729184469c91d108125dac5effbd63ccc9e5', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.187352', NULL, '2008-12-02 22:49:00.176269', '2008-12-02 22:49:00.188049', 11, true, true, true, 'Charlotte Hathaway', NULL, NULL, NULL, 80, '04 499 4069', '021 067 4841');
INSERT INTO users VALUES (46, 'Charrette', 'Boyce', 'charrette@gmail.com', '9b2c6d2e834f1abdcc8b8ff0c99abd3c4c3a335b', 'ab1fd02c0d4aff9af8142c579206df83eb8d7322', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.21307', NULL, '2008-12-02 22:49:00.203821', '2008-12-02 22:49:00.213749', 15, true, true, true, 'Mount Pleasant Pilates', '181 Moncks Spur Rd', 'Mount Pleasant', NULL, 95, '03 384 8005', '027 413 9605');
INSERT INTO users VALUES (47, 'Cherie', 'Anslow', 'Cherie_anslow@yahoo.com', '3c7bf72699f0dd99139826843104a5ebd28610c4', '3db62d03eb4640d347ab8248959543e8e3987f9e', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.24085', NULL, '2008-12-02 22:49:00.231219', '2008-12-02 22:49:00.241527', 11, true, true, true, 'Cherie Anslow', 'PO Box 22014', 'Khandallah', NULL, 80, '-', '027 282 8919');
INSERT INTO users VALUES (48, 'Cherry ', 'King', 'cherry-massage@paradise.net.nz', 'd32feeb1d2ce51702b069f094012635526c2bc81', '4198d73b1cc77f9121ca2df32423c12f59c06ba5', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.26826', NULL, '2008-12-02 22:49:00.259157', '2008-12-02 22:49:00.269004', 11, true, true, false, 'Cherry  King', NULL, NULL, NULL, 80, '04 473 3776', '021 207 8989');
INSERT INTO users VALUES (49, 'Chris', NULL, 'mishmash1188@xtra.co.nz', 'ec1f52e2957a783f67ea344c63fb33013169558f', '700430b1be430085e0bbbf559e556a036043ab5b', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.295815', NULL, '2008-12-02 22:49:00.285692', '2008-12-02 22:49:00.296503', 15, true, true, true, 'Chris ', '29 NewsteadLane', 'Addington', NULL, 95, '-', '-');
INSERT INTO users VALUES (50, 'Christine ', 'Toner', 'christine@toner.co.nz', 'b50f5b0e2a9855e2d77854f1516a6969c3dc24c4', '1c0a97d8bdfe55faf14c4268c07f85f15374bc81', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.408928', NULL, '2008-12-02 22:49:00.313877', '2008-12-02 22:49:00.409745', 15, true, true, true, 'Christine  Toner', '77 Mount Pleasant Rd', 'Redcliffs', NULL, 95, '03 384 9167', '027 4339598');
INSERT INTO users VALUES (51, 'Claudine', 'Alony', 'terschip@hotmail.com', '15332378a5e17ad28474704b3b2095b65c8161de', '89cf7120c31ee2ed11bd4391eaf48b57dc3536cc', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.434416', NULL, '2008-12-02 22:49:00.425117', '2008-12-02 22:49:00.435118', 2, true, true, true, 'Healing Massage', '21 Starlight Cove ', 'Howick', NULL, 14, '-', '021 899 978');
INSERT INTO users VALUES (52, 'Colleen', NULL, 'info@thevillabeauty.co.nz', 'e33138c2b9b0880c761a684f0cf9104fccfc29b7', '842c4e73c7aa58b184781d94168a9e63c9bd17ba', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.46565', NULL, '2008-12-02 22:49:00.454834', '2008-12-02 22:49:00.466458', 10, true, true, true, 'The Villa Beauty Therapy', '10-12 Church Street', NULL, NULL, 73, '06 370 4561', '027 4191005');
INSERT INTO users VALUES (53, 'Cushla', 'Reid', 'cushey@ihug.co.nz', 'b92535f905dfd56de319567e01e00c5ed9f19c2e', 'b6d95f8511278fed2e9e77486a5fbb66df70437a', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.492918', NULL, '2008-12-02 22:49:00.482763', '2008-12-02 22:49:00.493628', 11, true, true, false, 'Cushla Reid', 'Natural Health Centre, 2nd Floor,53 Courtney Place', NULL, NULL, 80, '04 385 4342', '0274 214 900');
INSERT INTO users VALUES (54, 'Daniel', 'Condor', 'dmassageworks@xtra.co.nz', '112eb7e21dbe36acb534516c3542510d701521cd', '4a9c23fe2522df2d33f1c9fd6b60da712f7abc75', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.521778', NULL, '2008-12-02 22:49:00.509562', '2008-12-02 22:49:00.522516', 4, true, true, true, 'massageworks', '31 Gillies Ave', NULL, NULL, 42, '-', '-');
INSERT INTO users VALUES (55, 'David ', 'Mason', 'info@hypknowsis.com', '232a6d9db92a2e7f1e8fe57d86afb06275e39db9', 'c95cb07d18ddeda1d82a306892c00912ad1cfe75', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.551245', NULL, '2008-12-02 22:49:00.540236', '2008-12-02 22:49:00.552009', 11, true, true, true, 'Wellingtom Hypnotherapy', '34 Hawtrey Terrace', 'Johnsonville', NULL, 80, '04 478 4100', '027 404 8003');
INSERT INTO users VALUES (56, 'Debbie', 'Mann', 'info@anoukherbals.co.nz', '48813d77c85d785ccba84161053938c605a9ce4b', 'a1b2f3cd4615ec215d0385e9694c334bcb35de27', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.580794', NULL, '2008-12-02 22:49:00.570754', '2008-12-02 22:49:00.581677', 15, true, true, true, 'Anouk', NULL, NULL, NULL, 95, '03 942 2103', '-');
INSERT INTO users VALUES (57, 'Debby ', 'Guddee', 'pmt_therapies@xtra.co.nz', 'b2bd127efe0f6931fc34d947e99a4e0b1a6220ad', '46d1d8aa0b0d1e9266ff66fc86ccfed30427ad8a', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.613424', NULL, '2008-12-02 22:49:00.601187', '2008-12-02 22:49:00.614123', 11, true, true, true, 'Mystical Therapies', '42 Percy Street', NULL, NULL, 79, '-', '021 332 427');
INSERT INTO users VALUES (58, 'Dee', 'Smith', 'justmassage@xtra.co.nz', '31410ecfd7d21061ca4ccc58b362da41a65b020e', 'dfb444dd4a4d2b2510b00d980a00fdabdbd896b5', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.638404', NULL, '2008-12-02 22:49:00.628816', '2008-12-02 22:49:00.640033', 2, true, true, true, 'Just Massage', '40 St Benedict Street', NULL, NULL, 15, '09 486 3335', '-');
INSERT INTO users VALUES (59, 'Delia', 'Crozier', 'delia_crozier@yahoo.com.au', 'da16d1de959bf2d16d721477df7d335c5b4222e3', 'ac5f77172c174dcb92ad19949862c161f2deaa6a', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.668749', NULL, '2008-12-02 22:49:00.659347', '2008-12-02 22:49:00.669502', 11, true, true, true, 'Holistic Counselling', 'Natural Health Centre, 2nd Floor, 53 Courtney Place', NULL, NULL, 80, '04 385 4342', '027 256 6800');
INSERT INTO users VALUES (60, 'Denise ', 'O''Malley', 'homeopath@ihug.co.nz', 'e771afddaa54233cce7e002fd679313c47d39fa1', 'b722743c9dcb2749bbfb6a9e83a22990fb129f7c', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.694835', NULL, '2008-12-02 22:49:00.684554', '2008-12-02 22:49:00.695606', 2, true, true, true, 'Denise  O''Malley', '1/102 Remuera Rd', 'Remuera', NULL, 9, '09 520 1260', '021 520 081');
INSERT INTO users VALUES (61, 'Diane', 'White', 'clinicalhypnotherapy@mail.com', '7837c083ebc7ebf4695afbb5e34a3d5b63eb826c', 'f30c85561b94185811f0dc10a3adc8833c125e09', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.727835', NULL, '2008-12-02 22:49:00.717078', '2008-12-02 22:49:00.728528', 15, true, true, true, 'Diane White-Clinical Hypnotherapist Life Coach', NULL, NULL, NULL, 95, '03 358 9792', '-');
INSERT INTO users VALUES (62, 'Dr Ian', 'Ball', 'drianball@mac.com', '6047fdf65037ecb417789425cb423aaf113061a3', 'dac53f9b5264520b8aa1304c2fce94777b14843d', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.753682', NULL, '2008-12-02 22:49:00.743475', '2008-12-02 22:49:00.754409', 2, true, true, true, 'Dr Ian Ball', NULL, NULL, NULL, 9, '09 307 1123', '027 272 2715');
INSERT INTO users VALUES (63, 'Dr. Dov', 'Phillips', 'connecttolife@gmail.co.nz', '7483daa228b0bd3cb69a5520e8669d843d4dc871', '1d77adbf8bae287473c1a4ae7e0ae737b384b466', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.783838', NULL, '2008-12-02 22:49:00.7744', '2008-12-02 22:49:00.784505', 2, true, true, true, 'Connect to life', NULL, NULL, NULL, 9, '09 488 0781', '021 286 5433');
INSERT INTO users VALUES (64, 'Dr. Graeme', 'Teague', 'gteague@xtra.co.nz', 'a407910dc6801bdf1542ca10bbd666c0ff308397', '46cdb2c832d030e4c6958f82f345381220af0722', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.810861', NULL, '2008-12-02 22:49:00.799149', '2008-12-02 22:49:00.811587', 15, true, true, true, 'Graeme Teague Ltd', '21 Len Hale Place', 'Ferrymead', NULL, 95, '03 384 0160', '-');
INSERT INTO users VALUES (65, 'Dr. Hayden', 'Sharp', 'hayden@equilibriumchiropractic.com', '07f8df74ff72e00e8eeb7eabc3e9dcd7e75e5630', '13815683810bae52cdbc1846f82ebde8ec8f98b5', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.839755', NULL, '2008-12-02 22:49:00.829351', '2008-12-02 22:49:00.84053', 12, true, true, true, 'Equilibrium Chiropractic', '114 Milton Street', NULL, NULL, 84, '03 548 0082', '-');
INSERT INTO users VALUES (66, 'Dr. Pratibha', 'Dalvi', 'pratibha@paradise.net.nz', '4dc389f46eef58b1d0a1cdc59b720a3882e4026c', '52bdae502ca5d6d578b3c1896b12d2fbd213cc65', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.950279', NULL, '2008-12-02 22:49:00.940896', '2008-12-02 22:49:00.950986', 2, true, true, true, 'Wilcott Street Health Care Centre', NULL, NULL, NULL, 9, '09 815 5560', '-');
INSERT INTO users VALUES (67, 'Dr. Singh', 'Saini', 'Dr.N.S.Saini@xtra.co.nz', '946ed7bee752a3d5db6f12333dde14418c66afa3', '8222d404dd850a5738618ddbdc015901d04adb05', NULL, NULL, 'active', NULL, '2008-12-02 22:49:00.976808', NULL, '2008-12-02 22:49:00.965943', '2008-12-02 22:49:00.977658', 2, true, true, true, 'Dr. Singh Saini', NULL, NULL, NULL, 9, '09  630 3909', '-');
INSERT INTO users VALUES (68, 'Dreenagh', 'Heppleston', 'unique_nlp@paradise.net.nz', '7c71ad06ead3b519b51a5bcc1cb988b195216a94', '1408fafc4228e82d3b558bcbe610559ba7a7ccd2', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.006904', NULL, '2008-12-02 22:49:00.994851', '2008-12-02 22:49:01.007679', 11, false, true, true, 'Dreenagh Heppleston', NULL, NULL, NULL, 80, '04 562 0071', '-');
INSERT INTO users VALUES (69, 'Elissa', 'Brittenden', 'konagirlnz@gmail.com', '83804c6c88f5c40d16dd88d1ac467e797d9c5716', '9f30a58a0915fa71b88359704963d004af2db325', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.033647', NULL, '2008-12-02 22:49:01.023837', '2008-12-02 22:49:01.034386', 15, true, true, false, 'Rangiora Clinical Massage', NULL, 'Waimakariri', NULL, 103, '03 313 7672', '021 441323');
INSERT INTO users VALUES (70, 'Emma', 'Van Veen', 'ameliorate@paradise.net.nz', 'a5e38479c62faa2067ecdd42ae681341a81e57e4', '7c0432a6e3de3ce195e25cc1b35b60d592d2263d', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.065643', NULL, '2008-12-02 22:49:01.056097', '2008-12-02 22:49:01.066331', 11, true, true, false, 'Ameliorate', NULL, NULL, NULL, 80, '04 478 6982', '-');
INSERT INTO users VALUES (71, 'Eric', 'Saxby', 'esax@paradise.net.nz', '70c10f32e216bc4584dc4fd9d4376ff15dc6cca9', 'e52e4c07ec0ede57989740800fba80439a902810', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.09117', NULL, '2008-12-02 22:49:01.080993', '2008-12-02 22:49:01.092009', 15, true, true, true, 'Eric Saxby', NULL, NULL, NULL, 95, '03 980 3130', '-');
INSERT INTO users VALUES (72, 'Estelle', 'Cainey', 'info@infiniteintegrity.co.nz', '2579ed5445b5cf39e8a1d6df15893b9284cb74dc', '42d7c281f3072c4b2d2fbb4dc73281fe2a5f2ac9', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.127341', NULL, '2008-12-02 22:49:01.117378', '2008-12-02 22:49:01.128037', 11, true, true, true, 'infinite integrity', NULL, NULL, NULL, 80, '04 383 6166', '027 208 3836');
INSERT INTO users VALUES (73, 'Fiona', 'Dolan', 'fiona.dolan@hotmail.com', '3b0d5801c2f728668e0398a646037b0ae2cd32fb', '496c2041e865acdcddf469bb18d54e22930a5c82', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.156548', NULL, '2008-12-02 22:49:01.143823', '2008-12-02 22:49:01.157405', 11, true, true, true, 'Fiona Dolan', '1/54 Whites Line West', NULL, NULL, 77, '04 587 0053', '021 913 224');
INSERT INTO users VALUES (74, 'Fiona', 'Goulding', 'fiona.goulding@actrix.co.nz', '04a60d2d0c4ca12bb13956cd942eabbe1809410b', '7a180e806109a76861def591cfef6ce72deaf8a8', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.186283', NULL, '2008-12-02 22:49:01.17645', '2008-12-02 22:49:01.186973', 15, true, true, true, 'Fiona Goulding', NULL, NULL, NULL, 95, '03 326 6226', '-');
INSERT INTO users VALUES (75, 'Fiona', 'Links', 'flinks@xtra.co.nz', '95761bb0cb1e4f5381359b4dff0fc5d7a5e9513c', 'b3f0f9ab27416b9f41622b64c22024bb9b956f71', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.214277', NULL, '2008-12-02 22:49:01.201963', '2008-12-02 22:49:01.215027', 4, true, true, true, 'Taupo Yoga Studio', '54 Ayrshire Drive', NULL, NULL, 42, '07 378 3372', '021 063 9249');
INSERT INTO users VALUES (76, 'Georgia', 'Bryant', 'acuhealth1@xtra.co.nz', 'ec0fea6fdfe52f2ba7d8573c9fc58c7d89c2ef50', 'b67b17557e7dd30b6e6ba3d99a18239a93c51884', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.242689', NULL, '2008-12-02 22:49:01.231534', '2008-12-02 22:49:01.244038', 15, true, true, true, 'Acupuncture for Health', NULL, NULL, NULL, 95, '03 388 7346', '-');
INSERT INTO users VALUES (77, 'Glyn', 'Flutey', 'glyn@osteopathicedge.co.nz', '434d84bdf9dc280f29402c4b750e9d06a3d166f9', '7aaf28134b9e83b666c29b99ea23c72dfaaf4177', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.270264', NULL, '2008-12-02 22:49:01.259091', '2008-12-02 22:49:01.270985', 2, true, true, true, 'Osteopathic Edge', '48 Bellevue Road', 'Mt. Eden', NULL, 9, '09 630 3790', '-');
INSERT INTO users VALUES (78, 'Hamish', 'Abbie', 'pulsept@xtra.co.nz', 'f7093dd1ea690b5b340ea5e3d59572de1d081ff4', 'bad5e8e016f80b844af4afba67f71abbf0b32420', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.297813', NULL, '2008-12-02 22:49:01.28771', '2008-12-02 22:49:01.298573', 11, false, true, true, 'Hamish Abbie', NULL, NULL, NULL, 80, '-', '021 730 281');
INSERT INTO users VALUES (79, 'Hayley', 'Nicholls', 'hayley@energycoach.co.nz', '06e293fc9631be1d98f58117780bc613363c73a6', '1e2ca767c8bf29ef2ded8958065f0cbcc6a78297', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.326348', NULL, '2008-12-02 22:49:01.315655', '2008-12-02 22:49:01.327073', 2, true, true, true, 'Compassion Buddist Centre', NULL, NULL, NULL, 9, '09 828 0687', '027 338 0009');
INSERT INTO users VALUES (80, 'Heather', 'Todd', 'heather@EFTclinic.co.nz', '54c24d78d63deb3a63cbc70c88835d018a925007', 'afeaef3e432da495a416c93c8a2cc81edad6809e', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.352197', NULL, '2008-12-02 22:49:01.343256', '2008-12-02 22:49:01.352875', 11, true, true, true, 'EFT Clinic', '149-3 Hill Road', NULL, NULL, 77, '04 565 3692', '027 437 0785');
INSERT INTO users VALUES (81, 'Heather', 'Wright', 'theramass2@xtra.co.nz', '23ee258d5b3fba3ca7da48e32253380b35c25af5', '516e61ee2145dc4b9e72603363b1bed20f0e281f', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.38291', NULL, '2008-12-02 22:49:01.368971', '2008-12-02 22:49:01.383661', 15, true, true, true, 'Heather Wright', '118 Bealey Ave', NULL, NULL, 95, '03 385 0544', '-');
INSERT INTO users VALUES (82, 'Helena ', 'Tobin', 'helenatobin@paradise.net.nz', '0829d45828fa57f25770f5375a2d5f2e809aaa04', 'be09a3ca5fc91cdc95df9601808aeda7a1a9ad73', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.491549', NULL, '2008-12-02 22:49:01.482195', '2008-12-02 22:49:01.492337', 11, true, true, true, 'Helena  Tobin', NULL, NULL, NULL, 80, '04 569 6164', '-');
INSERT INTO users VALUES (83, 'Ingrid', 'Bryant', 'inbryant@clear.net.nz', '9e65ab957e4afc35564658c0ced0d0d54a28ca4a', 'dca7b945c143232198fcb141049c2b4b0401cda2', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.524807', NULL, '2008-12-02 22:49:01.508959', '2008-12-02 22:49:01.525545', 6, true, true, true, 'Lifeforce Health', NULL, NULL, NULL, 50, '06 876 7948', '027 335 5673');
INSERT INTO users VALUES (84, 'Isha', 'Doellgasr', 'isha1728@yahoo.com', '514eaaaa812aee4411e09538e5830c10df418cc1', '9208c14228fb3d5b2c9c3ed338704334dcc8d36e', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.554679', NULL, '2008-12-02 22:49:01.545144', '2008-12-02 22:49:01.555386', 11, true, true, true, 'Aloha Massage', '46 Jackson Street', 'Island Bay', NULL, 80, '04 973 6055', '021 152 4438');
INSERT INTO users VALUES (85, 'Jackie ', 'Pratley', 'jackiepratley@hotmail.com', '092972af24fae1140bf17c71fd12b221630ff11a', 'abd38f50548135ca8195125b5f9ee8cb0d9613e4', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.584167', NULL, '2008-12-02 22:49:01.570521', '2008-12-02 22:49:01.585927', 15, true, true, true, 'Jackie  Pratley', NULL, NULL, NULL, 95, '03 383 3084', '-');
INSERT INTO users VALUES (86, 'Jacob', 'Munz', 'jacob@harahealth.co.nz', 'd2b00b8089ddbc5b536ec4f57ed6b55e0a8ed14d', '636c10f9ce08dfa519c5ec068e4867d4b45c3351', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.613579', NULL, '2008-12-02 22:49:01.602286', '2008-12-02 22:49:01.614398', 11, true, true, true, 'Hara Health', 'L3, 41 Dixon Street', NULL, NULL, 80, '04 3828175', '-');
INSERT INTO users VALUES (87, 'Jacqui', 'Vestergaard', 'starlightrising@xtra.co.nz', '9b7b395ee0d885d6f52eaa038cacccf725cf8c07', '74436325fea46aaa782cbea996b7289da687ed2a', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.641569', NULL, '2008-12-02 22:49:01.630016', '2008-12-02 22:49:01.642306', 11, true, true, true, 'Starlightrising.com', '316 Paekak Hill Rd', 'Paekakariki', NULL, 76, '04 237 6362', '021 141 2690');
INSERT INTO users VALUES (88, 'Jan & Maree', 'Stachel-Williamson', 'jan@nwow.co.nz', '8e66e6ecb84eb6616b0bec1a811956e19d5f964f', '6702c6fc621c40697a43d21ab1d78c9f411beb88', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.674041', NULL, '2008-12-02 22:49:01.664696', '2008-12-02 22:49:01.674722', 15, true, true, true, 'nWow! NLP & Kinesiology Solutions', NULL, NULL, NULL, 95, '-', '021 070 0132');
INSERT INTO users VALUES (89, 'Jan', 'Canton', 'jan@directsuccess.co.nz', '3ee2d86adf422d746afdab7b7f9c51935f385e97', '59d4ec7c2b9be1f45cc0826917c47cc6ac123704', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.699747', NULL, '2008-12-02 22:49:01.68913', '2008-12-02 22:49:01.700587', 3, true, true, false, 'Direct Success Coaching Ltd', 'POBox 102', NULL, NULL, 23, '07 846 5486', '-');
INSERT INTO users VALUES (90, 'Jane', 'Allan', 'jane@thehavencentre.co.nz', 'e7280eafcca817c61531b29789d55f6c49a2f8a1', 'bf82541e966792427798fce0c293239809bd2ced', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.734485', NULL, '2008-12-02 22:49:01.724641', '2008-12-02 22:49:01.735172', 15, true, true, true, 'ISBT-Bowen Therapy', '3 York Street', NULL, NULL, 95, '03 313 8661', '021 2238838');
INSERT INTO users VALUES (91, 'Jane', 'Cowan-Harris', 'jane@sitrightworkwell.co.nz', '21fdb45b5089de612d82db276373a4f810d2b64d', 'a4e00f2b74ef93a418ca33047fbf573c2d8bb48b', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.763777', NULL, '2008-12-02 22:49:01.752268', '2008-12-02 22:49:01.764572', 15, true, true, false, 'SitRight Workwell', NULL, NULL, NULL, 95, '03 326 5450', '021 043 5342');
INSERT INTO users VALUES (92, 'Jane', 'Hipkiss', 'jane@healingarts.co.nz', '0c924058344506306e91543f32e647e5ac77eb8a', '43216ebec29cb6cb5f836c6a9cd322db1d834122', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.795466', NULL, '2008-12-02 22:49:01.78615', '2008-12-02 22:49:01.79616', 11, false, true, true, 'Jane Hipkiss', NULL, NULL, NULL, 80, '04 293 7325', '-');
INSERT INTO users VALUES (93, 'Jane', 'Logie', 'jane.logie@clear.net.nz', 'd909a36a841362f59105ca84062cb629b9932bd6', '36ad0674ca65097ed84f94e6804ebebfd56cebe7', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.822473', NULL, '2008-12-02 22:49:01.811274', '2008-12-02 22:49:01.823254', 15, true, true, true, 'Jane Logie', NULL, NULL, NULL, 95, '03 302 8773', '-');
INSERT INTO users VALUES (94, 'Jane', 'Manthorpe', 'jcm@rawinspiration.biz', '74931ace7eca6114e311740768ac0a371b071cb4', 'ca35c2e14da6e1f79b5c0846b914080e80e07911', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.8521', NULL, '2008-12-02 22:49:01.842275', '2008-12-02 22:49:01.852803', 15, true, true, true, 'Jane Manthorpe', NULL, NULL, NULL, 95, '-', '-');
INSERT INTO users VALUES (95, 'Jane', 'Valentine-Burt', 'hypnotherapy@actrix.co.nz', '2f4efeb03adb1180a04c822504fc5ac5abaac6ce', 'e9ee7f5cd1f2e2b1288037cb103a07a984ea7adc', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.87745', NULL, '2008-12-02 22:49:01.867548', '2008-12-02 22:49:01.878161', 2, true, true, true, 'Professional Hypnotherapy', '22 Jervois Road', 'Hobsonville', NULL, 18, '09 416 5385', '027 4444 104');
INSERT INTO users VALUES (96, 'Janice', 'Denney', 'janice.denney@blazemail.com', '74fc4fdeefe026e74086024380199dcd95eede5f', '0557df7b14761c2477dbca08d3308e19ff6d4f69', NULL, NULL, 'active', NULL, '2008-12-02 22:49:01.907394', NULL, '2008-12-02 22:49:01.897693', '2008-12-02 22:49:01.908167', 11, false, true, true, 'Janice Denney', NULL, NULL, NULL, 80, '04 970 1447', '-');
INSERT INTO users VALUES (97, 'Jasmina', 'Kovacev', 'efthelp@gmail.com', '76edb484387d99c9583a34e25133ac6199cc9941', '1c04b13c50bd82b3e566b87caf7c28e6576e2ef0', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.019102', NULL, '2008-12-02 22:49:01.925925', '2008-12-02 22:49:02.019836', 11, true, true, false, 'emo-free', NULL, NULL, NULL, 80, '04 565 3888', '027 608 0078');
INSERT INTO users VALUES (98, 'Jason', 'Belch', 'actionmuscle@xtra.co.nz', '388412eb5936cf35c12c49187d01f8e6809e8d63', '229d7b7e42a8c4b1fe53507cac12a7bfaf329461', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.046732', NULL, '2008-12-02 22:49:02.035209', '2008-12-02 22:49:02.047495', 11, true, true, true, 'Action Muscle Therapy', '20/232 Middleton Road', 'Johnsonville', NULL, 80, '-', '0211 098 142');
INSERT INTO users VALUES (99, 'Jason', 'MacDonald', 'jason.goodmassage@gmail.com', '49df6ae3d83285d99a6b9be69c5c74f92c049bf8', '4b5a973c0305d5f3b6e64ff6d479cb92d518f037', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.07922', NULL, '2008-12-02 22:49:02.069093', '2008-12-02 22:49:02.079956', 15, true, true, true, 'Good Massage', '158 Bealey Road', 'Moncks Bay', NULL, 95, '03 365 5665', '027 514 5777');
INSERT INTO users VALUES (100, 'Jax ', 'Storey', 'jaxstorey@ihug.co.nz', '8cd3867817c30ceeb5b7bd1b53bbad56ccfa2f02', '1972306d31472c695ddce0822f3076d6bc8f5acc', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.112956', NULL, '2008-12-02 22:49:02.100448', '2008-12-02 22:49:02.113773', 15, true, true, true, 'Wellbeing Room', NULL, NULL, NULL, 95, '03 348 5733', '-');
INSERT INTO users VALUES (101, 'Jennie', 'McMurran', 'vitality@paradise.net.nz', '90d67667c430f5daaf73c5df5abad6d6960e2981', 'd73caa78cb6491b8cdb29ae6197d83a79ed88655', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.141812', NULL, '2008-12-02 22:49:02.131077', '2008-12-02 22:49:02.142557', 11, true, true, false, 'Jennie McMurran', NULL, NULL, NULL, 80, '04 389 9776', '021 725 751');
INSERT INTO users VALUES (102, 'Jennifer', 'James', 'jennifer@juniperjunxion.c0.nz', '152c1c2a8ed1a7e62c825cd2d12f268dffa77ee9', 'fc53a8b3ec6838bf4cb20a99373e711f41a6c6d7', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.179455', NULL, '2008-12-02 22:49:02.169585', '2008-12-02 22:49:02.180174', 2, true, true, true, 'Juniperjunxion', NULL, NULL, NULL, 9, '09 476 0000', '-');
INSERT INTO users VALUES (103, 'Jenny', 'Georgeson', 'jenny@bodha.co.nz', '066bda06afd1d00e30eef54ff7244d46ea9e2d7d', 'b2804868f91d8e4c5806394bf311c7d52474d542', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.204862', NULL, '2008-12-02 22:49:02.195542', '2008-12-02 22:49:02.205546', 15, true, true, true, 'Bodha', NULL, NULL, NULL, 95, '03 384 0594', '-');
INSERT INTO users VALUES (104, 'Jill', 'Casey', 'caseyjill@hotmail.com', '775b9a568ef169a681bc40e78085862fd6eba59d', '2326903c4b310bd07922008deb43c16ed22ad4d4', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.233085', NULL, '2008-12-02 22:49:02.223636', '2008-12-02 22:49:02.233776', 11, false, true, true, 'Jill Casey', NULL, NULL, NULL, 80, '04 472 9996', '-');
INSERT INTO users VALUES (105, 'Jill', 'Casey', 'jkcasey@hydrohealthwellington.co.nz', '28ce630776559832991a0e9463b2f4dfd900bbcc', '2bb48e97c58d3f2254fc397da20fc15572e230f3', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.258449', NULL, '2008-12-02 22:49:02.249274', '2008-12-02 22:49:02.259131', 11, true, true, true, 'Jill Casey', 'Dixon Street Health', NULL, NULL, 80, '04 802 0823', '-');
INSERT INTO users VALUES (106, 'Jo ', 'Hampton', 'jokiwikid@yahoo.com', '1c6390debba24a6d108e54bd2672dcfe3e740e41', 'd5bb2e23a03a3c2536c5f41c1737e2ab7c65da11', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.286472', NULL, '2008-12-02 22:49:02.275829', '2008-12-02 22:49:02.287163', 15, true, true, true, 'Bikram Yoga College of India', NULL, NULL, NULL, 95, '03 383 9903', '-');
INSERT INTO users VALUES (107, 'Jo ', 'Woods', 'jojoandayla@xtra.co.nz', '14d78b9b223ddd096ef75e4a3d02ec9dd139cfa1', 'db0a4f124a5165c85652cac6bc6b68b8f8281d7b', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.313055', NULL, '2008-12-02 22:49:02.303648', '2008-12-02 22:49:02.313834', 15, true, true, true, 'M4U Corporate - Mobile Massage', NULL, NULL, NULL, 95, '-', '021 775215');
INSERT INTO users VALUES (108, 'Joanne', 'Marama', 'theomarama@xtra.co.nz', 'eae6f4809b70ae170f1f77e4d91ca259946c3ea1', '436dbe61b79ebcb64bb843664973d0093299dfd9', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.341807', NULL, '2008-12-02 22:49:02.330363', '2008-12-02 22:49:02.342563', 15, true, true, true, 'Joanne Marama', NULL, NULL, NULL, 95, '03 347 7628', '-');
INSERT INTO users VALUES (109, 'Joanne', 'Ostler', 'joanne@careerwise.co.nz', 'fffd08f75a3a050558c4ee9d594acd83a6ec47aa', '18da9ac10dee33aced449dc0f86ccbe6620632bb', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.368703', NULL, '2008-12-02 22:49:02.359672', '2008-12-02 22:49:02.36938', 3, true, true, true, 'Careerwise', NULL, 'Waipa', NULL, 21, '-', '021 950 022');
INSERT INTO users VALUES (110, 'Jodi', 'Salter', 'soulsticenz@yahoo.co.nz', 'b8ef3fd0f65b83d4c6930b0ef475e2edf518ddc5', '8417913c486d3f704c61554ad3bbabb54f60e2b3', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.397586', NULL, '2008-12-02 22:49:02.385969', '2008-12-02 22:49:02.398277', 15, true, true, true, 'Soulstice Natural Medicine', NULL, NULL, NULL, 95, '03 379 9303', '-');
INSERT INTO users VALUES (111, 'John', 'Jing', 'john@acucentre.co.nz', '7aae5c0aff6e31c0a1a7ebdec4c8cc66c6853a45', '8bc4613cb9fa74cfc50bd3e52a311e832af19032', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.425059', NULL, '2008-12-02 22:49:02.413413', '2008-12-02 22:49:02.425731', 15, true, true, true, 'AcuCentre Chinese Healthcare', NULL, NULL, NULL, 95, '03 365 0688', '-');
INSERT INTO users VALUES (112, 'John', 'Ramsey', 'john.ramsay@mail.com', '7d8a91031631c62a64b7c4c5fc14fa7ac445f770', 'e0ead0c5d302cddc39c8b401ede38adbca83cd6b', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.453446', NULL, '2008-12-02 22:49:02.443263', '2008-12-02 22:49:02.454131', 2, true, true, true, 'John Ramsey', '1d-3 Cheshire Street', 'Parnell', NULL, 9, '-', '021 0231 1633');
INSERT INTO users VALUES (113, 'Joseph', 'Quinn', 'joseph@openroadassociates.com', 'a90a5acf7c431ccbeb1642988e2e5678c4db68fd', 'f1d42166098e0cfebf532a1e6c3c7bba9bbb4a84', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.565992', NULL, '2008-12-02 22:49:02.555813', '2008-12-02 22:49:02.566759', 2, true, true, true, 'Open Road Associates', '28 Elmira Place', NULL, NULL, 9, '09 357 0724', '021 022 46959');
INSERT INTO users VALUES (114, 'Joyce', 'Puch', 'puch1996@gmail.com', '0cca17c30594503a5ad4e06d4e3f0940a5594f46', 'b187a59cc420c4acfa5915177e946695593fcdc2', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.592516', NULL, '2008-12-02 22:49:02.582288', '2008-12-02 22:49:02.593262', 11, true, true, true, 'Choice Communication Group', 'Unit 3, 47-49 Wellington Road', 'Kilbernie', NULL, 80, '04 386 3454', '021 140 1180');
INSERT INTO users VALUES (115, 'Judy ', 'Montgomery', 'judyonline@xtra.co.nz', 'cf2233bbc8117e73d86a9e5cda7f54b98e99b191', '83fccb3a9fcba808fd8dccd0fa719c127e56754f', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.623192', NULL, '2008-12-02 22:49:02.611777', '2008-12-02 22:49:02.623941', 11, true, true, true, 'Judy  Montgomery', NULL, NULL, NULL, 80, '-', '027 2229056');
INSERT INTO users VALUES (116, 'Judy', 'Lynne', 'mayfly@paradise.net.nz', '340c7d2805c1d6da2537894c1705da4b0c919d90', 'd5929987545db9d87a7337df27113a36b09d0fdd', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.649865', NULL, '2008-12-02 22:49:02.639166', '2008-12-02 22:49:02.650693', 11, true, true, true, 'Living Thinking Being', 'PO Box 31253', NULL, NULL, 77, '-', '027 222 9056');
INSERT INTO users VALUES (117, 'Jules', 'McRae', 'julesmcr@paradise.net.nz', '807f6ca6d9296f8c3584a3bfd4a074f1d848dde8', 'b570ae1ad0b6f1964358b56f6cd08220efda10d4', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.677399', NULL, '2008-12-02 22:49:02.667927', '2008-12-02 22:49:02.678075', 11, false, true, true, 'Jules McRae', NULL, NULL, NULL, 80, '04 970 3554', '-');
INSERT INTO users VALUES (118, 'Julia', 'Biermann', 'soundstrue@paradise.net.nz', '55b67ea3baf6a40be873e0eb373f5306d0197ed5', '62172fa46696afe7b022ef6cd0fd867735348b02', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.706686', NULL, '2008-12-02 22:49:02.694384', '2008-12-02 22:49:02.707486', 2, true, true, true, 'Julia Biermann', NULL, 'Torbay ', NULL, 15, '09 473 1022', '-');
INSERT INTO users VALUES (119, 'Karen ', 'Shepherd', 'km.shephard@yahoo.co.nz', '8405300ff567736bc6604154854c53db1f0333dd', '90c3e6f5c50347bf9f202007def678b3a6b80309', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.738255', NULL, '2008-12-02 22:49:02.728073', '2008-12-02 22:49:02.739036', 2, true, true, true, 'Karen  Shepherd', '162 Ocean View Road', 'Papatoetoe', NULL, 14, '-', '021 0243 8620');
INSERT INTO users VALUES (120, 'Karen', 'Newitt', 'karen@handsonhealth.co.nz', '168751dbd3489ab068aae6f5ef95b0dc2592a8b5', 'c216de2805d65e8dcc6f9ed26750af6ac7116e97', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.764', NULL, '2008-12-02 22:49:02.753823', '2008-12-02 22:49:02.76473', 2, true, true, true, 'Hands On Health?', NULL, NULL, NULL, 9, '09 413 7547', '-');
INSERT INTO users VALUES (121, 'Kate', 'Harper', 'k8t@hushmail.com', 'bebe37d86cc5e040ce87b37004aa5fa7d89b34ef', 'bc753bdba51599fa769ee74d1853b93c3f243b17', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.794554', NULL, '2008-12-02 22:49:02.784731', '2008-12-02 22:49:02.795273', 2, true, true, true, 'Kate Harper', '18 Grand View Road', 'Remuera', NULL, 9, '09 522 2225', '027 240 5467');
INSERT INTO users VALUES (122, 'Katie', 'Lane', 'lane@kiwiwebhost.sarcoma.netnz', '85f622cfe09e4663e79b616d0ff123c9ba21012b', '68a993b8534c090b7ce664d3dc1a988e268292aa', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.823011', NULL, '2008-12-02 22:49:02.810424', '2008-12-02 22:49:02.823768', 15, true, true, true, 'Yoga Kula NZ', '139 Main Rd', NULL, NULL, 95, '03 337 6522', '-');
INSERT INTO users VALUES (123, 'Katrina', 'Rivers', 'katrina@healingart.co.nz', 'b0c4cfca947acc98a19c5ad8d3131295f557e885', '642cb91bb4be9012ef1b33116213d674587ecbff', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.852995', NULL, '2008-12-02 22:49:02.842678', '2008-12-02 22:49:02.853707', 2, true, true, true, 'Katrina Rivers', '3/37 Allenby Road', 'Papatoetoe', NULL, 14, '09 278 7991', '021 385 919');
INSERT INTO users VALUES (124, 'Kaytee', 'Boyd', 'kayteeBoyd@xtra.co.nz', '7b73ad5f48091d80d9350c7c61325985bab23710', '5b203e1b9f8912376633e1bc521b70d160706b89', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.878797', NULL, '2008-12-02 22:49:02.868259', '2008-12-02 22:49:02.879536', 2, true, true, true, 'Oomph', NULL, NULL, NULL, 9, '-', '021 460 444');
INSERT INTO users VALUES (125, 'Kevi', 'Hawkins', 'kevin.h@paradise.net.nz', '6b467ea69c3725a0d98aaafdf5360d17cd6ce6bb', '34b86c6530c24c5ef8495f26e38c78ed3c27af28', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.906733', NULL, '2008-12-02 22:49:02.895511', '2008-12-02 22:49:02.907441', 11, false, true, true, 'Kevi Hawkins', NULL, NULL, NULL, 80, '04 232 6585', '-');
INSERT INTO users VALUES (126, 'Kim ', 'Marshall', 'kim.manna@xtra.co.nz', '47700bb567a3325493f8ca401503b47941d9a4c1', '63a6a13c20c446374db6f4e694f5ad72a2bac391', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.931967', NULL, '2008-12-02 22:49:02.921948', '2008-12-02 22:49:02.932686', 2, true, true, true, 'FreeLife', NULL, NULL, NULL, 9, '-', '021 823 224');
INSERT INTO users VALUES (127, 'Kim ', 'Snell', 'body_mind_soul@hotmail.com', '8ec511ffcc448572cb370a4760163d979577f5e1', '392e9f4cc805fdd7c9064b16dbc1c7918a85dc5d', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.960089', NULL, '2008-12-02 22:49:02.950691', '2008-12-02 22:49:02.960775', 2, true, true, true, 'BodyMindSoul', '2 Jervois Road', 'Piha', NULL, 18, '-', '021 211 9847');
INSERT INTO users VALUES (128, 'Kim ', 'Turton', 'kst.50@clear.net.nz', '1b9cd0938d0978580f52a22b8da181ed52cca37b', '2dd36f17baa997983f3f96655baf2bc4567ed9e6', NULL, NULL, 'active', NULL, '2008-12-02 22:49:02.984418', NULL, '2008-12-02 22:49:02.975056', '2008-12-02 22:49:02.985302', 11, true, true, true, 'Kim  Turton', '79 Pretoria Street', NULL, NULL, 77, '04 566 7130', '021 231 7878');
INSERT INTO users VALUES (129, 'Kim', 'Chamberlain', 'kim@successfulspeaking.co.nz', 'a4b2f08043afd8333c767769a807d63197438250', '9dd0f911c2a747a0e9206203870549b312bac884', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.099553', NULL, '2008-12-02 22:49:03.089832', '2008-12-02 22:49:03.100296', 11, false, true, true, 'Kim Chamberlain', NULL, NULL, NULL, 80, '04 232 3726', '-');
INSERT INTO users VALUES (130, 'Kip', 'Mazuy', 'kip@bliss-music.com', '3b33b728b57e0d5d7bf8628f36e110164aaf6430', '44cac98f3668ab347b823d293d11a03bee754ebd', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.127758', NULL, '2008-12-02 22:49:03.115264', '2008-12-02 22:49:03.128518', 2, true, true, true, 'Kip Mazuy', NULL, 'Piha', NULL, 18, '09 812 8329', '-');
INSERT INTO users VALUES (131, 'Kris ', 'Mills', 'Kmills@chevron.com', 'bee7ac92cc5e493176b0032fcae764d5851c412f', 'e18c68475cd91700270d3601433ff81a30435e21', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.16015', NULL, '2008-12-02 22:49:03.146117', '2008-12-02 22:49:03.160997', 11, true, true, true, 'Kris  Mills', '80 Beazley Ave', 'Paparangi', NULL, 80, '04 470 6832', '027 470 6832');
INSERT INTO users VALUES (132, 'Laura', 'Bradburn', 'acudoc@ihug.co.nz', '02fd6b712da5b2ab9aa6fb3735fb766a28e14cb8', 'a80518e5342019d080f470e68e3b3b8b6f7852d8', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.185824', NULL, '2008-12-02 22:49:03.17588', '2008-12-02 22:49:03.18665', 2, true, true, true, 'Laura Bradburn', NULL, NULL, NULL, 9, '09 626 7120', '-');
INSERT INTO users VALUES (133, 'Linda', 'Spence', 'linda@bodymind.co.nz', '7f7038c05fa0684989b928b5e2a6fd8dba037ad5', '679b1d4f99b1b63e0344c647562c129f11e5b5a0', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.213053', NULL, '2008-12-02 22:49:03.203883', '2008-12-02 22:49:03.213788', 10, false, true, true, 'Linda Spence', NULL, NULL, NULL, 73, '06 370 1121', '-');
INSERT INTO users VALUES (134, 'Liz ', 'Ryan', 'lizryantherapy@xtra.co.nz', '48f5fd352b1ed178ee49ed1cbc549a9daec621f7', '4ae7e5787142377c53c09cf11eddfdb41c33d2f3', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.241588', NULL, '2008-12-02 22:49:03.230188', '2008-12-02 22:49:03.24264', 15, true, true, true, 'Liz  Ryan', NULL, NULL, NULL, 95, '03 315 7310', '-');
INSERT INTO users VALUES (135, 'Liz', 'Riversdale', 'liz.riversdale@vistacoaching.co.nz', '122a0c8c8daa73583ed09c9df55ed594a6c04019', 'a01c2dd8fb6c76cbfe4189d9c2651ec0a78da1c5', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.268847', NULL, '2008-12-02 22:49:03.258774', '2008-12-02 22:49:03.269568', 11, true, true, true, 'Vista Coaching', '51 Brussels Street', 'Miramar', NULL, 80, '-', '021 252 3234');
INSERT INTO users VALUES (136, 'Liz', 'Wassenaar', 'liz@bodymindconnections.co.nz', '345a6be883627aedc9995bea9305fb52ccb5a363', '46aa0b002963ef358ef3c208a63882d0f534527a', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.297633', NULL, '2008-12-02 22:49:03.286921', '2008-12-02 22:49:03.298371', 11, true, true, true, 'Mind Body Connections', '97 Williams Street', 'Petone', NULL, 77, '04 586 2246', '-');
INSERT INTO users VALUES (137, 'Lorel', 'Julian', 'oasis.health@paradise.net.nz', 'a5ba976f66e54a8152e3ee1f5cc32ebe3cbbb869', '15ad392716ed70a11f1e2ea83242712439de09bf', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.329068', NULL, '2008-12-02 22:49:03.317398', '2008-12-02 22:49:03.329787', 15, true, true, true, 'Oasis Holistic Health Limited', NULL, NULL, NULL, 95, '03 386 2414', '-');
INSERT INTO users VALUES (138, 'Louise', 'Hockley', 'louise@chiro.co.nz', '4750c2a737ec8956f58554e63583f10f0a3b7996', 'ab4ec63edd3aa5b4cb1a8fb8a7d161d375da4851', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.354626', NULL, '2008-12-02 22:49:03.344854', '2008-12-02 22:49:03.355344', 11, false, true, true, 'Louise Hockley', NULL, NULL, NULL, 80, '04 499 7755', '-');
INSERT INTO users VALUES (139, 'Lynda ', 'Millar', 'lynda.millar@hotmail.com', 'c55fa759665c79d18a41658e26ac38f4523b5ec1', '61092c5a3d2f98250fe33a8240c93738729bc825', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.381183', NULL, '2008-12-02 22:49:03.371861', '2008-12-02 22:49:03.382001', 11, true, true, false, 'Lynda  Millar', NULL, NULL, NULL, 80, '04 802 0820', '021 510 378');
INSERT INTO users VALUES (140, 'Lynda', 'Moe', 'soar2success@paradise.net.nz', 'fe4df3fa28d1de45d129ccc6624210d84e8acd5b', 'b6d1ac92a73a734d61ead59032fb88398fd953fb', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.409711', NULL, '2008-12-02 22:49:03.399519', '2008-12-02 22:49:03.410468', 2, true, true, true, 'Lynda Moe Trasnsformations', '25 Vermont Street', 'Point Chevalier', NULL, 9, '09 820 0633', '021 252 5537');
INSERT INTO users VALUES (141, 'Lynda', 'Molen', 'pilateswithlydia@paradise.net.nz', 'f6e8eb2dfe520f49f000ba7f522ceca3a6de4df9', 'dba0b1f15ee7a0784a669047daf84b5e0013eede', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.437189', NULL, '2008-12-02 22:49:03.427307', '2008-12-02 22:49:03.437937', 11, false, true, true, 'Lynda Molen', NULL, NULL, NULL, 80, '04 938 0676', '-');
INSERT INTO users VALUES (142, 'Malcolm', 'Idoine', 'malcolmi@xtra.co.nz', 'e7411733183ee77f247e0853bbec5f4036c958ef', '2196f935ce8ab03edd73598fc719892e69136b38', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.461342', NULL, '2008-12-02 22:49:03.452488', '2008-12-02 22:49:03.462101', 2, true, true, true, 'Malcolm Idoine', NULL, 'Ponsonby', NULL, 9, '-', '027 2345 333');
INSERT INTO users VALUES (143, 'Mandy ', 'Pickering', 'info@jettherapynorthwest.co.nz', '3b9980f9cf898ae04c12dcd7e1545e13db4e7943', 'f753cd0731426dc56a704e47bd1fa33ec9f69942', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.491721', NULL, '2008-12-02 22:49:03.48218', '2008-12-02 22:49:03.492433', 15, true, true, true, 'Jet Therapy North West', NULL, NULL, NULL, 95, '03 359 0280', '-');
INSERT INTO users VALUES (144, 'Marcia ', 'Pollack', 'marciapnz@paradise.net.nz', 'cac7e90ec368d07000643406f665e4a088696144', '5e0a913d5bceba2c7e8225e158961a59db380bec', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.602593', NULL, '2008-12-02 22:49:03.507813', '2008-12-02 22:49:03.603314', 11, false, true, true, 'Marcia  Pollack', NULL, NULL, NULL, 80, '04 569 7923', '-');
INSERT INTO users VALUES (145, 'Maree', 'Mason', 'victoriakidd@paradise.net.nz', '04024aa18e1dfb1fdab0fc7e74f72532786c4cdd', '446bed9f1ceb544fc33ff123ee409f841b8e7e17', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.628716', NULL, '2008-12-02 22:49:03.619076', '2008-12-02 22:49:03.629434', 15, true, true, true, 'In Touch', NULL, NULL, NULL, 95, '03 942 3104', '-');
INSERT INTO users VALUES (146, 'Maria', 'Gibbons', 'casajam@xtra.co.nz', '047f6e50be83b202774e3bfec54a13c96402f36a', '588a263f96875d27229f39d8eeb07646c7611f9d', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.65501', NULL, '2008-12-02 22:49:03.644884', '2008-12-02 22:49:03.655814', 11, false, true, true, 'Maria Gibbons', NULL, NULL, NULL, 80, '04 232 3343', '-');
INSERT INTO users VALUES (147, 'Maricia', 'Churchward', 'maricia@mamalu.co.nz', 'b6bc365b94dd61f13bfa7e7f3a1af5436352ede1', 'a368c5368414b902f1754426e7cd556c60eb37f9', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.683005', NULL, '2008-12-02 22:49:03.673257', '2008-12-02 22:49:03.683697', 11, true, true, true, 'Mamalu Coaching Ltd', '512 Evans Bay Pde', 'Evans Bay', NULL, 80, '04 386 1463', '0272 861 463');
INSERT INTO users VALUES (148, 'Marie ', 'Cameron', 'homeopathclinic@orcon.net.nz', '36c30043feb2ee285a78569b5c91f9f616650ad5', 'a8125f260890e03790e83d8ea564cf9e9e59e0ad', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.709035', NULL, '2008-12-02 22:49:03.698804', '2008-12-02 22:49:03.710367', 2, true, true, true, 'Homeopathic Healing Clinic', '137 Whitney Street', 'Browns Bay', NULL, 15, '09 486 7731', '027 351 5217');
INSERT INTO users VALUES (149, 'Marion', 'Kerr', 'marian@mariankerr.co.nz', '6518d7b948d4f31cb9dcc0ac54362fe717bbd70b', '1b98c76bb2d8f257083025c0215d0f94a0ccdeea', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.740786', NULL, '2008-12-02 22:49:03.729339', '2008-12-02 22:49:03.741621', 11, true, true, false, 'contemplatecoaching', 'PO Box 5157', 'Whitby', NULL, 78, '04 234 1957', '021266 2699');
INSERT INTO users VALUES (150, 'Mariska', 'Deventer', 'Mariska@paradise.net.nz', '7ec7cb523f6673170ee7757581cece3108b7aa3c', 'e8adec1e22c02ec2531c25fe1e7911b68287f458', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.766784', NULL, '2008-12-02 22:49:03.756559', '2008-12-02 22:49:03.767521', 11, false, true, true, 'Mariska Deventer', NULL, NULL, NULL, 80, '04 934 3368', '-');
INSERT INTO users VALUES (151, 'Mark', 'Cross', 'contact@envistaconsulting.com', '905e37706afef97d3f9b7af3e028f0d28fdb034e', 'a5f6dec97ac0e8f1bf17b942436b7c76be19e765', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.797751', NULL, '2008-12-02 22:49:03.788156', '2008-12-02 22:49:03.798563', 11, true, true, true, 'Envista Consulting', '15 Lawson Place', 'Mt. Victoria', NULL, 80, '-', '021 251 6727');
INSERT INTO users VALUES (152, 'Mary', 'Romanos', 'maryromanos@slingshot.co.nz', '94adb3cbafeaef24d8bc40885b59fa3bf8084d2e', 'a39adf7d7cf0d90199602b1124cb19854026c445', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.824074', NULL, '2008-12-02 22:49:03.813327', '2008-12-02 22:49:03.824851', 11, true, true, true, 'Mary Romanos', NULL, NULL, NULL, 80, '-', '-');
INSERT INTO users VALUES (153, 'Maureen ', 'Graham', 'maureengnz@yahoo.co.nz', '854b74495bc5dfc6e26a317e02130e123888f440', '6b7d9a696d6f838f01973faf7331027e5c47a69d', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.852309', NULL, '2008-12-02 22:49:03.842936', '2008-12-02 22:49:03.853033', 15, true, true, true, 'Maureen  Graham', NULL, NULL, NULL, 95, '03 338 1338', '-');
INSERT INTO users VALUES (154, 'May', 'Sahar', 'maysahar@quantumconsulting.co.nz', '9f7a6ee274818d1b2851a7128fcfbcf87a8e26b3', '54f409758d46b191b1b25ca67ed375c9178ec955', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.878144', NULL, '2008-12-02 22:49:03.868094', '2008-12-02 22:49:03.878888', 11, false, true, true, 'May Sahar', NULL, NULL, NULL, 80, '04 970 8007', '-');
INSERT INTO users VALUES (155, 'Melinda', 'Bredin', 'Chiropractictouch@clear.net.nz', '4d0c2fc46b4a033520846f76f79b6a50c1eac2f0', 'c96f6a27dc0f9dc2b9cb1a594702975d2b7aed0f', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.90685', NULL, '2008-12-02 22:49:03.896802', '2008-12-02 22:49:03.907562', 2, true, true, true, 'Chiropractic Touch', NULL, NULL, NULL, 9, '09 488 8001', '-');
INSERT INTO users VALUES (156, 'Meredith', 'McCarthy', 'emmccarthy@xtra.co.nz', 'b1a039dc51a3581862bd48fdb0763a074978362b', '07d568eaf6c37cd59edc38c7b5684b331d574fde', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.933323', NULL, '2008-12-02 22:49:03.923347', '2008-12-02 22:49:03.934236', 11, true, true, true, 'Meredith McCarthy', 'Manuka Health Centre,11 HectorSt ', 'Petone', NULL, 77, '04 577 1116', '027 699 3950');
INSERT INTO users VALUES (157, 'Michaela', 'Ballard', 'qe2massage@xtra.co.nz', '00cec0a7fa2318e2073ca6131190259b2058575f', 'f96b07bda25143bd3632590e7c2db7d946e2c47a', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.96145', NULL, '2008-12-02 22:49:03.951509', '2008-12-02 22:49:03.962196', 15, true, true, true, 'QE11 Clinical massage Therapy', NULL, NULL, NULL, 95, '03 383 5809', '-');
INSERT INTO users VALUES (158, 'Mike', 'Smith', 'mike.therapy@gmail.com', 'f9ff9deb291eb18cbdb7b644789f97038412a396', '4a291e2f4a67f63b2accc998e364d5fcfe5f9d97', NULL, NULL, 'active', NULL, '2008-12-02 22:49:03.986576', NULL, '2008-12-02 22:49:03.976768', '2008-12-02 22:49:03.987325', 2, true, true, true, 'Mike Smith', NULL, 'Mt. Albert', NULL, 9, '09 815 2534', '021 660728');
INSERT INTO users VALUES (159, 'Monika', 'Vadai', 'mvadai@hotmail.com', 'fc1f15d2311ebd7dc5024766a9f50b8cf2574ee6', 'a0e70c9223159259073e4171fb0e7764068eef68', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.015279', NULL, '2008-12-02 22:49:04.005761', '2008-12-02 22:49:04.016029', 2, true, true, true, 'Medicina Healing Centre', 'Shop 5, 13 Kent Street ', 'Newton', NULL, 9, '-', '0211 603 528');
INSERT INTO users VALUES (160, 'Nahaia', 'Russ N.D', 'nahaia@xtra.co.nz', 'a601d655a4d7a3ca2ad61bbef43f8bc826832660', '824808a4650e52e85b7d84907bbaa1f0cb21fc3b', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.126217', NULL, '2008-12-02 22:49:04.030981', '2008-12-02 22:49:04.126928', 2, true, true, true, 'Divine Lotus Healing Spa', NULL, NULL, NULL, 15, '09 489 6999', '-');
INSERT INTO users VALUES (161, 'Nalisha', 'Patel', 'nalisha@healthmastery.co.nz', 'd4fe65e31c7874a7e8661c496b5a245ef4be21d7', '2639d7aaee2bfb74db20ea51531fcbd89159164f', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.152878', NULL, '2008-12-02 22:49:04.142919', '2008-12-02 22:49:04.153714', 2, true, true, true, 'Health Mastery Ltd', NULL, 'Manukau', NULL, 14, '0508 742 736', '-');
INSERT INTO users VALUES (162, 'Naomi', 'Saito Chong Nee', 'healingroom.lapis@yahoo.co.nz', 'a54a3d60bc8907578f163cca4be11695382f845d', 'c365e1ea4f75c3738547e22348c032ae22fd8b0a', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.180692', NULL, '2008-12-02 22:49:04.169484', '2008-12-02 22:49:04.181476', 11, true, true, true, 'Naomi Saito Chong Nee', '2 Hinau Street', 'Linden', NULL, 80, '04 232 2965', '021 037 5091');
INSERT INTO users VALUES (163, 'Natasha', 'Berman', 'allergytesting@ihug.co.nz', 'c0d12a58b833f12b6cc9c9525a44d9f937379ad4', '6dce8798bf460ca6a4f3f7e31d82f558c5546bdb', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.210226', NULL, '2008-12-02 22:49:04.200439', '2008-12-02 22:49:04.211039', 2, true, true, true, 'Allergenics', NULL, NULL, NULL, 9, '09 817 6110', '-');
INSERT INTO users VALUES (164, 'Neil ', 'Bossenger', 'neil@spinewave.co.nz', '1336bc7996cfbc8cc65570a8d4884ef39666c636', '519f6a0f8274440d311b87f0eeacf0cedca7cac2', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.238212', NULL, '2008-12-02 22:49:04.227533', '2008-12-02 22:49:04.239013', 2, true, true, true, 'Spinewave Wellness Centre', 'PO Box 44036', 'Remuera', NULL, 9, '09 522 0025', '021 239 7623');
INSERT INTO users VALUES (165, 'Ngaire', 'Francis', 'ngaire@restorativehealth.co.nz', '4cfdf136d8e62fbc486e5a540a50ece39b374cf1', 'ee57476e556c96e490f8143c9261a0c129273820', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.269561', NULL, '2008-12-02 22:49:04.258976', '2008-12-02 22:49:04.270264', 11, true, true, true, 'restorative Health', NULL, NULL, NULL, 80, '04 890 3880', '-');
INSERT INTO users VALUES (166, 'Niel', 'Pryor', 'neilpryor@paradise.net.nz', '67d944870fd20930ca9c809e53f845faff09f498', 'e35da9c339deff06a3fdcfc7424b538ca221a23c', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.298776', NULL, '2008-12-02 22:49:04.286954', '2008-12-02 22:49:04.299509', 11, false, true, true, 'Niel Pryor', NULL, NULL, NULL, 80, '04 472 9222', '-');
INSERT INTO users VALUES (167, 'Norma', 'Stein', 'norma@eurekacoaching.co.nz', 'ff20b789f075933f9608c10e43f31b259e10604b', '5008f4fa7e710c9ebb796ff47bfd1df8213887fe', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.327087', NULL, '2008-12-02 22:49:04.316838', '2008-12-02 22:49:04.327813', 11, true, true, true, 'Eureka!Coaching', '20 Finlay Terrace', 'Mt Cook', NULL, 80, '04 801 8847', '021 549 923');
INSERT INTO users VALUES (168, 'Pamela', 'Mercer', 'dmercer@actrix.co.nz', '6daa97de6c5f933320a7d85231f259a291aadf63', '71b929581bdf322814e675b1c459134485ff72c2', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.353534', NULL, '2008-12-02 22:49:04.343405', '2008-12-02 22:49:04.354338', 15, true, true, true, 'Cranio Sacral Therapy', NULL, NULL, NULL, 95, '03 352 0082', '-');
INSERT INTO users VALUES (169, 'Pat', 'Guo', 'patguo@gmail.com', '5557155fb21a0dd3adda1577ca2225fe27847109', 'af160a437fdff9ea22fc58ae75de6b281f5c4659', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.381456', NULL, '2008-12-02 22:49:04.370909', '2008-12-02 22:49:04.382261', 15, true, true, true, 'Christchurch Acupuncture Centre', NULL, NULL, NULL, 95, '03 354 2398', '-');
INSERT INTO users VALUES (170, 'Paula ', 'Johnson', 'innerspirit@xtra.co.nz', 'c51d5b2a13fbf00cf953cd339d74e7f1a3e1eb36', '964f96b6605b589e7b1bc53e8fa1183e797e60ee', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.406892', NULL, '2008-12-02 22:49:04.397117', '2008-12-02 22:49:04.407645', 11, true, true, true, 'Balance & Harmony', NULL, NULL, NULL, 80, '04 526 7842', '-');
INSERT INTO users VALUES (171, 'Philip', 'Bayliss', 'phil.bayliss@orcon.net.nz', '3980f75750eacb1a087b801e3f5a0bfa367d29e6', '1eca98d6795c78acdad202fd9fce0f72d8067fad', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.434478', NULL, '2008-12-02 22:49:04.424977', '2008-12-02 22:49:04.435146', 15, true, true, true, 'Philip Bayliss St Albans Osteopathy', NULL, NULL, NULL, 95, '03 356 1353', '-');
INSERT INTO users VALUES (172, 'Phillipe', 'Campays', 'sol2@xtra.co.nz', '343634b00a08bc797ae867b01b483813b629c707', 'f181b5666dfae34621e8d3bfe49d3a3a7728f7f7', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.461843', NULL, '2008-12-02 22:49:04.453034', '2008-12-02 22:49:04.462886', 11, true, true, true, 'Sacred Design', NULL, NULL, NULL, 80, '04 380 1233', '021 501 502');
INSERT INTO users VALUES (173, 'Priya', 'Punjabi', 'priya@ayurvedic.co.nz', 'b60ebf713e201c62bc393dd00e73d7e1f3c5d180', '9d4526a9b360567e62ddfd5b0b3daa88bd342863', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.492338', NULL, '2008-12-02 22:49:04.48256', '2008-12-02 22:49:04.493765', 2, true, true, true, 'Ultimate Ayurveda Health Centre', '641 Sandringham Rd', 'Mt. Albert', NULL, 9, '09 829 2045', '021 253 0961');
INSERT INTO users VALUES (174, 'Rachael', 'Feather', 'rachael.feather@gmail.com', '887af0242d552a99aec4aa66425007da74567e69', '788c99c3eee2f3e712c4bd3fc0c5de6e7ad25f29', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.522596', NULL, '2008-12-02 22:49:04.511531', '2008-12-02 22:49:04.523323', 2, true, true, true, 'Rachael Feather', NULL, NULL, NULL, 9, '-', '021 067 4676');
INSERT INTO users VALUES (175, 'Rae', 'Torrie', 'rae.torrie@clear.net.nz', 'de6c77ee40efedb178b729d5dc04b0751925e7ab', '5aeba65e22fc1dfbbb5f0b65aff85c8c79e3b724', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.551052', NULL, '2008-12-02 22:49:04.541185', '2008-12-02 22:49:04.55175', 11, false, true, true, 'Rae Torrie', NULL, NULL, NULL, 80, '04 389 0488', '-');
INSERT INTO users VALUES (176, 'Rebecca ', 'Erlwein', 'rebecca@japaneseacupuncture.co.nz', 'ab1b8deff318799a4e3e6771f7599de5f8e807a7', '2398b34a4436d5cd3c54e9f338a247fd297f63e5', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.662093', NULL, '2008-12-02 22:49:04.652206', '2008-12-02 22:49:04.662832', 11, true, true, true, 'Japanese Acupuncture', '64 Hapua Street', 'Hataitai', NULL, 80, '04 938 1017', '-');
INSERT INTO users VALUES (177, 'Rekha', 'Patel', 'rekha@globe.net.nz ', 'a4119e11f1035fa85a09360e736b5a3c3d9a67ae', '3fe36f457a4c2a44fae8d099286257962d4ceeeb', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.687913', NULL, '2008-12-02 22:49:04.677466', '2008-12-02 22:49:04.68866', 11, false, true, true, 'Rekha Patel', NULL, NULL, NULL, 80, '04 385 3569', '-');
INSERT INTO users VALUES (178, 'Robin', 'Kerr', 'robin.kerr@zhengqi.co.nz', 'dcc5ebc2c4e1791b87e672f56412446bf9dcc25d', '750644e9be570c314c4cdedbd5765635b01bc047', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.717878', NULL, '2008-12-02 22:49:04.70685', '2008-12-02 22:49:04.718658', 15, true, true, true, 'Zheng Qi', '57 Morgans Valley', 'Lyttelton', NULL, 95, '03 328 8295', '027 2411748');
INSERT INTO users VALUES (179, 'Rose', 'Whyte', 'rose@backtobasics.co.nz', '37f97454ffb18e76694d07bf3fceae4afa39b146', '55f00e6a1215b7f35739e3db322bace0ddfc1334', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.748916', NULL, '2008-12-02 22:49:04.736165', '2008-12-02 22:49:04.749651', 2, true, true, true, 'Back to Basics', 'PO Box 5911 Wellesley Street', NULL, NULL, 9, '09 483 8580', '-');
INSERT INTO users VALUES (180, 'Rupert', 'Watson', 'rupert.watson@paradise.co.nz', 'aa8d76d9410c1111e5ee65e4e10496bddbe01d60', '17e5d32f34b02206e6f5a63a89d228a1a8355d5f', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.778981', NULL, '2008-12-02 22:49:04.76964', '2008-12-02 22:49:04.779679', 11, true, true, false, 'Ghuznee Health Associates', 'Level 2, The Terrace', NULL, NULL, 80, '04 801 6610', '-');
INSERT INTO users VALUES (181, 'Ruth', 'Donde', 'ruth@onecoach.co.nz', 'a233b8ec04b52d587a5d94880d370a0a74575196', '46050233f498cea011b24a315a0ba0c1b0eae391', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.806278', NULL, '2008-12-02 22:49:04.794554', '2008-12-02 22:49:04.80706', 2, true, true, false, 'One', '4/8 Kells Place, Highland Park', 'Howick', NULL, 14, '09 534 8744', '027 2745625');
INSERT INTO users VALUES (182, 'Ruth', 'van Dongen', 'ruth@watsu.co.nz', 'b664da65d60d1a02d5ddfd25ac716df3b641108c', 'ea798a2b7fb01fbddba2d6ea7f695bfbc810bd3f', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.836889', NULL, '2008-12-02 22:49:04.826558', '2008-12-02 22:49:04.837622', 2, true, true, true, 'Ruth van Dongen', 'PO Box95027', 'Torbay', NULL, 15, '09 473 0997', '-');
INSERT INTO users VALUES (183, 'Sally ', 'Anderson', 'sal.anderson@xtra.co.nz', 'b8e80f07f4ff79f335b1854eee969dc8c9d0a405', '24bf78d30855f4277cfbb4ccab408985216384a4', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.864124', NULL, '2008-12-02 22:49:04.853301', '2008-12-02 22:49:04.864875', 15, true, true, true, 'Sally Anderson Life Coach and Professional Mentor', NULL, NULL, NULL, 95, '-', '027 688 5551');
INSERT INTO users VALUES (184, 'Sally ', 'Goldsworthy', 'f.goldsworthy@clear.net.nz', 'b271ce29cb2db0f4ab0b66c085938f4ecddbdb11', '692c4f8755f8755b1d1aeecbd94830cc3353e8bc', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.891888', NULL, '2008-12-02 22:49:04.882449', '2008-12-02 22:49:04.892694', 15, true, true, true, 'Sally Goldsworthy - Kinesiologist', NULL, NULL, NULL, 95, '03 942 1193', '-');
INSERT INTO users VALUES (185, 'Sally', 'Barret', 'sally.barrett@paradise.net.nz', '8dd72afcaf56dfbcd768048075d07fa8df191198', '32f6a89146a2067a1ae2cce45c9956635f661e73', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.917398', NULL, '2008-12-02 22:49:04.907434', '2008-12-02 22:49:04.91811', 2, false, true, true, 'Sally Barret', NULL, NULL, NULL, 9, '09 415 7046', '-');
INSERT INTO users VALUES (186, 'Samantha ', 'Gadd', 'samantha@sweeten.co.nz', '3eca08744e74fd3ff9262bf171d02451df2b5d7b', '651bc3611117f8b23466fb17f6bba31842d09af4', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.948791', NULL, '2008-12-02 22:49:04.938503', '2008-12-02 22:49:04.949489', 11, true, true, true, 'Sweeten Ltd', '10 Caprera Street', 'Melrose', NULL, 80, '-', '021 999 269');
INSERT INTO users VALUES (187, 'Sarona', 'Hawkins', 'discoveryou@paradise.net.nz', '441d18e64eda5d5f264ffd810d157fa7be88c875', 'be53a90ace6178a8b99fba70f497f36e3942801b', NULL, NULL, 'active', NULL, '2008-12-02 22:49:04.973757', NULL, '2008-12-02 22:49:04.963877', '2008-12-02 22:49:04.974488', 11, false, true, true, 'Sarona Hawkins', NULL, NULL, NULL, 80, '04 234 8472', '-');
INSERT INTO users VALUES (188, 'Saskia', 'Clements', 'saskia@exceptionallife.co.nz', '34029bc70d2f062bdc675b25d3195e7b31f8e597', '2fb0b31ad24bb9b3558be9bebb74ed0e553c29d1', NULL, NULL, 'active', NULL, '2008-12-02 22:49:05.007048', NULL, '2008-12-02 22:49:04.992924', '2008-12-02 22:49:05.00786', 15, true, true, false, 'Exceptional Life', '26a Voelas Rd', 'Merivale', NULL, 95, '03 355 4276', '021 822 800');
INSERT INTO users VALUES (189, 'Shabina', 'Yakub', 'info@bodytonic@xtra.co.nz', 'ea2965ec84505f1ae600bf164978d81ef4a586af', 'f8c60c4678c4662185fe963442638b89106be9a3', NULL, NULL, 'active', NULL, '2008-12-02 22:49:05.313394', NULL, '2008-12-02 22:49:05.071461', '2008-12-02 22:49:05.31436', 11, true, true, true, 'Body Tonic', NULL, NULL, NULL, 80, '04 382 9980', '-');
INSERT INTO users VALUES (190, 'Shane', 'Anderson', 'shane@bodyspeacialist.co.nz', '4e1a16a1558a1dcea91aa7771c24d284131ae2b0', '0d750802ea721e9b49b21ff7ecfc0b7528a117cb', NULL, NULL, 'active', NULL, '2008-12-02 22:49:05.744458', NULL, '2008-12-02 22:49:05.32973', '2008-12-02 22:49:05.745346', 2, true, true, true, 'Bodyline Massage Specialists', '45 Arran Street', 'Blockhouse Bay', NULL, 9, '-', '021 277 7533');
INSERT INTO users VALUES (191, 'Shane', 'Reeves', 'shany@body-alive.com', '7afa139c81df96576cbe6872f19fe2f76a50c848', '20ae3d5939c41bfc5816b98c88af66acd4208ede', NULL, NULL, 'active', NULL, '2008-12-02 22:49:05.854704', NULL, '2008-12-02 22:49:05.76109', '2008-12-02 22:49:05.855422', 2, true, true, true, 'Body Alive', NULL, NULL, NULL, 9, '-', '021 132 4847');
INSERT INTO users VALUES (192, 'Sharon', 'Erdrich', 'sharon@houseofhealth.co.nz', '3095c2a10355cc4c5ce72b6c09b611a154812952', '225c342a958df3aac3bead60c13f0f8887fef62e', NULL, NULL, 'active', NULL, '2008-12-02 22:49:05.880741', NULL, '2008-12-02 22:49:05.871171', '2008-12-02 22:49:05.881456', 2, true, true, true, 'House of Health, Herne bay', 'Private Bag 78129, ', 'Herne Bay', NULL, 9, '09 360 0550', '027 239 3003');
INSERT INTO users VALUES (193, 'Sharon', 'Kearney', 'shaz.kev@xtra.co.nz', 'a5d9ac76d13fada904f773cc2d4ac3fc6df6a31b', '69ad96d01101cbde3bde2c5db7fbf11668d5ecc0', NULL, NULL, 'active', NULL, '2008-12-02 22:49:05.9069', NULL, '2008-12-02 22:49:05.896507', '2008-12-02 22:49:05.907652', 15, true, true, true, 'Papanui Physiotherapy Sports & Pilates Clinic', NULL, NULL, NULL, 95, '03 352 0395', '-');
INSERT INTO users VALUES (194, 'Sharyn', 'Haigh', 'sharyn.haigh@xtra.co.nz', '0deaa4d12ef6c536bd499e7cb9b2fcdf8a3f56f0', '6268bd73849c6976948bc896d9f80ab581018360', NULL, NULL, 'active', NULL, '2008-12-02 22:49:05.936114', NULL, '2008-12-02 22:49:05.925181', '2008-12-02 22:49:05.936899', 11, true, true, true, 'Sharyn Haigh', 'PO Box 22 316', 'Khandallah', NULL, 80, '04 4731940', '027 455 0949');
INSERT INTO users VALUES (195, 'Sherie', 'Bajon', 'healingdirect@paradise.net.nz', '34751d2afe665538baaf25c08b1b6833b6e1eff7', 'cbae02fb3ef60de7dfc8549d06ebda6d8161c979', NULL, NULL, 'active', NULL, '2008-12-02 22:49:05.963098', NULL, '2008-12-02 22:49:05.952928', '2008-12-02 22:49:05.963844', 15, true, true, true, 'Healing Direct', NULL, NULL, NULL, 95, '03 942 0144', '-');
INSERT INTO users VALUES (196, 'Simon', 'Elwell', 'simon@sacredspace.co.nz', 'c8656e1c34246b47145cb01704d68fa3d07a958c', '347c2c20d0c705b8a52cdcc63ebdf5a93f073793', NULL, NULL, 'active', NULL, '2008-12-02 22:49:05.990954', NULL, '2008-12-02 22:49:05.980121', '2008-12-02 22:49:05.991658', 11, true, true, true, 'Simon Elwell', '2/2 Caprera Street', NULL, NULL, 80, '-', '021 799 330');
INSERT INTO users VALUES (197, 'Simona', 'Fielder', 'simona@orcon.net.nz', '941ffe69dc2b3231a82e5d3cc55e6c8df17b3377', '84ea35358e270ddf0596b86f44d58712cf6befc6', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.016754', NULL, '2008-12-02 22:49:06.006961', '2008-12-02 22:49:06.017567', 2, true, true, true, 'Simona Fielder', 'PO Box 276 171', 'Mission Bay', NULL, 9, '-', '021 062 9972');
INSERT INTO users VALUES (198, 'Stephanie', 'Philps', 'steph@metamorphosis.co.nz', '56f74086c937f96af6e5c86e870cf43af3d031d5', 'c4871435b1d98ceca1875167606737733e7ea02f', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.046124', NULL, '2008-12-02 22:49:06.036162', '2008-12-02 22:49:06.046924', 2, true, true, true, 'Stephanie Philps', '48 Bellevue Road', 'Greenlane', NULL, 9, '09 636 3133', '-');
INSERT INTO users VALUES (199, 'Sue', 'Boleyn', 'tudor@ihug.co.nz', 'b9594991ba07403480c1b04abe9fe82dc126e3c2', '27c06ed9fd5cdeb77cad885f6438a53a9ca94ec8', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.091542', NULL, '2008-12-02 22:49:06.075364', '2008-12-02 22:49:06.092253', 15, true, true, true, 'Tudor Manor Massage & Beauty Therapy Clinic', NULL, NULL, NULL, 95, '03 338 8224', '-');
INSERT INTO users VALUES (200, 'Sue', 'Jones', 'info@suejones.co.nz', '722dfda9d0a56cb63a5877b6ca250f468b595b50', '9de45e783c5c5425d2c50a1f62c4d497e362f592', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.117873', NULL, '2008-12-02 22:49:06.107549', '2008-12-02 22:49:06.118641', 15, true, true, true, 'Sue Jones', 'Aylesbury, RD 1', NULL, NULL, 95, '03 318 1293', '027 614 8701');
INSERT INTO users VALUES (201, 'Susan', 'Finlay', 'finlaygroup@xtra.co.nz', '346c9446d7f1468e75f7e7788755d216e5553fba', 'fe6302095ce02f6ec4875010b99c343ca8a3f5c1', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.147099', NULL, '2008-12-02 22:49:06.13512', '2008-12-02 22:49:06.147853', 11, false, true, true, 'Susan Finlay', NULL, NULL, NULL, 80, '04 234 1463', '-');
INSERT INTO users VALUES (202, 'Susie', 'Herriott', 'susieherriott@yahoo.com', 'b008b1354a6c996b45f7c25c826d3964d6cc9988', 'd95b4d4162e3ac2218c690af1e88fd9d6a14b9bf', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.174079', NULL, '2008-12-02 22:49:06.164268', '2008-12-02 22:49:06.17484', 11, false, true, true, 'Susie Herriott', NULL, NULL, NULL, 80, '04 234 8495', '-');
INSERT INTO users VALUES (203, 'Tamara', 'Androsoff', 'healinglightnz@yahoo.co.nz', 'f2b0830ff39b72922ba59b37db3a3e34d479c7b1', '925b071ce47ea7ccdd808fceb18c6f3101d4b7fe', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.202521', NULL, '2008-12-02 22:49:06.19279', '2008-12-02 22:49:06.203591', 2, true, true, true, 'Tamara Androsoff', 'PO Box 11-939', 'Glen Eden', NULL, 18, '09 813 5361', '-');
INSERT INTO users VALUES (204, 'Tamara', 'Warrington', 'tamara_warrington@hotmail.com', 'f4c4639947726c91032055d09854c68450df5a31', 'cbbb8300e37334a61fb42369db7e8c5a382f5584', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.228044', NULL, '2008-12-02 22:49:06.219004', '2008-12-02 22:49:06.22892', 15, true, true, true, 'ESSENCE Therapeutic Body Replenishment', NULL, NULL, NULL, 95, '03 981 5452', '-');
INSERT INTO users VALUES (205, 'Tania', 'Laing', 'Laing@kiwiwebhost.sarcoma.net.nz', '7bedd2931a0469bd47dcbcb6ffbc2b300985f08e', 'b46d55d1144a5a833f14a2ce6e620e2d5966c390', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.260198', NULL, '2008-12-02 22:49:06.249416', '2008-12-02 22:49:06.260896', 2, true, true, true, 'Tania Laing Homeopathy', NULL, 'Ellerslie', NULL, 9, '09 579 3055', '027 688 9204');
INSERT INTO users VALUES (206, 'Tanya', 'Park', 'massagechi@gmail.com', '56fb25b725a8ab0a9d4cc92da0fe41ce856dbe1b', '6d7fa5616ac31e245dc3006565cfb0a865558114', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.284739', NULL, '2008-12-02 22:49:06.275697', '2008-12-02 22:49:06.285469', 2, true, true, true, 'Tanya Park', '578 Mt. Eden Road', 'Mt.Wellington', NULL, 9, '-', '-');
INSERT INTO users VALUES (207, 'Tejas', 'Ishaya', 'newzealand@ishaya.org', 'faf45edde1434e021df639dc87eaf892aac4878a', 'b9fd2fcca51c4553715703389fafb2c04ad5a5b8', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.401421', NULL, '2008-12-02 22:49:06.304725', '2008-12-02 22:49:06.402142', 2, true, true, true, 'The NZ Ishayas', 'PO Box 291', 'Saint Heliers', NULL, 9, '09 528 8315', '-');
INSERT INTO users VALUES (208, 'Tim', 'Girvan', 'timgirvan@gmail.com', 'ad61b431f83dbf7e6f3504da93f075ad4dd574ca', '6041273305b6564fa82b812111bdbe55b11c62be', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.426758', NULL, '2008-12-02 22:49:06.417343', '2008-12-02 22:49:06.427465', 2, true, true, false, 'Bellevue Health Centre', '779 New North Road', 'Mt. Eden', NULL, 9, '09 630 6331', '021 206 0487');
INSERT INTO users VALUES (209, 'Tim', 'Green', 'tim@pilatespersonal.co.nz', '74a1a2b12f5d112513bfaf1d92f7b909b4d02f1e', '2c030aa978e30c1d2754b5ad175d4f8f69a7b4eb', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.453678', NULL, '2008-12-02 22:49:06.443038', '2008-12-02 22:49:06.454446', 15, true, true, true, 'Pilates Personal Fitness Studio', NULL, NULL, NULL, 95, '03 377 4649', '-');
INSERT INTO users VALUES (210, 'Toni ', 'Kenyon', 'heartofhealth@clear.net.nz', '32a0150bc7e05a0b2f340a68819a1a17edc8f19e', '6cf5dfc3d0f79f1cb5e72c3a2d189761e3c723c4', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.48554', NULL, '2008-12-02 22:49:06.475632', '2008-12-02 22:49:06.486255', 2, true, true, true, 'Toni  Kenyon', NULL, NULL, NULL, 9, '09 4432788', '-');
INSERT INTO users VALUES (211, 'Toni ', 'Stewart', 'toni@flourishcoaching.co.nz', 'e3fb09f1f937926ec88c499e830899e62d83e215', '7e6125bd14837c9be52686661ef47fdd61663fb4', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.511983', NULL, '2008-12-02 22:49:06.501708', '2008-12-02 22:49:06.512723', 15, true, true, true, 'Flourish Coaching', NULL, 'Merivale', NULL, 95, '03 356 1188', '021 102 5578');
INSERT INTO users VALUES (212, 'Tracy ', 'Keith', 'tracy@tmkconsulting.co.nz', '479233e5057dc0eff4e94e4fc699e8d0d58ce979', 'c370892555309f2f539a4ebd15e71825933969e9', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.542622', NULL, '2008-12-02 22:49:06.53009', '2008-12-02 22:49:06.54335', 11, true, true, false, 'tmkconsulting', NULL, NULL, NULL, 80, '04 479 7327', '021 044 5454');
INSERT INTO users VALUES (213, 'Tralee', 'Clark', 'absolute-massage@xtra.co.nz', '9ed5092edd5831d071449a92b9e0219a88888bd4', 'ae0c252c06e32eb302942ce4ec35ffdb39df15d9', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.574347', NULL, '2008-12-02 22:49:06.56135', '2008-12-02 22:49:06.575077', 11, true, true, true, 'Absolute Massage', NULL, NULL, NULL, 80, '04 801 8284', '-');
INSERT INTO users VALUES (214, 'Trina', 'Burt', 'trina-burt@free.net.nz', 'fcf362b9d2340118a767f42733ddea37202d41ec', '431bd50e61ef8b377671f0ff07dc984d20830605', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.604055', NULL, '2008-12-02 22:49:06.591848', '2008-12-02 22:49:06.604794', 15, true, true, true, 'Trina Burt', NULL, NULL, NULL, 95, '-', '-');
INSERT INTO users VALUES (215, 'Trish', 'Pattison', 'Trish@freelivingbydesign.com', 'c0aa797bce3a4ea52d3587bd310c0a6831349ff9', 'b090c1e64e7664d7dc03abce30babaa5c466f7f3', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.630297', NULL, '2008-12-02 22:49:06.621106', '2008-12-02 22:49:06.631016', 11, false, true, true, 'Trish Pattison', NULL, NULL, NULL, 80, '04 389 6609', '-');
INSERT INTO users VALUES (216, 'Tui ', 'Parker', 'tuivolve@yahoo.com', 'bf6e1f069e398c8a0a95b956f8adbdad1e51c1fb', '9feee4403d7781e820cd16f06d875ed8d4e2ae0a', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.660024', NULL, '2008-12-02 22:49:06.647535', '2008-12-02 22:49:06.660796', 11, true, true, true, 'Ora Natural Therapies', NULL, NULL, NULL, 80, '04 499 9979', '021 238 0061');
INSERT INTO users VALUES (217, 'Valee', 'More', 'oasisclinic@slingshot.co.nz', '6dabb175c2f70d3d62ec12c2bcd223ed68749419', '51ee6cc038e06474ce030db2b2086084d676e86a', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.687703', NULL, '2008-12-02 22:49:06.678444', '2008-12-02 22:49:06.68838', 2, false, true, true, 'The Oasis Clinic', '12 Cooper Street', 'Massey', NULL, 9, '09 8329273', '-');
INSERT INTO users VALUES (218, 'Vanessa', 'Lukes', 'vanessalukes@chigong.co.nz', 'afbf00680b207527f88738a5410d2edb8eefab42', 'dfd840f7ac2a5499ebc6a0b922de4319af2ff517', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.717529', NULL, '2008-12-02 22:49:06.707843', '2008-12-02 22:49:06.718391', 15, true, true, true, 'Chigong Christchurch', 'Upstairs Merivale Mall', 'Opawa', NULL, 95, '03 981 7580', '-');
INSERT INTO users VALUES (219, 'Waveney', 'Reta', 'waveneyr@globe.net.nz', '56f29cd41edb9b73dd4c1717cc86a7480a8a19c6', 'fb99f01fa7d965e713644b91f70befea52bfa41d', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.746361', NULL, '2008-12-02 22:49:06.736422', '2008-12-02 22:49:06.74708', 11, true, true, true, 'Waveney Reta Therapies', '2nd Floor, 53 Courtney Place', NULL, NULL, 80, '04  385 4342', '021 384 308');
INSERT INTO users VALUES (220, 'Wenchaun', 'Huang', 'hwenchuan@sina.com.cn', '086336144059fbf940a549e73151479c308a430d', '9874b4a5e6e46da15ca47724f705df974807cead', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.775901', NULL, '2008-12-02 22:49:06.764032', '2008-12-02 22:49:06.776669', 2, true, true, true, 'Dr Win Acupuncture Clinic', NULL, 'Newmarket', NULL, 9, '09 5296185', '021 1793736');
INSERT INTO users VALUES (221, 'Wendy', 'Rushworth', 'wotzarushworth@yahoo.com', '2918e970e12d3634e05c26f0f52afa1baf26a784', '1c6a05e5521e1100cf5f8e03b5f4682e7644eda6', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.802823', NULL, '2008-12-02 22:49:06.793511', '2008-12-02 22:49:06.803502', 15, true, true, true, 'Balance Massage Therapy', NULL, NULL, NULL, 95, '03 337 3237', '-');
INSERT INTO users VALUES (222, 'Xanthe', 'Ashton', 'xanthe@reflexology.co.nz', 'f83bc5e7d06fedea257c4575bd52557bae2bdfbb', '74f4de0f0c0c75f27b45e799dfcdfd0102863caa', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.830242', NULL, '2008-12-02 22:49:06.820221', '2008-12-02 22:49:06.830915', 15, true, true, true, 'Xanthe Ashton', '100 Highstead Road', 'Halswell', NULL, 95, '03 322 4858', '-');
INSERT INTO users VALUES (223, 'Yumi', 'Sato', 'yumis@xtra.co.nz', 'ee66d447d2095ecccf1ef0efd6ad6cc2472ea278', 'ca6a6d66bf30b4175aafcafaf2795b7e74b7723d', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.943612', NULL, '2008-12-02 22:49:06.932885', '2008-12-02 22:49:06.94435', 15, true, true, true, 'Yumi Sato', NULL, NULL, NULL, 95, '03 331 7356', '-');
INSERT INTO users VALUES (224, 'Yvette', 'Blades', 'ybb@actrix.co.nz', '0f818ee36b963d7376c3da9833d28cf9770e159e', '7f338f8b9be4994399ef27461871995fb120e4e0', NULL, NULL, 'active', NULL, '2008-12-02 22:49:06.970435', NULL, '2008-12-02 22:49:06.959649', '2008-12-02 22:49:06.9712', 11, false, true, true, 'Yvette Blades', NULL, NULL, NULL, 80, '04 589 1652', '-');
INSERT INTO users VALUES (225, 'Yvonne', 'Louwers', 'ybml@xtra.co.nz', 'b7fd8a0965053be764f6ec884d491c9335d179e1', '7f066a5be9df2d736606256f53cef9d06eaa5eab', NULL, NULL, 'active', NULL, '2008-12-02 22:49:07.002625', NULL, '2008-12-02 22:49:06.990418', '2008-12-02 22:49:07.003468', 11, true, true, false, 'Yvonne Louwers', NULL, NULL, NULL, 80, '04 232 3979', '021 127 3120');
INSERT INTO users VALUES (226, NULL, NULL, 'sav@elevatecoaching.co.nz', '1dcf33a10cebb5d59cce4e01b2fbcf70c401fc55', 'a192ecd01fed2b312560858741cce78a0285b767', NULL, NULL, 'active', NULL, '2008-12-02 22:49:07.063839', NULL, '2008-12-02 22:49:07.037767', '2008-12-02 22:49:07.064847', NULL, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '-', '-');
INSERT INTO users VALUES (227, 'Cyrille', 'Bonnet', 'cbonnet99@gmail.com', '18c0aa93aba6574d2f367411f968b24e4a38d612', 'a2d150337ee54fb79a4f318cdff72d94a4cb1bd9', NULL, NULL, 'active', NULL, '2008-12-02 22:49:07.094881', NULL, '2008-12-02 22:49:07.084254', '2008-12-02 22:49:07.096507', NULL, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '-', '-');
INSERT INTO users VALUES (228, NULL, NULL, 'megan@beamazing.co.nz', '611c75332b6c9d7232ee57827a6feda345f25635', '339c65e44f6f81ed44e345924b642da721329cf3', NULL, NULL, 'active', NULL, '2008-12-02 22:49:07.120517', NULL, '2008-12-02 22:49:07.10974', '2008-12-02 22:49:07.121623', NULL, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '-', '-');
INSERT INTO users VALUES (229, NULL, NULL, 'julie@thatblindwoman.co.nz', '94def95c8747a772c718dcd41e40a56955659640', '508a2d26be67d0ffd17543437c4b0cf06dcb8fa6', NULL, NULL, 'active', NULL, '2008-12-02 22:49:07.145816', NULL, '2008-12-02 22:49:07.135926', '2008-12-02 22:49:07.146819', NULL, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '-', '-');


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
-- Name: payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


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
-- Name: user_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_events
    ADD CONSTRAINT user_events_pkey PRIMARY KEY (id);


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

