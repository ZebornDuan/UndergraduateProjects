package com.rebornduan.news.newsrd.view;


import android.content.Context;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.AttributeSet;

import static android.support.v7.widget.RecyclerView.SCROLL_STATE_IDLE;

public class DSwipeRefresh extends SwipeRefreshLayout {
    private RecyclerView mRecyclerView;
    private RecyclerView.Adapter mAdapter;
    private LinearLayoutManager mLayoutManager;
    private GridLayoutManager mGridLayoutManager;
    private boolean mGrid = false;
    private static int sLastVisibleItem;
    private OnLoadingListener mOnLoadingListener;

    private static final int[] SWIPE_REFRESH_COLOR_SCHEME = {android.R.color.holo_red_light,
            android.R.color.holo_orange_light,
            android.R.color.holo_green_light,
            android.R.color.holo_blue_bright};

    private RecyclerView.OnScrollListener mScrollListener = new RecyclerView.OnScrollListener() {
        @Override
        public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
            super.onScrollStateChanged(recyclerView, newState);
            if (newState == SCROLL_STATE_IDLE && sLastVisibleItem + 1 == mAdapter.getItemCount()) {
                if (mOnLoadingListener != null) {
                    mOnLoadingListener.onLoading();
                }
            }
        }

        @Override
        public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
            super.onScrolled(recyclerView, dx, dy);
            if (mGrid) {
                sLastVisibleItem = mGridLayoutManager.findLastVisibleItemPosition();
            } else {
                sLastVisibleItem = mLayoutManager.findLastVisibleItemPosition();
            }
        }
    };

    public DSwipeRefresh(Context context) {
        this(context, null);
    }

    public DSwipeRefresh(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public void setRecyclerViewAndAdapter(RecyclerView recyclerView, RecyclerView.Adapter adapter) {
        this.mGrid = false;
        this.mRecyclerView = recyclerView;
        this.mAdapter = adapter;
        mLayoutManager = new LinearLayoutManager(getContext());
        mRecyclerView.setLayoutManager(mLayoutManager);
        mRecyclerView.setOnScrollListener(mScrollListener);
        mRecyclerView.setAdapter(mAdapter);
    }

    public void setRecyclerViewAndAdapter(RecyclerView recyclerView, RecyclerView.Adapter adapter, int spanCount) {
        this.mGrid = true;
        this.mRecyclerView = recyclerView;
        this.mAdapter = adapter;
        mGridLayoutManager = new GridLayoutManager(getContext(), spanCount);
        mRecyclerView.setLayoutManager(mGridLayoutManager);
        mRecyclerView.setOnScrollListener(mScrollListener);
        mRecyclerView.setAdapter(mAdapter);
    }

    private void init() {
        setColorSchemeResources(SWIPE_REFRESH_COLOR_SCHEME);
    }

    public void setOnLoadingListener(OnLoadingListener onLoadingListener) {
        this.mOnLoadingListener = onLoadingListener;
    }

    public RecyclerView.LayoutManager getLayoutManager() {
        if (mGrid) {
            return mGridLayoutManager;
        } else {
            return mLayoutManager;
        }
    }

    public interface OnLoadingListener {
        void onLoading();
    }
}
