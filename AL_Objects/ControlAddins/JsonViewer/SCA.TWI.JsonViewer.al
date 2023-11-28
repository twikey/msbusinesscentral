controladdin "SCA.TWI.JsonViewer"
{
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;
    Scripts =
        'https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.4.1.min.js',
        'AL_Objects/ControlAddins/JsonViewer/SCA.TWI.JsonViewer.js',
        'AL_Objects/ControlAddins/JsonViewer/SCA.TWI.JsonViewer.Control.js';
    StyleSheets =
        'AL_Objects/ControlAddins/JsonViewer/SCA.TWI.JsonViewer.css';
    StartupScript = 'AL_Objects/ControlAddins/JsonViewer/SCA.TWI.JsonViewer.Startup.js';

    event OnControlReady()

    /// <summary> 
    /// Set Json Data.
    /// </summary>
    /// <param name="JsonData">Parameter of type Text.</param>
    procedure SetJsonData(JsonData: Text)

    /// <summary> 
    /// Set Caption.
    /// </summary>
    /// <param name="Caption">Parameter of type Text.</param>
    procedure SetCaption(Caption: Text)
}