codeunit 71016575 "SCA.TWI.TwikeyMgt"
{

    procedure GetBaseURL(): Text
    begin
        //exit('https://gijstest.free.beeceptor.com');
        exit(TwikeySetup."Environment URL");
    end;

    procedure GetBasicAuthKey(): Text;
    var
        Content: Text;
        Headers: HttpHeaders;
        Client: HttpClient;
        HttpContent: HttpContent;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        TenantId: Text;
        Url: Text;
        JArray: JsonArray;
        JValue: JsonValue;
        JToken: JsonToken;
        JObject: JsonObject;
    begin
        TwikeySetup.TestField("Environment URL");
        TwikeySetup.TestField("API Key");
        Url := TwikeySetup."Environment URL" + 'creditor';

        Request.SetRequestUri(url);
        Request.Method := 'POST';

        Content := 'apiToken=' + TwikeySetup."API Key";

        HttpContent.WriteFrom(Content);
        HttpContent.GetHeaders(Headers);

        if Headers.Contains('Content-Type') then begin
            Headers.Remove('Content-Type');
        end;
        Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

        Request.Content := HttpContent;

        if Client.Send(Request, Response) then begin
            Response.Content.ReadAs(Content);
            if JToken.ReadFrom(Content) then begin
                JHelper.GetJsonValue(JToken, JValue, 'Authorization');
                BasicAuthKey := JValue.AsText();
            end;
        end;
        exit(BasicAuthKey);
    end;

    local procedure GetContractTemplate(var ContractTemplate: Record "SCA.TWI.TwikeyContractTemplate")
    var
        ContractTemplates: Page "SCA.TWI.ContractTemplates";
        ContractTemplateErr: Label 'Twikey Contract Templates have not been set up correctly';
        ContractTemplateSelErr: Label 'You have to select a contract template';
    begin
        if ContractTemplate.IsEmpty then begin
            Error(ContractTemplateErr);
        end;
        if ContractTemplate.Count = 1 then begin
            ContractTemplate.FindFirst();
        end else begin
            ContractTemplates.LookupMode(true);
            if ContractTemplates.RunModal() = Action::LookupOK then begin
                ContractTemplates.GetRecord(ContractTemplate);
            end else begin
                Error(ContractTemplateSelErr);
            end;
        end;
    end;

    procedure InviteCustomer(Customer: Record Customer)
    var
        JsonMgt: Codeunit "JSON Management";
        JResponse: JsonToken;
        JRequest: JsonToken;
        CustObj: JsonObject;
        JValue: JsonValue;
        TwikeyDocument: Record "SCA.TWI.TwikeyDocument";
        Content: Text;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpContent: HttpContent;
        Headers: HttpHeaders;
        Client: HttpClient;
        ContractTemplate: Record "SCA.TWI.TwikeyContractTemplate";
        Label10: Label '%1 has been invited to sign the contract via Twikey!';
        Url: Text;
        ContractTemplateField: Record "SCA.TWI.TwikeyContrTemplField";
        ContractField: Record "SCA.TWI.TwikeyDocumentField";
        Label20: Label 'Field Name %1 has not been set for Customer No. %2 and Contract Template Id %3';
        VatRegistrationNo: Text;
        ResponseContent: Text;

    begin
        // CustObj.Add('ct', '3290');
        // CustObj.Add('l', Customer."Language Code");
        // CustObj.Add('email', Customer."E-Mail");
        // CustObj.Add('lastname', '');
        // CustObj.Add('firstname', Customer.Name);
        // CustObj.Add('mobile', Customer."Mobile Phone No.");
        // CustObj.Add('address', Customer.Address);
        // CustObj.Add('zip', Customer."Post Code");
        // CustObj.Add('city', Customer.City);
        // CustObj.Add('country', Customer."Country/Region Code");
        // JRequest := CustObj.AsToken();
        // JResponse := WebRequestMgt.ExecuteWebRequest('creditor/invite', 'POST', JRequest);
        // if JHelper.GetJsonValue(JResponse, JValue, 'mndtId') then begin
        //     TwikeyMandate.Init();
        //     TwikeyMandate."Customer No." := Customer."No.";
        //     TwikeyMandate."Mandate Id" := JValue.AsText();
        //     TwikeyMandate.Insert();
        // end;
        Customer.TestField("E-Mail");

        if IsTwikeyEnabled() then begin
            GetContractTemplate(ContractTemplate);
            Url := GetBaseURL() + 'creditor/invite';
            Request.SetRequestUri(Url);
            Request.Method := 'POST';

            Request.GetHeaders(Headers);
            if BasicAuthKey = '' then begin
                BasicAuthKey := GetBasicAuthKey();
            end;

            if Headers.Contains('Authorization') then begin
                Headers.Remove('Authorization');
            end;
            Headers.Add('Authorization', BasicAuthKey);

            Content := 'ct=' + format(ContractTemplate.Id);
            Content += '&l=' + Customer."Language Code";
            Content += '&email=' + Customer."E-Mail";
            Content += '&companyName=' + Customer.Name;
            Content += '&lastname=' + '-';
            if Customer.Contact <> '' then begin
                Content += '&firstname=' + Customer.Contact;
            end else begin
                Content += '&firstname=' + Customer.Name;
            end;
            Content += '&mobile=' + Customer."Mobile Phone No.";
            Content += '&address=' + Customer.Address;
            Content += '&zip=' + Customer."Post Code";
            Content += '&city=' + Customer.City;
            Content += '&country=' + Customer."Country/Region Code";
            Content += '&customerNumber=' + Customer."No.";
            if ContractTemplate."Send Mail on Invite" then begin
                Content += '&sendInvite=true';
            end;
            VatRegistrationNo := GetCustomerVatRegistrationNo(Customer);
            if VatRegistrationNo <> '' then begin
                Content += '&vatno=' + VatRegistrationNo;
            end;

            ContractTemplateField.SetRange(Id, ContractTemplate.Id);
            if ContractTemplateField.FindSet() then begin
                repeat
                    ContractField.SetRange("Customer No.", Customer."No.");
                    ContractField.SetRange("Contract Template", ContractTemplate.Id);
                    ContractField.SetRange("Field Name", ContractTemplateField."Field Name");
                    if ContractField.FindFirst() and (ContractField."Field Value" <> '') then begin
                        Content += '&' + ContractField."Field Name" + '=' + ContractField."Field Value";
                    end else begin
                        if ContractTemplateField.Mandatory then begin
                            Error(StrSubstNo(Label20, ContractTemplateField."Field Name", Customer."No.", ContractTemplate.Id));
                        end;
                    end;
                until ContractTemplateField.Next() = 0;
            end;


            HttpContent.WriteFrom(Content);
            HttpContent.GetHeaders(Headers);

            if Headers.Contains('Content-Type') then begin
                Headers.Remove('Content-Type');
            end;
            Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

            Request.Content := HttpContent;

            if Client.Send(Request, Response) then begin
                Response.Content.ReadAs(ResponseContent);
                if JResponse.ReadFrom(ResponseContent) then begin
                    if JHelper.GetJsonValue(JResponse, JValue, 'mndtId') then begin
                        TwikeyDocument.Init();
                        TwikeyDocument."Customer No." := Customer."No.";
                        TwikeyDocument."Document Id" := JValue.AsText();
                        TwikeyDocument.Status := 'Pending';
                        TwikeyDocument."Contract Template" := ContractTemplate.Id;
                        TwikeyDocument.Insert();
                    end;
                end;
            end;
            WebRequestMgt.CreateLogEntry(Url, Request.Method, Content, Response, '');
            Message(strsubstno(Label10, Customer."E-Mail"));

        end else begin
            Error(TwikeySetupErr);
        end;
    end;


    procedure InviteCustomer(Customer: Record Customer; ContractTemplate: Record "SCA.TWI.TwikeyContractTemplate")
    var
        JsonMgt: Codeunit "JSON Management";
        JResponse: JsonToken;
        JRequest: JsonToken;
        CustObj: JsonObject;
        JValue: JsonValue;
        TwikeyDocument: Record "SCA.TWI.TwikeyDocument";
        Content: Text;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpContent: HttpContent;
        Headers: HttpHeaders;
        Client: HttpClient;
        Label1: Label '%1 has been invited to sign the contract via Twikey!';
        Url: Text;
        ContractTemplateField: Record "SCA.TWI.TwikeyContrTemplField";
        ContractField: Record "SCA.TWI.TwikeyDocumentField";
        Label2: Label 'Field Name %1 has not been set for Customer No. %2 and Contract Template Id %3';
        VatRegistrationNo: Text;
        ResponseContent: Text;

    begin
        Customer.TestField("E-Mail");

        Url := GetBaseURL() + 'creditor/invite';
        Request.SetRequestUri(Url);
        Request.Method := 'POST';

        Request.GetHeaders(Headers);
        if BasicAuthKey = '' then begin
            BasicAuthKey := GetBasicAuthKey();
        end;

        if Headers.Contains('Authorization') then begin
            Headers.Remove('Authorization');
        end;
        Headers.Add('Authorization', BasicAuthKey);

        Content := 'ct=' + format(ContractTemplate.Id);
        Content += '&l=' + Customer."Language Code";
        Content += '&email=' + Customer."E-Mail";
        Content += '&companyName=' + Customer.Name;
        Content += '&lastname=' + '-';
        if Customer.Contact <> '' then begin
            Content += '&firstname=' + Customer.Contact;
        end else begin
            Content += '&firstname=' + Customer.Name;
        end;
        Content += '&mobile=' + Customer."Mobile Phone No.";
        Content += '&address=' + Customer.Address;
        Content += '&zip=' + Customer."Post Code";
        Content += '&city=' + Customer.City;
        Content += '&country=' + Customer."Country/Region Code";
        Content += '&customerNumber=' + Customer."No.";

        VatRegistrationNo := GetCustomerVatRegistrationNo(Customer);
        if VatRegistrationNo <> '' then begin
            Content += '&vatno=' + VatRegistrationNo;
        end;

        if ContractTemplate."Send Mail on Invite" then begin
            Content += '&sendInvite=true';
        end;
        ContractTemplateField.SetRange(Id, ContractTemplate.Id);
        if ContractTemplateField.FindSet() then begin
            repeat
                ContractField.SetRange("Customer No.", Customer."No.");
                ContractField.SetRange("Contract Template", ContractTemplate.Id);
                ContractField.SetRange("Field Name", ContractTemplateField."Field Name");
                if ContractField.FindFirst() and (ContractField."Field Value" <> '') then begin
                    Content += '&' + ContractField."Field Name" + '=' + ContractField."Field Value";
                end else begin
                    if ContractTemplateField.Mandatory then begin
                        Error(StrSubstNo(Label2, ContractTemplateField."Field Name", Customer."No.", ContractTemplate.Id));
                    end;
                end;
            until ContractTemplateField.Next() = 0;
        end;


        HttpContent.WriteFrom(Content);
        HttpContent.GetHeaders(Headers);

        if Headers.Contains('Content-Type') then begin
            Headers.Remove('Content-Type');
        end;
        Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

        Request.Content := HttpContent;

        if Client.Send(Request, Response) then begin
            Response.Content.ReadAs(ResponseContent);
            if JResponse.ReadFrom(ResponseContent) then begin
                if JHelper.GetJsonValue(JResponse, JValue, 'mndtId') then begin
                    TwikeyDocument.Init();
                    TwikeyDocument."Customer No." := Customer."No.";
                    TwikeyDocument."Document Id" := JValue.AsText();
                    TwikeyDocument.Status := 'Pending';
                    TwikeyDocument."Contract Template" := ContractTemplate.Id;
                    TwikeyDocument.Insert();
                end;
            end;
        end;
        WebRequestMgt.CreateLogEntry(Url, Request.Method, Content, Response, '');

    end;

    local procedure GetCustomerVatRegistrationNo(Customer: Record Customer): Text;
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        EnterpriseNo: Text;
        Field: Record Field;
        CustomerTableNo: Integer;
        EnterpriseNoFieldNo: Integer;
    begin
        CustomerTableNo := 18;
        EnterpriseNoFieldNo := 11310;

        Field.SetRange(TableNo, CustomerTableNo);
        Field.SetRange("No.", EnterpriseNoFieldNo);
        if Field.FindFirst() then begin
            RecRef.Open(CustomerTableNo);
            RecRef.Get(Customer.RecordId);
            FieldRef := RecRef.Field(EnterpriseNoFieldNo);
            if Evaluate(EnterpriseNo, FieldRef.Value) then begin
                if EnterpriseNo <> '' then begin
                    if StrPos(EnterpriseNo, 'BTW ') = 1 then begin
                        EnterpriseNo := CopyStr(EnterpriseNo, 5);
                    end;
                    exit(EnterpriseNo);
                end;
            end;
        end;

        if Customer."VAT Registration No." <> '' then begin
            exit(Customer."VAT Registration No.");
        end;
    end;

    procedure InviteCustomers(var Customer: Record Customer)
    var
        JsonMgt: Codeunit "JSON Management";
        JResponse: JsonToken;
        JRequest: JsonToken;
        CustObj: JsonObject;
        JValue: JsonValue;
        TwikeyDocument: Record "SCA.TWI.TwikeyDocument";
        Content: Text;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpContent: HttpContent;
        Headers: HttpHeaders;
        Client: HttpClient;
        ContractTemplate: Record "SCA.TWI.TwikeyContractTemplate";
        Label1: Label 'The customer has been invited to sign the contract via Twikey!';
        Url: Text;
        ContractTemplateField: Record "SCA.TWI.TwikeyContrTemplField";
        ContractField: Record "SCA.TWI.TwikeyDocumentField";
        Label2: Label 'Field Name %1 has not been set for Customer No. %2 and Contract Template Id %3';
        Label3: Label 'The selected customers have been invited to sign the contract via Twikey!';

    begin
        if IsTwikeyEnabled() then begin
            GetContractTemplate(ContractTemplate);

            if Customer.FindSet() then begin
                repeat
                    InviteCustomer(Customer, ContractTemplate);
                until Customer.Next() = 0;
                if Customer.Count = 1 then begin
                    Message(Label1);
                end else begin
                    Message(Label3);
                end;
            end;
        end else begin
            Error(TwikeySetupErr);
        end;
    end;


    procedure SuspendDocument(TwikeyDocument: Record "SCA.TWI.TwikeyDocument")
    var
        JsonMgt: Codeunit "JSON Management";
        JResponse: JsonToken;
        JRequest: JsonToken;
        CustObj: JsonObject;
        JValue: JsonValue;
        Content: Text;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpContent: HttpContent;
        Headers: HttpHeaders;
        Client: HttpClient;
        ContractTemplate: Record "SCA.TWI.TwikeyContractTemplate";
        Label1: Label '%1 has been invited to sign the contract via Twikey!';
        Url: Text;
        ContractTemplateField: Record "SCA.TWI.TwikeyContrTemplField";
        ContractField: Record "SCA.TWI.TwikeyDocumentField";
        Label2: Label 'Field Name %1 has not been set for Customer No. %2 and Contract Template Id %3';
        ResponseContent: Text;

    begin
        if IsTwikeyEnabled() then begin
            Url := GetBaseURL() + 'creditor/mandate/update';
            Request.SetRequestUri(Url);
            Request.Method := 'POST';

            Request.GetHeaders(Headers);
            if BasicAuthKey = '' then begin
                BasicAuthKey := GetBasicAuthKey();
            end;

            if Headers.Contains('Authorization') then begin
                Headers.Remove('Authorization');
            end;
            Headers.Add('Authorization', BasicAuthKey);

            Content := 'mndtId=' + format(TwikeyDocument."Document Id");
            Content += '&state=' + 'passive';

            HttpContent.WriteFrom(Content);
            HttpContent.GetHeaders(Headers);

            if Headers.Contains('Content-Type') then begin
                Headers.Remove('Content-Type');
            end;
            Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

            Request.Content := HttpContent;

            if Client.Send(Request, Response) then begin
                Response.Content.ReadAs(ResponseContent);
                TwikeyDocument.Status := 'Suspended';
                TwikeyDocument.Modify();
            end;
            WebRequestMgt.CreateLogEntry(Url, Request.Method, Content, Response, '');
        end else begin
            Error(TwikeySetupErr);
        end;
    end;

    procedure ReactivateDocument(TwikeyDocument: Record "SCA.TWI.TwikeyDocument")
    var
        JsonMgt: Codeunit "JSON Management";
        JResponse: JsonToken;
        JRequest: JsonToken;
        CustObj: JsonObject;
        JValue: JsonValue;
        Content: Text;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpContent: HttpContent;
        Headers: HttpHeaders;
        Client: HttpClient;
        ContractTemplate: Record "SCA.TWI.TwikeyContractTemplate";
        Label1: Label '%1 has been invited to sign the contract via Twikey!';
        Url: Text;
        ContractTemplateField: Record "SCA.TWI.TwikeyContrTemplField";
        ContractField: Record "SCA.TWI.TwikeyDocumentField";
        Label2: Label 'Field Name %1 has not been set for Customer No. %2 and Contract Template Id %3';
        ResponseContent: Text;

    begin
        if IsTwikeyEnabled() then begin
            Url := GetBaseURL() + 'creditor/mandate/update';
            Request.SetRequestUri(Url);
            Request.Method := 'POST';

            Request.GetHeaders(Headers);
            if BasicAuthKey = '' then begin
                BasicAuthKey := GetBasicAuthKey();
            end;

            if Headers.Contains('Authorization') then begin
                Headers.Remove('Authorization');
            end;
            Headers.Add('Authorization', BasicAuthKey);

            Content := 'mndtId=' + format(TwikeyDocument."Document Id");
            Content += '&state=' + 'active';

            HttpContent.WriteFrom(Content);
            HttpContent.GetHeaders(Headers);

            if Headers.Contains('Content-Type') then begin
                Headers.Remove('Content-Type');
            end;
            Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

            Request.Content := HttpContent;

            if Client.Send(Request, Response) then begin
                Response.Content.ReadAs(ResponseContent);
                TwikeyDocument.Status := 'Signed';
                TwikeyDocument.Modify();
            end;
            WebRequestMgt.CreateLogEntry(Url, Request.Method, Content, Response, '');
        end else begin
            Error(TwikeySetupErr);
        end;
    end;



    procedure CancelContract(TwikeyDocument: Record "SCA.TWI.TwikeyDocument")
    var
        JsonMgt: Codeunit "JSON Management";
        JResponse: JsonToken;
        JRequest: JsonToken;
        CustObj: JsonObject;
        JValue: JsonValue;
        Content: Text;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpContent: HttpContent;
        Headers: HttpHeaders;
        Client: HttpClient;
        ContractTemplate: Record "SCA.TWI.TwikeyContractTemplate";
        Label1: Label 'The contract has been cancelled via Twikey!';
        Label2: Label 'Are you sure you want to send this cancellation to Twikey?';
        Label3: Label 'The contract has not been cancelled via Twikey, please cancel it manually via Twikey.';
        Url: Text;
    begin
        TwikeyDocument.TestField("Cancel Reason");
        if Confirm(Label2) then begin
            if IsTwikeyEnabled() then begin
                Url := GetBaseURL() + 'creditor/mandate?mndtId=' + TwikeyDocument."Document Id" + '&rsn=' + TwikeyDocument."Cancel Reason";
                Request.SetRequestUri(Url);
                Request.Method := 'DELETE';

                Request.GetHeaders(Headers);
                if BasicAuthKey = '' then begin
                    BasicAuthKey := GetBasicAuthKey();
                end;

                if Headers.Contains('Authorization') then begin
                    Headers.Remove('Authorization');
                end;
                Headers.Add('Authorization', BasicAuthKey);

                if Client.Send(Request, Response) then begin
                    if Response.HttpStatusCode = 200 then begin
                        TwikeyDocument.Status := 'Cancelled';
                        TwikeyDocument.Modify();
                    end else begin
                        Commit();
                        Error(Label3);
                    end;
                    // Response.Content.ReadAs(Content);
                    // if JResponse.ReadFrom(Content) then begin
                    //     if JHelper.GetJsonValue(JResponse, JValue, 'mndtId') then begin
                    //         TwikeyDocument.Status := 'Cancelled';
                    //         TwikeyDocument.Modify();
                    //     end;
                    // end;
                end;
                WebRequestMgt.CreateLogEntry(Url, Request.Method, format(Request.Content), Response, '');
                Message(Label1);

            end else begin
                Error(TwikeySetupErr);
            end;
        end;
    end;


    // procedure SignMandate(Customer: Record Customer)
    // var
    //     JsonMgt: Codeunit "JSON Management";
    //     JResponse: JsonToken;
    //     JRequest: JsonToken;
    //     MainObj: JsonObject;
    //     JValue: JsonValue;
    //     CustBankAccount: Record "Customer Bank Account";
    //     TwikeyMandate: Record "SCA.TWI.TwikeyMandate";
    // begin
    //     CustBankAccount.Get(Customer."No.", Customer."Preferred Bank Account Code");

    //     MainObj.Add('method', 'sms');
    //     MainObj.Add('place', Customer.City);
    //     MainObj.Add('ct', '3290');
    //     MainObj.Add('iban', CustBankAccount.IBAN);
    //     MainObj.Add('bic', CustBankAccount."SWIFT Code");
    //     MainObj.Add('email', Customer."E-Mail");
    //     MainObj.Add('lastname', '');
    //     MainObj.Add('firstname', Customer.Name);
    //     MainObj.Add('mobile', Customer."Mobile Phone No.");
    //     MainObj.Add('address', Customer.Address);
    //     MainObj.Add('city', Customer.City);
    //     MainObj.Add('zip', Customer."Post Code");
    //     MainObj.Add('country', Customer."Country/Region Code");
    //     JRequest := MainObj.AsToken();

    //     JResponse := WebRequestMgt.ExecuteWebRequest('creditor/sign', 'POST', JRequest);

    //     if JHelper.GetJsonValue(JResponse, JValue, 'MndtId') then begin
    //         TwikeyMandate.Init();
    //         TwikeyMandate."Customer No." := Customer."No.";
    //         TwikeyMandate."Mandate Id" := JValue.AsText();
    //         TwikeyMandate.Insert();
    //     end;
    // end;

    procedure MandateFeed()
    var
        JsonMgt: Codeunit "JSON Management";
        JResponse: JsonToken;
        JRequest: JsonToken;
        MndtObj: JsonObject;
        JValue: JsonValue;
        JArray: JsonArray;
        JItem: JsonToken;
        JArray2: JsonArray;
        JItem2: JsonToken;
        TwikeyDocument: Record "SCA.TWI.TwikeyDocument";
    begin
        if IsTwikeyEnabled() then begin
            if GuiAllowed then begin
                Window.Open('Processing data... @1@@@@@@@@@@');
            end;

            if BasicAuthKey = '' then begin
                GetBasicAuthKey();
            end;

            WebRequestMgt.SetBasicAuthkey(BasicAuthKey);
            JResponse := WebRequestMgt.ExecuteWebRequest(GetBaseURL() + 'creditor/mandate', 'GET', JRequest);

            if JHelper.GetJsonArray(JResponse, JArray, 'Messages') then begin
                foreach JItem in JArray do begin
                    if JHelper.GetJsonObject(JItem, MndtObj, 'Mndt') then begin
                        if JHelper.GetJsonValue(MndtObj, JValue, 'MndtId') then begin
                            TwikeyDocument.SetRange("Document Id", JValue.AsText());
                            if TwikeyDocument.FindFirst() then begin
                                TwikeyDocument.Status := 'Signed';
                                TwikeyDocument.Modify();
                            end;
                        end;
                    end;
                    if JHelper.GetJsonObject(JItem, MndtObj, 'CxlRsn') then begin
                        if JHelper.GetJsonValue(JItem.AsObject(), JValue, 'OrgnlMndtId') then begin
                            TwikeyDocument.SetRange("Document Id", JValue.AsText());
                            if TwikeyDocument.FindFirst() then begin
                                TwikeyDocument.Status := 'Cancelled';
                            end;
                        end;
                    end;
                end;
            end;
            if GuiAllowed then begin
                Window.Close();
            end;
        end;
    end;


    procedure CreateInvoice(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        JsonMgt: Codeunit "JSON Management";
        JResponse: JsonToken;
        JRequest: JsonToken;
        JArray: JsonArray;
        JItem: JsonToken;
        JValue: JsonValue;
        NoOfRecs: Integer;
        CurrRec: Integer;
        TwikeyLink: Record "SCA.TWI.TwikeyRegistration";
        EntryNo: Integer;
    begin
        if IsTwikeyEnabled() then begin
            if GuiAllowed then begin
                Window.Open('Processing data... @1@@@@@@@@@@');
            end;

            BuildCreateInvoiceRequest(JRequest, SalesInvoiceHeader);
            if BasicAuthKey = '' then begin
                GetBasicAuthKey();
            end;

            WebRequestMgt.SetBasicAuthkey(BasicAuthKey);
            JResponse := WebRequestMgt.ExecuteWebRequest(GetBaseURL() + 'creditor/invoice', 'POST', JRequest);

            TwikeyLink.SetRange("Posted Sales Invoice No.", SalesInvoiceHeader."No.");
            if TwikeyLink.FindFirst() then begin
                if JHelper.GetJsonValue(JResponse, JValue, 'id') then begin
                    TwikeyLink."Twikey Invoice Id" := JValue.AsText();
                end;
                if JHelper.GetJsonValue(JResponse, JValue, 'state') then begin
                    TwikeyLink."Invoice Status" := JValue.AsText();
                end;
                if JHelper.GetJsonValue(JResponse, JValue, 'url') then begin
                    TwikeyLink."Invoice Payment URL" := JValue.AsText();
                end;
                TwikeyLink.Modify();
            end else begin
                TwikeyLink.Reset();
                if TwikeyLink.FindLast() then begin
                    EntryNo := TwikeyLink."Entry No.";
                end;
                EntryNo += 1;
                TwikeyLink.Init();
                TwikeyLink."Entry No." := EntryNo;
                TwikeyLink."Posted Sales Invoice No." := SalesInvoiceHeader."No.";
                if JHelper.GetJsonValue(JResponse, JValue, 'id') then begin
                    TwikeyLink."Twikey Invoice Id" := JValue.AsText();
                end;
                if JHelper.GetJsonValue(JResponse, JValue, 'state') then begin
                    TwikeyLink."Invoice Status" := JValue.AsText();
                end;
                if JHelper.GetJsonValue(JResponse, JValue, 'url') then begin
                    TwikeyLink."Invoice Payment URL" := JValue.AsText();
                end;
                TwikeyLink.Insert();
            end;
            if GuiAllowed then begin
                Window.Close();
            end;
        end;
    end;

    local procedure BuildCreateInvoiceRequest(var JRequest: JsonToken; SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        InvoiceObj: JsonObject;
        CustObj: JsonObject;
        Customer: Record Customer;
        VatRegistrationNo: Text;
    begin
        if not Customer.Get(SalesInvoiceHeader."Bill-to Customer No.") then
            Customer.Init();
        SalesInvoiceHeader.CalcFields("Amount Including VAT");

        InvoiceObj.Add('number', SalesInvoiceHeader."No.");
        InvoiceObj.Add('title', SalesInvoiceHeader."Your Reference");
        InvoiceObj.Add('remittance', SalesInvoiceHeader."Your Reference");
        if SalesInvoiceHeader."SCA.TWI.TwikeyContractTemplate" <> 0 then begin
            InvoiceObj.Add('ct', SalesInvoiceHeader."SCA.TWI.TwikeyContractTemplate");
        end;
        InvoiceObj.Add('amount', format(SalesInvoiceHeader."Amount Including VAT", 0, 9));
        InvoiceObj.Add('date', SalesInvoiceHeader."Posting Date");
        InvoiceObj.Add('duedate', SalesInvoiceHeader."Due Date");
        InvoiceObj.Add('locale', SalesInvoiceHeader."Language Code");

        CustObj.Add('customerNumber', Customer."No.");
        CustObj.Add('email', Customer."E-Mail");
        CustObj.Add('companyName', Customer.Name);
        if Customer.Contact <> '' then begin
            CustObj.Add('firstname', Customer.Contact);
        end else begin
            CustObj.Add('firstname', Customer.Name);
        end;
        CustObj.Add('lastname', '-');
        CustObj.Add('mobile', Customer."Mobile Phone No.");
        CustObj.Add('address', Customer.Address);
        CustObj.Add('zip', Customer."Post Code");
        CustObj.Add('city', Customer.City);
        CustObj.Add('country', Customer."Country/Region Code");
        CustObj.Add('l', Customer."Language Code");
        VatRegistrationNo := GetCustomerVatRegistrationNo(Customer);
        if VatRegistrationNo <> '' then begin
            CustObj.Add('vatno', VatRegistrationNo);
        end;


        InvoiceObj.Add('customer', CustObj.AsToken());

        //InvoiceObj.Add('pdf', '');

        JRequest := InvoiceObj.AsToken();
    end;

    procedure CreateCustLedgerEntry(CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        JsonMgt: Codeunit "JSON Management";
        JResponse: JsonToken;
        JRequest: JsonToken;
        JArray: JsonArray;
        JItem: JsonToken;
        JValue: JsonValue;
        NoOfRecs: Integer;
        CurrRec: Integer;
        CLETwikeyRegistration: Record "SCA.TWI.CLETwikeyRegistration";
        EntryNo: Integer;
    begin
        if GuiAllowed then begin
            Window.Open('Processing data... @1@@@@@@@@@@');
        end;

        BuildCreateCustLedgerEntryRequest(JRequest, CustLedgerEntry);
        if BasicAuthKey = '' then begin
            GetBasicAuthKey();
        end;

        WebRequestMgt.SetBasicAuthkey(BasicAuthKey);
        JResponse := WebRequestMgt.ExecuteWebRequest(GetBaseURL() + 'creditor/invoice', 'POST', JRequest);

        CLETwikeyRegistration.SetRange("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
        if CLETwikeyRegistration.FindFirst() then begin
            if JHelper.GetJsonValue(JResponse, JValue, 'id') then begin
                CLETwikeyRegistration."Twikey Invoice Id" := JValue.AsText();
            end;
            if JHelper.GetJsonValue(JResponse, JValue, 'state') then begin
                CLETwikeyRegistration."Invoice Status" := JValue.AsText();
            end;
            if JHelper.GetJsonValue(JResponse, JValue, 'url') then begin
                CLETwikeyRegistration."Invoice Payment URL" := JValue.AsText();
            end;
            CLETwikeyRegistration.Modify();
        end else begin
            CLETwikeyRegistration.Reset();
            if CLETwikeyRegistration.FindLast() then begin
                EntryNo := CLETwikeyRegistration."Entry No.";
            end;
            EntryNo += 1;
            CLETwikeyRegistration.Init();
            CLETwikeyRegistration."Entry No." := EntryNo;
            CLETwikeyRegistration."Cust. Ledger Entry Doc. No." := CustLedgerEntry."Document No.";
            CLETwikeyRegistration."Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
            if JHelper.GetJsonValue(JResponse, JValue, 'id') then begin
                CLETwikeyRegistration."Twikey Invoice Id" := JValue.AsText();
            end;
            if JHelper.GetJsonValue(JResponse, JValue, 'state') then begin
                CLETwikeyRegistration."Invoice Status" := JValue.AsText();
            end;
            if JHelper.GetJsonValue(JResponse, JValue, 'url') then begin
                CLETwikeyRegistration."Invoice Payment URL" := JValue.AsText();
            end;
            CLETwikeyRegistration.Insert();
        end;

        if GuiAllowed then begin
            Window.Close();
        end;
    end;

    local procedure BuildCreateCustLedgerEntryRequest(var JRequest: JsonToken; CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        InvoiceObj: JsonObject;
        CustObj: JsonObject;
        Customer: Record Customer;
        VatRegistrationNo: Text;
    begin
        if not Customer.Get(CustLedgerEntry."Customer No.") then
            Customer.Init();
        CustLedgerEntry.CalcFields("Amount");

        InvoiceObj.Add('number', CustLedgerEntry."Document No.");
        InvoiceObj.Add('title', CustLedgerEntry."Document No.");
        InvoiceObj.Add('remittance', CustLedgerEntry."Document No.");
        // if SalesInvoiceHeader."SCA.TWI.TwikeyContractTemplate" <> 0 then begin
        //     InvoiceObj.Add('ct', SalesInvoiceHeader."SCA.TWI.TwikeyContractTemplate");
        // end;
        InvoiceObj.Add('amount', format(CustLedgerEntry."Amount", 0, 9));
        InvoiceObj.Add('date', CustLedgerEntry."Posting Date");
        InvoiceObj.Add('duedate', CustLedgerEntry."Due Date");
        InvoiceObj.Add('locale', Customer."Language Code");

        CustObj.Add('customerNumber', Customer."No.");
        CustObj.Add('email', Customer."E-Mail");
        CustObj.Add('companyName', Customer.Name);
        if Customer.Contact <> '' then begin
            CustObj.Add('firstname', Customer.Contact);
        end else begin
            CustObj.Add('firstname', Customer.Name);
        end;
        CustObj.Add('lastname', '-');
        CustObj.Add('mobile', Customer."Mobile Phone No.");
        CustObj.Add('address', Customer.Address);
        CustObj.Add('zip', Customer."Post Code");
        CustObj.Add('city', Customer.City);
        CustObj.Add('country', Customer."Country/Region Code");
        CustObj.Add('l', Customer."Language Code");
        VatRegistrationNo := GetCustomerVatRegistrationNo(Customer);
        if VatRegistrationNo <> '' then begin
            CustObj.Add('vatno', VatRegistrationNo);
        end;

        InvoiceObj.Add('customer', CustObj.AsToken());

        //InvoiceObj.Add('pdf', '');

        JRequest := InvoiceObj.AsToken();
    end;



    // local procedure BuildPaymentLinkRequest(var JRequest: JsonToken; SalesInvoiceHeader: Record "Sales Invoice Header")
    // var
    //     PaymentObj: JsonObject;
    //     CustObj: JsonObject;
    //     Customer: Record Customer;
    // begin
    //     SalesInvoiceHeader.CalcFields("Amount Including VAT");

    //     PaymentObj.Add('email', 'gijs.franssens@scapta.com');
    //     PaymentObj.Add('message', SalesInvoiceHeader."Your Reference");
    //     PaymentObj.Add('amount', SalesInvoiceHeader."Amount Including VAT");

    //     JRequest := PaymentObj.AsToken();
    // end;


    procedure InvoiceFeed()
    var
        JsonMgt: Codeunit "JSON Management";
        JResponse: JsonToken;
        JRequest: JsonToken;
        JArray: JsonArray;
        JItem: JsonToken;
        JValue: JsonValue;
        NoOfRecs: Integer;
        CurrRec: Integer;
        TwikeyLink: Record "SCA.TWI.TwikeyRegistration";
        CLETwikeyRegistration: Record "SCA.TWI.CLETwikeyRegistration";
        EntryNo: Integer;
    begin
        if IsTwikeyEnabled() then begin
            if GuiAllowed then begin
                Window.Open('Processing data... @1@@@@@@@@@@');
            end;

            if BasicAuthKey = '' then begin
                GetBasicAuthKey();
            end;

            WebRequestMgt.SetBasicAuthkey(BasicAuthKey);
            JResponse := WebRequestMgt.ExecuteWebRequest(GetBaseURL() + 'creditor/invoice', 'GET', JRequest);
            if JHelper.GetJsonArray(JResponse, JArray, 'Invoices') then begin
                foreach JItem in JArray do begin
                    if JHelper.GetJsonValue(JItem.AsObject(), JValue, 'id') then begin
                        TwikeyLink.SetRange("Twikey Invoice Id", JValue.AsText());
                        if TwikeyLink.FindFirst() then begin
                            if JHelper.GetJsonValue(JItem.AsObject(), JValue, 'state') then begin
                                TwikeyLink."Invoice Status" := JValue.AsText();
                                TwikeyLink.Modify();
                            end;
                        end else begin
                            CLETwikeyRegistration.SetRange("Twikey Invoice Id", JValue.AsText());
                            if CLETwikeyRegistration.FindFirst() then begin
                                if JHelper.GetJsonValue(JItem.AsObject(), JValue, 'state') then begin
                                    CLETwikeyRegistration."Invoice Status" := JValue.AsText();
                                    CLETwikeyRegistration.Modify();
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            if GuiAllowed then begin
                Window.Close();
            end;
        end;
    end;

    // procedure CreatePaymentLinkForInvoice(SalesInvoiceHeader: Record "Sales Invoice Header")
    // var
    //     JsonMgt: Codeunit "JSON Management";
    //     JResponse: JsonToken;
    //     JRequest: JsonToken;
    //     JArray: JsonArray;
    //     JItem: JsonToken;
    //     JValue: JsonValue;
    //     NoOfRecs: Integer;
    //     CurrRec: Integer;
    //     TwikeyRegistration: Record "SCA.TWI.TwikeyRegistration";
    //     EntryNo: Integer;
    //     Request: HttpRequestMessage;
    //     Headers: HttpHeaders;
    //     Content: Text;
    //     HttpContent: HttpContent;
    //     Client: HttpClient;
    //     Response: HttpResponseMessage;
    //     Url: Text;
    // begin
    //     if IsTwikeyEnabled() then begin
    //         if GuiAllowed then begin
    //             Window.Open('Processing data... @1@@@@@@@@@@');
    //         end;

    //         Url := GetBaseURL() + 'creditor/payment/link';
    //         Request.SetRequestUri(Url);
    //         Request.Method := 'POST';

    //         Request.GetHeaders(Headers);
    //         if BasicAuthKey = '' then begin
    //             BasicAuthKey := GetBasicAuthKey();
    //         end;

    //         if Headers.Contains('Authorization') then begin
    //             Headers.Remove('Authorization');
    //         end;
    //         Headers.Add('Authorization', BasicAuthKey);

    //         Content := 'email=' + 'gijs.franssens@scapta.com';
    //         Content += '&message=' + SalesInvoiceHeader."No.";
    //         SalesInvoiceHeader.CalcFields("Amount Including VAT");
    //         Content += '&amount=' + format(SalesInvoiceHeader."Amount Including VAT", 0, 9);

    //         HttpContent.WriteFrom(Content);
    //         HttpContent.GetHeaders(Headers);

    //         if Headers.Contains('Content-Type') then begin
    //             Headers.Remove('Content-Type');
    //         end;
    //         Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

    //         Request.Content := HttpContent;

    //         if Client.Send(Request, Response) then begin
    //             Response.Content.ReadAs(Content);
    //             if JResponse.ReadFrom(Content) then begin
    //                 TwikeyRegistration.SetRange("Posted Sales Invoice No.", SalesInvoiceHeader."No.");
    //                 if TwikeyRegistration.FindFirst() then begin
    //                     if JHelper.GetJsonValue(JResponse, JValue, 'id') then begin
    //                         TwikeyRegistration."Payment Link Id" := JValue.AsInteger();
    //                     end;
    //                     if JHelper.GetJsonValue(JResponse, JValue, 'url') then begin
    //                         TwikeyRegistration."Payment Link URL" := JValue.AsText();
    //                     end;
    //                     TwikeyRegistration."Payment Status" := 'Created';
    //                     TwikeyRegistration.Modify();
    //                 end else begin
    //                     TwikeyRegistration.Reset();
    //                     if TwikeyRegistration.FindLast() then begin
    //                         EntryNo := TwikeyRegistration."Entry No.";
    //                     end;
    //                     EntryNo += 1;
    //                     TwikeyRegistration.Init();
    //                     TwikeyRegistration."Entry No." := EntryNo;
    //                     TwikeyRegistration."Posted Sales Invoice No." := SalesInvoiceHeader."No.";
    //                     if JHelper.GetJsonValue(JResponse, JValue, 'id') then begin
    //                         TwikeyRegistration."Payment Link Id" := JValue.AsInteger();
    //                     end;
    //                     if JHelper.GetJsonValue(JResponse, JValue, 'url') then begin
    //                         TwikeyRegistration."Payment Link URL" := JValue.AsText();
    //                     end;
    //                     TwikeyRegistration."Payment Status" := 'Created';
    //                     TwikeyRegistration.Insert();
    //                 end;
    //             end;
    //         end;
    //         WebRequestMgt.CreateLogEntry(Url, Request.Method, format(Request.Content), Response, '');
    //         if GuiAllowed then begin
    //             Window.Close();
    //         end;
    //     end;
    // end;

    // procedure PaymentLinkFeed()
    // var
    //     JsonMgt: Codeunit "JSON Management";
    //     JResponse: JsonToken;
    //     JRequest: JsonToken;
    //     JArray: JsonArray;
    //     JItem: JsonToken;
    //     JValue: JsonValue;
    //     NoOfRecs: Integer;
    //     CurrRec: Integer;
    //     TwikeyLink: Record "SCA.TWI.TwikeyRegistration";
    //     EntryNo: Integer;
    // begin
    //     if IsTwikeyEnabled() then begin
    //         if GuiAllowed then begin
    //             Window.Open('Processing data... @1@@@@@@@@@@');
    //         end;

    //         if BasicAuthKey = '' then begin
    //             GetBasicAuthKey();
    //         end;
    //         WebRequestMgt.SetBasicAuthkey(BasicAuthKey);
    //         JResponse := WebRequestMgt.ExecuteWebRequest(GetBaseURL() + 'creditor/payment/link/feed', 'GET', JRequest);
    //         if JHelper.GetJsonArray(JResponse, JArray, 'Links') then begin
    //             foreach JItem in JArray do begin
    //                 if JHelper.GetJsonValue(JItem, JValue, 'id') then begin
    //                     TwikeyLink.SetRange("Payment Link Id", JValue.AsInteger());
    //                     if TwikeyLink.FindFirst() then begin
    //                         if JHelper.GetJsonValue(JItem, JValue, 'state') then begin
    //                             TwikeyLink."Payment Status" := JValue.AsText();
    //                             TwikeyLink.Modify();
    //                         end;
    //                     end;
    //                 end;
    //             end;
    //         end;

    //         if GuiAllowed then begin
    //             Window.Close();
    //         end;

    //     end;
    // end;



    local procedure IsTwikeyEnabled(): Boolean
    var
    begin
        if TwikeySetup.Get() then begin
            if TwikeySetup."Enable Twikey Integration" then begin
                TwikeySetup.TestField("Environment URL");
                TwikeySetup.TestField("API Key");
                exit(true);
            end;
        end;
        exit(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSendPostedDocumentRecord', '', false, false)]
    local procedure SendInvoiceToTwikey(var SalesHeader: Record "Sales Header")
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        if IsTwikeyEnabled() then begin
            case SalesHeader."Document Type" of
                SalesHeader."Document Type"::Order:
                    begin
                        if SalesHeader.Invoice then begin
                            SalesInvHeader.Get(SalesHeader."Last Posting No.");
                            SendPostedSalesInvoiceToTwikey(SalesInvHeader, false);
                        end;
                    end;
                SalesHeader."Document Type"::Invoice:
                    begin
                        if SalesHeader."Last Posting No." = '' then begin
                            SalesInvHeader.Get(SalesHeader."No.");
                        end else begin
                            SalesInvHeader.Get(SalesHeader."Last Posting No.");
                        end;
                        SendPostedSalesInvoiceToTwikey(SalesInvHeader, false);
                    end;
            end;
        end;
    end;

    procedure SendPostedSalesInvoiceToTwikey(SalesInvHeader: Record "Sales Invoice Header"; ShowNotification: Boolean)
    var
        Customer: Record Customer;
        Label1: Label 'Do you want to send this invoice to Twikey?';
        Label2: Label 'Invoice %1 has succesfully been sent to Twikey.';
    begin
        Customer.Get(SalesInvHeader."Bill-to Customer No.");
        case Customer."SCA.TWI.SendingProfile" of
            Customer."SCA.TWI.SendingProfile"::Disable:
                begin
                    exit;
                end;
            Customer."SCA.TWI.SendingProfile"::Always:
                begin
                    CreateInvoice(SalesInvHeader);
                    Commit();
                end;
            Customer."SCA.TWI.SendingProfile"::Optional:
                begin
                    if Confirm(Label1) then begin
                        CreateInvoice(SalesInvHeader);
                        Commit();
                    end;
                end;
        end;
        if ShowNotification then begin
            Message(Strsubstno(Label2, SalesInvHeader."No."));
        end;
    end;

    procedure SendCustLedgerEntriesToTwikeyConfirm(var CustLedgerEntry: Record "Cust. Ledger Entry"; ShowNotification: Boolean)
    var
        Customer: Record Customer;
        Label1: Label 'Do you want to send these documents to Twikey?';
        Label2: Label 'The documents have been succesfully sent to Twikey.';
    begin
        if IsTwikeyEnabled() then begin
            if Confirm(Label1) then begin
                SendCustLedgerEntriesToTwikey(CustLedgerEntry, ShowNotification);
            end;
        end else begin
            Error(TwikeySetupErr);
        end;
    end;


    procedure SendCustLedgerEntriesToTwikey(var CustLedgerEntry: Record "Cust. Ledger Entry"; ShowNotification: Boolean)
    var
        Customer: Record Customer;
        Label1: Label 'Do you want to send these documents to Twikey?';
        Label2: Label 'The documents have been succesfully sent to Twikey.';
    begin
        if IsTwikeyEnabled() then begin
            if CustLedgerEntry.FindSet() then begin
                repeat
                    Customer.Get(CustLedgerEntry."Customer No.");

                    case Customer."SCA.TWI.SendingProfile" of
                        Customer."SCA.TWI.SendingProfile"::Optional,
                        Customer."SCA.TWI.SendingProfile"::Always:
                            begin
                                CreateCustLedgerEntry(CustLedgerEntry);
                                Commit();
                            end;
                    end;
                until CustLedgerEntry.Next() = 0;
            end;
            if ShowNotification then begin
                Message(Label2);
            end;
        end else begin
            Error(TwikeySetupErr);
        end;
    end;

    // procedure GetInvoicePaymentUrlQRCode(SalesInvHeader: Record "Sales Invoice Header"; var Barcode: Record "SCA.TWI.Barcode")
    // var
    //     BarcodeMgt: Codeunit "SCA.TWI.BarcodeMgt";
    // begin
    //     Barcode.Init();
    //     Barcode.
    // end;

    procedure SendPostedSalesInvoicesToTwikey(var SalesInvHeader: Record "Sales Invoice Header"; ShowNotification: Boolean)
    var
        Customer: Record Customer;
        Label2: Label 'The sales invoices have been succesfully sent to Twikey.';
    begin
        if SalesInvHeader.FindSet() then begin
            repeat
                Customer.Get(SalesInvHeader."Bill-to Customer No.");
                case Customer."SCA.TWI.SendingProfile" of
                    Customer."SCA.TWI.SendingProfile"::Always:
                        begin
                            CreateInvoice(SalesInvHeader);
                            Commit();
                        end;
                    Customer."SCA.TWI.SendingProfile"::Optional:
                        begin
                            CreateInvoice(SalesInvHeader);
                            Commit();
                        end;
                end;
            until SalesInvHeader.Next() = 0;
        end;
        if ShowNotification then begin
            Message(Label2);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterModifyEvent', '', true, false)]
    local procedure CustomerOnAfterModify(var Rec: Record Customer; var xRec: Record Customer)
    begin
        if IsCustomerUpdated(Rec, xRec) then begin
            UpdateCustomer(Rec, xRec);
        end;
    end;

    local procedure IsCustomerUpdated(Customer: Record Customer; xCustomer: Record Customer): Boolean
    var
        TwikeyDocument: Record "SCA.TWI.TwikeyDocument";
    begin
        TwikeyDocument.SetRange("Customer No.", Customer."No.");
        if not TwikeyDocument.IsEmpty then begin
            if Customer.Name <> xCustomer.Name then
                exit(true);
            if Customer.Address <> xCustomer.Address then
                exit(true);
            if Customer.City <> xCustomer.City then
                exit(true);
            if Customer."Post Code" <> xCustomer."Post Code" then
                exit(true);
            if Customer."Country/Region Code" <> xCustomer."Country/Region Code" then
                exit(true);
            if Customer."Language Code" <> xCustomer."Language Code" then
                exit(true);
            if Customer."E-Mail" <> xCustomer."E-Mail" then
                exit(true);
            if Customer."Mobile Phone No." <> xCustomer."Mobile Phone No." then
                exit(true);
            if Customer."No." <> xCustomer."No." then
                exit(true);
            if Customer.Contact <> xCustomer.Contact then
                exit(true);
            if GetCustomerVatRegistrationNo(Customer) <> GetCustomerVatRegistrationNo(xCustomer) then
                exit(true);
            if Customer."VAT Registration No." <> xCustomer."VAT Registration No." then
                exit(true);
        end;
    end;

    procedure UpdateCustomer(Customer: Record Customer; xCustomer: Record Customer)
    var
        JsonMgt: Codeunit "JSON Management";
        JResponse: JsonToken;
        JRequest: JsonToken;
        CustObj: JsonObject;
        JValue: JsonValue;
        Content: Text;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpContent: HttpContent;
        Headers: HttpHeaders;
        Client: HttpClient;
        Url: Text;
        VatRegistrationNo: Text;
        ResponseContent: Text;

    begin
        if IsTwikeyEnabled() then begin
            if GuiAllowed then begin
                Window.Open('Processing data... @1@@@@@@@@@@');
            end;

            Content := 'customerNumber=' + Customer."No.";
            Content += '&email=' + Customer."E-Mail";
            Content += '&companyName=' + Customer.Name;
            Content += '&lastname=' + '-';
            if Customer.Contact <> '' then begin
                Content += '&firstname=' + Customer.Contact;
            end else begin
                Content += '&firstname=' + Customer.Name;
            end;
            Content += '&mobile=' + Customer."Mobile Phone No.";
            Content += '&address=' + Customer.Address;
            Content += '&zip=' + Customer."Post Code";
            Content += '&city=' + Customer.City;
            Content += '&country=' + Customer."Country/Region Code";
            Content += '&l=' + Customer."Language Code";

            VatRegistrationNo := GetCustomerVatRegistrationNo(Customer);
            if VatRegistrationNo <> '' then begin
                Content += '&coc=' + VatRegistrationNo;
            end;

            Url := GetBaseURL();
            Url += 'creditor/customer/' + xCustomer."No." + '?' + Content;
            Request.SetRequestUri(Url);
            Request.Method := 'PATCH';

            Request.GetHeaders(Headers);
            if BasicAuthKey = '' then begin
                BasicAuthKey := GetBasicAuthKey();
            end;

            if Headers.Contains('Authorization') then begin
                Headers.Remove('Authorization');
            end;
            Headers.Add('Authorization', BasicAuthKey);

            Request.SetRequestUri(Url);

            HttpContent.WriteFrom('');
            HttpContent.GetHeaders(Headers);

            if Headers.Contains('Content-Type') then begin
                Headers.Remove('Content-Type');
            end;
            Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

            Request.Content := HttpContent;

            if Client.Send(Request, Response) then begin
                Response.Content.ReadAs(ResponseContent);
            end;
            WebRequestMgt.CreateLogEntry(Url, Request.Method, '', Response, '');

            if Response.HttpStatusCode = 400 then begin
                UpdateCustomerWithoutCompanyNameAndCOC(Customer, xCustomer);
            end;

            if GuiAllowed then begin
                Window.Close();
            end;
        end;
    end;

    procedure UpdateCustomerWithoutCompanyNameAndCOC(Customer: Record Customer; xCustomer: Record Customer)
    var
        JsonMgt: Codeunit "JSON Management";
        JResponse: JsonToken;
        JRequest: JsonToken;
        CustObj: JsonObject;
        JValue: JsonValue;
        Content: Text;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpContent: HttpContent;
        Headers: HttpHeaders;
        Client: HttpClient;
        Url: Text;
        VatRegistrationNo: Text;
        ResponseContent: Text;

    begin
        if IsTwikeyEnabled() then begin
            Content := 'customerNumber=' + Customer."No.";
            Content += '&email=' + Customer."E-Mail";
            Content += '&lastname=' + '-';
            if Customer.Contact <> '' then begin
                Content += '&firstname=' + Customer.Contact;
            end else begin
                Content += '&firstname=' + Customer.Name;
            end;
            Content += '&mobile=' + Customer."Mobile Phone No.";
            Content += '&address=' + Customer.Address;
            Content += '&zip=' + Customer."Post Code";
            Content += '&city=' + Customer.City;
            Content += '&country=' + Customer."Country/Region Code";
            Content += '&l=' + Customer."Language Code";

            Url := GetBaseURL();
            Url += 'creditor/customer/' + xCustomer."No." + '?' + Content;
            Request.SetRequestUri(Url);
            Request.Method := 'PATCH';

            Request.GetHeaders(Headers);
            if BasicAuthKey = '' then begin
                BasicAuthKey := GetBasicAuthKey();
            end;

            if Headers.Contains('Authorization') then begin
                Headers.Remove('Authorization');
            end;
            Headers.Add('Authorization', BasicAuthKey);

            Request.SetRequestUri(Url);

            HttpContent.WriteFrom('');
            HttpContent.GetHeaders(Headers);

            if Headers.Contains('Content-Type') then begin
                Headers.Remove('Content-Type');
            end;
            Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

            Request.Content := HttpContent;

            if Client.Send(Request, Response) then begin
                Response.Content.ReadAs(ResponseContent);
            end;
            WebRequestMgt.CreateLogEntry(Url, Request.Method, '', Response, '');
        end;
    end;


    var
        NextExecutionTime: DateTime;
        BasicAuthKey: Text;
        TwikeySetup: Record "SCA.TWI.TwikeySetup";
        WebRequestMgt: Codeunit "SCA.TWI.CommunicationMgt";
        JHelper: Codeunit "SCA.TWI.JsonHelper";
        Window: Dialog;
        TwikeySetupErr: Label 'Twikey has not been set up correctly';


}