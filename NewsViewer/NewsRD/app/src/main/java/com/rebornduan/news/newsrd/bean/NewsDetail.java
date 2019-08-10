package com.rebornduan.news.newsrd.bean;

/**
 * Created by Administrator on 2017/9/2 0002.
 */

public class NewsDetail {
    private String title;
    private String source;
    private String body;
    private String imageUrl;
    private String newsUrl;
    private String id;

    public NewsDetail(String title, String source, String body, String imageUrl, String newsUrl,String id) {
        this.title = title;
        this.source = source;
        this.body = body;
        this.imageUrl = imageUrl;
        this.newsUrl = newsUrl;
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getNewsUrl() {
        return newsUrl;
    }

    public void setNewsUrl(String newsUrl) {
        this.newsUrl = newsUrl;
    }
}
