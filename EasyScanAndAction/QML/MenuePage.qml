import QtQuick 2.13
import QtQuick.Controls 2.13

ESAAPage
{
    signal editContactData
    signal close
    signal editQRCode
    signal help
    caption: "Menü"
    Rectangle
    {
        id: removeMeLater
        anchors.fill: parent
        color: "white"
    }

    onShowing:
    {
        shareButton.blink(400)
        shareButton.rotate(400)
        spendenButton.blink(500)
    }

    Grid
    {
        id: theGrid
        property int buttonSize: ESAA.screenWidth / 3
        property int buttonFontPixelSize: ESAA.fontButtonPixelsize
        columns: 2
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: buttonSize * 2.5
        topPadding: spacing / 4
        spacing: width - 2 * buttonSize
        rowSpacing: spacing / 2
        CircleButton
        {
            id: qrcodebutton
            text: "QR-Code\nanlegen"
            onClicked: editQRCode()
            width: parent.buttonSize
            font.pixelSize: theGrid.buttonFontPixelSize
        }
        CircleButton
        {
            id: editButton
            font.pixelSize: theGrid.buttonFontPixelSize
            text: qsTr("Meine<br>Kontaktdaten<br>bearbeiten")
            onClicked: editContactData()
            width: parent.buttonSize
        }
        CircleButton
        {
            id: helpButton
            font.pixelSize: theGrid.buttonFontPixelSize * 1.3
            text: qsTr("Hilfe")
            onClicked: help()
            width: parent.buttonSize
        }
        CircleButton
        {
            id: spendenButton
            text: qsTr("Spenden")
            font.pixelSize: theGrid.buttonFontPixelSize * 1.3
            onClicked: Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=M29Q4NYS8DXYJ&source=url")
            width: parent.buttonSize
        }
    }
    CircleButton
    {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: theGrid.bottom
        id: shareButton
        belowCaption: qsTr("Weiterempfehlen")
        onClicked: ESAA.recommend()
        width: theGrid.buttonSize
        source: "qrc:/images/share_weiss.svg"
        downSource: "qrc:/images/share_blau.svg"
    }


    BackButton
    {
        onClicked: close()
    }
    onBackPressed:
    {
        console.log("menuepage back")
        close()
    }
}
