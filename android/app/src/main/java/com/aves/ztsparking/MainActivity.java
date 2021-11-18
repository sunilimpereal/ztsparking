package com.aves.ztsparking;

import io.flutter.embedding.android.FlutterActivity;
import android.app.ProgressDialog;
import android.bluetooth.BluetoothAdapter;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Typeface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.Layout;
import android.text.TextPaint;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.Observer;



import com.cie.btp.Barcode;
import com.cie.btp.CieBluetoothPrinter;
import com.cie.btp.DebugLog;
import com.cie.btp.FontStyle;
import com.cie.btp.FontType;
import com.cie.btp.PrintColumnParam;
import com.cie.btp.PrintImageColumn;
import com.cie.btp.PrinterWidth;

import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.io.*;
import java.util.*;


import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

import static com.cie.btp.BtpConsts.RECEIPT_PRINTER_CONN_DEVICE_NAME;
import static com.cie.btp.BtpConsts.RECEIPT_PRINTER_CONN_STATE_CONNECTED;
import static com.cie.btp.BtpConsts.RECEIPT_PRINTER_CONN_STATE_CONNECTING;
import static com.cie.btp.BtpConsts.RECEIPT_PRINTER_CONN_STATE_LISTEN;
import static com.cie.btp.BtpConsts.RECEIPT_PRINTER_CONN_STATE_NONE;
import static com.cie.btp.BtpConsts.RECEIPT_PRINTER_MSG;
import static com.cie.btp.BtpConsts.RECEIPT_PRINTER_NOTIFICATION_ERROR_MSG;
import static com.cie.btp.BtpConsts.RECEIPT_PRINTER_STATUS;
import static com.cie.btp.BtpConsts.RECEIPT_PRINTER_MESSAGES;

public class MainActivity extends FlutterActivity {


    private static final String CHANNEL = "brother/print";
    public CieBluetoothPrinter mPrinter = CieBluetoothPrinter.INSTANCE;

    ProgressDialog pdWorkInProgress;
    private static final int BARCODE_WIDTH = 384;
    private static final int BARCODE_HEIGHT = 100;
    private static final int QRCODE_WIDTH = 150;
    private int imageAlignment = 1;
    private int results;

