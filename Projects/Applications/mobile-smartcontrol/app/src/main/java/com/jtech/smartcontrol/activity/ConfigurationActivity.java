package com.jtech.smartcontrol.activity;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.jtech.smartcontrol.R;
import com.jtech.smartcontrol.utils.CustomProgressDialog;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

/**
 * Created by tjozsa on 3/8/2017.
 */

public class ConfigurationActivity extends AppCompatActivity {

    private final Context context = this;
    private boolean isConnected = false;
    private Socket socket;
    private BufferedReader bufferedReader;
    private PrintWriter printWriter;
    private EditText ssidEditText;
    private EditText passwordEditText;
    private EditText apnEditText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.configurator_activity);
        setupConnectButton();
        setupSaveButton();
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        TextView connectionStatusTextView = (TextView) findViewById(R.id.connected_text_view);
        connectionStatusTextView.setText(isConnected ? "Connected" : "Not Connected");
        connectionStatusTextView.setTextColor(isConnected ? Color.GREEN : Color.GRAY);

        ssidEditText = (EditText) findViewById(R.id.ssid_edit_text);
        passwordEditText = (EditText) findViewById(R.id.password_edit_text);
        apnEditText = (EditText) findViewById(R.id.apn_edit_text);
    }

    private void inputReaderThread() {
        Thread thread = new Thread(new Runnable() {

            @Override
            public void run() {

                while (!Thread.interrupted()) {
                    try {

                        String read = bufferedReader.readLine();

                        if (read != null){
                            if (read.contains("SSID")) {
                                String configs[] = read.split(";");
                                for (String config : configs) {
                                    final String args[] = config.split(":");
                                    if (args[0].equals("SSID")) {
                                        ConfigurationActivity.this.runOnUiThread(new Runnable() {
                                            public void run() {
                                                ssidEditText.setText(args[1]);
                                            }
                                        });
                                    }
                                    if (args[0].equals("PASSWORD")) {
                                        ConfigurationActivity.this.runOnUiThread(new Runnable() {
                                            public void run() {
                                                passwordEditText.setText(args[1]);
                                            }
                                        });
                                    }
                                    if (args[0].equals("APN")) {
                                        ConfigurationActivity.this.runOnUiThread(new Runnable() {
                                            public void run() {
                                                apnEditText.setText(args[1]);
                                            }
                                        });
                                    }
                                }
                            }
                        }
                        if (read == null) {
                            Thread.currentThread().interrupt();
                        }


                    } catch (IOException e) {
                        e.printStackTrace();
                    }

                }
            }
        }

        );
        thread.start();
    }

    private void setupConnectButton() {
        Button connectButton = (Button) findViewById(R.id.connect_button);
        connectButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //10.95.98.247
                EditText hostEditText = (EditText) findViewById(R.id.host_edit_text);
                new ConnectToDeviceTask(hostEditText.getText().toString(), 80).execute();
            }
        });
    }

    private void setupSaveButton() {
        Button saveButton = (Button) findViewById(R.id.save_button);
        saveButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                EditText ssidEditText = (EditText) findViewById(R.id.ssid_edit_text);
                EditText passwordEditText = (EditText) findViewById(R.id.password_edit_text);
                EditText apnEditText = (EditText) findViewById(R.id.apn_edit_text);

                if (isConnected()) {

                    final String message = "UPDATE_CONFIG;SSID:" + ssidEditText.getText().toString()
                            + ";PASSWORD:" + passwordEditText.getText().toString()
                            + ";APN:" + apnEditText.getText().toString() + ";\n";

                    Thread thread = new Thread(new Runnable() {
                        @Override
                        public void run() {
                            printWriter.write(message);
                            printWriter.flush();
                        }
                    });
                    thread.start();

                } else {
                    Toast.makeText(context, "Not connected", Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    private void setConnected(boolean connected) {
        isConnected = connected;
    }

    private boolean isConnected() {
        return isConnected;
    }

    private class ConnectToDeviceTask extends AsyncTask<Void, Void, Boolean> {

        private String host;
        private Integer port;

        public ConnectToDeviceTask(String host, Integer port) {
            this.host = host;
            this.port = port;
        }

        @Override
        protected void onPreExecute() {
            CustomProgressDialog.show(context, "Loading...");
            super.onPreExecute();
        }

        @Override
        protected Boolean doInBackground(Void... params) {
            try {
                socket = new Socket(host, port);
                bufferedReader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                printWriter = new PrintWriter(socket.getOutputStream());
                if (socket.isConnected()) {
                    printWriter.write("REQUEST_CONFIG\n");
                    printWriter.flush();
                    inputReaderThread();


                    return true;
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            return false;
        }

        @Override
        protected void onPostExecute(Boolean isConnected) {
            CustomProgressDialog.dismiss();
            setConnected(isConnected);

            TextView connectionStatusTextView = (TextView) findViewById(R.id.connected_text_view);
            connectionStatusTextView.setText(isConnected ? "Connected" : "Not Connected");
            connectionStatusTextView.setTextColor(isConnected ? Color.GREEN : Color.GRAY);

            String message = "";
            if (isConnected) {
                message = "Connection Successful.";
                Toast.makeText(context, message, Toast.LENGTH_SHORT).show();
            } else {
                message = "Connection error. Please use the appropriate WIFI HotSpot (HCM-Network) to connect to your device.";
                AlertDialog.Builder builder = new AlertDialog.Builder(ConfigurationActivity.this);
                builder.setMessage(message)
                        .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {
                                // FIRE ZE MISSILES!
                            }
                        })
                        .setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {
                                // User cancelled the dialog
                            }
                        });
                // Create the AlertDialog object and return it
                builder.create();
                builder.show();
            }

        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        menu.add("Web Console");
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        if (item.getTitle().equals("Web Console")) {
            Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.jtech-iot.com"));
            startActivity(browserIntent);
        }

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

}
