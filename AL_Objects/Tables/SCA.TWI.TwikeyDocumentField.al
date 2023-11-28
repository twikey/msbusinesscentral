table 71016583 "SCA.TWI.TwikeyDocumentField"
{
    DataClassification = CustomerContent;
    Caption = 'Twikey Document Field';

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }

        field(5; "Contract Template"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Template';
            TableRelation = "SCA.TWI.TwikeyContractTemplate".Id;
            NotBlank = true;
        }
        field(6; "Field Name"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Field Name';
            NotBlank = true;
            TableRelation = "SCA.TWI.TwikeyContrTemplField"."Field Name" where(Id = field("Contract Template"));

        }
        field(7; "Field Value"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Field Value';
            NotBlank = true;
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Contract Template", "Field Name")
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