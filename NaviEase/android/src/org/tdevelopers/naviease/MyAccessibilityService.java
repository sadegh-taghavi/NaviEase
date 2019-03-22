package org.tdevelopers.naviease;
import android.support.v4.content.LocalBroadcastManager;
import android.content.BroadcastReceiver;
import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.view.accessibility.AccessibilityEvent;
import android.hardware.SensorManager;
import android.hardware.Sensor;
import android.hardware.SensorEventListener;
import android.hardware.SensorEvent;
import android.os.SystemClock;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import java.lang.Math;
import android.content.Context;
import android.os.Vibrator;
import android.util.Log;
import android.os.PowerManager;

public class MyAccessibilityService extends AccessibilityService implements SensorEventListener
{
    private PowerManager m_powerManager;
    private SensorManager m_sensorManager;
    private Sensor m_gyro;
    private Sensor m_accel;
    private SharedPreferences m_shPr;
    private SharedPreferences.Editor m_shPrW;
    private long m_lastActionTime;
    private long m_startDoubleTime;
    private int m_doubleActionStart;
    private boolean m_doubleActionDo;
    private Vibrator m_vibrator;

    private float m_gyroMaxRange;
    private float m_accelMaxRange;

    private float[] m_actionSensitivity = new float[CustomMainActivity.AS_Count];
    private int[]   m_actionDirection = new int[CustomMainActivity.AS_Count];
    private int[]   m_actionVibrate = new int[CustomMainActivity.AS_Count];
    private int     m_actionDelay;
    private boolean m_actionGyroMode;
    private boolean m_actionDoubleEnable;
    private int     m_actionDoubleMinDelay;
    private int     m_actionDoubleMaxDelay;
    private boolean m_isActivityActive;
    private float[]   m_lastValues = new float[3];
    private BroadcastReceiver m_messageReceiver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, Intent intent) {
            int type = intent.getIntExtra( CustomMainActivity.IT_Type, -1 );
            //Log.d( "############SER", "type:" + type );
            if( type == CustomMainActivity.IV_ActivityState ){
                m_isActivityActive = intent.getBooleanExtra( CustomMainActivity.IE_ActivityStateValue, false);
            }else if( type == CustomMainActivity.IV_ServiceCommand ){
                int cmd = intent.getIntExtra( CustomMainActivity.IE_ServiceCommandValue, -1 );
                if( cmd == CustomMainActivity.SC_ServiceCommandSave )
                    saveSettings();
                else if( cmd == CustomMainActivity.SC_ServiceCommandLoad )
                    loadSettings();
                else if( cmd == CustomMainActivity.SC_ServiceCommandRequestSettings )
                    sendSettings();

            }else if( type == CustomMainActivity.IV_ServiceSettings ){
                for( int i = 0; i < CustomMainActivity.AS_Count; ++i){
                    m_actionSensitivity[i] = intent.getFloatExtra( "m_actionSensitivity" + i, 0 );
                    m_actionDirection[i] = intent.getIntExtra( "m_actionDirection" + i, 0 );
                    m_actionVibrate[i] = intent.getIntExtra( "m_actionVibrate" + i, 0 );
                }
                m_actionDelay = intent.getIntExtra( "m_actionDelay", 0 );
                setActionGyroMode( intent.getBooleanExtra( "m_actionGyroMode", false ) );
                m_actionDoubleEnable = intent.getBooleanExtra( "m_actionDoubleEnable", false );
                m_actionDoubleMinDelay = intent.getIntExtra( "m_actionDoubleMinDelay", 0 );
                m_actionDoubleMaxDelay = intent.getIntExtra( "m_actionDoubleMaxDelay", 0 );
            }
        }

    };

    private void sendServiceAction( int action ){
        Intent intent = new Intent(CustomMainActivity.IA_FromService);
        intent.putExtra(CustomMainActivity.IT_Type, CustomMainActivity.IV_ServiceAction);
        intent.putExtra(CustomMainActivity.IE_ServiceActionValue, action);
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
    }

    private void sendSettings(){
        Intent intent = new Intent(CustomMainActivity.IA_FromService);
        intent.putExtra(CustomMainActivity.IT_Type, CustomMainActivity.IV_ServiceSettings);
        for( int i = 0; i < CustomMainActivity.AS_Count; ++i){
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

    private boolean isActivityActive(){
        return m_isActivityActive;
    }


    private void saveSettings(){
        m_shPrW.putBoolean("m_actionGyroMode", m_actionGyroMode );
        for( int i = 0; i < CustomMainActivity.AS_Count; ++i){
            m_shPrW.putFloat("m_actionSensitivity" + i, m_actionSensitivity[i]);
            m_shPrW.putInt("m_actionDirection" + i, m_actionDirection[i]);
            m_shPrW.putInt("m_actionVibrate" + i, m_actionVibrate[i]);
        }
        m_shPrW.putInt("m_actionDelay" + m_actionGyroMode, m_actionDelay );
        m_shPrW.putBoolean("m_actionDoubleEnable", m_actionDoubleEnable );
        m_shPrW.putInt("m_actionDoubleMinDelay", m_actionDoubleMinDelay );
        m_shPrW.putInt("m_actionDoubleMaxDelay", m_actionDoubleMaxDelay );
        m_shPrW.commit();
    }

    private void loadSettings(){
        setActionGyroMode( m_shPr.getBoolean("m_actionGyroMode", true ) );
        float defaultSensitivity;
        if( m_actionGyroMode )
            defaultSensitivity = 0.3f;
        else
            defaultSensitivity = 0.9f;
        for( int i = 0; i < CustomMainActivity.AS_Count; ++i){
            m_actionSensitivity[i] = m_shPr.getFloat("m_actionSensitivity" + i,
            ( ( !m_actionGyroMode && i == CustomMainActivity.AS_Home ) ? 0.5f : defaultSensitivity ) );
            m_actionDirection[i] = m_shPr.getInt("m_actionDirection" + i,
            ( ( m_actionGyroMode || i < CustomMainActivity.AS_QuickSettings ) ?
            ( ( !m_actionGyroMode && i == CustomMainActivity.AS_Notifications ) ?
                CustomMainActivity.AD_TwistRight_SwipeToForward : i + 1 )
            : 0 ) );
            m_actionVibrate[i] = m_shPr.getInt("m_actionVibrate" + i, 80 );
        }
        m_actionDelay = m_shPr.getInt("m_actionDelay", 800 );
        m_actionDoubleEnable = m_shPr.getBoolean("m_actionDoubleEnable", false );
        m_actionDoubleMinDelay = m_shPr.getInt("m_actionDoubleMinDelay", 100 );
        m_actionDoubleMaxDelay = m_shPr.getInt("m_actionDoubleMaxDelay", 350 );
        sendSettings();
    }

    void setActionGyroMode( boolean value )
    {
        if( value && m_gyro == null )
            value = false;
        m_actionGyroMode = value;
        m_sensorManager.unregisterListener(this);
        if( m_actionGyroMode )
            m_sensorManager.registerListener( this, m_gyro, 50000 );
        else
            m_sensorManager.registerListener( this, m_accel, 30000 );
    }

    @Override
    public boolean onUnbind(Intent intent) {
        return true;
    }

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event){

    }

    @Override
    protected void onServiceConnected(){
        LocalBroadcastManager.getInstance(this).registerReceiver( m_messageReceiver, new IntentFilter(CustomMainActivity.IA_FromActivity) );

        m_shPr = getSharedPreferences("NaviEase", MODE_PRIVATE);
        m_shPrW = m_shPr.edit();
        AccessibilityServiceInfo info = new AccessibilityServiceInfo();
        info.notificationTimeout = 100;
        info.feedbackType = AccessibilityEvent.TYPES_ALL_MASK;
        setServiceInfo(info);

        m_powerManager = (PowerManager)getSystemService(Context.POWER_SERVICE);

        m_sensorManager = (SensorManager)getSystemService(SENSOR_SERVICE);
        m_vibrator = (Vibrator) getApplicationContext().getSystemService(Context.VIBRATOR_SERVICE);

        m_lastActionTime = SystemClock.uptimeMillis();
        setDoubleActionStart( 0, false );

        m_gyro = m_sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE);
        if( m_gyro != null )
            m_gyroMaxRange = m_gyro.getMaximumRange();
        else
            m_gyroMaxRange = 50;
        m_accel = m_sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        if( m_accel != null )
            m_accelMaxRange = m_accel.getMaximumRange();
        else
            m_accelMaxRange = 50;
        loadSettings();
    }

    private void setDoubleActionStart( int action, boolean start ){
        if( start )
        {
            m_doubleActionStart = action;
            m_startDoubleTime = SystemClock.uptimeMillis();
        }
        else
        {
            m_doubleActionStart = -1;
            m_startDoubleTime = 0;
        }
        m_doubleActionDo = false;
    }


    public void onAccuracyChanged(Sensor sensor, int accuracy){

    }

    private void doAction( int action ){

        if( m_actionDoubleEnable ){
            if( m_doubleActionStart == -1 ) {
                setDoubleActionStart( action, true );
                return;
            }else if( !m_doubleActionDo )
            {
                if( m_doubleActionStart != action &&
                    ( SystemClock.uptimeMillis() - m_startDoubleTime ) > m_actionDoubleMinDelay )
                    m_doubleActionDo = true;
                return;
            }
        }

        setDoubleActionStart( action, false );
        m_lastActionTime = SystemClock.uptimeMillis();

        if( m_actionVibrate[action] > 0 )
            m_vibrator.vibrate( m_actionVibrate[action] );

        if( isActivityActive() )
           sendServiceAction( action );
        else{
           if( action == CustomMainActivity.AS_Back )
                performGlobalAction(GLOBAL_ACTION_BACK);
            else if( action == CustomMainActivity.AS_Home )
                performGlobalAction(GLOBAL_ACTION_HOME);
            else if( action == CustomMainActivity.AS_Recents )
                performGlobalAction(GLOBAL_ACTION_RECENTS);
            else if( action == CustomMainActivity.AS_Notifications )
                performGlobalAction(GLOBAL_ACTION_NOTIFICATIONS);
            else if( action == CustomMainActivity.AS_QuickSettings )
                 performGlobalAction(GLOBAL_ACTION_QUICK_SETTINGS);
            else if( action == CustomMainActivity.AS_PowerDialog )
                 performGlobalAction(GLOBAL_ACTION_POWER_DIALOG);
            }
    }
    public void onSensorChanged(SensorEvent event){

        if( !m_powerManager.isInteractive() )
            return;

        float xValue;
        float yValue;
        float zValue;

        if( m_actionGyroMode ){
            xValue = event.values[0];
            yValue = event.values[1];
            zValue = event.values[2];
        }else{
            xValue = m_lastValues[0] - event.values[0];
            yValue = m_lastValues[1] - event.values[1];
            zValue = m_lastValues[2] - event.values[2];

            m_lastValues[0] = event.values[0];
            m_lastValues[1] = event.values[1];
            m_lastValues[2] = event.values[2];
        }

        if( ( SystemClock.uptimeMillis() - m_lastActionTime ) < m_actionDelay ){
            if( m_actionDoubleEnable )
                setDoubleActionStart( 0, false );
            return;
        }

        if( m_actionDoubleEnable && m_doubleActionStart != -1 &&
            ( SystemClock.uptimeMillis() - m_startDoubleTime ) > m_actionDoubleMaxDelay ){
            setDoubleActionStart( 0, false );
            return;
        }

        boolean notAnyAction = true;
        if( m_actionGyroMode ){

            for( int i = 0; i < CustomMainActivity.AS_Count; ++i ){
                switch( m_actionDirection[i] ){
                   case CustomMainActivity.AD_TurnToRight_SwipeToRight:{
                       if( yValue > m_actionSensitivity[i] * m_gyroMaxRange ){
                           doAction( i );
                           notAnyAction = false;
                           return;
                       }
                   break;
                   }
                   case CustomMainActivity.AD_TurnToLeft_SwipeToLeft:{
                       if( yValue < -m_actionSensitivity[i] * m_gyroMaxRange ){
                           doAction( i );
                           notAnyAction = false;
                           return;
                       }
                   break;
                   }
                   case CustomMainActivity.AD_TurnToBottom_SwipeToBottom:{
                       if( xValue > m_actionSensitivity[i] * m_gyroMaxRange ){
                           doAction( i );
                           notAnyAction = false;
                           return;
                       }
                   break;
                   }
                   case CustomMainActivity.AD_TurnToTop_SwipeToTop:{
                       if( xValue < -m_actionSensitivity[i] * m_gyroMaxRange ){
                           doAction( i );
                           notAnyAction = false;
                           return;
                       }
                   break;
                   }
                   case CustomMainActivity.AD_TwistRight_SwipeToForward:{
                       if( zValue < -m_actionSensitivity[i] * m_gyroMaxRange ){
                           doAction( i );
                           notAnyAction = false;
                           return;
                       }
                   break;
                   }
                   case CustomMainActivity.AD_TwistLeft_SwipeToBackward:{
                       if( zValue > m_actionSensitivity[i] * m_gyroMaxRange ){
                           doAction( i );
                           notAnyAction = false;
                           return;
                       }
                   break;
                 }
               };
            }
        }else{

            for( int i = 0; i < CustomMainActivity.AS_Count; ++i ){
                switch( m_actionDirection[i] ){
                   case CustomMainActivity.AD_TurnToRight_SwipeToRight:{
                       if( xValue > m_actionSensitivity[i] * m_accelMaxRange ){
                           doAction( i );
                           notAnyAction = false;
                           return;
                       }
                   break;
                   }
                   case CustomMainActivity.AD_TurnToLeft_SwipeToLeft:{
                       if( xValue < -m_actionSensitivity[i] * m_accelMaxRange ){
                           doAction( i );
                           notAnyAction = false;
                           return;
                       }
                   break;
                   }
                   case CustomMainActivity.AD_TurnToBottom_SwipeToBottom:{
                       if( yValue < -m_actionSensitivity[i] * m_accelMaxRange ){
                           doAction( i );
                           notAnyAction = false;
                           return;
                       }
                   break;
                   }
                   case CustomMainActivity.AD_TurnToTop_SwipeToTop:{
                       if( yValue > m_actionSensitivity[i] * m_accelMaxRange ){
                           doAction( i );
                           notAnyAction = false;
                           return;
                       }
                   break;
                   }
                   case CustomMainActivity.AD_TwistRight_SwipeToForward:{
                       if( zValue < -m_actionSensitivity[i] * m_accelMaxRange ){
                           doAction( i );
                           notAnyAction = false;
                           return;
                       }
                   break;
                   }
                   case CustomMainActivity.AD_TwistLeft_SwipeToBackward:{
                       if( zValue > m_actionSensitivity[i] * m_accelMaxRange ){
                           doAction( i );
                           notAnyAction = false;
                           return;
                       }
                   break;
                 }
               };
            }
        }

        if( m_actionDoubleEnable && notAnyAction && m_doubleActionStart != -1 &&
            ( SystemClock.uptimeMillis() - m_startDoubleTime ) > m_actionDoubleMinDelay )
            m_doubleActionDo = true;

    }

    @Override
    public void onInterrupt(){

    }
}
