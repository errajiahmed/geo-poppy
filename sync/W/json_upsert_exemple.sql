--requete de base pour récupérer un record set de la table sauv_data (attention une seulle ligne dans la table)
SELECT * from json_populate_recordset(null::inventaire_gps,(select sauv from sauv_data))

--affiche un tableau avec juste les champs
SELECT * from json_populate_recordset(null::inventaire_gps,(select sauv from sauv_data)) LIMIT 0;

-- test upsert : working
INSERT INTO public.inventaire_gps SELECT * FROM json_populate_recordset(null::public.inventaire_gps,'[{"ig_id":7076,"ig_date":"2016-04-26","ig_buffer":3000,"ig_cla_id":57,"ig_id_plante":61,"geom":"01010000206A080000DCF992BA0BF21A41F681E82974195941","ig_terrain_id":3,"gid":null,"ope_id":27}]') ON CONFLICT (ig_id)
 DO UPDATE set (ig_id,ig_date,ig_buffer,ig_cla_id,ig_id_plante,geom,ig_terrain_id,gid,ope_id) = (EXCLUDED.ig_id, EXCLUDED.ig_date, EXCLUDED.ig_buffer, EXCLUDED.ig_cla_id, EXCLUDED.ig_id_plante, EXCLUDED.geom, EXCLUDED.ig_terrain_id, EXCLUDED.gid, EXCLUDED.ope_id );

--extract array to json element
 select json_array_elements(sauv) from sauv_data

-- liste des champs dans un tableau
select json_object_keys('{"ig_id":7076,"ig_date":"2016-04-26","ig_buffer":3000,"ig_cla_id":57,"ig_id_plante":61,"geom":"01010000206A080000DCF992BA0BF21A41F681E82974195941","ig_terrain_id":3,"gid":null,"ope_id":27}')
-- liste des champs dans un tableau
select json_object_keys((select json_array_elements(sauv) from sauv_data)) j

----------------------------------------------------------------------------------------------------------------------
-----liste des champs sous la forme d'une ligne séparé par des virgules.
select string_agg(s.j, ' , ') from (select json_object_keys((select json_array_elements(sauv) from sauv_data)) j ) s
-----------------------------------------------------------------------------------------------------------------------

--base extract: [{"cla_id":5,"cla_transect2":"1-10-test","cla_gps2":null,"cla_moy_gps":null}]
select json_array_elements(sauv) from sauv_data 
--rajoute ' avt & aps []
select json_array_elements('[{"cla_id":5,"cla_transect2":"1-10-test","cla_gps2":null,"cla_moy_gps":null}]') 
-- là ça marche: "cla_id , cla_transect2 , cla_gps2 , cla_moy_gps"
select string_agg(s.j, ',') from (select json_object_keys((select json_array_elements('[{"cla_id":5,"cla_transect2":"1-10-test","cla_gps2":null,"cla_moy_gps":null}]'))) j ) s 
--rajouter des ()
select '('|| string_agg(s.j, ',') || ')' from (select json_object_keys((select json_array_elements('[{"cla_id":5,"cla_transect2":"1-10-test","cla_gps2":null,"cla_moy_gps":null}]'))) j ) s;
select '(EXCLUDED.'|| string_agg(s.j, ',EXCLUDED.') || ')' from (select json_object_keys((select json_array_elements('[{"cla_id":5,"cla_transect2":"1-10-test","cla_gps2":null,"cla_moy_gps":null}]'))) j ) s 

--créer une entrée From pour l'insérer dans le replay.sql
select e.ts, string_agg(e.json, ',') f,								  --list of fields for update
	 string_agg(e.json,',EXCLUDED.') g 									    --list of fileds for update + EXCLUDED.
	 from (select ts, json_object_keys(d.json) json	--list fields on json
	      from 
	      (select ts, json_array_elements(sauv) json--read ts & json array
	       from sauv_data) d 
	     ) e
	 group by e.ts
	 
--test pour insertion dans repaly.sql
SELECT distinct 												--for grouping
	CASE	
WHEN action1 = 'UPDATE' THEN 											--Writes the data update procedure
		'INSERT INTO '||s.schema_bd||'.'||s.tbl
		||' SELECT * FROM json_populate_recordset(null::'||schema_bd||'.'||tbl||','''||sauv||''')'	--json
		||' ON CONFLICT ('||s.pk||') DO UPDATE set ('||f.f||') = (EXCLUDED.'||f.g||');'			-- list of fields	
	END
FROM 	sauv_data s, 												--CALL the sauv_data table
	(select e.ts, string_agg(e.json, ',') f,								--list of fields for update
	 string_agg(e.json,',EXCLUDED.') g 									--list of fileds for update + EXCLUDED.
	 from (select ts, json_object_keys(d.json) json								--list fields on json
	      from 
	      (select ts, json_array_elements(sauv) json 							--read ts & json array
	       from sauv_data) d 
	     ) e
	 group by e.ts) f 											--CALL list of fields


--test replay sur une ligne: working
INSERT INTO public.inventaire_gps SELECT * FROM json_populate_recordset(null::public.inventaire_gps,'[{"ig_id":7076,"ig_date":"2016-04-26","ig_buffer":3000,"ig_cla_id":57,"ig_id_plante":61,"geom":"01010000206A080000DCF992BA0BF21A41F681E82974195941","ig_terrain_id":3,"gid":null,"ope_id":27}]') ON CONFLICT (ig_id) DO UPDATE set (ig_id,ig_date,ig_buffer,ig_cla_id,ig_id_plante,geom,ig_terrain_id,gid,ope_id)=(EXCLUDED.ig_id,EXCLUDED.ig_date,EXCLUDED.ig_buffer,EXCLUDED.ig_cla_id,EXCLUDED.ig_id_plante,EXCLUDED.geom,EXCLUDED.ig_terrain_id,EXCLUDED.gid,EXCLUDED.ope_id);
