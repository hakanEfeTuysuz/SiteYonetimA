--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2024-12-23 16:39:10

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
-- TOC entry 247 (class 1255 OID 16433)
-- Name: aidat_hesapla(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.aidat_hesapla(p_daire_id integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_metrekare NUMERIC;
    v_katnumarasi INTEGER; 
    v_aidat NUMERIC;
BEGIN
    SELECT d.metrekare, d.katnumarasi 
    INTO v_metrekare, v_katnumarasi
    FROM Daire d
    JOIN Apartman a ON d.apartman_id = a.apartman_id 
    WHERE d.daire_id = p_daire_id; 

    -- Handle cases where daire_id or katnumarasi is not found
    IF v_metrekare IS NULL OR v_katnumarasi IS NULL THEN
        RAISE EXCEPTION 'Daire not found or katnumarasi not available.';
    END IF;

    v_aidat := v_metrekare * 5; 
    IF v_katnumarasi > 0 THEN
        v_aidat := v_aidat + (v_katnumarasi * 10); 
    END IF;

    RETURN v_aidat;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'An error occurred during aidat_hesapla: %', SQLERRM;
        RETURN NULL; 
END;
$$;


ALTER FUNCTION public.aidat_hesapla(p_daire_id integer) OWNER TO postgres;

--
-- TOC entry 248 (class 1255 OID 16434)
-- Name: apartman_ekle(integer, integer, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.apartman_ekle(p_binaid integer, p_katsayisi integer, p_dairesayisi integer, p_asansorsayisi integer, p_yonetici character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Input Validation (Optional, but recommended)
    IF p_katsayisi < 0 THEN
        RAISE EXCEPTION 'Katsayisi negatif olamaz.';
    END IF;

    IF p_dairesayisi < 0 THEN
        RAISE EXCEPTION 'Daire sayisi negatif olamaz.';
    END IF;

    IF p_asansorsayisi < 0 THEN
        RAISE EXCEPTION 'Asansör sayisi negatif olamaz.';
    END IF;

    INSERT INTO public.apartman (binaid, katsayisi, dairesayisi, asansorsayisi, yonetici)
    VALUES (p_binaid, p_katsayisi, p_dairesayisi, p_asansorsayisi, p_yonetici);

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Bina bulunamadı.';
    WHEN OTHERS THEN
        RAISE NOTICE 'An error occurred during apartman_ekle: %', SQLERRM;
END;
$$;


ALTER FUNCTION public.apartman_ekle(p_binaid integer, p_katsayisi integer, p_dairesayisi integer, p_asansorsayisi integer, p_yonetici character varying) OWNER TO postgres;

--
-- TOC entry 249 (class 1255 OID 16435)
-- Name: bina_ekle(text, date, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.bina_ekle(p_adres text, p_insaat_tarihi date, p_yapim_firmasi character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_yapi_id integer; 
BEGIN
    -- Validate insaat_tarihi 
    IF p_insaat_tarihi > CURRENT_DATE THEN
        RAISE EXCEPTION 'Insaat tarihi gelecek bir tarih olamaz.'; 
    END IF;

    INSERT INTO public.yapi (adres, insaat_tarihi, yapim_firmasi)
    VALUES (p_adres, p_insaat_tarihi, p_yapim_firmasi)
    RETURNING yapi_id INTO v_yapi_id; 

    -- Ensure that a row was actually inserted
    IF NOT FOUND THEN
        RAISE NOTICE 'Bina ekleme işlemi başarısız oldu.';
        RETURN NULL;
    END IF;

    RETURN v_yapi_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'An error occurred during bina_ekle: %', SQLERRM;
        RETURN NULL; 
END;
$$;


ALTER FUNCTION public.bina_ekle(p_adres text, p_insaat_tarihi date, p_yapim_firmasi character varying) OWNER TO postgres;

--
-- TOC entry 250 (class 1255 OID 16436)
-- Name: check_calisan_in_calisanyapi(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_calisan_in_calisanyapi() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM public.calisanyapi WHERE kisiid = OLD.kisiid) THEN
        RAISE EXCEPTION 'Çalışan, calisanyapi tablosunda kullanıldığı için silinemez.';
    END IF;
    RETURN OLD; 
END;
$$;


ALTER FUNCTION public.check_calisan_in_calisanyapi() OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 16437)
-- Name: daire_ekle(integer, character varying, integer, integer, numeric, character varying, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.daire_ekle(p_apartmanid integer, p_daireno character varying, p_odasayisi integer, p_salonsayisi integer, p_metrekare numeric, p_dairetipi character varying, p_katnumarasi smallint) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Input Validation (Optional, but recommended)
    IF p_odasayisi < 0 THEN
        RAISE EXCEPTION 'Oda sayisi negatif olamaz.';
    END IF;

    IF p_salonsayisi < 0 THEN
        RAISE EXCEPTION 'Salon sayisi negatif olamaz.';
    END IF;

    IF p_metrekare <= 0 THEN
        RAISE EXCEPTION 'Metrekare sifirdan kucuk veya esit olamaz.';
    END IF;

    INSERT INTO public.daire (apartmanid, daireno, odasayisi, salonsayisi, metrekare, dairetipi, katnumarasi)
    VALUES (p_apartmanid, p_daireno, p_odasayisi, p_salonsayisi, p_metrekare, p_dairetipi, p_katnumarasi);

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Apartman bulunamadı.';
    WHEN OTHERS THEN
        RAISE NOTICE 'An error occurred during daire_ekle: %', SQLERRM;
END;
$$;


ALTER FUNCTION public.daire_ekle(p_apartmanid integer, p_daireno character varying, p_odasayisi integer, p_salonsayisi integer, p_metrekare numeric, p_dairetipi character varying, p_katnumarasi smallint) OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 16438)
-- Name: delete_unused_calisan(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_unused_calisan() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if there are no more entries for this calisan in calisanyapi
    IF NOT EXISTS (SELECT 1 FROM public.calisanyapi WHERE kisiid = OLD.kisiid) THEN
        DELETE FROM public.calisan WHERE kisiid = OLD.kisiid;
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.delete_unused_calisan() OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 16439)
-- Name: kisi_ekle(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.kisi_ekle(p_tckimlikno character varying, p_ad character varying, p_soyad character varying, p_telefon character varying, p_email character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_kisi_id integer; 
BEGIN
    INSERT INTO public.kisi (tckimlikno, ad, soyad, telefon, email)
    VALUES (p_tckimlikno, p_ad, p_soyad, p_telefon, p_email); 

    -- Retrieve the inserted kisi_id using SELECT lastval()
    SELECT lastval() INTO v_kisi_id; 

    RETURN v_kisi_id;

EXCEPTION
    WHEN unique_violation THEN 
        RAISE NOTICE 'A person with this TCKN already exists.';
        RETURN NULL; 
    WHEN OTHERS THEN
        RAISE NOTICE 'An error occurred during kisi_ekle: %', SQLERRM;
        RETURN NULL; 
END;
$$;


ALTER FUNCTION public.kisi_ekle(p_tckimlikno character varying, p_ad character varying, p_soyad character varying, p_telefon character varying, p_email character varying) OWNER TO postgres;

--
-- TOC entry 246 (class 1255 OID 16740)
-- Name: kontrol_bina_turu(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.kontrol_bina_turu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Park
        WHERE binaid = NEW.binaid
    ) OR EXISTS (
        SELECT 1
        FROM Apartman
        WHERE binaid = NEW.binaid
    ) OR EXISTS (
        SELECT 1
        FROM Otopark
        WHERE binaid = NEW.binaid
    ) THEN
        RAISE EXCEPTION 'Bu bina zaten başka bir tür olarak tanımlandı!';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.kontrol_bina_turu() OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 16440)
-- Name: kontrol_giris(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.kontrol_giris() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Kontrol 1: Giriş yapan kişinin kisiid'sinin kisi tablosunda bulunup bulunmadığını kontrol et
    IF NEW.kisiid IS NOT NULL THEN 
        RETURN NEW; -- Eğer kisiid varsa, giriş izni verilir
    END IF;

    -- Kontrol 2: Misafir girişi için gorecegiKisiid'nin kisi tablosunda bulunup bulunmadığını kontrol et
    IF NEW.misafirMi IS TRUE AND EXISTS (SELECT 1 FROM public.kisi WHERE kisiid = NEW.gorecegiKisiid) THEN
        RETURN NEW; -- Eğer misafirMi true ve gorecegiKisiid geçerliyse, giriş izni verilir
    END IF;

    -- Eğer hiçbir kontrol geçerli değilse, giriş engellenir
    RAISE EXCEPTION 'Giriş izni reddedildi.';

END;
$$;


ALTER FUNCTION public.kontrol_giris() OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 16441)
-- Name: otoparkdolumu(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.otoparkdolumu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    v_doluluk integer;
BEGiN
    select count(*) into v_doluluk from public.arac where otoparkid = new.otoparkid;
    
    if v_doluluk >= (select kapasite from public.otopark where otoparkid = new.otoparkid) then
        raise exception 'otopark dolu. Yeni araç ne yazık ki eklenemez.';
    end if;
    return new;
END;
$$;


ALTER FUNCTION public.otoparkdolumu() OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 16442)
-- Name: validate_plaka(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validate_plaka() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_plaka_pattern text := '[0-9]{2}[A-Z]{2}[0-9]{2}';
BEGIN
    IF NOT NEW.plaka ~ v_plaka_pattern THEN
        RAISE EXCEPTION 'Plaka formatı geçersiz. Geçerli format: 00AA00'; 
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validate_plaka() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 16443)
-- Name: adaylikbasvuru; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adaylikbasvuru (
    basvuruid integer NOT NULL,
    evsahibiid integer,
    basvurutarihi date
);


ALTER TABLE public.adaylikbasvuru OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16446)
-- Name: adaylikbasvuru_basvuruid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.adaylikbasvuru_basvuruid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.adaylikbasvuru_basvuruid_seq OWNER TO postgres;

--
-- TOC entry 5000 (class 0 OID 0)
-- Dependencies: 218
-- Name: adaylikbasvuru_basvuruid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.adaylikbasvuru_basvuruid_seq OWNED BY public.adaylikbasvuru.basvuruid;


--
-- TOC entry 219 (class 1259 OID 16447)
-- Name: apartman; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.apartman (
    binaid integer NOT NULL,
    katsayisi integer,
    dairesayisi integer,
    asansorsayisi integer,
    yoneticiid integer NOT NULL
);


ALTER TABLE public.apartman OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16450)
-- Name: arac; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.arac (
    aracid integer NOT NULL,
    sahipid integer,
    plaka character varying(6) NOT NULL,
    marka character varying NOT NULL,
    model character varying,
    otoparkid integer
);


ALTER TABLE public.arac OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16455)
-- Name: arac_aracid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.arac_aracid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.arac_aracid_seq OWNER TO postgres;

--
-- TOC entry 5001 (class 0 OID 0)
-- Dependencies: 221
-- Name: arac_aracid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.arac_aracid_seq OWNED BY public.arac.aracid;


--
-- TOC entry 222 (class 1259 OID 16456)
-- Name: bina; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bina (
    binaid integer NOT NULL,
    binaadi character varying(100),
    adres character varying(200),
    alan numeric NOT NULL
);


ALTER TABLE public.bina OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16461)
-- Name: bina_binaid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bina_binaid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bina_binaid_seq OWNER TO postgres;

--
-- TOC entry 5002 (class 0 OID 0)
-- Dependencies: 223
-- Name: bina_binaid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bina_binaid_seq OWNED BY public.bina.binaid;


--
-- TOC entry 224 (class 1259 OID 16462)
-- Name: calisan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.calisan (
    kisiid integer NOT NULL,
    gorev character varying(50),
    deneyim smallint,
    maas integer NOT NULL
);


ALTER TABLE public.calisan OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16465)
-- Name: calisanyapi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.calisanyapi (
    kisiid integer NOT NULL,
    binaid integer NOT NULL,
    isbaslangic date
);


ALTER TABLE public.calisanyapi OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16468)
-- Name: daire; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.daire (
    daireid integer NOT NULL,
    apartmanid integer,
    daireno character varying(10),
    odasayisi integer,
    salonsayisi integer,
    metrekare numeric,
    dairetipi character varying(50),
    katnumarasi smallint,
    sahipid integer
);


