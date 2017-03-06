package com.jtech.smartcontrol.activity;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.SpinnerAdapter;
import android.widget.Toast;

import com.jtech.smartcontrol.R;
import com.jtech.smartcontrol.model.Component;
import com.jtech.smartcontrol.model.Element;
import com.jtech.smartcontrol.model.Relay;
import com.jtech.smartcontrol.model.UserProduct;
import com.jtech.smartcontrol.model.UserProfile;
import com.jtech.smartcontrol.model.setting.RelaySetting;
import com.jtech.smartcontrol.utils.ComponentListAdapter;
import com.jtech.smartcontrol.utils.RelayListAdapter;
import com.jtech.smartcontrol.utils.RestUtils;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by tjozsa on 3/5/2017.
 */

public class RelayActivity extends AppCompatActivity{

    private final Context context = this;
    private ListView relayOnListView;
    private ListView relayOffListView;
    private RestUtils restUtils;
    private UserProfile userProfile;
    private List<UserProduct> userProducts;
    private Component component;
    private Element element;
    private String email;
    private String password;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.relay_activity);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        setUpFloatingActionButton();

        userProfile = (UserProfile)getIntent().getSerializableExtra("userprofile");
        component = (Component)getIntent().getSerializableExtra("component");
        element = (Element)getIntent().getSerializableExtra("element");
        email = getIntent().getStringExtra("email");
        password = getIntent().getStringExtra("password");

        restUtils = new RestUtils(email,password);
        userProducts = restUtils.getUserProducts(userProfile.getUserId());

        relayOnListView = (ListView) findViewById(R.id.relay_on_listview);
        relayOffListView = (ListView) findViewById(R.id.relay_off_listview);

        populateListViews();
    }

    @Override
    protected void onResume() {

        super.onResume();
    }

    public void setUpFloatingActionButton(){
        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab3);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AlertDialog.Builder builder = new AlertDialog.Builder(context);
                // Get the layout inflater
                LayoutInflater inflater = RelayActivity.this.getLayoutInflater();

                // Inflate and set the layout for the dialog
                // Pass null as the parent view because its going in the dialog layout
                final View v1 = inflater.inflate(R.layout.relay_dialogbox, null);

                populateProductPicker(v1);
                populateActions(v1);

                builder.setView(v1)
                        // Add action buttons
                        .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int id) {
                                Spinner productPicker = (Spinner)v1.findViewById(R.id.product_picker);
                                Spinner relayPicker = (Spinner)v1.findViewById(R.id.relay_picker);
                                Spinner relayActionPicker = (Spinner)v1.findViewById(R.id.relay_action_picker);
                                Spinner elementActionPicker = (Spinner)v1.findViewById(R.id.element_action_picker);

                                String serialNumber = productPicker.getSelectedItem().toString();
                                String relayName = relayPicker.getSelectedItem().toString();
                                String relayAction = relayActionPicker.getSelectedItem().toString();
                                String elementAction = elementActionPicker.getSelectedItem().toString();

                                Relay relay = initializeNewRelay(serialNumber, relayName, relayAction, elementAction);

                                if (relay != null){
                                    Toast.makeText(context,"not null",Toast.LENGTH_SHORT).show();
                                    for (Element el : component.getElements()){
                                        if (element.getElementId().equals(el.getElementId())){
                                            el.addRelay(relay);
                                        }
                                    }
                                    element.addRelay(relay);
                                    populateListViews();
                                    restUtils.updateComponent(component,userProfile.getUserId());
                                } else {
                                    Toast.makeText(context,"null",Toast.LENGTH_SHORT).show();
                                }
                            }
                        })
                        .setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {

                            }
                        });
                builder.create();
                builder.show();
            }
        });
    }

    private Relay initializeNewRelay(String serialNumber, String relayName, String relayAction, String elementAction){
        Relay relay = null;
        for (UserProduct userProduct : userProducts){
            if (userProduct.getSerialNumber().equals(serialNumber)){
                for (RelaySetting relaySetting : userProduct.getRelaySettings()){
                    if (relaySetting.getRelayName().equals(relayName)){
                        relay = new Relay();
                        relay.setSerialNumber(serialNumber);
                        relay.setModuleId(relaySetting.getModuleId());
                        relay.setRelayId(relaySetting.getRelayId());
                        relay.setAction(elementAction);
                        relay.setState(relayAction);
                        relay.setConnectionId(element.getRelays().size()+1);
                    }
                }
            }
        }
        return relay;
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    private void populateActions(final View v1){
        Spinner relayActionPicker = (Spinner)v1.findViewById(R.id.relay_action_picker);
        Spinner elementActionPicker = (Spinner)v1.findViewById(R.id.element_action_picker);

        List<String> actions = new ArrayList<String>();
        actions.add("ON");
        actions.add("OFF");

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(getApplicationContext(),
                android.R.layout.simple_spinner_item, actions);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        relayActionPicker.setAdapter(adapter);
        elementActionPicker.setAdapter(adapter);
    }

    private void populateProductPicker(final View v1){
        Spinner productPicker = (Spinner)v1.findViewById(R.id.product_picker);

        final List<String> serialNumbers = new ArrayList<String>();
        serialNumbers.addAll(getSerialNumbers());

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(getApplicationContext(),
                android.R.layout.simple_spinner_item, serialNumbers);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        productPicker.setAdapter(adapter);

        productPicker.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                populateRelayPicker(serialNumbers.get(position).toString(), v1);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
    }

    private void populateRelayPicker(String serialNumber, View v1){
        Spinner relayPicker = (Spinner)v1.findViewById(R.id.relay_picker);

        List<String> relayNames = new ArrayList<String>();
        relayNames.addAll(getRelayNames(serialNumber));

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(getApplicationContext(),
                android.R.layout.simple_spinner_item, relayNames);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        relayPicker.setAdapter(adapter);
    }

    private List<String> getRelayNames(String serialNumber){
        List<String> relayNames = new LinkedList<>();
        for (UserProduct userProduct : userProducts){
            if (userProduct.getSerialNumber().equals(serialNumber)){
                for (RelaySetting relaySetting : userProduct.getRelaySettings()){
                    relayNames.add(relaySetting.getRelayName());
                }
            }
        }
        return relayNames;
    }

    private List<String> getSerialNumbers(){
        List<String> serialNumbers = new LinkedList<>();
        for (UserProduct userProduct : userProducts){
            serialNumbers.add(userProduct.getSerialNumber());
        }
        return serialNumbers;
    }

    private void populateListViews(){
        List<Relay> listOfRelayOn = new LinkedList<>();
        List<Relay> listOfRelayOff = new LinkedList<>();
        for (Relay relay : element.getRelays()){
            if (relay.getAction().equals("ON")){
                listOfRelayOn.add(relay);
            } else {
                listOfRelayOff.add(relay);
            }
        }

        relayOnListView.setAdapter(new RelayListAdapter(this, listOfRelayOn, userProducts, email, password, userProfile));
        relayOffListView.setAdapter(new RelayListAdapter(this, listOfRelayOff, userProducts, email, password, userProfile));
    }
}
