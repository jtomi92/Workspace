package com.jtech.smartcontrol.activity;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.animation.AlphaAnimation;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.jtech.smartcontrol.R;
import com.jtech.smartcontrol.model.Component;
import com.jtech.smartcontrol.model.Element;
import com.jtech.smartcontrol.model.Notification;
import com.jtech.smartcontrol.model.NotificationWrapper;
import com.jtech.smartcontrol.model.Relay;
import com.jtech.smartcontrol.model.UserProduct;
import com.jtech.smartcontrol.model.UserProductWrapper;
import com.jtech.smartcontrol.model.UserProfile;
import com.jtech.smartcontrol.model.setting.RelaySetting;
import com.jtech.smartcontrol.utils.AnimationUtils;
import com.jtech.smartcontrol.utils.CustomProgressDialog;
import com.jtech.smartcontrol.adapter.RelayListAdapter;
import com.jtech.smartcontrol.utils.RestUtils;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by tjozsa on 3/5/2017.
 */

public class RelayActivity extends AppCompatActivity {

    private final Context context = this;
    private ListView relayOnListView;
    private ListView relayOffListView;
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

        setUpFloatingActionButton();

        userProfile = (UserProfile) getIntent().getSerializableExtra("userprofile");
        component = (Component) getIntent().getSerializableExtra("component");
        element = (Element) getIntent().getSerializableExtra("element");
        email = getIntent().getStringExtra("email");
        password = getIntent().getStringExtra("password");

        TextView elementNameTextView = (TextView) findViewById(R.id.element_name_text_view);
        elementNameTextView.setText(element.getElementName());

        Button onButton = (Button) findViewById(R.id.on_button);
        Button offButton = (Button) findViewById(R.id.off_button);

        onButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                v.startAnimation(AnimationUtils.buttonClick);
                new MultiSwitchTask(userProfile.getUserId(), component.getComponentId(), element.getElementId(), "ON", email, password).execute();
            }
        });

        offButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                v.startAnimation(AnimationUtils.buttonClick);
                new MultiSwitchTask(userProfile.getUserId(), component.getComponentId(), element.getElementId(), "OFF", email, password).execute();
            }
        });

        new GetUserProductsTask(userProfile.getUserId(), email, password).execute();
    }

    @Override
    protected void onResume() {

        super.onResume();
    }

    public void setUpFloatingActionButton() {
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
                                Spinner productPicker = (Spinner) v1.findViewById(R.id.product_picker);
                                Spinner relayPicker = (Spinner) v1.findViewById(R.id.relay_picker);
                                Spinner relayActionPicker = (Spinner) v1.findViewById(R.id.relay_action_picker);
                                Spinner elementActionPicker = (Spinner) v1.findViewById(R.id.element_action_picker);

                                String serialNumber = productPicker.getSelectedItem().toString();
                                String relayName = relayPicker.getSelectedItem().toString();
                                String relayAction = relayActionPicker.getSelectedItem().toString();
                                String elementAction = elementActionPicker.getSelectedItem().toString();

                                Relay relay = initializeNewRelay(serialNumber, relayName, relayAction, elementAction);

                                if (relay != null) {
                                    Toast.makeText(context, "not null", Toast.LENGTH_SHORT).show();
                                    for (Element el : component.getElements()) {
                                        if (element.getElementId().equals(el.getElementId())) {
                                            el.addRelay(relay);
                                        }
                                    }
                                    element.addRelay(relay);
                                    populateListViews();
                                    new UpdateComponentTask(component, userProfile.getUserId(), email, password).execute();
                                } else {
                                    Toast.makeText(context, "null", Toast.LENGTH_SHORT).show();
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

    private Relay initializeNewRelay(String serialNumber, String relayName, String relayAction, String elementAction) {
        Relay relay = null;
        for (UserProduct userProduct : userProducts) {
            if (userProduct.getSerialNumber().equals(serialNumber)) {
                for (RelaySetting relaySetting : userProduct.getRelaySettings()) {
                    if (relaySetting.getRelayName().equals(relayName)) {
                        relay = new Relay();
                        relay.setSerialNumber(serialNumber);
                        relay.setModuleId(relaySetting.getModuleId());
                        relay.setRelayId(relaySetting.getRelayId());
                        relay.setAction(elementAction);
                        relay.setState(relayAction);
                        relay.setConnectionId(generateConnectionId(element));
                    }
                }
            }
        }
        return relay;
    }

    private Integer generateConnectionId(Element element) {
        Integer connectionId = 1;
        while (true) {
            boolean validId = true;
            for (Relay relay : element.getRelays()) {
                if (connectionId.equals(relay.getConnectionId())) {
                    validId = false;
                    connectionId += 1;
                }
            }
            if (validId) {
                break;
            }
        }
        return connectionId;
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        menu.add("Open Console");
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        if (item.getTitle().equals("Open Console")){
            Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.jtech-iot.com"));
            startActivity(browserIntent);
        }

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    private void populateActions(final View v1) {
        Spinner relayActionPicker = (Spinner) v1.findViewById(R.id.relay_action_picker);
        Spinner elementActionPicker = (Spinner) v1.findViewById(R.id.element_action_picker);

        List<String> actions = new ArrayList<String>();
        actions.add("ON");
        actions.add("OFF");

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(getApplicationContext(),
                android.R.layout.simple_spinner_item, actions);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        relayActionPicker.setAdapter(adapter);
        elementActionPicker.setAdapter(adapter);

        relayActionPicker.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                ((TextView) view).setTextColor(Color.BLACK);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        elementActionPicker.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                ((TextView) view).setTextColor(Color.BLACK);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

    }

    private void populateProductPicker(final View v1) {
        final Spinner productPicker = (Spinner) v1.findViewById(R.id.product_picker);

        final List<String> serialNumbers = new ArrayList<String>();
        serialNumbers.addAll(getSerialNumbers());

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(getApplicationContext(),
                android.R.layout.simple_spinner_item, serialNumbers);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        productPicker.setAdapter(adapter);

        productPicker.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                ((TextView) view).setTextColor(Color.BLACK);
                populateRelayPicker(serialNumbers.get(position).toString(), v1);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
    }

    private void populateRelayPicker(String serialNumber, View v1) {
        Spinner relayPicker = (Spinner) v1.findViewById(R.id.relay_picker);

        List<String> relayNames = new ArrayList<String>();
        relayNames.addAll(getRelayNames(serialNumber));

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(getApplicationContext(),
                android.R.layout.simple_spinner_item, relayNames);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        relayPicker.setAdapter(adapter);

        relayPicker.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                ((TextView) view).setTextColor(Color.BLACK);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
    }

    private List<String> getRelayNames(String serialNumber) {
        List<String> relayNames = new LinkedList<>();
        for (UserProduct userProduct : userProducts) {
            if (userProduct.getSerialNumber().equals(serialNumber)) {
                for (RelaySetting relaySetting : userProduct.getRelaySettings()) {
                    relayNames.add(relaySetting.getRelayName());
                }
            }
        }
        return relayNames;
    }

    private List<String> getSerialNumbers() {
        List<String> serialNumbers = new LinkedList<>();
        for (UserProduct userProduct : userProducts) {
            serialNumbers.add(userProduct.getSerialNumber());
        }
        return serialNumbers;
    }

    private void populateListViews() {

        relayOnListView = (ListView) findViewById(R.id.relay_on_listview);
        relayOffListView = (ListView) findViewById(R.id.relay_off_listview);

        List<Relay> listOfRelayOn = new LinkedList<>();
        List<Relay> listOfRelayOff = new LinkedList<>();
        for (Relay relay : element.getRelays()) {
            if (relay.getAction().equals("ON")) {
                listOfRelayOn.add(relay);
            } else {
                listOfRelayOff.add(relay);
            }
        }

        relayOnListView.setAdapter(new RelayListAdapter(this, listOfRelayOn, component, element, userProducts, email, password, userProfile));
        relayOffListView.setAdapter(new RelayListAdapter(this, listOfRelayOff, component, element, userProducts, email, password, userProfile));
    }


    private class GetUserProductsTask extends AsyncTask<Void, Void, UserProductWrapper> {

        private Integer userId;
        private String email;
        private String password;

        public GetUserProductsTask(Integer userId, String email, String password) {
            this.userId = userId;
            this.email = email;
            this.password = password;
        }

        @Override
        protected void onPreExecute() {
            CustomProgressDialog.show(context,"Loading...");
            super.onPreExecute();
        }

        @Override
        protected UserProductWrapper doInBackground(Void... params) {
            try {
                RestUtils.initialize(email, password);
                ResponseEntity<UserProductWrapper> responseEntity = RestUtils.getRestTemplate().exchange(RestUtils.REST_GET_USER_PRODUCTS,
                        HttpMethod.GET, RestUtils.getHttpEntity(), UserProductWrapper.class, userId);
                return responseEntity.getBody();
            } catch (Exception e) {
                Log.e("RestUtils", e.getMessage(), e);
            }
            return null;
        }

        @Override
        protected void onPostExecute(UserProductWrapper userProductWrapper) {
            CustomProgressDialog.dismiss();
            userProducts = userProductWrapper.getUserProducts();
            populateListViews();
        }
    }

    private class MultiSwitchTask extends AsyncTask<Void, Void, NotificationWrapper> {

        private Integer userId;
        private Integer componentId;
        private Integer elementId;
        private String action;
        private String email;
        private String password;
        private ProgressDialog dialog;

        public MultiSwitchTask(Integer userId, Integer componentId, Integer elementId, String action, String email, String password) {
            this.userId = userId;
            this.componentId = componentId;
            this.elementId = elementId;
            this.action = action;
            this.email = email;
            this.password = password;
        }

        @Override
        protected void onPreExecute() {
            CustomProgressDialog.show(context,"Loading...");
            super.onPreExecute();
        }

        @Override
        protected NotificationWrapper doInBackground(Void... params) {
            try {
                RestUtils.initialize(email, password);
                ResponseEntity<NotificationWrapper> responseEntity = RestUtils.getRestTemplate().exchange(RestUtils.REST_MULTI_SWITCH,
                        HttpMethod.GET, RestUtils.getHttpEntity(), NotificationWrapper.class, userId, componentId, elementId, action);
                return responseEntity.getBody();
            } catch (Exception e) {
                Log.e("RestUtils", e.getMessage(), e);
            }
            return null;
        }

        @Override
        protected void onPostExecute(NotificationWrapper notificationWrapper) {
            CustomProgressDialog.dismiss();
            StringBuilder sb = new StringBuilder();
            if (notificationWrapper != null && notificationWrapper.getNotifications() != null) {
                for (Notification n : notificationWrapper.getNotifications()) {
                    if (n.getNs().get(0).equals("OK")) {
                        sb.append(n.getSn() + " - " + "Success\n");
                    } else {
                        sb.append(n.getSn() + " - " + "Error\n");
                    }
                }
                Toast.makeText(context, sb.toString(), Toast.LENGTH_SHORT).show();
            }
        }
    }


    private class UpdateComponentTask extends AsyncTask<Void, Void, Integer> {

        private Component component;
        private Integer userId;
        private ProgressDialog dialog;
        private String email;
        private String password;

        public UpdateComponentTask(Component component, Integer userId, String email, String password) {
            this.component = component;
            this.userId = userId;
            this.email = email;
            this.password = password;
        }

        @Override
        protected void onPreExecute() {
            CustomProgressDialog.show(context,"Loading...");
            super.onPreExecute();
        }

        @Override
        protected Integer doInBackground(Void... params) {
            try {
                RestUtils.initialize(email,password);
                HttpEntity<Object> httpEntity = new HttpEntity<Object>(component, RestUtils.getRequestHeaders());
                ResponseEntity<Integer> response = RestUtils.getRestTemplate().exchange(RestUtils.REST_UPDATE_COMPONENT, HttpMethod.PUT,
                        httpEntity, Integer.class, userId);
                return response.getBody();
            } catch (Exception e) {
                Log.e("RestUtils", e.getMessage(), e);
            }
            return 0;
        }

        @Override
        protected void onPostExecute(Integer response) {
            CustomProgressDialog.dismiss();
        }
    }
}
