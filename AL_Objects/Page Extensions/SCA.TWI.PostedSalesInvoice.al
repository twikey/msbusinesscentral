pageextension 71016577 "SCA.TWI.PostedSalesInvoice" extends "Posted Sales Invoice"
{
    layout
    {
        addlast("Invoice Details")
        {
            field("SCA.TWI.TwikeyInvoiceStatus"; Rec."SCA.TWI.TwikeyInvoiceStatus")
            {
                ApplicationArea = All;

                trigger OnDrillDown()
                var
                    TwikeyRegistration: Record "SCA.TWI.TwikeyRegistration";
                begin
                    TwikeyRegistration.SetRange("Posted Sales Invoice No.", Rec."No.");
                    if TwikeyRegistration.FindFirst() then begin
                        if TwikeyRegistration."Invoice Payment URL" <> '' then begin
                            Hyperlink(TwikeyRegistration."Invoice Payment URL");
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
                begin
                    TwikeyMgt.SendPostedSalesInvoiceToTwikey(Rec, true);
                end;
            }
        }
    }

    var
        myInt: Integer;
}