package com.example.odzo.ledcontrol_v2.helper;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.ParcelUuid;
import android.util.Log;

import com.example.odzo.ledcontrol_v2.R;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Set;

/**
 * Created by OdzO on 2017.01.21..
 */

public class BTConn {

    private static BTConn mBtConn;

    private BluetoothSocket socket;
    private OutputStream outputStream;
    private String deviceName;
    private Context context;
    private SharedPreferences sharedPref;

    public static final int BT_CONNECTION_SUCCEEDED = 0;
    public static final int BT_NO_BT = 1;
    public static final int BT_NOT_ENABLED = 2;
    public static final int BT_NO_PAIRED_DEVICES = 3;
    public static final int BT_NO_DEVICE_SET = 4;
    public static final int BT_CONNECTION_FAILED = 5;


    private BTConn(Context context){
        socket = null;
        this.context = context;
        sharedPref = context.getSharedPreferences(context.getString(R.string.prefered_file_key), Context.MODE_PRIVATE);
    }


    public static BTConn getInstance() {
        return mBtConn;
    }

    public static BTConn getInstance(Context context) {
        mBtConn = new BTConn(context);
        return mBtConn;
    }

    public int connect() {
        if(socket != null){
            try {
                socket.close();
            } catch (IOException e) {
                Log.e("connect","Can't close connection",e);
            }
        }
        BluetoothAdapter blueAdapter = BluetoothAdapter.getDefaultAdapter();
        if (blueAdapter != null) {
            blueAdapter.cancelDiscovery();
            if (blueAdapter.isEnabled()) {
                Set<BluetoothDevice> pairedDevices = blueAdapter.getBondedDevices();
                if(!pairedDevices.isEmpty()) {
                    BluetoothDevice selectedDevice = null;
                    boolean match = false;
                    for(BluetoothDevice d : pairedDevices){
                        if(!match){
                            Log.i("Check","BT: " + d.getName() + " - " + "Saved: " + deviceName);
                            if(d.getName().equals(deviceName)){
                                selectedDevice = d;
                                match = true;
                            }
                        }
                    }
                    if(match){
                        Log.i("Device",selectedDevice.getName());
                        ParcelUuid[] uuids = selectedDevice.getUuids();
                        try {
                            socket = selectedDevice.createRfcommSocketToServiceRecord(uuids[0].getUuid());
                            Log.i("BTConn","Socket: " + socket + " - " + socket.toString());
                            socket.connect();
                            outputStream = socket.getOutputStream();
                            Log.i("BTConn","connected");
                            return BT_CONNECTION_SUCCEEDED;
                        } catch (IOException e) {
                            Log.e("connect","Can't connect to " + selectedDevice.getName(),e);
                            return BT_CONNECTION_FAILED;
                        }
                    }else{
                        return BT_NO_DEVICE_SET;
                    }
                }else{
                    Log.e("error", "No appropriate paired devices.");
                    return BT_NO_PAIRED_DEVICES;
                }
            } else {
                Log.e("error", "Bluetooth is disabled.");
                return BT_NOT_ENABLED;
            }
        }else{
            Log.e("error", "Bluetooth is not supported.");
            return BT_NO_BT;
        }
    }

    public void setDevice(String deviceName){
        this.deviceName = deviceName;
    }

    public void send(String msg){
        if(sharedPref.getInt(context.getString(R.string.power_status), 0) == 1 && outputStream != null){
            try {
                msg = msg + "\n";
                outputStream.write(msg.getBytes());
                Log.i("send","Sent: " + msg);
            } catch (IOException e) {
                Log.e("send","Can't send message.",e);
            }
        }
    }
}