ALTER TABLE public.daire OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16473)
-- Name: daire_daireid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.daire_daireid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.daire_daireid_seq OWNER TO postgres;

--
-- TOC entry 5003 (class 0 OID 0)
-- Dependencies: 227
-- Name: daire_daireid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.daire_daireid_seq OWNED BY public.daire.daireid;


--
-- TOC entry 228 (class 1259 OID 16474)
-- Name: evsahibi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evsahibi (
    kisiid integer NOT NULL,
    dairesayisi smallint
);


ALTER TABLE public.evsahibi OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16477)
-- Name: giriscikiskaydi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.giriscikiskaydi (
    kayitid integer NOT NULL,
    kisiid integer,
    kapiid integer,
    aracid integer,
    giristarihi timestamp without time zone,
    "cikıstarihi" timestamp without time zone,
    aciklama text
);


ALTER TABLE public.giriscikiskaydi OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16482)
-- Name: giriscikiskaydi_kayitid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.giriscikiskaydi_kayitid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.giriscikiskaydi_kayitid_seq OWNER TO postgres;

--
-- TOC entry 5004 (class 0 OID 0)
-- Dependencies: 230
-- Name: giriscikiskaydi_kayitid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.giriscikiskaydi_kayitid_seq OWNED BY public.giriscikiskaydi.kayitid;


