package com.rebornduan.news.newsrd.listener;

/**
 * Created by Administrator on 2017/8/29 0029.
 */

import java.util.List;
import com.rebornduan.news.newsrd.bean.NewsItem;

public interface onGetNewsListener {
    void getItems(List<NewsItem> items);

    void onFailure();

    void noMore(List<NewsItem> items);
}
