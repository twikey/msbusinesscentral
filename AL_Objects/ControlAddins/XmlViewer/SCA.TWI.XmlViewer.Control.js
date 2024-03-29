function init() {
    var iframe = window.frameElement;

    iframe.parentElement.style.display = 'flex';
    iframe.parentElement.style.flexDirection = 'column';
    iframe.parentElement.style.flexGrow = '1';

    iframe.style.removeProperty('height');
    iframe.style.removeProperty('min-height');
    iframe.style.removeProperty('max-height');

    iframe.style.flexGrow = '1';
    iframe.style.flexShrink = '1';
    iframe.style.flexBasis = 'auto';
    iframe.style.paddingBottom = '42px';

    $('#controlAddIn').append('<label id="caption"></label><div id="content"><pre id="xml-renderer"></pre></div>');
}

function SetXmlData(xmlData) {
    $('#content').empty();
    if (xmlData != '') {
        $('#content').html('<pre id="xml-renderer"></pre>');
        $('#xml-renderer').simpleXML({ xmlString: xmlData });
    }
}