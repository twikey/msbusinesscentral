report 71016576 "SCA.TWI.SendServiceInvoices"
{
    Caption = 'Send Posted Service Invoices to Twikey';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Service Invoice Header"; "Service Invoice Header")
        {
            RequestFilterFields = "No.", "Bill-to Customer No.", "Payment Method Code", "SCA.TWI.TwikeyContractTemplate", "SCA.TWI.TwikeyInvoiceStatus";

            trigger OnPostDataItem()
            var
                TwikeyMgt: Codeunit "SCA.TWI.TwikeyMgt";
            begin
                TwikeyMgt.SendPostedServiceInvoicesToTwikey("Service Invoice Header", false);
            end;
        }
    }
}