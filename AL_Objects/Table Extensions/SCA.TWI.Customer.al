tableextension 71016575 "SCA.TWI.Customer" extends "Customer"
{
    fields
    {
        field(71016575; "SCA.TWI.SendingProfile"; Option)
        {
            Caption = 'Twikey Enabled';
            OptionMembers = "Always","Optional","Disable";
            OptionCaption = 'Always,Optional,Disable';
            DataClassification = CustomerContent;
        }
        // field(71016576; "SCA.TWI.ShowNotification"; Boolean)
        // {
        //     Caption = 'Show Notification';
        //     DataClassification = CustomerContent;
        // }
        field(71016576; "SCA.TWI.DocumentId"; Code[50])
        {
            Caption = 'Twikey Document Id';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = max("SCA.TWI.TwikeyDocument"."Document Id" where("Customer No." = field("No.")));
        }
        field(71016577; "SCA.TWI.Status"; Text[50])
        {
            Caption = 'Twikey Document Status';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("SCA.TWI.TwikeyDocument".Status where("Document Id" = field("SCA.TWI.DocumentId")));
        }
    }

    var
        myInt: Integer;
}