--
-- TOC entry 231 (class 1259 OID 16483)
-- Name: kapi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kapi (
    kapiid integer NOT NULL,
    kapiadi character varying(50)
);


ALTER TABLE public.kapi OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16486)
-- Name: kapi_kapiid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kapi_kapiid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kapi_kapiid_seq OWNER TO postgres;

--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 232
-- Name: kapi_kapiid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kapi_kapiid_seq OWNED BY public.kapi.kapiid;


--
-- TOC entry 233 (class 1259 OID 16487)
-- Name: kiraci; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kiraci (
    kiraciid integer NOT NULL,
    kisiid integer
);


ALTER TABLE public.kiraci OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16490)
-- Name: kiraci_kiraciid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kiraci_kiraciid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kiraci_kiraciid_seq OWNER TO postgres;

--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 234
-- Name: kiraci_kiraciid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kiraci_kiraciid_seq OWNED BY public.kiraci.kiraciid;


--
-- TOC entry 235 (class 1259 OID 16491)
-- Name: kirasozlesmesi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kirasozlesmesi (
    "sözleşmeid" integer NOT NULL,
    kiraciid integer NOT NULL,
    daireid integer NOT NULL,
    baslangictarihi date,
    bitistarihi date,
    kirabedeli numeric,
    depozito numeric,
    "özelsartlar" text,
    evsahibiid integer
);


ALTER TABLE public.kirasozlesmesi OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16496)
-- Name: kirasozlesmesi_sözleşmeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."kirasozlesmesi_sözleşmeid_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."kirasozlesmesi_sözleşmeid_seq" OWNER TO postgres;

