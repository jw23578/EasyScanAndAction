import QtQuick 2.3
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.0

ESAAPage
{
    caption: "QR-Code erstellen"
    id: createqrcodepage
    signal close
    signal showCode
    onBackPressed:
    {
        console.log("create qr code")
        close()
    }
    property string qrCodeFileName: ""
    property alias theFacilityName: facilityName.displayText
    property alias theContactReceiveEMail: contactReceiveEMail.displayText
    property color textColor: "#4581B3"
    property variant yesQuestionVector: []
    function generate()
    {
        ESAA.clearYesQuestions()
        for (var i = 0; i < yesQuestionRepeater.count; ++i)
        {
            if (yesQuestionVector[i] != "")
            {
                ESAA.addYesQuestions(yesQuestionVector[i])
            }
        }

        qrCodeFileName = ESAA.generateQRCode(facilityName.displayText,
                                             contactReceiveEMail.displayText,
                                             logoUrl.displayText,
                                             colorInput.displayText,
                                             adressSwitch.position > 0.9,
                                             emailSwitch.position > 0.9,
                                             mobileSwitch.position > 0.9,
                                             anonymReceiveEMail.displayText,
                                             parseInt(visitCounts.displayText),
                                             colorInputVisitCount.displayText,
                                             tableNumber.position > 0.9,
                                             whoIsVisited.position > 0.9,
                                             station.position > 0.9,
                                             room.position > 0.9,
                                             block.position > 0.9,
                                             seatNumber.position > 0.9);
    }

    ESAAFlickable
    {
        id: theFlick
        anchors.margins: ESAA.spacing
        anchors.bottom: showCodeButton.top
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
                id: facilityName
                width: parent.width
                caption: qsTr("Name des Geschäfts")
                helpText: "Dieser Name wird dem Besucher angezeigt, wenn er den QR-Code eingescannt hat."
                onHelpClicked: ESAA.showMessage(ht)
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: logoUrl
                caption: "Logo-Url"
                width: parent.width
                inputMethodHints: Qt.ImhUrlCharactersOnly
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                width: parent.width
                caption: "Farbcode (Format: #ffffff)"
                colorEdit: true
                onDisplayTextChanged:
                {
                    colorRectangle.color = displayText
                }
                id: colorInput
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: contactReceiveEMail
                caption: "Kontaktdaten senden an (E-Mail-Adresse)"
                width: parent.width
                inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhLowercaseOnly
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: anonymReceiveEMail
                caption: "Anonym senden an (E-Mail-Adresse)"
                width: parent.width
                inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhLowercaseOnly
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: visitCounts
                caption: "Jeden xten Besuch anzeigen"
                width: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
            }
            ESAALineInputWithCaption
            {
                visible: parseInt(visitCounts.displayText) > 0
                color: createqrcodepage.textColor
                width: parent.width
                caption: "Farbcode für xten Besuch<br>(Format: #ffffff)"
                colorEdit: true
                id: colorInputVisitCount
            }
            ESAAText
            {
                width: parent.width
                id: textId
                color: createqrcodepage.textColor
                text: "Welche Daten sollen erfasst werden?"
                wrapMode: Text.WordWrap
            }

            ESAASwitch
            {
                id: adressSwitch
                width: parent.width
                text: qsTr("Adressdaten")
                fontColor: createqrcodepage.textColor
            }
            ESAASwitch
            {
                id: emailSwitch
                width: parent.width
                text: qsTr("E-Mail-Adresse")
                fontColor: createqrcodepage.textColor
            }
            ESAASwitch
            {
                id: mobileSwitch
                width: parent.width
                text: qsTr("Handynummer")
                fontColor: createqrcodepage.textColor
            }
            ESAAText
            {
                width: parent.width
                color: createqrcodepage.textColor
                text: "Die Folgenden Angaben müssen jedesmal neu ausgefüllt werden:"
                wrapMode: Text.WordWrap
            }
            ESAASwitch
            {
                id: tableNumber
                width: parent.width
                text: qsTr("Die Tischnummer")
                fontColor: createqrcodepage.textColor
            }
            ESAASwitch
            {
                id: whoIsVisited
                width: parent.width
                text: qsTr("Wer besucht wird")
                fontColor: createqrcodepage.textColor
            }
            ESAASwitch
            {
                id: station
                width: parent.width
                text: qsTr("Die Station")
                fontColor: createqrcodepage.textColor
            }
            ESAASwitch
            {
                id: room
                width: parent.width
                text: qsTr("Die Raumnummer")
                fontColor: createqrcodepage.textColor
            }
            ESAASwitch
            {
                id: block
                width: parent.width
                text: qsTr("Die Blocknummer")
                fontColor: createqrcodepage.textColor
            }
            ESAASwitch
            {
                id: seatNumber
                width: parent.width
                text: qsTr("Die Sitznummer")
                fontColor: createqrcodepage.textColor
            }
            ESAAText
            {
                width: parent.width
                color: createqrcodepage.textColor
                text: "Folgende Fragen müssen jedesmal mit \"Ja\" beantwortet werden:"
                wrapMode: Text.WordWrap
            }
            Repeater
            {
                id: yesQuestionRepeater
                model: 1
                Row
                {
                    width: parent.width
                    ESAALineInputWithCaption
                    {
                        color: createqrcodepage.textColor
                        width: parent.width - height
                        caption: (index + 1) + ". Frage"
                        id: yesQuestion
                        Component.onCompleted: text = yesQuestionVector[index]
                        onDisplayTextChanged: yesQuestionVector[index] = displayText
                    }
                    Item
                    {
                        width: ESAA.spacing / 2
                    }

                    ESAAIconButton
                    {
                        source: "qrc:/images/eraseIcon.svg"
                        width: yesQuestion.inputHeight
                        height: width
                        anchors.bottom: parent.bottom
                        Component.onCompleted:
                        {
                            if (index == yesQuestionRepeater.count - 1)
                            {
                                rotate(100)
                            }
                        }
                        onClicked:
                        {
                            if (yesQuestionRepeater.count <= 1)
                            {
                                return
                            }

                            for (var i = index; i < yesQuestionRepeater.count; ++i)
                            {
                                yesQuestionVector[i] = yesQuestionVector[i + 1]
                            }
                            yesQuestionVector[yesQuestionRepeater.count - 1] = ""
                            yesQuestionRepeater.model = yesQuestionRepeater.count - 1
                        }
                    }
                }
            }
            CircleButton
            {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "weitere<br>Frage"
                onClicked: yesQuestionRepeater.model = yesQuestionRepeater.count + 1
            }

            Item
            {
                width: parent.width
                height: 1
            }
        }
    }
    CircleButton
    {
        id: showCodeButton
        anchors.bottom: parent.bottom
        anchors.bottomMargin: ESAA.spacing
        anchors.horizontalCenter: parent.horizontalCenter
        text: "QR-Code<br>erzeugen"
        onClicked: {
            if (facilityName.displayText == "")
            {
                facilityName.forceActiveFocus()
                ESAA.showMessage("Bitte gib noch den Namen des Geschäfts an.")
                return
            }
            if (contactReceiveEMail.displayText == "")
            {
                contactReceiveEMail.forceActiveFocus()
                ESAA.showMessage("Bitte gib noch die E-Mail-Adresse, an die die verschlüsselten Kontaktdaten gesendet werden sollen, an.")
                return
            }
            if (!ESAA.isEmailValid(contactReceiveEMail.displayText))
            {
                contactReceiveEMail.forceActiveFocus()
                ESAA.showMessage("Die E-Mail-Adresse, an die die verschlüsselten Kontaktdaten gesendet werden sollen ist ungültig.<br>Bitte korrigieren.")
                return
            }
            if (anonymReceiveEMail.displayText != "" && !ESAA.isEmailValid(anonymReceiveEMail.displayText))
            {
                anonymReceiveEMail.forceActiveFocus()
                ESAA.showMessage("Die E-Mail-Adresse, an die die Besuche anonym gesendet werden sollen ist ungültig.<br>Bitte korrigieren.")
                return
            }
            generate()
            showCode()
        }
    }
    BackButton
    {
        onClicked: close()
    }
}