    private String dateTime;
    private String categoryName;
    private List<String> lineItems = new ArrayList<String>();
    private List<String> lineitemQty = new ArrayList<String>();
    private List<String> lineitemTotal = new ArrayList<String>();
    private String ticketTotal;
    private String ticketNumber;
    public static final String STREAM = "printingStatus";
    EventChannel.EventSink mEventSink;


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new EventChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), STREAM).setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                mEventSink = events;


            }

            @Override
            public void onCancel(Object arguments) {
                mEventSink = null;
            }
        });
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("select")) {

                                mPrinter.disconnectFromPrinter();

                                mPrinter.selectPrinter(MainActivity.this);
                            } else if (call.method.equals("print")) {
                                 mPrinter.connectToPrinter();
                                ticketNumber   = call.argument("ticketNumber");
                                dateTime = call.argument("dateTime");
                                categoryName  = call.argument("categoryName");
                                lineItems     = call.argument("lineItems");
                                lineitemQty   = call.argument("lineitemQty");
                                lineitemTotal = call.argument("lineitemTotal");
                                ticketTotal   = call.argument("ticketTotal");
                                System.out.println("category");
                                System.out.println(categoryName.toString());
                                System.out.println(lineItems.toString());
                                System.out.println(lineitemQty.toString());
                                System.out.println(lineitemTotal.toString());
                                System.out.println(ticketTotal.toString());
                                System.out.println(ticketNumber.toString());
                                // Toast.makeText(this, "Bluetooth Not Supported", Toast.LENGTH_SHORT).show();
                            } else if (call.method.equals("printerStatus")) {
                                result.success(results);
                            }
                        }
                );
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        pdWorkInProgress = new ProgressDialog(this);
        BluetoothAdapter mAdapter = BluetoothAdapter.getDefaultAdapter();
        if (mAdapter == null) {
            Toast.makeText(this, "Bluetooth Not Supported", Toast.LENGTH_SHORT).show();
            finish();
        }
        try {
            mPrinter.initService(MainActivity.this);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onResume() {
        mPrinter.onActivityResume();
        super.onResume();
    }

    @Override
    protected void onPause() {
        mPrinter.onActivityPause();
        super.onPause();
    }


    @Override
    protected void onDestroy() {
        DebugLog.logTrace("onDestroy");
        mPrinter.onActivityDestroy();
        super.onDestroy();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        mPrinter.onActivityRequestPermissionsResult(requestCode, permissions, grantResults);
    }



    private final BroadcastReceiver ReceiptPrinterMessageReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            DebugLog.logTrace("Printer Message Received");
            Bundle b = intent.getExtras();
            if (b == null) {
                return;
            }
            results = b.getInt(RECEIPT_PRINTER_STATUS);
            mEventSink.success(results);
            switch (b.getInt(RECEIPT_PRINTER_STATUS)) {

                case RECEIPT_PRINTER_CONN_STATE_NONE:
                    Log.d("Not Connected", "");
                    break;
                case RECEIPT_PRINTER_CONN_STATE_LISTEN:
                    Log.d("Ready to connect", "");
                    break;
                case RECEIPT_PRINTER_CONN_STATE_CONNECTING:
                    Log.d("Printer Connecting", "");
                    break;
                case RECEIPT_PRINTER_CONN_STATE_CONNECTED:
                    Log.d("Printer connected", "");

                    new AsyncPrint().execute();
                    break;
                case RECEIPT_PRINTER_CONN_DEVICE_NAME:
                    Log.d("", "");
                    // mPrinter.connectToPrinter();
                    break;
                case RECEIPT_PRINTER_NOTIFICATION_ERROR_MSG:
                    String n = b.getString(RECEIPT_PRINTER_MSG);
                    break;
            }
        }
    };


    private class AsyncPrint extends AsyncTask<Void, Void, Void> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }

        @Override
        protected Void doInBackground(Void... params) {
            mPrinter.setPrinterWidth(PrinterWidth.PRINT_WIDTH_48MM);
            mPrinter.resetPrinter();
//            Bitmap bmp = BitmapFactory.decodeResource(getResources(), R.mipmap.ticketlogo);
            mPrinter.setAlignmentCenter();
            mPrinter.setCharRightSpacing(10);
//            mPrinter.printGrayScaleImage(bmp, 1);
            mPrinter.setCharRightSpacing(0);
            mPrinter.pixelLineFeed(50);
            // Bill Details Start
            mPrinter.setAlignmentLeft();
            mPrinter.printTextLine("SAVE FOREST,SAVE WILDLIFE");
            mPrinter.printTextLine("Ticket Number: " + ticketNumber + "\n");
            mPrinter.printTextLine("Time   : " + dateTime + "\n");
            mPrinter.printTextLine( categoryName + "\n");
            mPrinter.printTextLine("----------------------------------------");
            mPrinter.printTextLine("name         Qty          total");
            mPrinter.printTextLine("----------------------------------------");
            mPrinter.setAlignmentCenter();
            PrintColumnParam colm1  = new PrintColumnParam((String[]) lineItems.toArray(),40);
            PrintColumnParam colm2 = new PrintColumnParam((String[]) lineitemQty.toArray(),30);
            PrintColumnParam colm3= new PrintColumnParam((String[]) lineitemTotal.toArray(),30);
            mPrinter.PrintTable(colm1,colm2,colm3);
            mPrinter.setAlignmentRight();
            mPrinter.printTextLine("Total : " + ticketTotal.toString()+"\n");
            mPrinter.printQRcode(ticketNumber, 300, imageAlignment);
            // mPrinter.printTextLine("\nViolators will be booked under\nK F ACT 1963 and WP ACT1972\n");
            // mPrinter.printLineFeed();
            // mPrinter.printTextLine("Save Tigers\n");
            // mPrinter.printLineFeed();
            // mPrinter.printTextLine("******************************\n");
            // mPrinter.printLineFeed();


            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);
            //wait for printing to complete
            try {
                Thread.sleep(6000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            mPrinter.disconnectFromPrinter();

            pdWorkInProgress.cancel();
        }


    }


}
