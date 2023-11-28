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

    $('#controlAddIn').append('<div id="leftRightSection"><div id="leftSection"><label id="leftCaption"></label><div id="leftContent" class="content"><pre id="lefJson-renderer"></pre></div></div><div id="rightSection"><label id="rightCaption"></label><div id="rightContent" class="content"><pre id="rightJson-renderer"></pre></div></div></div>');
}

function SetLeftJsonData(jsonData) {
    $('#leftContent').empty();
    if (jsonData != '') {
        $('#leftContent').html('<pre id="leftJson-renderer"></pre>');
        $('#leftJson-renderer').jsonViewer(eval('(' + jsonData + ')'));
    }
}

function SetRightJsonData(jsonData) {
    $('#rightContent').empty();
    if (jsonData != '') {
        $('#rightContent').html('<pre id="rightJson-renderer"></pre>');
        $('#rightJson-renderer').jsonViewer(eval('(' + jsonData + ')'));
    }
}

function SetLeftCaption(caption) {
    $('#leftCaption').text(caption);
}
function SetRightCaption(caption) {
    $('#rightCaption').text(caption);
}