import QtQuick 2.0
import org.shotcut.qml 1.0

Metadata {
    type: Metadata.Filter
    objectName: 'fadeOutMovit'
    name: qsTr("Fade To Black")
    mlt_service: "movit.opacity"
    needsGPU: true
    qml: "ui.qml"
}
