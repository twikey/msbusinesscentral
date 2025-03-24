pageextension 71016583 "SCA.TWI.ServiceInvoice" extends "Service Invoice"
{
    layout
    {
        addlast(Invoicing)
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