package com.gameradar.gameradar_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Виджет «Отслеживаю» на рабочем столе: до четырёх игр с ценой и скидкой.
 * Данные кладёт приложение (home_widget, ключи row_N_name/row_N_price/
 * row_N_hot, count, updated) при каждом обновлении списка отслеживания.
 * Нажатие открывает вкладку «Отслеживаю» ссылкой gameradar://app/watchlist.
 */
class WatchlistWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.watchlist_widget)
            val count = widgetData.getInt("count", 0)

            for (i in 0 until ROWS) {
                val row = context.resources.getIdentifier("row_$i", "id", context.packageName)
                val name = context.resources.getIdentifier("row_${i}_name", "id", context.packageName)
                val price = context.resources.getIdentifier("row_${i}_price", "id", context.packageName)
                if (i < count) {
                    views.setViewVisibility(row, View.VISIBLE)
                    views.setTextViewText(name, widgetData.getString("row_${i}_name", ""))
                    views.setTextViewText(price, widgetData.getString("row_${i}_price", ""))
                    val hot = widgetData.getBoolean("row_${i}_hot", false)
                    views.setTextColor(
                        price,
                        context.getColor(if (hot) R.color.widget_discount else R.color.widget_text),
                    )
                } else {
                    views.setViewVisibility(row, View.GONE)
                }
            }
            views.setViewVisibility(R.id.empty, if (count == 0) View.VISIBLE else View.GONE)
            views.setTextViewText(R.id.updated, widgetData.getString("updated", ""))
            views.setTextViewText(
                R.id.empty,
                widgetData.getString("empty", context.getString(R.string.widget_empty)),
            )
            views.setTextViewText(
                R.id.title,
                widgetData.getString("title", context.getString(R.string.widget_title)),
            )

            val open = Intent(Intent.ACTION_VIEW, Uri.parse("gameradar://app/watchlist"))
                .setClass(context, MainActivity::class.java)
            views.setOnClickPendingIntent(
                R.id.root,
                PendingIntent.getActivity(
                    context,
                    0,
                    open,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                ),
            )
            appWidgetManager.updateAppWidget(id, views)
        }
    }

    companion object {
        const val ROWS = 4
    }
}
