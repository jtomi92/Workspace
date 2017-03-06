package com.jtech.smartcontrol.utils;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import com.jtech.smartcontrol.R;
import com.jtech.smartcontrol.activity.RelayActivity;
import com.jtech.smartcontrol.model.Component;
import com.jtech.smartcontrol.model.Element;
import com.jtech.smartcontrol.model.Relay;
import com.jtech.smartcontrol.model.UserProduct;
import com.jtech.smartcontrol.model.UserProfile;
import com.jtech.smartcontrol.model.setting.RelaySetting;

import java.util.List;

/**
 * Created by tjozsa on 3/5/2017.
 */

public class RelayListAdapter extends BaseAdapter{
    Context context;
    List<Relay> relays;
    private String email;
    private String password;
    private UserProfile userProfile;
    private List<UserProduct> userProducts;
    private static LayoutInflater inflater = null;

    public RelayListAdapter(Context context, List<Relay> relays, List<UserProduct> userProducts, String email, String password, UserProfile userProfile) {
        // TODO Auto-generated constructor stub
        this.email = email;
        this.password = password;
        this.userProfile = userProfile;
        this.context = context;
        this.relays = relays;
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

        relayName.setText(getRelayName(relays.get(position).getSerialNumber(),relays.get(position).getModuleId(),relays.get(position).getRelayId()));
        sw.setChecked(relays.get(position).getState().equals("OFF"));

        vi.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });

        vi.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {

                final AlertDialog.Builder builder = new AlertDialog.Builder(context);
                // Inflate and set the layout for the dialog
                // Pass null as the parent view because its going in the dialog layout
                final View v1 = inflater.inflate(R.layout.relay_list_item, null);
                TextView elementName = (TextView) v1.findViewById(R.id.relay_name_text_view);
                elementName.setText(relays.get(position).getSerialNumber());

                builder.setView(v1)
                        // Add action buttons
                        .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int id) {

                            }
                        })
                        .setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {

                            }
                        })
                        .setNeutralButton("Delete", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {

                            }
                        });
                builder.create();
                builder.show();

                return false;
            }
        });
        return vi;
    }

    private String getRelayName(String serialNumber, Integer moduleId, Integer relayId){
        for (UserProduct userProduct : userProducts){
            if (userProduct.getSerialNumber().equals(serialNumber)){
                for (RelaySetting relaySetting : userProduct.getRelaySettings()){
                    if (relaySetting.getModuleId().equals(moduleId) && relaySetting.getRelayId().equals(relayId)){
                        return relaySetting.getRelayName();
                    }
                }
            }
        }
        return "";
    }
}
