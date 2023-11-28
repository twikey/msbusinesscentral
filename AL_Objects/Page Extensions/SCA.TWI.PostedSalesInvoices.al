pageextension 71016580 "SCA.TWI.PostedSalesInvoices" extends "Posted Sales Invoices"
{
    layout
    {
        addlast(Control1)
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
        addlast(processing)
        {
            action("SCA.TWI.SendSelectionToTwikey")
            {
                Caption = 'Send Selection to Twikey';
                Image = SendElectronicDocument;
                ApplicationArea = All;

                trigger OnAction()
                var
                    Label1: Label 'Do you want to send the selected sales invoices to Twikey?';
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    TwikeyMgt: Codeunit "SCA.TWI.TwikeyMgt";
                begin
                    if not Confirm(Label1) then exit;

                    CurrPage.SetSelectionFilter(SalesInvoiceHeader);
                    TwikeyMgt.SendPostedSalesInvoicesToTwikey(SalesInvoiceHeader, true);
                end;
            }
        }
    }

    var
        myInt: Integer;
}