pageextension 71016582 "SCA.TWI.PostedServiceInvoice" extends "Posted Service Invoice"
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