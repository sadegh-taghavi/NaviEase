package org.tdevelopers.naviease;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.content.BroadcastReceiver;
import org.qtproject.qt5.android.bindings.QtApplication;
import org.qtproject.qt5.android.bindings.QtActivity;
import android.util.Log;
import android.content.Intent;
import android.content.IntentFilter;
import android.view.accessibility.AccessibilityManager;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.view.accessibility.AccessibilityEvent;
import android.content.Context;
import android.hardware.SensorManager;
import android.hardware.Sensor;
import android.hardware.SensorEventListener;
import android.hardware.SensorEvent;
import java.util.List;

//import ir.adad.client.AdListener;
//import ir.adad.client.AdView;
//import ir.adad.client.Adad;


public class CustomMainActivity extends QtActivity
{
    public static native void actionDone( int action );
    public static native void valuesChanged();

    public static final int AD_Disable = 0;
    public static final int AD_TurnToLeft_SwipeToLeft = 1;
    public static final int AD_TurnToTop_SwipeToTop = 2;
    public static final int AD_TurnToRight_SwipeToRight = 3;
    public static final int AD_TurnToBottom_SwipeToBottom = 4;
    public static final int AD_TwistRight_SwipeToForward = 5;
    public static final int AD_TwistLeft_SwipeToBackward = 6;
    public static final int AD_Count = 7;

    public static final int AS_Back = 0;
    public static final int AS_Home = 1;
    public static final int AS_Recents = 2;
    public static final int AS_Notifications = 3;
    public static final int AS_QuickSettings = 4;
    public static final int AS_PowerDialog = 5;
    public static final int AS_Count = 6;

    public static final String IA_FromService = "fromService";
    public static final String IA_FromActivity = "fromActivity";

    public static final String IT_Type = "Type";
    public static final int IV_ActivityState = 0;
    public static final int IV_ServiceAction = 1;
    public static final int IV_ServiceSettings = 2;
    public static final int IV_ServiceCommand = 3;

    public static final String IE_ActivityStateValue = "Value";
    public static final String IE_ServiceActionValue = "Value";
    public static final String IE_ServiceCommandValue = "Value";

    public static final int SC_ServiceCommandSave = 0;
    public static final int SC_ServiceCommandLoad = 1;
    public static final int SC_ServiceCommandRequestSettings = 3;

    private float[] m_actionSensitivity = new float[AS_Count];
    private int[]   m_actionDirection = new int[AS_Count];
    private int[]   m_actionVibrate = new int[AS_Count];
    private int     m_actionDelay;
    private boolean m_actionGyroMode;
    private boolean m_actionDoubleEnable;
    private int     m_actionDoubleMinDelay;
    private int     m_actionDoubleMaxDelay;

    private SensorManager m_sensorManager;
    private Sensor m_gyro;