--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 236
-- Name: kirasozlesmesi_sözleşmeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."kirasozlesmesi_sözleşmeid_seq" OWNED BY public.kirasozlesmesi."sözleşmeid";


--
-- TOC entry 237 (class 1259 OID 16497)
-- Name: kisi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kisi (
    kisiid integer NOT NULL,
    tckimlikno character varying(11),
    ad character varying(50),
    soyad character varying(50),
    telefon character varying(30),
    email character varying(100)
);


ALTER TABLE public.kisi OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16500)
-- Name: kisi_kisiid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kisi_kisiid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kisi_kisiid_seq OWNER TO postgres;

--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 238
-- Name: kisi_kisiid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kisi_kisiid_seq OWNED BY public.kisi.kisiid;


--
-- TOC entry 239 (class 1259 OID 16501)
-- Name: otopark; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otopark (
    otoparkid integer NOT NULL,
    binaid integer,
    kapasite integer,
    abonelikucreti numeric
);


ALTER TABLE public.otopark OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16506)
-- Name: otopark_otoparkid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.otopark_otoparkid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.otopark_otoparkid_seq OWNER TO postgres;

--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 240
-- Name: otopark_otoparkid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.otopark_otoparkid_seq OWNED BY public.otopark.otoparkid;


--
-- TOC entry 241 (class 1259 OID 16507)
-- Name: oylama; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oylama (
    oylamaid integer NOT NULL,
    binaid integer,
    evsahibiid integer,
    adayevsahibiid integer,
    oytarihi date
);


ALTER TABLE public.oylama OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16510)
-- Name: oylama_oylamaid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.oylama_oylamaid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.oylama_oylamaid_seq OWNER TO postgres;

--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 242
-- Name: oylama_oylamaid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.oylama_oylamaid_seq OWNED BY public.oylama.oylamaid;


--
-- TOC entry 243 (class 1259 OID 16511)
-- Name: park; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.park (
    binaid integer NOT NULL,
    oyunalani boolean,
    sporalani boolean
);


ALTER TABLE public.park OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 16514)
-- Name: yonetimekibi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.yonetimekibi (
    ekipuyeid integer NOT NULL,
    evsahibiid integer,
    gorev character varying(50),
    secimtarihi date,
    gorevsuresi integer
);


ALTER TABLE public.yonetimekibi OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 16517)
-- Name: yonetimekibi_ekipuyeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.yonetimekibi_ekipuyeid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.yonetimekibi_ekipuyeid_seq OWNER TO postgres;

--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 245
-- Name: yonetimekibi_ekipuyeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.yonetimekibi_ekipuyeid_seq OWNED BY public.yonetimekibi.ekipuyeid;


--
-- TOC entry 4727 (class 2604 OID 16518)
-- Name: adaylikbasvuru basvuruid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adaylikbasvuru ALTER COLUMN basvuruid SET DEFAULT nextval('public.adaylikbasvuru_basvuruid_seq'::regclass);


--
-- TOC entry 4728 (class 2604 OID 16519)
-- Name: arac aracid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arac ALTER COLUMN aracid SET DEFAULT nextval('public.arac_aracid_seq'::regclass);


--
-- TOC entry 4729 (class 2604 OID 16520)
-- Name: bina binaid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bina ALTER COLUMN binaid SET DEFAULT nextval('public.bina_binaid_seq'::regclass);


--
-- TOC entry 4730 (class 2604 OID 16521)
-- Name: daire daireid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daire ALTER COLUMN daireid SET DEFAULT nextval('public.daire_daireid_seq'::regclass);


--
-- TOC entry 4731 (class 2604 OID 16522)
-- Name: giriscikiskaydi kayitid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.giriscikiskaydi ALTER COLUMN kayitid SET DEFAULT nextval('public.giriscikiskaydi_kayitid_seq'::regclass);


--
-- TOC entry 4732 (class 2604 OID 16523)
-- Name: kapi kapiid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kapi ALTER COLUMN kapiid SET DEFAULT nextval('public.kapi_kapiid_seq'::regclass);


--
-- TOC entry 4733 (class 2604 OID 16524)
-- Name: kiraci kiraciid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kiraci ALTER COLUMN kiraciid SET DEFAULT nextval('public.kiraci_kiraciid_seq'::regclass);


--
-- TOC entry 4734 (class 2604 OID 16525)
-- Name: kirasozlesmesi sözleşmeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kirasozlesmesi ALTER COLUMN "sözleşmeid" SET DEFAULT nextval('public."kirasozlesmesi_sözleşmeid_seq"'::regclass);


--
-- TOC entry 4735 (class 2604 OID 16526)
-- Name: kisi kisiid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kisi ALTER COLUMN kisiid SET DEFAULT nextval('public.kisi_kisiid_seq'::regclass);


--
-- TOC entry 4736 (class 2604 OID 16527)
-- Name: otopark otoparkid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otopark ALTER COLUMN otoparkid SET DEFAULT nextval('public.otopark_otoparkid_seq'::regclass);


--
-- TOC entry 4737 (class 2604 OID 16528)
-- Name: oylama oylamaid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oylama ALTER COLUMN oylamaid SET DEFAULT nextval('public.oylama_oylamaid_seq'::regclass);


