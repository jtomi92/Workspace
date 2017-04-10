package com.jtech.smartcontrol.adapter;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CompoundButton;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import com.jtech.smartcontrol.R;
import com.jtech.smartcontrol.model.Component;
import com.jtech.smartcontrol.model.Element;
import com.jtech.smartcontrol.model.Relay;
import com.jtech.smartcontrol.model.UserProduct;
import com.jtech.smartcontrol.model.UserProfile;
import com.jtech.smartcontrol.model.setting.RelaySetting;
import com.jtech.smartcontrol.utils.AnimationUtils;
import com.jtech.smartcontrol.utils.CustomProgressDialog;
import com.jtech.smartcontrol.utils.RestUtils;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;

import java.util.List;

/**
 * Created by tjozsa on 3/5/2017.
 */

public class RelayListAdapter extends BaseAdapter {
    private Context context;
    private Component component;
    private Element element;
    private List<Relay> relays;
    private String email;
    private String password;
    private UserProfile userProfile;
    private List<UserProduct> userProducts;
    private static LayoutInflater inflater = null;

    public RelayListAdapter(Context context, List<Relay> relays, Component component, Element element, List<UserProduct> userProducts, String email, String password, UserProfile userProfile) {
        // TODO Auto-generated constructor stub
        this.email = email;
        this.password = password;
        this.userProfile = userProfile;
        this.context = context;
        this.relays = relays;
        this.component = component;
        this.element = element;
        this.userProducts = userProducts;

        inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public int getCount() {
        // TODO Auto-generated method stub
        return relays.size();
    }

    @Override
    public Object getItem(int position) {
        // TODO Auto-generated method stub
        return relays.get(position);
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
            vi = inflater.inflate(R.layout.relay_list_item, null);
        TextView relayName = (TextView) vi.findViewById(R.id.relay_name_text_view);
        Switch sw = (Switch) vi.findViewById(R.id.control_switch);

        relayName.setText(getRelayName(relays.get(position).getSerialNumber(), relays.get(position).getModuleId(), relays.get(position).getRelayId()));
        sw.setChecked(relays.get(position).getState().equals("ON"));

        sw.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                for (Element el : component.getElements()) {
                    if (el.getElementId().equals(element.getElementId())) {
                        for (Relay relay : el.getRelays()) {
                            if (relay.getConnectionId().equals(relays.get(position).getConnectionId())) {
                                if (isChecked) {
                                    relay.setState("ON");
                                } else {
                                    relay.setState("OFF");
                                }
                            }
                        }
                    }
                }
                if (isChecked) {
                    relays.get(position).setState("ON");
                } else {
                    relays.get(position).setState("OFF");
                }
                new UpdateComponentTask(component, userProfile.getUserId(), email, password).execute();
            }


        });

        vi.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                v.setAnimation(AnimationUtils.buttonClick);
            }
        });

        vi.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                v.setAnimation(AnimationUtils.buttonClick);
                final AlertDialog.Builder builder = new AlertDialog.Builder(context);
                // Inflate and set the layout for the dialog
                // Pass null as the parent view because its going in the dialog layout
                final View v1 = inflater.inflate(R.layout.relay_edit_dialogbox, null);
                TextView serialNumberTextView = (TextView) v1.findViewById(R.id.serial_number_text_view);
                serialNumberTextView.setText(relays.get(position).getSerialNumber());

                TextView relayNameTextView = (TextView) v1.findViewById(R.id.relay_name_text_view);
                relayNameTextView.setText(getRelayName(relays.get(position).getSerialNumber(), relays.get(position).getModuleId(), relays.get(position).getRelayId()));

                builder.setView(v1)
                        // Add action buttons
                        .setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {

                            }
                        })
                        .setNeutralButton("Delete", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                List<Element> elements = component.getElements();
                                Relay relayToRemove = null;
                                for (Element el : elements) {
                                    if (el.getElementId().equals(element.getElementId())) {
                                        for (Relay relay : el.getRelays()) {
                                            if (relay.getConnectionId().equals(relays.get(position).getConnectionId())) {
                                                relayToRemove = relay;
                                            }
                                        }
                                        if (relayToRemove != null) {
                                            el.getRelays().remove(relayToRemove);
                                            relays.remove(position);
                                            Toast.makeText(context, el.getRelays().get(position).getState() + " " + relayToRemove.getState() + " " + relayToRemove.getAction() + " " + getRelayName(relayToRemove.getSerialNumber(), relayToRemove.getModuleId(), relayToRemove.getRelayId()), Toast.LENGTH_SHORT).show();

                                            new UpdateComponentTask(component, userProfile.getUserId(), email, password).execute();
                                        }
                                    }
                                }

                            }
                        });
                builder.create();
                builder.show();

                return false;
            }
        });
        return vi;
    }

    private String getRelayName(String serialNumber, Integer moduleId, Integer relayId) {
        for (UserProduct userProduct : userProducts) {
            if (userProduct.getSerialNumber().equals(serialNumber)) {
                for (RelaySetting relaySetting : userProduct.getRelaySettings()) {
                    if (relaySetting.getModuleId().equals(moduleId) && relaySetting.getRelayId().equals(relayId)) {
                        return relaySetting.getRelayName();
                    }
                }
            }
        }
        return "";
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
            RelayListAdapter.this.notifyDataSetChanged();
        }
    }
}
