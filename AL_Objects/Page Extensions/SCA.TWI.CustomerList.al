pageextension 71016576 "SCA.TWI.CustomerList" extends "Customer List"
{
    layout
    {
        addlast(Control1)
        {
            field("SCA.TWI.DocumentId"; Rec."SCA.TWI.DocumentId")
            {
                ApplicationArea = All;
            }
            field("SCA.TWI.Status"; Rec."SCA.TWI.Status")
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
                Caption = 'Invite Selected Customers via Twikey';
                Image = Interaction;


                trigger OnAction()
                var
                    TwikeyMgt: Codeunit "SCA.TWI.TwikeyMgt";
                    Customer: Record Customer;
                begin
                    CurrPage.SetSelectionFilter(Customer);
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