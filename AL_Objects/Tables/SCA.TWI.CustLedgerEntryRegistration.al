table 71016584 "SCA.TWI.CLETwikeyRegistration"
{
    DataClassification = CustomerContent;
    Caption = 'Customer Ledger Entry Twikey Registration';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }

        field(2; "Cust. Ledger Entry Doc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Ledger Entry Document No.';
        }
        field(3; "Twikey Invoice Id"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Twikey Invoice Id';
        }
        field(4; "Invoice Status"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Status';
        }
        // field(5; "Payment Link URL"; Text[250])
        // {
        //     DataClassification = CustomerContent;
        //     Caption = 'Payment Link URL';
        // }
        // field(6; "Payment Link Id"; Integer)
        // {
        //     DataClassification = CustomerContent;
        //     Caption = 'Payment Link Id';
        // }
        // field(7; "Payment Status"; Text[50])
        // {
        //     DataClassification = CustomerContent;
        //     Caption = 'Payment Status';
        // }
        field(8; "Invoice Payment URL"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Payment URL';
        }
        field(9; "Cust. Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Ledger Entry No.';
        }

    }

    keys
    {
        key(Key1; "Entry No.")
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