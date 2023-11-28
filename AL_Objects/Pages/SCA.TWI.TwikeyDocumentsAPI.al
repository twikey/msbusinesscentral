page 71016587 "SCA.TWI.TwikeyDocumentsAPI"
{
    PageType = API;
    EntitySetName = 'twikeyDocuments';
    EntityName = 'twikeyDocument';
    APIGroup = 'twikey';
    APIPublisher = 'twikey';
    APIVersion = 'v1.0';
    SourceTable = "SCA.TWI.TwikeyDocument";
    Caption = 'Twikey Documents';
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(customerNo; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(contractId; Rec."Document Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(cancelReason; Rec."Cancel Reason")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Cancel)
            {
                Caption = 'Cancel';
                Image = Cancel;
                ApplicationArea = all;

                trigger OnAction()
                var
                    TwikeyMgt: Codeunit "SCA.TWI.TwikeyMgt";
                begin
                    TwikeyMgt.CancelContract(Rec);
                end;
            }
            action(Suspend)
            {
                Caption = 'Suspend';
                Image = DisableBreakpoint;
                ApplicationArea = all;

                trigger OnAction()
                var
                    TwikeyMgt: Codeunit "SCA.TWI.TwikeyMgt";
                begin
                    TwikeyMgt.SuspendDocument(Rec);
                end;
            }
            action(Reactivate)
            {
                Caption = 'Reactivate';
                Image = EnableBreakpoint;
                ApplicationArea = all;

                trigger OnAction()
                var
                    TwikeyMgt: Codeunit "SCA.TWI.TwikeyMgt";
                begin
                    TwikeyMgt.ReactivateDocument(Rec);
                end;
            }

        }
    }


    var
        myInt: Integer;
}