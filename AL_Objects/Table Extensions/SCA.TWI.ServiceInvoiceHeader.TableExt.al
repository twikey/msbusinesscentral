tableextension 71016580 "SCA.TWI.ServiceInvoiceHeader" extends "Service Invoice Header"
{
    fields
    {
        field(58200; "SCA.TWI.TwikeyContractTemplate"; Integer)
        {
            Caption = 'Twikey Alt. Contract Template';
            DataClassification = CustomerContent;
            TableRelation = "SCA.TWI.TwikeyContractTemplate".Id;
            BlankZero = true;
        }
        field(58201; "SCA.TWI.TwikeyInvoiceStatus"; Text[50])
        {
            Caption = 'Twikey Invoice Status';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("SCA.TWI.TwikeyServiceRegistr"."Invoice Status" where("Posted Service Invoice No." = field("No.")));

        }
    }

    var
        myInt: Integer;
}