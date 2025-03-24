report 71016575 "SCA.TWI.SendSalesInvoices"
{
    Caption = 'Send Posted Sales Invoices to Twikey';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.", "Bill-to Customer No.", "Payment Method Code", "SCA.TWI.TwikeyContractTemplate", "SCA.TWI.TwikeyInvoiceStatus";

            trigger OnPostDataItem()
            var
                TwikeyMgt: Codeunit "SCA.TWI.TwikeyMgt";
            begin
                TwikeyMgt.SendPostedSalesInvoicesToTwikey("Sales Invoice Header", false);
            end;
        }
    }
}