/*
 * Copyright (c) 2013 Meltytech, LLC
 * Author: Brian Matherly <pez4brian@yahoo.com>
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

#include "qmlapplication.h"
#include <QApplication>
#include <QCoreApplication>
#include <QSysInfo>
#include <QCursor>
#include <QPalette>

QmlApplication& QmlApplication::singleton()
{
    static QmlApplication instance;
    return instance;
}

QmlApplication::QmlApplication() :
    QObject()
{
}

Qt::WindowModality QmlApplication::dialogModality()
{
#ifdef Q_OS_OSX
    return (QSysInfo::macVersion() >= QSysInfo::MV_10_8)? Qt::WindowModal : Qt::ApplicationModal;
#else
    return Qt::ApplicationModal;
#endif
}

QPoint QmlApplication::mousePos()
{
    return QCursor::pos();
}

QColor QmlApplication::toolTipBaseColor()
{
    return qApp->palette().toolTipBase().color();
}

QColor QmlApplication::toolTipTextColor()
{
    return qApp->palette().toolTipText().color();
}
