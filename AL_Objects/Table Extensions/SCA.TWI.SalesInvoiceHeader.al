tableextension 71016577 "SCA.TWI.SalesInvoiceHeader" extends "Sales Invoice Header"
{
    fields
    {
        field(71016575; "SCA.TWI.TwikeyContractTemplate"; Integer)
        {
            Caption = 'Twikey Alt. Contract Template';
            DataClassification = CustomerContent;
            TableRelation = "SCA.TWI.TwikeyContractTemplate".Id;
            BlankZero = true;
        }
        field(71016576; "SCA.TWI.TwikeyInvoiceStatus"; Text[50])
        {
            Caption = 'Twikey Invoice Status';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("SCA.TWI.TwikeyRegistration"."Invoice Status" where("Posted Sales Invoice No." = field("No.")));

        }
    }

    var
        myInt: Integer;
}