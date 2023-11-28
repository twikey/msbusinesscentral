$(document).ready(function () {
    init();
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnControlReady", []);
});