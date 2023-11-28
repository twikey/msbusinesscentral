codeunit 71016577 "SCA.TWI.TwikeyJobQueue"
{
    trigger OnRun()
    begin
        TwikeyMgt.MandateFeed();
        TwikeyMgt.InvoiceFeed();
        //TwikeyMgt.PaymentLinkFeed();
    end;

    var
        TwikeyMgt: Codeunit "SCA.TWI.TwikeyMgt";
}