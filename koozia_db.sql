--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)

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
-- Name: aliments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aliments (
    id integer NOT NULL,
    name text NOT NULL,
    category_id integer,
    mois_dispo text NOT NULL,
    kcal_per_100g numeric NOT NULL
);


ALTER TABLE public.aliments OWNER TO postgres;

--
-- Name: aliments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.aliments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.aliments_id_seq OWNER TO postgres;

--
-- Name: aliments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.aliments_id_seq OWNED BY public.aliments.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: recette_ingredients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recette_ingredients (
    id integer NOT NULL,
    recette_id integer,
    aliment_id integer,
    quantite_grammes numeric NOT NULL,
    unite text DEFAULT 'g'::text
);


ALTER TABLE public.recette_ingredients OWNER TO postgres;

--
-- Name: recettes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recettes (
    id integer NOT NULL,
    name text NOT NULL,
    pays text NOT NULL,
    description text,
    date_creation timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.recettes OWNER TO postgres;

--
-- Name: recette_calories; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.recette_calories AS
 SELECT r.id AS recette_id,
    r.name AS recette_name,
    r.pays,
    r.description,
    sum(((ri.quantite_grammes * a.kcal_per_100g) / (100)::numeric)) AS kcal_totale
   FROM ((public.recettes r
     JOIN public.recette_ingredients ri ON ((r.id = ri.recette_id)))
     JOIN public.aliments a ON ((ri.aliment_id = a.id)))
  GROUP BY r.id, r.name, r.pays, r.description;


ALTER VIEW public.recette_calories OWNER TO postgres;

--
-- Name: recette_ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recette_ingredients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recette_ingredients_id_seq OWNER TO postgres;

--
-- Name: recette_ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recette_ingredients_id_seq OWNED BY public.recette_ingredients.id;


--
-- Name: recettes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recettes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recettes_id_seq OWNER TO postgres;

--
-- Name: recettes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recettes_id_seq OWNED BY public.recettes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    prenom character varying(100),
    email character varying(150) NOT NULL,
    password character varying(255) NOT NULL,
    date_creation timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    type_foyer character varying(10) DEFAULT 'solo'::character varying,
    nb_personnes smallint,
    allergies text,
    intolerances text,
    tabous text,
    CONSTRAINT check_nb_personnes CHECK (((((type_foyer)::text = 'famille'::text) AND (nb_personnes IS NOT NULL)) OR (((type_foyer)::text = 'solo'::text) AND (nb_personnes IS NULL)))),
    CONSTRAINT users_nb_personnes_check CHECK ((nb_personnes >= 1)),
    CONSTRAINT users_type_foyer_check CHECK (((type_foyer)::text = ANY ((ARRAY['solo'::character varying, 'famille'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: aliments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aliments ALTER COLUMN id SET DEFAULT nextval('public.aliments_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: recette_ingredients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recette_ingredients ALTER COLUMN id SET DEFAULT nextval('public.recette_ingredients_id_seq'::regclass);


--
-- Name: recettes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recettes ALTER COLUMN id SET DEFAULT nextval('public.recettes_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: aliments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aliments (id, name, category_id, mois_dispo, kcal_per_100g) FROM stdin;
1	Mangue	1	Decembre – Mars	60
2	Orange	1	Juin – Septembre	47
3	Papaye	1	Janvier – Mars	43
4	Ananas	1	Janvier – Decembre	50
5	Banane	1	Janvier – Decembre	89
6	Litchi	1	Mai – Aout	66
7	Goyave	1	Mai – Septembre	68
8	Avocat	1	Toute l'annee	160
9	Pomme	1	Juillet – Septembre	52
10	Citron	1	Avril – Septembre	29
11	Carotte	2	Janvier – Decembre	41
12	Chou	2	Janvier – Decembre	25
13	Epinard	2	Janvier – Decembre	23
14	Haricot vert	2	Novembre – Avril	127
15	Oignon	2	Janvier – Decembre	40
16	Tomate	2	Mai – Octobre	18
17	Concombre	2	Mai – Octobre	16
18	Poivron	2	Mai – Octobre	26
19	Aubergine	2	Mai – Octobre	25
20	Courgette	2	Novembre – Avril	17
21	Poulet	3	Toute l'annee	239
22	Boeuf	3	Toute l'annee	250
23	Porc	3	Toute l'annee	242
24	Agneau	3	Toute l'annee	294
25	Dinde	3	Toute l'annee	189
26	Tilapia	4	Toute l'annee	128
27	Saumon	4	Toute l'annee	208
28	Thon	4	Toute l'annee	144
29	Sardine	4	Toute l'annee	208
30	Crevette	4	Toute l'annee	99
31	Riz blanc	5	Toute l'annee	130
32	Ble	5	Toute l'annee	340
33	Mais	5	Mai – Decembre	365
34	Pommes de terre	5	Janvier – Decembre	77
35	Pates	5	Toute l'annee	131
36	Lait entier	6	Toute l'annee	60
37	Fromage	6	Toute l'annee	402
38	Yaourt	6	Toute l'annee	59
39	Beurre	6	Toute l'annee	717
40	Haricot sec	7	Toute l'annee	127
41	Lentille	7	Toute l'annee	116
42	Pois chiche	7	Toute l'annee	164
43	Feve	7	Toute l'annee	88
44	Huile d'olive	8	Toute l'annee	884
45	Sucre	8	Toute l'annee	387
46	Chocolat	8	Toute l'annee	546
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, name) FROM stdin;
1	Fruits
2	Légumes
3	Viandes
4	Poissons
5	Céréales & Féculents
6	Produits laitiers
7	Légumineuses
8	Autres
\.


--
-- Data for Name: recette_ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recette_ingredients (id, recette_id, aliment_id, quantite_grammes, unite) FROM stdin;
1	1	22	200	g
2	1	13	100	g
3	1	15	30	g
4	2	23	150	g
5	2	43	80	g
6	3	32	100	g
7	3	45	50	g
8	3	46	30	g
9	4	32	100	g
10	4	36	50	g
11	4	45	30	g
12	5	16	150	g
13	5	11	50	g
14	5	15	20	g
15	6	\N	100	g
16	6	36	50	g
17	6	22	80	g
18	7	16	150	g
19	7	18	50	g
20	7	19	50	g
21	8	22	200	g
22	8	11	50	g
23	8	15	30	g
24	9	39	50	g
25	9	32	100	g
26	9	36	50	g
27	10	15	150	g
28	10	39	20	g
29	11	35	100	g
30	11	\N	50	g
31	11	37	30	g
32	12	32	150	g
33	12	16	80	g
34	12	37	50	g
35	16	22	150	g
36	16	32	100	g
37	16	16	30	g
38	16	15	20	g
39	21	32	100	g
40	21	22	100	g
41	21	16	30	g
42	21	15	20	g
43	22	8	150	g
44	22	15	50	g
45	22	10	20	g
46	1	22	200	g
47	1	13	100	g
48	1	15	30	g
49	2	23	150	g
50	2	43	80	g
51	3	32	100	g
52	3	45	50	g
53	3	46	30	g
54	4	32	100	g
55	4	36	50	g
56	4	45	30	g
57	5	16	150	g
58	5	11	50	g
59	5	15	20	g
60	6	\N	100	g
61	6	36	50	g
62	6	22	80	g
63	7	16	150	g
64	7	18	50	g
65	7	19	50	g
66	8	22	200	g
67	8	11	50	g
68	8	15	30	g
69	9	39	50	g
70	9	32	100	g
71	9	36	50	g
72	10	15	150	g
73	10	39	20	g
74	1	22	200	g
75	1	13	100	g
76	1	15	30	g
77	2	23	150	g
78	2	43	80	g
79	3	32	100	g
80	3	45	50	g
81	3	46	30	g
82	4	32	100	g
83	4	36	50	g
84	4	45	30	g
85	5	16	150	g
86	5	11	50	g
87	5	15	20	g
88	6	\N	100	g
89	6	36	50	g
90	6	22	80	g
91	7	16	150	g
92	7	18	50	g
93	7	19	50	g
94	8	22	200	g
95	8	11	50	g
96	8	15	30	g
97	9	39	50	g
98	9	32	100	g
99	9	36	50	g
100	10	15	150	g
101	10	39	20	g
\.


--
-- Data for Name: recettes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recettes (id, name, pays, description, date_creation) FROM stdin;
1	Romazava	Madagascar	Plat à base de viande et brèdes	2025-09-06 18:47:27.406108
2	Ravitoto	Madagascar	Feuilles de manioc pilées avec porc	2025-09-06 18:47:27.406108
3	Koba	Madagascar	Dessert à base de riz et cacahuète	2025-09-06 18:47:27.406108
4	Mofo gasy	Madagascar	Pancake malgache pour le petit déjeuner	2025-09-06 18:47:27.406108
5	Lasary Voatabia	Madagascar	Salade de tomates et légumes	2025-09-06 18:47:27.406108
6	Quiche Lorraine	France	Tarte salée aux œufs, crème et lardons	2025-09-06 18:47:27.427859
7	Ratatouille	France	Légumes mijotés provençaux	2025-09-06 18:47:27.427859
8	Boeuf Bourguignon	France	Viande mijotée au vin rouge	2025-09-06 18:47:27.427859
9	Croissant	France	Viennoiserie au beurre	2025-09-06 18:47:27.427859
10	Soupe à l'oignon	France	Soupe à base d'oignon gratinée	2025-09-06 18:47:27.427859
11	Spaghetti Carbonara	Italie	Pâtes avec œufs, fromage et lardons	2025-09-06 18:47:27.44133
12	Pizza Margherita	Italie	Pizza avec tomate, mozzarella et basilic	2025-09-06 18:47:27.44133
13	Lasagne	Italie	Pâtes en couches avec viande et fromage	2025-09-06 18:47:27.44133
14	Risotto	Italie	Riz crémeux avec légumes et fromage	2025-09-06 18:47:27.44133
15	Tiramisu	Italie	Dessert à base de mascarpone et biscuits	2025-09-06 18:47:27.44133
16	Burger	USA	Sandwich avec viande, légumes et pain	2025-09-06 18:47:27.449201
17	Mac & Cheese	USA	Pâtes au fromage	2025-09-06 18:47:27.449201
18	BBQ Ribs	USA	Côtes de porc grillées sauce barbecue	2025-09-06 18:47:27.449201
19	Pancakes	USA	Pâtisserie pour petit-déjeuner	2025-09-06 18:47:27.449201
20	Apple Pie	USA	Tarte aux pommes	2025-09-06 18:47:27.449201
21	Tacos	Mexique	Tortilla garnie de viande et légumes	2025-09-06 18:47:27.453214
22	Guacamole	Mexique	Purée d'avocat avec oignon et citron	2025-09-06 18:47:27.453214
23	Enchiladas	Mexique	Tortilla roulée avec sauce et viande	2025-09-06 18:47:27.453214
24	Quesadillas	Mexique	Tortilla avec fromage fondu	2025-09-06 18:47:27.453214
25	Chiles Rellenos	Mexique	Piments farcis au fromage ou viande	2025-09-06 18:47:27.453214
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, nom, prenom, email, password, date_creation, type_foyer, nb_personnes, allergies, intolerances, tabous) FROM stdin;
\.


--
-- Name: aliments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.aliments_id_seq', 46, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_id_seq', 8, true);


--
-- Name: recette_ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recette_ingredients_id_seq', 101, true);


--
-- Name: recettes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recettes_id_seq', 25, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: aliments aliments_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aliments
    ADD CONSTRAINT aliments_name_key UNIQUE (name);


--
-- Name: aliments aliments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aliments
    ADD CONSTRAINT aliments_pkey PRIMARY KEY (id);


--
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: recette_ingredients recette_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recette_ingredients
    ADD CONSTRAINT recette_ingredients_pkey PRIMARY KEY (id);


--
-- Name: recettes recettes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recettes
    ADD CONSTRAINT recettes_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: aliments aliments_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aliments
    ADD CONSTRAINT aliments_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- Name: recette_ingredients recette_ingredients_aliment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recette_ingredients
    ADD CONSTRAINT recette_ingredients_aliment_id_fkey FOREIGN KEY (aliment_id) REFERENCES public.aliments(id) ON DELETE CASCADE;


--
-- Name: recette_ingredients recette_ingredients_recette_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recette_ingredients
    ADD CONSTRAINT recette_ingredients_recette_id_fkey FOREIGN KEY (recette_id) REFERENCES public.recettes(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

