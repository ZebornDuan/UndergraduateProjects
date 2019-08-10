package com.rebornduan.news.newsrd.bean;

/**
 * Created by Administrator on 2017/9/3 0003.
 */

import java.util.ArrayList;
import java.util.List;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;


public class DBHelper {
    private DatabaseHelper helper;
    private SQLiteDatabase db;

    public DBHelper(Context context) {
        helper = new DatabaseHelper(context);
        db = helper.getWritableDatabase();
    }

    public void add(String url) {
        db.beginTransaction();
        try {
            db.execSQL("INSERT INTO " + DatabaseHelper.TABLE_NAME
                    + " VALUES(null, ?)", new Object[] {url});
            db.setTransactionSuccessful();
        }
        finally {
            db.endTransaction();
        }
    }



    public void delete(String url) {
        db.delete(DatabaseHelper.TABLE_NAME, "URL == ?",
                new String[] {url});
    }

    public void closeDB() {
        db.close();
    }

    public List<String> query() {
        ArrayList<String> list = new ArrayList<>();
        Cursor c = queryTheCursor();
        while(c.moveToNext()) {
            String url = c.getString(c.getColumnIndex("URL"));
            list.add(url);
        }
        return  list;
    }

    public Boolean search_id(String id) {
        Cursor cursor = db.rawQuery("SELECT * FROM " +
                DatabaseHelper.TABLE_NAME + " WHERE URL=?",new String[] {id});
        if(cursor.moveToFirst())
            return true;
        return false;
    }

    public Cursor queryTheCursor() {
        Cursor c = db.rawQuery("SELECT * FROM " + DatabaseHelper.TABLE_NAME,
                null);
        return c;
    }

//    public Cursor queryTheCursor2() {
//        Cursor c = db.rawQuery("SELECT * FROM " + DatabaseHelper.TABLE_NAME2,
//                null);
//        return c;
//    }

//    public List<NewsDetail> query2() {
//        ArrayList<NewsDetail> list = new ArrayList<>();
//        Cursor c = queryTheCursor2();
//        while(c.moveToNext()) {
//            String title = c.getString(c.getColumnIndex("TITLE"));
//            //String intro = c.getString(c.getColumnIndex("INTRO"));
//            String source = c.getString(c.getColumnIndex("SOURCE"));
//            String body = c.getString(c.getColumnIndex("BODY"));
//            //String time = c.getString(c.getColumnIndex("TIME"));
//            String url = c.getString(c.getColumnIndex("URL"));
//            NewsDetail detail = new NewsDetail(title,source,body,"","",url);
//            list.add(detail);
//            //list.add(url);
//        }
//        return  list;
//    }
//
//    public void add2(String title,String intro,String source,String body,String time,String url) {
//        db.beginTransaction();
//        try {
//            db.execSQL("INSERT INTO " + DatabaseHelper.TABLE_NAME2
//                    + " VALUES(null, ?, ?, ?, ?, ?, ?)", new Object[] {title,intro,source,body,time,url});
//            db.setTransactionSuccessful();
//        }
//        finally {
//            db.endTransaction();
//        }
//    }

    public void add3(String url) {
        db.beginTransaction();
        try {
            db.execSQL("INSERT INTO " + DatabaseHelper.TABLE_NAME3
                    + " VALUES(null, ?)", new Object[] {url});
            db.setTransactionSuccessful();
        }
        finally {
            db.endTransaction();
        }
    }

    public Boolean search_id3(String id) {
        Cursor cursor = db.rawQuery("SELECT * FROM " +
                DatabaseHelper.TABLE_NAME3 + " WHERE URL=?",new String[] {id});
        if(cursor.moveToFirst())
            return true;
        return false;
    }
}
