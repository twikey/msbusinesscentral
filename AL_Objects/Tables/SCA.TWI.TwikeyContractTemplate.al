table 71016579 "SCA.TWI.TwikeyContractTemplate"
{
    DataClassification = CustomerContent;
    Caption = 'Twikey Contract Template';

    fields
    {
        field(1; "Id"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Id';
            NotBlank = true;
        }
        field(2; "Description"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(3; "Send Mail on Invite"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Send Mail on Invite';
        }
    }

    keys
    {
        key(Key1; "Id")
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