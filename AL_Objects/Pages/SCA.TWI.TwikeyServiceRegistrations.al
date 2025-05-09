page 71016590 "SCA.TWI.TwikeyServiceRegistr"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SCA.TWI.TwikeyServiceRegistr";
    Caption = 'Twikey Service Registrations';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Posted Service Invoice No."; Rec."Posted Service Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Twikey Unique Id"; Rec."Twikey Invoice Id")
                {
                    ApplicationArea = All;
                }
                field("Invoice Payment URL"; Rec."Invoice Payment URL")
                {
                    ApplicationArea = All;
                    ExtendedDatatype = URL;
                }
                field("Invoice Status"; Rec."Invoice Status")
                {
                    ApplicationArea = All;
                }
                // field("Payment Link Id"; Rec."Payment Link Id")
                // {
                //     ApplicationArea = All;
                //     BlankZero = true;
                //     Visible = false;
                // }
                // field("Payment Link URL"; Rec."Payment Link URL")
                // {
                //     ApplicationArea = All;
                //     Visible = false;
                // }
                // field("Payment Status"; Rec."Payment Status")
                // {
                //     ApplicationArea = All;
                //     Visible = false;
                // }
            }
        }
    }

    // actions
    // {
    //     area(Processing)
    //     {
    //         action(InviteCustomer)
    //         {
    //             ApplicationArea = All;

    //             trigger OnAction()
    //             var
    //                 Customer: Record Customer;
    //             begin
    //                 Customer.FindFirst();
    //                 TwikeyMgt.InviteCustomer(Customer);
    //             end;
    //         }

    //         action(CreateInvoice)
    //         {
    //             ApplicationArea = All;

    //             trigger OnAction()
    //             var
    //                 SalesInvoiceHeader: Record "Sales Invoice Header";
    //             begin
    //                 SalesInvoiceHeader.FindFirst();
    //                 TwikeyMgt.CreateInvoice(SalesInvoiceHeader);
    //             end;
    //         }
    //         action(CreatePaymentLink)
    //         {
    //             ApplicationArea = All;

    //             trigger OnAction()
    //             var
    //                 SalesInvoiceHeader: Record "Sales Invoice Header";
    //             begin
    //                 SalesInvoiceHeader.FindFirst();
    //                 TwikeyMgt.CreatePaymentLinkForInvoice(SalesInvoiceHeader);
    //             end;
    //         }
    //         action(InvoiceFeed)
    //         {
    //             ApplicationArea = All;

    //             trigger OnAction()
    //             var
    //             begin
    //                 TwikeyMgt.InvoiceFeed();
    //             end;
    //         }
    //         action(PaymentLinkFeed)
    //         {
    //             ApplicationArea = All;

    //             trigger OnAction()
    //             var
    //             begin
    //                 TwikeyMgt.PaymentLinkFeed();
    //             end;
    //         }
    //     }
    // }

    var
        TwikeyMgt: Codeunit "SCA.TWI.TwikeyMgt";

}