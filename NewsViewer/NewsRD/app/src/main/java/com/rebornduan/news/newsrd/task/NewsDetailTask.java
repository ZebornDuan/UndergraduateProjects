package com.rebornduan.news.newsrd.task;

import android.os.AsyncTask;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.rebornduan.news.newsrd.bean.NewsDetail;
import com.rebornduan.news.newsrd.listener.onGetDetailListener;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.URL;
import java.nio.charset.Charset;

/**
 * Created by Administrator on 2017/9/2 0002.
 */

public class NewsDetailTask extends AsyncTask<String, Void, Integer> {
    private static final int ON_SUCCESS = 0x0000;
    private static final int ON_FAILURE = 0x0001;

    private onGetDetailListener listener;
    private NewsDetail detail;

    public NewsDetailTask(onGetDetailListener listener) {
        this.listener = listener;
    }

    public static String readAll(Reader rd) throws IOException {
        StringBuilder sb = new StringBuilder();
        int x;
        while ((x = rd.read()) != -1) {
            sb.append((char) x);
        }
        return sb.toString();
    }
    @Override
    protected Integer doInBackground(String... strings) {
        String address = "http://166.111.68.66:2042/news/action/query/detail?newsId=";
        address += strings[0];
        try {
            InputStream is = new URL(address).openStream();
            BufferedReader rd = new BufferedReader(new InputStreamReader(is, Charset.forName("UTF-8")));
            String jsonText = readAll(rd);
            JsonParser parse =new JsonParser();
            JsonObject json=(JsonObject) parse.parse(jsonText);

            String time = json.get("news_Time").getAsString();
            time = time.substring(0,4) + "-" + time.substring(4,6) + "-" + time.substring(6,8);

            String title = json.get("news_Title").getAsString();
            String source = json.get("news_Author").getAsString() + " "
                    +json.get("news_Journal").getAsString() + " " +time;
            String text =  json.get("news_Title").getAsString() + "\n\n" +
                    json.get("news_Content").getAsString();
            String url = json.get("news_Pictures").getAsString().split(";|\\s")[0];
//            String image = json.get("news_Pictures").getAsString();

            String linking = json.get("news_URL").getAsString();
            String id = json.get("news_ID").getAsString();

            detail = new NewsDetail(title,source,text,url,linking,id);

        }catch (Exception e) {}
        return ON_SUCCESS;
    }

    @Override
    protected void onPostExecute(Integer status) {
        super.onPostExecute(status);
        if (status == ON_SUCCESS) {
            listener.getDetail(detail);
        }
    }
}