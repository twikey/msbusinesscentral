permissionset 71016575 "SCA.TWI.Twikey"
{
    Assignable = true;
    Caption = 'Twikey', MaxLength = 30;
    Permissions =
        table "SCA.TWI.Barcode" = X,
        tabledata "SCA.TWI.Barcode" = RMID,
        table "SCA.TWI.RESTWebServiceArg" = X,
        tabledata "SCA.TWI.RESTWebServiceArg" = RMID,
        table "SCA.TWI.TwikeyContractTemplate" = X,
        tabledata "SCA.TWI.TwikeyContractTemplate" = RMID,
        table "SCA.TWI.TwikeyContrTemplField" = X,
        tabledata "SCA.TWI.TwikeyContrTemplField" = RMID,
        table "SCA.TWI.TwikeyDocument" = X,
        tabledata "SCA.TWI.TwikeyDocument" = RMID,
        table "SCA.TWI.TwikeyDocumentField" = X,
        tabledata "SCA.TWI.TwikeyDocumentField" = RMID,
        table "SCA.TWI.TwikeyLogEntry" = X,
        tabledata "SCA.TWI.TwikeyLogEntry" = RMID,
        table "SCA.TWI.TwikeyRegistration" = X,
        tabledata "SCA.TWI.TwikeyRegistration" = RMID,
        table "SCA.TWI.TwikeySetup" = X,
        tabledata "SCA.TWI.TwikeySetup" = RMID,
        codeunit "SCA.TWI.TwikeyMgt" = X,
        codeunit "SCA.TWI.TwikeyJobQueue" = X,
        codeunit "SCA.TWI.CommunicationMgt" = X,
        codeunit "SCA.TWI.BarcodeWebReq" = X,
        codeunit "SCA.TWI.BarcodeMgt" = X,
        page "SCA.TWI.BarcodeList" = X,
        page "SCA.TWI.BarcodePage" = X,
        page "SCA.TWI.BarcodePicture" = X,
        page "SCA.TWI.ContractTemplates" = X,
        page "SCA.TWI.ContrTemplFields" = X,
        page "SCA.TWI.TwikeyDocumentFields" = X,
        page "SCA.TWI.TwikeyDocuments" = X,
        page "SCA.TWI.TwikeyLogEntries" = X,
        page "SCA.TWI.TwikeyLogEntry" = X,
        page "SCA.TWI.TwikeyRegistrations" = X,
        page "SCA.TWI.TwikeySetup" = X,
        table "SCA.TWI.CLETwikeyRegistration" = X,
        tabledata "SCA.TWI.CLETwikeyRegistration" = RMID,
        table "SCA.TWI.TwikeyServiceRegistr" = X,
        tabledata "SCA.TWI.TwikeyServiceRegistr" = RMID,
        codeunit "SCA.TWI.JsonHelper" = X,
        page "SCA.TWI.CLETwikeyRegAPI" = X,
        page "SCA.TWI.CLETwikeyRegistrations" = X,
        page "SCA.TWI.TwikeyDocumentsAPI" = X,
        page "SCA.TWI.TwikeyRegistrationsAPI" = X,
        page "SCA.TWI.TwikeyServiceRegistr" = X,
        page "SCA.TWI.TwikeyServRegistrAPI" = X,
        report "SCA.TWI.SendSalesInvoices" = X,
        report "SCA.TWI.SendServiceInvoices" = X;
}
