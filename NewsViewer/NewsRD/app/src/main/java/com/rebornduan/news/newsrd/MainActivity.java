package com.rebornduan.news.newsrd;

import android.content.Context;
import android.content.SharedPreferences;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.rebornduan.news.newsrd.bean.NewsItem;
import com.rebornduan.news.newsrd.view.DSwipeRefresh;
import com.rebornduan.news.newsrd.listener.onGetNewsListener;
import com.rebornduan.news.newsrd.adapter.NewsAdapter;
import com.rebornduan.news.newsrd.task.NewsItemTask;

import java.util.List;

public class MainActivity extends AppCompatActivity implements onGetNewsListener{
    private EditText Keyword;
    private ImageView KeySearch;
    private RecyclerView NewsView;
    private DSwipeRefresh SwipeRefresh;
    private NewsAdapter newsAdapter_;
    private int pages = 1;
    private boolean isLoad = false;
    private String content;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setNight();
        setContentView(R.layout.activity_main);
        findView();
        setListener();
    }

    private void setNight() {
        SharedPreferences preferences = getSharedPreferences("user", Context.MODE_PRIVATE);
        boolean isNight = preferences.getBoolean("isNight",false);
        if(isNight) {
            this.setTheme(R.style.NightTheme);
            //dayNightSwitch.setChecked(true);
        }
        else {
            this.setTheme(R.style.AppTheme);
            //dayNightSwitch.setChecked(false);
        }
    }

    private void findView() {
        Keyword = (EditText) findViewById(R.id.Keyword);
        KeySearch = (ImageView) findViewById(R.id.keySearch);
        NewsView = (RecyclerView) findViewById(R.id.NewsView);
        SwipeRefresh = (DSwipeRefresh) findViewById(R.id.swipeRefresh);
        newsAdapter_ = new NewsAdapter(this);
        SwipeRefresh.setRecyclerViewAndAdapter(NewsView,newsAdapter_);
    }

    private void setListener() {
        KeySearch.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                content = Keyword.getText().toString().trim();
                if (!("".equals(content)))
                    startSearch(content);
            }
        });

        SwipeRefresh.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                NewsItemTask task = new NewsItemTask(MainActivity.this);
                pages+=1;
                startSearch(content);
            }
        });
    }

    private void startSearch(String parameters) {
        NewsItemTask task = new NewsItemTask(MainActivity.this);
        String[] target = new String[3];
        target[0] = parameters;
        target[1] = "&pageNo=" + String.valueOf(pages);
        target[2] = "&pageSize=30";
        task.execute(target);
        SwipeRefresh.setRefreshing(true);
        isLoad = false;
    }

    @Override
    public void getItems(List<NewsItem> items) {
        SwipeRefresh.setRefreshing(false);
        if (isLoad) {
            newsAdapter_.addData(items);
        } else {
            newsAdapter_.setData(items);
        }
        newsAdapter_.setFooterInfo("下拉刷新...");
    }

    @Override
    public void onFailure() {
    }

    @Override
    public void noMore(List<NewsItem> items) {
        newsAdapter_.setFooterInfo("暂时没有找到更多...");
        newsAdapter_.setData(items);
        SwipeRefresh.setRefreshing(false);
        startSearch(content);
    }
}
