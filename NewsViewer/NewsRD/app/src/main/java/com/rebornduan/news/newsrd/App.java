package com.rebornduan.news.newsrd;

/**
 * Created by Administrator on 2017/9/3 0003.
 */

import android.app.Application;

import cc.duduhuo.applicationtoast.AppToast;
import com.rebornduan.news.newsrd.bean.DBHelper;

public class App extends Application {
    public static DBHelper helper;
    public static boolean begin;
    @Override
    public void onCreate() {
        super.onCreate();
        AppToast.init(this);
        helper = new DBHelper(this);
        begin = true;
    }
}