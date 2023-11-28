page 71016589 "SCA.TWI.CLETwikeyRegAPI"
{
    PageType = API;
    EntityName = 'twikeyRegistrationCLE';
    EntitySetName = 'twikeyRegistrationsCLE';
    APIGroup = 'twikey';
    APIPublisher = 'twikey';
    APIVersion = 'v1.0';
    SourceTable = "SCA.TWI.CLETwikeyRegistration";
    Caption = 'Customer Ledger Entry Twikey Registrations';
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
                field(custLedgerEntryDocNo; Rec."Cust. Ledger Entry Doc. No.")
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
                field(custLedgerEntryNo; Rec."Cust. Ledger Entry No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }


    var
        TwikeyMgt: Codeunit "SCA.TWI.TwikeyMgt";

}