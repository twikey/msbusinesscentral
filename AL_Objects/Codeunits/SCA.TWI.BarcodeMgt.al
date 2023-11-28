codeunit 71016578 "SCA.TWI.BarcodeMgt"
{
    procedure GenerateBarcode(var Barcode: Record "SCA.TWI.Barcode")
    begin
        DoGenerateBarcode(Barcode);
    end;

    local procedure DoGenerateBarcode(var Barcode: Record "SCA.TWI.Barcode")
    var
        Arguments: Record "SCA.TWI.RESTWebServiceArg" temporary;
    begin
        if Barcode.Type = Barcode.Type::" " then begin
            Clear(Barcode.Picture);
            exit;
        end;

        InitArguments(Arguments, Barcode);
        if not CallWebService(Arguments) then
            exit;

        SaveResult(Arguments, Barcode);

    end;

    local procedure InitArguments(var Arguments: Record "SCA.TWI.RESTWebServiceArg" temporary; Barcode: Record "SCA.TWI.Barcode")
    var
        BaseURL: Text;
        TypeHelper: Codeunit "Type Helper";
    begin
        BaseURL := 'https://barcode.tec-it.com';

        // if Barcode.Type = Barcode.Type::qr then
        //     Arguments.URL := StrSubstNo('%1/barcode/qr/qr.%2?value=%3&size=%4&ecclevel=%5',
        //                                 BaseURL,
        //                                 GetOptionStringValue(Barcode.Type, Barcode.FieldNo(Type)),
        //                                 TypeHelper.UrlEncode(Barcode.Value),
        //                                 GetOptionStringValue(Barcode.Size, Barcode.FieldNo(Size)),
        //                                 GetOptionStringValue(Barcode.ECCLevel, Barcode.FieldNo(ECCLevel)))
        // else
        //     Arguments.URL := StrSubstNo('%1/barcode/%2/%3.%4?istextdrawn=%5&isborderdrawn=%6&isreversecolor=%7',
        //                                 BaseURL,
        //                                 GetOptionStringValue(Barcode.Type, Barcode.FieldNo(Type)),
        //                                 TypeHelper.UrlEncode(Barcode.Value),
        //                                 GetOptionStringValue(Barcode.PictureType, Barcode.FieldNo(PictureType)),
        //                                 Format(Barcode.IncludeText, 0, 2),
        //                                 Format(Barcode.Border, 0, 2),
        //                                 Format(Barcode.ReverseColors, 0, 2));

        // Arguments.URL := StrSubstNo('%1/barcode.ashx?data=' + TypeHelper.UrlEncode(Barcode.Value) +
        // '&code=Code128&multiplebarcodes=false&translate-esc=false&unit=Fit&dpi=96&imagetype=Png',
        //                                         BaseURL);
        if Barcode.Type = Barcode.Type::qr then begin
            Arguments.URL := StrSubstNo('%1/barcode.ashx?data=%2&code=QRCode&multiplebarcodes=false&translate-esc=false&unit=Fit&dpi=96&imagetype=Png',
                                                            BaseURL,
                                                            TypeHelper.UrlEncode(Barcode.Value));
            // end else begin
            //     Arguments.URL := StrSubstNo('%1/barcode.ashx?data=%2&code=QRCode&multiplebarcodes=false&translate-esc=false&unit=Fit&dpi=96&imagetype=Png',
            //                                                     BaseURL,
            //                                                     TypeHelper.UrlEncode(Barcode.Value));
        end;

        Arguments.RestMethod := Arguments.RestMethod::get;
    end;

    local procedure CallWebService(var Arguments: Record "SCA.TWI.RESTWebServiceArg" temporary) Success: Boolean
    var
        RESTWebService: codeunit "SCA.TWI.BarcodeWebReq";
    begin
        Success := RESTWebService.CallRESTWebService(Arguments);
    end;

    local procedure SaveResult(var Arguments: Record "SCA.TWI.RESTWebServiceArg" temporary; var Barcode: Record "SCA.TWI.Barcode")
    var
        ResponseContent: HttpContent;
        InStr: InStream;
        // TempBlob: Record TempBlob temporary;
        TempBlob2: Codeunit "Temp Blob";
    begin
        Arguments.GetResponseContent(ResponseContent);
        TempBlob2.CreateInStream(InStr);
        //TempBlob.Blob.CreateInStream(InStr);
        ResponseContent.ReadAs(InStr);
        Clear(Barcode.Picture);
        Barcode.Picture.ImportStream(InStr, Barcode.Value);
    end;

    local procedure GetOptionStringValue(Value: Integer; fieldno: Integer): Text
    var
        FieldRec: Record Field;
    begin
        FieldRec.Get(Database::"SCA.TWI.Barcode", fieldno);
        exit(SelectStr(Value + 1, FieldRec.OptionString));
    end;

}
