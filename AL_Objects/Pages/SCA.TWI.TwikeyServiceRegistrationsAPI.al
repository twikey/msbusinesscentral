page 71016591 "SCA.TWI.TwikeyServRegistrAPI"
{
    PageType = API;
    EntityName = 'twikeyServiceRegistration';
    EntitySetName = 'twikeyServiceRegistrations';
    APIGroup = 'twikey';
    APIPublisher = 'twikey';
    APIVersion = 'v1.0';
    SourceTable = "SCA.TWI.TwikeyServiceRegistr";
    Caption = 'Twikey Service Registrations';
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
                field(postedServiceInvoiceNo; Rec."Posted Service Invoice No.")
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