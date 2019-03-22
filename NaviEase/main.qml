import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import Qt.labs.settings 1.0
import org.tdevelopers.naviease 1.0

ApplicationWindow {
    id: window
    width: 360
    height: 520
    visible: true
    title: qsTr("NaviEase")
    Material.foreground: "#FFFFFF"
    Component.onCompleted: {
        actionAll.swhActionGyroMode.enabled = vSettings.isGyroSupported();
        vSettings.requestSettings();
    }
    CSettings{
        id:vSettings;
        property bool isFirstSet : true;
        function resetToDefault( changeGyroMode )
        {
            if( changeGyroMode )
                actionAll.swhActionGyroMode.checked = vSettings.isGyroSupported();

            var defaultSensitivity;
            if( actionAll.swhActionGyroMode.checked )
                defaultSensitivity = ( 1.0 - 0.3 );
            else
                defaultSensitivity = ( 1.0 - 0.9 );
            var defaultVibrate = ( 80 / 500 );

            actionAll.sldrAllSensitivities.setValue( 0 );
            actionAll.sldrAllVibrates.setValue( 0 );

            backAction.cbActionDirection.gyroMode = actionAll.swhActionGyroMode.checked;
            backAction.cbActionDirection.currentIndex = 1;
            backAction.sldrActionSensitivity.value = defaultSensitivity;
            backAction.sldrActionVibrate.value = defaultVibrate;

            homeAction.cbActionDirection.gyroMode = actionAll.swhActionGyroMode.checked;
            homeAction.cbActionDirection.currentIndex = 2;
            homeAction.sldrActionSensitivity.value = ( actionAll.swhActionGyroMode.checked ? defaultSensitivity : 0.5 );
            homeAction.sldrActionVibrate.value = defaultVibrate;

            recentsAction.cbActionDirection.gyroMode = actionAll.swhActionGyroMode.checked;
            recentsAction.cbActionDirection.currentIndex = 3;
            recentsAction.sldrActionSensitivity.value = defaultSensitivity;
            recentsAction.sldrActionVibrate.value = defaultVibrate;

            notificationsAction.cbActionDirection.gyroMode = actionAll.swhActionGyroMode.checked;
            notificationsAction.cbActionDirection.currentIndex = ( actionAll.swhActionGyroMode.checked ? 4 : 5 );
            notificationsAction.sldrActionSensitivity.value = defaultSensitivity;
            notificationsAction.sldrActionVibrate.value = defaultVibrate;

            quickSettingsAction.cbActionDirection.gyroMode = actionAll.swhActionGyroMode.checked;
            quickSettingsAction.cbActionDirection.currentIndex = ( actionAll.swhActionGyroMode.checked ? 5 : 0 );
            quickSettingsAction.sldrActionSensitivity.value = defaultSensitivity;
            quickSettingsAction.sldrActionVibrate.value = defaultVibrate;

            powerDialogAction.cbActionDirection.gyroMode = actionAll.swhActionGyroMode.checked;
            powerDialogAction.cbActionDirection.currentIndex = ( actionAll.swhActionGyroMode.checked ? 6 : 0 );
            powerDialogAction.sldrActionSensitivity.value = defaultSensitivity;
            powerDialogAction.sldrActionVibrate.value = defaultVibrate;

            actionAll.sldrActionDelay.value = ( 800 / 3000 );
            actionAll.swhActionDoubleEnable.checked = false;
            actionAll.rsldrActionDoubleTime.first.value = ( 100 / 500 );
            actionAll.rsldrActionDoubleTime.second.value = ( 350 / 500 );
        }

        onValuesChangedSignal: {

            actionAll.sldrAllSensitivities.setValue( 0 );
            actionAll.sldrAllVibrates.setValue( 0 );

            isFirstSet = false;

            backAction.cbActionDirection.gyroMode = getActionGyroMode();
            backAction.cbActionDirection.currentIndex = getActionDirection( CSettings.AS_Back );
            backAction.sldrActionSensitivity.value = ( 1.0 - getActionSensitivity( CSettings.AS_Back ) );
            backAction.sldrActionVibrate.value = ( getActionVibrate( CSettings.AS_Back ) / 500);

            homeAction.cbActionDirection.gyroMode = getActionGyroMode();
            homeAction.cbActionDirection.currentIndex = getActionDirection( CSettings.AS_Home );
            homeAction.sldrActionSensitivity.value = ( 1.0 - getActionSensitivity( CSettings.AS_Home ) );
            homeAction.sldrActionVibrate.value = ( getActionVibrate( CSettings.AS_Home ) / 500 );

            recentsAction.cbActionDirection.gyroMode = getActionGyroMode();
            recentsAction.cbActionDirection.currentIndex = getActionDirection( CSettings.AS_Recents );
            recentsAction.sldrActionSensitivity.value = ( 1.0 - getActionSensitivity( CSettings.AS_Recents ) );
            recentsAction.sldrActionVibrate.value = ( getActionVibrate( CSettings.AS_Recents ) / 500 );

            notificationsAction.cbActionDirection.gyroMode = getActionGyroMode();
            notificationsAction.cbActionDirection.currentIndex = getActionDirection( CSettings.AS_Notifications );
            notificationsAction.sldrActionSensitivity.value = ( 1.0 - getActionSensitivity( CSettings.AS_Notifications ) );
            notificationsAction.sldrActionVibrate.value = ( getActionVibrate( CSettings.AS_Notifications ) / 500 );

            quickSettingsAction.cbActionDirection.gyroMode = getActionGyroMode();
            quickSettingsAction.cbActionDirection.currentIndex = getActionDirection( CSettings.AS_QuickSettings );
            quickSettingsAction.sldrActionSensitivity.value = ( 1.0 - getActionSensitivity( CSettings.AS_QuickSettings ) );
            quickSettingsAction.sldrActionVibrate.value = ( getActionVibrate( CSettings.AS_QuickSettings ) / 500 );

            powerDialogAction.cbActionDirection.gyroMode = getActionGyroMode();
            powerDialogAction.cbActionDirection.currentIndex = getActionDirection( CSettings.AS_PowerDialog );
            powerDialogAction.sldrActionSensitivity.value = ( 1.0 - getActionSensitivity( CSettings.AS_PowerDialog ) );
            powerDialogAction.sldrActionVibrate.value = ( getActionVibrate( CSettings.AS_PowerDialog ) / 500 );

            actionAll.sldrActionDelay.value = ( getActionDelay() / 3000 );
            actionAll.swhActionGyroMode.checked = getActionGyroMode();
            actionAll.swhActionDoubleEnable.checked = getActionDoubleEnable();
            actionAll.rsldrActionDoubleTime.first.value = ( getActionDoubleMinDelay() / 500 );
            actionAll.rsldrActionDoubleTime.second.value = ( getActionDoubleMaxDelay() / 500 );
        }

        onActionDoneBackSignal: {
            backAction.anmActionDo.restart();
            actionPopup.show( CSettings.AS_Back );
        }
        onActionDoneHomeSignal: {
            homeAction.anmActionDo.restart();
            actionPopup.show( CSettings.AS_Home );
        }
        onActionDoneRecentsSignal: {
            recentsAction.anmActionDo.restart();
            actionPopup.show( CSettings.AS_Recents );
        }
        onActionDoneNotificationsSignal: {
            notificationsAction.anmActionDo.restart();
            actionPopup.show( CSettings.AS_Notifications );
        }
        onActionDoneQuickSettingsSignal: {
            quickSettingsAction.anmActionDo.restart();
            actionPopup.show( CSettings.AS_QuickSettings );
        }
        onActionDonePowerDialogSignal: {
            powerDialogAction.anmActionDo.restart();
            actionPopup.show( CSettings.AS_PowerDialog );
        }
    }


    footer: ToolBar{
        visible: false
        ToolTip {
            Material.elevation:0
            Material.foreground:"#FFFFFF"
            width: parent.width
            height: parent.height
            parent: parent
            id:baseToolTipSave
            visible: false
        }
        ToolTip {
            Material.elevation:0
            Material.foreground:"#FFFFFF"
            width: parent.width
            height: parent.height
            parent: parent
            id:baseToolTipExit
            visible: false
        }
    }

    Item{
        id:backKeyHandler;
        anchors.fill: parent
        focus: true
        Timer {
            id:exitTimer
            interval: 2000;
            running: false;
            repeat: false
        }
        Keys.onPressed: {
            if (event.key === Qt.Key_Escape || event.key === Qt.Key_Back) {
                if( exitTimer.running )
                {
                    vSettings.loadSettings();
                    Qt.quit();
                }else
                {
                    exitTimer.start();
                    baseToolTipExit.visible = false;
                    baseToolTipExit.text = qsTr("Press again to exit.");
                    baseToolTipExit.timeout = 2000;
                    baseToolTipExit.visible = true;
                    event.accepted = true;
                }
            }
        }
    }


    Popup {
        id: resetPopup
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 3 * 2
        height: resetColumn.implicitHeight + topPadding + bottomPadding
        modal: true
        focus: true

        contentItem: ColumnLayout {
            layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
            id:resetColumn
            spacing: 20
            Label {
                text: qsTr("Reset")
                font.bold: true
            }

            RowLayout {
                layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
                spacing: 10

                Label {
                    text: qsTr("Reset all settings to default!\n\nAre you sure?");
                }
            }

            RowLayout {
                layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
                spacing: 10

                Button {
                    text: qsTr("Yes")
                    onClicked: {
                        resetPopup.close();
                        vSettings.resetToDefault( true );
                    }

                    Material.background: "transparent"
                    Material.elevation: 0

                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
                }

                Button {
                    text: qsTr("No")
                    onClicked: {
                        resetPopup.close()
                    }

                    Material.foreground: "#FFFFFF"
                    Material.background: "transparent"
                    Material.elevation: 0

                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
                }
            }
        }
    }

    Popup {
        id: actionPopup
        width: Math.min( window.width, window.height ) / 2;
        height: width
        x: (window.width - width) / 2
        y: (window.height - height) / 2
        modal: false
        focus: false
        dim: false
        Frame{
            background: Rectangle {
                  color: "transparent"
                  border.color: "Lime"
                  radius: 2
              }
            anchors.fill: parent
            Image {
                id: imgActionPopup
            }
        }
        Timer{
            id:visibleTimer
            interval: 1000
            repeat: false
            onTriggered: {
                actionPopup.visible = false;
            }
        }
        function show( actionState ){
            switch( actionState )
            {
            case CSettings.AS_Back:
                imgActionPopup.source = "qrc:/icons/back.png";
                break;
            case CSettings.AS_Home:
                imgActionPopup.source = "qrc:/icons/home.png";
                break;
            case CSettings.AS_Recents:
                imgActionPopup.source = "qrc:/icons/recents.png";
                break;
            case CSettings.AS_Notifications:
                imgActionPopup.source = "qrc:/icons/notifications.png";
                break;
            case CSettings.AS_QuickSettings:
                imgActionPopup.source = "qrc:/icons/settings.png";
                break;
            case CSettings.AS_PowerDialog:
                imgActionPopup.source = "qrc:/icons/power.png";
                break;
            }

            visible = true;
            visibleTimer.restart();
        }
    }
    Popup {
        id: aboutPopup
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 3 * 2
        height: aboutColumn.implicitHeight + topPadding + bottomPadding
        modal: true
        focus: true

        contentItem: ColumnLayout {
            layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
            id:aboutColumn
            spacing: 20
            Label {
                text: qsTr("About")
                font.bold: true
            }

            RowLayout {
                layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
                spacing: 10

                Label {
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                    text: qsTr("All right reserve to\n\nTDevelopers group.");
                }
            }

            RowLayout {
                layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
                spacing: 10

                Button {
                    text: qsTr("OK")
                    onClicked: {
                        aboutPopup.close()
                    }

                    Material.foreground: "#FFFFFF"
                    Material.background: "transparent"
                    Material.elevation: 0

                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
                }
            }
        }
    }


    header: ToolBar {
        Keys.forwardTo: backKeyHandler
        RowLayout {
            layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
            spacing: 20
            anchors.fill: parent

            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/icons/save.png"
                }
                onClicked:
                {
                    vSettings.saveSettings();

                    baseToolTipSave.visible = false;
                    baseToolTipSave.text = qsTr("Settings has been saved.");
                    baseToolTipSave.timeout = 2000;
                    baseToolTipSave.visible = true;
                }
            }

//            ToolButton {
//                property bool english: true;
//                contentItem: Image {
//                    id:imgLan
//                    fillMode: Image.Pad
//                    horizontalAlignment: Image.AlignHCenter
//                    verticalAlignment: Image.AlignVCenter
//                    source: "qrc:/icons/fa.png"
//                }
//                onClicked:
//                {
//                    english = !english;
//                    if( english )
//                        imgLan.source= "qrc:/icons/fa.png";
//                    else
//                        imgLan.source= "qrc:/icons/en.png";
//                    vSettings.setLanguege( english );
//                }
//            }

            Label {
                id: titleLabel
                text: qsTr("NaviEase")
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/icons/reset.png"
                }
                onClicked:
                {
                    resetPopup.visible = true;
                }
            }
            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/icons/about.png"
                }
                onClicked:
                {
                    aboutPopup.visible = true;
                }
            }
        }
    }

    Flickable {
        anchors.margins:  10
        anchors.fill: parent
        contentWidth: width;
        contentHeight: 2000
        ScrollIndicator.vertical:  ScrollIndicator{
            rightPadding: -5
            position: 1
            active: true
        }

            ColumnLayout{
                layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );

            anchors.fill: parent

            SettingsAll{
                id:actionAll
                title: qsTr("General settings")

                sldrAllSensitivities.onValueChanged: {
//                    if( vSettings.isFirstSet )
//                        return;
                    backAction.sldrActionSensitivity.value = sldrAllSensitivities.value;
                    homeAction.sldrActionSensitivity.value = sldrAllSensitivities.value;
                    recentsAction.sldrActionSensitivity.value = sldrAllSensitivities.value;
                    notificationsAction.sldrActionSensitivity.value = sldrAllSensitivities.value;
                    quickSettingsAction.sldrActionSensitivity.value = sldrAllSensitivities.value;
                    powerDialogAction.sldrActionSensitivity.value = sldrAllSensitivities.value;
                }

                sldrAllVibrates.onValueChanged: {
//                    if( vSettings.isFirstSet )
//                        return;
                    backAction.sldrActionVibrate.value = sldrAllVibrates.value;
                    homeAction.sldrActionVibrate.value = sldrAllVibrates.value;
                    recentsAction.sldrActionVibrate.value = sldrAllVibrates.value;
                    notificationsAction.sldrActionVibrate.value = sldrAllVibrates.value;
                    quickSettingsAction.sldrActionVibrate.value = sldrAllVibrates.value;
                    powerDialogAction.sldrActionVibrate.value = sldrAllVibrates.value;
                }

                sldrActionDelay.onValueChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionDelay( sldrActionDelay.value * 3000 );
                }
                swhActionGyroMode.onCheckedChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.resetToDefault( false );
                    vSettings.setActionGyroMode( swhActionGyroMode.checked );
                }
                swhActionDoubleEnable.onCheckedChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionDoubleEnable( swhActionDoubleEnable.checked );
                }
                rsldrActionDoubleTime.first.onValueChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionDoubleMinDelay( rsldrActionDoubleTime.first.value * 500 );
                }
                rsldrActionDoubleTime.second.onValueChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionDoubleMaxDelay( rsldrActionDoubleTime.second.value * 500 );
                }
            }

            SettingsBase{
                id:backAction
                title: qsTr("Back key simulation")
                imgTitle.source: "qrc:/icons/back.png"
                cbActionDirection.onCurrentIndexChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionDirection( CSettings.AS_Back, cbActionDirection.currentIndex );
                }
                sldrActionSensitivity.onValueChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionSensitivity( CSettings.AS_Back, 1.0 - sldrActionSensitivity.value );
                }
                sldrActionVibrate.onValueChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionVibrate( CSettings.AS_Back, sldrActionVibrate.value * 500 );
                }
            }

            SettingsBase{
                id:homeAction
                title: qsTr("Home key simulation")
                imgTitle.source: "qrc:/icons/home.png"
                cbActionDirection.onCurrentIndexChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionDirection( CSettings.AS_Home, cbActionDirection.currentIndex );
                }
                sldrActionSensitivity.onValueChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionSensitivity( CSettings.AS_Home, 1.0 - sldrActionSensitivity.value );
                }
                sldrActionVibrate.onValueChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionVibrate( CSettings.AS_Home, sldrActionVibrate.value * 500 );
                }
            }

            SettingsBase{
                id:recentsAction
                title: qsTr("Recents key simulation")
                imgTitle.source: "qrc:/icons/recents.png"
                cbActionDirection.onCurrentIndexChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionDirection( CSettings.AS_Recents, cbActionDirection.currentIndex );
                }
                sldrActionSensitivity.onValueChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionSensitivity( CSettings.AS_Recents, 1.0 - sldrActionSensitivity.value );
                }
                sldrActionVibrate.onValueChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionVibrate( CSettings.AS_Recents, sldrActionVibrate.value * 500 );
                }
            }

            SettingsBase{
                id:notificationsAction
                title: qsTr("Open notifications")
                imgTitle.source: "qrc:/icons/notifications.png"
                cbActionDirection.onCurrentIndexChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionDirection( CSettings.AS_Notifications, cbActionDirection.currentIndex );
                }
                sldrActionSensitivity.onValueChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionSensitivity( CSettings.AS_Notifications, 1.0 - sldrActionSensitivity.value );
                }
                sldrActionVibrate.onValueChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionVibrate( CSettings.AS_Notifications, sldrActionVibrate.value * 500 );
                }
            }

            SettingsBase{
                id:quickSettingsAction
                title: qsTr("Open quick settings")
                imgTitle.source: "qrc:/icons/settings.png"
                cbActionDirection.onCurrentIndexChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionDirection( CSettings.AS_QuickSettings, cbActionDirection.currentIndex );
                }
                sldrActionSensitivity.onValueChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionSensitivity( CSettings.AS_QuickSettings, 1.0 - sldrActionSensitivity.value );
                }
                sldrActionVibrate.onValueChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionVibrate( CSettings.AS_QuickSettings, sldrActionVibrate.value * 500 );
                }
            }

            SettingsBase{
                id:powerDialogAction
                title: qsTr("Hold power key simulation")
                imgTitle.source: "qrc:/icons/power.png"
                cbActionDirection.onCurrentIndexChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionDirection( CSettings.AS_PowerDialog, cbActionDirection.currentIndex );
                }
                sldrActionSensitivity.onValueChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionSensitivity( CSettings.AS_PowerDialog, 1.0 - sldrActionSensitivity.value );
                }
                sldrActionVibrate.onValueChanged: {
                    if( vSettings.isFirstSet )
                        return;
                    vSettings.setActionVibrate( CSettings.AS_PowerDialog, sldrActionVibrate.value * 500 );
                }
            }
        }
    }
}
