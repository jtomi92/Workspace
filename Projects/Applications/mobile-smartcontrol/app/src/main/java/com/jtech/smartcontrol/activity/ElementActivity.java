package com.jtech.smartcontrol.activity;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
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
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.jtech.smartcontrol.R;
import com.jtech.smartcontrol.model.Component;
import com.jtech.smartcontrol.model.ComponentWrapper;
import com.jtech.smartcontrol.model.Element;
import com.jtech.smartcontrol.model.Relay;
import com.jtech.smartcontrol.model.UserProfile;
import com.jtech.smartcontrol.utils.CustomProgressDialog;
import com.jtech.smartcontrol.adapter.ElementListAdapter;
import com.jtech.smartcontrol.utils.RestUtils;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by tjozsa on 3/4/2017.
 */

public class ElementActivity extends AppCompatActivity {

    private final Context context = this;
    private ListView listView;
    private Component component;
    private String email;
    private String password;
    private UserProfile userProfile;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.element_activity);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        setUpFloatingActionButton();

        email = getIntent().getStringExtra("email");
        password = getIntent().getStringExtra("password");
        component = (Component) getIntent().getSerializableExtra("component");
        userProfile = (UserProfile) getIntent().getSerializableExtra("userprofile");

        listView = (ListView) findViewById(R.id.element_list_view);
        listView.setAdapter(new ElementListAdapter(context, component, email, password, userProfile));

        TextView componentNameTextView = (TextView) findViewById(R.id.component_name_text_view);
        componentNameTextView.setText(component.getComponentName());

    }

    @Override
    protected void onResume() {
        new GetComponentsTask(userProfile.getUserId(), email, password).execute();
        super.onResume();
    }


    public void setUpFloatingActionButton() {
        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab2);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AlertDialog.Builder builder = new AlertDialog.Builder(context);
                // Get the layout inflater
                LayoutInflater inflater = ElementActivity.this.getLayoutInflater();

                // Inflate and set the layout for the dialog
                // Pass null as the parent view because its going in the dialog layout
                final View v1 = inflater.inflate(R.layout.component_dialogbox, null);
                builder.setView(v1)
                        // Add action buttons
                        .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int id) {
                                EditText editText = (EditText) v1.findViewById(R.id.component_edit_text);
                                String elementName = editText.getText().toString();
                                Element element = new Element();
                                element.setElementName(elementName);
                                element.setElementId(generateElementId(component));
                                element.setSequence(generateElementId(component));
                                element.setRelays(new LinkedList<Relay>());
                                component.addElement(element);

                                new UpdateComponentTask(component,userProfile.getUserId(), email, password).execute();
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

    private Integer generateElementId(Component component) {
        Integer elementId = 1;
        while (true) {
            boolean validId = true;
            for (Element element : component.getElements()) {
                if (elementId.equals(element.getElementId())) {
                    validId = false;
                    elementId += 1;
                }
            }
            if (validId) {
                break;
            }
        }
        return elementId;
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

        if (item.getTitle().equals("Web Console")){
            Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.jtech-iot.com"));
            startActivity(browserIntent);
        }

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    private class GetComponentsTask extends AsyncTask<Void, Void, ComponentWrapper> {

        private Integer userId;
        private String email;
        private String password;
        private ProgressDialog dialog;

        public GetComponentsTask(Integer userId, String email, String password) {
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
        protected ComponentWrapper doInBackground(Void... params) {
            try {
                RestUtils.initialize(email, password);
                ResponseEntity<ComponentWrapper> responseEntity = RestUtils.getRestTemplate().exchange(RestUtils.REST_GET_COMPONENTS,
                        HttpMethod.GET, RestUtils.getHttpEntity(), ComponentWrapper.class, userId);
                return responseEntity.getBody();
            } catch (Exception e) {
                Log.e("RestUtils", e.getMessage(), e);
            }
            return null;
        }

        @Override
        protected void onPostExecute(ComponentWrapper componentWrapper) {

            CustomProgressDialog.dismiss();

            List<Component> componentList = componentWrapper.getComponents();
            for (Component comp : componentList) {
                if (comp.getComponentId().equals(component.getComponentId())) {
                    component = comp;
                }
            }
            listView = (ListView) findViewById(R.id.element_list_view);
            listView.setAdapter(new ElementListAdapter(context, component, email, password, userProfile));
        }
    }



    private class UpdateComponentTask extends AsyncTask<Void, Void, Integer> {

        private Component component;
        private Integer userId;
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
            listView.setAdapter(new ElementListAdapter(context, component, email, password, userProfile));
        }
    }
}
