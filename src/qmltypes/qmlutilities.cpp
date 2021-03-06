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

#include "qmltypes/qmlapplication.h"
#include "qmltypes/colorpickeritem.h"
#include "qmltypes/colorwheelitem.h"
#include "qmltypes/qmlprofile.h"
#include "qmltypes/qmlutilities.h"
#include "qmltypes/qmlfile.h"
#include "qmltypes/qmlhtmleditor.h"
#include "qmltypes/qmlmetadata.h"
#include "settings.h"
#include <QCoreApplication>
#include <QSysInfo>
#include <QCursor>
#include <QtQml>
#include <QQmlContext>

QmlUtilities::QmlUtilities(QObject *parent) :
    QObject(parent)
{
}

void QmlUtilities::registerCommonTypes()
{
    qmlRegisterType<QmlFile>("org.shotcut.qml", 1, 0, "File");
    qmlRegisterType<QmlHtmlEditor>("org.shotcut.qml", 1, 0, "HtmlEditor");
    qmlRegisterType<QmlMetadata>("org.shotcut.qml", 1, 0, "Metadata");
    qmlRegisterType<QmlUtilities>("org.shotcut.qml", 1, 0, "Utilities");
    qmlRegisterType<ColorPickerItem>("Shotcut.Controls", 1, 0, "ColorPickerItem");
    qmlRegisterType<ColorWheelItem>("Shotcut.Controls", 1, 0, "ColorWheelItem");
}

void QmlUtilities::setCommonProperties(QQmlContext* rootContext)
{
    rootContext->setContextProperty("settings", &ShotcutSettings::singleton());
    rootContext->setContextProperty("application", &QmlApplication::singleton());
    rootContext->setContextProperty("profile", &QmlProfile::singleton());
}

QDir QmlUtilities::qmlDir()
{
    QDir dir(qApp->applicationDirPath());
#if defined(Q_OS_UNIX) && !defined(Q_OS_MAC)
    dir.cdUp();
#endif
    dir.cd("share");
    dir.cd("shotcut");
    dir.cd("qml");
    return dir;
}
