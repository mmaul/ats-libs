
staload "ats-libs/bdb/SATS/bdb.sats"

(* setup a storage an ats type in this case a tuple *)
typedef int_int_pair = @(int, int)
extern typedef "int_int_pair" = int_int_pair
extern fun bdb_dbt_get_int_int_pair(dbt: bdb_dbt_t): int_int_pair  = "bdb_dbt_get_int_int_pair_extern"
extern fun bdb_dbt_set_int_int_pair(value:int_int_pair): bdb_dbt_t = "bdb_dbt_set_int_int_pair_extern"
%{
  DBT* bdb_dbt_set_int_int_pair_extern(int_int_pair val) {
    DBT *dbt=malloc(sizeof(DBT));
    memset(dbt, 0, sizeof(DBT));
    dbt->data = &val;
    dbt->size = sizeof(int_int_pair);
    return dbt;
  }

  int_int_pair bdb_dbt_get_int_int_pair_extern(DBT *dbt) {
    return *((int_int_pair *)dbt->data);
  }
%}

fun set_get_int_int_pair(db:bdb_db_t,key_s:string,value:int_int_pair):int_int_pair = 
    let
      val key = bdb_dbt_set_string("ten")
      val put_dbt = bdb_dbt_set_int_int_pair(value)
      val put_ret = bdb_put(db, key, put_dbt, DB_NOOVERWRITE)
      val get_dbt = bdb_dbt_set_int_int_pair(@(0,0))
      val get_ret=bdb_get(db, key, get_dbt, uint_of_int(0));
      val get_value = bdb_dbt_get_int_int_pair(get_dbt)
    in
      get_value
    end
      
(* Cursor Example *)
fun cursor_get_last (cursor:bdb_dbc_t,key:bdb_dbt_t,flag:uint):string = let 
    val value = bdb_dbt_create(256);
    val ret = bdb_cursor_get(cursor,key,value,flag)
  in
    if ret = 0 then
          if bdb_cursor_count(cursor) > 0 then cursor_get_last(cursor,key,DB_NEXT) else bdb_dbt_get_string(value)
    else ""
  end

fun cursor_get_last_by_uint (cursor:bdb_dbc_t,key_val:uint):string = cursor_get_last(cursor, bdb_dbt_set_uint(key_val),DB_SET)

(* db creation helper *)
fun create_db (dbname:string,db_type:bdb_dbtype_t,flags:uint):bdb_db_t = 
  let 
    val db = bdb_create()
  in 
    if bdb_db_ok(db) = false then $raise BDB_OPEN_FAILED else 
      if bdb_open(db,dbname,db_type,flags) = 0 then db else $raise BDB_OPEN_FAILED
  end

(* Excercise the wrapper *)  
implement main (argc, argv) =
  let 
      val db = create_db("my.db",DB_BTREE,DB_CREATE) (* DB_BTREE,DB_CREATE lor DB_EXCL *)
  in
    if  bdb_db_ok(db) = true then  
    let
      var key1 = bdb_dbt_set_uint(uint_of_int(10))
      var value1 = bdb_dbt_set_string("ten")
      var key2 = bdb_dbt_set_uint(uint_of_int(11))
      var value2 = bdb_dbt_set_string("eleven")
      var get_value1 = bdb_dbt_create(256)
      var get_value2 = bdb_dbt_create(256)
    in
      assert_errmsg(int_of_uint(bdb_dbt_get_uint(key1)) = 10 ,"UINT SET FAILED FAILED (value1 != 10)");
      assert_errmsg(bdb_dbt_get_string(value1) = "ten" ,"STRING SET FAILED FAILED (value1 != ten)");
      assert_errmsg(int_of_uint(bdb_dbt_get_uint(key2)) = 11 ,"UINT SET FAILED FAILED (value2 != 11)");
      assert_errmsg(bdb_dbt_get_string(value2) = "eleven" ,"STRING SET FAILED FAILED (value2 != eleven)");
      let
        var put_ret1 = bdb_put(db, key1, value1, DB_NOFLAGS);
        var put_ret2 = bdb_put(db, key2, value2, DB_NOFLAGS);
      in
        assert_errmsg(put_ret1 = DB_SUCCESS,"PUT 1 FAILED (10,ten)");
        assert_errmsg(put_ret2 = DB_SUCCESS,"PUT 2 FAILED (11,eleven)");
        let
          var get_ret1 = bdb_get(db, key1, get_value1, DB_NOFLAGS);
        in
          assert_errmsg(get_ret1 = DB_SUCCESS ,"GET 1 FAILED (ret != DB_SUCCESS)");
          assert_errmsg(bdb_dbt_get_string(get_value1) = "ten" ,"GET 1 VALUE FAILED (value != ten)");
        end;
        let
          var get_ret2 = bdb_get(db, key2, get_value2, DB_NOFLAGS);
        in
          assert_errmsg(get_ret2 = DB_SUCCESS ,"GET 2 FAILED (ret != DB_SUCCESS)");
          assert_errmsg(bdb_dbt_get_string(get_value2) = "eleven" ,"GET 2 VALUE FAILED (value != eleven)");
        end;
      end
   end;
    (* TEST cursors *)
    let
      val cursorp = bdb_cursor(db, uint_of_int(0))
    in
      assert_errmsg(cursor_get_last_by_uint(cursorp,uint_of_int(11)) = "eleven","CURSOR FAILED (value != eleven)");
      assert_errmsg( bdb_cursor_close(cursorp) = 0 ,"CURSOR CLOSE FAILED");
    end;
    (* TEST Custom storage type *)
    let
      var pair=set_get_int_int_pair(db,"TEST",@(3,6))
    in
      assert_errmsg((pair.0) = 3 && (pair.1) = 6 ,"CUSTOM STORAGE FAILED");
    end;
    (* Delete test *)
    let
      val c=bdb_close(db,DB_NOSYNC)
    in
      assert_errmsg(c=0,"DATABASE CLOSE FAILED");
      printf("BDB TEST SUCCESSFUL\n",@());
    end
    
  end;
  


(* GC initialization is done.
key: 135405792
value:ten
put ret: -30995
get value:ten , get_ret: -30995
key: 135358464
value:ten
CURSOR CLOSE:0
Test of custom storage set @(3,6) got@(3,6)
DBCLOSE:0
*)
