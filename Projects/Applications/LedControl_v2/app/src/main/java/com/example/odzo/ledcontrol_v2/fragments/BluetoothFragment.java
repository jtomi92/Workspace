package com.example.odzo.ledcontrol_v2.fragments;


import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import com.example.odzo.ledcontrol_v2.R;
import com.example.odzo.ledcontrol_v2.helper.BTConn;

import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class BluetoothFragment extends Fragment {

    private View view;
    private Switch switch1;
    private Button button1;
    private Button button2;
    private Button button3;
    private EditText editText;
    private TextView deviceStatus;
    private Spinner spinner1;
    private ArrayAdapter<String> dataAdapter;
    private SharedPreferences sharedPref;


    //private List<BluetoothDevice> devices = new ArrayList<BluetoothDevice>();
    private OutputStream outputStream;
    private int messageInt = 1;


    public static BluetoothFragment newInstance() {
        BluetoothFragment fragment = new BluetoothFragment();
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        sharedPref = getActivity().getSharedPreferences(getString(R.string.prefered_file_key), Context.MODE_PRIVATE);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, final Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.fragment_bluetooth, container, false);

        switch1 = (Switch) view.findViewById(R.id.switch1);
        switch1.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    controlBluetooth(true);
                }else{
                    controlBluetooth(false);
                }
            }
        });

        button1 = (Button) view.findViewById(R.id.button1);
        button1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(Intent.ACTION_MAIN, null);
                intent.addCategory(Intent.CATEGORY_LAUNCHER);
                ComponentName cn = new ComponentName("com.android.settings", "com.android.settings.bluetooth.BluetoothSettings");
                intent.setComponent(cn);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity( intent);
            }
        });

        button2 = (Button) view.findViewById(R.id.power);
        button2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                updateDevices();
            }
        });

        editText = (EditText) view.findViewById(R.id.editText);
        deviceStatus = (TextView) view.findViewById(R.id.deviceStatus);
        if(sharedPref.getInt(getString(R.string.connection_status), 5) == 0){
            deviceStatus.setText("Connected");
            deviceStatus.setTextColor(Color.GREEN);
        }else{
            deviceStatus.setText("No connection");
            deviceStatus.setTextColor(Color.RED);
        }

        button3 = (Button) view.findViewById(R.id.button3);
        button3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                BTConn.getInstance().send(editText.getText().toString());
            }
        });

        spinner1 = (Spinner) view.findViewById(R.id.spinner);
        updateDevices();
        spinner1.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            SharedPreferences.Editor editor = sharedPref.edit();
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                String storedDeviceName = sharedPref.getString(getString(R.string.selected_device_name),"BT_device");
                String deviceName = dataAdapter.getItem(position).toString();
                if(!storedDeviceName.equals(deviceName)){
                    //ez itt nem íródik ki, csak a második
                    deviceStatus.setText("Connecting");
                    deviceStatus.setTextColor(Color.YELLOW);
                    editor.putString(getString(R.string.selected_device_name),deviceName);
                    Log.i("asdasdas",deviceName);
                    editor.commit();
                    BTConn.getInstance().setDevice(deviceName);
                    int res = BTConn.getInstance().connect();
                    if(res == 0){
                        deviceStatus.setText("Connected");
                        deviceStatus.setTextColor(Color.GREEN);
                    }else{
                        deviceStatus.setText("No connection");
                        deviceStatus.setTextColor(Color.RED);
                    }
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        return view;
    }

    public void controlBluetooth(Boolean b){
        BluetoothAdapter mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        if (mBluetoothAdapter == null) {
            String message = "Your device does not support bluetooth";
            Toast toast = Toast.makeText(view.getContext().getApplicationContext(), message, Toast.LENGTH_SHORT);
            toast.setGravity(Gravity.BOTTOM, 0, 300);
            toast.show();
            switch1.setChecked(false);
        }else{
            if(b){
                mBluetoothAdapter.enable();
            }else {
                mBluetoothAdapter.disable();
            }
        }
    }

    private void updateDevices(){
        List<String> list = new ArrayList<String>();

        BluetoothAdapter mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        if (mBluetoothAdapter != null) {
            if(mBluetoothAdapter.isEnabled()){
                switch1.setChecked(true);
                Set<BluetoothDevice> pairedDevices = mBluetoothAdapter.getBondedDevices();
                if (pairedDevices.size() > 0) {
                    for (BluetoothDevice device : pairedDevices) {
                        String deviceName = device.getName();
                        String deviceHardwareAddress = device.getAddress(); // MAC address
                        //devices.add(device);
                        list.add(deviceName);
                    }
                }else{
                    list.add("No paired devices");
                }
            }else{
                //talán onresume-be téve szebb
                switch1.setChecked(false);
                list.add("Bluetooth not enabled");
            }
        }else{
            list.add("No bluetooth support");
        }

        dataAdapter = new ArrayAdapter<String>(view.getContext(), android.R.layout.simple_spinner_dropdown_item, list);
        dataAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        int index = dataAdapter.getPosition(sharedPref.getString(getString(R.string.selected_device_name),"BT_device"));
        spinner1.setAdapter(dataAdapter);
        if(index == -1){
            spinner1.setSelection(0);
        }else{
            spinner1.setSelection(index);
        }

    }

    class ConnectingThread extends Thread {
        public void run() {
            Log.i("Thread","Start");

            Log.i("Thread","End");
        }
    }
}