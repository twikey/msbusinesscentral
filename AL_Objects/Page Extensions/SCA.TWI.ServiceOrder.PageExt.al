pageextension 71016584 "SCA.TWI.ServiceOrder" extends "Service Order"
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