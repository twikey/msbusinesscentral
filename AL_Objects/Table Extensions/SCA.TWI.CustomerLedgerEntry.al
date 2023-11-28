tableextension 71016578 "SCA.TWI.CustLedgerEntry" extends "Cust. Ledger Entry"
{
    fields
    {
        // field(71016575; "SCA.TWI.TwikeyContractTemplate"; Integer)
        // {
        //     Caption = 'Twikey Alt. Contract Template';
        //     DataClassification = CustomerContent;
        //     TableRelation = "SCA.TWI.TwikeyContractTemplate".Id;
        //     BlankZero = true;
        // }
        field(71016576; "SCA.TWI.TwikeyInvoiceStatus"; Text[50])
        {
            Caption = 'Twikey Invoice Status';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("SCA.TWI.CLETwikeyRegistration"."Invoice Status" where("Cust. Ledger Entry No." = field("Entry No.")));

        }
    }

    var
        myInt: Integer;
}