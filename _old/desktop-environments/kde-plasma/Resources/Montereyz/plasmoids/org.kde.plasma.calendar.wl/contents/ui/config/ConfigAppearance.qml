import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4

Item {

    property string cfg_icon: plasmoid.configuration.icon
    property alias cfg_bold: bold.checked
    property alias cfg_colorDay: colorDay.text
    property alias cfg_dayFontSize: dayFontSize.value
    property alias cfg_dayHorizontalPosition: dayHorizontalPosition.value
    property alias cfg_dayVerticalPosition: dayVerticalPosition.value
    property string cfg_formatMonth: formatMonth.Index
    property alias cfg_colorMonth: colorMonth.text
    property alias cfg_monthFontSize: monthFontSize.value
    property alias cfg_monthHorizontalPosition: monthHorizontalPosition.value
    property alias cfg_monthVerticalPosition: monthVerticalPosition.value

    
    GridLayout {
        columns: 3
        columnSpacing: 20; rowSpacing: 4
        Layout.fillWidth: true
        anchors.right: parent.right
        anchors.left: parent.left

        Label {
            Layout.row: 0
            Layout.column: 0
            text: i18n("Icon:")
            font.bold: true
        }
        IconPicker {
            Layout.row: 0
            Layout.column: 2
            currentIcon: cfg_icon
            defaultIcon: "mini-calendar-widget"
            onIconChanged: cfg_icon = iconName
            enabled: true
            Layout.alignment: Qt.AlignRight
            }

        Label {
            Layout.row: 1
            Layout.column: 0
            text: i18n("Day settings")
            font.bold: true
        }
        
        CheckBox {
            Layout.row: 2
            Layout.column: 2
            id: bold
            text: i18n("Use bold font")
            Layout.alignment: Qt.AlignRight     
        }
        
        Label {
            Layout.row: 3
            Layout.column: 1
            text: i18n("Color:")
        }
        TextField {
                Layout.row: 3
                Layout.column: 2
                id: colorDay
                Layout.fillWidth: false
                Layout.preferredWidth: 60
                Layout.alignment: Qt.AlignRight
            }
  
        Label {
            Layout.row: 4
            Layout.column: 1
            text: i18n("Font size:")
        }
        Slider {
            Layout.row: 4
            Layout.column: 2
            id: dayFontSize
            stepSize: 1
            minimumValue: 1
            maximumValue: 100
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
        }
        
        Label {
            Layout.row: 5
            Layout.column: 1
            text: i18n("Horizontal position:")
        }
        Slider {
            Layout.row: 5
            Layout.column: 2
            id: dayHorizontalPosition
            stepSize: 1
            minimumValue: -100
            maximumValue: 100
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
        }
        
        Label {
            Layout.row: 6
            Layout.column: 1
            text: i18n("Vertical position:")
        }
        Slider {
            Layout.row: 6
            Layout.column: 2
            id: dayVerticalPosition
            stepSize: 1
            minimumValue: -100
            maximumValue: 100
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
        }
        
        Label {
            Layout.row: 7
            Layout.column: 0
            text: i18n("Month settings")
            font.bold: true
        }
        
        Label {
            Layout.row: 8
            Layout.column: 1
            text: i18n("Format:")
        }
        ComboBox {
            id: formatMonth
            textRole: "label"
            Layout.alignment: Qt.AlignRight
            model: [
                {
                    'label': i18n("Short"),
                    'name': "MMM"
                },
                {
                    'label': i18n("Long"),
                    'name': "MMMM"
                }
            ]
            onCurrentIndexChanged: cfg_formatMonth = model[currentIndex]["name"]

            Component.onCompleted: {
                for (var i = 0; i < model.length; i++) {
                    if (model[i]["name"] === plasmoid.configuration.formatMonth) {
                        formatMonth.currentIndex = i;
                    }
                }
            }
        }
        
        Label {
            Layout.row: 9
            Layout.column: 1
            text: i18n("Color:")
        }
        TextField {
                Layout.row: 9
                Layout.column: 2
                id: colorMonth
                Layout.fillWidth: false
                Layout.preferredWidth: 60
                Layout.alignment: Qt.AlignRight
            }
            
        Label {
            Layout.row: 10
            Layout.column: 1
            text: i18n("Font size:")
        }
        Slider {
            Layout.row: 10
            Layout.column: 2
            id: monthFontSize
            stepSize: 1
            minimumValue: 1
            maximumValue: 100
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
        }
        
        Label {
            Layout.row: 11
            Layout.column: 1
            text: i18n("Horizontal position:")
        }
        Slider {
            Layout.row: 11
            Layout.column: 2
            id: monthHorizontalPosition
            stepSize: 1
            minimumValue: -100
            maximumValue: 100
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
        }
        
        Label {
            Layout.row: 12
            Layout.column: 1
            text: i18n("Vertical position:")
        }
        Slider {
            Layout.row: 12
            Layout.column: 2
            id: monthVerticalPosition
            stepSize: 1
            minimumValue: -100
            maximumValue: 100
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
        }
        
        Item {
            width: 2
            height: 10
            Layout.columnSpan: 2
        }   
    }
}

