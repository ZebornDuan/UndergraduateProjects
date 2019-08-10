package com.rebornduan.news.newsrd;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.support.design.widget.CoordinatorLayout;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.widget.ImageView;
import android.widget.TextView;
import android.support.design.widget.CollapsingToolbarLayout;
import android.view.View;

import com.bumptech.glide.Glide;
import com.rebornduan.news.newsrd.bean.NewsDetail;
import com.rebornduan.news.newsrd.listener.onGetDetailListener;
import com.rebornduan.news.newsrd.task.NewsDetailTask;
import com.rebornduan.news.newsrd.task.DownloadTask;
import butterknife.BindView;
import android.support.v7.widget.Toolbar;
import com.rebornduan.news.newsrd.WebActivity;

import com.iflytek.cloud.InitListener;
import com.iflytek.cloud.SpeechConstant;
import com.iflytek.cloud.SpeechError;
import com.iflytek.cloud.SpeechSynthesizer;
import com.iflytek.cloud.SpeechUtility;
import com.iflytek.cloud.SynthesizerListener;

import java.util.ArrayList;
import java.util.List;

import static cc.duduhuo.applicationtoast.AppToast.showToast;
/**
 * Created by Administrator on 2017/9/1 0001.
 */


public class DetailActivity extends AppCompatActivity implements onGetDetailListener {
    private NewsDetail newsDetail;
    private FloatingActionButton fab;
    private FloatingActionButton tts;
    private TextView web;
    private TextView download;
    private TextView collect;
    private boolean islike;
    private boolean isSpeeching = false;
    private boolean isPause = false;
    private SpeechSynthesizer mTextToSpeech;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setNight();
        setContentView(R.layout.detail_activity);
        Intent intent = this.getIntent();
        String url = intent.getStringExtra("web");
        NewsDetailTask task = new NewsDetailTask(this);
        task.execute(url);
        SpeechUtility.createUtility(DetailActivity.this, "appid=59ae9a61");
        mTextToSpeech = SpeechSynthesizer.createSynthesizer(this, myInitListener);
        mTextToSpeech.setParameter(SpeechConstant.VOICE_NAME,"xiaoyan");
        //设置音调
        mTextToSpeech.setParameter(SpeechConstant.PITCH,"50");
        //设置音量
        mTextToSpeech.setParameter(SpeechConstant.VOLUME,"50");
        addListener();
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

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if(isSpeeching || isPause)
            mTextToSpeech.stopSpeaking();
    }

    private InitListener myInitListener = new InitListener() {
        @Override
        public void onInit(int code) {}
    };

    private void addListener() {
        fab = (FloatingActionButton)findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
//                Uri uri = Uri.parse(newsDetail.getImageUrl());
                Intent shareIntent = new Intent(Intent.ACTION_SEND);
                shareIntent.setType("text/*");
//                shareIntent.putExtra(Intent.EXTRA_STREAM,uri);
                shareIntent.putExtra(Intent.EXTRA_TEXT,newsDetail.getNewsUrl() + "\n" + newsDetail.getTitle());

                shareIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//                shareIntene.setData();
                startActivity(Intent.createChooser(shareIntent,"分享到"));

            }
        });

        web = (TextView)findViewById(R.id.web);
        web.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(DetailActivity.this, WebActivity.class);
                String url =  newsDetail.getNewsUrl();
                intent.putExtra("web", url);
                startActivity(intent);
            }
        });

        download = (TextView)findViewById(R.id.download);
        download.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DownloadTask task = new DownloadTask(DetailActivity.this);
                task.execute(newsDetail.getNewsUrl(),newsDetail.getId());
            }
        });

        collect = (TextView)findViewById(R.id.collect);
        collect.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(islike) {
                    App.helper.delete(newsDetail.getId());
                    showToast("取消收藏成功");
                    collect.setText("收藏");
                    islike = !islike;
                }
                else {
                    App.helper.add(newsDetail.getId());
                    showToast("添加收藏成功");
                    collect.setText("取消");
                    islike = !islike;
                }

            }
        });

        tts = (FloatingActionButton)findViewById(R.id.tts);
        tts.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                //mTextToSpeech = new SpeechSynthesizer();
                if(isSpeeching) {
                    mTextToSpeech.pauseSpeaking();
                    isPause = !isPause;
                    isSpeeching = !isSpeeching;
                }

                else{
                    if(isPause) {
                        mTextToSpeech.resumeSpeaking();
                        isPause = !isPause;
                        isSpeeching = !isSpeeching;
                    }
                    else {
                        String toRead = newsDetail.getBody();
                        int code = mTextToSpeech.startSpeaking(toRead, mTtsListener);
                        isSpeeching = !isSpeeching;
                    }
                    //mTextToSpeech.stopSpeaking();
                }
            }
        });

//        tts.setOnLongClickListener(new View.OnLongClickListener() {
//            @Override
//            public boolean onLongClick(View view) {
//                return false;
//            }
//        });
    }

    private SynthesizerListener mTtsListener = new SynthesizerListener() {
        @Override
        public void onSpeakBegin() {}
        @Override
        public void onSpeakPaused() {}
        @Override
        public void onSpeakResumed() {}
        @Override
        public void onBufferProgress(int percent, int beginPos, int endPos, String info) {}
        @Override
        public void onSpeakProgress(int percent, int beginPos, int endPos) {}
        @Override
        public void onCompleted(SpeechError error) {}
        @Override
        public void onEvent(int arg0, int arg1, int arg2, Bundle arg3) {
            // TODO Auto-generated method stub
        }
    };

    private void setView(NewsDetail news) {
        Toolbar toolbar = (Toolbar)findViewById(R.id.itoolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        toolbar.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
        CollapsingToolbarLayout dToolbarLayout = (CollapsingToolbarLayout) findViewById(R.id.toolbar_layout);
        dToolbarLayout.setTitle(news.getTitle());
        dToolbarLayout.setExpandedTitleColor(ContextCompat.getColor(this,R.color.white));
        dToolbarLayout.setCollapsedTitleTextColor(ContextCompat.getColor(this,R.color.white));
        TextView source = (TextView) findViewById(R.id.news_detail_from_tv);
        source.setText(news.getSource());
        TextView body = (TextView) findViewById(R.id.news_detail_body_tv);
        body.setText(news.getBody());
        ImageView detailPhoto = (ImageView) findViewById(R.id.news_detail_photo_iv);
        Glide.with(this).load(news.getImageUrl()).asBitmap().centerCrop().into(detailPhoto);
        islike = App.helper.search_id(newsDetail.getId());
        TextView collect_ = (TextView)findViewById(R.id.collect);
        if(islike)
            collect_.setText("取消");
    }

    @Override
    public void getDetail(NewsDetail detail) {
        this.newsDetail = detail;
        setView(newsDetail);
    }
}
