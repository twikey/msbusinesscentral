page 71016588 "SCA.TWI.TwikeyRegistrationsAPI"
{
    PageType = API;
    EntityName = 'twikeyRegistration';
    EntitySetName = 'twikeyRegistrations';
    APIGroup = 'twikey';
    APIPublisher = 'twikey';
    APIVersion = 'v1.0';
    SourceTable = "SCA.TWI.TwikeyRegistration";
    Caption = 'Twikey Registrations';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(entryNo; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(postedSalesInvoiceNo; Rec."Posted Sales Invoice No.")
                {
                    ApplicationArea = All;
                }
                field(twikeyUniqueId; Rec."Twikey Invoice Id")
                {
                    ApplicationArea = All;
                }
                field(invoicePaymentURL; Rec."Invoice Payment URL")
                {
                    ApplicationArea = All;
                    ExtendedDatatype = URL;
                }
                field(invoiceStatus; Rec."Invoice Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }



    var
        TwikeyMgt: Codeunit "SCA.TWI.TwikeyMgt";

}