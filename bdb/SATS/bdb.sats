%{# #include <db.h> %}
abst@ype bdb_dbtype_t = $extype "DBTYPE"
abst@ype bdb_db_t = $extype "DB *"
abst@ype bdb_dbt_t = $extype "DBT *"
abst@ype bdb_dbc_t = $extype "DBC *"

macdef DB_BTREE = $extval (bdb_dbtype_t, "DB_BTREE")
macdef DB_HASH = $extval (bdb_dbtype_t, "DB_HASH")
macdef DB_RECNO = $extval (bdb_dbtype_t, "DB_RECNO")
macdef DB_QUEUE = $extval (bdb_dbtype_t, "DB_QUEUE")
macdef DB_UNKNOWN = $extval (bdb_dbtype_t, "DB_UNKNOWN")
        
macdef DB_AUTO_COMMIT = $extval (uint,"DB_AUTO_COMMIT")
macdef DB_CREATE = $extval (uint,"DB_CREATE")
macdef DB_EXCL = $extval (uint,"DB_EXCL")
macdef DB_MULTIVERSION = $extval (uint,"DB_MULTIVERSION")
macdef DB_NOMMAP = $extval (uint,"DB_NOMMAP")
macdef DB_RDONLY = $extval (uint,"DB_RDONLY")
macdef DB_READ_UNCOMMITTED = $extval (uint,"DB_READ_UNCOMMITTED")
macdef DB_THREAD = $extval (uint ,"DB_THREAD")
macdef DB_TRUNCATE = $extval (uint,"DB_TRUNCATE")
macdef DB_AFTER  = $extval (uint,"DB_AFTER")
macdef DB_APPEND = $extval (uint,"DB_APPEND")
macdef DB_BEFORE = $extval (uint,"DB_BEFORE")
macdef DB_CONSUME = $extval (uint,"DB_CONSUME")
macdef DB_CONSUME_WAIT	= $extval (uint,"DB_CONSUME_WAIT")
macdef DB_CURRENT = $extval (uint,"DB_CURRENT")
macdef DB_FIRST = $extval (uint,"DB_FIRST")
macdef DB_GET_BOTH = $extval (uint,"DB_GET_BOTH")
macdef DB_GET_BOTHC = $extval (uint,"DB_GET_BOTHC")
macdef DB_GET_BOTH_RANGE = $extval (uint,"DB_GET_BOTH_RANGE")
macdef DB_GET_RECNO = $extval (uint,"DB_GET_RECNO")
macdef DB_JOIN_ITEM = $extval (uint,"DB_JOIN_ITEM")
macdef DB_KEYFIRST = $extval (uint,"DB_KEYFIRST")
macdef DB_KEYLAST = $extval (uint,"DB_KEYLAST")
macdef DB_LAST	= $extval (uint,"DB_LAST")
macdef DB_NEXT	= $extval (uint,"DB_NEXT")
macdef DB_NEXT_DUP = $extval (uint,"DB_NEXT_DUP")
macdef DB_NEXT_NODUP = $extval (uint,"DB_NEXT_NODUP")
macdef DB_NODUPDATA = $extval (uint,"DB_NODUPDATA")
macdef DB_NOOVERWRITE = $extval (uint,"DB_NOOVERWRITE")
macdef DB_NOSYNC = $extval (uint,"DB_NOSYNC")
macdef DB_POSITION = $extval (uint,"DB_POSITION")
macdef DB_PREV	= $extval (uint,"DB_PREV")
macdef DB_PREV_DUP = $extval (uint,"DB_PREV_DUP")
macdef DB_PREV_NODUP = $extval (uint,"DB_PREV_NODUP")
macdef DB_SET = $extval (uint,"DB_SET")
macdef DB_SET_RANGE = $extval (uint,"DB_SET_RANGE")
macdef DB_SET_RECNO = $extval (uint,"DB_SET_RECNO")
macdef DB_UPDATE_SECONDARY = $extval (uint,"DB_UPDATE_SECONDARY")
macdef DB_WRITECURSOR = $extval (uint,"DB_WRITECURSOR")
macdef DB_WRITELOCK = $extval (uint,"DB_WRITELOCK")
macdef DB_KEYEXIST = $extval (uint,"DB_KEYEXIST")
macdef DB_NOFLAGS = uint_of_int(0)
macdef DB_SUCCESS = 0
exception BDB_OPEN_FAILED

fun bdb_dbt_create(size:int):bdb_dbt_t = "bdb_dbt_create_extern";
fun bdb_create(): bdb_db_t = "bdb_create_extern" 
fun bdb_open(db:bdb_db_t,file:string,db_type:bdb_dbtype_t,flags:uint): int = "bdb_open_extern" 
fun bdb_close(db:bdb_db_t,flags:uint): int = "bdb_close_extern" 
fun bdb_set_flags(db:bdb_db_t, flags:uint):int =  "bdb_set_flags_extern"
fun bdb_dbt_set_uint(value:uint): bdb_dbt_t = "bdb_dbt_set_uint_extern"
fun bdb_dbt_set_string(value: string): bdb_dbt_t = "bdb_dbt_set_string_extern"
fun bdb_dbt_get_uint(dbt: bdb_dbt_t): uint = "bdb_dbt_get_uint_extern"
fun bdb_dbt_get_string(dbt: bdb_dbt_t): string = "bdb_dbt_get_string_extern"
fun bdb_get(db:bdb_db_t,key:bdb_dbt_t,data:bdb_dbt_t,flags:uint): int = "bdb_get_extern"
fun bdb_pget(db:bdb_db_t,key:bdb_dbt_t,pkey:bdb_dbt_t,data:bdb_dbt_t,flags:uint):int = "bdb_pget_extern"
fun bdb_put(db:bdb_db_t,key:bdb_dbt_t,data:bdb_dbt_t,flags:uint): int = "bdb_put_extern"
fun bdb_del(bd:bdb_db_t, key:bdb_dbt_t, flags:uint):int = "bdb_del_extern"
fun bdb_cursor(db:bdb_db_t, flags: uint):bdb_dbc_t = "bdb_cursor_extern"
fun bdb_cursor_close(cursor: bdb_dbc_t):int = "bdb_cursor_close_extern"
fun bdb_cursor_get(cursor:bdb_dbc_t, key:bdb_dbt_t, data:bdb_dbt_t, flags:uint):int ="bdb_cursor_get_extern"
fun bdb_cursor_getn(cursor:bdb_dbc_t, key:bdb_dbt_t, pkey:bdb_dbt_t, data:bdb_dbt_t, flags:uint):int =" bdb_cursor_pget_extern"
fun bdb_cursor_put(cursor:bdb_dbc_t, key:bdb_dbt_t, data:bdb_dbt_t, flags:uint):int ="bdb_cursor_put_extern"
fun bdb_db_ok(db:bdb_db_t):<>bool = "bdb_db_ok_extern"
fun bdb_cursor_ok(db:bdb_dbc_t):<>bool = "bdb_cursor_ok_extern"
fun bdb_del(DBcursor:bdb_dbc_t, flags:uint):int = "bdb_cursor_del_extern"
fun bdb_cursor_count(DBcursor:bdb_dbc_t):int = "bdb_cursor_count_extern"