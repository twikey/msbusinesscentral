codeunit 71016580 "SCA.TWI.JsonHelper"
{
    SingleInstance = true;

    /// <summary> 
    /// Get Json Array.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="JResult">Parameter of type JsonArray.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure GetJsonArray(JToken: JsonToken; var JResult: JsonArray; KeyName: Text): Boolean
    var
        KeyNames: List of [Text];
    begin
        if JToken.IsValue then
            exit(false);

        Clear(JResult);
        if JToken.IsArray and (KeyName = '') then begin
            JResult := JToken.AsArray();
            exit(true);
        end;

        KeyNames := KeyName.Split('.');
        foreach KeyName in KeyNames do begin
            if JToken.AsObject().Get(KeyName, JToken) then begin
                if KeyNames.IndexOf(KeyName) = KeyNames.Count then begin
                    if JToken.IsArray then begin
                        JResult := JToken.AsArray();
                        exit(true);
                    end;
                end;
            end;
        end;
    end;

    /// <summary> 
    /// Get Json Array.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="JResult">Parameter of type JsonArray.</param>
    /// <param name="KeyName">Parameter of type text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure GetJsonArray(JObject: JsonObject; var JResult: JsonArray; KeyName: text): Boolean
    var
        JToken: JsonToken;
    begin
        exit(GetJsonArray(JObject.AsToken(), JResult, KeyName));
    end;

    /// <summary> 
    /// Get Json Object.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="JResult">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure GetJsonObject(JToken: JsonToken; var JResult: JsonObject; KeyName: Text): Boolean
    var
        KeyNames: List of [Text];
    begin
        Clear(JResult);
        if JToken.IsObject and (KeyName = '') then begin
            JResult := JToken.AsObject();
            exit(true);
        end;

        KeyNames := KeyName.Split('.');
        foreach KeyName in KeyNames do begin
            if JToken.AsObject().Get(KeyName, JToken) then begin
                if KeyNames.IndexOf(KeyName) = KeyNames.Count then begin
                    if JToken.IsObject then begin
                        JResult := JToken.AsObject();
                        exit(true);
                    end;
                end;
            end;
        end;
    end;

    /// <summary> 
    /// Get Json Object.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="JResult">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure GetJsonObject(JObject: JsonObject; var JResult: JsonObject; KeyName: text): Boolean
    begin
        exit(GetJsonObject(JObject.AsToken(), JResult, KeyName));
    end;

    /// <summary> 
    /// Get Json Token.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type JsonToken.</returns>
    procedure GetJsonToken(JToken: JsonToken; KeyName: Text): JsonToken
    var
        KeyNames: List of [Text];
    begin
        KeyNames := KeyName.Split('.');
        foreach KeyName in KeyNames do begin
            if JToken.AsObject().Get(KeyName, JToken) then begin
                if KeyNames.IndexOf(KeyName) = KeyNames.Count then begin
                    exit(JToken);
                end;
            end;
        end;
    end;

    /// <summary> 
    /// Get Json Value.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="JResult">Parameter of type JsonValue.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure GetJsonValue(JToken: JsonToken; var JResult: JsonValue; KeyName: Text): Boolean
    var
        KeyNames: List of [Text];
    begin
        Clear(JResult);
        if JToken.IsValue then begin
            if (KeyName = '') then begin
                JResult := JToken.AsValue();
                exit(true);
            end;
            exit(false);
        end;

        KeyNames := KeyName.Split('.');
        foreach KeyName in KeyNames do begin
            if JToken.IsObject then begin
                if JToken.AsObject().Get(KeyName, JToken) then begin
                    if KeyNames.IndexOf(KeyName) = KeyNames.Count then begin
                        if JToken.IsValue then begin
                            JResult := JToken.AsValue();
                            exit(not (JResult.IsNull or JResult.IsUndefined));
                        end;
                    end;
                end;
            end else begin
                if KeyNames.IndexOf(KeyName) = KeyNames.Count then begin
                    if JToken.IsValue then begin
                        JResult := JToken.AsValue();
                        exit(not (JResult.IsNull or JResult.IsUndefined));
                    end;
                end;
            end;
        end;
    end;

    /// <summary> 
    /// Get Json Value.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="JResult">Parameter of type JsonValue.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure GetJsonValue(JObject: JsonObject; var JResult: JsonValue; KeyName: Text): Boolean
    var
        JToken: JsonToken;
    begin
        exit(GetJsonValue(JObject.AsToken(), JResult, KeyName));
    end;

    /// <summary> 
    /// Get Value As Big Integer.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type BigInteger.</returns>
    procedure GetValueAsBigInteger(JToken: JsonToken; KeyName: Text): BigInteger
    var
        JValue: JsonValue;
    begin
        if JToken.IsObject then begin
            exit(GetValueAsBigInteger(JToken.AsObject(), KeyName));
        end else
            if JToken.IsValue then begin
                JValue := JToken.AsValue();
                if not (JValue.IsNull or JValue.IsUndefined) then
                    exit(JValue.AsBigInteger());
            end;
    end;

    /// <summary> 
    /// Get Value As Big Integer.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type BigInteger.</returns>
    procedure GetValueAsBigInteger(JObject: JsonObject; KeyName: Text): BigInteger
    var
        JValue: JsonValue;
    begin
        if GetJsonValue(JObject, JValue, KeyName) then
            exit(JValue.AsBigInteger());
    end;

    /// <summary> 
    /// Get Value As Boolean.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure GetValueAsBoolean(JToken: JsonToken; KeyName: Text): Boolean
    var
        JValue: JsonValue;
    begin
        if JToken.IsObject then begin
            exit(GetValueAsBoolean(JToken.AsObject(), KeyName));
        end else
            if JToken.IsValue then begin
                JValue := JToken.AsValue();
                if not (JValue.IsNull or JValue.IsUndefined) then
                    exit(JValue.AsBoolean());
            end;
    end;

    /// <summary> 
    /// Get Value As Boolean.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure GetValueAsBoolean(JObject: JsonObject; KeyName: Text): Boolean
    var
        JValue: JsonValue;
    begin
        if GetJsonValue(JObject, JValue, KeyName) then
            exit(JValue.AsBoolean());
    end;

    /// <summary> 
    /// Get Value As Byte.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Byte.</returns>
    procedure GetValueAsByte(JToken: JsonToken; KeyName: Text): Byte
    var
        JValue: JsonValue;
    begin
        if JToken.IsObject then begin
            exit(GetValueAsByte(JToken.AsObject(), KeyName));
        end else
            if JToken.IsValue then begin
                JValue := JToken.AsValue();
                if not (JValue.IsNull or JValue.IsUndefined) then
                    exit(JValue.AsByte());
            end;
    end;

    /// <summary> 
    /// Get Value As Byte.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Byte.</returns>
    procedure GetValueAsByte(JObject: JsonObject; KeyName: Text): Byte
    var
        JValue: JsonValue;
    begin
        if GetJsonValue(JObject, JValue, KeyName) then
            exit(JValue.AsByte());
    end;

    /// <summary> 
    /// Get Value As Char.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Char.</returns>
    procedure GetValueAsChar(JToken: JsonToken; KeyName: Text): Char
    var
        JValue: JsonValue;
    begin
        if JToken.IsObject then begin
            exit(GetValueAsChar(JToken.AsObject(), KeyName));
        end else
            if JToken.IsValue then begin
                JValue := JToken.AsValue();
                if not (JValue.IsNull or JValue.IsUndefined) then
                    exit(JValue.AsChar());
            end;
    end;

    /// <summary> 
    /// Get Value As Char.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Char.</returns>
    procedure GetValueAsChar(JObject: JsonObject; KeyName: Text): Char
    var
        JValue: JsonValue;
    begin
        if GetJsonValue(JObject, JValue, KeyName) then
            exit(JValue.AsChar());
    end;

    /// <summary> 
    /// Get Value As Code.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetValueAsCode(JToken: JsonToken; KeyName: Text): Text
    var
        JValue: JsonValue;
    begin
        if JToken.IsObject then begin
            exit(GetValueAsCode(JToken.AsObject(), KeyName));
        end else
            if JToken.IsValue then begin
                JValue := JToken.AsValue();
                if not (JValue.IsNull or JValue.IsUndefined) then
                    exit(JValue.AsCode());
            end;
    end;

    /// <summary> 
    /// Get Value As Code.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetValueAsCode(JObject: JsonObject; KeyName: Text): Text
    var
        JValue: JsonValue;
    begin
        if GetJsonValue(JObject, JValue, KeyName) then
            exit(JValue.AsCode());
    end;

    /// <summary> 
    /// Get Value As Code.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <param name="MaxLength">Parameter of type Integer.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetValueAsCode(JToken: JsonToken; KeyName: Text; MaxLength: Integer): Text
    var
        JValue: JsonValue;
    begin
        if JToken.IsObject then begin
            exit(GetValueAsCode(JToken.AsObject(), KeyName, MaxLength));
        end else
            if JToken.IsValue then
                exit(CopyStr(JToken.AsValue().AsCode(), 1, MaxLength));
    end;

    /// <summary> 
    /// Get Value As Code.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <param name="MaxLength">Parameter of type Integer.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetValueAsCode(JObject: JsonObject; KeyName: Text; MaxLength: Integer): Text
    var
        JValue: JsonValue;
    begin
        exit(CopyStr(GetValueAsCode(JObject, KeyName), 1, MaxLength));
    end;

    /// <summary> 
    /// Get Value As Date.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Date.</returns>
    procedure GetValueAsDate(JToken: JsonToken; KeyName: Text): Date
    var
        JValue: JsonValue;
    begin
        if JToken.IsObject then begin
            exit(GetValueAsDate(JToken.AsObject(), KeyName));
        end else
            if JToken.IsValue then begin
                JValue := JToken.AsValue();
                if not (JValue.IsNull or JValue.IsUndefined) then
                    exit(JValue.AsDate());
            end;
    end;

    /// <summary> 
    /// Get Value As Date.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Date.</returns>
    procedure GetValueAsDate(JObject: JsonObject; KeyName: Text): Date
    var
        JValue: JsonValue;
    begin
        if GetJsonValue(JObject, JValue, KeyName) then
            exit(JValue.AsDate());
    end;

    /// <summary> 
    /// Get Value As DateTime.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type DateTime.</returns>
    procedure GetValueAsDateTime(JToken: JsonToken; KeyName: Text): DateTime
    var
        JValue: JsonValue;
    begin
        if JToken.IsObject then begin
            exit(GetValueAsDateTime(JToken.AsObject(), KeyName));
        end else
            if JToken.IsValue then begin
                JValue := JToken.AsValue();
                if not (JValue.IsNull or JValue.IsUndefined) then
                    exit(JValue.AsDateTime());
            end;
    end;

    /// <summary> 
    /// Get Value As DateTime.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type DateTime.</returns>
    procedure GetValueAsDateTime(JObject: JsonObject; KeyName: Text): DateTime
    var
        JValue: JsonValue;
    begin
        if GetJsonValue(JObject, JValue, KeyName) then
            exit(JValue.AsDateTime());
    end;

    /// <summary> 
    /// Get Value As Decimal.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetValueAsDecimal(JToken: JsonToken; KeyName: Text): Decimal
    var
        JValue: JsonValue;
    begin
        if JToken.IsObject then begin
            exit(GetValueAsDecimal(JToken.AsObject(), KeyName));
        end else
            if JToken.IsValue then begin
                JValue := JToken.AsValue();
                if not (JValue.IsNull or JValue.IsUndefined) then
                    exit(JValue.AsDecimal());
            end;
    end;

    /// <summary> 
    /// Get Value As Decimal.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetValueAsDecimal(JObject: JsonObject; KeyName: Text): Decimal
    var
        JValue: JsonValue;
    begin
        if GetJsonValue(JObject, JValue, KeyName) then
            exit(JValue.AsDecimal());
    end;

    /// <summary> 
    /// Get Value As Duration.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Duration.</returns>
    procedure GetValueAsDuration(JToken: JsonToken; KeyName: Text): Duration
    var
        JValue: JsonValue;
    begin
        if JToken.IsObject then begin
            exit(GetValueAsDuration(JToken.AsObject(), KeyName));
        end else
            if JToken.IsValue then begin
                JValue := JToken.AsValue();
                if not (JValue.IsNull or JValue.IsUndefined) then
                    exit(JValue.AsDuration());
            end;
    end;

    /// <summary> 
    /// Get Value As Duration.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Duration.</returns>
    procedure GetValueAsDuration(JObject: JsonObject; KeyName: Text): Duration
    var
        JValue: JsonValue;
    begin
        if GetJsonValue(JObject, JValue, KeyName) then
            exit(JValue.AsDuration());
    end;

    /// <summary> 
    /// Get Value As Integer.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure GetValueAsInteger(JToken: JsonToken; KeyName: Text): Integer
    var
        JValue: JsonValue;
    begin
        if JToken.IsObject then begin
            exit(GetValueAsInteger(JToken.AsObject(), KeyName));
        end else
            if JToken.IsValue then begin
                JValue := JToken.AsValue();
                if not (JValue.IsNull or JValue.IsUndefined) then
                    exit(JValue.AsInteger());
            end;
    end;

    /// <summary> 
    /// Get Value As Integer.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure GetValueAsInteger(JObject: JsonObject; KeyName: Text): Integer
    var
        JValue: JsonValue;
    begin
        if GetJsonValue(JObject, JValue, KeyName) then
            exit(JValue.AsInteger());
    end;

    /// <summary> 
    /// Get Value As Option.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Option.</returns>
    procedure GetValueAsOption(JToken: JsonToken; KeyName: Text): Option
    var
        JValue: JsonValue;
    begin
        if JToken.IsObject then begin
            exit(GetValueAsOption(JToken.AsObject(), KeyName));
        end else
            if JToken.IsValue then begin
                JValue := JToken.AsValue();
                if not (JValue.IsNull or JValue.IsUndefined) then
                    exit(JValue.AsOption());
            end;
    end;

    /// <summary> 
    /// Get Value As Option.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Option.</returns>
    procedure GetValueAsOption(JObject: JsonObject; KeyName: Text): Option
    var
        JValue: JsonValue;
    begin
        if GetJsonValue(JObject, JValue, KeyName) then
            exit(JValue.AsOption());
    end;

    /// <summary> 
    /// Get Value As Text.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetValueAsText(JToken: JsonToken; KeyName: Text): Text
    var
        JValue: JsonValue;
    begin
        if JToken.IsObject then begin
            exit(GetValueAsText(JToken.AsObject(), KeyName));
        end else
            if JToken.IsValue then begin
                JValue := JToken.AsValue();
                if not (JValue.IsNull or JValue.IsUndefined) then
                    exit(JValue.AsText);
            end;
    end;

    /// <summary> 
    /// Description for GetArrayAsText.
    /// </summary>
    /// <param name="JArray">Parameter of type JsonArray.</param>
    /// <returns>Return variable "Text".</returns>
    procedure GetArrayAsText(JArray: JsonArray): Text
    var
        Value: Text;
        Builder: TextBuilder;
        JToken: JsonToken;
    begin
        foreach JToken in JArray do begin
            if JToken.IsValue then begin
                Value := JToken.AsValue().AsText();
                if Value.Contains(',') then begin
                    Builder.Append(', "');
                    Builder.Append(Value);
                    Builder.Append('"');
                end else begin
                    Builder.Append(', ');
                    Builder.Append(Value);
                end;
            end else begin
                Builder.Append(', ');
                Builder.Append(Format(JToken));
            end;
        end;
        if Builder.Length > 2 then
            exit(Builder.ToText().Remove(1, 2));
    end;

    /// <summary> 
    /// Description for GetArrayAsText.
    /// </summary>
    /// <param name="JArray">Parameter of type JsonArray.</param>
    /// <param name="MaxLength">Parameter of type Integer.</param>
    /// <returns>Return variable "Text".</returns>
    procedure GetArrayAsText(JArray: JsonArray; MaxLength: Integer): Text
    begin
        exit(GetArrayAsText(JArray).Substring(0, MaxLength));
    end;

    /// <summary> 
    /// Description for GetArrayAsText.
    /// </summary>
    /// <param name="JObject">Parameter of type JSonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return variable "Text".</returns>
    procedure GetArrayAsText(JObject: JSonObject; KeyName: Text): Text
    var
        JArray: JsonArray;
    begin
        if GetJsonArray(JObject, JArray, KeyName) then begin
            exit(GetArrayAsText(JArray));
        end;
    end;

    /// <summary> 
    /// Description for GetArrayAsText.
    /// </summary>
    /// <param name="JObject">Parameter of type JSonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <param name="MaxLength">Parameter of type Integer.</param>
    /// <returns>Return variable "Text".</returns>
    procedure GetArrayAsText(JObject: JSonObject; KeyName: Text; MaxLength: Integer): Text
    begin
        exit(CopyStr(GetArrayAsText(JObject, KeyName), 1, MaxLength));
    end;

    /// <summary> 
    /// Description for GetArrayAsText.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return variable "Text".</returns>
    procedure GetArrayAsText(JToken: JsonToken; KeyName: Text): Text
    var
        JArray: JsonArray;
    begin
        if GetJsonArray(JToken, JArray, KeyName) then begin
            exit(GetArrayAsText(JArray));
        end;
    end;

    /// <summary> 
    /// Description for GetArrayAsText.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <param name="MaxLength">Parameter of type Integer.</param>
    /// <returns>Return variable "Text".</returns>
    procedure GetArrayAsText(JToken: JsonToken; KeyName: Text; MaxLength: Integer): Text
    begin
        exit(CopyStr(GetArrayAsText(JToken, KeyName), 1, MaxLength));
    end;

    /// <summary> 
    /// Get Value As Text.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetValueAsText(JObject: JsonObject; KeyName: Text): Text
    var
        JValue: JsonValue;
    begin
        if GetJsonValue(JObject, JValue, KeyName) then
            exit(JValue.AsText());
    end;

    /// <summary> 
    /// Get Value As Text.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <param name="MaxLength">Parameter of type Integer.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetValueAsText(JToken: JsonToken; KeyName: Text; MaxLength: Integer): Text
    var
        JValue: JsonValue;
    begin
        exit(CopyStr(GetValueAsText(JToken, KeyName), 1, MaxLength));
    end;

    /// <summary> 
    /// Get Value As Text.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <param name="MaxLength">Parameter of type Integer.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetValueAsText(JObject: JsonObject; KeyName: Text; MaxLength: Integer): Text
    begin
        exit(CopyStr(GetValueAsText(JObject, KeyName), 1, MaxLength));
    end;

    /// <summary> 
    /// Get Value As Time.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Time.</returns>
    procedure GetValueAsTime(JToken: JsonToken; KeyName: Text): Time
    var
        JValue: JsonValue;
    begin
        if JToken.IsObject then begin
            exit(GetValueAsTime(JToken.AsObject(), KeyName));
        end else
            if JToken.IsValue then begin
                JValue := JToken.AsValue();
                if not (JValue.IsNull or JValue.IsUndefined) then
                    exit(JValue.AsTime());
            end;
    end;

    /// <summary> 
    /// Get Value As Time.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return value of type Time.</returns>
    procedure GetValueAsTime(JObject: JsonObject; KeyName: Text): Time
    var
        JValue: JsonValue;
    begin
        if GetJsonValue(JObject, JValue, KeyName) then
            exit(JValue.AsTime());
    end;

    procedure IsBase64String(Data: Text): Boolean
    var
        RegEx: Codeunit Regex;
    begin
        exit(RegEx.IsMatch(Data, '^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)?$'));
    end;


    /// <summary> 
    /// Get Value Into Field.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <param name="RecRef">Parameter of type RecordRef.</param>
    /// <param name="FieldNo">Parameter of type Integer.</param>
    procedure GetValueIntoField(JToken: JsonToken; KeyName: Text; var RecRef: RecordRef; FieldNo: Integer)
    var
        TempBlob: Codeunit "Temp Blob";
        Field: FieldRef;
        FieldType: FieldType;
        NotImplemented: Label 'No implementation for fieldtype: "%1".';
        Stream: OutStream;
        Base64Convert: Codeunit "Base64 Convert";
        Data: Text;
    begin

        Field := RecRef.Field(FieldNo);
        case Field.Type of
            FieldType::BigInteger:
                Field.Value := GetValueAsBigInteger(JToken, KeyName);
            FieldType::Blob:
                begin
                    Data := GetValueAsText(JToken, KeyName);
                    if IsBase64String(Data) then begin
                        TempBlob.CreateOutStream(Stream);
                        Data := Base64Convert.FromBase64(Data);
                        Stream.Write(Data);
                    end else begin
                        TempBlob.CreateOutStream(Stream, TextEncoding::UTF8);
                        Stream.WriteText(Data);
                    end;
                    TempBlob.ToRecordRef(RecRef, FieldNo);
                end;
            FieldType::Boolean:
                Field.Value := GetValueAsBoolean(JToken, KeyName);
            FieldType::Code,
            FieldType::Text:
                Field.Value := GetValueAsText(JToken, KeyName, Field.Length);
            FieldType::Date:
                Field.Value := GetValueAsDate(JToken, KeyName);
            FieldType::DateTime:
                Field.Value := GetValueAsDateTime(JToken, KeyName);
            FieldType::Decimal:
                Field.Value := GetValueAsDecimal(JToken, KeyName);
            FieldType::Duration:
                Field.Value := GetValueAsDuration(JToken, KeyName);
            FieldType::Guid:
                Field.Value := GetValueAsText(JToken, KeyName);
            FieldType::Integer:
                Field.Value := GetValueAsInteger(JToken, KeyName);
            FieldType::Option:
                Field.Value := GetValueAsOption(JToken, KeyName);
            FieldType::Time:
                Field.Value := GetValueAsTime(JToken, KeyName);
            else
                Error(NotImplemented, Field.Type);
        end;
    end;

    /// <summary> 
    /// Get Value Into Field With Validation.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <param name="RecRef">Parameter of type RecordRef.</param>
    /// <param name="FieldNo">Parameter of type Integer.</param>
    procedure GetValueIntoFieldWithValidation(JToken: JsonToken; KeyName: Text; var RecRef: RecordRef; FieldNo: Integer)
    var
        TempBlob: Codeunit "Temp Blob";
        Field: FieldRef;
        FieldType: FieldType;
        NotImplemented: Label 'No implementation for fieldtype: "%1".';
        Stream: OutStream;
    begin

        Field := RecRef.Field(FieldNo);
        case Field.Type of
            FieldType::BigInteger:
                Field.Validate(GetValueAsBigInteger(JToken, KeyName));
            FieldType::Blob:
                begin
                    TempBlob.CreateOutStream(Stream);
                    Stream.Write(GetValueAsText(JToken, KeyName));
                    TempBlob.ToRecordRef(RecRef, FieldNo);
                end;
            FieldType::Boolean:
                Field.Validate(GetValueAsBoolean(JToken, KeyName));
            FieldType::Code,
            FieldType::Text:
                Field.Validate(GetValueAsText(JToken, KeyName, Field.Length));
            FieldType::Date:
                Field.Validate(GetValueAsDate(JToken, KeyName));
            FieldType::DateTime:
                Field.Validate(GetValueAsDateTime(JToken, KeyName));
            FieldType::Decimal:
                Field.Validate(GetValueAsDecimal(JToken, KeyName));
            FieldType::Duration:
                Field.Validate(GetValueAsDuration(JToken, KeyName));
            FieldType::Guid:
                Field.Validate(GetValueAsText(JToken, KeyName));
            FieldType::Integer:
                Field.Validate(GetValueAsInteger(JToken, KeyName));
            FieldType::Option:
                Field.Validate(GetValueAsOption(JToken, KeyName));
            FieldType::Time:
                Field.Validate(GetValueAsTime(JToken, KeyName));
            else
                Error(NotImplemented, Field.Type);
        end;
    end;

    /// <summary> 
    /// Get Value Into Field.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <param name="RecRef">Parameter of type RecordRef.</param>
    /// <param name="FieldNo">Parameter of type Integer.</param>
    procedure GetValueIntoField(JObject: JsonObject; KeyName: Text; var RecRef: RecordRef; FieldNo: Integer)
    begin
        GetValueIntoField(JObject.AsToken(), KeyName, RecRef, FieldNo);
    end;

    /// <summary> 
    /// Description for GetValueIntoFieldWithValidation.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <param name="RecRef">Parameter of type RecordRef.</param>
    /// <param name="FieldNo">Parameter of type Integer.</param>
    procedure GetValueIntoFieldWithValidation(JObject: JsonObject; KeyName: Text; var RecRef: RecordRef; FieldNo: Integer)
    begin
        GetValueIntoFieldWithValidation(JObject.AsToken(), KeyName, RecRef, FieldNo);
    end;

    /// <summary> 
    /// Description for ContainsToken.
    /// </summary>
    /// <param name="JToken">Parameter of type JsonToken.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return variable "Boolean".</returns>
    procedure ContainsToken(JToken: JsonToken; KeyName: Text): Boolean
    var
        KeyNames: List of [Text];
    begin
        KeyNames := KeyName.Split('.');
        foreach KeyName in KeyNames do begin
            if JToken.AsObject().Get(KeyName, JToken) then begin
                if KeyNames.IndexOf(KeyName) = KeyNames.Count then begin
                    exit(true);
                end;
            end;
        end;
    end;

    /// <summary> 
    /// Description for ContainsToken.
    /// </summary>
    /// <param name="JObject">Parameter of type JsonObject.</param>
    /// <param name="KeyName">Parameter of type Text.</param>
    /// <returns>Return variable "Boolean".</returns>
    procedure ContainsToken(JObject: JsonObject; KeyName: Text): Boolean
    begin
        exit(ContainsToken(JObject.AsToken(), KeyName));
    end;
}