package com.rebornduan.news.newsrd.task;

import android.os.AsyncTask;
import com.google.gson.JsonArray;
import com.google.gson.JsonIOException;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;

import com.google.gson.internal.Streams;
import com.rebornduan.news.newsrd.App;
import com.rebornduan.news.newsrd.bean.NewsItem;
import com.rebornduan.news.newsrd.listener.onGetNewsListener;
import static cc.duduhuo.applicationtoast.AppToast.showToast;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.net.URL;
import java.nio.charset.Charset;
import java.net.URLEncoder;
import android.util.Log;
/**
 * Created by Administrator on 2017/8/29 0029.
 */

public class NewsItemTask extends AsyncTask<String, Void, Integer> {
    private static final int ON_SUCCESS = 0x0000;
    private static final int ON_FAILURE = 0x0001;

    private onGetNewsListener mListener;
    private List<NewsItem> itemList = new ArrayList<>(1);

    public NewsItemTask(onGetNewsListener mListener) {
        this.mListener = mListener;
    }

    private static String readAll(Reader rd) throws IOException {
        StringBuilder sb = new StringBuilder();
        int x;
        while ((x = rd.read()) != -1) {
            sb.append((char) x);
        }
        return sb.toString();
    }

    private  String request(String address) {
        String jsonText = "";
        try {
            InputStream is = new URL(address).openStream();
            BufferedReader rd = new BufferedReader(new InputStreamReader(is, Charset.forName("UTF-8")));
            jsonText = readAll(rd);
        }catch (Exception e) {}
        return jsonText;
    }

    @Override
    protected Integer doInBackground(String... parameters) {
        itemList.clear();
        boolean image = true;
        String address = "http://166.111.68.66:2042/news/action/query/";
        int length = parameters.length;
        if(length == 1) {

            List<String> list = App.helper.query();

            for(int i = 0;i < list.size();i++) {
                String destination = "http://166.111.68.66:2042/news/action/query/detail?newsId=" + list.get(i);
                String jsonText = request(destination);
                JsonParser parse =new JsonParser();
                JsonObject json=(JsonObject) parse.parse(jsonText);

                String time = json.get("news_Time").getAsString();
                time = time.substring(0,4) + "-" + time.substring(4,6) + "-" + time.substring(6,8);

                String title = json.get("news_Title").getAsString();
                String introduction = json.get("news_Content").getAsString().trim();
                String url = json.get("news_Pictures").getAsString().split(";|\\s")[0];
                String linking = json.get("news_URL").getAsString();
                String ID = json.get("news_ID").getAsString();
                String source = json.get("news_Source").getAsString() + " "+
                        json.get("newsClassTag").getAsString();
                NewsItem new_item = new NewsItem(title,introduction,source,time,url,ID,linking);
                itemList.add(new_item);
            }
            return ON_SUCCESS;
        }

        if(length == 2) {
            Random random = new Random();
            int a = random.nextInt(100) + 20;
            int b = random.nextInt(20) + a;
            address = address + "latest?&pageNo=" +String.valueOf(a) + "&pageSize=" + String.valueOf(b);
        }

        if(length == 3) {
            try {
                parameters[0] = URLEncoder.encode(parameters[0],"UTF-8");
            }
            catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
            image = false;
            address = address +"search?keyword=" + parameters[0] + parameters[1] + parameters[2];
//            address = "http://166.111.68.66:2042/news/action/query/search?keyword=%E5%8C%97%E4%BA%AC";
//            address = "http://166.111.68.66:2042/news/action/query/search?keyword=%E5%8C%97%E4%BA%AC&pageNo=1&pageSize=10";
        }
        if(length == 4)
            address = address + parameters[0] + parameters[1] + parameters[2] + parameters[3];
        try {
            InputStream is = new URL(address).openStream();
            BufferedReader rd = new BufferedReader(new InputStreamReader(is, Charset.forName("UTF-8")));
            String jsonText = readAll(rd);
            JsonParser parse =new JsonParser();
            JsonObject json=(JsonObject) parse.parse(jsonText);

            JsonArray array = json.get("list").getAsJsonArray();

            for(int i = 0;i < array.size();i++) {
                JsonObject subObject = array.get(i).getAsJsonObject();
                String source = subObject.get("news_Source").getAsString() + " "+
                        subObject.get("newsClassTag").getAsString();
                String title = subObject.get("news_Title").getAsString();
                String time = subObject.get("news_Time").getAsString();
                time = time.substring(0,4) + "-" + time.substring(4,6) + "-" + time.substring(6,8);
                String introduction = subObject.get("news_Intro").getAsString().trim();
                String coverUrl = subObject.get("news_Pictures").getAsString().split(";|\\s")[0];
                String ID = subObject.get("news_ID").getAsString();
                String Url = subObject.get("news_URL").getAsString();

                if(coverUrl == "" && image)
                    continue;
                NewsItem new_item = new NewsItem(title,introduction,source,time,coverUrl,ID,Url);
                itemList.add(new_item);
            }

        }catch (Exception e) {
            //return ON_FAILURE;
        }

        return ON_SUCCESS;
    }

    @Override
    protected void onPostExecute(Integer status) {
        super.onPostExecute(status);
        if (status == ON_FAILURE) {
            if (mListener != null) {
                mListener.onFailure();
            }
        } else if (status == ON_SUCCESS) {
            if (itemList.size() == 0) {
                if (mListener != null) {
                    mListener.noMore(itemList);
                }
            } else {
                if (mListener != null) {
                    mListener.getItems(itemList);
                }
            }
        }
    }
}

