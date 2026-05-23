--
-- PostgreSQL database dump
--

\restrict OgD3hoNJWtIDHLdAMO5JJUXtwCna6mOieofm6Y30ppFAoWDsc3fZP8nKjZbcsaT

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

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
-- Name: BugFix(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public."BugFix"()
    LANGUAGE plpgsql
    AS $$
BEGIN

	UPDATE "character_data" SET "Alive" = '0' WHERE "Inventory" = '[[],[]]' AND "Backpack" LIKE '%["",[[],[]],[[],[]]]%' AND "Alive" = '1';

	

  UPDATE "object_data" SET "Damage"='1' WHERE "Worldspace" NOT LIKE '[%,[%,%,%]]';

	UPDATE "object_data" SET "Damage"='1' WHERE "Hitpoints" NOT LIKE '%[["%' AND "Hitpoints" NOT LIKE '%[]%';

 

END
$$;


ALTER PROCEDURE public."BugFix"() OWNER TO postgres;

--
-- Name: fGetClassCount(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."fGetClassCount"(clname character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $$
DECLARE
    iClassCount smallint := 0;
BEGIN
	
	SELECT COUNT("Classname") 
		INTO iClassCount 
		FROM "object_data" 
		WHERE "Classname" = clname;
	RETURN iClassCount;
END
$$;


ALTER FUNCTION public."fGetClassCount"(clname character varying) OWNER TO postgres;

--
-- Name: fGetSpawnFromChance(double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."fGetSpawnFromChance"(chance double precision) RETURNS smallint
    LANGUAGE plpgsql
    AS $$
DECLARE
    bspawn smallint := 0;
BEGIN
	IF (random() <= chance) THEN
		bspawn := 1;
	END IF;
	RETURN bspawn;
END
$$;


ALTER FUNCTION public."fGetSpawnFromChance"(chance double precision) OWNER TO postgres;

--
-- Name: fGetVehCount(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."fGetVehCount"() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    iVehCount integer := 0;
BEGIN
	SELECT COUNT("Classname") 
		INTO iVehCount
		FROM "object_data" 
		WHERE "Classname" != 'dummy'
			AND "Classname" != 'TentStorage'  
			AND "Classname" != 'Hedgehog_DZ'	
			AND "Classname" != 'Wire_cat1'		
			AND "Classname" != 'Sandbag1_DZ'	
			AND "Classname" != 'TrapBear';		
	RETURN iVehCount;
END
$$;


ALTER FUNCTION public."fGetVehCount"() OWNER TO postgres;

--
-- Name: pCleanup(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public."pCleanup"()
    LANGUAGE plpgsql
    AS $$
BEGIN

	DELETE
	FROM object_data
	WHERE Damage = '1';

	DELETE
			FROM "object_data" 
			WHERE "ObjectUID" 
			NOT LIKE '0000%' 
			AND (	"Classname" NOT LIKE 'Tentstorage' AND 
					"Classname" NOT LIKE 'TentstorageR' AND 
					"Classname" NOT LIKE 'wooden_shed_lvl_1' AND 
					"Classname" NOT LIKE 'log_house_lvl_2' AND 
					"Classname" NOT LIKE 'wooden_house_lvl_3' AND 
					"Classname" NOT LIKE 'large_shed_lvl_1' AND 
					"Classname" NOT LIKE 'small_house_lvl_2' AND 
					"Classname" NOT LIKE 'big_house_lvl_3' AND 
					"Classname" NOT LIKE 'small_garage' AND 
					"Classname" NOT LIKE 'big_garage' AND 
					"Classname" NOT LIKE 'object_x');

	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000393';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000394';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000395';

	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001391';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001392';			
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001393';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001394';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001395';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001396';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001397';

	INSERT INTO "object_data" 
			VALUES (NULL, '0000500001391', '1', 'ori_vil_truck_civ_base', '0.05000', '0', '[48,[22173.301,19832.301,0.001]]', '[[[],[]],[[\"ItemAntibiotic\",\"ItemBandage\",\"ItemBloodbag\",\"ItemEpinephrine\",\"ItemMorphine\",\"ItemPainkiller\",\"FoodCanBakedBeans\",\"FoodCanFrankBeans\",\"FoodCanPasta\",\"FoodCanSardines\",\"ItemSodaCoke\",\"ItemSodaPepsi\",\"ItemHeatPack\"],[15,15,15,15,15,15,15,15,15,15,15,15,15]],[["O_TravelerPack_1","O_MegaPack_1"],[1,1]]]', '[[\"motor\",0.8],[\"karoserie\",1],[\"palivo\",0.8],[\"wheel_1_1_steering\",1],[\"wheel_2_1_steering\",1],[\"wheel_1_2_steering\",1],[\"wheel_2_2_steering\",1]]', '0.01000', NOW()) ON CONFLICT DO NOTHING;
	INSERT INTO "object_data" 
			VALUES (NULL, '0000500001392', '1', 'ori_vil_truck_civ_base', '0.05000', '0', '[353,[22546.1,19870.801,0.001]]', '[[[\"ItemPickaxe\"],[2]],[[\"ItemBpt_b1\",\"ItemBpt_b2\",\"ItemBpt_h1\",\"ItemBpt_h2\",\"ItemBpt_g_s\",\"ItemBpt_g_b\",\"ItemBattery\",\"ItemPin\",\"ItemRocks\",\"ItemCementBag\",\"PartScrap\",\"PartWoodPile\",\"ItemCeMix\"],[3,3,3,3,3,1,7,7,15,5,10,15,3]],[["O_TravelerPack_1","O_MegaPack_1"],[1,1]]]', '[[\"motor\",0.8],[\"karoserie\",1],[\"palivo\",0.8],[\"wheel_1_1_steering\",1],[\"wheel_2_1_steering\",1],[\"wheel_1_2_steering\",1],[\"wheel_2_2_steering\",1]]', '0.01000', NOW()) ON CONFLICT DO NOTHING;

	
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000431';
	
	INSERT INTO "object_data" 
			VALUES (NULL, '0000500000431', '1', 'Ori_DC3', '0.05000', '0', '[1,[22687.3,19239.3,0]]', '[]', '[]', '1', NOW()) ON CONFLICT DO NOTHING;

	
	DELETE
	FROM object_data
	WHERE Datestamp::date < CURRENT_DATE - INTERVAL '5 days'
	AND Classname != 'Hedgehog_DZ'
	AND Classname != 'Wire_cat1'
	AND Classname != 'Sandbag1_DZ'
	AND Classname != 'TrapBear'
	AND Classname != 'TentStorage'
	AND Classname != 'TentStorageR' AND
	Classname != 'wooden_shed_lvl_1' AND 
	Classname != 'log_house_lvl_2' AND 
	Classname != 'wooden_house_lvl_3' AND 
	Classname != 'large_shed_lvl_1' AND 
	Classname != 'small_house_lvl_2' AND 
	Classname != 'big_house_lvl_3' AND 
	Classname != 'small_garage' AND 
	Classname != 'big_garage' AND 
	Classname != 'object_x';

	
	DELETE
		FROM "object_data"
		WHERE "Classname" = 'TentStorage'
			AND  Datestamp::date < CURRENT_DATE - INTERVAL '6 days';

	
	DELETE
	FROM object_data
	WHERE Classname = 'TentStorage'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[[[],[]],[[],[]],[[],[]]]';

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorage'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[]';	

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorageR'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[[[],[]],[[],[]],[[],[]]]';

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorageR'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[]';

	
	DELETE
	FROM object_data
	WHERE Classname = 'Wire_cat1'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'Hedgehog_DZ'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'Sandbag1_DZ'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'TrapBear'
	AND Datestamp::date <= CURRENT_DATE;

	DELETE
			FROM "check"
			WHERE "check" = '0';
	DELETE
			FROM "check"
			WHERE "check" = '6';
	INSERT INTO "check" VALUES (1);
	
END
$$;


ALTER PROCEDURE public."pCleanup"() OWNER TO postgres;

--
-- Name: pCleanup2(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public."pCleanup2"()
    LANGUAGE plpgsql
    AS $$
BEGIN

	DELETE
	FROM object_data
	WHERE Damage = '1';

	DELETE
			FROM "object_data" 
			WHERE "ObjectUID" 
			NOT LIKE '0000%' 
			AND (	"Classname" NOT LIKE 'Tentstorage' AND 
					"Classname" NOT LIKE 'TentstorageR' AND 
					"Classname" NOT LIKE 'wooden_shed_lvl_1' AND 
					"Classname" NOT LIKE 'log_house_lvl_2' AND 
					"Classname" NOT LIKE 'wooden_house_lvl_3' AND 
					"Classname" NOT LIKE 'large_shed_lvl_1' AND 
					"Classname" NOT LIKE 'small_house_lvl_2' AND 
					"Classname" NOT LIKE 'big_house_lvl_3' AND 
					"Classname" NOT LIKE 'small_garage' AND 
					"Classname" NOT LIKE 'big_garage' AND 
					"Classname" NOT LIKE 'object_x');

	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000393';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000394';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000395';

	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001391';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001392';			
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001393';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001394';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001395';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001396';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001397';

	INSERT INTO "object_data" 
			VALUES (NULL, '0000500001391', '1', 'ori_vil_truck_civ_base', '0.05000', '0', '[48,[22173.301,19832.301,0.001]]', '[[[],[]],[[\"ItemAntibiotic\",\"ItemBandage\",\"ItemBloodbag\",\"ItemEpinephrine\",\"ItemMorphine\",\"ItemPainkiller\",\"FoodCanBakedBeans\",\"FoodCanFrankBeans\",\"FoodCanPasta\",\"FoodCanSardines\",\"ItemSodaCoke\",\"ItemSodaPepsi\",\"ItemHeatPack\"],[15,15,15,15,15,15,15,15,15,15,15,15,15]],[["O_TravelerPack_1","O_MegaPack_1"],[1,1]]]', '[[\"motor\",0.8],[\"karoserie\",1],[\"palivo\",0.8],[\"wheel_1_1_steering\",1],[\"wheel_2_1_steering\",1],[\"wheel_1_2_steering\",1],[\"wheel_2_2_steering\",1]]', '0.01000', NOW()) ON CONFLICT DO NOTHING;
	INSERT INTO "object_data" 
			VALUES (NULL, '0000500001393', '1', 'ori_vil_truck_civ_base', '0.05000', '0', '[208,[22580.1,19685.699,0.001]]', '[[[\"AKS_74_kobra\",\"M16A2GL\",\"AKS_74_U\",\"FN_FAL\",\"M9SD\",\"PK_DZ\",\"Pecheneg_DZ\",\"bizon_silenced\",\"M4A3_RCO_GL_EP1\",\"NVGoggles\",\"ItemGPS\",\"G36K\"],[3,3,3,3,3,3,3,3,3,2,2,1]],[[\"ItemBloodbag\",\"100Rnd_762x54_PK\",\"30Rnd_556x45_Stanag\",\"100Rnd_762x51_M240\",\"30Rnd_556x45_G36SD\",\"10Rnd_9x39_SP5_VSS\",\"ItemAntibiotic\",\"30Rnd_545x39_AK\",\"20Rnd_762x51_FNFAL\",\"15Rnd_9x19_M9SD\",\"64Rnd_9x19_SD_Bizon\",\"1Rnd_HE_GP25\",\"PartGeneric\",\"PartEngine\",\"PartGlass\",\"PartVRotor\",\"ItemJerrycan\",\"ItemTent\"],[10,10,10,10,10,10,10,10,10,10,10,10,4,2,6,2,10,2]],[["O_TravelerPack_1","O_MegaPack_1"],[1,1]]]', '[[\"motor\",0.8],[\"karoserie\",1],[\"palivo\",0.8],[\"wheel_1_1_steering\",1],[\"wheel_2_1_steering\",1],[\"wheel_1_2_steering\",1],[\"wheel_2_2_steering\",1]]', '0.01000', NOW()) ON CONFLICT DO NOTHING;
	
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000431';
	
	INSERT INTO "object_data" 
			VALUES (NULL, '0000500000431', '1', 'Ori_DC3', '0.05000', '0', '[1,[22687.3,19239.3,0]]', '[]', '[]', '1', NOW()) ON CONFLICT DO NOTHING;

	
	DELETE
	FROM object_data
	WHERE Datestamp::date < CURRENT_DATE - INTERVAL '5 days'
	AND Classname != 'Hedgehog_DZ'
	AND Classname != 'Wire_cat1'
	AND Classname != 'Sandbag1_DZ'
	AND Classname != 'TrapBear'
	AND Classname != 'TentStorage'
	AND Classname != 'TentStorageR' AND
	Classname != 'wooden_shed_lvl_1' AND 
	Classname != 'log_house_lvl_2' AND 
	Classname != 'wooden_house_lvl_3' AND 
	Classname != 'large_shed_lvl_1' AND 
	Classname != 'small_house_lvl_2' AND 
	Classname != 'big_house_lvl_3' AND 
	Classname != 'small_garage' AND 
	Classname != 'big_garage' AND 
	Classname != 'object_x';

	
	DELETE
		FROM "object_data"
		WHERE "Classname" = 'TentStorage'
			AND  Datestamp::date < CURRENT_DATE - INTERVAL '6 days';

	
	DELETE
	FROM object_data
	WHERE Classname = 'TentStorage'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[[[],[]],[[],[]],[[],[]]]';

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorage'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[]';	

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorageR'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[[[],[]],[[],[]],[[],[]]]';

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorageR'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[]';

	
	DELETE
	FROM object_data
	WHERE Classname = 'Wire_cat1'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'Hedgehog_DZ'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'Sandbag1_DZ'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'TrapBear'
	AND Datestamp::date <= CURRENT_DATE;
	
	DELETE
			FROM "check"
			WHERE "check" = '0';
	DELETE
			FROM "check"
			WHERE "check" = '1';
	INSERT INTO "check" VALUES (2);

END
$$;


ALTER PROCEDURE public."pCleanup2"() OWNER TO postgres;

--
-- Name: pCleanup3(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public."pCleanup3"()
    LANGUAGE plpgsql
    AS $$
BEGIN

	DELETE
	FROM object_data
	WHERE Damage = '1';

	DELETE
			FROM "object_data" 
			WHERE "ObjectUID" 
			NOT LIKE '0000%' 
			AND (	"Classname" NOT LIKE 'Tentstorage' AND 
					"Classname" NOT LIKE 'TentstorageR' AND 
					"Classname" NOT LIKE 'wooden_shed_lvl_1' AND 
					"Classname" NOT LIKE 'log_house_lvl_2' AND 
					"Classname" NOT LIKE 'wooden_house_lvl_3' AND 
					"Classname" NOT LIKE 'large_shed_lvl_1' AND 
					"Classname" NOT LIKE 'small_house_lvl_2' AND 
					"Classname" NOT LIKE 'big_house_lvl_3' AND 
					"Classname" NOT LIKE 'small_garage' AND 
					"Classname" NOT LIKE 'big_garage' AND 
					"Classname" NOT LIKE 'object_x');

	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000393';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000394';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000395';

	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001391';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001392';			
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001393';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001394';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001395';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001396';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001397';

	INSERT INTO "object_data" 
			VALUES (NULL, '0000500001391', '1', 'ori_vil_truck_civ_base', '0.05000', '0', '[48,[22173.301,19832.301,0.001]]', '[[[],[]],[[\"ItemAntibiotic\",\"ItemBandage\",\"ItemBloodbag\",\"ItemEpinephrine\",\"ItemMorphine\",\"ItemPainkiller\",\"FoodCanBakedBeans\",\"FoodCanFrankBeans\",\"FoodCanPasta\",\"FoodCanSardines\",\"ItemSodaCoke\",\"ItemSodaPepsi\",\"ItemHeatPack\"],[15,15,15,15,15,15,15,15,15,15,15,15,15]],[["O_TravelerPack_1","O_MegaPack_1"],[1,1]]]', '[[\"motor\",0.8],[\"karoserie\",1],[\"palivo\",0.8],[\"wheel_1_1_steering\",1],[\"wheel_2_1_steering\",1],[\"wheel_1_2_steering\",1],[\"wheel_2_2_steering\",1]]', '0.01000', NOW()) ON CONFLICT DO NOTHING;
	INSERT INTO "object_data" 
			VALUES (NULL, '0000500001394', '1', 'ori_vil_truck_civ_base', '0.05000', '0', '[180,[22280.9,19846.199,0.001]]', '[[[\"AKS_74_kobra\",\"M16A2GL\",\"AKS_74_U\",\"FN_FAL\",\"M9SD\",\"PK_DZ\",\"Pecheneg_DZ\",\"bizon_silenced\",\"M4A3_RCO_GL_EP1\",\"NVGoggles\",\"ItemGPS\",\"G36K\"],[3,3,3,3,3,3,3,3,3,2,2,1]],[[\"ItemBloodbag\",\"100Rnd_762x54_PK\",\"30Rnd_556x45_Stanag\",\"100Rnd_762x51_M240\",\"30Rnd_556x45_G36SD\",\"10Rnd_9x39_SP5_VSS\",\"ItemAntibiotic\",\"30Rnd_545x39_AK\",\"20Rnd_762x51_FNFAL\",\"15Rnd_9x19_M9SD\",\"64Rnd_9x19_SD_Bizon\",\"1Rnd_HE_GP25\",\"PartGeneric\",\"PartEngine\",\"PartGlass\",\"PartVRotor\",\"ItemJerrycan\",\"ItemTent\"],[10,10,10,10,10,10,10,10,10,10,10,10,4,2,6,2,10,2]],[["O_TravelerPack_1","O_MegaPack_1"],[1,1]]]', '[[\"motor\",0.8],[\"karoserie\",1],[\"palivo\",0.8],[\"wheel_1_1_steering\",1],[\"wheel_2_1_steering\",1],[\"wheel_1_2_steering\",1],[\"wheel_2_2_steering\",1]]', '0.01000', NOW()) ON CONFLICT DO NOTHING;
	
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000431';
	
	INSERT INTO "object_data" 
			VALUES (NULL, '0000500000431', '1', 'Ori_DC3', '0.05000', '0', '[1,[22687.3,19239.3,0]]', '[]', '[]', '1', NOW()) ON CONFLICT DO NOTHING;

	
	DELETE
	FROM object_data
	WHERE Datestamp::date < CURRENT_DATE - INTERVAL '5 days'
	AND Classname != 'Hedgehog_DZ'
	AND Classname != 'Wire_cat1'
	AND Classname != 'Sandbag1_DZ'
	AND Classname != 'TrapBear'
	AND Classname != 'TentStorage'
	AND Classname != 'TentStorageR' AND
	Classname != 'wooden_shed_lvl_1' AND 
	Classname != 'log_house_lvl_2' AND 
	Classname != 'wooden_house_lvl_3' AND 
	Classname != 'large_shed_lvl_1' AND 
	Classname != 'small_house_lvl_2' AND 
	Classname != 'big_house_lvl_3' AND 
	Classname != 'small_garage' AND 
	Classname != 'big_garage' AND 
	Classname != 'object_x';

	
	DELETE
		FROM "object_data"
		WHERE "Classname" = 'TentStorage'
			AND  Datestamp::date < CURRENT_DATE - INTERVAL '6 days';

	
	DELETE
	FROM object_data
	WHERE Classname = 'TentStorage'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[[[],[]],[[],[]],[[],[]]]';

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorage'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[]';	

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorageR'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[[[],[]],[[],[]],[[],[]]]';

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorageR'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[]';

	
	DELETE
	FROM object_data
	WHERE Classname = 'Wire_cat1'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'Hedgehog_DZ'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'Sandbag1_DZ'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'TrapBear'
	AND Datestamp::date <= CURRENT_DATE;

	DELETE
			FROM "check"
			WHERE "check" = '0';
	DELETE
			FROM "check"
			WHERE "check" = '2';
	INSERT INTO "check" VALUES (3);	
END
$$;


ALTER PROCEDURE public."pCleanup3"() OWNER TO postgres;

--
-- Name: pCleanup4(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public."pCleanup4"()
    LANGUAGE plpgsql
    AS $$
BEGIN

	DELETE
	FROM object_data
	WHERE Damage = '1';

	DELETE
			FROM "object_data" 
			WHERE "ObjectUID" 
			NOT LIKE '0000%' 
			AND (	"Classname" NOT LIKE 'Tentstorage' AND 
					"Classname" NOT LIKE 'TentstorageR' AND 
					"Classname" NOT LIKE 'wooden_shed_lvl_1' AND 
					"Classname" NOT LIKE 'log_house_lvl_2' AND 
					"Classname" NOT LIKE 'wooden_house_lvl_3' AND 
					"Classname" NOT LIKE 'large_shed_lvl_1' AND 
					"Classname" NOT LIKE 'small_house_lvl_2' AND 
					"Classname" NOT LIKE 'big_house_lvl_3' AND 
					"Classname" NOT LIKE 'small_garage' AND 
					"Classname" NOT LIKE 'big_garage' AND 
					"Classname" NOT LIKE 'object_x');

	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000393';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000394';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000395';

	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001391';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001392';			
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001393';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001394';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001395';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001396';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001397';

	INSERT INTO "object_data" 
			VALUES (NULL, '0000500001391', '1', 'ori_vil_truck_civ_base', '0.05000', '0', '[48,[22173.301,19832.301,0.001]]', '[[[],[]],[[\"ItemAntibiotic\",\"ItemBandage\",\"ItemBloodbag\",\"ItemEpinephrine\",\"ItemMorphine\",\"ItemPainkiller\",\"FoodCanBakedBeans\",\"FoodCanFrankBeans\",\"FoodCanPasta\",\"FoodCanSardines\",\"ItemSodaCoke\",\"ItemSodaPepsi\",\"ItemHeatPack\"],[15,15,15,15,15,15,15,15,15,15,15,15,15]],[["O_TravelerPack_1","O_MegaPack_1"],[1,1]]]', '[[\"motor\",0.8],[\"karoserie\",1],[\"palivo\",0.8],[\"wheel_1_1_steering\",1],[\"wheel_2_1_steering\",1],[\"wheel_1_2_steering\",1],[\"wheel_2_2_steering\",1]]', '0.01000', NOW()) ON CONFLICT DO NOTHING;
	INSERT INTO "object_data" 
			VALUES (NULL, '0000500001395', '1', 'ori_vil_truck_civ_base', '0.05000', '0', '[269,[22506.5,20040.6,0.001]]', '[[[\"AKS_74_kobra\",\"M16A2GL\",\"AKS_74_U\",\"FN_FAL\",\"M9SD\",\"PK_DZ\",\"Pecheneg_DZ\",\"bizon_silenced\",\"M4A3_RCO_GL_EP1\",\"NVGoggles\",\"ItemGPS\",\"G36K\"],[3,3,3,3,3,3,3,3,3,2,2,1]],[[\"ItemBloodbag\",\"100Rnd_762x54_PK\",\"30Rnd_556x45_Stanag\",\"100Rnd_762x51_M240\",\"30Rnd_556x45_G36SD\",\"10Rnd_9x39_SP5_VSS\",\"ItemAntibiotic\",\"30Rnd_545x39_AK\",\"20Rnd_762x51_FNFAL\",\"15Rnd_9x19_M9SD\",\"64Rnd_9x19_SD_Bizon\",\"1Rnd_HE_GP25\",\"PartGeneric\",\"PartEngine\",\"PartGlass\",\"PartVRotor\",\"ItemJerrycan\",\"ItemTent\"],[10,10,10,10,10,10,10,10,10,10,10,10,4,2,6,2,10,2]],[["O_TravelerPack_1","O_MegaPack_1"],[1,1]]]', '[[\"motor\",0.8],[\"karoserie\",1],[\"palivo\",0.8],[\"wheel_1_1_steering\",1],[\"wheel_2_1_steering\",1],[\"wheel_1_2_steering\",1],[\"wheel_2_2_steering\",1]]', '0.01000', NOW()) ON CONFLICT DO NOTHING;
	
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000431';
	
	INSERT INTO "object_data" 
			VALUES (NULL, '0000500000431', '1', 'Ori_DC3', '0.05000', '0', '[1,[22687.3,19239.3,0]]', '[]', '[]', '1', NOW()) ON CONFLICT DO NOTHING;

	
	DELETE
	FROM object_data
	WHERE Datestamp::date < CURRENT_DATE - INTERVAL '5 days'
	AND Classname != 'Hedgehog_DZ'
	AND Classname != 'Wire_cat1'
	AND Classname != 'Sandbag1_DZ'
	AND Classname != 'TrapBear'
	AND Classname != 'TentStorage'
	AND Classname != 'TentStorageR' AND
	Classname != 'wooden_shed_lvl_1' AND 
	Classname != 'log_house_lvl_2' AND 
	Classname != 'wooden_house_lvl_3' AND 
	Classname != 'large_shed_lvl_1' AND 
	Classname != 'small_house_lvl_2' AND 
	Classname != 'big_house_lvl_3' AND 
	Classname != 'small_garage' AND 
	Classname != 'big_garage' AND 
	Classname != 'object_x';

	
	DELETE
		FROM "object_data"
		WHERE "Classname" = 'TentStorage'
			AND  Datestamp::date < CURRENT_DATE - INTERVAL '6 days';

	
	DELETE
	FROM object_data
	WHERE Classname = 'TentStorage'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[[[],[]],[[],[]],[[],[]]]';

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorage'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[]';	

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorageR'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[[[],[]],[[],[]],[[],[]]]';

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorageR'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[]';

	
	DELETE
	FROM object_data
	WHERE Classname = 'Wire_cat1'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'Hedgehog_DZ'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'Sandbag1_DZ'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'TrapBear'
	AND Datestamp::date <= CURRENT_DATE;
	
	DELETE
			FROM "check"
			WHERE "check" = '0';
	DELETE
			FROM "check"
			WHERE "check" = '3';
	INSERT INTO "check" VALUES (4);

END
$$;


ALTER PROCEDURE public."pCleanup4"() OWNER TO postgres;

--
-- Name: pCleanup5(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public."pCleanup5"()
    LANGUAGE plpgsql
    AS $$
BEGIN

	DELETE
	FROM object_data
	WHERE Damage = '1';

	DELETE
			FROM "object_data" 
			WHERE "ObjectUID" 
			NOT LIKE '0000%' 
			AND (	"Classname" NOT LIKE 'Tentstorage' AND 
					"Classname" NOT LIKE 'TentstorageR' AND 
					"Classname" NOT LIKE 'wooden_shed_lvl_1' AND 
					"Classname" NOT LIKE 'log_house_lvl_2' AND 
					"Classname" NOT LIKE 'wooden_house_lvl_3' AND 
					"Classname" NOT LIKE 'large_shed_lvl_1' AND 
					"Classname" NOT LIKE 'small_house_lvl_2' AND 
					"Classname" NOT LIKE 'big_house_lvl_3' AND 
					"Classname" NOT LIKE 'small_garage' AND 
					"Classname" NOT LIKE 'big_garage' AND 
					"Classname" NOT LIKE 'object_x');

	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000393';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000394';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000395';

	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001391';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001392';			
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001393';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001394';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001395';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001396';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001397';

	INSERT INTO "object_data" 
			VALUES (NULL, '0000500001391', '1', 'ori_vil_truck_civ_base', '0.05000', '0', '[48,[22173.301,19832.301,0.001]]', '[[[],[]],[[\"ItemAntibiotic\",\"ItemBandage\",\"ItemBloodbag\",\"ItemEpinephrine\",\"ItemMorphine\",\"ItemPainkiller\",\"FoodCanBakedBeans\",\"FoodCanFrankBeans\",\"FoodCanPasta\",\"FoodCanSardines\",\"ItemSodaCoke\",\"ItemSodaPepsi\",\"ItemHeatPack\"],[15,15,15,15,15,15,15,15,15,15,15,15,15]],[["O_TravelerPack_1","O_MegaPack_1"],[1,1]]]', '[[\"motor\",0.8],[\"karoserie\",1],[\"palivo\",0.8],[\"wheel_1_1_steering\",1],[\"wheel_2_1_steering\",1],[\"wheel_1_2_steering\",1],[\"wheel_2_2_steering\",1]]', '0.01000', NOW()) ON CONFLICT DO NOTHING;
	INSERT INTO "object_data" 
			VALUES (NULL, '0000500001396', '1', 'ori_vil_truck_civ_base', '0.05000', '0', '[24,[22812.6,19541.199,0.001]]', '[[[\"AKS_74_kobra\",\"M16A2GL\",\"AKS_74_U\",\"FN_FAL\",\"M9SD\",\"PK_DZ\",\"Pecheneg_DZ\",\"bizon_silenced\",\"M4A3_RCO_GL_EP1\",\"NVGoggles\",\"ItemGPS\",\"G36K\"],[3,3,3,3,3,3,3,3,3,2,2,1]],[[\"ItemBloodbag\",\"100Rnd_762x54_PK\",\"30Rnd_556x45_Stanag\",\"100Rnd_762x51_M240\",\"30Rnd_556x45_G36SD\",\"10Rnd_9x39_SP5_VSS\",\"ItemAntibiotic\",\"30Rnd_545x39_AK\",\"20Rnd_762x51_FNFAL\",\"15Rnd_9x19_M9SD\",\"64Rnd_9x19_SD_Bizon\",\"1Rnd_HE_GP25\",\"PartGeneric\",\"PartEngine\",\"PartGlass\",\"PartVRotor\",\"ItemJerrycan\",\"ItemTent\"],[10,10,10,10,10,10,10,10,10,10,10,10,4,2,6,2,10,2]],[["O_TravelerPack_1","O_MegaPack_1"],[1,1]]]', '[[\"motor\",0.8],[\"karoserie\",1],[\"palivo\",0.8],[\"wheel_1_1_steering\",1],[\"wheel_2_1_steering\",1],[\"wheel_1_2_steering\",1],[\"wheel_2_2_steering\",1]]', '0.01000', NOW()) ON CONFLICT DO NOTHING;
	
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000431';
	
	INSERT INTO "object_data" 
			VALUES (NULL, '0000500000431', '1', 'Ori_DC3', '0.05000', '0', '[1,[22687.3,19239.3,0]]', '[]', '[]', '1', NOW()) ON CONFLICT DO NOTHING;

	
	DELETE
	FROM object_data
	WHERE Datestamp::date < CURRENT_DATE - INTERVAL '5 days'
	AND Classname != 'Hedgehog_DZ'
	AND Classname != 'Wire_cat1'
	AND Classname != 'Sandbag1_DZ'
	AND Classname != 'TrapBear'
	AND Classname != 'TentStorage'
	AND Classname != 'TentStorageR' AND
	Classname != 'wooden_shed_lvl_1' AND 
	Classname != 'log_house_lvl_2' AND 
	Classname != 'wooden_house_lvl_3' AND 
	Classname != 'large_shed_lvl_1' AND 
	Classname != 'small_house_lvl_2' AND 
	Classname != 'big_house_lvl_3' AND 
	Classname != 'small_garage' AND 
	Classname != 'big_garage' AND 
	Classname != 'object_x';

	
	DELETE
		FROM "object_data"
		WHERE "Classname" = 'TentStorage'
			AND  Datestamp::date < CURRENT_DATE - INTERVAL '6 days';

	
	DELETE
	FROM object_data
	WHERE Classname = 'TentStorage'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[[[],[]],[[],[]],[[],[]]]';

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorage'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[]';	

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorageR'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[[[],[]],[[],[]],[[],[]]]';

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorageR'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[]';

	
	DELETE
	FROM object_data
	WHERE Classname = 'Wire_cat1'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'Hedgehog_DZ'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'Sandbag1_DZ'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'TrapBear'
	AND Datestamp::date <= CURRENT_DATE;

	DELETE
			FROM "check"
			WHERE "check" = '0';
	DELETE
			FROM "check"
			WHERE "check" = '4';
	INSERT INTO "check" VALUES (5);
END
$$;


ALTER PROCEDURE public."pCleanup5"() OWNER TO postgres;

--
-- Name: pCleanup6(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public."pCleanup6"()
    LANGUAGE plpgsql
    AS $$
BEGIN

	DELETE
	FROM object_data
	WHERE Damage = '1';

	DELETE
			FROM "object_data" 
			WHERE "ObjectUID" 
			NOT LIKE '0000%' 
			AND (	"Classname" NOT LIKE 'Tentstorage' AND 
					"Classname" NOT LIKE 'TentstorageR' AND 
					"Classname" NOT LIKE 'wooden_shed_lvl_1' AND 
					"Classname" NOT LIKE 'log_house_lvl_2' AND 
					"Classname" NOT LIKE 'wooden_house_lvl_3' AND 
					"Classname" NOT LIKE 'large_shed_lvl_1' AND 
					"Classname" NOT LIKE 'small_house_lvl_2' AND 
					"Classname" NOT LIKE 'big_house_lvl_3' AND 
					"Classname" NOT LIKE 'small_garage' AND 
					"Classname" NOT LIKE 'big_garage' AND 
					"Classname" NOT LIKE 'object_x');

	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000393';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000394';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000395';

	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001391';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001392';			
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001393';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001394';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001395';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001396';
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500001397';

	INSERT INTO "object_data" 
			VALUES (NULL, '0000500001391', '1', 'ori_vil_truck_civ_base', '0.05000', '0', '[48,[22173.301,19832.301,0.001]]', '[[[],[]],[[\"ItemAntibiotic\",\"ItemBandage\",\"ItemBloodbag\",\"ItemEpinephrine\",\"ItemMorphine\",\"ItemPainkiller\",\"FoodCanBakedBeans\",\"FoodCanFrankBeans\",\"FoodCanPasta\",\"FoodCanSardines\",\"ItemSodaCoke\",\"ItemSodaPepsi\",\"ItemHeatPack\"],[15,15,15,15,15,15,15,15,15,15,15,15,15]],[["O_TravelerPack_1","O_MegaPack_1"],[1,1]]]', '[[\"motor\",0.8],[\"karoserie\",1],[\"palivo\",0.8],[\"wheel_1_1_steering\",1],[\"wheel_2_1_steering\",1],[\"wheel_1_2_steering\",1],[\"wheel_2_2_steering\",1]]', '0.01000', NOW()) ON CONFLICT DO NOTHING;
	INSERT INTO "object_data" 
			VALUES (NULL, '0000500001397', '1', 'ori_vil_truck_civ_base', '0.05000', '0', '[181,[22464.5,19495.1,0.001]]', '[[[\"AKS_74_kobra\",\"M16A2GL\",\"AKS_74_U\",\"FN_FAL\",\"M9SD\",\"PK_DZ\",\"Pecheneg_DZ\",\"bizon_silenced\",\"M4A3_RCO_GL_EP1\",\"NVGoggles\",\"ItemGPS\",\"G36K\"],[3,3,3,3,3,3,3,3,3,2,2,1]],[[\"ItemBloodbag\",\"100Rnd_762x54_PK\",\"30Rnd_556x45_Stanag\",\"100Rnd_762x51_M240\",\"30Rnd_556x45_G36SD\",\"10Rnd_9x39_SP5_VSS\",\"ItemAntibiotic\",\"30Rnd_545x39_AK\",\"20Rnd_762x51_FNFAL\",\"15Rnd_9x19_M9SD\",\"64Rnd_9x19_SD_Bizon\",\"1Rnd_HE_GP25\",\"PartGeneric\",\"PartEngine\",\"PartGlass\",\"PartVRotor\",\"ItemJerrycan\",\"ItemTent\"],[10,10,10,10,10,10,10,10,10,10,10,10,4,2,6,2,10,2]],[["O_TravelerPack_1","O_MegaPack_1"],[1,1]]]', '[[\"motor\",0.8],[\"karoserie\",1],[\"palivo\",0.8],[\"wheel_1_1_steering\",1],[\"wheel_2_1_steering\",1],[\"wheel_1_2_steering\",1],[\"wheel_2_2_steering\",1]]', '0.01000', NOW()) ON CONFLICT DO NOTHING;
	
	DELETE
			FROM "object_data"
			WHERE "ObjectUID" = '0000500000431';
	
	INSERT INTO "object_data" 
			VALUES (NULL, '0000500000431', '1', 'Ori_DC3', '0.05000', '0', '[1,[22687.3,19239.3,0]]', '[]', '[]', '1', NOW()) ON CONFLICT DO NOTHING;

	
	DELETE
	FROM object_data
	WHERE Datestamp::date < CURRENT_DATE - INTERVAL '5 days'
	AND Classname != 'Hedgehog_DZ'
	AND Classname != 'Wire_cat1'
	AND Classname != 'Sandbag1_DZ'
	AND Classname != 'TrapBear'
	AND Classname != 'TentStorage'
	AND Classname != 'TentStorageR' AND
	Classname != 'wooden_shed_lvl_1' AND 
	Classname != 'log_house_lvl_2' AND 
	Classname != 'wooden_house_lvl_3' AND 
	Classname != 'large_shed_lvl_1' AND 
	Classname != 'small_house_lvl_2' AND 
	Classname != 'big_house_lvl_3' AND 
	Classname != 'small_garage' AND 
	Classname != 'big_garage' AND 
	Classname != 'object_x';

	
	DELETE
		FROM "object_data"
		WHERE "Classname" = 'TentStorage'
			AND  Datestamp::date < CURRENT_DATE - INTERVAL '6 days';

	
	DELETE
	FROM object_data
	WHERE Classname = 'TentStorage'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[[[],[]],[[],[]],[[],[]]]';

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorage'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[]';	

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorageR'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[[[],[]],[[],[]],[[],[]]]';

	DELETE
	FROM object_data
	WHERE Classname = 'TentStorageR'
	AND Datestamp::date < CURRENT_DATE - INTERVAL '7 days'
	AND Inventory = '[]';

	
	DELETE
	FROM object_data
	WHERE Classname = 'Wire_cat1'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'Hedgehog_DZ'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'Sandbag1_DZ'
	AND Datestamp::date <= CURRENT_DATE;

	
	DELETE
	FROM object_data
	WHERE Classname = 'TrapBear'
	AND Datestamp::date <= CURRENT_DATE;
	
	DELETE
			FROM "check"
			WHERE "check" = '0';
	DELETE
			FROM "check"
			WHERE "check" = '5';
	INSERT INTO "check" VALUES (6);

END
$$;


ALTER PROCEDURE public."pCleanup6"() OWNER TO postgres;

--
-- Name: pCleanupOOB(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public."pCleanupOOB"()
    LANGUAGE plpgsql
    AS $$
DECLARE
    intLineCount integer := 0;
    intDummyCount integer := 0;
    intDoLine integer := 0;
    intWest integer := 0;
    intNorth integer := 0;
    rsObjectUID varchar(20) := '';
    rsWorldspace varchar(128) := '';
    West text := '';
    North text := '';
BEGIN



	SELECT COUNT(*)

		INTO intLineCount

		FROM object_data;



	SELECT COUNT(*)

		INTO intDummyCount

		FROM object_data

		WHERE Classname = 'dummy';



	WHILE intLineCount > intDummyCount LOOP

	

		intDoLine := intLineCount - 1;



		SELECT ObjectUID, Worldspace

			INTO rsObjectUID, rsWorldspace

			FROM object_data

			LIMIT 1 OFFSET intDoLine;



		rsWorldspace := REPLACE(rsWorldspace, '[', '');

		rsWorldspace := REPLACE(rsWorldspace, ']', '');

		SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(rsWorldspace, ',', 2), LENGTH(SUBSTRING_INDEX(rsWorldspace, ',', 2 -1)) + 1), ',', '') INTO West;

		SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(rsWorldspace, ',', 3), LENGTH(SUBSTRING_INDEX(rsWorldspace, ',', 3 -1)) + 1), ',', '') INTO North;



		SELECT POSITION('-' IN West) INTO intWest;

		SELECT POSITION('-' IN North) INTO intNorth;



		IF (intNorth = 0) THEN

			SELECT North::numeric(16,8) INTO intNorth;

		END IF;

			

		intLineCount := intLineCount - 1;



	END LOOP;



END
$$;


ALTER PROCEDURE public."pCleanupOOB"() OWNER TO postgres;

--
-- Name: pFixMaxNum(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public."pFixMaxNum"()
    LANGUAGE plpgsql
    AS $$
DECLARE
    iCounter integer := 0;
    iClassesCount integer := 0;
    Classname varchar(100) := '';
    MaxNum smallint := 0;
    iMaxClassSpawn integer := 0;
BEGIN

	SELECT COUNT("Classname") INTO iClassesCount FROM "object_classes" WHERE Classname<>'';
	WHILE iCounter < iClassesCount LOOP
		SELECT "Classname", "MaxNum" INTO Classname, MaxNum FROM "object_classes" LIMIT 1 OFFSET iCounter;
		SELECT COUNT("Classname") INTO iMaxClassSpawn FROM object_spawns WHERE "Classname" LIKE Classname;
		IF (MaxNum > iMaxClassSpawn) THEN
			UPDATE "object_classes" SET "MaxNum" = iMaxClassSpawn WHERE "Classname" = Classname;
		END IF;
		iCounter := iCounter + 1;
	END LOOP;
END
$$;


ALTER PROCEDURE public."pFixMaxNum"() OWNER TO postgres;

--
-- Name: pMain(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public."pMain"()
    LANGUAGE plpgsql
    AS $$
DECLARE
    sInstance varchar(8) := '1';
    iVehSpawnMax integer := 487;
    iTimeoutMax integer := 450;
    iTimeout integer := 0;
    iNumVehExisting integer := 0;
    iNumClassExisting integer := 0;
    i integer := 1;
    iupdateCount integer := 0;
    rsClassname varchar(100) := '';
    rsChance double precision := 0;
    rsMaxNum smallint := 0;
    rsDamage numeric(13,5) := 0;
BEGIN
    SELECT "check" FROM "check" LIMIT 1 INTO iupdateCount;
    
    IF iupdateCount = 6 THEN CALL pCleanup(); END IF;
    IF iupdateCount = 5 THEN CALL pCleanup6(); END IF;
    IF iupdateCount = 4 THEN CALL pCleanup5(); END IF;
    IF iupdateCount = 3 THEN CALL pCleanup4(); END IF;
    IF iupdateCount = 2 THEN CALL pCleanup3(); END IF;
    IF iupdateCount = 1 THEN CALL pCleanup2(); END IF;

    SELECT COUNT(*) INTO iNumVehExisting
    FROM object_data
    WHERE "Instance" = sInstance
        AND "Classname" != 'Hedgehog_DZ' AND "Classname" != 'Wire_cat1'
        AND "Classname" != 'Sandbag1_DZ' AND "Classname" != 'TrapBear'
        AND "Classname" != 'TentStorage' AND "Classname" != 'TentStorageR'
        AND "Classname" != 'wooden_shed_lvl_1' AND "Classname" != 'log_house_lvl_2'
        AND "Classname" != 'wooden_house_lvl_3' AND "Classname" != 'large_shed_lvl_1'
        AND "Classname" != 'small_house_lvl_2' AND "Classname" != 'big_house_lvl_3'
        AND "Classname" != 'small_garage' AND "Classname" != 'big_garage'
        AND "Classname" != 'object_x';

    WHILE iNumVehExisting < iVehSpawnMax LOOP
        SELECT "Classname", "Chance", "MaxNum", "Damage"
        INTO rsClassname, rsChance, rsMaxNum, rsDamage
        FROM object_classes ORDER BY random() LIMIT 1;

        SELECT COUNT(*) INTO iNumClassExisting
        FROM object_data
        WHERE "Instance" = sInstance AND "Classname" = rsClassname;

        IF iNumClassExisting < rsMaxNum THEN
            IF rndspawn(rsChance) = 1 THEN
                INSERT INTO object_data ("ObjectUID", "Instance", "Classname", "Damage", "CharacterID", "Worldspace", "Inventory", "Hitpoints", "Fuel", "Datestamp")
                    SELECT OS."ObjectUID", '1', OC."Classname", random(), NULL, OS."Worldspace", '[]', OC."Hitpoints", random(), NOW()
                    FROM object_spawns OS
                    INNER JOIN object_classes OC ON OS."Classname" = OC."Classname"
                    WHERE OC."Classname" = rsClassname
                    AND OS."ObjectUID" NOT IN (SELECT "ObjectUID" FROM object_data WHERE "Instance" = sInstance)
                    ORDER BY random() LIMIT 1;

                SELECT COUNT(*) INTO iNumVehExisting
                FROM object_data
                WHERE "Instance" = sInstance
                    AND "Classname" != 'Hedgehog_DZ' AND "Classname" != 'Wire_cat1'
                    AND "Classname" != 'Sandbag1_DZ' AND "Classname" != 'TrapBear'
                    AND "Classname" != 'TentStorage' AND "Classname" != 'TentStorageR'
                    AND "Classname" != 'wooden_shed_lvl_1' AND "Classname" != 'log_house_lvl_2'
                    AND "Classname" != 'wooden_house_lvl_3' AND "Classname" != 'large_shed_lvl_1'
                    AND "Classname" != 'small_house_lvl_2' AND "Classname" != 'big_house_lvl_3'
                    AND "Classname" != 'small_garage' AND "Classname" != 'big_garage'
                    AND "Classname" != 'object_x';

                SELECT COUNT(*) INTO iNumClassExisting
                FROM object_data
                WHERE "Instance" = sInstance AND "Classname" = rsClassname;
            END IF;
        END IF;

        iTimeout := iTimeout + 1;
        IF iTimeout >= iTimeoutMax THEN
            iNumVehExisting := iVehSpawnMax;
        END IF;
    END LOOP;
    i := i + 1;
END
$$;


ALTER PROCEDURE public."pMain"() OWNER TO postgres;

--
-- Name: pMoveDead(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public."pMoveDead"()
    LANGUAGE plpgsql
    AS $$
DECLARE
    iNumVehExisting integer := 0;
    iPlayerUID integer := 1;
    rsMaxNum integer := 0;
    nPlayerUID varchar(20) := '';
    numPlayerUID integer := 0;
    nCharacterID integer := 0;
BEGIN  
	
	SELECT count(DISTINCT "PlayerUID") 
		INTO rsMaxNum
		FROM "character_data" 
		WHERE "Alive" = '0';
	
	WHILE iPlayerUID < rsMaxNum LOOP
	
		SELECT DISTINCT "PlayerUID"
			INTO nPlayerUID
			FROM "character_data" 
			WHERE "Alive" = '0' 
			ORDER BY "PlayerUID" LIMIT 1 OFFSET iPlayerUID;

		SELECT count("PlayerUID") 
			INTO numPlayerUID
			FROM "character_data" 
			WHERE "Alive" = '0' 
			AND "PlayerUID"=nPlayerUID;
		
		IF (numPlayerUID>1) THEN 
			SELECT "CharacterID"
				INTO nCharacterID
				FROM "character_data" 
				WHERE "Alive" = '0' 
				AND "PlayerUID"=nPlayerUID  
				ORDER BY "Datetime" DESC LIMIT 1 OFFSET 1;
	
			INSERT INTO "character_data_dead" (CharacterID,PlayerUID,Alive,InstanceID,Worldspace,Inventory,Backpack,Medical,Generation,Datestamp,LastLogin,LastAte,LastDrank,Humanity,KillsZ,HeadshotsZ,distanceFoot,duration,currentState,KillsH,KillsB,Model,Datetime) 
				SELECT CharacterID,PlayerUID,Alive,InstanceID,Worldspace,Inventory,Backpack,Medical,Generation,Datestamp,LastLogin,LastAte,LastDrank,Humanity,KillsZ,HeadshotsZ,distanceFoot,duration,currentState,KillsH,KillsB,Model,Datetime 
				FROM "character_data" WHERE "Alive" = '0' AND "PlayerUID"=nPlayerUID AND "CharacterID" <> nCharacterID;
			
			DELETE FROM "character_data" WHERE "Alive" = '0' AND "PlayerUID"=nPlayerUID AND "CharacterID" <> nCharacterID; 
		END IF;
	iPlayerUID := iPlayerUID + 1;

	END LOOP;

END
$$;


ALTER PROCEDURE public."pMoveDead"() OWNER TO postgres;

--
-- Name: pSpawn(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public."pSpawn"()
    LANGUAGE plpgsql
    AS $$
DECLARE
    bSpawned smallint := 0;
    iLID integer := 0;
BEGIN

    WHILE bSpawned = 0 LOOP
        iLID := LAST_INSERT_ID();
        INSERT INTO "object_data" (ObjectUID, Instance,Classname, Damage, CharacterID, Worldspace, Inventory, Hitpoints, Fuel, Datestamp)
        SELECT ot.ObjectUID, '1', ot.Classname, ot.Damage, '0', ot.Worldspace, '[]', ot.Hitpoints, '0.01', NOW()
            FROM (SELECT oc.Classname, oc.Chance, oc.MaxNum, oc.Damage, oc.Hitpoints, os.ObjectUID, os.Worldspace
                FROM object_classes AS oc
                INNER JOIN "object_spawns" AS os
                ON oc.Classname = os.Classname
                ORDER BY random()) AS ot
            WHERE NOT EXISTS (SELECT od.ObjectUID
                            FROM "object_data" AS od
                            WHERE ot.ObjectUID = od.ObjectUID)
            AND fGetClassCount(ot.Classname) < ot.MaxNum
            AND fGetSpawnFromChance(ot.Chance) = 1
            LIMIT 1;
          

            IF (LAST_INSERT_ID() <> iLID) THEN
                bSpawned := 1;
            END IF;
    END LOOP;
END
$$;


ALTER PROCEDURE public."pSpawn"() OWNER TO postgres;

--
-- Name: rndspawn(double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rndspawn(chance double precision) RETURNS smallint
    LANGUAGE plpgsql
    AS $$
DECLARE
    bspawn smallint := 0;
BEGIN
    IF (random() <= chance) THEN
        bspawn := 1;
    END IF;
    RETURN bspawn;
END
$$;


ALTER FUNCTION public.rndspawn(chance double precision) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Character_DATA; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Character_DATA" (
    "CharacterID" bigint CONSTRAINT "character_data_CharacterID_not_null" NOT NULL,
    "PlayerUID" character varying(20) DEFAULT ''::character varying CONSTRAINT "character_data_PlayerUID_not_null" NOT NULL,
    "Alive" smallint DEFAULT '1'::smallint CONSTRAINT "character_data_Alive_not_null" NOT NULL,
    "InstanceID" smallint CONSTRAINT "character_data_InstanceID_not_null" NOT NULL,
    "Worldspace" character varying(128) DEFAULT '[]'::character varying CONSTRAINT "character_data_Worldspace_not_null" NOT NULL,
    "Inventory" text CONSTRAINT "character_data_Inventory_not_null" NOT NULL,
    "Backpack" text CONSTRAINT "character_data_Backpack_not_null" NOT NULL,
    "Medical" character varying(300) DEFAULT '[]'::character varying CONSTRAINT "character_data_Medical_not_null" NOT NULL,
    "Generation" integer DEFAULT 0 CONSTRAINT "character_data_Generation_not_null" NOT NULL,
    "Datestamp" timestamp without time zone,
    "LastLogin" timestamp without time zone,
    "LastAte" timestamp without time zone,
    "LastDrank" timestamp without time zone,
    "Humanity" integer,
    "KillsZ" integer DEFAULT 0 CONSTRAINT "character_data_KillsZ_not_null" NOT NULL,
    "HeadshotsZ" integer DEFAULT 0 CONSTRAINT "character_data_HeadshotsZ_not_null" NOT NULL,
    "DistanceFoot" bigint DEFAULT '0'::bigint CONSTRAINT "character_data_distanceFoot_not_null" NOT NULL,
    "Duration" integer DEFAULT 0 CONSTRAINT character_data_duration_not_null NOT NULL,
    "CurrentState" character varying(128) DEFAULT '[]'::character varying CONSTRAINT "character_data_currentState_not_null" NOT NULL,
    "KillsH" integer DEFAULT 0 CONSTRAINT "character_data_KillsH_not_null" NOT NULL,
    "KillsB" integer DEFAULT 0 CONSTRAINT "character_data_KillsB_not_null" NOT NULL,
    "Model" character varying(50) DEFAULT '"Survivor1_DZ"'::character varying CONSTRAINT "character_data_Model_not_null" NOT NULL,
    "Datetime" timestamp without time zone
);


ALTER TABLE public."Character_DATA" OWNER TO postgres;

--
-- Name: Deployable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Deployable" (
    id integer CONSTRAINT deployable_id_not_null NOT NULL,
    class_name character varying(100) DEFAULT NULL::character varying
);


ALTER TABLE public."Deployable" OWNER TO postgres;

--
-- Name: Object_DATA; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Object_DATA" (
    "ObjectID" bigint CONSTRAINT "object_data_ObjectID_not_null" NOT NULL,
    "ObjectUID" bigint,
    "Instance" integer,
    "Classname" character varying(32) DEFAULT NULL::character varying,
    "Damage" numeric(13,5) DEFAULT NULL::numeric,
    "CharacterID" bigint,
    "Worldspace" character varying(64) DEFAULT NULL::character varying,
    "Inventory" text,
    "Hitpoints" character varying(999) DEFAULT NULL::character varying,
    "Fuel" numeric(13,5) DEFAULT NULL::numeric,
    "Datestamp" timestamp without time zone
);


ALTER TABLE public."Object_DATA" OWNER TO postgres;

--
-- Name: Object_classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Object_classes" (
    "Classname" character varying(32) DEFAULT ''::character varying CONSTRAINT "object_classes_Classname_not_null" NOT NULL,
    "Chance" character varying(4) DEFAULT '0'::character varying CONSTRAINT "object_classes_Chance_not_null" NOT NULL,
    "MaxNum" smallint DEFAULT '0'::smallint CONSTRAINT "object_classes_MaxNum_not_null" NOT NULL,
    "Damage" character varying(20) DEFAULT '0'::character varying CONSTRAINT "object_classes_Damage_not_null" NOT NULL,
    "Hitpoints" character varying(999) DEFAULT '[]'::character varying CONSTRAINT "object_classes_Hitpoints_not_null" NOT NULL
);


ALTER TABLE public."Object_classes" OWNER TO postgres;

--
-- Name: Object_spawns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Object_spawns" (
    "ObjectUID" character varying(20) DEFAULT ''::character varying CONSTRAINT "object_spawns_ObjectUID_not_null" NOT NULL,
    "Classname" character varying(32) DEFAULT NULL::character varying,
    "Worldspace" character varying(64) DEFAULT NULL::character varying,
    "Description" character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public."Object_spawns" OWNER TO postgres;

--
-- Name: Player_DATA; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Player_DATA" (
    "PlayerUID" character varying(20) DEFAULT ''::character varying CONSTRAINT "player_data_PlayerUID_not_null" NOT NULL,
    "PlayerName" character varying(128) DEFAULT ''::character varying CONSTRAINT "player_data_PlayerName_not_null" NOT NULL,
    "PlayerMorality" integer,
    "PlayerSex" smallint,
    "Datetime" timestamp without time zone
);


ALTER TABLE public."Player_DATA" OWNER TO postgres;

--
-- Name: Player_LOGIN; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Player_LOGIN" (
    "ID" bigint CONSTRAINT "player_login_ID_not_null" NOT NULL,
    "PlayerUID" character varying(20) DEFAULT ''::character varying,
    "CharacterID" integer,
    "Action" smallint DEFAULT '0'::smallint CONSTRAINT "player_login_Action_not_null" NOT NULL,
    "Datestamp" timestamp without time zone
);


ALTER TABLE public."Player_LOGIN" OWNER TO postgres;

--
-- Name: character_data_CharacterID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Character_DATA" ALTER COLUMN "CharacterID" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."character_data_CharacterID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: character_data_dead; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.character_data_dead (
    "CharacterID" bigint NOT NULL,
    "PlayerUID" character varying(20) DEFAULT ''::character varying NOT NULL,
    "Alive" smallint DEFAULT '1'::smallint NOT NULL,
    "InstanceID" smallint NOT NULL,
    "Worldspace" character varying(128) DEFAULT '[]'::character varying NOT NULL,
    "Inventory" text NOT NULL,
    "Backpack" text NOT NULL,
    "Medical" character varying(300) DEFAULT '[]'::character varying NOT NULL,
    "Generation" integer DEFAULT 0 NOT NULL,
    "Datestamp" timestamp without time zone,
    "LastLogin" timestamp without time zone,
    "LastAte" timestamp without time zone,
    "LastDrank" timestamp without time zone,
    "Humanity" integer,
    "KillsZ" integer DEFAULT 0 NOT NULL,
    "HeadshotsZ" integer DEFAULT 0 NOT NULL,
    "distanceFoot" bigint DEFAULT '0'::bigint NOT NULL,
    duration integer DEFAULT 0 NOT NULL,
    "currentState" character varying(128) DEFAULT '[]'::character varying NOT NULL,
    "KillsH" integer DEFAULT 0 NOT NULL,
    "KillsB" integer DEFAULT 0 NOT NULL,
    "Model" character varying(50) DEFAULT '"Survivor1_DZ"'::character varying NOT NULL,
    "Datetime" timestamp without time zone
);


ALTER TABLE public.character_data_dead OWNER TO postgres;

--
-- Name: character_data_dead_CharacterID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.character_data_dead ALTER COLUMN "CharacterID" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."character_data_dead_CharacterID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: check; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."check" (
    "check" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."check" OWNER TO postgres;

--
-- Name: dbver; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dbver (
    version integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.dbver OWNER TO postgres;

--
-- Name: object_data_ObjectID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Object_DATA" ALTER COLUMN "ObjectID" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."object_data_ObjectID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: player_login_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Player_LOGIN" ALTER COLUMN "ID" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."player_login_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: character_data_dead character_data_dead_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.character_data_dead
    ADD CONSTRAINT character_data_dead_pkey PRIMARY KEY ("CharacterID", "PlayerUID");


--
-- Name: Character_DATA character_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Character_DATA"
    ADD CONSTRAINT character_data_pkey PRIMARY KEY ("CharacterID", "PlayerUID");


--
-- Name: check check_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."check"
    ADD CONSTRAINT check_pkey PRIMARY KEY ("check");


--
-- Name: dbver dbver_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dbver
    ADD CONSTRAINT dbver_pkey PRIMARY KEY (version);


--
-- Name: Deployable deployable_class_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Deployable"
    ADD CONSTRAINT deployable_class_name_key UNIQUE (class_name);


--
-- Name: Deployable deployable_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Deployable"
    ADD CONSTRAINT deployable_pkey PRIMARY KEY (id);


--
-- Name: Object_classes object_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Object_classes"
    ADD CONSTRAINT object_classes_pkey PRIMARY KEY ("Classname");


--
-- Name: Object_DATA object_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Object_DATA"
    ADD CONSTRAINT object_data_pkey PRIMARY KEY ("ObjectID");


--
-- Name: Object_spawns object_spawns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Object_spawns"
    ADD CONSTRAINT object_spawns_pkey PRIMARY KEY ("ObjectUID");


--
-- Name: Player_DATA player_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Player_DATA"
    ADD CONSTRAINT player_data_pkey PRIMARY KEY ("PlayerUID");


--
-- Name: Player_LOGIN player_login_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Player_LOGIN"
    ADD CONSTRAINT player_login_pkey PRIMARY KEY ("ID");


--
-- PostgreSQL database dump complete
--

\unrestrict OgD3hoNJWtIDHLdAMO5JJUXtwCna6mOieofm6Y30ppFAoWDsc3fZP8nKjZbcsaT


