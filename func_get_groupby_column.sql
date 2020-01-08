CREATE OR REPLACE FUNCTION func_get_groupby_column(tbl_name varchar) 
RETURNS varchar 
AS
$BODY$
DECLARE
	tmp_attname VARCHAR;
BEGIN

	SELECT attname into tmp_attname FROM pg_attribute WHERE  attrelid = tbl_name::regclass and attname not in ('tableoid','cmax','cmin','xmax','xmin','ctid')  limit 1;	
    RETURN tmp_attname;
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE CALLED ON NULL INPUT SECURITY INVOKER;