    private BroadcastReceiver m_messageReceiver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, Intent intent) {

            int type = intent.getIntExtra( IT_Type, -1 );
//            Log.d( "############ACT", "type:" + type );
            if( type == IV_ServiceAction ){
                actionDone( intent.getIntExtra( IE_ServiceActionValue, 0) );
            }else if( type == IV_ServiceSettings ){
                for( int i = 0; i < AS_Count; ++i){
                    m_actionSensitivity[i] = intent.getFloatExtra( "m_actionSensitivity" + i, 0 );
                    m_actionDirection[i] = intent.getIntExtra( "m_actionDirection" + i, 0 );
                    m_actionVibrate[i] = intent.getIntExtra( "m_actionVibrate" + i, 0 );
                }
                m_actionDelay = intent.getIntExtra( "m_actionDelay", 0 );
                m_actionGyroMode = intent.getBooleanExtra( "m_actionGyroMode", false );
                m_actionDoubleEnable = intent.getBooleanExtra( "m_actionDoubleEnable", false );
                m_actionDoubleMinDelay = intent.getIntExtra( "m_actionDoubleMinDelay", 0 );
                m_actionDoubleMaxDelay = intent.getIntExtra( "m_actionDoubleMaxDelay", 0 );
                valuesChanged();
            }
        }
    };

    public void sendActivityIsActive( boolean isActive ){
        Intent intent = new Intent(IA_FromActivity);
        intent.putExtra(IT_Type, IV_ActivityState);
        intent.putExtra(IE_ActivityStateValue, isActive);
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
    }

    public void saveSettings(){
        Intent intent = new Intent(IA_FromActivity);
        intent.putExtra(IT_Type, IV_ServiceCommand);
        intent.putExtra(IE_ServiceCommandValue, SC_ServiceCommandSave);
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);

        //Adad.showInterstitialAd( this );
    }

    public void requestSettings(){
        Intent intent = new Intent(IA_FromActivity);
        intent.putExtra(IT_Type, IV_ServiceCommand);
        intent.putExtra(IE_ServiceCommandValue, SC_ServiceCommandRequestSettings);
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
    }

    public void loadSettings(){
        Intent intent = new Intent(IA_FromActivity);
        intent.putExtra(IT_Type, IV_ServiceCommand);
        intent.putExtra(IE_ServiceCommandValue, SC_ServiceCommandLoad);
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
    }

    public void sendSettings(){
        Intent intent = new Intent(IA_FromActivity);
        intent.putExtra(IT_Type, IV_ServiceSettings);
        for( int i = 0; i < AS_Count; ++i){
            intent.putExtra( "m_actionSensitivity" + i, m_actionSensitivity[i] );
            intent.putExtra( "m_actionDirection" + i, m_actionDirection[i] );
            intent.putExtra( "m_actionVibrate" + i, m_actionVibrate[i] );
        }
        intent.putExtra( "m_actionDelay", m_actionDelay );
        intent.putExtra( "m_actionGyroMode", m_actionGyroMode );
        intent.putExtra( "m_actionDoubleEnable", m_actionDoubleEnable );
        intent.putExtra( "m_actionDoubleMinDelay", m_actionDoubleMinDelay );
        intent.putExtra( "m_actionDoubleMaxDelay", m_actionDoubleMaxDelay );
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
    }

    public boolean isServiceActive( String name )
    {
        AccessibilityManager am = (AccessibilityManager)getSystemService(Context.ACCESSIBILITY_SERVICE);
        List<AccessibilityServiceInfo> runningServices = am.getEnabledAccessibilityServiceList(
        AccessibilityEvent.TYPES_ALL_MASK);
        for (AccessibilityServiceInfo service : runningServices)
        {
            if ( service.getId().indexOf(name) > -1 )
                return true;
        }
        return false;
    }

    public boolean isMyServiceActive(){
        return isServiceActive("org.tdevelopers.naviease");
    }

    public void checkAndActiveService(){
        if( isMyServiceActive() )
            sendActivityIsActive( true );
        else
            startAccessibilitySettings();
    }

    public void startAccessibilitySettings(){
        Intent intent = new Intent(android.provider.Settings.ACTION_ACCESSIBILITY_SETTINGS);
        startActivity(intent);
    }

    public boolean isGyroSupported(){
        return ( m_gyro == null ? false : true );
    }

    public float getActionSensitivity( int action ){
        return m_actionSensitivity[action];
    }

    public void setActionSensitivity( int action, float value ){
        m_actionSensitivity[action] = value;
        sendSettings();
    }

    public int getActionDirection( int action ){
        return m_actionDirection[action];
    }

    public void setActionDirection( int action, int value ){
        m_actionDirection[action] = value;
        sendSettings();
    }

    public int getActionVibrate( int action ){
        return m_actionVibrate[action];
    }

    public void setActionVibrate( int action, int value ){
        m_actionVibrate[action] = value;
        sendSettings();
    }

    public int getActionDelay(){
        return m_actionDelay;
    }

    public void setActionDelay( int value ){
        m_actionDelay = value;
        sendSettings();
    }

    public boolean getActionGyroMode(){
        return m_actionGyroMode;
    }

    public void setActionGyroMode( boolean value ){
        m_actionGyroMode = value;
        sendSettings();
    }

    public boolean getActionDoubleEnable(){
        return m_actionDoubleEnable;
    }

    public void setActionDoubleEnable( boolean value ){
        m_actionDoubleEnable = value;
        sendSettings();
    }

    public int getActionDoubleMinDelay(){
        return m_actionDoubleMinDelay;
    }

    public void setActionDoubleMinDelay( int value ){
        m_actionDoubleMinDelay = value;
        sendSettings();
    }

    public int getActionDoubleMaxDelay(){
        return m_actionDoubleMaxDelay;
    }

    public void setActionDoubleMaxDelay( int value ){
        m_actionDoubleMaxDelay = value;
        sendSettings();
    }

    @Override
    public void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);

//        Adad.initialize(getApplicationContext());
//        Adad.prepareInterstitialAd();

        LocalBroadcastManager.getInstance(this).registerReceiver( m_messageReceiver, new IntentFilter(IA_FromService) );
        m_sensorManager = (SensorManager)getSystemService(SENSOR_SERVICE);
        m_gyro = m_sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE);
    }

    @Override
    protected void onResume(){
        checkAndActiveService();
        super.onResume();
    }

    @Override
    protected void onPause(){
        sendActivityIsActive( false );
        super.onPause();
    }

    @Override
    protected void onDestroy(){
        sendActivityIsActive( false );
        super.onDestroy();
    }
}
