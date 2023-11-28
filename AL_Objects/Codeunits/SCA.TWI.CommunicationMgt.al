codeunit 71016576 "SCA.TWI.CommunicationMgt"
{
    /// <summary> 
    /// Execute WebRequest.
    /// </summary>
    /// <param name="Url">Parameter of type Text.</param>
    /// <param name="Method">Parameter of type Text.</param>
    /// <param name="JRequest">Parameter of type JsonToken.</param>
    /// <returns>Return value of type JsonToken.</returns>
    procedure ExecuteWebRequest(Url: Text; Method: Text; JRequest: JsonToken): JsonToken
    var
        ResponseHeaders: HttpHeaders;
    begin
        exit(ExecuteWebRequest(Url, Method, JRequest, ResponseHeaders));
    end;

    /// <summary> 
    /// Execute Web Request.
    /// </summary>
    /// <param name="Url">Parameter of type Text.</param>
    /// <param name="Method">Parameter of type Text.</param>
    /// <param name="JRequest">Parameter of type JsonToken.</param>
    /// <param name="nextPageUrl">Parameter of type Text.</param>
    /// <returns>Return variable "JResponse" of type JsonToken.</returns>
    procedure ExecuteWebRequest(Url: Text; Method: Text; JRequest: JsonToken; var nextPageUrl: Text) JResponse: JsonToken
    var
        ResponseHeaders: HttpHeaders;
        LinkInfo: List of [Text];
        Links: array[1] of Text;
    begin
        JResponse := ExecuteWebRequest(Url, Method, JRequest, ResponseHeaders);
        Clear(nextPageUrl);
        if ResponseHeaders.Contains('Link') then begin
            if ResponseHeaders.GetValues('Link', Links) then begin
                if Links[1] <> '' then begin
                    LinkInfo := Links[1].Split(', ');
                    LinkInfo := LinkInfo.Get(LinkInfo.Count).Split('; ');
                    if LinkInfo.Get(2) = 'rel="next"' then begin
                        nextPageUrl := CopyStr(LinkInfo.Get(1), 2, StrLen(LinkInfo.Get(1)) - 2);
                    end;
                end;
            end;
        end;
    end;

    /// <summary> 
    /// Execute Web Request.
    /// </summary>
    /// <param name="Url">Parameter of type Text.</param>
    /// <param name="Method">Parameter of type Text.</param>
    /// <param name="JRequest">Parameter of type JsonToken.</param>
    /// <param name="ResponseHeaders">Parameter of type HttpHeaders.</param>
    /// <returns>Return variable "JResponse" of type JsonToken.</returns>
    procedure ExecuteWebRequest(Url: Text; Method: Text; JRequest: JsonToken; var ResponseHeaders: HttpHeaders) JResponse: JsonToken
    var
        Request: Text;
    begin
        JRequest.WriteTo(Request);
        if JResponse.ReadFrom(ExecuteWebRequest(Url, Method, Request, ResponseHeaders)) then;
    end;

    /// <summary> 
    /// Execute Web Request.
    /// </summary>
    /// <param name="Url">Parameter of type Text.</param>
    /// <param name="Method">Parameter of type Text.</param>
    /// <param name="Request">Parameter of type Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure ExecuteWebRequest(Url: Text; Method: Text; Request: Text): Text
    var
        ResponseHeaders: HttpHeaders;
    begin
        exit(ExecuteWebRequest(Url, Method, Request, ResponseHeaders));
    end;

    procedure SetBasicAuthkey(BasicAuthKey2: Text)
    begin
        BasicAuthKey := BasicAuthKey2;
    end;

    /// <summary> 
    /// Execute Web Request.
    /// </summary>
    /// <param name="Url">Parameter of type Text.</param>
    /// <param name="Method">Parameter of type Text.</param>
    /// <param name="Request">Parameter of type Text.</param>
    /// <param name="ResponseHeaders">Parameter of type HttpHeaders.</param>
    /// <returns>Return variable "Response" of type Text.</returns>
    procedure ExecuteWebRequest(Url: Text; Method: Text; Request: Text; var ResponseHeaders: HttpHeaders) Response: Text
    var
        Client: HttpClient;
        HttpRequestMsg: HttpRequestMessage;
        HttpResponseMsg: HttpResponseMessage;
        Status: Integer;
        RetryCounter: Integer;
        Wait: Duration;
    begin
        CreateHttpRequestMessage(Url, Method, Request, HttpRequestMsg);

        Wait := 100;

        if Format(NextExecutionTime) = '' then
            NextExecutionTime := CurrentDateTime - Wait;

        if CurrentDateTime < (NextExecutionTime) then begin
            Wait := (NextExecutionTime - CurrentDateTime);
            if Wait > 0 then begin
                Sleep(Wait);
            end;
        end;

        if Client.Send(HttpRequestMsg, HttpResponseMsg) then begin
            Clear(RetryCounter);
            // while (EvaluateResponse(HttpResponseMsg)) and (RetryCounter < 5) do begin
            //     CreateLogEntry(Url, Method, Request, HttpResponseMsg, Response);
            //     Clear(Client);
            //     Clear(HttpRequestMsg);
            //     Clear(HttpResponseMsg);
            //     CreateHttpRequestMessage(Url, Method, Request, HttpRequestMsg);
            //     Client.Send(HttpRequestMsg, HttpResponseMsg);
            // end;

            HttpResponseMsg.Content.ReadAs(Response);
            ResponseHeaders := HttpResponseMsg.Headers();
            CreateLogEntry(Url, Method, Request, HttpResponseMsg, Response);
        end else begin
            CreateLogEntry(Url, Method, Request, HttpResponseMsg, Response);
        end;
        Commit();
    end;

    /// <summary> 
    /// Evaluate Response.
    /// </summary>
    /// <param name="HttpResponseMsg">Parameter of type HttpResponseMessage.</param>
    /// <returns>Return variable "Retry" of type Boolean.</returns>
    local procedure EvaluateResponse(HttpResponseMsg: HttpResponseMessage) Retry: Boolean
    var
        BucketPerc: Decimal;
        WaitTime: Duration;
        BucketSize: Integer;
        BucketUse: Integer;
        Status: Integer;
        Values: array[10] of Text;
    begin
        Status := HttpResponseMsg.HttpStatusCode();
        case Status of
            429:
                begin
                    Sleep(2000);
                    Retry := true;
                end;
            500 .. 599:
                begin
                    Sleep(10000);
                    Retry := true;
                end;
            else
                if HttpResponseMsg.Headers().GetValues('X-Shopify-Shop-Api-Call-Limit', Values) then begin
                    if Evaluate(BucketUse, Values[1].Split('/').Get(1)) and Evaluate(BucketSize, Values[1].Split('/').Get(2)) then begin
                        BucketPerc := 100 * BucketUse / BucketSize;
                        if BucketPerc >= 90 then
                            WaitTime := 1000
                        else
                            if BucketPerc >= 80 then
                                WaitTime := 800
                            else
                                if BucketPerc >= 70 then
                                    WaitTime := 600
                                else
                                    if BucketPerc >= 60 then
                                        WaitTime := 400
                                    else
                                        if BucketPerc >= 50 then
                                            WaitTime := 200;
                        // if WaitTime > 0 then begin
                        //     Sleep(WaitTime);
                        // end;
                    end;
                end;
                NextExecutionTime := CurrentDateTime() + WaitTime;
        end;
    end;


    /// <summary> 
    /// Create Http Request Message.
    /// </summary>
    /// <param name="Url">Parameter of type text.</param>
    /// <param name="Method">Parameter of type Text.</param>
    /// <param name="Request">Parameter of type Text.</param>
    /// <param name="HttpRequestMsg">Parameter of type HttpRequestMessage.</param>
    local procedure CreateHttpRequestMessage(Url: text; Method: Text; Request: Text; var HttpRequestMsg: HttpRequestMessage)
    var
        Convert: Codeunit "Base64 Convert";
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        Headers: HttpHeaders;
        AuthText: Text;
        EnvironmentInformation: Codeunit "Environment Information";
    begin
        HttpRequestMsg.SetRequestUri(url);
        //HttpRequestMsg.SetRequestUri('https://gijsfranssens.free.beeceptor.com');
        HttpRequestMsg.GetHeaders(Headers);

        Headers.Add('Authorization', BasicAuthKey);

        Headers.Add('User-Agent', 'BusCentr/' + CompanyName);

        HttpRequestMsg.Method := Method;

        if Method in ['POST', 'PUT'] then begin
            Content.WriteFrom(Request);
            Content.GetHeaders(ContentHeaders);
            if ContentHeaders.Contains('Content-Type') then begin
                ContentHeaders.Remove('Content-Type');
            end;
            ContentHeaders.Add('Content-Type', 'application/json');
            HttpRequestMsg.Content(Content);
        end;
    end;

    procedure CreateLogEntry(Url: text; Method: text; Request: Text; var HttpResponseMessage: HttpResponseMessage; Response: text)
    var
        LogEntry: Record "SCA.TWI.TwikeyLogEntry";
        OutStr: OutStream;
        TwikeySetup: Record "SCA.TWI.TwikeySetup";
    begin
        TwikeySetup.Get();
        if TwikeySetup."Enable Log" then begin
            LogEntry.Init;
            LogEntry."Date and Time" := CurrentDateTime;
            LogEntry.Time := TIME;
            LogEntry."User ID" := UserId;
            LogEntry.URL := Url;
            LogEntry.Method := Method;
            if Request <> '' then begin
                LogEntry.SetRequest(Request);
            end;
            if Response <> '' then begin
                LogEntry.SetResponse(Response);
            end;
            LogEntry."Status Code" := CopyStr(Format(HttpResponseMessage.HttpStatusCode), 1, MaxStrLen(LogEntry."Status Code"));
            LogEntry."Status Description" := CopyStr(HttpResponseMessage.ReasonPhrase, 1, MaxStrLen(LogEntry."Status Description"));
            LogEntry.Insert;
        end;
    end;



    var
        NextExecutionTime: DateTime;
        BasicAuthKey: Text;
        JHelper: codeunit "SCA.TWI.JsonHelper";
        TwikeySetup: Record "SCA.TWI.TwikeySetup";
}