table 71016578 "SCA.TWI.TwikeyDocument"
{
    DataClassification = CustomerContent;
    Caption = 'Twikey Document';
    LookupPageId = "SCA.TWI.TwikeyDocuments";
    DrillDownPageId = "SCA.TWI.TwikeyDocuments";

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.';

        }
        field(2; "Document Id"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Document Id';
        }
        field(3; "Status"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
        field(4; "Cancel Reason"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Cancel Reason';
        }
        field(5; "Contract Template"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Template';
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Document Id")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}