--
-- TOC entry 4738 (class 2604 OID 16529)
-- Name: yonetimekibi ekipuyeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yonetimekibi ALTER COLUMN ekipuyeid SET DEFAULT nextval('public.yonetimekibi_ekipuyeid_seq'::regclass);


--
-- TOC entry 4966 (class 0 OID 16443)
-- Dependencies: 217
-- Data for Name: adaylikbasvuru; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adaylikbasvuru (basvuruid, evsahibiid, basvurutarihi) FROM stdin;
\.


--
-- TOC entry 4968 (class 0 OID 16447)
-- Dependencies: 219
-- Data for Name: apartman; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.apartman (binaid, katsayisi, dairesayisi, asansorsayisi, yoneticiid) FROM stdin;
\.


--
-- TOC entry 4969 (class 0 OID 16450)
-- Dependencies: 220
-- Data for Name: arac; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.arac (aracid, sahipid, plaka, marka, model, otoparkid) FROM stdin;
9	2	11AA22	111	aa	\N
\.


--
-- TOC entry 4971 (class 0 OID 16456)
-- Dependencies: 222
-- Data for Name: bina; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bina (binaid, binaadi, adres, alan) FROM stdin;
13	mavi	123 caddsi	300
14	11	123 caddesi	400
15	123	cadde mavi	300
\.


--
-- TOC entry 4973 (class 0 OID 16462)
-- Dependencies: 224
-- Data for Name: calisan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.calisan (kisiid, gorev, deneyim, maas) FROM stdin;
1	oturmak	5	1900
\.


--
-- TOC entry 4974 (class 0 OID 16465)
-- Dependencies: 225
-- Data for Name: calisanyapi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.calisanyapi (kisiid, binaid, isbaslangic) FROM stdin;
1	14	2024-12-23
\.


--
-- TOC entry 4975 (class 0 OID 16468)
-- Dependencies: 226
-- Data for Name: daire; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.daire (daireid, apartmanid, daireno, odasayisi, salonsayisi, metrekare, dairetipi, katnumarasi, sahipid) FROM stdin;
\.


--
-- TOC entry 4977 (class 0 OID 16474)
-- Dependencies: 228
-- Data for Name: evsahibi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.evsahibi (kisiid, dairesayisi) FROM stdin;
1	1
\.


--
-- TOC entry 4978 (class 0 OID 16477)
-- Dependencies: 229
-- Data for Name: giriscikiskaydi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.giriscikiskaydi (kayitid, kisiid, kapiid, aracid, giristarihi, "cikıstarihi", aciklama) FROM stdin;
\.


--
-- TOC entry 4980 (class 0 OID 16483)
-- Dependencies: 231
-- Data for Name: kapi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kapi (kapiid, kapiadi) FROM stdin;
1	ahmetKapisi
\.


--
-- TOC entry 4982 (class 0 OID 16487)
-- Dependencies: 233
-- Data for Name: kiraci; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kiraci (kiraciid, kisiid) FROM stdin;
\.


--
-- TOC entry 4984 (class 0 OID 16491)
-- Dependencies: 235
-- Data for Name: kirasozlesmesi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kirasozlesmesi ("sözleşmeid", kiraciid, daireid, baslangictarihi, bitistarihi, kirabedeli, depozito, "özelsartlar", evsahibiid) FROM stdin;
\.


--
-- TOC entry 4986 (class 0 OID 16497)
-- Dependencies: 237
-- Data for Name: kisi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kisi (kisiid, tckimlikno, ad, soyad, telefon, email) FROM stdin;
1	98765432101	hakan	Tüysüz	05327816312	\N
10	09090909091	John	Doe	1234567890	john.doe@example.com
11	09020904091	John	Doe	1234567890	john.doe@example.com
12	12020904091	John	Doe	1234567890	john.doe@example.com
14	02020904391	John	Doe	1234567890	john.doe@example.com
5	12020904391	John	Doe	1234567890	john.doe@example.com
16	12345678900	hakan efe	tüysüz	05447317941	\N
18	12345678903	hakan efe xx	tüysüz	05447317941	\N
2	12345678901	ahmat	mahmut	123	asd
\.


--
-- TOC entry 4988 (class 0 OID 16501)
-- Dependencies: 239
-- Data for Name: otopark; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.otopark (otoparkid, binaid, kapasite, abonelikucreti) FROM stdin;
6	14	66	77
\.


--
-- TOC entry 4990 (class 0 OID 16507)
-- Dependencies: 241
-- Data for Name: oylama; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oylama (oylamaid, binaid, evsahibiid, adayevsahibiid, oytarihi) FROM stdin;
\.


--
-- TOC entry 4992 (class 0 OID 16511)
-- Dependencies: 243
-- Data for Name: park; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.park (binaid, oyunalani, sporalani) FROM stdin;
13	t	t
\.


--
-- TOC entry 4993 (class 0 OID 16514)
-- Dependencies: 244
-- Data for Name: yonetimekibi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.yonetimekibi (ekipuyeid, evsahibiid, gorev, secimtarihi, gorevsuresi) FROM stdin;
1	1	yönetmek	2020-12-12	10
\.


