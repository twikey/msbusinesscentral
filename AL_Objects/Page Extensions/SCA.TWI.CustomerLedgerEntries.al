pageextension 71016581 "SCA.TWI.CustomerLedgerEntries" extends "Customer Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("SCA.TWI.TwikeyInvoiceStatus"; Rec."SCA.TWI.TwikeyInvoiceStatus")
            {
                ApplicationArea = All;
                Editable = false;

                trigger OnDrillDown()
                var
                    CLETwikeyRegistration: Record "SCA.TWI.CLETwikeyRegistration";
                begin
                    CLETwikeyRegistration.SetRange("Cust. Ledger Entry No.", Rec."Entry No.");
                    if CLETwikeyRegistration.FindFirst() then begin
                        if CLETwikeyRegistration."Invoice Payment URL" <> '' then begin
                            Hyperlink(CLETwikeyRegistration."Invoice Payment URL");
                        end;
                    end;
                end;

            }
        }
    }

    actions
    {
        addlast("F&unctions")
        {
            action("SCA.TWI.SendToTwikey")
            {
                Caption = 'Send to Twikey';
                ApplicationArea = All;
                Image = SendElectronicDocument;

                trigger OnAction()
                var
                    TwikeyMgt: Codeunit "SCA.TWI.TwikeyMgt";
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    CurrPage.SetSelectionFilter(CustLedgerEntry);
                    TwikeyMgt.SendCustLedgerEntriesToTwikeyConfirm(CustLedgerEntry, true);
                end;
            }
        }
    }


    var
        myInt: Integer;
}