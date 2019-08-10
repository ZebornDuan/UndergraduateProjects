package com.rebornduan.news.newsrd.task;

import android.app.Activity;
import android.content.Context;
import android.os.AsyncTask;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.nio.charset.Charset;

import static cc.duduhuo.applicationtoast.AppToast.showToast;
/**
 * Created by Administrator on 2017/9/7 0007.
 */

public class DownloadTask extends AsyncTask<String,Void,Boolean> {
    private Activity activity;

    public DownloadTask(Activity activity) {
        this.activity = activity;
    }
    //    public boolean isExternalStorageWritable() {
//        String state = Environment.getExternalStorageState();
//        if(Environment.MEDIA_MOUNTED.equals(state))
//            return true;
//        return false;
//    }
//
//    public boolean isExternalStorageReadable() {
//        String state =Environment.getExternalStorageState();
//        if(Environment.MEDIA_MOUNTED.equals(state) || Environment.MEDIA_MOUNTED_READ_ONLY.equals(state)){
//            return true;
//        }
//        return false;
//    }

    @Override
    protected Boolean doInBackground(String... strings) {
//        Uri uri = Uri.parse(strings[0]);
        try {
            InputStream is = new URL(strings[0]).openStream();
            BufferedReader rd = new BufferedReader(new InputStreamReader(is, Charset.forName("UTF-8")));
            String data = NewsDetailTask.readAll(rd);

            FileOutputStream output = activity.openFileOutput(strings[1].trim() + ".txt", Context.MODE_APPEND);
            output.write(data.getBytes());
            output.close();
        }catch (Exception e) {
            return false;
        }
        return true;
    }

    @Override
    protected void onPostExecute(Boolean success) {
        super.onPostExecute(success);
        if(success)
            showToast("下载成功");
    }
}
