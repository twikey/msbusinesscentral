table 71016582 "SCA.TWI.TwikeyContrTemplField"
{
    DataClassification = CustomerContent;
    Caption = 'Twikey Contract Template Field';

    fields
    {
        field(1; "Id"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Id';
            NotBlank = true;
        }
        field(2; "Field Name"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Field Name';
            NotBlank = true;
        }
        field(3; "Mandatory"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Mandatory';
        }
    }

    keys
    {
        key(Key1; "Id", "Field Name")
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