import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../BasePages"
import "../Comp"

PageWithBackButton
{
    id: manualvisitpage
    caption: "Kontaktsituation eintragen"
    function saveVisit(name, adress)
    {
        manualvisitpage.name = name
        manualvisitpage.adress = adress
        ESAA.askYesNoQuestion("Soll ein Besuch bei <br><br><b>" + name + "</b><br><br> eingetragen werden?", visitAccepted, visitNotAccepted)
    }

    CircleButton
    {
        anchors.right: parent.right
        anchors.top: parent.top
        text: "oldenburg<br>simulieren"
        visible: ESAA.isDevelop
        onClicked: PlacesManager.simulate()
        z: 2
    }

    onShowing:
    {
        manualName.text = ""
        MobileExtensions.requestLocationPermission(permissionDenied, permissionGranted)
        if (!MobileExtensions.locationServicesDeniedByUser)
        {
            PlacesManager.update()
        }
    }
    function permissionDenied()
    {

    }
    function permissionGranted()
    {

    }
    property string name: ""
    property string adress: ""
    function visitAccepted()
    {
        ESAA.saveKontaktsituation(name, adress)
        ESAA.showMessage("Die Kontaktsituation wurde gespeichert.")
        backPressed()
    }
    function visitNotAccepted()
    {
        console.log("nein")
    }

    ListView
    {
        id: view
        anchors.top: parent.top
        anchors.margins: ESAA.spacing
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: manuell.top
        spacing: 1
        model: Places
        clip: true
        delegate: Item {
            width: view.width
            height: view.height / 8
            ESAAText
            {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: ESAA.spacing
                text: place.name
                font.pixelSize: ESAA.fontTextPixelsize * 1.1
            }
            ESAAText
            {
                anchors.left: parent.left
                anchors.leftMargin: ESAA.spacing
                anchors.bottom: parent.bottom
                anchors.bottomMargin: ESAA.spacing / 4
                font.pixelSize: ESAA.fontTextPixelsize * 0.9
                text: place.adress
            }

            Rectangle
            {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: "black"
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked: saveVisit(place.name, place.adress)
            }
        }
    }
    Column
    {
        id: manuell
        width: parent.width
        anchors.bottom: saveButton.top
        anchors.bottomMargin: ESAA.spacing
        ESAALineInputWithCaption
        {
            width: parent.width - 2 * ESAA.spacing
            caption: qsTr("Manuelle Eingabe")
            anchors.horizontalCenter: parent.horizontalCenter
            id: manualName
        }
    }

    Rectangle
    {
        anchors.fill: view
        color: "red"
        opacity: 0.5
        ESAAText
        {
            anchors.centerIn: parent
            text: "Umgebungsdaten werden abgerufen"
        }
        visible: PlacesManager.waitingForPlaces && !locationNotAvailable.visible
    }
    Rectangle
    {
        id: locationNotAvailable
        anchors.fill: view
        color: "orange"
        opacity: 1
        ESAAText
        {
            anchors.centerIn: parent
            width: parent.width * 8 / 10
            wrapMode: Text.WordWrap
            text: "Die Standortdaten können nicht abgerufen werden, bitte aktivieren sie die Lokalisierung in den " + MobileExtensions.systemName + " Einstellungen."
        }
        visible: MobileExtensions.locationServicesDeniedByUser
        onVisibleChanged: {
            if (!visible && manualvisitpage.visible)
            {
                if (!MobileExtensions.locationServicesDeniedByUser)
                {
                    PlacesManager.update()
                }
            }
        }
    }
    CentralActionButton
    {
        id: saveButton
        text: "Speichern"
        onClicked:
        {
            if (manualName.displayText == "")
            {
                ESAA.showMessage("Bitte geben Sie noch eine Bezeichnung für den manuelle Speicherung ein.");
                return
            }
            saveVisit(manualName.displayText, "")
        }
    }
}
