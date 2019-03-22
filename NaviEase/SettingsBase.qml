import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import Qt.labs.settings 1.0
import org.tdevelopers.naviease 1.0


GroupBox{
    Keys.forwardTo: backKeyHandler
    property alias cbActionDirection: cbActionDirection
    property alias sldrActionSensitivity: sldrActionSensitivity
    property alias sldrActionVibrate: sldrActionVibrate
    property alias imgTitle: imgTitle
    property alias anmActionDo: anmActionDo

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
             Image {
                 asynchronous : true
                 opacity: 0.5
                 id: imgTitle
                 x: grpBox.width - width
             }
         }
    PropertyAnimation{
        id:anmActionDo
        target: rectBorder
        property: "border.color"
        easing.type: Easing.InQuart
        duration: 1000
        from: "Lime"
        to: "#7a7a7a"
        onStarted: {
            anmActionDoText.restart();
            anmActionDoImgTittle.restart();
        }
    }
    PropertyAnimation{
        id:anmActionDoText
        target: lblTitle
        property: "color"
        easing.type: Easing.InQuart
        duration: 1000
        from: "Lime"
        to: "#FFFFFF"
    }

    PropertyAnimation{
        id:anmActionDoImgTittle
        target: imgTitle
        property: "opacity"
        easing.type: Easing.InQuart
        duration: 1000
        from: 1.0
        to: 0.5
    }

    Layout.fillWidth: true
    id:grpBox
    ColumnLayout{
        layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
        anchors.fill: parent
        RowLayout{
            layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
            spacing: 6
            Layout.fillWidth: true
//            Label{
//                id:lblTriggerBy
//                //Layout.preferredWidth: txtVibrate.width
//                text: qsTr("Trigger by:");
//            }
            ComboBox {
                Layout.fillWidth: true
                Layout.preferredHeight: cbActionDirectionCurrentImg.height
                id: cbActionDirection
                property bool gyroMode: true
                function updateItems()
                {
                    if( gyroMode ){
                        cbActionDirectionListModel.set( 1, { "caption": qsTr("Turn to left"),
                                                              "img" : "qrc:/icons/turn_to_left.png" } );
                        cbActionDirectionListModel.set( 2, { "caption": qsTr("Turn to top"),
                                                              "img" : "qrc:/icons/turn_to_top.png" } );
                        cbActionDirectionListModel.set( 3, { "caption": qsTr("Turn to right"),
                                                              "img" : "qrc:/icons/turn_to_right.png" } );
                        cbActionDirectionListModel.set( 4, { "caption": qsTr("Turn to bottom"),
                                                              "img" : "qrc:/icons/turn_to_bottom.png" } );
                        cbActionDirectionListModel.set( 5, { "caption": qsTr("Twist to right"),
                                                              "img" : "qrc:/icons/twist_to_right.png" } );
                        cbActionDirectionListModel.set( 6, { "caption": qsTr("Twist to left"),
                                                              "img" : "qrc:/icons/twist_to_left.png" } );
                    }else
                    {
                        cbActionDirectionListModel.set( 1, { "caption": qsTr("Swipe to left"),
                                                              "img" : "qrc:/icons/swipe_to_left.png" } );
                        cbActionDirectionListModel.set( 2, { "caption": qsTr("Swipe to top"),
                                                              "img" : "qrc:/icons/swipe_to_top.png" } );
                        cbActionDirectionListModel.set( 3, { "caption": qsTr("Swipe to right"),
                                                              "img" : "qrc:/icons/swipe_to_right.png" } );
                        cbActionDirectionListModel.set( 4, { "caption": qsTr("Swipe to bottom"),
                                                              "img" : "qrc:/icons/swipe_to_bottom.png" } );
                        cbActionDirectionListModel.set( 5, { "caption": qsTr("Swipe to forward"),
                                                              "img" : "qrc:/icons/swipe_to_forward.png" } );
                        cbActionDirectionListModel.set( 6, { "caption": qsTr("Swipe to backward"),
                                                              "img" : "qrc:/icons/swipe_to_backward.png" } );
                    }
                    var indx = currentIndex;
                    currentIndex = 0;
                    currentIndex = indx;
                }

                onGyroModeChanged: {
                    updateItems();
                }
                Component.onCompleted: {
                    updateItems();
                }

                model: ListModel {
                    id:cbActionDirectionListModel
                    ListElement { caption: qsTr("Disable"); img: "qrc:/icons/none.png" }
                }

                Image
                {
                    asynchronous : true
                    Layout.fillWidth: true
                    anchors.verticalCenter: cbActionDirection.verticalCenter
                    id:cbActionDirectionCurrentImg
                    source: cbActionDirectionListModel.get(cbActionDirection.currentIndex).img
                }
                Text {
                    Layout.fillWidth: true
                    color: "#FFFFFF"
                    id:cbActionDirectionCurrentText
                    anchors.left: cbActionDirectionCurrentImg.right
                    anchors.verticalCenter: cbActionDirectionCurrentImg.verticalCenter
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    text:cbActionDirectionListModel.get(cbActionDirection.currentIndex).caption
                    font.pixelSize: 15
                }

                delegate: ItemDelegate {
                    font.weight: cbActionDirection.currentIndex === index ? Font.DemiBold : Font.Normal
                    highlighted: cbActionDirection.highlightedIndex === index
                    text: caption
                    width: cbActionDirection.width
                    height: icon.implicitHeight
                    leftPadding: icon.implicitWidth + 10
                    font.pixelSize: 15
                    onClicked: cbActionDirection.currentIndex = index

                    Image {
                        asynchronous : true
                        id: icon
                        source: img
                    }
                }
            }
        }

        RowLayout{
            layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
            Layout.fillWidth: true
            spacing: 6
            Label{
                text: qsTr("Sensitivity:");
//                Layout.preferredWidth: txtVibrate.width
            }
            Slider{
                Material.foreground: "#000000"
                Layout.fillWidth: true
                id:sldrActionSensitivity
                orientation: Qt.Horizontal;
                Behavior on value { PropertyAnimation { duration: 300; easing.type: Easing.InOutCubic} }
                ToolTip {
                    Material.foreground:"Lime"
                    parent: sldrActionSensitivity.handle
                    visible: sldrActionSensitivity.pressed
                    text: ( sldrActionSensitivity.position * 100 ).toFixed( 0 ) + " %"
                }
            }
        }
        RowLayout{
            layoutDirection: ( qsTr( "ltr" ) === "ltr" ? "LeftToRight" : "RightToLeft" );
            Layout.fillWidth: true
            spacing: 6
            Label{
                id:txtVibrate;
                text: qsTr("Vibrate:");
            }
            Slider{
                Material.foreground: "#000000"
                Layout.fillWidth: true
                id:sldrActionVibrate
                orientation: Qt.Horizontal;
                Behavior on value { PropertyAnimation { duration: 300; easing.type: Easing.InOutCubic} }
                ToolTip {
                    Material.foreground:"Lime"
                    parent: sldrActionVibrate.handle
                    visible: sldrActionVibrate.pressed
                    text: ( sldrActionVibrate.position * 0.5 ).toFixed( 2 ) + " " + qsTr("Sec")
                }
            }
        }
    }
}