--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 218
-- Name: adaylikbasvuru_basvuruid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adaylikbasvuru_basvuruid_seq', 1, false);


--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 221
-- Name: arac_aracid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.arac_aracid_seq', 11, true);


--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 223
-- Name: bina_binaid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bina_binaid_seq', 15, true);


--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 227
-- Name: daire_daireid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.daire_daireid_seq', 1, false);


--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 230
-- Name: giriscikiskaydi_kayitid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.giriscikiskaydi_kayitid_seq', 1, false);


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 232
-- Name: kapi_kapiid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kapi_kapiid_seq', 1, false);


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 234
-- Name: kiraci_kiraciid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kiraci_kiraciid_seq', 1, true);


--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 236
-- Name: kirasozlesmesi_sözleşmeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."kirasozlesmesi_sözleşmeid_seq"', 1, false);


--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 238
-- Name: kisi_kisiid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kisi_kisiid_seq', 18, true);


--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 240
-- Name: otopark_otoparkid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.otopark_otoparkid_seq', 6, true);


--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 242
-- Name: oylama_oylamaid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.oylama_oylamaid_seq', 1, false);


--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 245
-- Name: yonetimekibi_ekipuyeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.yonetimekibi_ekipuyeid_seq', 1, false);


--
-- TOC entry 4740 (class 2606 OID 16531)
-- Name: adaylikbasvuru adaylikbasvuru_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adaylikbasvuru
    ADD CONSTRAINT adaylikbasvuru_pkey PRIMARY KEY (basvuruid);


--
-- TOC entry 4742 (class 2606 OID 16533)
-- Name: apartman apartman_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.apartman
    ADD CONSTRAINT apartman_pkey PRIMARY KEY (binaid);


--
-- TOC entry 4744 (class 2606 OID 16535)
-- Name: arac arac_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arac
    ADD CONSTRAINT arac_pkey PRIMARY KEY (aracid);


--
-- TOC entry 4749 (class 2606 OID 16537)
-- Name: bina bina_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bina
    ADD CONSTRAINT bina_pkey PRIMARY KEY (binaid);


--
-- TOC entry 4751 (class 2606 OID 16734)
-- Name: bina binaunique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bina
    ADD CONSTRAINT binaunique UNIQUE (binaid);


--
-- TOC entry 4753 (class 2606 OID 16539)
-- Name: calisan calisan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calisan
    ADD CONSTRAINT calisan_pkey PRIMARY KEY (kisiid);


--
-- TOC entry 4756 (class 2606 OID 16541)
-- Name: calisanyapi calisanyapi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calisanyapi
    ADD CONSTRAINT calisanyapi_pkey PRIMARY KEY (kisiid, binaid);


--
-- TOC entry 4758 (class 2606 OID 16543)
-- Name: daire daire_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daire
    ADD CONSTRAINT daire_pkey PRIMARY KEY (daireid);


--
-- TOC entry 4761 (class 2606 OID 16545)
-- Name: evsahibi evsahibi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evsahibi
    ADD CONSTRAINT evsahibi_pkey PRIMARY KEY (kisiid);


--
-- TOC entry 4766 (class 2606 OID 16547)
-- Name: giriscikiskaydi giriscikiskaydi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.giriscikiskaydi
    ADD CONSTRAINT giriscikiskaydi_pkey PRIMARY KEY (kayitid);


--
-- TOC entry 4768 (class 2606 OID 16549)
-- Name: kapi kapi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kapi
    ADD CONSTRAINT kapi_pkey PRIMARY KEY (kapiid);


--
-- TOC entry 4771 (class 2606 OID 16551)
-- Name: kiraci kiraci_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kiraci
    ADD CONSTRAINT kiraci_pkey PRIMARY KEY (kiraciid);


--
-- TOC entry 4773 (class 2606 OID 16553)
-- Name: kirasozlesmesi kirasozlesmesi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kirasozlesmesi
    ADD CONSTRAINT kirasozlesmesi_pkey PRIMARY KEY ("sözleşmeid", kiraciid, daireid);


--
-- TOC entry 4775 (class 2606 OID 16555)
-- Name: kisi kisi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kisi
    ADD CONSTRAINT kisi_pkey PRIMARY KEY (kisiid);


--
-- TOC entry 4777 (class 2606 OID 16557)
-- Name: kisi kisi_tckimlikno_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kisi
    ADD CONSTRAINT kisi_tckimlikno_key UNIQUE (tckimlikno);


--
-- TOC entry 4779 (class 2606 OID 16559)
-- Name: otopark otopark_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otopark
    ADD CONSTRAINT otopark_pkey PRIMARY KEY (otoparkid);


--
-- TOC entry 4781 (class 2606 OID 16738)
-- Name: otopark otoparkunique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otopark
    ADD CONSTRAINT otoparkunique UNIQUE (binaid);


--
-- TOC entry 4783 (class 2606 OID 16561)
-- Name: oylama oylama_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oylama
    ADD CONSTRAINT oylama_pkey PRIMARY KEY (oylamaid);


