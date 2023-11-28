pageextension 71016578 "SCA.TWI.SalesInvoice" extends "Sales Invoice"
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