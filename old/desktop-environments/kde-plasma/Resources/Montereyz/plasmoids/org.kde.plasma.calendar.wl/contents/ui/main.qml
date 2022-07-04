/*
 * Copyright 2013  Heena Mahour <heena393@gmail.com>
 * Copyright 2013 Sebastian Kügler <sebas@kde.org>
 * Copyright 2016 Kai Uwe Broulik <kde@privat.broulik.de>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.calendar 2.0
import "calendar" as LocalCalendar

Item {
    
    property int formatMonth: plasmoid.configuration.formatMonth
    
    Plasmoid.switchWidth: units.gridUnit * 12
    Plasmoid.switchHeight: units.gridUnit * 12

    Plasmoid.toolTipMainText: Qt.formatDate(dataSource.data.Local.DateTime, "dddd")
    Plasmoid.toolTipSubText: {
        // this logic is taken from digital-clock:
        // remove "dddd" from the locale format string
        // /all/ locales in LongFormat have "dddd" either
        // at the beginning or at the end. so we just
        // remove it + the delimiter and space
        var format = Qt.locale().dateFormat(Locale.LongFormat);
        format = format.replace(/(^dddd.?\s)|(,?\sdddd$)/, "");
        return Qt.formatDate(dataSource.data.Local.DateTime, format)
    }
    
    Layout.minimumWidth: units.iconSizes.large
    Layout.minimumHeight: units.iconSizes.large

    PlasmaCore.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 60000
        intervalAlignment: PlasmaCore.Types.AlignToMinute
    }

    Plasmoid.compactRepresentation: MouseArea {
        onClicked: plasmoid.expanded = !plasmoid.expanded
    
        PlasmaCore.IconItem {
            id: icon
            anchors.fill: parent
            source: plasmoid.configuration.icon
            
        PlasmaComponents.Label {
                anchors {
                    fill: parent
                    leftMargin: plasmoid.configuration.monthHorizontalPosition
                    topMargin: plasmoid.configuration.monthVerticalPosition
                }
                height: undefined
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: plasmoid.configuration.monthFontSize
                font.pointSize: -1
                color: plasmoid.configuration.colorMonth
                text: {
                    var d = new Date(dataSource.data.Local.DateTime)
                    var format = plasmoid.configuration.formatMonth

                    return Qt.formatDate(d, format)
                }
            }
            
            PlasmaComponents.Label {
                anchors {
                    fill: parent
                    leftMargin: plasmoid.configuration.dayHorizontalPosition
                    topMargin: plasmoid.configuration.dayVerticalPosition

                }
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: plasmoid.configuration.dayFontSize
                font.pointSize: -1
                font.weight: plasmoid.configuration.bold ? Font.Bold : Font.Normal
                color: plasmoid.configuration.colorDay
                text: {
                    var d = new Date(dataSource.data.Local.DateTime)
                    var format = "d"

                    return Qt.formatDate(d, format)
                }
            }
        }
    }

    Plasmoid.fullRepresentation: LocalCalendar.MonthView {
        Layout.minimumWidth: units.gridUnit * 20
        Layout.minimumHeight: units.gridUnit * 20

        today: dataSource.data["Local"]["DateTime"]

        borderOpacity: 0
        circleStyle: true
    }
}
