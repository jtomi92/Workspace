package com.jtech.smartcontrol.adapter;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.jtech.smartcontrol.R;
import com.jtech.smartcontrol.activity.RelayActivity;
import com.jtech.smartcontrol.model.Component;
import com.jtech.smartcontrol.model.Element;
import com.jtech.smartcontrol.model.Notification;
import com.jtech.smartcontrol.model.NotificationWrapper;
import com.jtech.smartcontrol.model.UserProfile;
import com.jtech.smartcontrol.utils.AnimationUtils;
import com.jtech.smartcontrol.utils.CustomProgressDialog;
import com.jtech.smartcontrol.utils.RestUtils;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;

/**
 * Created by tjozsa on 3/4/2017.
 */

public class ElementListAdapter extends BaseAdapter {

    Context context;
    Component component;
    private String email;
    private String password;
    private UserProfile userProfile;
    private static LayoutInflater inflater = null;

    public ElementListAdapter(Context context, Component component, String email, String password, UserProfile userProfile) {
        // TODO Auto-generated constructor stub
        this.email = email;
        this.password = password;
        this.userProfile = userProfile;
        this.context = context;
        this.component = component;
        inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public int getCount() {
        // TODO Auto-generated method stub
        return component.getElements().size();
    }

    @Override
    public Object getItem(int position) {
        // TODO Auto-generated method stub
        return component.getElements().get(position);
    }

    @Override
    public long getItemId(int position) {
        // TODO Auto-generated method stub
        return position;
    }

    @Override
    public View getView(final int position, View convertView, final ViewGroup parent) {
        // TODO Auto-generated method stub
        View vi = convertView;
        if (vi == null)
            vi = inflater.inflate(R.layout.element_list_item, null);

        Button onButton = (Button) vi.findViewById(R.id.on_button);
        Button offButton = (Button) vi.findViewById(R.id.off_button);

        onButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                v.startAnimation(AnimationUtils.buttonClick);
                new MultiSwitchTask(userProfile.getUserId(), component.getComponentId(), component.getElements().get(position).getElementId(), "ON", email, password).execute();
            }
        });
        offButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                v.startAnimation(AnimationUtils.buttonClick);
                new MultiSwitchTask(userProfile.getUserId(), component.getComponentId(), component.getElements().get(position).getElementId(), "OFF", email, password).execute();
            }
        });

        TextView elementName = (TextView) vi.findViewById(R.id.element_name_text_view);
        elementName.setText(component.getElements().get(position).getElementName());
        vi.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                v.startAnimation(AnimationUtils.buttonClick);
                Element element = component.getElements().get(position);
                Intent intent = new Intent(context, RelayActivity.class);
                intent.putExtra("component", component);
                intent.putExtra("element", element);
                intent.putExtra("email", email);
                intent.putExtra("password", password);
                intent.putExtra("userprofile", userProfile);
                context.startActivity(intent);
            }
        });

        vi.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                v.startAnimation(AnimationUtils.buttonClick);
                final AlertDialog.Builder builder = new AlertDialog.Builder(context);
                // Inflate and set the layout for the dialog
                // Pass null as the parent view because its going in the dialog layout
                final View v1 = inflater.inflate(R.layout.component_dialogbox, null);
                EditText editText = (EditText) v1.findViewById(R.id.component_edit_text);
                editText.setText(component.getElements().get(position).getElementName());
                builder.setView(v1)
                        // Add action buttons
                        .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int id) {
                                EditText editText = (EditText) v1.findViewById(R.id.component_edit_text);
                                String elementName = editText.getText().toString();
                                Element element = component.getElements().get(position);
                                element.setElementName(elementName);
                                new UpdateComponentTask(component, userProfile.getUserId(), email, password).execute();
                            }
                        })
                        .setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {

                            }
                        })
                        .setNeutralButton("Delete", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                component.getElements().remove(position);
                                new UpdateComponentTask(component, userProfile.getUserId(), email, password).execute();
                            }
                        });
                builder.create();
                builder.show();

                return false;
            }
        });
        return vi;
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
            CustomProgressDialog.show(context, "Loading...");
            super.onPreExecute();
        }

        @Override
        protected Integer doInBackground(Void... params) {
            try {
                RestUtils.initialize(email, password);
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
            ElementListAdapter.this.notifyDataSetChanged();
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
            CustomProgressDialog.show(context, "Waiting for device...");
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
}