--
-- TOC entry 4785 (class 2606 OID 16563)
-- Name: park park_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.park
    ADD CONSTRAINT park_pkey PRIMARY KEY (binaid);


--
-- TOC entry 4787 (class 2606 OID 16736)
-- Name: park parkunique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.park
    ADD CONSTRAINT parkunique UNIQUE (binaid);


--
-- TOC entry 4747 (class 2606 OID 16690)
-- Name: arac uq_plka; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arac
    ADD CONSTRAINT uq_plka UNIQUE (plaka);


--
-- TOC entry 4789 (class 2606 OID 16565)
-- Name: yonetimekibi yonetimekibi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yonetimekibi
    ADD CONSTRAINT yonetimekibi_pkey PRIMARY KEY (ekipuyeid);


--
-- TOC entry 4745 (class 1259 OID 16702)
-- Name: fki_arackisi; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_arackisi ON public.arac USING btree (sahipid);


--
-- TOC entry 4754 (class 1259 OID 16720)
-- Name: fki_calisankisiid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_calisankisiid ON public.calisan USING btree (kisiid);


--
-- TOC entry 4762 (class 1259 OID 16726)
-- Name: fki_evsahibikisi; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_evsahibikisi ON public.evsahibi USING btree (kisiid);


--
-- TOC entry 4763 (class 1259 OID 16708)
-- Name: fki_giriscikisarac; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_giriscikisarac ON public.giriscikiskaydi USING btree (aracid);


--
-- TOC entry 4764 (class 1259 OID 16714)
-- Name: fki_giriscikiskisi; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_giriscikiskisi ON public.giriscikiskaydi USING btree (kisiid);


--
-- TOC entry 4769 (class 1259 OID 16732)
-- Name: fki_kisikiraci; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_kisikiraci ON public.kiraci USING btree (kisiid);


--
-- TOC entry 4759 (class 1259 OID 16696)
-- Name: fki_sahipfk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_sahipfk ON public.daire USING btree (sahipid);


--
-- TOC entry 4814 (class 2620 OID 16741)
-- Name: apartman kontrol_apartman; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER kontrol_apartman BEFORE INSERT OR UPDATE ON public.apartman FOR EACH ROW EXECUTE FUNCTION public.kontrol_bina_turu();


--
-- TOC entry 4819 (class 2620 OID 16743)
-- Name: otopark kontrol_otopark; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER kontrol_otopark BEFORE INSERT OR UPDATE ON public.otopark FOR EACH ROW EXECUTE FUNCTION public.kontrol_bina_turu();


--
-- TOC entry 4820 (class 2620 OID 16742)
-- Name: park kontrol_park; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER kontrol_park BEFORE INSERT OR UPDATE ON public.park FOR EACH ROW EXECUTE FUNCTION public.kontrol_bina_turu();


--
-- TOC entry 4815 (class 2620 OID 16566)
-- Name: arac trg_arac_insert_before; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_arac_insert_before BEFORE INSERT ON public.arac FOR EACH ROW EXECUTE FUNCTION public.validate_plaka();


--
-- TOC entry 4817 (class 2620 OID 16567)
-- Name: calisan trg_calisan_delete_check; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_calisan_delete_check BEFORE DELETE ON public.calisan FOR EACH ROW EXECUTE FUNCTION public.check_calisan_in_calisanyapi();


--
-- TOC entry 4818 (class 2620 OID 16568)
-- Name: calisanyapi trg_delete_unused_calisan; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_delete_unused_calisan AFTER DELETE ON public.calisanyapi FOR EACH ROW EXECUTE FUNCTION public.delete_unused_calisan();


--
-- TOC entry 4816 (class 2620 OID 16569)
-- Name: arac trg_otopark_dolu_mu; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_otopark_dolu_mu BEFORE INSERT ON public.arac FOR EACH ROW EXECUTE FUNCTION public.otoparkdolumu();


--
-- TOC entry 4790 (class 2606 OID 16570)
-- Name: adaylikbasvuru adaylikbasvuru_evsahibiid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adaylikbasvuru
    ADD CONSTRAINT adaylikbasvuru_evsahibiid_fkey FOREIGN KEY (evsahibiid) REFERENCES public.evsahibi(kisiid);


--
-- TOC entry 4791 (class 2606 OID 16575)
-- Name: apartman apartman_binaid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.apartman
    ADD CONSTRAINT apartman_binaid_fkey FOREIGN KEY (binaid) REFERENCES public.bina(binaid);


