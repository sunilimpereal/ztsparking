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
import androidx.localbroadcastmanager.content.LocalBroadcastManager;



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
    private boolean isExitTicket = false;
    private String dateTime;
    private String categoryName;
    private List<String> lineItems = new ArrayList<String>();
    private List<String> lineitemQty = new ArrayList<String>();
    private List<String> lineitemTotal = new ArrayList<String>();
    private String ticketTotal;
    private String ticketNumber;
    private String qrCode;
    private String vehicleNumber;
    //Exit ticket
    private String date;
    private String entryTime;
    private String exitTime;

       //print Summary
       boolean isSummary;
       String userEmail;
       String summaryDate;
       String printDate;
       private List<String> sumLineItemNames = new ArrayList<String>();
       private List<String> sumLineItemQty = new ArrayList<String>();
       private List<String> sumLineItemTotal = new ArrayList<String>();
       String summaryTotal;
    public static final String STREAM = "printingStatus";
    EventChannel.EventSink mEventSink;


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new EventChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), STREAM).setStreamHandler(new EventChannel.StreamHandler() {
           
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                System.out.println("sds");
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
                                ticketNumber  = call.argument("ticketNumber");
                                dateTime      = call.argument("dateTime");
                                categoryName  = call.argument("categoryName");
                                lineItems     = call.argument("lineItems");
                                lineitemQty   = call.argument("lineitemQty");
                                lineitemTotal = call.argument("lineitemTotal");
                                ticketTotal   = call.argument("ticketTotal");
                                qrCode        = call.argument("qrCode");
                                vehicleNumber = call.argument("vehicleNumber");
                                //exit ticket
                                date         = call.argument("date");
                                entryTime    = call.argument("entryTime");
                                exitTime     = call.argument("exitTime");
                                isExitTicket = call.argument("isExitTicket");
                                System.out.println("category");
                                System.out.println(categoryName.toString());
                                System.out.println(lineItems.toString());
                                System.out.println(lineitemQty.toString());
                                System.out.println(lineitemTotal.toString());
                                System.out.println(ticketTotal.toString());
                                System.out.println(ticketNumber.toString());
                                System.out.println("entry"+ entryTime);
                                System.out.println("exit"+ exitTime);
                                System.out.println("date"+ date);
                                System.out.println(qrCode.toString());
                                System.out.println(vehicleNumber.toString());
                                result.success(results);
                                 //Toast.makeText(this, "Bluetooth Not Supported", Toast.LENGTH_SHORT).show();
                            
                            }else if (call.method.equals("printSummary")) {
                                isSummary=true;
                                mPrinter.connectToPrinter();
                               userEmail   = call.argument("userEmail");
                               summaryDate = call.argument("summaryDate");
                               printDate  = call.argument("printDate");
                               sumLineItemNames     = call.argument("sumLineItemNames");
                               sumLineItemQty   = call.argument("sumLineItemQty");
                               sumLineItemTotal = call.argument("sumLineItemTotal");
                               summaryTotal   = call.argument("summaryTotal");
                               System.out.println("Summary");
                               System.out.println(userEmail.toString());
                               System.out.println(summaryDate.toString());
                               System.out.println(printDate.toString());
                               System.out.println(sumLineItemNames.toString());
                               System.out.println(sumLineItemQty.toString());
                               System.out.println(sumLineItemTotal.toString());
                               System.out.println(summaryTotal.toString());
                               result.success(results);
                                //Toast.makeText(this, "Bluetooth Not Supported", Toast.LENGTH_SHORT).show();
                           }
                            
                            else if (call.method.equals("printerStatus")) {
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
    protected void onStart() {
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(RECEIPT_PRINTER_MESSAGES);
        LocalBroadcastManager.getInstance(this).registerReceiver(ReceiptPrinterMessageReceiver, intentFilter);

        super.onStart();
    }

    @Override
    protected void onStop() {
        LocalBroadcastManager.getInstance(this).unregisterReceiver(ReceiptPrinterMessageReceiver);

        super.onStop();
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
            TextPaint tp = new TextPaint();
            tp.setTextSize(36);
            mPrinter.setPrinterWidth(PrinterWidth.PRINT_WIDTH_48MM);
            if(isSummary == false){
            if(!isExitTicket){

         
            mPrinter.resetPrinter();
            Bitmap bmp = BitmapFactory.decodeResource(getResources(), R.mipmap.ticketlogo);
            Bitmap logo = BitmapFactory.decodeResource(getResources(), R.mipmap.logo1);
            mPrinter.setAlignmentCenter();
            mPrinter.setCharRightSpacing(10);
            mPrinter.printGrayScaleImage(bmp, 1);
            mPrinter.setCharRightSpacing(0);
            mPrinter.pixelLineFeed(50);
            // Bill Details Start
            mPrinter.setAlignmentLeft();
            mPrinter.printTextLine("SAVE FOREST,SAVE WILDLIFE\n");
            mPrinter.printTextLine("Ticket Number: " + ticketNumber + "\n");
            mPrinter.printTextLine("Date & Time : " + dateTime + "\n");
            mPrinter.printTextLine("Vehicle Number : " + vehicleNumber + "\n");
            mPrinter.setAlignmentCenter();
            mPrinter.setBoldOn();
            mPrinter.setCharRightSpacing(3);
            mPrinter.pixelLineFeed(50);
            mPrinter.pixelLineFeed(50);
            mPrinter.printLineFeed();
            mPrinter.printTextLine( "PARKING TICKET\n");
            mPrinter.pixelLineFeed(50);  
            mPrinter.setBoldOff();
            mPrinter.setCharRightSpacing(0);
            mPrinter.printTextLine("-------------------------------\n");
            mPrinter.printTextLine("Name            Qty      total \n");
            mPrinter.printTextLine("-------------------------------\n");
            mPrinter.setAlignmentCenter();
            PrintColumnParam colm1  = new PrintColumnParam((String[]) lineItems.toArray(new String[0]),50);
            PrintColumnParam colm2 = new PrintColumnParam( (String[])lineitemQty.toArray(new String[0]),25);
            PrintColumnParam colm3=  new PrintColumnParam((String[]) lineitemTotal.toArray(new String[0]),25,Layout.Alignment.ALIGN_OPPOSITE);
            mPrinter.PrintTable(colm1,colm2,colm3);
            mPrinter.setAlignmentRight();
            mPrinter.printUnicodeText("Total : " + ticketTotal.toString()+"\n",Layout.Alignment.ALIGN_OPPOSITE,tp);
            mPrinter.printQRcode(qrCode, 300, imageAlignment);
            mPrinter.setAlignmentLeft();
            mPrinter.printTextLine("Valid for 4 Hours,Overstay\nwill be charged\n");
            mPrinter.printTextLine("THANK YOU VISIT AGAIN \nLOVE AND PROTECT ANIMALS\n");
            mPrinter.printGrayScaleImage(logo, 1);
            // mPrinter.printTextLine("******************************\n");
            mPrinter.printLineFeed();
            mPrinter.printLineFeed();
            return null;
            }else{
               
                mPrinter.resetPrinter();
                Bitmap bmp = BitmapFactory.decodeResource(getResources(), R.mipmap.ticketlogo);
                Bitmap logo = BitmapFactory.decodeResource(getResources(), R.mipmap.logo1);
                mPrinter.setAlignmentCenter();
                mPrinter.setCharRightSpacing(10);
                mPrinter.printGrayScaleImage(bmp, 1);
                mPrinter.setCharRightSpacing(0);
                // Bill Details Start
                mPrinter.setAlignmentLeft();
                mPrinter.printTextLine("SAVE FOREST,SAVE WILDLIFE\n");
                mPrinter.printTextLine("Ticket Number: " + ticketNumber + "\n");
                mPrinter.printTextLine("Date : " + date + "\n");
                mPrinter.printTextLine("Entry Time : " + entryTime + "\n");
                mPrinter.printTextLine("Exit Time  : " + exitTime + "\n");
                // mPrinter.printTextLine("Vehicle Number : " + vehicleNumber + "\n");
                mPrinter.setAlignmentCenter();
                mPrinter.setBoldOn();
                mPrinter.setCharRightSpacing(3);
                mPrinter.pixelLineFeed(50);
                mPrinter.pixelLineFeed(50);
                mPrinter.printLineFeed();
                mPrinter.printTextLine( "PARKING EXIT TICKET\n");
                mPrinter.pixelLineFeed(50);  
                mPrinter.setBoldOff();
                mPrinter.setCharRightSpacing(0);
                mPrinter.printTextLine("-------------------------------\n");
                mPrinter.printTextLine("Name            Qty      total \n");
                mPrinter.printTextLine("-------------------------------\n");
                mPrinter.setAlignmentCenter();
                PrintColumnParam colm1  = new PrintColumnParam((String[]) lineItems.toArray(new String[0]),50);
                PrintColumnParam colm2 = new PrintColumnParam( (String[])lineitemQty.toArray(new String[0]),25);
                PrintColumnParam colm3=  new PrintColumnParam((String[]) lineitemTotal.toArray(new String[0]),25,Layout.Alignment.ALIGN_OPPOSITE);
                mPrinter.PrintTable(colm1,colm2,colm3);
                mPrinter.setAlignmentRight();
                mPrinter.printUnicodeText("Total : " + ticketTotal.toString()+"\n",Layout.Alignment.ALIGN_OPPOSITE,tp);
                // mPrinter.printQRcode(qrCode, 300, imageAlignment);
                mPrinter.setAlignmentLeft();
                // mPrinter.printTextLine("Valid for 4 Hours,Overstay\nwill be charged\n");
                mPrinter.printTextLine("THANK YOU VISIT AGAIN \nLOVE AND PROTECT ANIMALS\n");
                mPrinter.printGrayScaleImage(logo, 1);
                // mPrinter.printTextLine("******************************\n");
                mPrinter.printLineFeed();
                mPrinter.printLineFeed();
                return null;
            }
        }else{
            System.out.println("Printing Summary");
            Bitmap bmp = BitmapFactory.decodeResource(getResources(), R.mipmap.ticketlogo);
            Bitmap logo = BitmapFactory.decodeResource(getResources(), R.mipmap.logo1);
            mPrinter.setAlignmentCenter();
            mPrinter.setCharRightSpacing(10);
            mPrinter.printGrayScaleImage(bmp, 1);
            mPrinter.setCharRightSpacing(0);
            mPrinter.pixelLineFeed(50);
            // Bill Details Start
            mPrinter.setAlignmentLeft();
            mPrinter.setBoldOn();
            mPrinter.pixelLineFeed(50);
            mPrinter.printTextLine("Agent Daily Summary\n");
            mPrinter.pixelLineFeed(50);
            mPrinter.setBoldOff();
            mPrinter.printTextLine("User: " + userEmail + "\n");
            mPrinter.printTextLine("Summary Date : " + summaryDate + "\n");
            mPrinter.printTextLine("Print Date : " + printDate + "\n");
            mPrinter.setAlignmentCenter();
            mPrinter.setBoldOn();
            mPrinter.setCharRightSpacing(3);
            mPrinter.pixelLineFeed(50);
            mPrinter.printLineFeed();
            //mPrinter.printTextLine( "PARKING TICKET\n");
            mPrinter.pixelLineFeed(50);  
            mPrinter.setBoldOff();
            mPrinter.setCharRightSpacing(0);
            mPrinter.printTextLine("-------------------------------\n");
            mPrinter.printTextLine("Item            Qty      total \n");
            mPrinter.printTextLine("-------------------------------\n");
            mPrinter.setAlignmentCenter();
            PrintColumnParam colm1  = new PrintColumnParam((String[]) sumLineItemNames.toArray(new String[0]),50);
            PrintColumnParam colm2 = new PrintColumnParam( (String[])sumLineItemQty.toArray(new String[0]),25);
            PrintColumnParam colm3=  new PrintColumnParam((String[]) sumLineItemTotal.toArray(new String[0]),25,Layout.Alignment.ALIGN_OPPOSITE);
            mPrinter.PrintTable(colm1,colm2,colm3);
            mPrinter.setAlignmentRight();
            mPrinter.printUnicodeText("Total : " + summaryTotal.toString()+"\n",Layout.Alignment.ALIGN_OPPOSITE,tp);
            mPrinter.setAlignmentLeft();
            mPrinter.pixelLineFeed(50);
            mPrinter.printTextLine("Agent singnature  : \n");
            mPrinter.pixelLineFeed(50);
            mPrinter.pixelLineFeed(50);
            mPrinter.printTextLine("Finance signature :\n");
            mPrinter.pixelLineFeed(50);
            mPrinter.pixelLineFeed(50);
            mPrinter.printGrayScaleImage(logo, 1);
            // mPrinter.printTextLine("******************************\n");
            mPrinter.printLineFeed();
            mPrinter.printLineFeed();
            return null;
        }
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
