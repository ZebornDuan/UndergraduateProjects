package com.rebornduan.news.newsrd;

/**
 * Created by Administrator on 2017/8/31 0031.
 */
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.ColorStateList;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.design.widget.TabLayout;
import android.support.v4.view.MenuItemCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.app.AppCompatDelegate;
import android.support.v7.widget.PopupMenu;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.SwitchCompat;
import android.support.v7.widget.Toolbar;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.design.widget.NavigationView;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.CompoundButton;

import com.rebornduan.news.newsrd.adapter.NewsAdapter;
import com.rebornduan.news.newsrd.bean.NewsItem;
import com.rebornduan.news.newsrd.listener.onGetNewsListener;
import com.rebornduan.news.newsrd.task.NewsItemTask;
import com.rebornduan.news.newsrd.view.DSwipeRefresh;
import static cc.duduhuo.applicationtoast.AppToast.showToast;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class NewsActivity extends AppCompatActivity implements onGetNewsListener {
    private DrawerLayout drawer;
    private RecyclerView NewsView;
    private DSwipeRefresh SwipeRefresh;
    private NewsAdapter newsAdapter_;
    private int pages = 1;
    private int catagory_code = 1;
    private boolean isLoad = false;
    private final String[] channels = {"科技","教育","军事","国内","社会","文化","汽车",
            "国际","体育","财经","健康","娱乐"};
    public static List<String> userList;
    public static List<String> otherList;
    public static TabLayout tab;
    private HashMap<String,Integer> map;
    private boolean isNight;
    private boolean showImage;
    private NavigationView navView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setNight();
        setContentView(R.layout.activity_news);
        if(App.begin) {
            startActivity(new Intent(NewsActivity.this,SplashActivity.class));
            App.begin = false;
        }
        initialize();
        findView();
        setListener();
        startSearch();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        saveTab();
    }

    private void saveTab() {
        SharedPreferences preferences = getSharedPreferences("user",Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();
        editor.putBoolean("isFirst",false);
        editor.putInt("titleCount",userList.size());
        for(int i = 0;i < userList.size();i++)
            editor.putString("title" + String.valueOf(i),userList.get(i));
        editor.commit();
    }

    private void findView() {
        NewsView = (RecyclerView) findViewById(R.id.NewsView);
        SwipeRefresh = (DSwipeRefresh) findViewById(R.id.swipeRefresh);
        newsAdapter_ = new NewsAdapter(this);
        SwipeRefresh.setRecyclerViewAndAdapter(NewsView,newsAdapter_);
        navView = (NavigationView) findViewById(R.id.nav_view);
    }

    //set night mode
    private void setNight() {
        SharedPreferences preferences = getSharedPreferences("user", Context.MODE_PRIVATE);
        isNight = preferences.getBoolean("isNight",false);
        showImage = preferences.getBoolean("showImage",true);
        if(isNight) {
            this.setTheme(R.style.NightTheme);
        }
        else {
            this.setTheme(R.style.AppTheme);
        }
    }

    private void initialize() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        toolbar.setOnMenuItemClickListener(onMenuItemClick);

        tab = (TabLayout)findViewById(R.id.tabs);
        userList = new ArrayList<>();
        otherList = new ArrayList<>();
        SharedPreferences preferences = getSharedPreferences("user", Context.MODE_PRIVATE);
        boolean firstTime = preferences.getBoolean("isFirst",true);
        if(firstTime) {
            userList.add("科技");
            userList.add("军事");
            userList.add("财经");
            userList.add("娱乐");
        } else {
            int counts = preferences.getInt("titleCount",4);
            for(int i = 0;i < counts;i++)
                userList.add(preferences.getString("title" + String.valueOf(i),""));
        }

        map = new HashMap<>();
        for(int i = 0;i < channels.length;i++) {
            map.put(channels[i],i + 1);
            if(!userList.contains(channels[i]))
                otherList.add(channels[i]);
        }

        drawer = (DrawerLayout) findViewById(R.id.Drawer);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.addDrawerListener(toggle);
        toggle.syncState();

        //get SwitchCompat and set listener
        navView = (NavigationView) findViewById(R.id.nav_view);
        MenuItem menuNight = navView.getMenu().findItem(R.id.nav_night_mode);
        MenuItem menuImage = navView.getMenu().findItem(R.id.noimage_mode);
        SwitchCompat dayNightSwitch = (SwitchCompat) MenuItemCompat.getActionView(menuNight);
        SwitchCompat imageShow = (SwitchCompat) MenuItemCompat.getActionView(menuImage);
        if(isNight)
            dayNightSwitch.setChecked(true);
        else
            dayNightSwitch.setChecked(false);
        if(showImage)
            imageShow.setChecked(false);
        else
            imageShow.setChecked(true);

        imageShow.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                SharedPreferences preferences = getSharedPreferences("user",Context.MODE_PRIVATE);
                SharedPreferences.Editor editor = preferences.edit();
                if(b) {
                    editor.putBoolean("showImage",false);
                    showToast("无图模式开启 刷新时不显示图片");
                }
                else{
                    editor.putBoolean("showImage",true);
                    showToast("无图模式关闭");
                }
                editor.commit();
            }
        });

        dayNightSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                SharedPreferences preferences = getSharedPreferences("user",Context.MODE_PRIVATE);
                SharedPreferences.Editor editor = preferences.edit();
                if(b) {
                    NewsActivity.this.setTheme(R.style.NightTheme);
                    editor.putBoolean("isNight",true);
                    editor.commit();
                }
                else {
                    NewsActivity.this.setTheme(R.style.AppTheme);
                    editor.putBoolean("isNight",false);
                    editor.commit();
                }
                //onDestroy();
                saveTab();
                finish();
                Intent intent = new Intent(NewsActivity.this,NewsActivity.class);
                intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK|Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);
                //drawer.openDrawer(navView);
                //recreate();
            }
        });

        for(int i = 0;i < userList.size();i++)
            tab.addTab(tab.newTab().setText(userList.get(i)));
        tab.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                String catagory = tab.getText().toString();
                pages = 1;
                catagory_code = map.get(catagory);
                startSearch();
            }
            @Override
            public void onTabUnselected(TabLayout.Tab tab) {}
            @Override
            public void onTabReselected(TabLayout.Tab tab) {}
        });

        ImageView addChannel = (ImageView)findViewById(R.id.add_channel_iv);
        addChannel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(NewsActivity.this,AddActivity.class);
                startActivity(intent);
            }
        });
    }

    public static void changeTab() {
        tab.removeAllTabs();
        for(int i = 0;i < userList.size();i++)
            tab.addTab(tab.newTab().setText(userList.get(i)));
    }



    //set toolbar menu
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_news,menu);
        return true;
    }

    //toolbar menu item clicked event
    private Toolbar.OnMenuItemClickListener onMenuItemClick = new Toolbar.OnMenuItemClickListener() {
        @Override
        public boolean onMenuItemClick(MenuItem menuItem) {
            Intent intent = new Intent();
            intent.setClass(NewsActivity.this,MainActivity.class);
            startActivity(intent);
            return true;
        }
    };

    private void setListener() {
        SwipeRefresh.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                pages++;
                startSearch();
            }
        });

        SwipeRefresh.setOnLoadingListener(new DSwipeRefresh.OnLoadingListener() {
            @Override
            public void onLoading() {
                pages++;
                isLoad = true;
                startSearch();
            }
        });

        navView.setNavigationItemSelectedListener(new NavigationView.OnNavigationItemSelectedListener() {
            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem item) {
                int id = item.getItemId();
                switch(id) {
                    case R.id.nav_like:
                        Intent intent = new Intent(NewsActivity.this,LikeActivity.class);
                        intent.putExtra("isLike",true);
                        startActivity(intent);
                        break;
                    case R.id.nav_news:
                        Intent intent_ = new Intent(NewsActivity.this,LikeActivity.class);
                        intent_.putExtra("isLike",false);
                        startActivity(intent_);
                        break;
//                    case R.id.nav_offline:
//                        break;
                }
                return false;
            }
        });
    }

    private void startSearch() {
        NewsItemTask task = new NewsItemTask(NewsActivity.this);
        String[] target = new String[4];
        target[0] = "latest?";
        target[1] = "&pageNo=" + String.valueOf(pages);
        target[2] = "&pageSize=30";
        target[3] = "&category=" + String.valueOf(catagory_code);
        task.execute(target);
        SwipeRefresh.setRefreshing(true);
        isLoad = false;
    }

    @Override
    public void getItems(List<NewsItem> items) {
        SwipeRefresh.setRefreshing(false);
        if(isLoad)
            newsAdapter_.addData(items);
        else
            newsAdapter_.setData(items);
        newsAdapter_.setFooterInfo("上拉加载更多...");
    }

    @Override
    public void onFailure() {
//        SwipeRefresh.setRefreshing(false);
//        newsAdapter_.setFooterInfo("网络连接失败...");
    }

    @Override
    public void noMore(List<NewsItem> items) {
        SwipeRefresh.setRefreshing(false);
        startSearch();
    }
}