--
-- TOC entry 4793 (class 2606 OID 16697)
-- Name: arac arackisi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arac
    ADD CONSTRAINT arackisi FOREIGN KEY (sahipid) REFERENCES public.kisi(kisiid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4795 (class 2606 OID 16715)
-- Name: calisan calisankisiid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calisan
    ADD CONSTRAINT calisankisiid FOREIGN KEY (kisiid) REFERENCES public.kisi(kisiid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4796 (class 2606 OID 16590)
-- Name: calisanyapi calisanyapi_binaid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calisanyapi
    ADD CONSTRAINT calisanyapi_binaid_fkey FOREIGN KEY (binaid) REFERENCES public.bina(binaid);


--
-- TOC entry 4797 (class 2606 OID 16595)
-- Name: calisanyapi calisanyapi_kisiid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calisanyapi
    ADD CONSTRAINT calisanyapi_kisiid_fkey FOREIGN KEY (kisiid) REFERENCES public.calisan(kisiid);


--
-- TOC entry 4798 (class 2606 OID 16600)
-- Name: daire daire_apartmanid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daire
    ADD CONSTRAINT daire_apartmanid_fkey FOREIGN KEY (apartmanid) REFERENCES public.apartman(binaid);


--
-- TOC entry 4800 (class 2606 OID 16721)
-- Name: evsahibi evsahibikisi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evsahibi
    ADD CONSTRAINT evsahibikisi FOREIGN KEY (kisiid) REFERENCES public.kisi(kisiid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4805 (class 2606 OID 16744)
-- Name: kirasozlesmesi evsahibisozlesme; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kirasozlesmesi
    ADD CONSTRAINT evsahibisozlesme FOREIGN KEY (evsahibiid) REFERENCES public.evsahibi(kisiid) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4801 (class 2606 OID 16703)
-- Name: giriscikiskaydi giriscikisarac; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.giriscikiskaydi
    ADD CONSTRAINT giriscikisarac FOREIGN KEY (aracid) REFERENCES public.arac(aracid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4802 (class 2606 OID 16615)
-- Name: giriscikiskaydi giriscikiskaydi_kapiid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.giriscikiskaydi
    ADD CONSTRAINT giriscikiskaydi_kapiid_fkey FOREIGN KEY (kapiid) REFERENCES public.kapi(kapiid);


--
-- TOC entry 4803 (class 2606 OID 16709)
-- Name: giriscikiskaydi giriscikiskisi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.giriscikiskaydi
    ADD CONSTRAINT giriscikiskisi FOREIGN KEY (kisiid) REFERENCES public.kisi(kisiid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4806 (class 2606 OID 16630)
-- Name: kirasozlesmesi kirasozlesmesi_daireid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kirasozlesmesi
    ADD CONSTRAINT kirasozlesmesi_daireid_fkey FOREIGN KEY (daireid) REFERENCES public.daire(daireid);


--
-- TOC entry 4807 (class 2606 OID 16635)
-- Name: kirasozlesmesi kirasozlesmesi_kiraciid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kirasozlesmesi
    ADD CONSTRAINT kirasozlesmesi_kiraciid_fkey FOREIGN KEY (kiraciid) REFERENCES public.kiraci(kiraciid);


--
-- TOC entry 4804 (class 2606 OID 16727)
-- Name: kiraci kisikiraci; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kiraci
    ADD CONSTRAINT kisikiraci FOREIGN KEY (kisiid) REFERENCES public.kisi(kisiid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4794 (class 2606 OID 16640)
-- Name: arac link_otopark_arac; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arac
    ADD CONSTRAINT link_otopark_arac FOREIGN KEY (otoparkid) REFERENCES public.otopark(otoparkid) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4792 (class 2606 OID 16645)
-- Name: apartman link_yonetimekibi_apartman; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.apartman
    ADD CONSTRAINT link_yonetimekibi_apartman FOREIGN KEY (yoneticiid) REFERENCES public.yonetimekibi(ekipuyeid) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4808 (class 2606 OID 16650)
-- Name: otopark otopark_binaid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otopark
    ADD CONSTRAINT otopark_binaid_fkey FOREIGN KEY (binaid) REFERENCES public.bina(binaid);


--
-- TOC entry 4809 (class 2606 OID 16655)
-- Name: oylama oylama_adayevsahibiid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oylama
    ADD CONSTRAINT oylama_adayevsahibiid_fkey FOREIGN KEY (adayevsahibiid) REFERENCES public.evsahibi(kisiid);


--
-- TOC entry 4810 (class 2606 OID 16660)
-- Name: oylama oylama_binaid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oylama
    ADD CONSTRAINT oylama_binaid_fkey FOREIGN KEY (binaid) REFERENCES public.bina(binaid);


--
-- TOC entry 4811 (class 2606 OID 16665)
-- Name: oylama oylama_evsahibiid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oylama
    ADD CONSTRAINT oylama_evsahibiid_fkey FOREIGN KEY (evsahibiid) REFERENCES public.evsahibi(kisiid);


--
-- TOC entry 4812 (class 2606 OID 16670)
-- Name: park park_binaid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.park
    ADD CONSTRAINT park_binaid_fkey FOREIGN KEY (binaid) REFERENCES public.bina(binaid);


--
-- TOC entry 4799 (class 2606 OID 16691)
-- Name: daire sahipfk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daire
    ADD CONSTRAINT sahipfk FOREIGN KEY (sahipid) REFERENCES public.evsahibi(kisiid);


--
-- TOC entry 4813 (class 2606 OID 16675)
-- Name: yonetimekibi yonetimekibi_evsahibiid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yonetimekibi
    ADD CONSTRAINT yonetimekibi_evsahibiid_fkey FOREIGN KEY (evsahibiid) REFERENCES public.evsahibi(kisiid);


-- Completed on 2024-12-23 16:39:10

--
-- PostgreSQL database dump complete
--

