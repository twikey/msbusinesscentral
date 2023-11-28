pageextension 71016579 "SCA.TWI.SalesOrder" extends "Sales Order"
{
    layout
    {
        addlast("Invoice Details")
        {
            field("SCA.TWI.TwikeyContractTemplate"; Rec."SCA.TWI.TwikeyContractTemplate")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}