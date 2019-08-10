package com.rebornduan.news.newsrd.adapter;

import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v7.app.AlertDialog;
import android.support.v7.widget.CardView;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.rebornduan.news.newsrd.App;
import com.rebornduan.news.newsrd.bean.NewsItem;
import com.rebornduan.news.newsrd.DetailActivity;
import com.rebornduan.news.newsrd.R;
import com.bumptech.glide.Glide;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Administrator on 2017/8/29 0029.
 */
public class NewsAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {
    private List<NewsItem> Items = new ArrayList<NewsItem>(1);
    private static final int TYPE_ITEM = 0x0000;
    private static final int TYPE_FOOTER = 0x0001;
    private Activity mActivity;
    private String FooterInfo = "";

    public NewsAdapter(Activity mActivity) {
        this.mActivity = mActivity;
    }

    public void setData(List<NewsItem> new_item) {
        Items.clear();
        if (new_item != null && !new_item.isEmpty())
            Items.addAll(new_item);
        notifyDataSetChanged();
    }

    public void addData(List<NewsItem> items_) {
        int start = Items.size();
        if (items_ != null && !items_.isEmpty()) {
            Items.addAll(items_);
            //notifyDataSetChanged();
            notifyItemRangeInserted(start, items_.size());
        }
    }

    public void setFooterInfo(String footerInfo) {
        FooterInfo = footerInfo;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        if (viewType == TYPE_ITEM) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_news, parent, false);
            return new ItemViewHolder(view);
        } else if (viewType == TYPE_FOOTER) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_footr, parent, false);
            return new FooterViewHolder(view);
        }
        return null;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        if (getItemViewType(position) == TYPE_ITEM) {
            SharedPreferences preferences = mActivity.getSharedPreferences("user", Context.MODE_PRIVATE);
            boolean showImage = preferences.getBoolean("showImage",true);
            ItemViewHolder itemHolder = (ItemViewHolder) holder;
            final NewsItem item_ = Items.get(position);
            Glide.with(mActivity).load(item_.getCoverUrl()).asBitmap().centerCrop().into(itemHolder.Cover);
            if(!showImage)
                itemHolder.Cover.setVisibility(View.INVISIBLE);
            else
                itemHolder.Cover.setVisibility(View.VISIBLE);
            itemHolder.newsTitle.setText(item_.getTitle());
            if(App.helper.search_id3(item_.getID()))
                itemHolder.newsTitle.setTextColor(mActivity.getResources().getColor(R.color.colorNight));
            else
                itemHolder.newsTitle.setTextColor(mActivity.getResources().getColor(R.color.black));
            itemHolder.Introduction.setText(item_.getIntroduction());
            itemHolder.Source.setText(item_.getSource());
            itemHolder.Time.setText(item_.getTime());
            itemHolder.newsOutline.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    App.helper.add3(item_.getID());
                    notifyDataSetChanged();
                    Intent intent = new Intent(mActivity, DetailActivity.class);
                    String url =  item_.getID();
                    intent.putExtra("web", url);
                    mActivity.startActivity(intent);
                }
            });
        } else if (getItemViewType(position) == TYPE_FOOTER) {
            ((FooterViewHolder) holder).iFooter.setText(FooterInfo);
        }
    }

    @Override
    public int getItemCount() {
        return Items.size() + 1;
    }


    @Override
    public int getItemViewType(int position) {
        if (position == getItemCount() - 1)
            return TYPE_FOOTER;
        return TYPE_ITEM;
    }

    public static class ItemViewHolder extends RecyclerView.ViewHolder {
        private ImageView Cover;
        private TextView newsTitle;
        private TextView Introduction, Source, Time;
        private LinearLayout newsOutline;
        private CardView Card;

        public ItemViewHolder(View itemView) {
            super(itemView);
            Cover = (ImageView) itemView.findViewById(R.id.Cover);
            newsTitle = (TextView) itemView.findViewById(R.id.newsTitle);
            Introduction = (TextView) itemView.findViewById(R.id.introduction);
            Source = (TextView) itemView.findViewById(R.id.source);
            Time = (TextView) itemView.findViewById(R.id.Time);
            newsOutline = (LinearLayout) itemView.findViewById(R.id.NewsOutline);
            Card = (CardView)itemView.findViewById(R.id.card);
        }
    }

    public static class FooterViewHolder extends RecyclerView.ViewHolder {
        private TextView iFooter;
        public FooterViewHolder(View itemView) {
            super(itemView);
            iFooter = (TextView) itemView.findViewById(R.id.Footer);
        }
    }
}
