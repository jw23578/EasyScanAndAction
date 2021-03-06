import QtQuick 2.15
import "Comp"
import "qrc:/foundation"

Rectangle
{
    property int headerHeight: parent.height / 16
    signal splashDone
    signal helpClicked
    signal profileIconClicked
    id: splashscreen
    opacity: 1
    anchors.top: parent.top
    anchors.left: parent.left
    width: parent.width
    height: parent.height
    property bool minimized: false
    property alias headerText: headerCaption.text
    property color gradientFromColor: ESAA.buttonFromColor
    property color gradientToColor: minimized ? ESAA.buttonFromColor : ESAA.buttonToColor
    Behavior on gradientToColor {
        ColorAnimation {
            duration: JW78Utils.longAniDuration
        }
    }
    Behavior on gradientFromColor {
        ColorAnimation {
            duration: JW78Utils.longAniDuration
        }
    }
    gradient: Gradient
    {
        orientation: Gradient.Horizontal
        GradientStop {position: 0.0; color: gradientFromColor}
        GradientStop {position: 1.0; color: gradientToColor}
    }
    IDPText
    {
        anchors.centerIn: parent
        id: headerCaption
        color: ESAA.textColor
        font.pixelSize: ESAA.fontTextPixelsize * 0.8
    }

    Logo
    {
        id: logo
        y: (parent.height - height) / 2
        width: Math.min(parent.height, parent.width)
        height: width
        visible: parent.height != headerHeight || !JW78APP.loggedIn
    }

    Behavior on height {
        NumberAnimation
        {
            duration: JW78Utils.longAniDuration
            easing.type: Easing.OutCubic
        }
    }
    MouseArea
    {
        anchors.fill: parent
        pressAndHoldInterval: 5000
        onPressAndHold: {
            ESAA.reset()
        }
    }
    NumberAnimation
    {
        id: rotateProfileImage
        target: profileImage
        property: "rotation"
        from: 0
        to: 360
        duration: JW78Utils.longAniDuration
    }

    Connections
    {
        target: JW78APP
        function onLoggedInChanged() {
            rotateProfileImage.start()
        }
    }

    Item
    {
        id: profileItem
        visible: parent.height == headerHeight && JW78APP.loggedIn
        width: height
        height: headerHeight
        Image
        {
            id: profileImage
            mipmap: true
            source: "qrc:/images/user.svg"
            anchors.centerIn: parent
            width: parent.width * 0.9
            height: parent.height * 0.9
        }
        MouseArea
        {
            z: 1
            anchors.fill: parent
            onClicked: profileIconClicked();
        }

    }

    onHeightChanged: {
        if (height == headerHeight)
        {
            rotateProfileImage.start()
        }
    }

    Image
    {
        property int changeCounter: 0
        Timer
        {
            interval: 10000
            repeat: true
            running: true
            onTriggered: helpImage.changeCounter += 1
        }
        id: helpImage
        anchors.right: parent.right
        anchors.rightMargin: (parent.headerHeight - parent.parent.height / 20) / 2
        anchors.topMargin: (parent.headerHeight - parent.parent.height / 20) / 2
        anchors.top: parent.top
        width: parent.parent.height / 20
        height: width
        source: "qrc:/images/help.svg"
        opacity: 0
        visible: !ESAA.isActiveVisit(helpImage.changeCounter)
        fillMode: Image.PreserveAspectFit
        mipmap: true
        Behavior on opacity {
            NumberAnimation
            {
                duration: JW78Utils.longAniDuration
            }
        }
        MouseArea
        {
            enabled: !ESAA.isActiveVisit(helpImage.changeCounter)
            anchors.fill: parent
            onClicked: helpClicked()
        }
    }

    PauseAnimation {
        duration: 3000
        id: longWait
        onStopped: helpImage.opacity = 1
    }

    function minimize()
    {
        minimized = true
        height = headerHeight
        logo.qrCodeOffset = parent.height / 10 / 8
        logo.claimImageX = parent.height / 10 / 8
        longWait.start()
    }

    PauseAnimation {
        id: hidePause
        duration: 1000
        onFinished: {
            splashDone()
            minimize()
        }
    }

    PauseAnimation
    {
        id: pause
        duration: 20
        onFinished:
        {
            hidePause.start()
            logo.qrCodeOpacity = 0.6
            logo.qrCodeOffset = splashscreen.width / 8
            logo.claimImageX = parent.width / 8
        }
    }
    function start()
    {
        pause.start()
    }
    Component.onCompleted: start()
}
