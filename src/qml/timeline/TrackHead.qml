/*
 * Copyright (c) 2013 Meltytech, LLC
 * Author: Dan Dennedy <dan@dennedy.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0
import Shotcut.Controls 1.0 as Shotcut

Rectangle {
    property string trackName: ''
    property bool isMute
    property bool isHidden
    property int isComposite
    property bool isVideo
    signal clicked()

    id: trackHeadRoot
    SystemPalette { id: activePalette }
    color: activePalette.window
    clip: true

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: {
            parent.clicked()
            nameEdit.visible = false
        }
    }
    Column {
        id: trackHeadColumn
        spacing: (trackHeadRoot.height < 50)? 0 : 6
        anchors {
            top: parent.top
            left: parent.left
            margins: (trackHeadRoot.height < 50)? 0 : 4
        }

        Label {
            text: trackName
            color: activePalette.windowText
            width: trackHeadRoot.width
            elide: Qt.ElideRight
            MouseArea {
                height: parent.height
                width: nameEdit.width
                onClicked: {
                    nameEdit.visible = true
                    nameEdit.selectAll()
                }
            }
            TextField {
                id: nameEdit
                visible: false
                width: trackHeadRoot.width - trackHeadColumn.anchors.margins * 2
                text: trackName
                onAccepted: {
                    timeline.setTrackName(index, text)
                    visible = false
                }
                onFocusChanged: visible = focus
            }
        }
        RowLayout {
            spacing: 0
            CheckBox {
                id: muteButton
                checked: isMute
                style: CheckBoxStyle {
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 2
                        color: isMute? activePalette.highlight : trackHeadRoot.color
                        border.color: activePalette.shadow
                        border.width: 1
                        Text {
                            id: muteText
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr('M', 'Mute')
                            color: isMute? activePalette.highlightedText : activePalette.windowText
                        }
                    }
                }
                onClicked: timeline.toggleTrackMute(index)
                Shotcut.ToolTip { text: qsTr('Mute') }
            }

            CheckBox {
                id: hideButton
                checked: isHidden
                visible: isVideo
                style: CheckBoxStyle {
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 2
                        color: isHidden? activePalette.highlight : trackHeadRoot.color
                        border.color: activePalette.shadow
                        border.width: 1
                        Text {
                            id: hideText
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr('H', 'Hide')
                            color: isHidden? activePalette.highlightedText : activePalette.windowText
                        }
                    }
                }
                onClicked: timeline.toggleTrackHidden(index)
                Shotcut.ToolTip { text: qsTr('Hide') }
            }

            CheckBox {
                id: compositeButton
                visible: isVideo
                partiallyCheckedEnabled: true
                checkedState: isComposite
                style: CheckBoxStyle {
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 2
                        color: (isComposite === Qt.Checked)? activePalette.highlight
                            : (isComposite === Qt.PartiallyChecked)? Qt.lighter(activePalette.highlight)
                            : trackHeadRoot.color
                        border.color: activePalette.shadow
                        border.width: 1
                        Text {
                            id: compositeText
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr('C', 'Composite')
                            color: (isComposite === Qt.Checked)? activePalette.highlightedText : activePalette.windowText
                        }
                    }
                }
                onClicked: timeline.setTrackComposite(index, checkedState)
                Shotcut.ToolTip { text: qsTr('Composite') }
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onClicked: compositeMenu.popup()
                }
            }
        }
    }

    Menu {
        id: compositeMenu
        // XXX This is a workaround for menus appearing in wrong location in a Quick
        // view used in a DockWidget on OS X.
        Component.onCompleted: if (timeline.yoffset) __yOffset = timeline.yoffset
        MenuItem {
            text: qsTr('No Compositing')
            onTriggered: { timeline.setTrackComposite(index, Qt.Unchecked); compositeButton.checkedState = Qt.Unchecked }
        }
        MenuItem {
            text: qsTr('Composite')
            onTriggered: { timeline.setTrackComposite(index, Qt.PartiallyChecked); compositeButton.checkedState = Qt.PartiallyChecked }
        }
        MenuItem {
            text: qsTr('Composite And Fill')
            onTriggered: { timeline.setTrackComposite(index, Qt.Checked); compositeButton.checkedState = Qt.Checked }
        }
    }
}
