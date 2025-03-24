tableextension 71016579 "SCA.TWI.ServiceHeader" extends "Service Header"
{
    fields
    {
        field(58201; "SCA.TWI.TwikeyContractTemplate"; Integer)
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