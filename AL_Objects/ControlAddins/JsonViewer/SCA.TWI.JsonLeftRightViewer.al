controladdin "SCA.TWI.JsonLeftRightViewer"
{
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;
    Scripts =
        'https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.4.1.min.js',
        'AL_Objects/ControlAddins/JsonViewer/SCA.TWI.JsonViewer.js',
        'AL_Objects/ControlAddins/JsonViewer/SCA.TWI.JsonLeftRightViewer.Control.js';
    StyleSheets =
        'AL_Objects/ControlAddins/JsonViewer/SCA.TWI.JsonViewer.css';
    StartupScript = 'AL_Objects/ControlAddins/JsonViewer/SCA.TWI.JsonViewer.Startup.js';

    event OnControlReady()

    /// <summary> 
    /// Set Left Json Data.
    /// </summary>
    /// <param name="JsonData">Parameter of type Text.</param>
    procedure SetLeftJsonData(JsonData: Text)

    /// <summary> 
    /// Set Right Json Data.
    /// </summary>
    /// <param name="JsonData">Parameter of type Text.</param>
    procedure SetRightJsonData(JsonData: Text)

    /// <summary> 
    /// Set Left Caption.
    /// </summary>
    /// <param name="Caption">Parameter of type Text.</param>
    procedure SetLeftCaption(Caption: Text)

    /// <summary> 
    /// Set Right Caption.
    /// </summary>
    /// <param name="Caption">Parameter of type Text.</param>
    procedure SetRightCaption(Caption: Text)
}