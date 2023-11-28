table 71016575 "SCA.TWI.TwikeyLogEntry"
{
    Caption = 'Twikey Log Entry';
    DataClassification = SystemMetadata;
    DrillDownPageID = "SCA.TWI.TwikeyLogEntry";
    LookupPageID = "SCA.TWI.TwikeyLogEntries";

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }
        field(2; "Date and Time"; DateTime)
        {
            Caption = 'Date and Time';
            DataClassification = SystemMetadata;
        }
        field(3; "Time"; Time)
        {
            Caption = 'Time';
            DataClassification = SystemMetadata;
        }
        field(4; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            NotBlank = true;
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("User ID");
            end;
        }
        field(6; Request; BLOB)
        {
            Caption = 'Request';
            DataClassification = SystemMetadata;
        }
        field(7; Response; BLOB)
        {
            Caption = 'Response';
            DataClassification = SystemMetadata;
        }
        field(8; "Status Code"; Code[10])
        {
            Caption = 'Status Code';
            DataClassification = SystemMetadata;
        }
        field(9; "Status Description"; Text[500])
        {
            Caption = 'Status Description';
            DataClassification = SystemMetadata;
        }
        field(10; URL; Text[500])
        {
            Caption = 'URL';
            DataClassification = SystemMetadata;
            ExtendedDatatype = URL;
        }
        field(11; Method; Text[30])
        {
            Caption = 'Method';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label 'Are you sure that you want to delete the log entries?';

    /// <summary> 
    /// Delete Entries.
    /// </summary>
    /// <param name="DaysOld">Parameter of type Integer.</param>
    procedure DeleteEntries(DaysOld: Integer);
    begin
        if not Confirm(Text000) then begin
            exit;
        end;

        if DaysOld > 0 then begin
            SetFilter("Date and Time", '<=%1', CreateDateTime(Today - DaysOld, Time));
            if not IsEmpty then
                DeleteAll(false);
            SetRange("Date and Time");
        end else begin
            if not IsEmpty then
                DeleteAll(false);
        end;
    end;

    /// <summary> 
    /// Get Request.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetRequest(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields(Request);
        Request.CreateInStream(InStream, TextEncoding::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    /// <summary> 
    /// Get Response.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetResponse(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields(Response);
        Response.CreateInStream(InStream, TextEncoding::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    /// <summary> 
    /// Set Request.
    /// </summary>
    /// <param name="Data">Parameter of type Text.</param>
    procedure SetRequest(Data: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Request);
        Request.CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(Data);
        if Modify then;
    end;

    /// <summary> 
    /// Set Response.
    /// </summary>
    /// <param name="Data">Parameter of type Text.</param>
    procedure SetResponse(Data: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Response);
        Response.CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(Data);
        if Modify then;
    end;
}

