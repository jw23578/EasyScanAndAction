import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../Comp"
import "../BasePages"

PageWithBackButton
{
    caption: "Hilfe anbieten"
    ESAAFlickable
    {
        id: theFlick
        anchors.margins: ESAA.spacing
        anchors.bottom: addHelp.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        contentHeight: theColumn.height * 1.3
        Column
        {
            parent: theFlick.contentItem
            y: ESAA.spacing
            spacing: ESAA.spacing
            id: theColumn
            width: parent.width - 2 * ESAA.spacing
            anchors.horizontalCenter: parent.horizontalCenter
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: helpOfferShort
                width: parent.width
                caption: qsTr("Wie möchtest du helfen? (Einkaufshilfe, Haustierausführen, Medikamente abholen, ...)")
                helpText: ""
                onHelpClicked: ESAA.showMessage(ht)
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: helpLocation
                width: parent.width
                caption: qsTr("Wo möchtest du helfen? (Stadt, Landkreis, ...)")
            }
            ESAAText
            {
                text: "Deine Kontaktdaten"
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: name
                width: parent.width
                caption: qsTr("Vorname")
                text: ESAA.fstname
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: surname
                width: parent.width
                caption: qsTr("Nachname")
                text: ESAA.surname
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: phonenumber
                width: parent.width
                caption: qsTr("Telefonnummer")
                text: JW78APP.mobile
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: email
                width: parent.width
                caption: qsTr("E-Mail-Adresse")
                text: JW78APP.emailAdress
            }
            ESAAText
            {
                width: parent.width
                wrapMode: Text.WordWrap
                text: "Beschreibe hier genauer, wie du anderen eine Freude machen möchtest"
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: helpOfferLong
                width: parent.width
                caption: qsTr("Beschreibung deiner Hilfe")
            }
        }
    }
    CentralActionButton
    {
        id: addHelp
        text: "Angebot<br>eintragen"
    }
}