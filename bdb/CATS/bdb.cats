/************************************************************************/
/*                                                                      */
/*                   ats-libs Berkeley Database Binding                 */
/*                                 For                                  */
/*                         Applied Type System                          */
/*                                                                      */
/*                              Mike Maul                               */
/*                                                                      */
/************************************************************************/

/*
 *
 * Copyright (C) 2008 Mike Maul.
 *
 * Berkeley   Database   Binding  for ATS   is   free  software;  you can  
 * redistribute          it       and/or          modify    it      under
 * the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by the
 * Free Software Foundation; either version 2.1, or (at your option)  any
 * later version.
 * 
 * ATS is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
 * for more details.
 * 
 * You  should  have  received  a  copy of the GNU General Public License
 * along  with  ATS;  see the  file COPYING.  If not, please write to the
 * Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 *
 */

/* ****** ****** */
/* author:Mike Maul (mike.maul AT gmail DOT com) */
/* ****** ****** */
#ifndef __BDB_CATS
#define __BDB_CATS
#include <db.h>
#include <string.h>

typedef ats_ptr_type ats_string_type ;


/* Initialize the structure. This
 * database is not opened in an environment, 
 * so the environment pointer is NULL. */
/* bdb_int_bdb_db_pair bdb_create_extern () {
  DB *dbp;    
  int ret;
  bdb_int_bdb_db_pair pair;
  pair.atslab_0=db_create(&dbp, NULL, 0);
  pair.atslab_1=dbp;
  return pair; 
} */

DB * bdb_create_extern () {
  DB *dbp;    /* For convenience */
  int ret = db_create(&dbp, NULL, 0);
  if(0 == ret){
       return dbp;
  } else {
    return NULL;
  } 
}

ats_int_type bdb_open_extern(DB *dbp,ats_ptr_type file,DBTYPE type, ats_uint_type flags){
  return ((DB *)dbp)->open((DB *)dbp, NULL, (char *)file,NULL, type, flags, 0);
}

ats_int_type bdb_close_extern(DB *dbp,ats_uint_type flags){
  return ((DB *)dbp)->close(dbp, flags);
}

ats_int_type bdb_set_flags_extern(DB *db, ats_uint_type flags) {
  return db->set_flags(db, flags);
}

DBT* bdb_dbt_set_uint_extern(ats_uint_type val) {
  DBT *dbt=malloc(sizeof(DBT));
  /* Zero out the DBTs before using them. */
  memset(dbt, 0, sizeof(DBT));
  dbt->data = (void *)malloc(sizeof(uint));
  *(uint *)dbt->data=val;
  dbt->size = sizeof(ats_uint_type);
  return dbt;
}

ats_uint_type bdb_dbt_get_uint_extern(DBT *dbt) {
  return *((ats_uint_type *)dbt->data);
}

DBT * bdb_dbt_set_string_extern(ats_ptr_type val) {
  DBT *dbt = malloc(sizeof(DBT));
  /* Zero out the DBTs before using them. */
  memset(dbt, 0, sizeof(DBT));
  dbt->data = val;
  dbt->size = sizeof(char) * strlen((char *)val);
  return dbt;
}

DBT * bdb_dbt_create_extern(int size) {
  DBT *dbt = malloc(sizeof(DBT));
  /* Zero out the DBTs before using them. */
  memset(dbt, 0, sizeof(DBT));
  dbt->data = malloc(size);
  memset(dbt->data,0,size);
  dbt->size = 0;
  dbt->ulen = size;
  dbt->flags = DB_DBT_APPMALLOC;
  return dbt;
}


ats_ptr_type bdb_dbt_get_string_extern(DBT *dbt) {
  return dbt->data;
}

ats_int_type bdb_get_extern(DB *db,DBT *key,DBT *data,ats_uint_type flags) {
  int ret = ((DB *)db)->get(db, NULL, key, data, flags);
  return ret;
}

ats_int_type bdb_pget_extern(DB *db,DBT *key,DBT *pkey, DBT *data,ats_uint_type flags) {
  return ((DB *)db)->pget(db, NULL, key, pkey, data, flags); 
}

ats_int_type bdb_put_extern(DB *db,DBT *key,DBT *data,ats_uint_type flags) {
  return ((DB *)db)->put(db, NULL, key, data, flags);
}

ats_int_type bdb_del_extern(DB *db, DBT *key, ats_uint_type flags) {
  return db->del(db, NULL, key, flags);
}

ats_bool_type bdb_db_ok_extern(DB *a) {
  return (a != NULL);
}

DBC * bdb_cursor_extern(DB *db,ats_uint_type flags) {
  DBC *cursorp;
  if(0 == db->cursor(db,NULL, &cursorp,flags)) {
       return cursorp;
  } else {
    return NULL;
  }
}

ats_bool_type bdb_cursor_ok_extern(DBC *a) {
  return (a != NULL);
}

ats_int_type bdb_cursor_close_extern(DBC *cursorp) {
  return ((DBC *)cursorp)->close(cursorp);
}

ats_int_type bdb_cursor_get_extern(DBC *cursor,DBT *key, DBT *data, ats_uint_type flags) {
  int ret=cursor->get(cursor,key, data,  flags);
  if(ret == 0 && data->size <= 0) {
    return -1;
  }
  return ret; 
}

ats_int_type bdb_cursor_pget_extern(DBC *cursor,DBT *key, DBT *pkey, DBT *data, ats_uint_type flags) {
  return cursor->pget(cursor, key, pkey, data, flags);
}


ats_int_type bdb_cursor_put_extern(DBC *cursor, DBT *key, DBT *data, u_int32_t flags) {
  return cursor->put(cursor, key, data, flags);
}


ats_int_type bdb_cursor_del_extern(DBC *cursor, ats_uint_type flags) {
  return cursor->del(cursor, flags);
}

ats_int_type bdb_cursor_count_extern(DBC *cursor) {
  db_recno_t countp;
  int ret=cursor->count(cursor, &countp, 0);
  if (ret == DB_REP_HANDLE_DEAD || ret == DB_REP_LOCKOUT || ret == 0) {
    return 0;
  }
  return countp;
}



#endif

