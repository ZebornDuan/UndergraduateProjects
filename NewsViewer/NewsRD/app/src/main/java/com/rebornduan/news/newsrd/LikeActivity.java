package com.rebornduan.news.newsrd;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.View;

import com.rebornduan.news.newsrd.adapter.NewsAdapter;
import com.rebornduan.news.newsrd.bean.NewsItem;
import com.rebornduan.news.newsrd.listener.onGetNewsListener;
import com.rebornduan.news.newsrd.view.DSwipeRefresh;
import com.rebornduan.news.newsrd.task.NewsItemTask;
import static cc.duduhuo.applicationtoast.AppToast.showToast;


import java.util.List;

/**
 * Created by Administrator on 2017/9/4 0004.
 */

public class LikeActivity extends AppCompatActivity implements onGetNewsListener {
    private Toolbar toolbar;
    private RecyclerView LikeView;
    private DSwipeRefresh SwipeRefresh;
    private NewsAdapter newsAdapter_;
    private boolean isLike;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setNight();
        setContentView(R.layout.activity_like);
        Intent intent = getIntent();
        isLike = intent.getBooleanExtra("isLike",true);
        toolbar = (Toolbar)findViewById(R.id.like_bar);
        initialize();
        start(isLike);
        if(!isLike) {
            toolbar.setTitle("推荐");
        }

        SwipeRefresh.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                    start(isLike);
            }
        });
    }


    private void setNight() {
        SharedPreferences preferences = getSharedPreferences("user", Context.MODE_PRIVATE);
        boolean isNight = preferences.getBoolean("isNight",false);
        if(isNight) {
            this.setTheme(R.style.NightTheme);
        }
        else {
            this.setTheme(R.style.AppTheme);
        }
    }
    @Override
    protected void onRestart() {
        super.onRestart();
        if(isLike)
            start(true);
    }

    private void initialize() {
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        toolbar.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });

        LikeView = (RecyclerView) findViewById(R.id.LikeView);
        SwipeRefresh = (DSwipeRefresh) findViewById(R.id.swipeRefreshLike);
        newsAdapter_ = new NewsAdapter(this);
        SwipeRefresh.setRecyclerViewAndAdapter(LikeView,newsAdapter_);
    }

    private void start(boolean mode) {
        NewsItemTask task = new NewsItemTask(this);
        if(mode) {
            task.execute("like");
        } else {
            task.execute("recommmend","random");
        }
        SwipeRefresh.setRefreshing(true);
    }

    @Override
    public void getItems(List<NewsItem> items) {
        SwipeRefresh.setRefreshing(false);
        newsAdapter_.setData(items);
    }

    @Override
    public void onFailure() {}

    @Override
    public void noMore(List<NewsItem> items) {
        SwipeRefresh.setRefreshing(false);
        newsAdapter_.setData(items);
        newsAdapter_.setFooterInfo("你还没有收藏哦  ╮(๑•́ ₃•̀๑)╭");
        //start(true);
//        SwipeRefresh.setRefreshing(false);
    }
}
