tableextension 71016576 "SCA.TWI.SalesHeader" extends "Sales Header"
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
    }

    var
        myInt: Integer;
}