controladdin "SCA.TWI.XmlViewer"
{
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;
    Scripts =
        'https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.4.1.min.js',
        'AL_Objects/ControlAddIns/XmlViewer/SCA.TWI.XmlViewer.js',
        'AL_Objects/ControlAddIns/XmlViewer/SCA.TWI.XmlViewer.Control.js';
    StyleSheets =
        'AL_Objects/ControlAddIns/XmlViewer/SCA.TWI.XmlViewer.css';
    StartupScript = 'AL_Objects/ControlAddIns/XmlViewer/SCA.TWI.XmlViewer.Startup.js';
    Images = 'AL_Objects/ControlAddIns/XmlViewer/SCA.TWI.XmlViewer.png';

    event OnControlReady()

    /// <summary> 
    /// Set Xml Data.
    /// </summary>
    /// <param name="XmlData">Parameter of type Text.</param>
    procedure SetXmlData(XmlData: Text)

    /// <summary> 
    /// Set Caption.
    /// </summary>
    /// <param name="Caption">Parameter of type Text.</param>
    procedure SetCaption(Caption: Text)
}