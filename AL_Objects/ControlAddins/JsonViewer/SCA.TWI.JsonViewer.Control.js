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
    iframe.style.paddingBottom = '20px';

    $('#controlAddIn').append('<label id="caption"></label><div id="content" class="content"><pre id="json-renderer"></pre></div>');
}

function SetJsonData(jsonData) {
    $('#content').empty();
    if (jsonData != '') {
        $('#content').html('<pre id="json-renderer"></pre>');
        $('#json-renderer').jsonViewer(eval('(' + jsonData + ')'));
    }
}

function SetCaption(caption) {
    $('#caption').text(caption);
}