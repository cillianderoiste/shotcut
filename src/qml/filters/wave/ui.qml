/*
 * Copyright (c) 2014 Meltytech, LLC
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

import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import Shotcut.Controls 1.0

Rectangle {
    width: 400
    height: 200
    color: 'transparent'

    Component.onCompleted: {
        if (filter.isNew) {
            filter.set('wave', 10)
            filter.set('speed', 5)
            filter.set('deformX', 1)
            filter.set('deformY', 1)
        }
    }

    GridLayout {
        columns: 3
        anchors.fill: parent
        anchors.margins: 8

        Label {
            text: qsTr('Preset')
            Layout.alignment: Qt.AlignRight
        }
        Preset {
            Layout.columnSpan: 2
            parameters: ['wave', 'speed', 'deformX', 'deformX']
            onPresetSelected: {
                waveSlider.value = filter.get('wave')
                speedSlider.value = filter.get('speed')
                deformXCheckBox.checked = filter.get('deformX') === '1'
                deformYCheckBox.checked = filter.get('deformY') === '1'
            }
        }

        Label {
            text: qsTr('Amplitude')
            Layout.alignment: Qt.AlignRight
        }
        SliderSpinner {
            id: waveSlider
            minimumValue: 1
            maximumValue: 500
            value: filter.get('wave')
            onValueChanged: filter.set('wave', value)
        }
        UndoButton {
            onClicked: waveSlider.value = 10
        }

        Label {
            text: qsTr('Speed')
            Layout.alignment: Qt.AlignRight
        }
        SliderSpinner {
            id: speedSlider
            minimumValue: 0
            maximumValue: 1000
            value: filter.get('speed')
            onValueChanged: filter.set('speed', value)
        }
        UndoButton {
            onClicked: speedSlider.value = 5
        }

        Label {}
        CheckBox {
            id: deformXCheckBox
            text: qsTr('Deform horizontally?')
            Layout.columnSpan: 2
            checked: filter.get('deformX') === '1'
            property bool isReady: false
            Component.onCompleted: isReady = true
            onClicked: {
                if (isReady)
                    filter.set('deformX', checked)
            }
        }

        Label {}
        CheckBox {
            id: deformYCheckBox
            text: qsTr('Deform vertically?')
            Layout.columnSpan: 2
            checked: filter.get('deformY') === '1'
            property bool isReady: false
            Component.onCompleted: isReady = true
            onClicked: {
                if (isReady)
                    filter.set('deformY', checked)
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
