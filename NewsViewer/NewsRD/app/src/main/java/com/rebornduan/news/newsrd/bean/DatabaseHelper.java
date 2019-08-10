package com.rebornduan.news.newsrd.bean;

/**
 * Created by Administrator on 2017/9/3 0003.
 */

import android.content.Context;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;

public class DatabaseHelper extends SQLiteOpenHelper {

    private static final int DATABASE_VERSION = 1;
    private static final String DATABASE_NAME = "user.db";
    public static final String TABLE_NAME = "UserTable";
    public static final String TABLE_NAME2 = "OfflineTable";
    public static final String TABLE_NAME3= "History";

    public DatabaseHelper(Context context, String name, CursorFactory factory, int version, DatabaseErrorHandler errorHandler) {
        super(context, name, factory, version, errorHandler);
    }

    public DatabaseHelper(Context context, String name, CursorFactory factory, int version) {
        super(context, name, factory, version);
    }

    public DatabaseHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase sqLiteDatabase) {
        String create1 = "CREATE TABLE [" + TABLE_NAME + "] (" +
                "[_ID] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, " +
                "[URL] TEXT" +
                ")";

        String create2 = "CREATE TABLE [" + TABLE_NAME2 + "] (" +
                "[_ID] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, " +
                "[TITLE] TEXT, " + "[INTRO] TEXT, " + "[SOURCE] TEXT, " +
                "[BODY] TEXT, " + "[TIME] TEXT, " + "[URL] TEXT" + ")";

        String create3 = "CREATE TABLE [" + TABLE_NAME3 + "] (" +
                "[_ID] INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, " +
                "[URL] TEXT" +
                ")";
        sqLiteDatabase.execSQL(create1);
        //sqLiteDatabase.execSQL(create2);
        sqLiteDatabase.execSQL(create3);
    }

    @Override
    public void onUpgrade(SQLiteDatabase sqLiteDatabase, int i, int i1) {

    }

    @Override
    public void onOpen(SQLiteDatabase sqLiteDatabase) {
        super.onOpen(sqLiteDatabase);
    }
}
