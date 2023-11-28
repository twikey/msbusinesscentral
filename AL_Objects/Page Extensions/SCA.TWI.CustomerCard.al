pageextension 71016575 "SCA.TWI.CustomerCard" extends "Customer Card"
{
    layout
    {
        addlast(Payments)
        {
            field("SCA.TWI.SendingProfile"; Rec."SCA.TWI.SendingProfile")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action("SCA.TWI.InviteCustomer")
            {
                ApplicationArea = All;
                Caption = 'Invite Customer via Twikey';
                Image = Interaction;

                trigger OnAction()
                var
                    TwikeyMgt: Codeunit "SCA.TWI.TwikeyMgt";
                    Customer: Record Customer;
                begin
                    Customer.Get(Rec."No.");
                    Customer.SetRecFilter();
                    TwikeyMgt.InviteCustomers(Customer);
                end;
            }
        }
        addlast("&Customer")
        {
            action("SCA.TWI.TwikeyDocuments")
            {
                ApplicationArea = All;
                Caption = 'Twikey Documents';
                Image = ContractPayment;
                RunObject = page "SCA.TWI.TwikeyDocuments";
                RunPageLink = "Customer No." = field("No.");
            }
            action("SCA.TWI.TwikeyDocumentFields")
            {
                ApplicationArea = All;
                Caption = 'Twikey Document Fields';
                Image = SelectField;
                RunObject = page "SCA.TWI.TwikeyDocumentFields";
                RunPageLink = "Customer No." = field("No.");
            }

        }
    }

    var
}