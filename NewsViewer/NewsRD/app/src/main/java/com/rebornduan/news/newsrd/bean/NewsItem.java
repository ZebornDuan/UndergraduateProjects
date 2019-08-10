package com.rebornduan.news.newsrd.bean;

import android.os.MessageQueue;

/**
 * Created by Administrator on 2017/8/29 0029.
 */

public class NewsItem {
    private String title;
    private String introduction;
    private String source;
    private String time;
    private String coverUrl;
    private String ID;
    private String Url;

    public NewsItem(String title, String introduction, String source, String time, String coverUrl, String ID,String url) {
        this.title = title;
        this.introduction = introduction;
        this.source = source;
        this.time = time;
        this.coverUrl = coverUrl;
        this.ID = ID;
        this.Url = url;
    }

    public NewsItem() {
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getIntroduction() {
        return introduction;
    }

    public String getID() {
        return ID;
    }

    public void setID(String ID) {
        this.ID = ID;
    }

    public String getUrl() {
        return Url;
    }

    public void setUrl(String url) {
        Url = url;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getCoverUrl() {
        return coverUrl;
    }

    public void setCoverUrl(String coverUrl) {
        this.coverUrl = coverUrl;
    }

    @Override
    public String toString() {
        return "NewsItem{" +
                "title='" + title + '\'' +
                ", introduction='" + introduction + '\'' +
                ", source='" + source + '\'' +
                ", time='" + time + '\'' +
                '}';
    }
}
