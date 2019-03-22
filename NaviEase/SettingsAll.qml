import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import Qt.labs.settings 1.0
import org.tdevelopers.naviease 1.0


GroupBox{
    Keys.forwardTo: backKeyHandler
    property alias sldrAllSensitivities: sldrAllSensitivities
    property alias sldrAllVibrates: sldrAllVibrates
    property alias sldrActionDelay: sldrActionDelay
    property alias swhActionGyroMode: swhActionGyroMode
    property alias swhActionDoubleEnable: swhActionDoubleEnable
    property alias rsldrActionDoubleTime: rsldrActionDoubleTime


    background: Rectangle {
        id:rectBorder
        y: parent.topPadding - parent.padding
        width: parent.width
        height: parent.height - parent.topPadding + parent.padding
        color: "transparent"
        border.color: "#7a7a7a"
        radius: 2
    }
    label:
        Text {
             id: lblTitle
             text: parent.title
             font: parent.font
             color: "White"
         }

    Layout.fillWidth: true
    id:grpBox
    ColumnLayout{
        layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
        anchors.fill: parent

        RowLayout{
            layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
            Layout.fillWidth: true
            spacing: 6
            Label{
                id:txtAllSensitivities;
                text: qsTr("All sensitivities:");
            }
            Slider{
                Material.foreground: "#000000"
                Layout.fillWidth: true
                id:sldrAllSensitivities
                orientation: Qt.Horizontal;
                function setValue( val ){
                    paAllSensitivities.duration = 0;
                    sldrAllSensitivities.value = val;
                    paAllSensitivities.duration = 300;
                }

                Behavior on value {
                    PropertyAnimation {
                        id: paAllSensitivities;
                        duration: 300;
                        easing.type: Easing.InOutCubic;
                    }
                }

                ToolTip {
                    Material.foreground:"Lime"
                    parent: sldrAllSensitivities.handle
                    visible: sldrAllSensitivities.pressed
                    text: ( sldrAllSensitivities.position * 100 ).toFixed( 0 ) + " %"
                }
            }
        }

        RowLayout{
            layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
            Layout.fillWidth: true
            spacing: 6
            Label{
                id:txtAllVibrates;
//                Layout.preferredWidth: txtAllSensitivities.width
                text: qsTr("All vibrates:");
            }
            Slider{
                Material.foreground: "#000000"
                Layout.fillWidth: true
                id:sldrAllVibrates
                orientation: Qt.Horizontal;
                function setValue( val ){
                    paAllVibrates.duration = 0;
                    sldrAllVibrates.value = val;
                    paAllVibrates.duration = 300;
                }
                Behavior on value {
                    PropertyAnimation {
                        id: paAllVibrates;
                        duration: 300;
                        easing.type: Easing.InOutCubic;
                    }
                }
                ToolTip {
                    Material.foreground:"Lime"
                    parent: sldrAllVibrates.handle
                    visible: sldrAllVibrates.pressed
                    text: ( sldrAllVibrates.position * 0.5 ).toFixed( 2 ) + " " + qsTr("Sec")
                }
            }
        }

        RowLayout{
            layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
            Layout.fillWidth: true
            spacing: 6
            Label{
                id:txtDelay;
//                Layout.preferredWidth: txtAllSensitivities.width
                text: qsTr("Delay to next action:");
            }
            Slider{
                Material.foreground: "#000000"
                Layout.fillWidth: true
                id:sldrActionDelay
                orientation: Qt.Horizontal;
                Behavior on value { PropertyAnimation { duration: 300; easing.type: Easing.InOutCubic} }

                ToolTip {
                    Material.foreground:"Lime"
                    parent: sldrActionDelay.handle
                    visible: sldrActionDelay.pressed
                    text: ( sldrActionDelay.position * 3 ).toFixed( 1 ) + " " + qsTr("Sec")
                }
            }
        }
        RowLayout{
            layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
            Layout.fillWidth: true
            spacing: 6
            Label{
                text: qsTr("Use gyroscope:");
                Layout.preferredWidth: txtDoubleEnable.width
                //Layout.fillWidth: true
            }
            Switch{
                Layout.fillWidth: true
                id:swhActionGyroMode
            }
        }

        RowLayout{
            layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
            Layout.fillWidth: true
            spacing: 6
            Label{
                id: txtDoubleEnable
                text: qsTr("Double move:");
                //Layout.fillWidth: true
            }
            Switch{
                Layout.fillWidth: true
                id:swhActionDoubleEnable
            }
        }
        RowLayout{
            layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
            Layout.fillWidth: true
            spacing: 6
            Label{
                id:txtDoubleTime;
//                Layout.preferredWidth: txtAllSensitivities.width
                text: qsTr("Double move timing:");
            }
            RangeSlider{
                Material.foreground: "#000000"
                Layout.fillWidth: true
                id:rsldrActionDoubleTime
                orientation: Qt.Horizontal;
                Behavior on first.value { PropertyAnimation { duration: 300; easing.type: Easing.InOutCubic} }
                Behavior on second.value { PropertyAnimation { duration: 300; easing.type: Easing.InOutCubic} }
                ToolTip {
                    Material.foreground:"Lime"
                    parent: rsldrActionDoubleTime.first.handle
                    visible: rsldrActionDoubleTime.first.pressed
                    text: ( rsldrActionDoubleTime.first.position * 0.5 ).toFixed( 2 ) + " " + qsTr("Sec")
                }
                ToolTip {
                    Material.foreground:"Lime"
                    parent: rsldrActionDoubleTime.second.handle
                    visible: rsldrActionDoubleTime.second.pressed
                    text: ( rsldrActionDoubleTime.second.position * 0.5 ).toFixed( 2 ) + " " + qsTr("Sec")
                }
            }
        }


    }
}
